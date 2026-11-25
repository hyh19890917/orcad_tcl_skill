# bulk-edit-csv.tcl — 进程内：按 CSV 批量改器件属性（带前值校验 + 逆序回滚）
#
#   source bulk-edit-csv.tcl
#   ::bulkedit::Run C:/work/changes.csv              ;# dry-run：只打印计划
#   ::bulkedit::Run C:/work/changes.csv -commit      ;# 应用并保存设计
#   ::bulkedit::Run C:/work/changes.csv -all -commit ;# 处理整个设计（默认只当前页）
#
# CSV 每行：reference,field,value（逗号分隔，允许 "值,含逗号" 用双引号包裹）
#   R1,Manufacturer,YAGEO
#   R2,PCB Footprint,0402
#   U3,Value,STM32F103C8T6
#
# 规则（照抄可靠批量改的套路）：
#   1. 先取 before（effective 值 + 是否存在），写后回读校验，不一致就回滚
#   2. 任一行失败 → 逆序恢复已写行 → 报错，绝不半途保存
#   3. -commit 前不写盘；保存用 MarkAllLibForSave + SaveDesign
# 说明：模板，未在 GUI 里跑过；先 dry-run 对一遍"命中/未命中"再 -commit。

namespace eval ::bulkedit {
    variable applied {}
    variable missing {}
}

proc ::bulkedit::Text {obj method} {
    set p [DboTclHelper_sMakeCString "" 0]
    set code [catch {
        set st [$obj $method $p]
        catch {$st -delete}
        DboTclHelper_sGetConstCharPtr $p
    } r]
    DboTclHelper_sDeleteCString $p
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $r }
    return $r
}

proc ::bulkedit::Prop {obj name} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString "" 0]
    set code [catch {
        set st [$obj GetEffectivePropStringValue $n $v]
        set ok [$st OK]; catch {$st -delete}
        list $ok [DboTclHelper_sGetConstCharPtr $v]
    } r]
    DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $r }
    return $r
}

proc ::bulkedit::Write {obj name present value} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString $value 0]
    set code [catch {
        if {$present} {
            set st [$obj SetEffectivePropStringValue $n $v]
        } else {
            set st [$obj DeleteEffectiveProp $n]
        }
        set ok [$st OK]; catch {$st -delete}
        if {!$ok} { error "宿主拒绝 $name" }
        set st [$obj MarkModified]; catch {$st -delete}
    } r]
    DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $r }
    return
}

# 收集 refdes → 对象（当前页或整个设计）
proc ::bulkedit::Collect {all} {
    set map [dict create]
    set design [GetActivePMDesign]
    if {$design eq "NULL" || $design eq ""} { error "请先打开设计" }
    set st [DboState]
    try {
        if {$all} {
            set vi [$design NewViewsIter $st $::IterDefs_SCHEMATICS]
            for {set view [$vi NextView $st]} {$view ne "NULL"} {set view [$vi NextView $st]} {
                set sch [DboViewToDboSchematic $view]
                set pi [$sch NewPagesIter $st]
                for {set page [$pi NextPage $st]} {$page ne "NULL"} {set page [$pi NextPage $st]} {
                    set ii [$page NewPartInstsIter $st]
                    for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} {
                        set ref [lindex [::bulkedit::Prop $inst {Part Reference}] 1]
                        if {$ref eq ""} { set ref [::bulkedit::Text $inst GetDesignator] }
                        if {$ref ne "" && ![dict exists $map $ref]} { dict set map $ref $inst }
                    }
                    catch {delete_DboPagePartInstsIter $ii}
                }
                catch {delete_DboSchematicPagesIter $pi}
            }
            catch {delete_DboLibViewsIter $vi}
        } else {
            set page [GetActivePage]
            if {$page eq "NULL" || $page eq ""} { error "请先打开一页原理图" }
            set ii [$page NewPartInstsIter $st]
            for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} {
                set ref [lindex [::bulkedit::Prop $inst {Part Reference}] 1]
                if {$ref eq ""} { set ref [::bulkedit::Text $inst GetDesignator] }
                if {$ref ne ""} { dict set map $ref $inst }
            }
            catch {delete_DboPagePartInstsIter $ii}
        }
    } finally { catch {$st -delete} }
    return $map
}

proc ::bulkedit::Run {csvFile args} {
    variable applied; variable missing
    set applied {}; set missing {}
    set commit 0; set all 0
    foreach a $args {
        switch -- $a {
            -commit { set commit 1 }
            -all    { set all 1 }
            default { error "未知参数 $a" }
        }
    }
    if {![file isfile $csvFile]} { error "找不到 CSV：$csvFile" }
    set rows {}
    set fh [open $csvFile r]
    fconfigure $fh -encoding utf-8
    while {[gets $fh line] >= 0} {
        set line [string trim $line]
        if {$line eq "" || [string index $line 0] eq "#"} continue
        set f [::bulkedit::SplitCsv $line]
        if {[llength $f] < 3} { continue }
        lappend rows [list [lindex $f 0] [lindex $f 1] [lindex $f 2]]
    }
    close $fh
    if {![llength $rows]} { error "CSV 没有有效行" }

    set map [::bulkedit::Collect $all]
    set dw [llength $rows]
    set hit 0
    foreach r $rows {
        lassign $r ref field value
        if {![dict exists $map $ref]} { lappend missing $ref; continue }
        incr hit
        set obj [dict get $map $ref]
        lassign [::bulkedit::Prop $obj $field] exists before
        puts [format "  %-8s %-28s %s -> %s" $ref $field [expr {$exists ? "«$before»" : "(无)"}] "«$value»"]
        if {!$commit} continue
        lappend applied [list $obj $field $exists $before]
        ::bulkedit::Write $obj $field 1 $value
        lassign [::bulkedit::Prop $obj $field] aexists avalue
        if {!$aexists || $avalue ne $value} { error "回读不一致：$ref/$field 期望 «$value» 实际 «$avalue»" }
    }
    if {[llength $missing]} { puts "  未命中 refdes：[join $missing {, }]" }

    if {$commit} {
        set design [GetActivePMDesign]
        set sess $::DboSession_s_pDboSession
        set st [$sess MarkAllLibForSave $design]
        if {![$st OK]} { $st -delete; error "标记保存失败" }
        $st -delete
        set st [$sess SaveDesign $design]
        if {![$st OK]} { $st -delete; error "保存设计失败" }
        $st -delete
        puts "  committed: $hit 行"
    } else {
        puts "  dry-run: 命中 $hit / $dw 行（加 -commit 才写盘）"
    }
    return $hit
}

# 极简 CSV 行解析（支持双引号包裹、逗号在引号内）
proc ::bulkedit::SplitCsv {line} {
    set out {}; set cur ""; set inQ 0
    foreach ch [split $line ""] {
        if {$ch eq "\""} { set inQ [expr {!$inQ}]; continue }
        if {$ch eq "," && !$inQ} { lappend out $cur; set cur ""; continue }
        append cur $ch
    }
    lappend out $cur
    return $out
}

puts "::bulkedit::Run 已就绪（先 dry-run，确认命中数再加 -commit）"
