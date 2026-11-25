# 进阶 Dbo API：事务、JSON/BOM、位号、路径、Web 宿主

除了"取对象—改属性—保存"这条主线，Dbo 还暴露了一批**大多数人不知道存在**的族。它们都能在 `info commands` 里看到；下面按用途分组，并标出**官方 564 个 tcl 脚本里是否真的用过**（`官方用例` 列）——没用过的不代表不能用，只代表没有免费示例，需自测。

版本可用性（来自 16.6 / 17.2 / 17.4 三次实测导出）：

| 族 | 16.6 | 17.2 | 17.4 | 官方用例 |
| --- | --- | --- | --- | --- |
| `DboPageTransaction` | 7 | 7 | 7 | 0 |
| `DboTclUtils` | 11 | 21 | 23 | 5 |
| `DboTclBom` | 0 | 3 | 3 | 0 |
| `DboJsonUtils` | 0 | 1 | 1 | 0 |
| `DboRefDesManager` | 10 | 10 | 10 | 0 |
| `DboRefDesAnnotate` | 8 | 13 | 13 | 0 |
| `DboRefDesUtils` | 6 | 22 | 22 | 21 |
| `DboPathMgr` | 32 | 43 | 43 | 17 |
| `DboDirectory` | 21 | 21 | 21 | 0 |
| `DboERC` / `DboBookMark` | 10 / 3 | 10 / 3 | 10 / 3 | 0 |
| `DboExtensionManager` | 14 | 14 | 14 | 0 |
| `DboInstOccMapper` | 4 | 4 | 4 | 0 |
| `DboConnectivityChange*` | 0 | 3 | 5 | 0 |

## 1. 事务与撤销：`DboPageTransaction`

| 命令 | 参数 | 用途 |
| --- | --- | --- |
| `DboPageTransaction_InitiateInternalTransaction` | self | 开启内部事务 |
| `DboPageTransaction_InitAutoTransactions` | self | 开启自动事务模式 |
| `DboPageTransaction_PlaceUndoMarker` | self,`pCheckForDuplicate` | 在当前点放一个 undo 标记（一次"可撤销单元"） |
| `DboPageTransaction_TerminatePage` | self | 结束当前页事务 |
| `DboPageTransaction_ClearTransactionHistory` | self | 清事务历史 |
| `DboPageTransaction_DumpTransactionVector` | self | dump 事务向量（排错） |
| `DboPageTransaction_RegisterSchDocCommand` | self | 注册命令 |

配套：`DboState_ClearDesignUndoRedo <pDesignName>`（按设计名清 undo 栈）、`DboBaseObject_GetTransactionCount` / `SetTransactionCount`（对象级事务计数）、`DboBaseObject_IsOccModified` / `SetOccsModified`。

**用法要点**：批量修改时"一次事务 = 一次 Ctrl+Z"，比逐条 `MarkModified` 更符合用户预期；`PlaceUndoMarker` 可在同一事务里切分多个可撤销点。这些命令官方 tcl 里没有示例，需先在测试设计上验证行为再用于生产。

## 2. 现成的 JSON 与 BOM 助手：`DboTclUtils` / `DboTclBom`

`DboTclUtils`（17.2 起 21 个，17.4 23 个）里最适合直接用的是把设计/器件读成 JSON 的那批：

