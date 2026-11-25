# dump-dbo-signatures.tcl — recover the official parameter list of every Dbo
# Tcl command by invoking it with no arguments and reading the arity error.
#
# Why this works: the Dbo extension validates objc before touching arguments,
# and its error text is generated from a literal signature string, e.g.
#
#     % DboLib_GetName
#     Wrong number of arguments :DboLib_GetName self name  argument 2
#
# So the message itself documents the C++ member signature. This is the only
# way to learn parameter names/order without a header or a PDF.
#
# Only commands whose FIRST parameter is mandatory (self / iterator / path) are
# probed. Constructors (DboLib, DboPage, ...) and the effectful DboTclHelper_*
# singletons are deliberately skipped: a zero-argument call on those can really
# execute (registry cleanup, plugin re-registration, lite mode...).
#
# Output rows: <command>\t<code>\t<message>   (tab separated, appended, so a
# crash keeps everything already written; re-running resumes).
#
#   tclsh dump-dbo-signatures.tcl <dbo-dll> <out.tsv>

set dll [lindex $argv 0]
set outFile [lindex $argv 1]
if {[catch {load $dll DboTclWriteBasic} e]} { puts "LOADFAIL: $e"; exit 1 }

set done {}
if {[file exists $outFile]} {
    set fh [open $outFile r]
    fconfigure $fh -encoding utf-8
    while {[gets $fh line] >= 0} {
        if {$line eq ""} continue
        lappend done [lindex [split $line \t] 0]
    }
    close $fh
}
set out [open $outFile a]
fconfigure $out -translation lf -encoding utf-8

set n 0
foreach c [lsort [info commands *]] {
    if {[lsearch -exact $done $c] >= 0} continue
    if {![regexp {^(Dbo[A-Za-z0-9]+_[A-Za-z0-9_]+|delete_Dbo[A-Za-z0-9]+|XMATIC_[A-Za-z0-9]+)$} $c]} continue
    set code [catch {$c} msg]
    regsub -all {[\t\r\n]+} $msg { } msg
    puts $out "$c\t$code\t$msg"
    flush $out
    incr n
}
close $out
puts "probed=$n total_written=[expr {[llength $done] + $n}]"
exit 0
