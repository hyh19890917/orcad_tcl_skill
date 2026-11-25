# build-symbol.tcl — headless：从零建一个符号（Package + Part + Pins + 显示属性），保存后回读校验。
#
#   tclsh build-symbol.tcl <dbo-dll> <out.olb> <packageName> <refDesPrefix> <pinSpecFile>
#
# pinSpecFile 每行（TAB 分隔）：number  name  type  x1  y1  x2  y2
#   number  管脚号（字符串，可 "A1"）
#   name    管脚名（"~" 表示不显示）
#   type    GetPinType 的整数值（1=Input 2=Output 3=IO …，先用 1 试，回读验证）
#   x1 y1   管脚起点（符号本地坐标，单位与库一致，通常是 1/100 inch）
#   x2 y2   热点（连线端点）
#
# 官方同款序列：sCreateSession → GetLib/CreateLib → SetDefaultFont → NewPackage → NewPart
#   → DboSymbolToDboLibPart → SetBoundingBox → NewSymbolPinScalar → NewDisplayProp → SaveLib
# 退出码：0 成功；2 参数/输入错误；3 DLL 加载失败；4 建库失败；5 保存失败；6 回读校验失败。

if {$argc < 5} { puts stderr "usage: tclsh build-symbol.tcl <dbo-dll> <out.olb> <pkg> <refDes> <pinSpec>"; exit 2 }
lassign $argv dll olb pkgName refDes pinFile

if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 3 }
if {![file isfile $pinFile]} { puts stderr "missing pin spec: $pinFile"; exit 2 }

# --- 读管脚表 -------------------------------------------------------------
set pins {}
set fh [open $pinFile r]
fconfigure $fh -encoding utf-8
while {[gets $fh line] >= 0} {
    set line [string trim $line]
    if {$line eq "" || [string index $line 0] eq "#"} continue
    set f [split $line \t]
    if {[llength $f] < 7} { puts stderr "bad pin row: $line"; exit 2 }
    lappend pins [list [lindex $f 0] [lindex $f 1] [lindex $f 2] \
                       [lindex $f 3] [lindex $f 4] [lindex $f 5] [lindex $f 6]]
}
close $fh
if {![llength $pins]} { puts stderr "empty pin spec"; exit 2 }

# --- 建库 -----------------------------------------------------------------
set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set pathC [DboTclHelper_sMakeCString $olb 0]
set lib  [DboSession_GetLib $sess $pathC $st]
set created 0
if {$lib eq "NULL"} { set lib [DboSession_CreateLib $sess $pathC $st]; set created 1 }
if {$lib eq "NULL" || [$st Failed]} { puts stderr "open/create library failed: $olb"; exit 4 }

# 24 个默认字体槽先灌 Arial 8（否则文字用系统默认字体，跨机器变形）
set face [DboTclHelper_sMakeCString "Arial" 0]
for {set t 0} {$t < 24} {incr t} {
    set font [DboTclHelper_sMakeLOGFONT $face 8 0 0 0 400 0 0 0 0 7 0 1 16]
    catch {$lib SetDefaultFont $t $font}
    catch {DboTclHelper_sDeleteLOGFONT $font}
}
DboTclHelper_sDeleteCString $face

# --- 建 Package / Part -----------------------------------------------------
# Package ← Cell ← Part 三层：Part 名约定 "<Package>.Normal"（多单元时 A/B/C…）
set nameC [DboTclHelper_sMakeCString $pkgName 0]
set pkg   [$lib NewPackage $nameC $st]
set cell  [$lib NewCell    $nameC $st]
set partN [DboTclHelper_sMakeCString "$pkgName.Normal" 0]
set part  [$lib NewPart    $partN $st]
DboTclHelper_sDeleteCString $partN
DboTclHelper_sDeleteCString $nameC
if {$pkg eq "NULL" || $cell eq "NULL" || $part eq "NULL"} { puts stderr "NewPackage/NewCell/NewPart failed"; exit 4 }

set refC [DboTclHelper_sMakeCString $refDes 0]
catch {$pkg SetReferenceTemplate $refC}
DboTclHelper_sDeleteCString $refC

# Part 必须挂进 Cell，并把 Cell/Package 指针写回 LibPart，否则库里查不到这个器件
set libPart [DboSymbolToDboLibPart $part]
catch {$cell AddPart $part}
catch {$libPart SetCellPtr $cell}
catch {$libPart SetPackagePtr $pkg}
catch {$libPart SetPinNumbersAreVisible 0}
# 关键：Package 通过 Device 引用 Cell；没有 Device，Package 里看不到任何 Part（重开即空）
set devD [DboTclHelper_sMakeCString "A" 0]
set device [$pkg NewDevice $devD 0 $cell $st]
DboTclHelper_sDeleteCString $devD
if {$device eq "NULL"} { puts stderr "NewDevice failed"; exit 4 }
set refC2 [DboTclHelper_sMakeCString $refDes 0]
catch {$part SetReference $refC2}
DboTclHelper_sDeleteCString $refC2

