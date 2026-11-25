# Capture 宿主命令（非 Dbo）

这些命令由 **Capture.exe 自身**或 Cadence 的 Tcl 扩展注册，不在 `orDb_Dll_Tcl*.dll` 里，因此**无法用 `dump-dbo-api.tcl` 枚举**，也没有 `info args`（原生命令）。下表是可用参数的实证清单：`证据` 列说明是实测、来自宿主脚本，还是仅来自调用点。

> 用法前提：这些命令只在 **Capture 进程内的 Tcl 解释器**里存在。headless tclsh 里没有。

## 1. 菜单与 action

| 命令 | 形态 | 证据 |
| --- | --- | --- |
| `RegisterAction <id> <enabledProc> <flag> <callback> <flag2>` | 5 参 | 实测（一个成熟插件注册了 10 个 id） |
| `InsertXMLMenu <spec>` | 1 参：list of lists | 实测 |
| `FindXMLMenu <pathList>` | 返回 id 或字面量 `"NULL"` | 实测 |
| `DeleteXMLMenu <pathList>` | 删除子树 | 实测 |
| `RefreshMenu` | 无参 | 实测（先 `info commands RefreshMenu` 判存在） |
| `AddAccessoryMenu <menu> <label> <command>` | 3 参 | 实测（动态菜单里用） |

菜单 spec 的两种叶子：

```tcl
# popup：建子菜单节点
InsertXMLMenu [list [list "myPlugin"] "" "" [list "popup" "My Plugin" "0"]]

# action：菜单项 = {action <标题> <flag> <actionId> <enabledActionId>}
InsertXMLMenu [list [list "myPlugin" "Run"] "" "" \
    [list "action" "Run" "0" "myOpenAction" "myOpenAction"]]
```

内置钩子 action id（注册后由宿主在合适时机回调，用来"动态加菜单"）：

| action id | 触发时机 | 回调约定 |
| --- | --- | --- |
| `_cdnCapTclAddPageCustomMenu` | Start Page / 页面视图 | 回调里调 `AddAccessoryMenu` |
| `_cdnCapTclAddDesignCustomMenu` | 设计视图 | 同上 |
| `_cdnOrOnPreExit` | Capture 退出前 | 清理定时器、注销回调；**不要**在这里销毁活跃 CEF 控制条 |
| `_cdnOrNotifyObjectSelect` / `_cdnOrNotifyObjectDeSelect` | 选中/取消选中 | 会**逐对象**触发，需要去抖 |
| `_cdnOrSchViewCmdComplete` | 原理图视图命令完成 | 第一个实参是命令名（如 `sRotate`、`OnLButtonUp`、`OnActivateView`） |

## 2. 文档 / 视图 / 选择

| 命令 | 返回 | 说明 |
| --- | --- | --- |
| `GetActivePMDesign` | `DboDesign` 或 `"NULL"` | 当前设计；`"NULL"` 时先报错给用户 |
| `GetActivePage` | `DboPage` 或 `"NULL"` | 当前页 |
| `GetSelectedObjects` | 对象列表 | 混合类型，需逐个 `GetObjectType` |
| `GetInstanceOccurrence` | `DboInstOccurrence` | 当前层级分支（层级设计才有意义） |
| `capGetIsSchematicEditingDisabled` | 0/1 | **1 = 不可编辑**；先判这个再动手 |
| `capGetMostRecentSchFrameID` | **CString 指针** | 必须 `DboTclHelper_sGetConstCharPtr` 取值 |
| `capGetIsViewerMode` | 0/1 | 只读查看模式（写操作前拦截） |
| `ui::SchematicActivate <frameId>` | — | 激活原理图窗口；**这也是唯一的刷新手段** |
| `OPage <schematic> <page> [branch]` | — | 直接打开页（不发工程树事件） |
| `UnSelectAll` / `SelectObjectById <id>` / `ZoomSelection` | — | 定位三连 |
| `IsSchematicViewActive` | 0/1 | 16.6 的旧式判据（新版本用 `capGetIsSchematicEditingDisabled`） |

刷新惯用法（Capture 没有 Redraw）：

```tcl
catch {ui::SchematicActivate [DboTclHelper_sGetConstCharPtr [capGetMostRecentSchFrameID]]}
```

## 3. 放置器件（三个版本三种签名）

```tcl
PlaceNew    <olb> <part> <unitIndex>                    ;# 16.6 / 17.2
PlacePartEx <olb> <part> <device> 0 {} {}               ;# 早期 17.4（6 参重载）
PlacePartEx <olb> <part> <device> 0 {} {} 1             ;# >= 22.1（第 7 参：继承 Characteristic 显示行）
```

- 都是"光标跟随放置"，由宿主负责旋转/Esc/重复放置/Undo，不要自己循环。
- 放置前必须：可编辑页（§2 判定）+ 目标库已被 `GetOpenLib`/`GetUpdatedPackage` 刷新（新加的符号才可见）。
- `PlacePartEx` 会重建标注并隐藏业务属性；要保留实例值与显示默认，用 `PlaceNew`（16.6/17.2 上这就是正确选择）。

