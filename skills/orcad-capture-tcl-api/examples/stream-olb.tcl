# stream-olb.tcl — headless：把一个 .olb 的封装/器件/管脚流成 JSON（预览器/索引器的输入）
#
#   tclsh stream-olb.tcl <dbo-dll> <in.olb> <out.json> ?maxPackages?
#
# 输出结构（字段名对齐宿主官方 streamer 的习惯：id/type/layer/visible 用小写、
# 数值不带单位、类型用**名字**而不是数字）：
#   {"library":"<path>","packages":[{"name":..,"footprint":..,"refDes":..,
#      "parts":[{"name":..,"pinNamesVisible":0/1,"pins":[
#         {"number":"1","name":"VIN","type":1,"x":-100,"y":100,"visible":1}]}]}],
#    "packageCount":N,"partCount":N,"pinCount":N}
#
# 说明：这是**只读**导出，不 MarkModified、不 Save；可用于做静态库索引、网页预览、
# 或"改库前后 diff"的基线。需要页/封装几何的完整流（含图形、层、填充）请参考宿主自带的
# orPrmDboStreamer 分层（见 reference/official-ui-layout-export.md §4）。

if {$argc < 3} { puts stderr "usage: tclsh stream-olb.tcl <dbo-dll> <in.olb> <out.json> ?maxPackages?"; exit 2 }
lassign $argv dll olb outJson maxPkgs
if {$maxPkgs eq ""} { set maxPkgs 0 }

if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 3 }
if {![file isfile $olb]} { puts stderr "missing OLB: $olb"; exit 2 }

proc jstr {s} {
    set out ""
    foreach ch [split $s ""] {
        switch -- $ch {
            "\"" { append out "\\\"" }
            "\\" { append out "\\\\" }
            "\n" { append out "\\n" }
            "\r" { append out "\\r" }
            "\t" { append out "\\t" }
            default {
                set c [scan $ch %c]
                if {$c < 32} { append out [format "\\u%04x" $c] } else { append out $ch }
            }
        }
    }
    return "\"$out\""
}
proc mkc {v} { return [DboTclHelper_sMakeCString $v 0] }
proc readText {obj method} {
    set p [mkc ""]
    if {[catch {set st [$obj $method $p]} e]} { DboTclHelper_sDeleteCString $p; return "" }
    catch {$st -delete}
    set v [DboTclHelper_sGetConstCharPtr $p]
    DboTclHelper_sDeleteCString $p
    return $v
}

set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set pC   [mkc $olb]
set lib  [DboSession_GetLib $sess $pC $st]
if {$lib eq "NULL" || [$st Failed]} { puts stderr "cannot open: $olb"; exit 4 }

set pkgs {}
set nPkg 0; set nPart 0; set nPin 0
set it [$lib NewPackagesIter $st]
for {set pkg [$it NextPackage $st]} {$pkg ne "NULL"} {set pkg [$it NextPackage $st]} {
    if {$maxPkgs > 0 && $nPkg >= $maxPkgs} break
    incr nPkg
    set name [readText $pkg GetName]
    set fp   [readText $pkg GetPCBFootprint]
    set rd   [readText $pkg GetReferenceTemplate]

    set parts {}
    set pit [$pkg NewPartsIter $st]
    for {set part [$pit NextPart $st]} {$part ne "NULL"} {set part [$pit NextPart $st]} {
        incr nPart
        set pname [readText $part GetName]
        set namesVis 0
        catch {set namesVis [$part GetPinNamesAreVisible $st]}
        set numsVis 0
        catch {set numsVis [$part GetPinNumbersAreVisible $st]}
        catch {$st -delete}

        set pins {}
        set pinIt [$part NewLPinsIter $st]
        for {set pin [$pinIt NextPin $st]} {$pin ne "NULL"} {set pin [$pinIt NextPin $st]} {
            incr nPin
            set pn [readText $pin GetPinName]
            set pos "";  catch {set pos [$pin GetPinPosition $st]}
            set typ "";  catch {set typ [$pin GetPinType $st]}
            set vis 1;   catch {set vis [$pin GetIsVisible $st]}
            set hotX ""; set hotY ""
            if {![catch {set hp [$pin GetHotSpot $st]}]} {
                set hotX [DboTclHelper_sGetCPointX $hp]; set hotY [DboTclHelper_sGetCPointY $hp]
                DboTclHelper_sDeleteCPoint $hp
            }
            catch {$st -delete}
            lappend pins "{\"number\":[jstr $pos],\"name\":[jstr $pn],\"type\":[jstr $typ],\"x\":[jstr $hotX],\"y\":[jstr $hotY],\"visible\":[jstr $vis]}"
        }
        delete_DboLibPartPinsIter $pinIt
        catch {$pinIt -delete}
        lappend parts "{\"name\":[jstr $pname],\"pinNamesVisible\":$namesVis,\"pinNumbersVisible\":$numsVis,\"pins\":\[[join $pins ,]\]}"
    }
    delete_DboPackagePartsIter $pit
    catch {$pit -delete}
    lappend pkgs "{\"name\":[jstr $name],\"footprint\":[jstr $fp],\"refDes\":[jstr $rd],\"parts\":\[[join $parts ,]\]}"
}
delete_DboLibPackagesIter $it
catch {$it -delete}

set fh [open $outJson w]
fconfigure $fh -encoding utf-8 -translation lf
puts $fh "{\"library\":[jstr $olb],\"packages\":\[[join $pkgs ,]\],\"packageCount\":$nPkg,\"partCount\":$nPart,\"pinCount\":$nPin}"
close $fh

catch {DboSession_RemoveLib $sess $lib}
DboTclHelper_sDeleteCString $pC
catch {$st -delete}
DboTclHelper_sDeleteSession $sess
puts "ok packages=$nPkg parts=$nPart pins=$nPin -> $outJson"
exit 0
