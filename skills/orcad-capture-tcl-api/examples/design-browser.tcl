# design-browser.tcl — headless：把 .dsn 的层级 + 每一页的图元 + 可选 OLB 封装库，
# 打成一个**自包含单文件 HTML**（离线双击可看：左侧层级树、右侧页渲染、点器件看封装/管脚）。
#
#   tclsh design-browser.tcl <dbo-dll> <design.dsn> <out.html> ?--olb a.olb ?--olb b.olb ...?
#
# 设计取舍：
#   * 数据一次性内嵌到 HTML（<script type="application/json">），不依赖本地服务器，双击即用；
#   * 页渲染用 SVG 线框（导线 polyline、器件方块+位号、端口圆点），够核对结构，不追求像 Capture；
#   * 树节点与页按"原理图名"关联；点器件显示 位号/值/封装名，若 --olb 里有该封装则列出管脚。
# 只读：不 MarkModified、不 Save。大设计注意产物大小（每页图元都内嵌）。

if {$argc < 3} { puts stderr "usage: tclsh design-browser.tcl <dbo-dll> <dsn> <out.html> ?--olb file?..."; exit 2 }
set dll  [lindex $argv 0]
set dsn  [lindex $argv 1]
set outp [lindex $argv 2]
set olbs {}
set i 3
while {$i < $argc} {
    if {[lindex $argv $i] eq "--olb"} { incr i; lappend olbs [lindex $argv $i] }
    incr i
}
if {[catch {load $dll DboTclWriteBasic} e]} { puts stderr "LOADFAIL: $e"; exit 3 }
if {![file isfile $dsn]} { puts stderr "missing design: $dsn"; exit 2 }

proc mkc {v} { return [DboTclHelper_sMakeCString $v 0] }
proc readText {obj method} {
    set p [mkc ""]
    if {[catch {set st [$obj $method $p]} e]} { DboTclHelper_sDeleteCString $p; return "" }
    catch {$st -delete}
    set v [DboTclHelper_sGetConstCharPtr $p]
    DboTclHelper_sDeleteCString $p
    return $v
}
proc propOf {obj name} {
    set n [mkc $name]; set v [mkc ""]
    if {[catch {set st [$obj GetEffectivePropStringValue $n $v]}]} { set r "" } else {
        catch {$st -delete}
        set r [DboTclHelper_sGetConstCharPtr $v]
    }
    DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v
    return $r
}
proc jstr {s} {
    set o ""
    foreach ch [split $s ""] {
        switch -- $ch {
            "\"" { append o "\\\"" } "\\" { append o "\\\\" }
            "\n" { append o "\\n" } "\r" { append o "\\r" } "\t" { append o "\\t" }
            default { set c [scan $ch %c]; if {$c < 32} { append o [format "\\u%04x" $c] } else { append o $ch } }
        }
    }
    return "\"$o\""
}
proc Pt {obj method st} {
    set p ""
    if {[catch {set p [$obj $method $st]}]} { return "" }
    if {$p eq "NULL" || $p eq ""} { return "" }
    set x [DboTclHelper_sGetCPointX $p]; set y [DboTclHelper_sGetCPointY $p]
    catch {DboTclHelper_sDeleteCPoint $p}
    return [list $x $y]
}

set sess [DboTclHelper_sCreateSession]
set st   [DboState]

# ---------------- 2) 打开设计，先扫页 ----------------
set pathC [mkc $dsn]
set design [$sess GetDesign $pathC $st]
DboTclHelper_sDeleteCString $pathC
if {$design eq "NULL" || [$st Failed]} { puts stderr "cannot open design: $dsn"; exit 4 }
set dname [readText $design GetName]
set rootName [readText $design GetRootName]
puts "design=$dname root=$rootName"

