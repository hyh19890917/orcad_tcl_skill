# hier-tree.tcl — headless：把一个设计（.dsn）的层级与页结构导成 JSON（层级预览器的数据源）
#
#   tclsh hier-tree.tcl <dbo-dll> <design.dsn> <out.json> ?maxDepth?
#
# 输出：
#   {"design":"...","root":"...","occurrences":[
#      {"id":12,"path":"ROOT/A1","ref":"U1","page":"SHEET1/PAGE1","children":3,"primitive":0}],
#    "views":[{"schematic":"SHEET1","pages":[{"name":"PAGE1","partInsts":42}]}],
#    "occurrenceCount":N,"pageCount":N,"partInstCount":N}
#
# 依赖：DboSession_GetDesign（离屏打开设计）、GetRootOccurrence + NewChildrenIter（层级）、
#       NewViewsIter/NewPagesIter（页）。全是只读调用，不保存、不 MarkModified。
# 提示：.dsn 可能被 Capture 独占；先在副本上跑。找不到 DSN 样本时可用 Cadence 自带
#       share\orcad\examples\pcbdemo2\ps15\PS15.DSN 试。

if {$argc < 3} { puts stderr "usage: tclsh hier-tree.tcl <dbo-dll> <design.dsn> <out.json> ?maxDepth?"; exit 2 }
lassign $argv dll dsn outJson maxDepth
if {$maxDepth eq ""} { set maxDepth 20 }

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

set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set pathC [mkc $dsn]
set design [$sess GetDesign $pathC $st]
if {$design eq "NULL" || [$st Failed]} { puts stderr "cannot open design: $dsn"; exit 4 }
set dname [readText $design GetName]
set rootName [readText $design GetRootName]
puts "design=$dname root=$rootName"

# --- 层级：从 root occurrence 起 BFS -------------------------------------
set occs {}
set seen {}
set queue {}
set nOcc 0
set depthExceeded 0
catch {
    set root [$design GetRootOccurrence $st]
    if {$root ne "NULL"} {
        lappend queue [list $root 0]
        while {[llength $queue]} {
            lassign [lindex $queue 0] occ depth
            set queue [lrange $queue 1 end]
            set oid ""
            catch {set oid [$occ GetId $st]}
            if {[dict exists $seen $oid]} continue
            dict set seen $oid 1
            incr nOcc
            set path [readText $occ GetPathName]
            set ref ""
            set page ""
            set prim 0
            catch {set prim [$occ IsPrimitive $st]}
            set inst "NULL"
            catch {set inst [$occ GetPartInst $st]}
            if {$inst ne "NULL"} {
                # 位号：occurrence 上的值优先（分支可能覆盖），再退回实例属性
                set ref ""
                set pn [mkc "Part Reference"]
                foreach holder [list $occ $inst] {
                    set pv [mkc ""]
                    if {![catch {set ps [$holder GetEffectivePropStringValue $pn $pv]}]} { catch {$ps -delete} }
                    set pval [DboTclHelper_sGetConstCharPtr $pv]
                    DboTclHelper_sDeleteCString $pv
                    if {$pval ne ""} { set ref $pval; break }
                }
                DboTclHelper_sDeleteCString $pn
                if {$ref eq ""} { set ref [readText $inst GetDesignator] }
                set pg [$inst GetOwner]
                if {$pg ne "NULL"} {
                    set sch [$pg GetOwner]
                    set page "[readText $sch GetName]/[readText $pg GetName]"
                }
            }
            set kids 0
            if {$depth < $maxDepth} {
                set it "NULL"
                if {![catch {set it [$occ NewChildrenIter $st $::IterDefs_INSTS]}] && $it ne "NULL"} {
                    for {set c [$it NextOccurrence $st]} {$c ne "NULL"} {set c [$it NextOccurrence $st]} {
                        incr kids
                        set child [DboOccurrenceToDboInstOccurrence $c]
                        lappend queue [list $child [expr {$depth + 1}]]
                    }
                    catch {delete_DboOccurrenceChildrenIter $it}
                    catch {$it -delete}
                }
            } else { set depthExceeded 1 }
            lappend occs "{\"id\":[jstr $oid],\"path\":[jstr $path],\"ref\":[jstr $ref],\"page\":[jstr $page],\"primitive\":$prim,\"children\":$kids}"
        }
    }
}

# --- 页与视图 -------------------------------------------------------------
set views {}
set nPage 0; set nInst 0
set vi "NULL"
if {![catch {set vi [$design NewViewsIter $st $::IterDefs_SCHEMATICS]}] && $vi ne "NULL"} {
    for {set view [$vi NextView $st]} {$view ne "NULL"} {set view [$vi NextView $st]} {
        set sch [DboViewToDboSchematic $view]
        set schName [readText $sch GetName]
        set pages {}
        set pi "NULL"
        if {![catch {set pi [$sch NewPagesIter $st]}] && $pi ne "NULL"} {
            for {set page [$pi NextPage $st]} {$page ne "NULL"} {set page [$pi NextPage $st]} {
                incr nPage
                set pname [readText $page GetName]
                set cnt 0
                set ii "NULL"
                if {![catch {set ii [$page NewPartInstsIter $st]}] && $ii ne "NULL"} {
                    for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} { incr cnt }
                    catch {delete_DboPagePartInstsIter $ii}
                }
                incr nInst $cnt
                lappend pages "{\"name\":[jstr $pname],\"partInsts\":$cnt}"
            }
            catch {delete_DboSchematicPagesIter $pi}
        }
        lappend views "{\"schematic\":[jstr $schName],\"pages\":\[[join $pages ,]\]}"
    }
    catch {delete_DboLibViewsIter $vi}
}

set fh [open $outJson w]
fconfigure $fh -encoding utf-8 -translation lf
puts $fh "{\"design\":[jstr $dname],\"root\":[jstr $rootName],\"occurrences\":\[[join $occs ,]\],\"views\":\[[join $views ,]\],\"occurrenceCount\":$nOcc,\"pageCount\":$nPage,\"partInstCount\":$nInst,\"depthLimitHit\":$depthExceeded}"
close $fh

catch {$sess RemoveDesign $design}
DboTclHelper_sDeleteCString $pathC
catch {$st -delete}
DboTclHelper_sDeleteSession $sess
puts "ok occurrences=$nOcc pages=$nPage partInsts=$nInst -> $outJson"
exit 0
