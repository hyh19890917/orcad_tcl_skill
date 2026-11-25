# plugin-skeleton.tcl — 最小可用的 Capture 插件骨架：
#   菜单 → 建控制条 → 载入本地网页 → 网页用 executeTcl 回调 Tcl。
#
# 装法（二选一）：
#   A) 手动：Capture 里 `source D:/work/plugin-skeleton.tcl; ::demo::Init`
#   B) 自动：把本文件的 source 语句写进
#      <CadenceRoot>\tools\capture\tclscripts\capAutoLoad\demoInit.tcl
#      （技巧：hex 编码路径 + SourceUtf8，兼容 Tcl 8.4 的 source 编码问题）
#
# 兼容：Tcl 8.4（16.6）与 8.6。刻意不用 dict/try；UTF-8 用 encoding 显式切。

namespace eval ::demo {
    variable widget ""
    variable url    ""   ;# 例：http://127.0.0.1:8765
    variable token  ""   ;# 由你的后端下发；放 URL fragment，别放 query
    variable menuChecked 0
}

# ---- UTF-8 安全的 source（8.4 没有 source -encoding） ---------------------
proc ::demo::SourceUtf8 {path} {
    set prev [encoding system]
    encoding system utf-8
    set code [catch {uplevel #0 [list source $path]} result]
    if {$code == 1} { set trace $::errorInfo ; set detail $::errorCode }
    encoding system $prev
    if {$code == 1} { return -code error -errorinfo $trace -errorcode $detail $result }
    return -code $code $result
}

# ---- 菜单 / action -------------------------------------------------------
proc ::demo::Enabled {args} { return true }

proc ::demo::Init {} {
    # 固定 action id：宿主按 id 回调，重复注册是安全的
    RegisterAction "demoOpen"   "::demo::Enabled" "" "::demo::Open"   ""
    RegisterAction "demoClose"  "::demo::Enabled" "" "::demo::Close"  ""
    RegisterAction "_cdnOrOnPreExit" "::demo::Enabled" "" "::demo::PreExit" ""

    # XML 菜单：FindXMLMenu 返回字面量 "NULL" 表示不存在
    if {[FindXMLMenu [list "demoPlugin"]] eq "NULL"} {
        InsertXMLMenu [list [list "demoPlugin"] "" "" [list "popup" "Demo" "0"]]
    }
    foreach item {Open Close} {
        set path [list "demoPlugin" $item]
        if {[FindXMLMenu $path] ne "NULL"} { catch {DeleteXMLMenu $path} }
    }
    InsertXMLMenu [list [list "demoPlugin" "Open"] "" "" \
        [list "action" "Open panel" "0" "demoOpen" "demoOpen"]]
    InsertXMLMenu [list [list "demoPlugin" "Close"] "" "" \
        [list "action" "Close panel" "0" "demoClose" "demoClose"]]

    # 动态菜单钩子：Start Page / 设计视图都能出菜单（标题只用 ASCII）
    RegisterAction "_cdnCapTclAddPageCustomMenu"   "::demo::Enabled" "" "::demo::Menu" ""
    RegisterAction "_cdnCapTclAddDesignCustomMenu" "::demo::Enabled" "" "::demo::Menu" ""

    if {[llength [info commands RefreshMenu]]} { catch {RefreshMenu} }
    # 宿主会在 capAutoLoad 之后重建菜单，延迟复查一次
    after 1000 ::demo::EnsureMenu
}

proc ::demo::Menu {args} {
    catch {AddAccessoryMenu "Demo" "Open panel" "::demo::Open"}
}

proc ::demo::EnsureMenu {} {
    if {[FindXMLMenu [list "demoPlugin"]] ne "NULL"} { return }
    if {[catch {::demo::Init} e]} { ::demo::Log "菜单重建失败：$e" }
}

# ---- 面板 ----------------------------------------------------------------
proc ::demo::Open {args} {
    variable widget ; variable url ; variable token
    if {$url eq ""} {
        # 演示：让用户先调 ::demo::SetBackend <url> <token>
        ::demo::Log "先执行 ::demo::SetBackend http://127.0.0.1:PORT TOKEN"
        return
    }
    package require orPrmUtils
    if {$widget ne ""} {
        catch {orPrm::LoadResource $widget "$url/panel#$token"}
        catch {orPrm::ShowWidget $widget 1}
        return
    }
    # 17.4+ 有 CEF；16.6/17.2 只有 IE WebBrowser
    if {[lsearch -exact {16.6 17.2} [::demo::HostVersion]] < 0 && [info exists ::orPrm::WF_CEF]} {
        set widget [orPrm::CreateControlBar "Demo" $::orPrm::WDOCK_RIGHT $::orPrm::WDALLOW_RIGHT 420 $::orPrm::WF_CEF]
    } else {
        package require orPrmWebComp 1.0
        set widget [orPrm::CreateControlBar "Demo" $::orPrm::WDOCK_RIGHT $::orPrm::WDALLOW_RIGHT 420]
    }
    orPrm::LoadResource $widget "$url/panel#$token"
    orPrm::ShowWidget $widget 1
}

proc ::demo::Close {args} {
    variable widget
    if {$widget eq ""} { return }
    catch {orPrm::DestroyWidget $widget}
    set widget ""
}

proc ::demo::SetBackend {backendUrl tokenValue} {
    variable url ; variable token
    if {![regexp {^http://127\.0\.0\.1:[0-9]+$} $backendUrl]} { error "只接受本机回环地址" }
    if {![regexp {^[A-Za-z0-9_-]+$} $tokenValue]} { error "token 形态非法" }
    set url $backendUrl ; set token $tokenValue
}

# ---- 网页 → Tcl：唯一入口（白名单，绝不拼接任意代码） --------------------
proc ::demo::Call {action ticket} {
    variable token
    if {![regexp {^[0-9a-f]{32}$} $ticket]} { error "ticket 非法" }
    if {[lsearch -exact {ping snapshot} $action] < 0} { error "未支持的操作：$action" }
    switch -- $action {
        ping     { set data [list ok 1 host [::demo::HostVersion] token [expr {$token ne ""}]] }
        snapshot { set data [::demo::Snapshot] }
    }
    return [::demo::Json $data]
}

proc ::demo::Snapshot {} {
    set design [GetActivePMDesign]
    if {$design eq "NULL" || $design eq ""} { return [list design "" insts 0] }
    set name [::demo::Text $design GetName]
    set st [DboState]
    set page [GetActivePage]
    set n 0
    if {$page ne "NULL" && $page ne ""} {
        set it [$page NewPartInstsIter $st]
        for {set o [$it NextPartInst $st]} {$o ne "NULL"} {set o [$it NextPartInst $st]} { incr n }
        delete_DboPagePartInstsIter $it
        catch {$it -delete}
    }
    catch {$st -delete}
    return [list design $name insts $n]
}

# ---- 小工具 --------------------------------------------------------------
proc ::demo::Text {object method} {
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

# 极简 JSON 序列化（8.4 无 json 包时也能用）；生产代码请用 package require json
proc ::demo::Json {pairs} {
    set out "\["
    set first 1
    foreach {k v} $pairs {
        if {!$first} { append out "," }
        set first 0
        if {[string is integer -strict $v]} { append out "\"$k\":$v" } else { append out "\"$k\":\"$v\"" }
    }
    append out "\]"
    return $out
}

proc ::demo::HostVersion {} {
    if {[info exists ::demoHostVersion]} { return $::demoHostVersion }
    return ""
}

proc ::demo::Log {message} {
    set tokenText ""
    catch {set tokenText $::demo::token}
    if {$tokenText ne ""} { set message [string map [list $tokenText {<token>}] $message] }
    catch {puts "\[demo\] $message"}
}

# ---- 退出：只取消定时器，不销毁活跃 CEF 条（宿主自己拆） -----------------
proc ::demo::PreExit {args} {
    variable widget
    if {$widget ne ""} { catch {orPrm::ShowWidget $widget 0} }
    return
}

puts "demo 插件已载入：::demo::Init → ::demo::SetBackend <url> <token> → ::demo::Open"