set pagePairs {}
set wantFp [dict create]
set nPage 0
set totalParts 0
set vi "NULL"
if {![catch {set vi [$design NewViewsIter $st $::IterDefs_SCHEMATICS]}] && $vi ne "NULL"} {
    for {set view [$vi NextView $st]} {$view ne "NULL"} {set view [$vi NextView $st]} {
        set sch [DboViewToDboSchematic $view]
        set schName [readText $sch GetName]
        set pi "NULL"
        if {![catch {set pi [$sch NewPagesIter $st]}] && $pi ne "NULL"} {
            for {set page [$pi NextPage $st]} {$page ne "NULL"} {set page [$pi NextPage $st]} {
                incr nPage
                set pname [readText $page GetName]
                set minX ""; set minY ""; set maxX ""; set maxY ""
                set parts {}
                set nPart 0
                set ii "NULL"
                if {![catch {set ii [$page NewPartInstsIter $st]}] && $ii ne "NULL"} {
                    for {set inst [$ii NextPartInst $st]} {$inst ne "NULL"} {set inst [$ii NextPartInst $st]} {
                        incr nPart; incr totalParts
                        set ref [propOf $inst Reference]
                        if {$ref eq ""} { set ref [propOf $inst {Part Reference}] }
                        if {$ref eq ""} { set ref [readText $inst GetDesignator] }
                        set val [propOf $inst Value]
                        set fp  [propOf $inst {PCB Footprint}]
                        if {$fp ne ""} { dict set wantFp [string tolower $fp] 1 }
                        set loc [Pt $inst GetLocation $st]
                        if {[llength $loc] == 2} {
                            set x [lindex $loc 0]; set y [lindex $loc 1]
                            if {$minX eq "" || $x < $minX} { set minX $x }
                            if {$maxX eq "" || $x > $maxX} { set maxX $x }
                            if {$minY eq "" || $y < $minY} { set minY $y }
                            if {$maxY eq "" || $y > $maxY} { set maxY $y }
                            lappend parts "{\"r\":[jstr $ref],\"v\":[jstr $val],\"f\":[jstr $fp],\"x\":$x,\"y\":$y}"
                        }
                    }
                    catch {delete_DboPagePartInstsIter $ii}
                }
                set wires {}
                set wi "NULL"
                if {![catch {set wi [$page NewWiresIter $st]}] && $wi ne "NULL"} {
                    for {set w [$wi NextWire $st]} {$w ne "NULL"} {set w [$wi NextWire $st]} {
                        set s [Pt $w GetStartPoint $st]; set e [Pt $w GetEndPoint $st]
                        if {[llength $s] != 2 || [llength $e] != 2} continue
                        foreach pt [list $s $e] {
                            set x [lindex $pt 0]; set y [lindex $pt 1]
                            if {$minX eq "" || $x < $minX} { set minX $x }
                            if {$maxX eq "" || $x > $maxX} { set maxX $x }
                            if {$minY eq "" || $y < $minY} { set minY $y }
                            if {$maxY eq "" || $y > $maxY} { set maxY $y }
                        }
                        lappend wires "\[[lindex $s 0],[lindex $s 1],[lindex $e 0],[lindex $e 1]\]"
                    }
                    catch {delete_DboPageWiresIter $wi}
                }
                set ports {}
                set pi2 "NULL"
                if {![catch {set pi2 [$page NewPortInstsIter $st]}] && $pi2 ne "NULL"} {
                    for {set p [$pi2 NextPortInst $st]} {$p ne "NULL"} {set p [$pi2 NextPortInst $st]} {
                        set pos [Pt $p GetHotSpot $st]
                        if {[llength $pos] != 2} { set pos [Pt $p GetStartPoint $st] }
                        if {[llength $pos] != 2} continue
                        set x [lindex $pos 0]; set y [lindex $pos 1]
                        if {$minX eq "" || $x < $minX} { set minX $x }
                        if {$maxX eq "" || $x > $maxX} { set maxX $x }
                        if {$minY eq "" || $y < $minY} { set minY $y }
                        if {$maxY eq "" || $y > $maxY} { set maxY $y }
                        lappend ports "{\"name\":[jstr [readText $p GetPinName]],\"x\":$x,\"y\":$y}"
                    }
                    catch {delete_DboPagePortInstsIter $pi2}
                }
                if {$minX eq ""} { set minX 0; set minY 0; set maxX 1000; set maxY 1000 }
                set key "$schName|$pname"
                lappend pagePairs "[jstr $key]:\{\"schematic\":[jstr $schName],\"page\":[jstr $pname],\"extent\":\[$minX,$minY,$maxX,$maxY\],\"parts\":\[[join $parts ,]\],\"wires\":\[[join $wires ,]\],\"ports\":\[[join $ports ,]\]\}"
            }
            catch {delete_DboSchematicPagesIter $pi}
        }
    }
    catch {delete_DboLibViewsIter $vi}
}

