# hier-tree.tcl — headless：把 .dsn 的层级导成 JSON（可选生成 HTML 折叠树）
#
#   tclsh hier-tree.tcl <dbo-dll> <design.dsn> <out.json> ?maxDepth? ?--html out.html?
#
# 做法：先扫一遍"视图/原理图/页"建统计表（每页的器件数 + 类型直方图），
#       再从 root occurrence 走层级树；每个分支的页/器件数/类型直接从统计表取，
#       不重复遍历页——大设计也只扫一遍页。
#
# 输出 JSON：
#   {design, root, occurrences:[{id,parent,path,ref,page,primitive,recursive,contents,
#     children,pages:[{name,partInsts}],partCount,types:{TYPE_NAME:count}}],
#    views:[{schematic,pages:[{name,partInsts}]}],
#    occurrenceCount,pageCount,partInstCount,depthLimitHit}
#
# 只读：不 MarkModified、不 Save。.dsn 可能被 Capture 独占，建议在副本上跑。

if {$argc < 3} { puts stderr "usage: tclsh hier-tree.tcl <dbo-dll> <dsn> <out.json> ?maxDepth? ?--html file?"; exit 2 }
set dll      [lindex $argv 0]
set dsn      [lindex $argv 1]
set outJson  [lindex $argv 2]
set maxDepth 20
set htmlOut  ""
set idx 3
while {$idx < $argc} {
    set a [lindex $argv $idx]
    if {$a eq "--html"} { incr idx; set htmlOut [lindex $argv $idx] } \
    elseif {[string is integer -strict $a]} { set maxDepth $a }
    incr idx
}

