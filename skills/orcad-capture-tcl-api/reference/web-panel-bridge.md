# 网页面板桥：`orPrmConnector` ↔ `executeTcl` 的官方实现

前面几轮从"某个产品"身上看到过这个桥（面板用 `executeTcl` 调 Tcl）。这一轮在 Cadence 自带源码里找到了**服务端与客户端两侧的原始实现**，可以照抄。

## 1. 服务端：一个 POST 里 `eval`

`tools\capture\tclscripts\orPrmWebApp\tcl\orPrmServer.tcl` 的核心分支（原文）：

```tcl
set lMethod [getValSafe lPostParams "methodLabel"]
set lParams [getValSafe lPostParams "methodParams"]
set lResult {}
if { "executeTcl" == $lMethod } {
    set lResult [eval $lParams]
}
orPrmCGI::startContent $::orPrmCGI::nTYPE_JSON
puts -nonewline $lResult
orPrmCGI::endContent $::orPrmCGI::nTYPE_JSON
```

契约因此非常明确：

| 项 | 值 |
| --- | --- |
| 传输 | HTTP POST，表单字段 `methodLabel` / `methodParams` |
| 方法名 | `executeTcl`（唯一内建方法） |
| 语义 | **对 `methodParams` 直接 `eval`**，结果按 `application/json` 回写 |
| 返回值 | `eval` 的最后一条命令结果（自己返回合法 JSON 最省事） |

注意这是**任意 Tcl 执行**——没有白名单。面板只有落在 `127.0.0.1` 且受宿主生命周期保护时才安全；自己写插件时必须在 Tcl 侧加白名单（见 §4）。

## 2. 客户端：`window.external.orPrmConnector`

官方 `auto_test.tcl` 里的面板 HTML 片段（原文，已转义）：

```html
<script>
function schtoolSetText(t){document.getElementById('x').textContent=t;}
window.onload=function(){
  try{
    if(window.external && window.external.orPrmConnector){
      window.external.orPrmConnector(window.external.orPrmWidgetId,
        '::schtool::autotest::wpMsg {js-bridge-ok}');
    }
  }catch(e){}
};
</script>
```

两个要点：

1. **调用形态**：`orPrmConnector(widgetId, tclCommand)` —— 第二个参数就是一段 Tcl 命令字符串；
2. **必须做存在性判断**（`window.external && window.external.orPrmConnector`）—— 页面在普通浏览器里打开时没有这个对象，不判断会抛错。

## 3. 反方向（Tcl → 页面）：推 JS 进去

官方示例面板 `tclscripts\schtool\ui\webpanel.tcl` 是一份完整的对照实现，proc 清单就能看出套路：

| proc | 作用 |
| --- | --- |
| `::schtool::webpanel::exec {js}` | 把一段 JS 推进面板执行 |
| `::schtool::webpanel::jsStr {s}` | 转义成 JS 字符串字面量 |
| `::schtool::webpanel::status {t}` | 更新状态栏文字 |
| `::schtool::webpanel::pushDrc {dlist}` / `pushAttrs` | 把结构化数据推给页面 |
| `::schtool::webpanel::runCheck` / `saveAttrs` / `askDirty` | 页面发起的动作，落在 Tcl 侧 |

另一条 Tcl→页面的通道在 `capCreateSummaryHtml.tcl` 里能直接看到：

```tcl
OrDzServerInterface.sGetServerInterface().nativeCall("executeTcl", p_Command, p_fnClosure);
```

即通过宿主服务接口 `nativeCall("executeTcl", …)` 调用——这是"把命令交给页面执行"的底层入口，`exec` 之类封装都建在它上面。

## 4. 自己写面板时的最小骨架

```tcl
namespace eval ::MyPanel { variable ::MyPanel::w }

# 白名单：只允许这些命令从页面进来
proc ::MyPanel::dispatch {cmd args} {
    switch -- $cmd {
        refresh  { ::MyPanel::DoRefresh; return {"ok":true} }
        setProp  { lassign $args ref name value
                   ::MyPanel::SetProp $ref $name $value
                   return {"ok":true} }
        default  { return {"ok":false,"error":"unknown command"} }
    }
}

# 页面 → Tcl 的唯一入口（页面里调 orPrmConnector(widgetId, '::MyPanel::dispatch refresh')）
proc ::MyPanel::wpMsg {args} { return [::MyPanel::dispatch {*}$args] }

# Tcl → 页面
proc ::MyPanel::exec {js} { ::schtool::webpanel::exec $js }
```

三条实践规则：

1. **页面只准调一个入口**（`wpMsg`），入口内部按子命令分派并校验参数——`eval` 任意字符串是官方实现的默认行为，不是你应该继承的行为；
2. **返回值用 JSON**，因为服务端按 `nTYPE_JSON` 回写，非 JSON 会让前端 `JSON.parse` 失败；
3. **加载时就检测桥是否可用**：`window.external.orPrmConnector` 不存在时页面应进入只读/提示态，而不是报错。

## 5. 边界与未知

- 这套桥只在**宿主里的网页面板**生效；headless `tclsh` 里既没有 `orPrmConnector` 也没有 `orPrmServer`。
- 官方服务端只实现了 `executeTcl` 一个方法（`if { "executeTcl" == $lMethod }`），没有其它 methodLabel 分支——想做结构化接口，要么在 Tcl 侧分派（推荐），要么自己加分支。
- 面板框架包名是 `orPrmDesigner`（见 plugin-lifecycle.md），但它的 `pkgIndex.tcl` 不在 `tclscripts` 里——说明它由安装目录其它位置或二进制提供，**这一点尚未定位**。