# ---------------- 2.5) 可选：索引 OLB 库（只取设计引用到的封装）----------------
set libJson "{}"
set libPairs {}
foreach olb $olbs {
    set pathC [mkc $olb]
    set lib [DboSession_GetLib $sess $pathC $st]
    DboTclHelper_sDeleteCString $pathC
    if {$lib eq "NULL"} { puts stderr "skip olb: $olb"; continue }
    set it [$lib NewPackagesIter $st]
    for {set pkg [$it NextPackage $st]} {$pkg ne "NULL"} {set pkg [$it NextPackage $st]} {
        set nm [readText $pkg GetName]
        set fp [readText $pkg GetPCBFootprint]
        # 只索引设计里真正引用的封装，避免把整库塞进 HTML
        if {![dict exists $wantFp [string tolower $nm]] && ![dict exists $wantFp [string tolower $fp]]} continue
        set pins {}
        set pit [$pkg NewPartsIter $st]
        for {set part [$pit NextPart $st]} {$part ne "NULL"} {set part [$pit NextPart $st]} {
            set pinIt [$part NewLPinsIter $st]
            for {set pin [$pinIt NextPin $st]} {$pin ne "NULL"} {set pin [$pinIt NextPin $st]} {
                set pnum [readText $pin GetPinNumber]
                set pname [readText $pin GetPinName]
                set pos [Pt $pin GetHotSpot $st]
                lappend pins "{\"n\":[jstr $pnum],\"name\":[jstr $pname],\"x\":[lindex $pos 0],\"y\":[lindex $pos 1]}"
            }
            catch {delete_DboLibPartPinsIter $pinIt}
            break
        }
        catch {delete_DboPackagePartsIter $pit}
        lappend libPairs "[jstr [string tolower $nm]]:\{\"name\":[jstr $nm],\"fp\":[jstr $fp],\"pins\":\[[join $pins ,]\]\}"
    }
    catch {delete_DboLibPackagesIter $it}
    catch {DboSession_RemoveLib $sess $lib}
}
if {[llength $libPairs]} { set libJson "\{[join $libPairs ,]\}" }

# ---------------- 3) occurrence 树 ----------------
set treeRecs {}
set kidsOf [dict create]
set nOcc 0
catch {
    set root [$design GetRootOccurrence $st]
    if {$root ne "NULL"} {
        set queue [list [list $root "" 0]]
        while {[llength $queue]} {
            lassign [lindex $queue 0] occ parent depth
            set queue [lrange $queue 1 end]
            set oid ""; catch {set oid [$occ GetId $st]}
            incr nOcc
            set ref ""
            set inst "NULL"; catch {set inst [$occ GetPartInst $st]}
            foreach holder [list $occ $inst] {
                if {$holder eq "NULL"} continue
                set r [propOf $holder Reference]
                if {$r eq ""} { set r [propOf $holder {Part Reference}] }
                if {$r ne ""} { set ref $r; break }
            }
            if {$ref eq "" && $inst ne "NULL"} { set ref [readText $inst GetDesignator] }
            set path [readText $occ GetPathName]
            set contents ""
            set sch "NULL"
            if {![catch {set sch [$occ GetContents $st]}] && $sch ne "NULL"} { set contents [readText $sch GetName] }
            set kids {}
            if {$depth < 8} {
                set it "NULL"
                if {![catch {set it [$occ NewChildrenIter $st $::IterDefs_INSTS]}] && $it ne "NULL"} {
                    for {set c [$it NextOccurrence $st]} {$c ne "NULL"} {set c [$it NextOccurrence $st]} {
                        set child [DboOccurrenceToDboInstOccurrence $c]
                        set cid ""; catch {set cid [$child GetId $st]}
                        if {$cid ne ""} { lappend kids $cid; lappend queue [list $child $oid [expr {$depth+1}]] }
                    }
                    catch {delete_DboOccurrenceChildrenIter $it}
                    catch {$it -delete}
                }
            }
            set kj {}
            foreach k $kids { lappend kj [jstr $k] }
            lappend treeRecs "{\"id\":[jstr $oid],\"parent\":[jstr $parent],\"path\":[jstr $path],\"ref\":[jstr $ref],\"contents\":[jstr $contents],\"kids\":\[[join $kj ,]\]}"
        }
    }
}

