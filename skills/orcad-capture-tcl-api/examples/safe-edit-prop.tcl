# safe-edit-prop.tcl — 批量改属性：先读 before，写后回读校验，失败逆序回滚。
#
# 可以直接当库用：source 进插件即可。**纯 Tcl 8.4 兼容**（16.6 也能跑），
# 所以这里不用 dict / try / lassign 之外的新语法（lassign 是 8.5，本文件只在
# 8.6 分支用；8.4 走 list 索引）。
#
#   ::idz::EditAll <changes>
#     changes = {{<object> <propName> <newValue>} ...}
#
# 三条硬规则（源自实测）：
#   1. 写前必须读 before，用于"是否被别人改过"的判断与回滚；
#   2. 写后必须回读 —— DboState OK 不代表值真的落地；
#   3. 批量中任一项失败 → 逆序恢复已写项，再抛错，绝不半途保存。

namespace eval ::idz {
    variable haveLassign [expr {[llength [info commands lassign]] > 0}]
}

# 取列表第 i 个元素（8.4/8.6 通用，避免依赖 lassign）
proc ::idz::Nth {listValue i} { return [lindex $listValue $i] }

# 逆序（8.4 没有 lreverse）
proc ::idz::Reverse {values} {
    set out {}
    for {set i [expr {[llength $values] - 1}]} {$i >= 0} {incr i -1} {
        lappend out [lindex $values $i]
    }
    return $out
}

proc ::idz::Text {object method} {
    set ptr [DboTclHelper_sMakeCString "" 0]
    set code [catch {
        set st [$object $method $ptr]
        catch {$st -delete}
        DboTclHelper_sGetConstCharPtr $ptr
    } result]
    DboTclHelper_sDeleteCString $ptr
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $result }
    return $result
}

proc ::idz::Prop {object name {user 0}} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString "" 0]
    set code [catch {
        if {$user} { set st [$object GetUserPropStringValue $n $v] } \
        else       { set st [$object GetEffectivePropStringValue $n $v] }
        set found [$st OK]
        catch {$st -delete}
        list $found [DboTclHelper_sGetConstCharPtr $v]
    } result]
    DboTclHelper_sDeleteCString $n
    DboTclHelper_sDeleteCString $v
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $result }
    return $result
}

proc ::idz::Check {st} {
    set ok [$st OK]
    $st -delete
    if {!$ok} { error "Capture 拒绝该属性操作" }
}

# present=1 写值；present=0 删除实例覆盖（回落到继承值）
proc ::idz::Write {object name present value} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString $value 0]
    set code [catch {
        if {$present} {
            ::idz::Check [$object SetEffectivePropStringValue $n $v]
        } else {
            ::idz::Check [$object DeleteEffectiveProp $n]
        }
        ::idz::Check [$object MarkModified]
    } result]
    DboTclHelper_sDeleteCString $n
    DboTclHelper_sDeleteCString $v
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $result }
    return
}

# 返回写入条数；失败时抛错（已回滚）
proc ::idz::EditAll {changes} {
    set applied {}
    set code [catch {
        foreach c $changes {
            set object [::idz::Nth $c 0]
            set name   [::idz::Nth $c 1]
            set value  [::idz::Nth $c 2]

            set before [::idz::Prop $object $name]
            set beforeExists [::idz::Nth $before 0]
            set beforeValue  [::idz::Nth $before 1]
            lappend applied [list $object $name $beforeExists $beforeValue]

            ::idz::Write $object $name 1 $value

            set after [::idz::Prop $object $name]
            set afterExists [::idz::Nth $after 0]
            set afterValue  [::idz::Nth $after 1]
            if {!$afterExists || $afterValue ne $value} {
                error "回读不一致：$name 期望 {$value} 实际 {$afterValue}"
            }
        }
    } message]

    if {$code} {
        set failures {}
        foreach u [::idz::Reverse $applied] {
            set object      [::idz::Nth $u 0]
            set name        [::idz::Nth $u 1]
            set exists      [::idz::Nth $u 2]
            set value       [::idz::Nth $u 3]
            if {[catch {::idz::Write $object $name $exists $value} e]} { lappend failures $e }
        }
        if {[llength $failures]} {
            error "批量修改失败：$message；且恢复失败：[join $failures {; }]。请勿保存当前设计"
        }
        error "批量修改失败：$message（已回滚）"
    }
    return [llength $applied]
}

# 全部成功后才保存
proc ::idz::Commit {design} {
    set sess $::DboSession_s_pDboSession
    ::idz::Check [DboSession_MarkAllLibForSave $sess $design]
    ::idz::Check [DboSession_SaveDesign $sess $design]
    return
}

# ---- 用法 -----------------------------------------------------------------
# set changes {}
# foreach inst $insts {
#     lappend changes [list $inst "Manufacturer Part Number" "STM32F103C8T6"]
# }
# ::idz::EditAll $changes
# ::idz::Commit [GetActivePMDesign]
