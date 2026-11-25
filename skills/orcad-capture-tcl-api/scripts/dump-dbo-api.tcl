# dump-dbo-api.tcl — enumerate the official Dbo Tcl API surface of a Cadence Capture install.
#
# The Dbo Tcl extension (orDb_Dll_Tcl*.dll) registers ONE global command per
# C++ class member plus the DboTclHelper_* marshalling functions, the
# DboSession_* statics, XMATIC_* converters and every iterator destructor.
# Enumerating them is the cheapest way to get the authoritative API list for a
# given release, without a Capture GUI.
#
#   tclsh dump-dbo-api.tcl <orDb_Dll_Tcl64.dll|orDb_Dll_Tcl.dll> ?outfile?
#
# Requirements: the DLL's own directory must be on PATH (cdsCommon etc.), and
# the tclsh pointer size must match the DLL. Capture 16.6 ships a 32-bit Tcl
# 8.4 plus tools\capture\orDb_Dll_Tcl.dll; 17.2+ ships 64-bit Tcl plus
# tools\bin\orDb_Dll_Tcl64.dll. A 32-bit tclsh cannot load the 64-bit DLL.
#
# Written for Tcl 8.4 (no dict, no try): it must run on the oldest supported
# interpreter.

if {$argc < 1} {
    puts stderr "usage: tclsh dump-dbo-api.tcl <dbo-dll> ?outfile?"
    exit 2
}
set dll [lindex $argv 0]
set outFile ""
if {$argc >= 2} { set outFile [lindex $argv 1] }

if {![file exists $dll]} {
    puts stderr "missing DLL: $dll"
    exit 2
}

if {[catch {load $dll DboTclWriteBasic} err]} {
    puts stderr "LOADFAIL: $err"
    puts stderr "hint: 32-bit tclsh needs orDb_Dll_Tcl.dll, 64-bit needs orDb_Dll_Tcl64.dll, and the DLL directory must be on PATH"
    exit 3
}

set all [lsort [info commands *]]

if {$outFile ne ""} {
    set fh [open $outFile w]
    fconfigure $fh -translation lf -encoding utf-8
    foreach c $all { puts $fh $c }
    close $fh
}

# Per-prefix census, so a diff between two releases shows what moved.
set groups {}
foreach c $all {
    if {[regexp {^(delete_Dbo[A-Za-z0-9]+)} $c -> prefix]} {
        set prefix delete_Dbo*
    } elseif {[regexp {^(XMATIC_)} $c -> prefix]} {
        set prefix XMATIC
    } elseif {[regexp {^(Dbo[A-Za-z0-9]+_)} $c -> prefix]} {
        # strip the trailing underscore for the count line
        set prefix [string range $prefix 0 end-1]
    } else {
        continue
    }
    if {[info exists counts($prefix)]} { incr counts($prefix) } else { set counts($prefix) 1 }
}
foreach k [lsort [array names counts]] {
    lappend groups [list $k $counts($k)]
}
puts "TOTAL=[llength $all]"
foreach g [lsort -integer -decreasing -index 1 $groups] {
    puts [format "%-28s %s" [lindex $g 0] [lindex $g 1]]
}
exit 0