catch {$sess RemoveDesign $design}
catch {$st -delete}
DboTclHelper_sDeleteSession $sess

# ---------------- 4) 写自包含 HTML ----------------
set fh [open $outp w]
fconfigure $fh -encoding utf-8 -translation lf
puts $fh "<!doctype html><meta charset=utf-8><title>[string map {< &lt; > &gt;} $dname] browser</title>"
puts $fh {<style>
*{box-sizing:border-box}body{margin:0;font:12px/1.5 Consolas,Menlo,monospace;color:#222}
#app{display:flex;height:100vh}
#tree{width:320px;border-right:1px solid #ddd;overflow:auto;padding:8px}
#main{flex:1;display:flex;flex-direction:column;min-width:0}
#bar{padding:6px 10px;border-bottom:1px solid #eee;display:flex;gap:10px;align-items:center}
#wrap{flex:1;overflow:auto;background:#fafafa}
#info{padding:8px 10px;border-top:1px solid #eee;min-height:64px;max-height:200px;overflow:auto;background:#fff}
svg{display:block}
details{margin-left:12px}summary{cursor:pointer}
.pg{cursor:pointer;color:#06c;margin-left:26px}
.pg:hover{text-decoration:underline}
.w{stroke:#2b6;stroke-width:1;fill:none}
.p{fill:#06c}.pt{fill:#c60}
.lbl{font-size:9px;fill:#06c}
.pl{font-size:9px;fill:#c60}
</style>
<div id=app><aside id=tree></aside><main id=main>
<div id=bar><b id=ttl>-</b><input id=q placeholder="筛选位号" size=18><span id=st></span></div>
<div id=wrap><svg id=cv width=1 height=1></svg></div>
<div id=info>点页面看线框；点器件看封装与管脚。</div>
</main></div>}
puts $fh {<script id=data type="application/json">}
puts $fh "{\"design\":[jstr $dname],\"root\":[jstr $rootName],\"tree\":\[[join $treeRecs ,]\],\"pages\":\{[join $pagePairs ,]\},\"lib\":$libJson}"
puts $fh {</script>}
puts $fh {<script>
const D=JSON.parse(document.getElementById('data').textContent);
const byId={};D.tree.forEach(n=>byId[n.id]=n);
const kids={};D.tree.forEach(n=>{if(n.parent)(kids[n.parent]=kids[n.parent]||[]).push(n.id)});
const pagesBySch={};Object.keys(D.pages).forEach(k=>{const p=D.pages[k];(pagesBySch[p.schematic]=pagesBySch[p.schematic]||[]).push(k)});
function el(t,a,txt){const e=document.createElementNS('http://www.w3.org/2000/svg',t);for(const k in a)e.setAttribute(k,a[k]);if(txt!=null)e.textContent=txt;return e;}
function showPage(key){
  const p=D.pages[key];if(!p)return;
  document.getElementById('ttl').textContent=p.schematic+' / '+p.page;
  const cv=document.getElementById('cv');while(cv.firstChild)cv.removeChild(cv.firstChild);
  const [x0,y0,x1,y1]=p.extent;const w=Math.max(1,x1-x0),h=Math.max(1,y1-y0);const pad=30;
  cv.setAttribute('viewBox',(-pad)+' '+(-pad)+' '+(w+2*pad)+' '+(h+2*pad));
  cv.setAttribute('width',Math.min(2400,w+2*pad));cv.setAttribute('height',Math.min(1600,h+2*pad));
  const X=x=>x-x0, Y=y=>y1-y;
  p.wires.forEach(wv=>{cv.appendChild(el('polyline',{points:X(wv[0])+','+Y(wv[1])+' '+X(wv[2])+','+Y(wv[3]),class:'w'}))});
  p.parts.forEach(pt=>{
    const g=el('g',{});
    g.appendChild(el('rect',{x:X(pt.x)-4,y:Y(pt.y)-4,width:8,height:8,class:'p'}));
    g.appendChild(el('text',{x:X(pt.x)+6,y:Y(pt.y)-5,class:'lbl'},pt.r||'?'));
    g.style.cursor='pointer';
    g.onclick=()=>showPart(pt);
    cv.appendChild(g);
  });
  p.ports.forEach(po=>{
    cv.appendChild(el('circle',{cx:X(po.x),cy:Y(po.y),r:4,class:'pt'}));
    cv.appendChild(el('text',{x:X(po.x)+6,y:Y(po.y)+3,class:'pl'},po.name||''));
  });
  document.getElementById('st').textContent='parts='+p.parts.length+' wires='+p.wires.length+' ports='+p.ports.length;
}
function showPart(pt){
  const box=document.getElementById('info');
  let h='<b>'+(pt.r||'(无位号)')+'</b> &nbsp; value='+(pt.v||'')+' &nbsp; footprint='+(pt.f||'(未填)');
  const pk=D.lib[(pt.f||'').toLowerCase()];
  if(pk){h+='<br>封装 <b>'+pk.name+'</b>：'+pk.pins.length+' 管脚<div style="margin-top:4px">'+pk.pins.slice(0,40).map(p=>'<code>'+p.n+':'+p.name+'</code>').join(' ')+(pk.pins.length>40?' …':'')+'</div>';}
  else if(pt.f){h+='<br><span style="color:#999">（OLB 里没有该封装：用 --olb 指定库再看管脚）</span>';}
  box.innerHTML=h;
}
function nodeLabel(n){let s=n.path||'(root)';if(n.ref)s+='  '+n.ref;if(n.contents)s+='  -> '+n.contents;return s;}
function buildTree(id,depth){
  const n=byId[id];if(!n)return null;
  const d=document.createElement('details');if(depth<2)d.open=true;
  const sm=document.createElement('summary');sm.textContent=nodeLabel(n);d.appendChild(sm);
  (pagesBySch[n.contents]||[]).forEach(k=>{
    const a=document.createElement('div');a.className='pg';a.textContent='页 '+D.pages[k].page;
    a.onclick=ev=>{ev.preventDefault();ev.stopPropagation();showPage(k)};d.appendChild(a);
  });
  (kids[id]||[]).forEach(c=>{const e=buildTree(c,depth+1);if(e)d.appendChild(e)});
  return d;
}
const rootIds=D.tree.filter(n=>!n.parent).map(n=>n.id);
const tree=document.getElementById('tree');
if(!rootIds.length)tree.textContent='(无 occurrence)';
rootIds.forEach(r=>{const e=buildTree(r,0);if(e)tree.appendChild(e)});
const first=Object.keys(D.pages)[0];if(first)showPage(first);
document.getElementById('q').oninput=e=>{
  const v=(e.target.value||'').toLowerCase();
  document.querySelectorAll('#tree summary').forEach(s=>{s.parentElement.style.display=(!v||s.textContent.toLowerCase().includes(v))?'':'none';});
};
document.getElementById('st').textContent='occ='+D.tree.length+' pages='+Object.keys(D.pages).length;
</script>}
close $fh
puts "ok occ=$nOcc pages=$nPage parts=$totalParts -> $outp"
puts "size=[file size $outp] bytes"
exit 0
