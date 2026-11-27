# export-host-commands.tcl (v2) — 在 **Capture 内部**导出宿主命令面
#
# v2 相比 v1 的变化：
#   1) arity 探测覆盖到 Place* / Add* / Register* / Cap*（零参调用，最安全的情形）
#   2) 结果写成 **arity-probe.tsv**（cmd / 类别 / 参数名或类型 / 原始报错），可直接排序筛选
#   3) 新增 namespace-procs.txt：每个命名空间下的 proc **带参数名**（`info args`）
#   4) 新增 place-and-cap.txt：Place*/Cap*/Add*/Register* 单独成表
#   5) report.txt 里内建"关键命令存在性核对"（RegisterAction/PlaceWire/…）
#
# 用法（Capture 命令窗口）：
#     source <本文件>
#     ::hostdump::Run                                   ;# 默认目录 + 全套探测
#     ::hostdump::Run D:/tmp/capture-host-v2            ;# 指定目录
#     ::hostdump::Run D:/tmp/x --no-probe               ;# 完全不调用任何命令
#     ::hostdump::Run D:/tmp/x --deep                   ;# 额外对 Get/Is/Has 试 1..4 个空参
#
# 安全边界：
#   * 默认只做**零参**调用；零参时放置类命令会在参数检查阶段就报错，不会进入交互；
#   * 跳过名字含 exit/quit/delete/remove/close/open/save/load/run/exec/reset/clear 的命令；
#   * 跳过 `*WithDialog`（弹窗会阻塞 Capture）；
#   * 全程不注册、不修改设计、不保存。

