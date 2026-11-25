# place-from-csv.tcl — 在 Capture 内按 CSV 批量放置导线/网络标签/页间连接符/端口/连接点
#
# 用法（Capture 命令窗口）：
#     source <本文件>
#     ::placecsv::Run "D:/work/place.csv" --dry-run     ;# 只打印计划
#     ::placecsv::Run "D:/work/place.csv"               ;# 真正放置
#     ::placecsv::Run "D:/work/place.csv" --verify      ;# 放置后用 Dbo 回读计数
#
# CSV 表头（逗号分隔，允许空列）：
#     kind,x1,y1,x2,y2,name,lib,symbol
#
#   kind 取值：
#     wire      需要 x1,y1,x2,y2
#     junction / noconnect        需要 x1,y1
#     alias                       需要 x1,y1,name
#     offpage / port / power / ground   需要 x1,y1,lib,symbol,name
#
# 例：
#     kind,x1,y1,x2,y2,name,lib,symbol
#     wire,100,100,200,100,,,
#     alias,150,100,,,VDD_3V3,,
#     offpage,300,100,,,VDD_3V3,CAPSYM,OFFPAGELEFT-R
#     junction,100,100,,,,
#
# 设计原则：
#   1. 放置命令失败是**抛异常**（例：无页时 RuntimeError: Command Requires SchematicView），
#      所以每条都 catch，逐行记账，不让一行失败打断整批；
#   2. 开头先取 GetActivePage 做前置检查，取不到就直接报错退出；
#   3. --dry-run 只打印计划和前置检查结果，不调用任何 Place*；
#   4. 全输出 ASCII，避免脚本按系统编码解释导致乱码。

namespace eval ::placecsv {
    variable stats
    variable errors
}

proc ::placecsv::Reset {} {
    variable stats
    variable errors
    set stats [dict create ok 0 fail 0 skip 0]
    set errors {}
}

proc ::placecsv::Bump {k} {
    variable stats
    dict incr stats $k
}

proc ::placecsv::Num {v} {
    if {![string is double -strict $v]} { return "" }
    return $v
}

# 解析一行 CSV（支持双引号包裹）
proc ::placecsv::SplitCsv {line} {
    set out {}; set cur ""; set inQ 0
    foreach ch [split $line ""] {
        if {$ch eq "\""} { set inQ [expr {!$inQ}]; continue }
        if {$ch eq "," && !$inQ} { lappend out $cur; set cur ""; continue }
        append cur $ch
    }
    lappend out $cur
    return $out
}

proc ::placecsv::ReadCsv {path} {
    set rows {}
    set fh [open $path r]
    fconfigure $fh -encoding utf-8
    set idx 0
    while {[gets $fh line] >= 0} {
        incr idx
        set line [string trim $line]
        if {$line eq "" || [string index $line 0] eq "#"} continue
        set f [::placecsv::SplitCsv $line]
        if {$idx == 1 && [string tolower [lindex $f 0]] eq "kind"} continue
        lappend rows [list $idx $f]
    }
    close $fh
    return $rows
}

# 一条放置：返回 {ok|fail|skip message}
proc ::placecsv::DoOne {kind x1 y1 x2 y2 name lib symbol} {
    switch -- $kind {
        wire {
            if {$x1 eq "" || $y1 eq "" || $x2 eq "" || $y2 eq ""} { return [list skip "wire needs x1 y1 x2 y2"] }
            set code [catch {PlaceWire $x1 $y1 $x2 $y2} r]
        }
        junction {
            if {$x1 eq "" || $y1 eq ""} { return [list skip "junction needs x1 y1"] }
            set code [catch {PlaceJunction $x1 $y1} r]
        }
        noconnect {
            if {$x1 eq "" || $y1 eq ""} { return [list skip "noconnect needs x1 y1"] }
            set code [catch {PlaceNoConnect $x1 $y1} r]
        }
        alias {
            if {$x1 eq "" || $y1 eq "" || $name eq ""} { return [list skip "alias needs x1 y1 name"] }
            set code [catch {PlaceNetAlias $x1 $y1 $name} r]
        }
        offpage - port - power - ground {
            if {$x1 eq "" || $y1 eq "" || $lib eq "" || $symbol eq "" || $name eq ""} {
                return [list skip "$kind needs x1 y1 lib symbol name"]
            }
            switch -- $kind {
                offpage { set code [catch {PlaceOffPage $x1 $y1 $lib $symbol $name} r] }
                port    { set code [catch {PlacePort    $x1 $y1 $lib $symbol $name} r] }
                power   { set code [catch {PlacePower   $x1 $y1 $lib $symbol $name} r] }
                ground  { set code [catch {PlaceGround  $x1 $y1 $lib $symbol $name} r] }
            }
        }
        default { return [list skip "unknown kind: $kind"] }
    }
    if {$code} { return [list fail [string range $r 0 160]] }
    return [list ok ""]
}

