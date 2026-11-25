# dump-constants.tcl — 把宿主预置的全局常量（对象类型/值枚举/迭代器过滤位）导成 name=value
#
#   tclsh dump-constants.tcl <orDb_Dll_Tcl64.dll> <out.txt>
#
# 这些常量由 Dbo 扩展在初始化时注册到解释器全局命名空间，不需要 package require。

set dll [lindex $argv 0]
set outFile [lindex $argv 1]
if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 1 }

set fh [open $outFile w]
fconfigure $fh -translation lf -encoding utf-8
set n 0
foreach name [lsort [info globals]] {
    if {[string match "DboBaseObject_*" $name] || [string match "DboValue_*" $name] || [string match "IterDefs_*" $name]} {
        puts $fh "$name=[set ::$name]"
        incr n
    }
}
close $fh
puts "wrote=$n -> $outFile"
exit 0