namespace eval ::hostdump {
    variable outdir ""
    variable errors {}
    variable probeCount 0
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

# 解析一条零参调用的报错，返回 {kind arity detail}
proc ::hostdump::ParseErr {msg} {
    set msg [string map {"\n" " "} $msg]
    # 形态1: Wrong number of arguments :cmd a b c  argument 1
    if {[regexp {Wrong number of arguments :(\S+)((?:\s+\S+)*?)\s+argument\s+(\d+)} $msg -> cmd params idx]} {
        set plist [regexp -all -inline {\S+} $params]
        return [list wrongnum [llength $plist] [join $plist " "]]
    }
    # 形态2: TypeError in method 'X', argument N of type 'T'
    if {[regexp {argument (\d+) of type '([^']+)'} $msg -> pos typ]} {
        return [list typeerror $pos $typ]
    }
    if {[regexp {No matching function for overloaded '([^']+)'} $msg -> m]} {
        return [list overloaded "" $m]
    }
    if {$msg eq ""} { return [list ok 0 ""] }
    return [list other "" [string range $msg 0 120]]
}

proc ::hostdump::Run {args} {
    variable outdir
    variable errors
    variable probeCount
    set outdir ""
    set probe 1
    set deep 0
    set probePlace 0
    set probePdf 0
    set probeBom 0
    foreach a $args {
        switch -- $a {
            --no-probe { set probe 0 }
            --deep        { set deep 1 }
            --probe-place { set probePlace 1 }
            --probe-pdf   { set probePdf 1 }
            --probe-bom   { set probeBom 1 }
            default    { set outdir $a }
        }
    }
    if {$outdir eq ""} {
        if {[info exists ::env(TEMP)]} {
            set outdir [file join $::env(TEMP) capture-host-export-v2]
        } else {
            set outdir [file join [pwd] capture-host-export-v2]
        }
    }
    file mkdir $outdir
    set errors {}
    set probeCount 0

    # ---- 1) 全量命令 / 前缀分布 ----
    set all [lsort [info commands]]
    ::hostdump::W commands-all.txt [join $all "\n"]

    array set cnt {}
    foreach c $all {
        set p [lindex [split $c "_"] 0]
        if {[string length $p] > 28} { set p [string range $p 0 27] }
        if {[info exists cnt($p)]} { incr cnt($p) } else { set cnt($p) 1 }
    }
    set lines {}
    foreach p [lsort [array names cnt]] { lappend lines "$p\t$cnt($p)" }
    ::hostdump::W commands-prefix.tsv [join $lines "\n"]

    # ---- 2) 候选 / 放置与 Cap 专表 ----
    set interesting {}
    foreach c $all {
        if {[regexp -nocase -- {(action|menu|command|place|draw|add|create|new|delete|select|active|page|design|panel|dock|widget|tool|bar)} $c]} {
            lappend interesting $c
        }
    }
    ::hostdump::W commands-candidates.txt [join $interesting "\n"]

    set place {}
    foreach c $all {
        if {[regexp {^(Place|Cap|cap|Add|Register|Insert)} $c]} { lappend place $c }
    }
    ::hostdump::W place-and-cap.txt [join $place "\n"]

    # ---- 3) proc / 命名空间（带参数名）----
    set procs [lsort [info procs]]
    ::hostdump::W procs-all.txt [join $procs "\n"]

    set nsLines {}
    set nsProcLines {}
    foreach ns [lsort [namespace children ::]] {
        set ps {}
        catch {set ps [namespace eval $ns {info procs}]}
        set cs {}
        catch {set cs [namespace eval $ns {info commands}]}
        lappend nsLines "$ns\tprocs=[llength $ps]\tcmds=[llength $cs]"
        foreach p [lsort $ps] {
            set a {}
            catch {set a [namespace eval $ns [list info args $p]]}
            lappend nsProcLines "$ns\::$p\t[join $a { }]"
        }
    }
    ::hostdump::W namespaces.txt [join $nsLines "\n"]
    ::hostdump::W namespace-procs.txt [join $nsProcLines "\n"]

    # ---- 4) 包 / 环境 ----
    set pkLines {}
    foreach p [lsort [package names]] {
        set v ""
        catch {set v [package present $p]}
        lappend pkLines "$p\t$v"
    }
    ::hostdump::W packages.txt [join $pkLines "\n"]

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

    # ---- 5) 关键命令存在性 ----
    set keyCmds {
        RegisterAction InsertXMLMenu RefreshMenu GetSelectedObjects GetActivePage
        GetActivePMDesign capTrue PlaceWire PlacePart PlaceNetAlias PlaceOffPage
        PlacePort PlaceJunction PlaceNoConnect AddMenu AddAccessoryMenu AskUserInput
        AutoWire BusWire CapPdfPrint CapFindObjects ExecuteAction ExecuteCommand
    }
    set keyLines {}
    foreach k $keyCmds {
        set has [expr {[llength [info commands $k]] > 0 ? "YES" : "-"}]
        lappend keyLines "$k\t$has"
    }

    # ---- 6) arity 探测 ----
    set tsv [list [join {cmd kind arity_or_pos detail raw} "\t"]]
    if {$probe} {
        # default: read-only/query families only (zero-arg calls cannot start UI)
        set allow {^(Get|Is|Has|Can|Find|Query|List)}
        set block {exit|quit|delete|remove|close|open|save|load|\brun\b|exec|reset|clear|withdialog|drop|kill|placenext}
        if {$probePlace} { set allow {^(Get|Is|Has|Can|Find|Query|List|Place)} }
        if {$probePdf} { set allow {^(Get|Is|Has|Can|Find|Query|List|CapPdf)} }
        if {$probeBom} { set allow {^(Get|Is|Has|Can|Find|Query|List|CNewBOm|CVariant|DboTclBom|DBXMLWriter|orjson)} }
        set n 0
        foreach c $all {
            if {![regexp -- $allow $c]} { continue }
            if {[regexp -nocase -- $block $c]} { continue }
            incr n
            if {$n > 900} { lappend tsv "# truncated after 900 probes"; break }
            incr probeCount
            set code [catch {uplevel #0 [list $c]} r]
            lassign [::hostdump::ParseErr $r] kind arity detail
            set raw [string range [string map {"\n" " " "\t" " "} $r] 0 180]
            lappend tsv [join [list $c $kind $arity $detail $raw] "\t"]
        }
    } else {
        lappend tsv "# skipped (--no-probe)"
    }
    ::hostdump::W arity-probe.tsv [join $tsv "\n"]
    ::hostdump::W arity-probe.txt [join [lrange $tsv 0 400] "\n"]

    # ---- 7) 深探（可选，仅 Get/Is/Has，1..4 个空参）----
    if {$deep} {
        set dtsv [list [join {cmd arity detail} "\t"]]
        foreach c $all {
            if {![regexp {^(Get|Is|Has)} $c]} { continue }
            if {[regexp -nocase -- {exit|quit|delete|remove|close|open|save|load|exec} $c]} { continue }
            for {set k 1} {$k <= 4} {incr k} {
                set args {}
                for {set i 0} {$i < $k} {incr i} { lappend args "" }
                set code [catch {uplevel #0 [list $c {*}$args]} r]
                lassign [::hostdump::ParseErr $r] kind arity detail
                if {$kind ne "wrongnum" || $arity != $k} {
                    lappend dtsv [join [list $c $k "$kind $detail"] "\t"]
                    break
                }
            }
        }
        ::hostdump::W arity-deep.tsv [join $dtsv "\n"]
    }

    # ---- 8) 报告 ----
    set rep {}
    lappend rep "output_dir\t$outdir"
    lappend rep "tcl\t[info patchlevel]"
    lappend rep "commands\t[llength $all]"
    lappend rep "procs\t[llength $procs]"
    lappend rep "candidates\t[llength $interesting]"
    lappend rep "place_or_cap\t[llength $place]"
    lappend rep "probes\t$probeCount"
    lappend rep "deep\t$deep"
    lappend rep ""
    lappend rep "== key commands =="
    foreach l $keyLines { lappend rep $l }
    lappend rep ""
    lappend rep "== errors =="
    if {[llength $errors]} { foreach e $errors { lappend rep $e } } else { lappend rep "(none)" }
    ::hostdump::W report.txt [join $rep "\n"]

    puts "hostdump v2: [llength $all] commands / [llength $procs] procs / probes=$probeCount -> $outdir"
    return $outdir
}

puts "::hostdump::Run ?outdir? ?--no-probe? ?--deep? ?--probe-place? ?--probe-pdf? ?--probe-bom?  ready (v2)"
