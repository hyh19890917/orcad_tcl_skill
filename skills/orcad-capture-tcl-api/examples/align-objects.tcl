# align-objects.tcl — 进程内：对齐 / 等距分布选中的器件与图形（模板）
#
#   source align-objects.tcl
#   ::align::Run left                     ;# 只打印计划（dry-run，不动设计）
#   ::align::Run left -apply              ;# 真正移动
#   ::align::Run dist-h -gap 20 -apply    ;# 水平等距，间距 20（数据库单位）
#
# 支持：left/right/top/bottom/hcenter/vcenter（对齐）、dist-h/dist-v（等距分布）
# 移动方式：DboPartInst_SetLocation / DboGraphicInstance_SetLocation（实测签名 self,location）
# 显示属性：DboDisplayProp_SetLocation（标注跟着对齐）
# 导线：没有可靠的移动 API（只有 SetBoundingBox），默认跳过并在报告里列出
#
# 算法（与官方 capAlignObject 同思路）：
#   1) 收集每个对象的包围盒 → 取 TL/BR 两点
#   2) 按对齐方式算目标 x/y（基准 = 所有对象的外接框，或 pivot 对象）
#   3) 逐个 SetLocation；失败进错误清单，最后统一报告
# 说明：本文件是"模板"，未在 GUI 里跑过；先用 dry-run 核对计划再 -apply。

namespace eval ::align {
    variable mode ""
    variable gap 0
    variable apply 0
    variable errors {}
}

proc ::align::Box {obj} {
    set st [DboState]
    if {[catch {set box [$obj GetBoundingBox]} e]} { catch {$st -delete}; return "" }
    set tl [DboTclHelper_sGetCRectTopLeft $box]
    set br [DboTclHelper_sGetCRectBottomRight $box]
    set x1 [DboTclHelper_sGetCPointX $tl]; set y1 [DboTclHelper_sGetCPointY $tl]
    set x2 [DboTclHelper_sGetCPointX $br]; set y2 [DboTclHelper_sGetCPointY $br]
    DboTclHelper_sDeleteCPoint $tl; DboTclHelper_sDeleteCPoint $br; DboTclHelper_sDeleteCRect $box
    catch {$st -delete}
    return [list $x1 $y1 $x2 $y2]
}

proc ::align::Kind {obj} {
    if {[catch {set t [$obj GetObjectType]} e]} { return "unknown" }
    if {$t == $::DboBaseObject_PLACED_INSTANCE} { return "part" }
    if {$t == $::DboBaseObject_DRAWN_INSTANCE || $t == $::DboBaseObject_GRAPHIC_INSTANCE} { return "graphic" }
    if {$t == $::DboBaseObject_DISPLAY_PROP} { return "label" }
    if {$t == $::DboBaseObject_WIRE_SCALAR || $t == $::DboBaseObject_WIRE_BUS} { return "wire" }
    return "other"
}