# 包围盒按管脚范围算，再留 20 的边
set minX 0; set maxX 0; set minY 0; set maxY 0; set first 1
foreach p $pins {
    foreach {x y} [list [lindex $p 3] [lindex $p 4] [lindex $p 5] [lindex $p 6]] {
        if {![string is double -strict $x]} continue
        if {$first} { set minX $x; set maxX $x; set minY $y; set maxY $y; set first 0 }
        if {$x < $minX} { set minX $x }; if {$x > $maxX} { set maxX $x }
        if {$y < $minY} { set minY $y }; if {$y > $maxY} { set maxY $y }
    }
}
if {$first} { set minX -100; set maxX 100; set minY -100; set maxY 100 }
catch {$part SetBoundingBox [DboTclHelper_sMakeCRect [expr {$minX-20}] [expr {$minY-20}] \
                                                      [expr {$maxX+20}] [expr {$maxY+20}]]}

# --- 建管脚 ---------------------------------------------------------------
set made 0
foreach p $pins {
    lassign $p num pname ptype x1 y1 x2 y2
    set nC [DboTclHelper_sMakeCString $pname 0]
    set sP [DboTclHelper_sMakeCPoint $x1 $y1]
    set hP [DboTclHelper_sMakeCPoint $x2 $y2]
    set pin [$part NewSymbolPinScalar $st $nC $ptype $sP $hP 1 $num]
    DboTclHelper_sDeleteCString $nC
    DboTclHelper_sDeleteCPoint $sP
    DboTclHelper_sDeleteCPoint $hP
    if {$pin eq "NULL"} { puts stderr "pin $num failed"; exit 4 }
    incr made
}

# --- 显示属性（Value 放在包围盒下方）-------------------------------------
set label [DboTclHelper_sMakeCString "Value" 0]
set loc   [DboTclHelper_sMakeCPoint 0 [expr {$minY-40}]]
set f2    [DboTclHelper_sMakeLOGFONT [DboTclHelper_sMakeCString "Arial" 0] 8 0 0 0 400 0 0 0 0 7 0 1 16]
catch {set dp [$part NewDisplayProp $st $label $loc 0 $f2 48]}
DboTclHelper_sDeleteCString $label
DboTclHelper_sDeleteCPoint $loc
catch {DboTclHelper_sDeleteLOGFONT $f2}

# --- 保存 -----------------------------------------------------------------
# 关键：先 MarkAllLibForSave 再 SaveLib；只调 SaveLib 会返回 OK 但什么都不写（重开即空）
catch {DboSession_MarkAllLibForSave $sess $lib}
set st2 [$sess SaveLib $lib]
if {[$st2 Failed]} { $st2 -delete; puts stderr "SaveLib failed"; exit 5 }
$st2 -delete
DboSession_RemoveLib $sess $lib

# --- 回读校验：重开库，按包名找 Part，数管脚 ------------------------------
catch {$st -delete}
set st [DboState]
set lib2 [DboSession_GetLib $sess $pathC $st]
if {$lib2 eq "NULL"} { puts stderr "reopen failed"; exit 6 }
set nameC2 [DboTclHelper_sMakeCString $pkgName 0]
set pkg2 [$lib2 GetPackage $nameC2 $st]
DboTclHelper_sDeleteCString $nameC2
set count 0
if {$pkg2 ne "NULL"} {
    set it [$pkg2 NewPartsIter $st]
    for {set o [$it NextPart $st]} {$o ne "NULL"} {set o [$it NextPart $st]} {
        set pit [$o NewLPinsIter $st]
        for {set pn [$pit NextPin $st]} {$pn ne "NULL"} {set pn [$pit NextPin $st]} { incr count }
        catch {delete_DboLibPartPinsIter $pit}
        break
    }
    catch {delete_DboPackagePartsIter $it}
}
DboSession_RemoveLib $sess $lib2
catch {$st -delete}
DboTclHelper_sDeleteCString $pathC
DboTclHelper_sDeleteSession $sess

if {$count != $made} { puts stderr "readback mismatch: wrote $made pins, read $count"; exit 6 }
puts "ok package=$pkgName pins=$made created=$created -> $olb"
exit 0
