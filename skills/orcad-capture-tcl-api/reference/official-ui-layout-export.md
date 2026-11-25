# 官方 UI / 对齐 / 导出 / 对象流：四套现成范式

要把插件做成"有界面、能排版、能出图、能预览"，这四块都能在 Cadence 自带脚本里找到完整实现，不必从零设计。下面按"官方怎么组织 → 你能抄什么"给出。

## 1. 偏好设置表单：树 + 表 + 字段枚举 + JSON

官方 `capExtPrefSetup`（338 处 Dbo）的组织方式：

| 层 | 官方实现 | 说明 |
| --- | --- | --- |
| 宿主编排 | `::OrHandlerExtPrefSetupForm::capLaunchWidget` | 由宿主拉起控件，Tcl 只负责填充 |
| 表单描述 | `setUIFormJSON` | 整个界面以 JSON 描述交给前端 |
| 树 | `initTree` + `COrTree_GetDataInJSON` | 配置树：节点是可折叠的分类 |
| 表 | `initDsnAndLibsTable` / `initConfigFilesTable` / `initCISTable` / `initDRCTable` / `initNetGroupTable` / `initNetlistTable` / `initDsnCacheTable` / `initCMDShellTable` | 每类配置一张表 |
| 字段类型 | `$row NewField $::COrConfigField_CFT_STATIC_TEXT` / `_CFT_CHECKBOX` / `_CFT_...` | 用枚举声明控件类型，而不是硬编码 HTML/Tk 控件 |
| 取值/回写 | `COrConfigTable_sGetDataInJSON` / `COrConfigTable_*` | 配置表与 JSON 互转 |

**可抄的点**：把"界面描述"和"配置数据"都做成 JSON，Tcl 只负责把两者拼起来；字段类型用枚举（静态文本/复选/输入/下拉），前端按枚举渲染。这样同一套描述既能给宿主原生控件，也能给网页面板。

## 2. 对齐 / 分布：先算包围盒，再按锚点算目标位置

官方 `capAlignObject`（240 处 Dbo）的全部选项就是一个完整的对齐引擎 API：

| 命令族 | 作用 |
| --- | --- |
| `SetObjectList` / `GetObjectList` | 待处理对象清单 |
| `SetAlignType` / `GetAlignType` | 对齐方式（左/右/居中/上下/等距…） |
| `SetPivotPt` / `GetPivotPt` | 基准点（以哪个对象为准） |
| `SetStartPos` / `GetStartPos`、`SetLeftStartLoc` / `GetLeftStartLoc` | 起始位置与左边界基准 |
| `SetSpacing` / `GetSpacing` | 间距（对齐或分布的时间隔） |
| `SetDistributionType` / `GetDistributionType` | 分布方式（等间距/按中心距…） |
| `SetAlignAsyncMode` / `GetAlignAsyncMode` | 异步执行（对象多时不卡界面） |
| `SetOptionSelectWire` / `GetOptionSelectedWire` | 是否把导线也纳入对齐 |
| `ResetLockedObjsList` / `ResetPrevErrorList` / `ResetErrorList` / `ResetElements` | 锁定对象与错误清单（部分对象不可动时要能报告） |

Dbo 侧只用了三种原料：`GetBoundingBox`（配 `sGetCRectTopLeft`/`sGetCRectBottomRight`，官方分别用了 32/28 次）、`GetObjectType`（过滤 `GRAPHIC`/`WIRE`/`ALIAS`/`DISPLAY`/`ERC`/`BOOK`）、`SetLocation`。

**可抄的算法骨架**：

```tcl
# 1) 收集包围盒
foreach obj $objects {
    set box [$obj GetBoundingBox]
    set tl [DboTclHelper_sGetCRectTopLeft $box]
    set br [DboTclHelper_sGetCRectBottomRight $box]
    lappend items [list $obj [DboTclHelper_sGetCPointX $tl] [DboTclHelper_sGetCPointY $tl] \
                            [DboTclHelper_sGetCPointX $br] [DboTclHelper_sGetCPointY $br]]
    DboTclHelper_sDeleteCPoint $tl; DboTclHelper_sDeleteCPoint $br; DboTclHelper_sDeleteCRect $box
}
# 2) 按 pivot 选基准，算出每个对象的 dx/dy
# 3) 逐个 SetLocation（或对显示属性用 SetLocation + MarkModified）
# 4) 失败对象进错误清单，锁定的先剔除
```

