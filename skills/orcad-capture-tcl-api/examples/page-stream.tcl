# page-stream.tcl — headless：把一页原理图流成 JSON（+ 可选 SVG/HTML 预览）
#
#   tclsh page-stream.tcl <dbo-dll> <design.dsn> <schematic> <page> <out.json> ?--html out.html?
#
# 用途：离线"点分支看页"的渲染数据源。与 hier-tree.tcl 配合：
#   hier-tree 告诉你有哪些分支/页 → page-stream 把某一页的图元导出来 → 前端画。
#
# 输出：
#   {"schematic":"..","page":"..","extent":[minx,miny,maxx,maxy],
#    "parts":[{"id","ref","value","x","y"}],
#    "wires":[{"id","name","points":[[x,y],..]}],
#    "ports":[{"id","name","x","y","global":0/1}],
#    "offpage":[{"id","name","x","y"}],
#    "counts":{"parts":N,"wires":N,"ports":N,"offpage":N}}
#
# 只读。坐标单位 = 设计数据库单位（通常 1/100 inch），前端按 extent 自适应。
# 注意：图元几何取"端点/热点/包围盒中心"，够画线框预览；要精确图形（圆弧/多边形）
#       仍需宿主自带 orPrmDboStreamer 那套完整 streamer。

if {$argc < 5} { puts stderr "usage: tclsh page-stream.tcl <dbo-dll> <dsn> <schematic> <page> <out.json> ?--html file?"; exit 2 }
set dll  [lindex $argv 0]
set dsn  [lindex $argv 1]
set schW [lindex $argv 2]
set pgW  [lindex $argv 3]
set out  [lindex $argv 4]
set htmlOut ""
set i 5
while {$i < $argc} {
    if {[lindex $argv $i] eq "--html"} { incr i; set htmlOut [lindex $argv $i] }
    incr i
}
if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 3 }

