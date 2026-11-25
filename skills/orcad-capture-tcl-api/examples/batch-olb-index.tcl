# batch-olb-index.tcl — 无 GUI 枚举一个 .olb 的 Package / Part / Pin，输出 TSV。
#
#   tclsh batch-olb-index.tcl <dbo-dll> <input.olb> <out.tsv>
#
# 例：
#   $env:PATH = 'D:\Cadence\Cadence\SPB_17.4\tools\bin;' + $env:PATH
#   & 'D:\Cadence\Cadence\SPB_17.4\tools\bin\tclsh.exe' batch-olb-index.tcl `
#       'D:\Cadence\Cadence\SPB_17.4\tools\bin\orDb_Dll_Tcl64.dll' C:\work\lib.olb C:\work\lib.tsv
#
# 输出列：kind<TAB>pkg<TAB>part<TAB>pinpos<TAB>pinname<TAB>pintype<TAB>visible
# 设计要点（都来自实测踩坑）：
#   * CString 一律 sMakeCString <s> 0（不登记），自己删；
#   * 每个返回 DboState 的读取方法都要 $st -delete；
#   * 迭代器用同名 delete_ 命令释放，并补 catch {$it -delete}；
#   * 方法调用走对象形态（$obj Method），全局形态只覆盖声明类。

if {$argc < 3} { puts stderr "usage: tclsh batch-olb-index.tcl <dbo-dll> <input.olb> <out.tsv>"; exit 2 }
set dll    [lindex $argv 0]
set olb    [lindex $argv 1]
set outTsv [lindex $argv 2]

if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 3 }
if {![file isfile $olb]} { puts stderr "missing OLB: $olb"; exit 2 }

set sess [DboTclHelper_sCreateSession]
if {$sess eq "NULL"} { puts stderr "cannot create Dbo session"; exit 3 }
set st [DboState]

set pathPtr [DboTclHelper_sMakeCString $olb 0]
set lib [DboSession_GetLib $sess $pathPtr $st]
if {$lib eq "NULL" || [$st Failed]} {
    DboTclHelper_sDeleteCString $pathPtr; $st -delete
    DboTclHelper_sDeleteSession $sess
    puts stderr "cannot open OLB: $olb"; exit 4
}

set out [open $outTsv w]
fconfigure $out -translation lf -encoding utf-8

# --- Package 级 ------------------------------------------------------------
set pkgs [$lib NewPackagesIter $st]
set pkg [$pkgs NextPackage $st]
set nPkg 0
while {$pkg ne "NULL"} {
    incr nPkg
    set namePtr [DboTclHelper_sMakeCString "" 0]
    catch {$pkg GetName $namePtr}
    set pkgName [DboTclHelper_sGetConstCharPtr $namePtr]
    DboTclHelper_sDeleteCString $namePtr

    set fpPtr [DboTclHelper_sMakeCString "" 0]
    catch {$pkg GetPCBFootprint $fpPtr}
    set footprint [DboTclHelper_sGetConstCharPtr $fpPtr]
    DboTclHelper_sDeleteCString $fpPtr

    puts $out "package\t$pkgName\t\t\t\t\t$footprint"

    # --- Part（符号单元）级 ------------------------------------------------
    set parts [$pkg NewPartsIter $st]
    set part [$parts NextPart $st]
    while {$part ne "NULL"} {
        set pnPtr [DboTclHelper_sMakeCString "" 0]
        catch {$part GetName $pnPtr}
        set partName [DboTclHelper_sGetConstCharPtr $pnPtr]
        DboTclHelper_sDeleteCString $pnPtr

        set namesVis ""
        catch {set namesVis [$part GetPinNamesAreVisible $st]}
        set numsVis ""
        catch {set numsVis [$part GetPinNumbersAreVisible $st]}
        if {[$st Failed]} { set st [DboState] }
        puts $out "part\t$pkgName\t$partName\t\t\t\tnames=$namesVis numbers=$numsVis"

        # --- Pin 级 --------------------------------------------------------
        set pins [$part NewLPinsIter $st]
        set pin [$pins NextPin $st]
        while {$pin ne "NULL"} {
            set nPtr [DboTclHelper_sMakeCString "" 0]
            catch {$pin GetPinName $nPtr}
            set pinName [DboTclHelper_sGetConstCharPtr $nPtr]
            DboTclHelper_sDeleteCString $nPtr

            set pos "";  catch {set pos [$pin GetPinPosition $st]}
            set typ "";  catch {set typ [$pin GetPinType $st]}
            set vis "";  catch {set vis [$pin GetIsVisible $st]}
            puts $out "pin\t$pkgName\t$partName\t$pos\t$pinName\t$typ\t$vis"

            set pin [$pins NextPin $st]
        }
        delete_DboLibPartPinsIter $pins
        catch {$pins -delete}

        set part [$parts NextPart $st]
    }
    delete_DboPackagePartsIter $parts
    catch {$parts -delete}

    set pkg [$pkgs NextPackage $st]
}
delete_DboLibPackagesIter $pkgs
catch {$pkgs -delete}

# --- 特殊库兜底：capsym.olb / TitleBlock 这类库没有任何 Package，
# --- 只有 Symbol（实测 capsym.olb：packages=0, symbols=38: GND_EARTH/TitleBlock0...）
set nSym 0
if {$nPkg == 0} {
    set syms [$lib NewSymbolsIter $st]
    if {$syms ne "NULL"} {
        set sym [$syms NextSymbol $st]
        while {$sym ne "NULL"} {
            incr nSym
            set sPtr [DboTclHelper_sMakeCString "" 0]
            catch {$sym GetName $sPtr}
            puts $out "symbol\t[DboTclHelper_sGetConstCharPtr $sPtr]\t\t\t\t\t"
            DboTclHelper_sDeleteCString $sPtr
            set sym [$syms NextSymbol $st]
        }
        delete_DboLibSymbolsIter $syms
        catch {$syms -delete}
    }
}

close $out
catch {DboSession_RemoveLib $sess $lib}
DboTclHelper_sDeleteCString $pathPtr
catch {$st -delete}
DboTclHelper_sDeleteSession $sess
puts "packages=$nPkg symbols=$nSym -> $outTsv"
exit 0
