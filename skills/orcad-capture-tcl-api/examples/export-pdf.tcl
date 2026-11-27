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
#     --paper N|a4|letter|tabloid  PaperSize（索引或别名；3=Tabloid 11x17, 9=A4, 1=Letter）
#     --driver "名称"            PostscriptDriver
#
# 设计要点：
#   1. 前置：GetActivePMDesign 非 NULL；有 capIsPrinterDriverAvailable 就先问一句；
#   2. 每个 SetOption 之后用 CapPdfGetOption 回读并打印 —— 设置成功不等于生效；
#   3. CapPdfPrint 只报成败，真正判据是 `file exists` + 文件大小；
#   4. 全输出 ASCII。

namespace eval ::pdfexp {
    variable log {}
    # PaperSize 是索引；官方列表见 capPdfUtil::populatePaperSizeList（0..33）
    array set papers {
        default 0 letter 1 lettersmall 2 tabloid 3 ledger 4 legal 5 statement 6
        executive 7 a3 8 a4 9 a4small 10 a5 11 b4 12 b5 13 folio 14 quarto 15
        usletter 1 ustabloid 3 uslegal 5 usledger 4
    }
}

proc ::pdfexp::PaperIndex {v} {
    if {[string is integer -strict $v]} { return $v }
    set k [string tolower [string map {" " "" "-" "" "_" ""} $v]]
    if {[info exists ::pdfexp::papers($k)]} { return $::pdfexp::papers($k) }
    return $v
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

# 诊断：把 ini 里的 PDF 相关键、驱动可用性、转换器是否存在、输出目录内容都打出来
proc ::pdfexp::Diagnose {outDir} {
    foreach k {capPDFDriver capPDFCommandIndex capPDFPaperSize capPDFPrintingMode capPDFCreateNetAndBookmark capPDFCreatePropertiesFile} {
        set v ""
        catch {set v [GetOptionString $k]}
        ::pdfexp::Note "ini $k = «$v»"
    }
    set idx ""
    catch {set idx [GetOptionString capPDFCommandIndex]}
    if {$idx ne ""} {
        set cv ""
        catch {set cv [GetOptionString "capPDFCommand$idx"]}
        ::pdfexp::Note "ini capPDFCommand$idx = «$cv»"
    }
    if {[llength [info commands capIsPrinterDriverAvailable]]} {
        set a ""
        catch {set a [capIsPrinterDriverAvailable]}
        ::pdfexp::Note "capIsPrinterDriverAvailable = «$a»"
    }
    foreach exe {gswin64c gswin32c gs ps2pdf ps2pdf14} {
        set p ""
        catch {set p [auto_execok $exe]}
        if {$p ne ""} { ::pdfexp::Note "converter found: $exe -> $p" }
    }
    if {[file isdirectory $outDir]} {
        set files {}
        catch {set files [glob -nocomplain -directory $outDir *]}
        ::pdfexp::Note "outDir contains: [llength $files] file(s)"
        foreach f [lrange $files 0 9] { ::pdfexp::Note "  [file tail $f] ([file size $f] B)" }
    }
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

    # 驱动检查：官方 OrHandlerPDFExport::checkPrinterDriver 是带驱动名调用的
    set driverName "OrCADPS_17.4"
    catch { set ini ""; set ini [GetOptionString capPDFDriver]; if {$ini ne ""} { set driverName $ini } }
    if {[llength [info commands capIsPrinterDriverAvailable]]} {
        set avail ""
        catch {set avail [capIsPrinterDriverAvailable $driverName]}
        ::pdfexp::Note "driver «$driverName» available = «$avail»"
        if {$avail eq "" || $avail eq "0"} {
            ::pdfexp::Note "WARNING: driver unavailable -> CapPdfPrint will emit an empty PS (0 B) and no PDF"
        }
    }
    # 转换器是否在 PATH（官方 checkToolPath 用 lindex $cmd 0 + auto_execok）
    set idx ""
    catch {set idx [GetOptionString capPDFCommandIndex]}
    if {$idx ne ""} {
        set cmd ""
        catch {set cmd [GetOptionString "capPDFCommand$idx"]}
        set exe [lindex $cmd 0]
        if {$exe ne ""} {
            set found ""
            catch {set found [auto_execok $exe]}
            ::pdfexp::Note "converter exe «$exe» found = «$found»"
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
    if {$paper ne ""}  { ::pdfexp::SetOpt "PaperSize" [::pdfexp::PaperIndex $paper] }

    # 驱动：官方 setPdfGenerationOptions 总是设一次（ini capPDFDriver 优先，否则默认 Acrobat Distiller）
    if {$driver eq ""} {
        set driver "Acrobat Distiller"
        catch { set ini ""; set ini [GetOptionString capPDFDriver]; if {$ini ne ""} { set driver $ini } }
    }
    ::pdfexp::SetOpt "PostscriptDriver" $driver

    if {$dry} {
        ::pdfexp::Diagnose $outDir
        ::pdfexp::Note "dry-run: options applied, nothing printed"
        return 0
    }

    # ---- 打印：优先用官方编排 ::capPdfUtil::printPdf ----
    # 原因：裸调 CapPdfPrint 只走了"打印"这一步，而 PDF 的实际生成是
    # capPdfUtil::printPdfFromPS 用 mPSToPDFConverterCommand(gs) 把 .ps 转成 .pdf。
    # 官方编排会先 setOptionValues（初始化转换器命令与临时路径）再打印。
    set target [file join $outDir $outFile]
    set printed 0
    if {[catch {package require capPdfUtil}] == 0 && [llength [info commands ::capPdfUtil::printPdf]]} {
        # 把我们的选择写进 ini（setPdfGenerationOptions 就是从 ini 读的）
        catch {SetOptionString capPDFPaperSize [::pdfexp::PaperIndex $paper]}
        catch {SetOptionString capPDFDriver $driver}
        catch {SetOptionString capPDFCreatePropertiesFile [expr {$propspdf eq "True" ? "1" : "0"}]}
        catch {SetOptionString capPDFCreateNetAndBookmark [expr {($netmarks eq "True" || $refmarks eq "True") ? "1" : "0"}]}
        ::pdfexp::Note "using official orchestrator: ::capPdfUtil::printPdf"
        set code [catch {::capPdfUtil::printPdf $outDir $outFile} res]
        ::pdfexp::Note "printPdf code=$code ret=[string range $res 0 120]"
        set printed 1
    } else {
        ::pdfexp::Note "capPdfUtil not available -> raw CapPdfPrint (may only produce .ps)"
    }

    if {!$printed} {
    catch {file delete -force $target}
        set t0 [clock clicks -milliseconds]
        set code [catch {CapPdfPrint $outDir $outFile} res]
        set t1 [clock clicks -milliseconds]
        ::pdfexp::Note "CapPdfPrint code=$code ret=[string range $res 0 120] elapsed=[expr {$t1-$t0}]ms"
    }

    # ---- 回读校验 ----
    set produced {}
    catch {set produced [glob -nocomplain -directory $outDir *]}
    if {[llength $produced]} {
        foreach f [lrange $produced 0 9] { ::pdfexp::Note "outDir now has: [file tail $f] ([file size $f] B)" }
    }
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