proc mkc {v} { return [DboTclHelper_sMakeCString $v 0] }
proc readText {obj method} {
    set p [mkc ""]
    if {[catch {set st [$obj $method $p]} e]} { DboTclHelper_sDeleteCString $p; return "" }
    catch {$st -delete}
    set v [DboTclHelper_sGetConstCharPtr $p]
    DboTclHelper_sDeleteCString $p
    return $v
}
proc jstr {s} {
    set o ""
    foreach ch [split $s ""] {
        switch -- $ch {
            "\"" { append o "\\\"" } "\\" { append o "\\\\" }
            "\n" { append o "\\n" } "\r" { append o "\\r" } "\t" { append o "\\t" }
            default { set c [scan $ch %c]; if {$c < 32} { append o [format "\\u%04x" $c] } else { append o $ch } }
        }
    }
    return "\"$o\""
}
proc hstr {s} { return [string map {& &amp; < &lt; > &gt; \" &quot;} $s] }
proc Pt {obj method st} {
    set p ""
    if {[catch {set p [$obj $method $st]}]} { return "" }
    if {$p eq "NULL" || $p eq ""} { return "" }
    set x [DboTclHelper_sGetCPointX $p]; set y [DboTclHelper_sGetCPointY $p]
    catch {DboTclHelper_sDeleteCPoint $p}
    return [list $x $y]
}

set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set pC [mkc $dsn]
set design [$sess GetDesign $pC $st]
if {$design eq "NULL" || [$st Failed]} { puts stderr "cannot open design: $dsn"; exit 4 }

# 定位 schematic/page
set pageObj "NULL"
set vi "NULL"
if {![catch {set vi [$design NewViewsIter $st $::IterDefs_SCHEMATICS]}] && $vi ne "NULL"} {
    for {set view [$vi NextView $st]} {$view ne "NULL"} {set view [$vi NextView $st]} {
        set sch [DboViewToDboSchematic $view]
        if {[string equal -nocase [readText $sch GetName] $schW]} {
            set pi "NULL"
            if {![catch {set pi [$sch NewPagesIter $st]}] && $pi ne "NULL"} {
                for {set pg [$pi NextPage $st]} {$pg ne "NULL"} {set pg [$pi NextPage $st]} {
                    if {[string equal -nocase [readText $pg GetName] $pgW]} { set pageObj $pg; break }
                }
                catch {delete_DboSchematicPagesIter $pi}
            }
        }
        if {$pageObj ne "NULL"} break
    }
    catch {delete_DboLibViewsIter $vi}
}
if {$pageObj eq "NULL"} { puts stderr "page not found: $schW/$pgW"; exit 4 }

set minX ""; set minY ""; set maxX ""; set maxY ""
proc grow {x y} {
    variable minX; variable minY; variable maxX; variable maxY
    if {$x eq "" || $y eq ""} return
    if {$minX eq "" || $x < $minX} { set minX $x }
    if {$maxX eq "" || $x > $maxX} { set maxX $x }
    if {$minY eq "" || $y < $minY} { set minY $y }
    if {$maxY eq "" || $y > $maxY} { set maxY $y }
}

# --- 器件 ----------------------------------------------------------------
set parts {}
set partGeom {}
set wireGeom {}
set portGeom {}
set nPart 0
set ii "NULL"
if {![catch {set ii [$pageObj NewPartInstsIter $st]}] && $ii ne "NULL"} {
    for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} {
        incr nPart
        set id ""; catch {set id [$inst GetId $st]}
        set ref ""
        foreach rp {Reference {Part Reference} {Part_Reference}} {
            if {$ref ne ""} break
            set rn [mkc $rp]; set rv [mkc ""]
            if {![catch {set rs [$inst GetEffectivePropStringValue $rn $rv]}]} { catch {$rs -delete} }
            set ref [DboTclHelper_sGetConstCharPtr $rv]
            DboTclHelper_sDeleteCString $rn; DboTclHelper_sDeleteCString $rv
        }
        if {$ref eq ""} { set ref [readText $inst GetDesignator] }
        set val ""
        set pn [mkc "Value"]
        set pv [mkc ""]
        if {![catch {set ps [$inst GetEffectivePropStringValue $pn $pv]}]} { catch {$ps -delete} }
        catch {set val [DboTclHelper_sGetConstCharPtr $pv]}
        DboTclHelper_sDeleteCString $pn; DboTclHelper_sDeleteCString $pv
        set loc [Pt $inst GetLocation $st]
        if {[llength $loc]} { grow [lindex $loc 0] [lindex $loc 1] }
        lappend parts "{\"id\":[jstr $id],\"ref\":[jstr $ref],\"value\":[jstr $val],\"x\":[lindex $loc 0],\"y\":[lindex $loc 1]}"
        if {[llength $loc] == 2} { lappend partGeom [list $ref [lindex $loc 0] [lindex $loc 1]] }
    }
    catch {delete_DboPagePartInstsIter $ii}
}

# --- 导线 ----------------------------------------------------------------
set wires {}
set nWire 0
set wi "NULL"
if {![catch {set wi [$pageObj NewWiresIter $st]}] && $wi ne "NULL"} {
    for {set w [$wi NextWire $st]} {$w ne "NULL"} {set w [$wi NextWire $st]} {
        incr nWire
        set id ""; catch {set id [$w GetId $st]}
        set s [Pt $w GetStartPoint $st]
        set e [Pt $w GetEndPoint $st]
        set pts {}
        if {[llength $s] && [llength $e]} { set pts [list $s $e] }
        foreach p $pts { grow [lindex $p 0] [lindex $p 1] }
        set pj {}
        foreach p $pts { lappend pj "\[[lindex $p 0],[lindex $p 1]\]" }
        lappend wires "{\"id\":[jstr $id],\"name\":[jstr [readText $w GetNetName]],\"points\":\[[join $pj ,]\]}"
        lappend wireGeom $pts
    }
    catch {delete_DboPageWiresIter $wi}
}

# --- 端口 / 全局 / 页间连接符 --------------------------------------------
set ports {}
set nPort 0
set pi2 "NULL"
if {![catch {set pi2 [$pageObj NewPortInstsIter $st]}] && $pi2 ne "NULL"} {
    for {set p [$pi2 NextPortInst $st]} {$p ne "NULL"} {set p [$pi2 NextPortInst $st]} {
        incr nPort
        set id ""; catch {set id [$p GetId]}
        set hs [Pt $p GetHotSpot $st]
        set sp [Pt $p GetStartPoint $st]
        set pos [expr {[llength $hs] ? $hs : $sp}]
        if {[llength $pos]} { grow [lindex $pos 0] [lindex $pos 1] }
        set g 0; catch {set g [$p GetIsGlobal $st]}
        lappend ports "{\"id\":[jstr $id],\"name\":[jstr [readText $p GetPinName]],\"x\":[lindex $pos 0],\"y\":[lindex $pos 1],\"global\":$g}"
        if {[llength $pos] == 2} { lappend portGeom [list [readText $p GetPinName] [lindex $pos 0] [lindex $pos 1]] }
    }
    catch {delete_DboPagePortInstsIter $pi2}
}

set offpage {}
set nOff 0
set oi "NULL"
if {![catch {set oi [$pageObj NewOffPageConnectorsIter $st]}] && $oi ne "NULL"} {
    for {set o [$oi NextOffPageConnector $st]} {$o ne "NULL"} {set o [$oi NextOffPageConnector $st]} {
        incr nOff
        set id ""; catch {set id [$o GetId]}
        set box "NULL"; catch {set box [$o GetBoundingBox]}
        set cx ""; set cy ""
        if {$box ne "NULL"} {
            set br [DboTclHelper_sGetCRectBottomRight $box]
            set cx [DboTclHelper_sGetCPointX $br]; set cy [DboTclHelper_sGetCPointY $br]
            DboTclHelper_sDeleteCPoint $br; DboTclHelper_sDeleteCRect $box
            grow $cx $cy
        }
        lappend offpage "{\"id\":[jstr $id],\"name\":[jstr [readText $o GetName]],\"x\":[jstr $cx],\"y\":[jstr $cy]}"
    }
    catch {delete_DboOffPageConnectorsIter $oi}
}

if {$minX eq ""} { set minX 0; set minY 0; set maxX 1000; set maxY 1000 }

set fh [open $out w]
fconfigure $fh -encoding utf-8 -translation lf
puts $fh "{\"schematic\":[jstr $schW],\"page\":[jstr $pgW],\"extent\":\[$minX,$minY,$maxX,$maxY\],\"parts\":\[[join $parts ,]\],\"wires\":\[[join $wires ,]\],\"ports\":\[[join $ports ,]\],\"offpage\":\[[join $offpage ,]\],\"counts\":{\"parts\":$nPart,\"wires\":$nWire,\"ports\":$nPort,\"offpage\":$nOff}}"
close $fh

# --- 可选：SVG 缩略图（同一份数据画线框，便于肉眼核对）-------------------
if {$htmlOut ne ""} {
    set W 1200; set H 800
    set dx [expr {double($maxX - $minX)}]; if {$dx <= 0} { set dx 1 }
    set dy [expr {double($maxY - $minY)}]; if {$dy <= 0} { set dy 1 }
    set s [expr {(($W-80)/$dx) < (($H-80)/$dy) ? (($W-80)/$dx) : (($H-80)/$dy)}]
    proc TX {x} { global minX s; return [expr {40 + ($x - $minX) * $s}] }
    proc TY {y} { global maxY s; return [expr {40 + ($maxY - $y) * $s}] }
    set svg "<svg xmlns=http://www.w3.org/2000/svg width=$W height=$H viewBox=\"0 0 $W $H\" style=\"background:#fff\">"
    append svg "<rect x=40 y=40 width=[expr {$W-80}] height=[expr {$H-80}] fill=none stroke=#ddd/>"
    foreach pts $wireGeom {
        set coords {}
        foreach p $pts { lappend coords "[TX [lindex $p 0]],[TY [lindex $p 1]]" }
        if {[llength $coords] >= 2} { append svg "<polyline points=\"[join $coords { }]\" fill=none stroke=#2b6/>" }
    }
    foreach g $partGeom {
        lassign $g ref x y
        set px [TX $x]; set py [TY $y]
        append svg "<rect x=[expr {$px-3}] y=[expr {$py-3}] width=6 height=6 fill=#06c/>"
        if {$ref ne ""} { append svg "<text x=[expr {$px+5}] y=[expr {$py-5}] font-size=10 fill=#06c>[hstr $ref]</text>" }
    }
    foreach g $portGeom {
        lassign $g nm x y
        set px [TX $x]; set py [TY $y]
        append svg "<circle cx=$px cy=$py r=4 fill=#c60/><text x=[expr {$px+6}] y=[expr {$py+3}] font-size=10 fill=#c60>[hstr $nm]</text>"
    }
    append svg "</svg>"
    set hh [open $htmlOut w]
    fconfigure $hh -encoding utf-8 -translation lf
    puts $hh "<!doctype html><meta charset=utf-8><title>[hstr $schW]/[hstr $pgW]</title><body style=\"margin:0;font:12px sans-serif\"><div style=\"padding:6px\">[hstr $schW]/[hstr $pgW] — parts=$nPart wires=$nWire ports=$nPort</div>$svg</body>"
    close $hh
    puts "html -> $htmlOut"
}