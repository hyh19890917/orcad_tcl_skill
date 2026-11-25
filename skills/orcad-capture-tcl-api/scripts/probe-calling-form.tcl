# probe-form.tcl — determine the *calling convention* of the Dbo Tcl API.
# Question: do objects answer to `$obj Method args...`, or to the registered
# global `Dbo<Class>_<Method> $obj args...`? Both may work; several official
# Cadence scripts use the object form, others use the global form.
# Run: tclsh probe-form.tcl <orDb_Dll_Tcl64.dll>

set dll [lindex $argv 0]
if {[catch {load $dll DboTclWriteBasic} e]} { puts "LOADFAIL: $e"; exit 1 }

set tmp [file join $env(TEMP) "dbo-probe[pid].olb"]
catch {file delete -force $tmp}

set s [DboTclHelper_sCreateSession]
puts "session=$s"
set st [DboState]

set path [DboTclHelper_sMakeCString $tmp]
set lib "NULL"
foreach form {
    {DboSession_CreateLib $s $path $st}
    {DboSession_CreateLib $s $path}
    {$s CreateLib $path $st}
} {
    set code [catch {uplevel #0 $form} r]
    puts [format "%-38s code=%s result=%s ok=%s" $form $code $r [expr {$st eq "" ? "?" : [$st OK]}]]
    if {!$code && $r ne "NULL" && $r ne ""} { set lib $r; break }
}

if {$lib eq "NULL"} { puts "NO LIB"; exit 2 }
puts "lib=$lib  iscommand=[llength [info commands $lib]]"

set name [DboTclHelper_sMakeCString]
puts "object form   : [$lib GetName $name] -> [DboTclHelper_sGetConstCharPtr $name]"
puts "global form   : [DboLib_GetName $lib $name] -> [DboTclHelper_sGetConstCharPtr $name]"
puts "wrong-arity   : [catch {DboLib_GetName $name} err] $err"

# type introspection
puts "typeof(lib)   : [$lib GetObjectType]"
puts "cmds named DboLib_1*: [llength [info commands DboLib_1*]]"

catch {DboSession_RemoveLib $s $lib}
catch {$s RemoveLib $lib}
DboTclHelper_sDeleteCString $path
DboTclHelper_sDeleteCString $name
$st -delete
DboTclHelper_sDeleteSession $s
catch {file delete -force $tmp}
exit 0