## 3. PDF / 打印导出：先把页对象"标注"出来，再交给外部渲染

官方 `capPDFExport`（284 处 Dbo）不是自己画 PDF，而是走一条**标注 → 序列化 → 跨进程渲染**的管线：

| 阶段 | 官方 proc | 说明 |
| --- | --- | --- |
| 遍历 | `annotatePageObjects` / `annotatePagePtrObjects` | 逐页收集对象 |
| 分类标注 | `annotateProps` / `annotateEffectiveProps` / `annotateEffectiveProp` / `annotateAlias` / `annotateWire` / `annotateGlobal` | 按对象类型补足"渲染需要但库里没有"的信息（有效属性、网络名、全局符号等） |
| 变体 | `getVariantPropValue` / `getVariantPropValueFromOccAndInst` | 处理变体/多单元属性 |
| 纸张 | `populatePaperSizeList` / `getPaperSizeName` / `getPaperSizeListCount` | 纸张与比例 |
| 跨进程 | `DboTclHelper_sSetDboObjectInProcess $obj`（18 次） | **把对象句柄交给外部进程**（打印/渲染是独立进程） |
| 日志 | `DboState_WriteToSessionLog`（10 次） | 输出到 Capture 会话日志 |

`sSetDboObjectInProcess` / `sGetDboObjectInProcess` 这一对就是**跨进程传 Dbo 对象**的官方手段：进程 A 把对象"登记"，进程 B 按句柄取回。自己做"外部渲染器/外部预览器"时，这是唯一不需要序列化几何的传参方式（但两个进程要共享同一个 Dbo 会话上下文）。

## 4. 对象流序列化：`orPrmDboStreamer` 的字段分层

要把页/封装/库喂给网页或外部 viewer，官方 `orPrmDboStreamer`（64 KB 纯 Tcl）就是参考实现。它的分层很清晰：

| 层次 | proc | 输出 |
| --- | --- | --- |
| 原语 | `streamPoint` / `streamCPoint` / `streamRect` / `streamCRect` / `streamLayer` | 坐标与层 |
| 样式 | `streamVisibility` / `streamFillStyle` / `streamStrokeStyle` / `streamPainterId` | 可见性、填充、线型、画笔 |
| 属性 | `streamProp` / `streamDboProp` / `streamDboProps` / `streamDbProps` / `streamUserProps` / `streamDisplayProp` / `streamDisplayProps` | 属性与显示属性（含字体/颜色/位置） |
| 形状 | `streamShapeHeader` / `streamDefShapeHeader` / `streamArc` / `streamEllipse` / `streamBox` / `streamText` … | 每类图形一个 streamer，统一带头部 |
| 容器 | `streamPage`（下分 `streamPageWires` 等，导线与总线分开收集）/ `streamPackage` / `streamLibrary` | 页/封装/库 |
| 类型名 | `dboValueType2Name` / `getDboType` / `getDboPropTypeStr` | **把类型码转成可读名字**写进 JSON，而不是数字 |

组合方式（官方 `orPrmWebProvider::getObjectStream`）：

```tcl
switch -- [$obj GetObjectType] {
    $::DboBaseObject_PAGE      { set v 1; set s [orPrmJSON::encode [orPrmDboStreamer::streamPage $obj]] }
    $::DboBaseObject_PACKAGE   { set v 2; set s [orPrmJSON::encode [orPrmDboStreamer::streamPackage $obj]] }
    $::DboBaseObject_LIBRARY   { set v 3; set s [orPrmJSON::encode [orPrmDboStreamer::streamLibrary $obj]] }
}
# 注入：oCDNOrPrimeViewer.viewType = $v; oCDNOrPrimeViewer.stream = $s
```

**可抄的点**：
1. 每个图元一个 streamer，统一 header（类型名 + id + 层 + 样式），前端按 `type` 分派绘制——比"一个大函数里堆 switch"好维护。
2. 类型写**名字**不写数字（`dboValueType2Name`），跨版本更稳。
3. 导线与总线分开数组（`lJWires` / `lJBusWires`），渲染时前者按线、后者按总线样式。