## 4. 控制条（`orPrm::`）——Web 面板的唯一入口

实现位于 **`orPrmWebCompIE64.dll`**（本机在 177 个 `or*`/`cds*` DLL 中唯一定点命中 `WF_CEF` / `CreateControlBar` / `GetNativeHandle` / `IsContolBarVisible` 的模块）。命名空间常量也由它导出。

| 命令 | 说明 |
| --- | --- |
| `package require orPrmWebComp 1.0` | 载入扩展（旧版 IE WebBrowser 控件） |
| `orPrm::CreateControlBar <title> <dock> <allow> <width> ?WF_CEF?` | 建停靠控制条；返回 widget id |
| `orPrm::CreateWidget <WTYPE_DIALOG> ?WF_CEF?` | 建浮动窗 |
| `orPrm::LoadResource <widget> <url>` | 载入 URL（`http://127.0.0.1:PORT/panel?...`） |
| `orPrm::ShowWidget <widget> <0/1>` | 显隐 |
| `orPrm::IsContolBarVisible <widget>` | 可见性（**宿主拼写就是 `IsContol`**，不是笔误） |
| `orPrm::Execute <widget> <jsCode>` | 在页面里执行 JS |
| `orPrm::GetNativeHandle <widget>` | 取 HWND（布局吸附、原生裁剪用） |
| `orPrm::RegisterCloseTclFn <widget> <proc>` / `DeRegisterCloseTclFn` | 关闭回调（浮窗必须注册） |
| `orPrm::DestroyWidget <widget>` | 销毁；**退出路径上别对活跃 CEF 条调用** |
| `orPrm::IsWidget <widget>` | 存活探测 |
| `orPrm::SetTitle` / `SetWindowPos <w> <flag> <x> <y> <cx> <cy>` / `SetResizable` | 浮窗属性 |
| 常量 | `::orPrm::WDOCK_RIGHT` `WDALLOW_RIGHT` `WTYPE_DIALOG` `WF_CEF` |

版本行为：16.6 / 17.2 只有 IE WebBrowser；17.4+ 若存在 `::orPrm::WF_CEF` 则用 CEF。CEF 在宿主退出/Ota 重开时会先卸 libcef 再回调（崩溃点），必要时用保活模块（见 SKILL.md §11.6）。

## 5. 网页 ↔ Tcl 桥：`executeTcl`

```js
// CEF（17.4+）
var closure = OrDzCallBackManager.createClosure(null, cb, []);
OrDzServerInterface.sGetServerInterface().nativeCall('executeTcl', '::myPlugin::Run 1a2b...', closure);

// IE WebBrowser（16.6 / 17.2）
window.external.orPrmConnector('executeTcl', '::myPlugin::Run 1a2b...');
```

宿主探测（Cadence 自己的 `orPrmJSLayerLoader` 也这么做）：

```js
var cef = window.OrDzServerInterface && window.OrDzCallBackManager && OrDzServerInterface.isHosted();
var ie  = window.external && window.external.orPrmWidgetId != null;   // IE 的 COM dispatch 会谎报 undefined
```

安全要点：桥的入参必须是**你自己解析的受限形态**（常见做法是白名单正则：命令名枚举 + 32 位 hex ticket + 坐标限长），永远不要拼接任意 Tcl 片段。

## 6. 其它可用但少用的宿主能力（来自 `DboState_*` 的静态成员）

`DboState` 上挂了一批"全局功能"命令，它们在 Tcl 里注册成 `DboState_<名>`（第一参为 `pDesign*` 等）：

| 命令 | 用途 |
| --- | --- |
| `DboState_GetOptionString <name> <default>` | 读 OrCAD 选项字符串 |
| `DboState_WriteToSessionLog <str>` | 写会话日志（排错首选） |
| `DboState_ClearDesignUndoRedo <name>` | 清某设计的 undo 栈 |
| `DboState_RunBackAnnotation` / `RunFrontToBackTool` | 反标 / 正标 |
| `DboState_DispPropBoundingBox <prop> <viewOcc>` | 标注包围盒 |
| `DboState_GetLicenseString` / `GetOrCADCMTierFlag` | 许可/CM 档位 |

## 7. 不确定性声明

- `orPrm::*`、`RegisterAction`、`InsertXMLMenu` 等**没有官方参数文档**可查；上表参数形态来自真实调用点与实测，宿主不做参数校验的地方（例如 `SetWindowPos` 的 `flag`）需要按 `1` 试。
- 宿主命令的可用性随版本变动（例如 16.6 用 `IsSchematicViewActive`，17.4 用 `capGetIsSchematicEditingDisabled`）。写代码时统一用 `if {[llength [info commands <cmd>]]}` 做能力检测，而不是按版本号硬分叉。
