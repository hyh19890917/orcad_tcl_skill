# export-pdf.tcl — 在 Capture 内把当前设计打印成 PDF（带设置 → 打印 → 回读校验）
#
# 用法（Capture 命令窗口）：
#     source <本文件>
#     ::pdfexp::Run "D:/tmp/out"                 ;# 用默认文件名
#     ::pdfexp::Run "D:/tmp/out" "board.pdf"     ;# 指定文件名
#     ::pdfexp::Run "D:/tmp/out" "" --paper 3 --landscape 1
#     ::pdfexp::Run "D:/tmp/out" "" --dry-run    ;# 只检查前置与选项，不打印
#
# 选项（对应 CapPdfSetOption，值一律用字符串 "True"/"False"，与官方一致）：
#     --instmode 0|1             InstMode
#     --netmarks 0|1             CreateNetBookMarks
#     --refmarks 0|1             CreateRefdesBookMarks
#     --propspdf 0|1             CreatePropertiesPdfFile
#     --landscape 0|1            LandscapeOrientation
#     --paper N                  PaperSize（**索引，不是纸张名**）
#     --driver "名称"            PostscriptDriver
#
# 设计要点：
#   1. 前置：GetActivePMDesign 非 NULL；有 capIsPrinterDriverAvailable 就先问一句；
#   2. 每个 SetOption 之后用 CapPdfGetOption 回读并打印 —— 设置成功不等于生效；
#   3. CapPdfPrint 只报成败，真正判据是 `file exists` + 文件大小；
#   4. 全输出 ASCII。

namespace eval ::pdfexp {
    variable log {}
}

proc ::pdfexp::Note {msg} {
    variable log
    lappend log $msg
    puts "  $msg"
}

proc ::pdfexp::SetOpt {name value} {
    if {[catch {CapPdfSetOption $name $value} e]} {
        ::pdfexp::Note "set $name = $value -> FAILED: [string range $e 0 120]"
        return 0
    }
    set back ""
    catch {set back [CapPdfGetOption $name]}
    ::pdfexp::Note "set $name = $value (readback: $back)"
    return 1
}

proc ::pdfexp::Run {outDir args} {
    variable log
    set log {}
    set outFile ""
    set dry 0
    set paper ""
    set driver ""

    # 位置参数：第二个非选项参数是文件名
    set positional {}
    set i 0
    foreach a $args {
        switch -- $a {
            --dry-run { set dry 1 }
            default {
                if {[string index $a 0] eq "-"} { incr i; continue }
                lappend positional $a
            }
        }
        incr i
    }
    # 解析 --key value 形式
    set instmode "True"; set netmarks "True"; set refmarks "True"
    set propspdf "False"; set landscape "False"
    for {set k 0} {$k < [llength $args]} {incr k} {
        set a [lindex $args $k]
        switch -- $a {
            --instmode  { incr k; set instmode  [expr {[lindex $args $k] ? "True" : "False"}] }
            --netmarks  { incr k; set netmarks  [expr {[lindex $args $k] ? "True" : "False"}] }
            --refmarks  { incr k; set refmarks  [expr {[lindex $args $k] ? "True" : "False"}] }
            --propspdf  { incr k; set propspdf  [expr {[lindex $args $k] ? "True" : "False"}] }
            --landscape { incr k; set landscape [expr {[lindex $args $k] ? "True" : "False"}] }
            --paper     { incr k; set paper    [lindex $args $k] }
            --driver    { incr k; set driver   [lindex $args $k] }
        }
    }
    if {[llength $positional] >= 1} { set outFile [lindex $positional 0] }
    if {$outFile eq ""} { set outFile "capture-export.pdf" }

    foreach c {GetActivePMDesign CapPdfSetOption CapPdfGetOption CapPdfPrint} {
        if {[llength [info commands $c]] == 0} { error "not in Capture (missing $c)" }
    }

    # ---- 前置 ----
    set design "NULL"
    catch {set design [GetActivePMDesign]}
    if {$design eq "NULL" || $design eq ""} { error "no active design" }
    ::pdfexp::Note "design ok"

    if {[llength [info commands capIsPrinterDriverAvailable]]} {
        set avail ""
        catch {set avail [capIsPrinterDriverAvailable]}
        ::pdfexp::Note "printer driver available: $avail"
        if {$avail ne "" && ![string is true -strict $avail] && $avail ne "1"} {
            ::pdfexp::Note "WARNING: driver reported unavailable, continuing anyway"
        }
    }

    if {![file isdirectory $outDir]} {
        if {[catch {file mkdir $outDir} e]} { error "cannot create outDir: $e" }
        ::pdfexp::Note "created outDir $outDir"
    }

    # ---- 选项 ----
    ::pdfexp::SetOpt "InstMode" $instmode
    ::pdfexp::SetOpt "CreateNetBookMarks" $netmarks
    ::pdfexp::SetOpt "CreateRefdesBookMarks" $refmarks
    ::pdfexp::SetOpt "CreatePropertiesPdfFile" $propspdf
    ::pdfexp::SetOpt "LandscapeOrientation" $landscape
    if {$paper ne ""}  { ::pdfexp::SetOpt "PaperSize" $paper }
    if {$driver ne ""} { ::pdfexp::SetOpt "PostscriptDriver" $driver }

    if {$dry} {
        ::pdfexp::Note "dry-run: options applied, nothing printed"
        return 0
    }

    # ---- 打印 ----
    set target [file join $outDir $outFile]
    catch {file delete -force $target}
    set t0 [clock clicks -milliseconds]
    set code [catch {CapPdfPrint $outDir $outFile} res]
    set t1 [clock clicks -milliseconds]
    ::pdfexp::Note "CapPdfPrint code=$code ret=[string range $res 0 120] elapsed=[expr {$t1-$t0}]ms"

    # ---- 回读校验 ----
    set ok 0
    if {[file exists $target]} {
        set size [file size $target]
        ::pdfexp::Note "file exists: $target ([format %.1f [expr {$size/1024.0}]] KB)"
        set ok [expr {$size > 0}]
    } else {
        ::pdfexp::Note "file NOT created: $target"
    }
    if {!$ok} {
        ::pdfexp::Note "result: FAILED (print returned ok but no file)"
        return 1
    }
    ::pdfexp::Note "result: OK"
    return 0
}

puts "::pdfexp::Run <outDir> ?fileName? ?--paper N? ?--driver name? ?--landscape 0|1? ?--dry-run?  ready"
