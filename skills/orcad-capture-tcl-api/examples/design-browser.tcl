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
                        # 全部折点：GetPointCount + GetPoint i（返回 CPoint 指针）
                        set cnt 0
                        catch {set cnt [$w GetPointCount $st]}
                        set pts {}
                        for {set k 0} {$k < $cnt} {incr k} {
                            set cp ""
                            if {[catch {set cp [$w GetPoint $k $st]}]} { continue }
                            if {$cp eq "NULL" || $cp eq ""} { continue }
                            set x [DboTclHelper_sGetCPointX $cp]
                            set y [DboTclHelper_sGetCPointY $cp]
                            catch {DboTclHelper_sDeleteCPoint $cp}
                            lappend pts "\[$x,$y\]"
                            if {$minX eq "" || $x < $minX} { set minX $x }
                            if {$maxX eq "" || $x > $maxX} { set maxX $x }
                            if {$minY eq "" || $y < $minY} { set minY $y }
                            if {$maxY eq "" || $y > $maxY} { set maxY $y }
                        }
                        if {[llength $pts] < 2} continue
                        lappend wires "\{\"n\":[jstr [readText $w GetNetName]],\"p\":\[[join $pts ,]\]\}"
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
.chip{display:inline-block;padding:1px 5px;margin:2px;border-radius:3px;cursor:pointer;color:#fff;font-size:11px}
#legend{padding:4px 10px;border-bottom:1px solid #eee;background:#fff;max-height:64px;overflow:auto}
</style>
<div id=app><aside id=tree></aside><main id=main>
<div id=bar><b id=ttl>-</b><input id=q placeholder="筛选位号" size=18><label><input id=cm type=checkbox checked> 网络配色</label><span id=st></span></div>
<div id=legend></div>
<div id=wrap><svg id=cv width=1 height=1></svg></div>
<div id=info>点页面看线框；点器件看封装与管脚。</div>
</main></div>}
puts $fh {<script id=data type="application/json">}
puts $fh "{\"design\":[jstr $dname],\"root\":[jstr $rootName],\"tree\":\[[join $treeRecs ,]\],\"pages\":\{[join $pagePairs ,]\},\"lib\":$libJson}"
puts $fh {</script>}
puts $fh {<script>
const D=JSON.parse(document.getElementById('data').textContent);
const PAL=['#1f77b4','#ff7f0e','#2ca02c','#d62728','#9467bd','#8c564b','#e377c2','#7f7f7f','#bcbd22','#17becf','#393b79','#637939','#8c6d31','#843c39','#7b4173','#5254a3','#6b6ecf','#9c9ede','#e6550d','#fd8d3c'];
const byId={};D.tree.forEach(n=>byId[n.id]=n);
const kids={};D.tree.forEach(n=>{if(n.parent)(kids[n.parent]=kids[n.parent]||[]).push(n.id)});
const pagesBySch={};Object.keys(D.pages).forEach(k=>{const p=D.pages[k];(pagesBySch[p.schematic]=pagesBySch[p.schematic]||[]).push(k)});
const cv=document.getElementById('cv'), legend=document.getElementById('legend');
const X=x=>x, Y=y=>-y;
let vb=null, curKey=null, drag=null, colorMode=true, selNet=null, netMap={};
function el(t,a,txt){const e=document.createElementNS('http://www.w3.org/2000/svg',t);for(const k in a)e.setAttribute(k,a[k]);if(txt!=null)e.textContent=txt;return e;}
function netColor(n){
  if(!n)return '#999';
  if(netMap[n])return netMap[n];
  let h=0;for(let i=0;i<n.length;i++)h=(h*31+n.charCodeAt(i))>>>0;
  return PAL[h%PAL.length];
}
function assignNets(wires){
  netMap={};const cnt={};wires.forEach(w=>{if(w.n)cnt[w.n]=(cnt[w.n]||0)+1});
  const list=Object.keys(cnt).sort((a,b)=>(cnt[b]-cnt[a])||(a<b?-1:1));
  const n=Math.max(list.length,12);
  list.forEach((nm,i)=>{netMap[nm]='hsl('+Math.round(i*360/n)+',66%,45%)'});
}
function applyVB(){if(vb)cv.setAttribute('viewBox',vb.x+' '+vb.y+' '+vb.w+' '+vb.h);}
function fit(){const p=D.pages[curKey];const e=p.extent,pad=40;
  vb={x:e[0]-pad,y:Y(e[3])-pad,w:(e[2]-e[0])+2*pad,h:(e[3]-e[1])+2*pad};applyVB();}
function paint(){
  document.querySelectorAll('polyline.w').forEach(pl=>{
    const g=pl.parentElement, n=g.getAttribute('data-net')||'';
    const base=colorMode?netColor(n):'#2b6';
    const on=selNet&&n===selNet;
    pl.style.stroke=base;
    pl.style.strokeWidth=on?3:1;
    pl.style.opacity=(selNet&&!on)?0.12:1;
  });
}
function buildLegend(wires){
  const cnt={};wires.forEach(w=>{if(w.n)cnt[w.n]=(cnt[w.n]||0)+1});
  const list=Object.keys(cnt).sort((a,b)=>cnt[b]-cnt[a]);
  legend.textContent='';
  if(!list.length){legend.textContent='(本页无网络名)';return;}
  const head=document.createElement('span');head.style.color='#888';head.style.marginRight='6px';
  head.textContent='网络('+list.length+'):';legend.appendChild(head);
  list.slice(0,24).forEach(n=>{
    const c=document.createElement('span');c.className='chip';
    c.style.background=netColor(n);c.textContent=n+'×'+cnt[n];
    c.onclick=()=>{selNet=(selNet===n?null:n);paint();
      document.getElementById('st').textContent=selNet?('net='+selNet):'已清除高亮';};
    legend.appendChild(c);
  });
  if(list.length>24){const more=document.createElement('span');more.style.color='#888';more.textContent=' …共'+list.length+'个';legend.appendChild(more);}
}
function showPage(key){
  const p=D.pages[key];if(!p)return;curKey=key;selNet=null;
  document.getElementById('ttl').textContent=p.schematic+' / '+p.page;
  while(cv.firstChild)cv.removeChild(cv.firstChild);
  assignNets(p.wires);
  p.wires.forEach(w=>{
    const pts=w.p||[];if(pts.length<2)return;
    const g=el('g',{'data-net':w.n||''});
    g.appendChild(el('polyline',{points:pts.map(q=>X(q[0])+','+Y(q[1])).join(' '),class:'w'}));
    g.style.cursor='pointer';
    g.onclick=ev=>{ev.stopPropagation();selNet=w.n||null;paint();
      document.getElementById('st').textContent=selNet?('net='+selNet):'已清除高亮';};
    cv.appendChild(g);
  });
  p.parts.forEach(pt=>{
    const g=el('g',{});
    g.appendChild(el('rect',{x:X(pt.x)-4,y:Y(pt.y)-4,width:8,height:8,class:'p'}));
    g.appendChild(el('text',{x:X(pt.x)+6,y:Y(pt.y)-5,class:'lbl'},pt.r||'?'));
    g.style.cursor='pointer';g.onclick=ev=>{ev.stopPropagation();showPart(pt)};
    cv.appendChild(g);
  });
  p.ports.forEach(po=>{
    cv.appendChild(el('circle',{cx:X(po.x),cy:Y(po.y),r:4,class:'pt'}));
    cv.appendChild(el('text',{x:X(po.x)+6,y:Y(po.y)+3,class:'pl'},po.name||''));
  });
  fit();paint();buildLegend(p.wires);
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
function schStats(sch){
  const ks=pagesBySch[sch]||[];let pg=0,pt=0;
  ks.forEach(k=>{pg++;pt+=(D.pages[k].parts||[]).length});
  return {pages:pg,parts:pt};
}
function nodeLabel(n){
  let s=n.path||'(root)';
  if(n.ref)s+='  '+n.ref;
  if(n.contents){const st=schStats(n.contents);s+='  -> '+n.contents+' ('+st.pages+'页/'+st.parts+'器件)';}
  return s;
}
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
cv.addEventListener('wheel',ev=>{
  if(!vb)return;ev.preventDefault();
  const r=cv.getBoundingClientRect();
  const px=vb.x+(ev.clientX-r.left)/r.width*vb.w;
  const py=vb.y+(ev.clientY-r.top)/r.height*vb.h;
  const k=ev.deltaY>0?1.15:1/1.15;
  vb={x:px-(px-vb.x)*k,y:py-(py-vb.y)*k,w:vb.w*k,h:vb.h*k};applyVB();
},{passive:false});
cv.addEventListener('mousedown',ev=>{if(!vb)return;drag={x:ev.clientX,y:ev.clientY,vb:Object.assign({},vb)};cv.style.cursor='grabbing'});
window.addEventListener('mousemove',ev=>{if(!drag||!vb)return;const r=cv.getBoundingClientRect();
  vb.x=drag.vb.x-(ev.clientX-drag.x)/r.width*drag.vb.w;
  vb.y=drag.vb.y-(ev.clientY-drag.y)/r.height*drag.vb.h;applyVB();});
window.addEventListener('mouseup',()=>{drag=null;cv.style.cursor=''});
cv.addEventListener('dblclick',()=>{if(curKey)fit()});
document.getElementById('cm').onchange=ev=>{colorMode=ev.target.checked;paint()};
const rootIds=D.tree.filter(n=>!n.parent).map(n=>n.id);
const tree=document.getElementById('tree');
if(!rootIds.length)tree.textContent='(无 occurrence)';
rootIds.forEach(r=>{const e=buildTree(r,0);if(e)tree.appendChild(e)});
const first=Object.keys(D.pages)[0];if(first)showPage(first);
document.getElementById('q').oninput=e=>{
  const v=(e.target.value||'').toLowerCase();
  document.querySelectorAll('#tree details').forEach(d=>{d.style.display=(!v||d.textContent.toLowerCase().includes(v))?'':'none';});
};
</script>}
close $fh
puts "ok occ=$nOcc pages=$nPage parts=$totalParts -> $outp"
puts "size=[file size $outp] bytes"
exit 0