| 命令 | 参数 | 产出 |
| --- | --- | --- |
| `DboTclUtils_sGetDesignPartPropertyJSON` | pDesign,pPropToIgnoreSet,**prStrJSONProp** | 全设计器件属性 JSON |
| `DboTclUtils_sGetSelectedPartPropertyJSON` | pDesign,pOccID,pPropToIgnoreSet,prStrJSONProp | 选中器件（可带 occurrence）属性 JSON |
| `DboTclUtils_sGetActiveDesignComponents` | pDesign,pDsnCompPartPropList,pPartsToIgnoreWithPropNameVal,pPropToIgnore,pStrJSONActDsnComp | 当前设计器件清单 |
| `DboTclUtils_sGetDesignPartGroupByMatchProp` | pDesign,pPropToMatch,pPropToRead,pPartsToIgnore…,prStrJSON | **按属性分组**（BOM 分组的基础） |
| `DboTclUtils_sGetDesignPartGroupByOccJSON` | pDesign,pPropToRead,pPartsToIgnore…,prStrJSON | 按 occurrence 分组 |
| `DboTclUtils_sGetPartRefAllOccOfParts` | pDesign,pOccId,pPropToRead,prStrJSONProp | 同一器件在所有分支的引用 |
| `DboTclUtils_sFindSimilarPartBasedOnProp` | pDesign,pstrPartInfoJSON,pstrPropNameJSON,pPropToRead,prStrJSONProp | 按属性找同款 |
| `DboTclUtils_GetDesignHierarchyInJSON` / `…WithoutPages` | — | 层级结构 JSON |
| `DboTclUtils_GetComponentsAndCountInJSON` | — | 器件数统计 |
| `DboTclUtils_GetReferenceFromID` | pDesign,pId | 由内部 id 反查位号 |
| `DboTclUtils_CreateJSONForProperties` | pProps,pDefProps,pObjType,pAppName | 属性表 → JSON |
| `DboTclUtils_GetReferencePrefix` | cstrRef | 位号前缀（R1→R） |
| `DboTclUtils_EvalTCLCommand` / `GetTclInterpreter` | pCommand,commandResult | C++ 侧调 Tcl / 取解释器 |
| `DboTclUtils_sGetETOEURL` | pPart,pPackageName,pPartID | 器件"在线"跳转 URL |
| `DboTclUtils_sGetTIPartsData` | pDesign,pTIVersion,pModelLibVersion,pOSVersion,pForumURL,pPartsURL | 器件库站点数据 |

`DboTclBom`（**17.2+**，三个命令）：`GetBOMJSON pDesign,pInputJSON`、`GetBOMJSON1`、`GetBOMOptionsJSON pDesign` —— 官方 BOM JSON 生成入口，参数是输入 JSON（选项），输出 JSON。
`DboJsonUtils_GetPrefixReferenceRange`（17.2+）：位号前缀范围解析。

> 实践建议：**先试 `DboTclBom::GetBOMJSON`，再考虑自研**。它省掉"遍历-合并-序列化"整段，代价是输出结构由宿主决定；若你的 BOM 需要自定义分组/列，仍可用 `sGetDesignPartGroupByMatchProp` 拿分组结果自己拼。

## 3. 位号与标注：`DboRefDes*`

| 族 | 关键命令 | 用途 |
| --- | --- | --- |
| `DboRefDesManager` | `AddInstOccToPending` / `AssignRefDesToPendingInstOccs` / `ClearPendingInstOccs` / `GetOccRefDesMap` / `IsDesignLevelAutoReferenceEnabled` / `RefreshOccRefDesMap` / `ProcessRefDesModify` / `ProcessObjectDelete` | 位号分配状态机；新放置的器件先进 pending，再统一分配 |
| `DboRefDesAnnotate` | `Annotate` / `AnnotateIncremental` / `AnnotateUnconditional` / `ResetPartReference pObjectList` / `SetDesign` | 三种标注模式（全量/增量/无条件）+ 复位 |
| `DboRefDesUtils` | `GetDesignatorNumber` / `GetDesignatorString` / `SplitPartReference` / `BuildRefNumRange` / `GetReference` / `ResetReference` / `NewPartsIter` / `GetPagesInOrder` / `GetPagesForPropertyValue` / `GetPagesAsPerPMOrder` / `GetPagesAsPerPagesInTitleBlockOrder` | 位号解析与"按页顺序"遍历（`capAdvancedAnnotation` 用它 21 次） |

## 4. 路径与内存目录：`DboPathMgr` / `DboDirectory`

- `DboPathMgr`（17.2 起 43 个）：`sLookupPath`、`sFindAbsolutePath path,baseDir`、`sFindRelativePath`、`sConvertToAbsolutePath`、`sNormalizePath`、`sIsPathAbsolute`、`sGetFullPath`、`sGetFileStatus`、`sIsReadOnly`、`sForgetReadOnlyAttribute`、`sSetPathLookupTimeout` / `sGetPathLookupTimeout`、`sSetLegacySaveAs`、`sDisableFileLookupNotifaction`、`sDumpToSessionLog`。
  **用途**：库搜索路径（`padpath`/`psmpath`/设计目录）解析与只读判定，比 `file normalize` 更贴近宿主行为；批量改库前用 `sIsReadOnly` 提前拦截，比写失败再回滚体验好。