if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 3 }
if {![file isfile $dsn]} { puts stderr "missing design: $dsn"; exit 2 }

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
    set out ""
    foreach ch [split $s ""] {
        switch -- $ch {
            "\"" { append out "\\\"" }
            "\\" { append out "\\\\" }
            "\n" { append out "\\n" }
            "\r" { append out "\\r" }
            "\t" { append out "\\t" }
            default { set c [scan $ch %c]; if {$c < 32} { append out [format "\\u%04x" $c] } else { append out $ch } }
        }
    }
    return "\"$out\""
}
proc hstr {s} {
    return [string map {& &amp; < &lt; > &gt; \" &quot;} $s]
}

# 类型码 -> 官方常量名（用宿主预置常量建表，不硬编码数字）
set ::TYPE_NAMES [dict create]
foreach n {PLACED_INSTANCE DRAWN_INSTANCE GRAPHIC_INSTANCE SYMBOL_PIN PAGE PACKAGE DEVICE LIBRARY_PART \
           WIRE_SCALAR WIRE_BUS NET_SCALAR FLAT_NET ALIAS DISPLAY_PROP TITLE_BLOCK PORT_INST \
           OFF_PAGE_CONNECTOR BOOK_MARK ERC_OBJECT CUSTOMITEM_INSTANCE} {
    if {[info exists ::DboBaseObject_$n]} { dict set ::TYPE_NAMES [set ::DboBaseObject_$n] $n }
}
proc typeName {t} {
    if {[dict exists $::TYPE_NAMES $t]} { return [dict get $::TYPE_NAMES $t] }
    return "TYPE_$t"
}

set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set pathC [mkc $dsn]
set design [$sess GetDesign $pathC $st]
if {$design eq "NULL" || [$st Failed]} { puts stderr "cannot open design: $dsn"; exit 4 }
set dname    [readText $design GetName]
set rootName [readText $design GetRootName]
puts "design=$dname root=$rootName"

# --- 第一遍：视图/页统计（schematic -> {pages, partCount, types}）---------
set schStats [dict create]
set views {}
set nPage 0
set nInst 0
set vi "NULL"
if {![catch {set vi [$design NewViewsIter $st $::IterDefs_SCHEMATICS]}] && $vi ne "NULL"} {
    for {set view [$vi NextView $st]} {$view ne "NULL"} {set view [$vi NextView $st]} {
        set sch [DboViewToDboSchematic $view]
        set schName [readText $sch GetName]
        set pageList {}
        set schParts 0
        set schTypes [dict create]
        set pi "NULL"
        if {![catch {set pi [$sch NewPagesIter $st]}] && $pi ne "NULL"} {
            for {set page [$pi NextPage $st]} {$page ne "NULL"} {set page [$pi NextPage $st]} {
                incr nPage
                set pname [readText $page GetName]
                set cnt 0
                set ii "NULL"
                if {![catch {set ii [$page NewPartInstsIter $st]}] && $ii ne "NULL"} {
                    for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} {
                        incr cnt; incr nInst
                        set t ""; catch {set t [$inst GetObjectType]}
                        if {$t ne ""} { dict incr schTypes [typeName $t] }
                    }
                    catch {delete_DboPagePartInstsIter $ii}
                }
                incr schParts $cnt
                lappend pageList [list $pname $cnt]
            }
            catch {delete_DboSchematicPagesIter $pi}
        }
        dict set schStats $schName [dict create pages $pageList parts $schParts types $schTypes]
        set pj {}
        foreach p $pageList { lappend pj "{\"name\":[jstr [lindex $p 0]],\"partInsts\":[lindex $p 1]}" }
        lappend views "{\"schematic\":[jstr $schName],\"pages\":\[[join $pj ,]\]}"
    }
    catch {delete_DboLibViewsIter $vi}
}

# --- 第二遍：occurrence 树 -------------------------------------------------
set recs [dict create]
set kidsOf [dict create]
set queue {}
set nOcc 0
set depthHit 0
catch {
    set root [$design GetRootOccurrence $st]
    if {$root ne "NULL"} {
        lappend queue [list $root 0 ""]
        while {[llength $queue]} {
            lassign [lindex $queue 0] occ depth parentId
            set queue [lrange $queue 1 end]
            set oid ""; catch {set oid [$occ GetId $st]}
            if {[dict exists $recs $oid]} continue
            incr nOcc

            set ref ""
            set pn [mkc "Part Reference"]
            set inst "NULL"; catch {set inst [$occ GetPartInst $st]}
            foreach holder [list $occ $inst] {
                if {$holder eq "NULL"} continue
                set pv [mkc ""]
                if {![catch {set ps [$holder GetEffectivePropStringValue $pn $pv]}]} { catch {$ps -delete} }
                set pval [DboTclHelper_sGetConstCharPtr $pv]
                DboTclHelper_sDeleteCString $pv
                if {$pval ne ""} { set ref $pval; break }
            }
            DboTclHelper_sDeleteCString $pn
            if {$ref eq "" && $inst ne "NULL"} { set ref [readText $inst GetDesignator] }

            set page ""
            if {$inst ne "NULL"} {
                set pg "NULL"; catch {set pg [$inst GetOwner]}
                if {$pg ne "NULL"} {
                    set sch2 "NULL"; catch {set sch2 [$pg GetOwner]}
                    set page "[readText $sch2 GetName]/[readText $pg GetName]"
                }
            }

            set prim 0; catch {set prim [$occ IsPrimitive $st]}
            set rec 0;  catch {set rec  [$occ IsRecursive $st]}
            set path [readText $occ GetPathName]

            # 分支展开到哪个原理图，就用第一遍的统计
            set contents ""
            set sch "NULL"
            if {![catch {set sch [$occ GetContents $st]}] && $sch ne "NULL"} { set contents [readText $sch GetName] }
            set pages {}; set pc 0; set types [dict create]
            if {$contents ne "" && [dict exists $schStats $contents]} {
                set s [dict get $schStats $contents]
                set pages [dict get $s pages]
                set pc [dict get $s parts]
                set types [dict get $s types]
            }

            set kids {}
            if {$depth < $maxDepth} {
                set it "NULL"
                if {![catch {set it [$occ NewChildrenIter $st $::IterDefs_INSTS]}] && $it ne "NULL"} {
                    for {set c [$it NextOccurrence $st]} {$c ne "NULL"} {set c [$it NextOccurrence $st]} {
                        set child [DboOccurrenceToDboInstOccurrence $c]
                        set cid ""; catch {set cid [$child GetId $st]}
                        if {$cid ne ""} { lappend kids $cid; lappend queue [list $child [expr {$depth + 1}] $oid] }
                    }
                    catch {delete_DboOccurrenceChildrenIter $it}
                    catch {$it -delete}
                }
            } elseif {[llength $kids] == 0} { set depthHit 1 }

            dict set recs $oid [dict create id $oid path $path ref $ref page $page prim $prim rec $rec \
                                             contents $contents pages $pages parts $pc types $types kids $kids parent $parentId]
            if {$parentId ne ""} { dict lappend kidsOf $parentId $oid }
        }
    }
}

# --- 写 JSON ---------------------------------------------------------------
set chunks {}
dict for {oid r} $recs {
    set pagesJson {}
    foreach pg [dict get $r pages] { lappend pagesJson "{\"name\":[jstr [lindex $pg 0]],\"partInsts\":[lindex $pg 1]}" }
    set typesJson {}
    dict for {tn tc} [dict get $r types] { lappend typesJson "[jstr $tn]:$tc" }
    lappend chunks "{\"id\":[jstr $oid],\"parent\":[jstr [dict get $r parent]],\"path\":[jstr [dict get $r path]],\"ref\":[jstr [dict get $r ref]],\"page\":[jstr [dict get $r page]],\"primitive\":[dict get $r prim],\"recursive\":[dict get $r rec],\"contents\":[jstr [dict get $r contents]],\"children\":[llength [dict get $r kids]],\"pages\":\[[join $pagesJson ,]\],\"partCount\":[dict get $r parts],\"types\":\{[join $typesJson ,]\}}"
}
set fh [open $outJson w]
fconfigure $fh -encoding utf-8 -translation lf
puts $fh "{\"design\":[jstr $dname],\"root\":[jstr $rootName],\"occurrences\":\[[join $chunks ,]\],\"views\":\[[join $views ,]\],\"occurrenceCount\":$nOcc,\"pageCount\":$nPage,\"partInstCount\":$nInst,\"depthLimitHit\":$depthHit}"
close $fh

# --- 可选：HTML 折叠树 -----------------------------------------------------
if {$htmlOut ne ""} {
    proc renderNode {oid recs kidsOf depth} {
        if {![dict exists $recs $oid]} { return "" }
        set r [dict get $recs $oid]
        set label [hstr [dict get $r path]]
        if {[dict get $r ref] ne ""} { append label "  " [hstr [dict get $r ref]] }
        if {[dict get $r contents] ne ""} { append label "  -> " [hstr [dict get $r contents]] }
        if {[dict get $r parts] > 0} { append label "  (" [dict get $r parts] " parts)" }
        set body ""
        set types ""
        dict for {tn tc} [dict get $r types] { append types " $tn:$tc" }
        if {$types ne ""} { append body "<div class=t>" [hstr $types] "</div>" }
        if {[dict exists $kidsOf $oid]} {
            foreach k [dict get $kidsOf $oid] { append body [renderNode $k $recs $kidsOf [expr {$depth+1}]] }
        }
        set open [expr {$depth < 2 ? " open" : ""}]
        return "<details$open><summary>$label</summary>$body</details>"
    }
    set rootId ""
    dict for {oid r} $recs { if {[dict get $r parent] eq ""} { set rootId $oid; break } }
    set html "<!doctype html><meta charset=utf-8><title>[hstr $dname] hierarchy</title>"
    append html "<style>body{font:13px/1.6 Consolas,Menlo,monospace;margin:20px}details{margin-left:14px}summary{cursor:pointer}.t{color:#888;margin-left:26px;font-size:12px}</style>"
    append html "<h3>[hstr $dname]</h3>"
    append html [renderNode $rootId $recs $kidsOf 0]
    set hh [open $htmlOut w]
    fconfigure $hh -encoding utf-8 -translation lf
    puts $hh $html
    close $hh
    puts "html -> $htmlOut"
}

catch {$sess RemoveDesign $design}
DboTclHelper_sDeleteCString $pathC
catch {$st -delete}
DboTclHelper_sDeleteSession $sess
puts "ok occurrences=$nOcc pages=$nPage partInsts=$nInst -> $outJson"
exit 0
