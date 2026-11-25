# debug-olb.tcl <dbo-dll> <olb>  — 诊断为什么枚举为 0
set dll [lindex $argv 0]; set olb [lindex $argv 1]
load $dll DboTclWriteBasic
set s [DboTclHelper_sCreateSession]
set st [DboState]
set p [DboTclHelper_sMakeCString $olb 0]
set lib [DboSession_GetLib $s $p $st]
puts "lib=$lib failed=[$st Failed]"
set np [DboTclHelper_sMakeCString "" 0]
catch {$lib GetName $np}
puts "libname=[DboTclHelper_sGetConstCharPtr $np]"
puts "libtype=[catch {$lib GetObjectType} t] $t"
set it [$lib NewPackagesIter $st]
puts "iter=$it failed=[$st Failed]"
set n 0
set pkg [$it NextPackage $st]
while {$pkg ne "NULL"} {
    incr n
    if {$n <= 5} {
        set nm [DboTclHelper_sMakeCString "" 0]
        catch {$pkg GetName $nm}
        puts "  pkg#$n name=[DboTclHelper_sGetConstCharPtr $nm] type=[catch {$pkg GetObjectType} pt] $pt"
        DboTclHelper_sDeleteCString $nm
    }
    set pkg [$it NextPackage $st]
}
puts "packages=$n"
delete_DboLibPackagesIter $it
catch {$it -delete}
DboSession_RemoveLib $s $lib
DboTclHelper_sDeleteCString $p
catch {$st -delete}
DboTclHelper_sDeleteSession $s
exit 0
