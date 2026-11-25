# probe-design.tcl — 在 Capture 里"体检"当前设计（进程内运行，只读）。
#
# 用法（Capture 的 Tcl 控制台，或从 capAutoLoad 里 source 后手动调）：
#   source D:/work/probe-design.tcl
#   ::probe::Run
#
# 输出：TAB 分隔，直接可贴进 Excel / diff。
# 说明：全部是只读操作；不 MarkModified，不 Save*。
#       依赖宿主命令（GetActivePMDesign 等），headless tclsh 里跑不了。

namespace eval ::probe {}

# --- 安全读字符串：不登记到宿主（第二参 0），自己删 ------------------------
proc ::probe::Text {object method} {
    set ptr [DboTclHelper_sMakeCString "" 0]
    try {
        set st [$object $method $ptr]
        catch {$st -delete}
        return [DboTclHelper_sGetConstCharPtr $ptr]
    } finally { DboTclHelper_sDeleteCString $ptr }
}

# --- 读属性：返回 {exists value}，user=1 读本地值 --------------------------
proc ::probe::Prop {object name {user 0}} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString "" 0]
    try {
        if {$user} { set st [$object GetUserPropStringValue $n $v] } \
        else       { set st [$object GetEffectivePropStringValue $n $v] }
        set found [$st OK]; $st -delete
        return [list $found [DboTclHelper_sGetConstCharPtr $v]]
    } finally { DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v }
}

proc ::probe::Run {} {
    set design [GetActivePMDesign]
    if {$design eq "NULL" || $design eq ""} { error "请先打开一个设计" }
    set dname [::probe::Text $design GetName]
    set st [DboState]
    puts "design\t$dname"

    # --- 视图 → 原理图 → 页 → 器件实例 ------------------------------------
    # NewViewsIter 需要过滤位；GUI 内由宿主定义 $::IterDefs_SCHEMATICS。
    if {[info exists ::IterDefs_SCHEMATICS]} {
        set vi [$design NewViewsIter $st $::IterDefs_SCHEMATICS]
        set nView 0; set nPage 0; set nInst 0
        for {set view [$vi NextView $st]} {$view ne "NULL"} {set view [$vi NextView $st]} {
            incr nView
            set sch [DboViewToDboSchematic $view]
            set schName [::probe::Text $sch GetName]
            set pi [$sch NewPagesIter $st]
            for {set page [$pi NextPage $st]} {$page ne "NULL"} {set page [$pi NextPage $st]} {
                incr nPage
                set pageName [::probe::Text $page GetName]
                set ii [$page NewPartInstsIter $st]
                set cnt 0
                for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} {
                    incr cnt; incr nInst
                }
                delete_DboPagePartInstsIter $ii
                catch {$ii -delete}
                puts "page\t$schName\t$pageName\tinsts=$cnt"
            }
            delete_DboSchematicPagesIter $pi
            catch {$pi -delete}
        }
        delete_DboLibViewsIter $vi
        catch {$vi -delete}
        puts "summary\tviews=$nView pages=$nPage insts=$nInst"
    } else {
        puts "warn\t::IterDefs_SCHEMATICS 不存在，跳过视图遍历（headless？）"
    }

    # --- 当前选中 ---------------------------------------------------------
    set sel {}
    catch {set sel [GetSelectedObjects]}
    foreach obj $sel {
        set type [catch {$obj GetObjectType} t]; set t [lindex $t end]
        set id ""
        catch {set id [$obj GetId $st]}
        set des ""
        catch {set des [::probe::Text $obj GetDesignator]}
        lassign [::probe::Prop $obj Value] hasVal val
        puts "selected\ttype=$t\tid=$id\tdes=$des\tvalue=$val"
    }
    catch {$st -delete}
    return
}

puts "::probe::Run 已就绪；在 Capture 里执行 ::probe::Run"
