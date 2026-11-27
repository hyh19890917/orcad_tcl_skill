# 面板 API 全景：240 个命名空间 / 3126 个方法（真机导出）

`scripts/export-host-commands.tcl` 的 `namespace-procs.txt` 把 Capture 里所有命名空间的 proc **连参数名**一起导了出来。这份文件是"官方面板到底提供了什么"。下面是从真机数据（17.4）整理出的结构与几个直接能用的子集。

## 1. 规模与分布

| 指标 | 值 |
| --- | --- |
| 命名空间 | **240** |
| proc 总数 | **3,126** |
| 方法名前缀 | `get*` 735、`Set*` 162、`On*` 158、`capLaunchWidget` 38、`capCloseWidget` 26、`update*` 28 |

方法最多的十个命名空间：

```text
178  OrHandlerSymbolEditorConfig     120  capObjectAlignment
 60  OrHandlerPspicePwlModelingApp    59  OrEntrySymbolEditorConfig
 58  orPrmServerPrimary               58  OrEntryPspicePwlModelingApp
 55  PSpiceSettingsForm               48  capPSpiceModelAppWrapper
 46  OrPSpiceServerClientOperation    45  capPSpiceModelBrowser
```

## 2. `OrEntry<Feature>::` 的面板契约

以 `::OrEntryAdvancedAnnotation::` 为例（全部 11 个方法）：

```tcl
capAnnotate            pAnnotateMode pSelectedNode pSettingJSON pStrClientId
capDestroyWidget       pStrClientId
capGetOccurenceJSONTree            pStrClientId
capGetOccurenceJSONTreeWithoutPages pStrClientId
capGetPropertyBlockJSON pProperty pStrClientId
capHelpAdvancedAnnotation           pStrClientId
capLaunchWidget        pStrClientId
capSetAllRefString     pJSON pStrClientId
capSetRefString        pObject pRefString pStrClientId
getPreviousAnnotationOptions        pStrClientId
getUserNameFromID                   pStrClientId
```

归纳出四条固定套路：

1. **`pStrClientId` 是每个方法的最后一个参数**（就是面板启动时传的 `"hostedClientId"`）。所有跨面板调用都得把它带着，面板之间靠它隔离会话；
2. **生命周期三件套**：`capLaunchWidget` / `capDestroyWidget` / `capHelp*`；
3. **数据进出**：`capGetXxxJSON`（面板取数据）、`capSetXxx`（面板回写）、`getPreviousXxxOptions`（恢复上次选项）；
4. **动作方法**都接收"选择集 + 设置 JSON"（如 `capAnnotate pAnnotateMode pSelectedNode pSettingJSON pStrClientId`）。

## 3. `::capObjectAlignment::`：一整套现成的对齐/分布引擎（120 个方法）

这解释了 `capAlignObject` 为什么那么"重"——它的算法全在这一层，**可以直接调用，不必自己算包围盒**：

| 方法 | 参数 | 作用 |
| --- | --- | --- |
| `AlignLeft` / `AlignRight` / `AlignTop` / `AlignBottom` / `AlignCenter` / `AlignMiddle` | `args` | 六种对齐（对当前选择） |
| `AlignObjectInList` | `pObjectList pPivotPt pAlignType` | 对给定对象列表按 pivot 对齐 |
| `AsyncAlignObjInList` | `pObjList pPivotpt pAlignType` | 异步版（大批量不卡界面） |
| `DistributeHorizontal` / `DistributeVertical` | `args` | 水平/垂直等距分布 |
| `DistributeObjInList` | `pStartPt pSpreadWidth pDistbtnType pObjList` | 指定起点、总宽度、分布方式 |
| `DistributeOneObject` | `pObj pStartPos pSpaceBetweenObjs pDistbtnType` | 单个对象的分布定位 |
| `AdjustSpace` | `pSpace pObjList pDistbtnType` | 调间距 |
| `ConvertDocToUser` / `ConvertUserToDoc` | `aPage aDocUnit` / `aPage aUserUnit` | **文档单位 ↔ 用户单位换算**（以前手算 inch 的活可以省） |
| `AreObjectshavesameDim` | `pObjList` | 判断同尺寸 |
| `DumpToSessionLog` / `Dump*Massage` | … | 把结果/错误写进会话日志 |

对我们 `examples/align-objects.tcl` 的意义：那份脚本自己算包围盒、自己移动，只适合"无宿主环境下最小实现"；**在真实 Capture 里应该优先调 `::capObjectAlignment::*`**，省掉单位换算、异步、错误清单这些坑。

## 4. `::orPrmServerPrimary::`：面板后端 RPC（统一 `pListArgs`）

```tcl
::orPrmServerPrimary::CreateLibrary         pListArgs
::orPrmServerPrimary::SaveNewPartInLib      pListArgs
::orPrmServerPrimary::CheckuploadLibraryLimit pListArgs
::orPrmServerPrimary::createPspiceNetlist   pListArgs
::orPrmServerPrimary::downloadDesignBase64Data pListArgs
::orPrmServerPrimary::downloadDesignStream  pListArgs
::orPrmServerPrimary::checkFileAvailability pListArgs
::orPrmServerPrimary::datFileBrowse         pListArgs
::orPrmServerPrimary::evaluateExpr          pListArgs
::orPrmServerPrimary::evaluateExprRunning   pListArgs
::orPrmServerPrimary::getAnalogTraceData    pListArgs
::orPrmServerPrimary::endUserSession        pListArgs
```

形态高度统一：**单入口 + 命令名 + 一个参数列表**。也就是说面板与本机的 RPC 不是"每条命令一个函数签名"，而是 `(commandName, argsList)` 的通用分发——和我们从 `orPrmServer.tcl` 看到的 `methodLabel/methodParams` 完全对得上。

## 5. 怎么自己接着查

在 Capture 里任何时刻都可以：

```tcl
lsort [namespace children ::]                 ;# 有哪些命名空间
namespace eval ::OrEntryDesignView {info procs}   ;# 某个面板的全部方法
namespace eval ::OrEntryDesignView {info args capLaunchWidget}  ;# 某个方法的参数名
```

或者重新跑一次导出脚本，`namespace-procs.txt` 会给出全部 3126 条（名字 + 参数）。

## 6. 注意

- 这份导出是**装了第三方插件的环境**里跑的，`namespace children ::` 会包含非 Cadence 的命名空间；写文档/示例时只取 `OrEntry*` / `Or*Handler*` / `cap*` 这些默认安装自带的。
- `OrHandler*` 与 `OrEntry*` 是两套：`OrEntry*` 面向面板（收 `pStrClientId`），`OrHandler*` 偏内部处理（参数更业务化，如 `::OrHandlerPDFExport::printPDF pJson`）。