# 用 Dbo 回读当前页的对象计数（只在有 Dbo 与真实页时可用）
proc ::placecsv::Counts {page} {
    if {[llength [info commands DboState]] == 0} { return "" }
    set st [DboState]
    set out {}
    foreach spec {
        {wires   NewWiresIter           NextWire            delete_DboPageWiresIter}
        {parts   NewPartInstsIter       NextPartInst        delete_DboPagePartInstsIter}
        {offpage NewOffPageConnectorsIter NextOffPageConnector delete_DboPageOffPageConnectorsIter}
    } {
        lassign $spec label mkmethod itermethod delcmd
        set n 0
        if {![catch {set it [$page $mkmethod $st]}] && $it ne "NULL"} {
            for {set o [$it $itermethod $st]} {$o ne "NULL"} {set o [$it $itermethod $st]} { incr n }
            catch {$delcmd $it}
        }
        lappend out "$label=$n"
    }
    catch {$st -delete}
    return [join $out " "]
}

proc ::placecsv::Run {csvFile args} {
    variable stats
    variable errors
    set dry 0
    set verify 0
    foreach a $args {
        switch -- $a {
            --dry-run { set dry 1 }
            --verify  { set verify 1 }
            default   { error "unknown option: $a" }
        }
    }
    ::placecsv::Reset

    if {![file isfile $csvFile]} { error "csv not found: $csvFile" }

    # 前置检查：必须有打开的页；放置命令在无页时抛 RuntimeError
    set page ""
    if {[catch {set page [GetActivePage]} e]} {
        error "no schematic page open (Place* requires a schematic view): $e"
    }
    puts "page ok, mode=[expr {$dry ? "dry-run" : "place"}]"

    set rows [::placecsv::ReadCsv $csvFile]
    set n [llength $rows]
    puts "rows=$n"

    if {$dry} {
        foreach row $rows {
            lassign $row idx f
            while {[llength $f] < 8} { lappend f "" }
            lassign $f kind x1 y1 x2 y2 name lib symbol
            puts [format "  #%-4s %-9s (%s,%s)-(%s,%s) name=%s lib=%s sym=%s" \
                $idx $kind $x1 $y1 $x2 $y2 $name $lib $symbol]
        }
        puts "dry-run: nothing placed"
        return 0
    }

    foreach row $rows {
        lassign $row idx f
        while {[llength $f] < 8} { lappend f "" }
        lassign $f kind x1 y1 x2 y2 name lib symbol
        set kind [string tolower [string trim $kind]]
        lassign [::placecsv::DoOne $kind $x1 $y1 $x2 $y2 $name $lib $symbol] status msg
        ::placecsv::Bump $status
        if {$status eq "ok"} {
            puts [format "  #%-4s %-9s ok" $idx $kind]
        } else {
            puts [format "  #%-4s %-9s %s: %s" $idx $kind $status $msg]
            if {$status eq "fail"} { lappend errors "row $idx: $msg" }
        }
    }

    if {$verify} {
        set c [::placecsv::Counts $page]
        if {$c eq ""} { puts "verify: skipped (no Dbo)" } else { puts "verify: $c" }
    }

    puts [format "done: ok=%d fail=%d skip=%d" [dict get $stats ok] [dict get $stats fail] [dict get $stats skip]]
    if {[llength $errors]} {
        puts "errors:"
        foreach e $errors { puts "  $e" }
    }
    return [dict get $stats ok]
}

puts "::placecsv::Run <csv> ?--dry-run? ?--verify?  ready"
