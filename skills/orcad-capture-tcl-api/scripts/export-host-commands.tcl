# export-host-commands.tcl — 在 **Capture 内部**运行，导出宿主命令面（headless 拿不到的那部分）
#
# 用法（在 Capture 的命令窗口 / 脚本窗口里）：
#     source <本文件路径>
#     ::hostdump::Run
# 或者指定输出目录：
#     ::hostdump::Run D:/tmp/capture-host-export
#
# 产出（UTF-8 纯文本，UTF-8 无 BOM）：
#   report.txt                 概要与统计（先看这个）
#   commands-all.txt           全部命令名（info commands，排序）
#   commands-prefix.tsv        前缀 → 数量（看家族分布）
#   commands-candidates.txt    与 action/菜单/放置/选中 相关的命令（最有价值）
#   procs-all.txt              全部 Tcl proc 名（info procs）
#   namespaces.txt             顶层命名空间及其 proc 数
#   packages.txt               已加载 package 及版本
#   env.txt                    Tcl/平台/安装路径等环境信息
#   arity-probe.txt            **对安全前缀做零参探测**，从报错文本反推参数名
#
# 说明：
#   * 全程不修改设计、不保存、不注册任何东西；
#   * arity 探测只对白名单前缀（capGet/capIs/capHas/Get/Is/Has 等）做**零参调用**，
#     并跳过含 exit/quit/delete/remove/close/open/save/load/run/exec 等词的名字；
#     如仍不放心，用 `::hostdump::Run <dir> --no-probe` 完全跳过探测。

namespace eval ::hostdump {
    variable outdir ""
    variable errors {}
}

proc ::hostdump::W {name content} {
    variable outdir
    set p [file join $outdir $name]
    set fh [open $p w]
    fconfigure $fh -encoding utf-8 -translation lf
    puts -nonewline $fh $content
    close $fh
    return $p
}

proc ::hostdump::Section {label script} {
    variable errors
    set code [catch {uplevel 1 $script} res]
    if {$code} {
        lappend errors "$label: $res"
        return ""
    }
    return $res
}

proc ::hostdump::Run {args} {
    variable outdir
    variable errors
    set outdir ""
    set probe 1
    foreach a $args {
        if {$a eq "--no-probe"} { set probe 0 } else { set outdir $a }
    }
    if {$outdir eq ""} {
        if {[info exists ::env(TEMP)]} {
            set outdir [file join $::env(TEMP) capture-host-export]
        } else {
            set outdir [file join [pwd] capture-host-export]
        }
    }
    file mkdir $outdir
    set errors {}

    # ---- 1) 全部命令 ----
    set all [lsort [info commands]]
    ::hostdump::W commands-all.txt [join $all "\n"]
    set nAll [llength $all]

    # ---- 2) 前缀分布 ----
    array set cnt {}
    foreach c $all {
        set p [lindex [split $c "_"] 0]
        if {[string length $p] > 28} { set p [string range $p 0 27] }
        if {[info exists cnt($p)]} { incr cnt($p) } else { set cnt($p) 1 }
    }
    set lines {}
    foreach p [lsort [array names cnt]] { lappend lines "$p\t$cnt($p)" }
    ::hostdump::W commands-prefix.tsv [join $lines "\n"]

    # ---- 3) 关心的命令（action / 菜单 / 放置 / 选中 / 设计 / 页）----
    set interesting {}
    foreach c $all {
        if {[regexp -nocase -- {(action|menu|command|place|draw|add|create|new|delete|select|active|page|design|panel|dock|widget|tool|bar)} $c]} {
            lappend interesting $c
        }
    }
    ::hostdump::W commands-candidates.txt [join $interesting "\n"]
    set nInt [llength $interesting]

    # ---- 4) proc 与命名空间 ----
    set procs [lsort [info procs]]
    ::hostdump::W procs-all.txt [join $procs "\n"]
    set nProc [llength $procs]

    set nsLines {}
    foreach ns [lsort [namespace children ::]] {
        set ps {}
        catch {set ps [namespace eval $ns {info procs}]}
        set cs {}
        catch {set cs [namespace eval $ns {info commands}]}
        lappend nsLines "$ns\tprocs=[llength $ps]\tcmds=[llength $cs]"
    }
    ::hostdump::W namespaces.txt [join $nsLines "\n"]

    # ---- 5) 包 ----
    set pkLines {}
    foreach p [lsort [package names]] {
        set v ""
        catch {set v [package present $p]}
        lappend pkLines "$p\t$v"
    }
    ::hostdump::W packages.txt [join $pkLines "\n"]

    # ---- 6) 环境 ----
    set envLines {}
    lappend envLines "tcl_patchlevel\t[info patchlevel]"
    lappend envLines "tcl_library\t[info library]"
    lappend envLines "nameofexecutable\t[info nameofexecutable]"
    if {[llength [info commands binary]]} { lappend envLines "cmd_bytes\t[string length [binary format c 1]]" }
    foreach k {tcl_platform(platform) tcl_platform(os) tcl_platform(machine) tcl_platform(byteOrder) tcl_platform(wordSize) tcl_platform(threaded)} {
        if {[info exists ::$k]} { lappend envLines "$k\t[set ::$k]" }
    }
    foreach v {HOME CDS_SITE CDS_INST_DIR CADENCE_DIR TEMP USERPROFILE} {
        if {[info exists ::env($v)]} { lappend envLines "env:$v\t$::env($v)" }
    }
    ::hostdump::W env.txt [join $envLines "\n"]

    # ---- 7) 安全的 arity 探测（零参，从报错文本拿参数名）----
    if {$probe} {
        set allow {^(capGet|capIs|capHas|capCan|capTrue|Get|Is|Has|Find|Query|List)}
        set block {exit|quit|delete|remove|close|open|save|load|run|exec|exitapp|kill|drop|reset|clear}
        set probeLines {}
        set n 0
        foreach c $all {
            if {![regexp -- $allow $c]} { continue }
            set lc [string tolower $c]
            if {[regexp -- $block $lc]} { continue }
            incr n
            if {$n > 400} { lappend probeLines "# (truncated after 400 probes)"; break }
            set code [catch {uplevel #0 [list $c]} r]
            set r [string map {"\n" " "} $r]
            if {[string length $r] > 200} { set r [string range $r 0 199] }
            lappend probeLines "$c\tcode=$code\t$r"
        }
        ::hostdump::W arity-probe.txt [join $probeLines "\n"]
    } else {
        ::hostdump::W arity-probe.txt "(skipped: --no-probe)"
    }

    # ---- 8) 报告 ----
    set rep {}
    lappend rep "output_dir\t$outdir"
    lappend rep "tcl\t[info patchlevel]"
    lappend rep "commands\t$nAll"
    lappend rep "procs\t$nProc"
    lappend rep "candidates\t$nInt"
    lappend rep "probe\t[expr {$probe ? "on" : "off"}]"
    lappend rep ""
    lappend rep "== errors =="
    if {[llength $errors]} { foreach e $errors { lappend rep $e } } else { lappend rep "(none)" }
    ::hostdump::W report.txt [join $rep "\n"]

    puts "hostdump: $nAll commands / $nProc procs -> $outdir"
    if {[llength $errors]} { puts "hostdump errors: [join $errors {; }]" }
    return $outdir
}

puts "::hostdump::Run ?outdir? ?--no-probe?  ready"