## 5. 什么时候用官方这套

| 需求 | 用官方的 | 自研 |
| --- | --- | --- |
| 设置界面 | `COrConfigField_CFT_*` + 表格/树 + JSON | 自定义网页面板（跨宿主可复用） |
| 对齐/分布 | `capAlignObject` 的选项模型（照抄 API 设计） | 具体算法可自己写，几十行 |
| 打印/导出 | `sSetDboObjectInProcess` 跨进程传参 | 自己序列化成 SVG/PDF |
| 预览 | `orPrmDboStreamer` 的字段分层 | 只读场景直接用官方 viewer 协议 |

## 6. 层级流：`orPrmDboHierStreamer`（6.8 KB）

官方还有一个专门处理**层级设计**的 streamer，比 `orPrmDboStreamer` 更轻，只要树和页：

| proc | 作用 |
| --- | --- |
| `init <stopType>` | 设定遍历截止类型（默认 `$::DboBaseObject_PART_INSTANCE`） |
| `openDesign <dsn>` | **离屏打开设计**：本质是 `$session GetDesign <path> $status`（headless 可用） |
| `getViewNames <lib>` | 取设计所在库里的视图名 |
| `getHierData <design> ?occMode?` | 主入口：产出 `{viewNames, schHiers, pageNames, pageInsts}` |
| `getSchematicChildren` / `getPageChildren` | 层级下钻 |
| `getInstHierStream <design>` | `getHierData` → `orPrmJSON::encode` 的 JSON 版 |
| `getInstHierStreamFromFile <dsn> ?stopType?` | 一行式：开文件 → 取层级 JSON |

**可抄的两点**：
1. 层级遍历用 **occurrence 树**（`GetRootOccurrence` → `NewChildrenIter` → `DboOccurrenceToDboInstOccurrence`），不是按视图/页递归——共享页只会出现一次，分支由 occurrence 表达。
2. 停到 `PART_INSTANCE` 即止，避免把每个图元都流出去；要更细就换 stopType。

最小实现（`examples/hier-tree.tcl`，已用 Cadence 自带 `PS15.DSN` 实测：32 个 occurrence / 1 页 / 31 个器件实例，JSON 合法）：

```text
session GetDesign <dsn> → design GetRootName
→ GetRootOccurrence → NewChildrenIter $st $::IterDefs_INSTS → NextOccurrence
→ DboOccurrenceToDboInstOccurrence → GetPathName / GetId / GetPartInst / IsPrimitive
→ 位号：occurrence 上取 "Part Reference"（分支可覆盖），空则退回 GetDesignator
→ 页：NewViewsIter $::IterDefs_SCHEMATICS → DboViewToDboSchematic → NewPagesIter → NewPartInstsIter（计数）
```

输出契约（v2，直接可喂树控件）：

```text
{design, root,
 occurrences:[{id, parent, path, ref, page, primitive, recursive, contents,
               children, pages:[{name,partInsts}], partCount, types:{TYPE_NAME:count}}],
 views:[{schematic,pages:[{name,partInsts}]}],
 occurrenceCount, pageCount, partInstCount, depthLimitHit}
```

关键点：`pages/partCount/types` **不是**每个 occurrence 各扫一遍页得来的——先扫一遍"视图→页"建 `schematic → {pages, parts, types}` 统计表，遍历 occurrence 时按 `contents` 查表。两遍遍历、每页只扫一次，大设计也不慢。

实测（两份 Cadence 自带样本）：

| 设计 | 规模 | occurrence | 页 | 器件实例 | 耗时 | 产物 |
| --- | --- | --- | --- | --- | --- | --- |
| `PS15.DSN`（平面） | 201 KB | 32 | 1 | 31 | 0.7 s | JSON 5.5 KB |
| `HSD_FPGA.DSN`（层级） | 3.1 MB | 441 | 17 | 440 | 1.2 s | JSON 91 KB + HTML 29 KB |

层级样本里 root 的 `contents=Top`、`pages=[Top_Level(10)]`、`types={DRAWN_INSTANCE:9, PLACED_INSTANCE:1}`——正是树控件要显示的东西。加 `--html out.html` 会额外生成一份零依赖的 `<details>` 折叠树，双击就能在浏览器里逐层展开。