- `DboDirectory`（21）：内存目录视图 —— `GetObject name,status`、`GetPackageFromMemory`、`NewEntriesIter`、`MarkModified`/`MarkSaved`/`MarkToBeSaved`/`MarkToBeDeleted`、`IsInMemory`、`IsAnyEntryModified`、`ClearModified`、`GetCreateTime`/`GetModifyTime`。
  **用途**：判断"这个封装是不是只在内存里、还没落盘"，避免把未保存的库当成磁盘状态处理。

## 5. 元数据、ERC、书签

- `DboExtensionManager`（14）：handle 化的属性袋 —— `CreateHandle`/`DeleteHandle`、`AddExtension`/`RemoveExtension`/`ReplaceExtension`/`GetExtension pHandle,pExtensionType`、`NewExtensionIter`、`StoreExtensions`/`LoadExtensions`（序列化到 buffer）、`sGetInstance`。适合挂"宿主不认识但需要随对象持久化"的二进制数据。
- `DboERC`（10）：`GetSeverity`/`GetDetail`/`GetError`/`GetLocationString`/`SetLocation`/`SetMirror`/`SetRotation`，配 `DboPageERCsIter` 遍历 —— 可以做自己的 DRC 报告汇总。
- `DboBookMark`（3）+ `DboPageBookMarksIter`：页内书签（跳转点）。

## 6. 连通性变更与实例映射（新版本才有）

- `DboConnectivityChange*`（17.2 起）：`NextAddorModifiedDbObject` / `NextDeletedDbObject` / `NextFlatNetChange` / `NextPinChange` —— **增量感知**电气变化，适合做"改完只重算受影响网表"。
- `DboInstOccMapper`（4）：`GetOccurrences` / `GetOccurrencesAtPos` / `GetOccurrencesCount` / `GetOccurrenceFromParent` —— 同一图形实例在层级各分支的定位。
- `DboDesignPackageInstOcc*` / `DboPackageInstOccurrences*`（17.4 起）：封装实例级 occurrence 枚举。

## 7. 官方 Web 宿主：`orPrmWebApp`（`package require orPrmServer`）

Cadence 自带一套"把设计对象暴露给浏览器"的框架，不必自己起 HTTP 服务：

- `orPrmServer.tcl`：`orPrmServer::run`（启动宿主侧 web 服务）。
- `orPrmWebProvider.tcl`：`getObjectStream pObj`（对象→流）、`loadObject id`、`getLibraryNames`、`getDesignNames`、`getWorkspaceElements aSessionId`、`getPage pFile pSchematic pPage aSessionId`、`getContents pFilename pType aSessionId`、`streamFiles`。
- `orPrmCGI.tcl`：`parseRequest` / `processRequest` / `startContent` / `endContent`。
- `orPrmServerIIS.tcl`：走 IIS 的变体。

**取舍**：它擅长"只读地把设计/库对象喂给页面"，鉴权与会话由宿主管；但如果你要双向命令（浏览器点一下改原理图），仍需自建受限命令通道（一次性 token + 白名单 + 超时，见 SKILL.md §10）。

## 8. XSD：`capDB\olb.xsd` 与 `dsn.xsd`

`XMATIC_OLB2XML <olb> <xml> <olb.xsd> <log>` 的第三个参数就是 schema 路径（顶层元素 `Lib`）。做"XML→OLB"生成器时，**先按 XSD 建结构再填数据**，比照着一个样例反推字段可靠得多；`dsn.xsd` 对应设计级导入导出。

## 9. 使用顺序建议

1. 读数据 → 先看 `DboTclUtils_*JSON` 能不能直接给（省一大段遍历）。
2. BOM → 先试 `DboTclBom::GetBOMJSON`（17.2+），不够再自研分组。
3. 批量改 → 用 `DboPageTransaction` 圈事务，配 `PlaceUndoMarker` 切撤销点。
4. 位号 → 用 `DboRefDesManager` 的 pending 流程，别自己拼字符串。
5. 路径/只读 → 用 `DboPathMgr`，别用 `file` 命令猜。
6. 未知族 → 先在测试设计上跑零参/最小参数试探（`DboLib_GetPackage` 那种"错参报签名"的机制对多数族有效），再写生产代码。