proc ::align::Run {mode args} {
    variable gap; variable apply; variable errors
    set apply 0
    set gap 0
    foreach {k v} $args {
        switch -- $k {
            -apply { set apply 1 }
            -gap   { set gap $v }
            default { error "未知参数 $k" }
        }
    }
    set errors {}
    set objects {}
    if {[catch {set objects [GetSelectedObjects]} e]} { error "取选中对象失败：$e" }
    if {[llength $objects] < 2} { error "至少选中 2 个对象" }

    # 1) 收集
    set items {}
    set skipped {}
    foreach obj $objects {
        set kind [::align::Kind $obj]
        if {$kind eq "wire" || $kind eq "other"} {
            lappend skipped "$kind:[catch {$obj GetId} id] $id"
            continue
        }
        set b [::align::Box $obj]
        if {![llength $b]} { lappend skipped "$kind:no-bbox"; continue }
        lappend items [list $obj $kind {*}$b]
    }
    if {[llength $items] < 2} { error "可对齐对象不足（跳过：[join $skipped {; }]）" }

    # 2) 计算外接框与目标
    set minX ""; set minY ""; set maxX ""; set maxY ""
    foreach it $items {
        lassign $it obj kind x1 y1 x2 y2
        if {$minX eq "" || $x1 < $minX} { set minX $x1 }
        if {$minY eq "" || $y1 < $minY} { set minY $y1 }
        if {$maxX eq "" || $x2 > $maxX} { set maxX $x2 }
        if {$maxY eq "" || $y2 > $maxY} { set maxY $y2 }
    }
    set plan {}
    switch -- $mode {
        left    { foreach it $items { lappend plan [list $it [list dx [expr {$minX - [lindex $it 2]}] dy 0]] } }
        right   { foreach it $items { lappend plan [list $it [list dx [expr {$maxX - [lindex $it 4]}] dy 0]] } }
        top     { foreach it $items { lappend plan [list $it [list dx 0 dy [expr {$maxY - [lindex $it 3]}]]] } }
        bottom  { foreach it $items { lappend plan [list $it [list dx 0 dy [expr {$minY - [lindex $it 5]}]]] } }
        hcenter { set cx [expr {($minX + $maxX) / 2}]
                  foreach it $items { set w [expr {[lindex $it 4] - [lindex $it 2]}]
                      lappend plan [list $it [list dx [expr {$cx - ([lindex $it 2] + $w/2)}] dy 0]] } }
        vcenter { set cy [expr {($minY + $maxY) / 2}]
                  foreach it $items { set h [expr {[lindex $it 5] - [lindex $it 3]}]
                      lappend plan [list $it [list dx 0 dy [expr {$cy - ([lindex $it 3] + $h/2)}]]] } }
        dist-h  - dist-v {
            set horiz [expr {$mode eq "dist-h"}]
            set sorted [lsort -command [expr {$horiz ? {apply {{a b} {expr {[lindex $a 2] - [lindex $b 2]}}}} : {apply {{a b} {expr {[lindex $a 3] - [lindex $b 3]}}}}} $items]
            set n [llength $sorted]
            if {$n < 3} { error "等距分布至少要 3 个对象" }
            set first [lindex $sorted 0]; set last [lindex $sorted end]
            if {$horiz} { set span [expr {[lindex $last 2] - [lindex $first 2]}] } else { set span [expr {[lindex $last 3] - [lindex $first 3]}] }
            set total 0
            foreach it $sorted { set total [expr {$total + ($horiz ? ([lindex $it 4]-[lindex $it 2]) : ([lindex $it 5]-[lindex $it 3]))}] }
            set free [expr {$span - $total}]
            set step [expr {$free / ($n - 1)}]
            if {$gap > 0} { set step $gap }
            set cursor [expr {$horiz ? [lindex $first 2] : [lindex $first 3]}]
            foreach it $sorted {
                set w [expr {$horiz ? ([lindex $it 4]-[lindex $it 2]) : ([lindex $it 5]-[lindex $it 3])}]
                if {$horiz} { lappend plan [list $it [list dx [expr {$cursor - [lindex $it 2]}] dy 0]] } \
                else { lappend plan [list $it [list dx 0 dy [expr {$cursor - [lindex $it 3]}]]] }
                incr cursor [expr {$w + $step}]
            }
        }
        default { error "未知对齐方式：$mode（left/right/top/bottom/hcenter/vcenter/dist-h/dist-v）" }
    }

    # 3) 执行或打印
    set moved 0
    foreach p $plan {
        lassign $p it delta
        lassign $it obj kind x1 y1 x2 y2
        lassign $delta dx dy
        if {$dx == 0 && $dy == 0} continue
        if {!$apply} { puts [format "  plan %-6s dx=%-6s dy=%-6s" $kind $dx $dy]; incr moved; continue }
        set st [DboState]
        set ok 1
        switch -- $kind {
            part - graphic - label {
                set loc [$obj GetLocation $st]
                if {$loc eq "NULL"} { set ok 0 } else {
                    set nx [expr {[DboTclHelper_sGetCPointX $loc] + $dx}]
                    set ny [expr {[DboTclHelper_sGetCPointY $loc] + $dy}]
                    DboTclHelper_sDeleteCPoint $loc
                    set np [DboTclHelper_sMakeCPoint $nx $ny]
                    if {[catch {set s2 [$obj SetLocation $np]} e]} { set ok 0 } else {
                        set okw [$s2 OK]; $s2 -delete
                        if {!$okw} { set ok 0 }
                        if {$ok} { catch {$obj MarkModified} }
                    }
                    DboTclHelper_sDeleteCPoint $np
                }
            }
        }
        if {$ok} { incr moved } else { lappend ::align::errors "$kind move failed" }
        catch {$st -delete}
    }
    puts [format "%s: %d 个对象，移动 %d，跳过 %d%s" \
        [expr {$apply ? "applied" : "dry-run"}] [llength $items] $moved [llength $skipped] \
        [expr {[llength $::align::errors] ? "，错误 [llength $::align::errors]" : ""}]]
    if {[llength $::align::errors]} { foreach e $::align::errors { puts "  err: $e" } }
    return $moved
}

puts "::align::Run 已就绪（先不加 -apply 看计划）"
