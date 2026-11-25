# 宿主命令面：9,830 vs 6,112 —— 之前看不见的那 ~3,700 条

用 `scripts/export-host-commands.tcl` 在真实 Capture（17.4）里导出后，宿主面第一次有了清单。这份文档记录**盘点结果**，以及它推翻/修正的几条旧结论。

## 1. 规模差

| 环境 | `info commands` |
| --- | --- |
| headless `tclsh` + `orDb_Dll_Tcl64.dll` | 6,112 |
| **Capture.exe 内部** | **9,830** |

差额 ≈ **3,718 条**——全部是 `capture.exe` 启动时注册的宿主命令，headless 一条都看不到。这也解释了此前几轮为什么"用 Dbo 面够不到放置类能力"。

环境信息（`env.txt`）：`tcl 8.6.5`、`nameofexecutable = ...\SPB_17.4\tools\bin\Capture.exe`、`tcl_platform(wordSize)=4`（再次印证 wordSize 不能用来判 ABI）、`HOME = ...\SPB_Data`。

## 2. 家族分布（Top 20，来自 `commands-prefix.tsv`）

```text
326 DboLib      302 delete    273 new       266 DboPage   232 CorSimSrvr
148 DBXMLWriter 145 orSysObjectsManager     138 CPMgtCfg  135 CPSpiceProject
123 CISDesign   114 DboBaseObject           95 DboSchematic 91 DboTclHelper
89 DboInstOccurrence  86 DboDesign  86 pSpiceExplorerServer  82 DboPortInst
81 DboWire      80 DboPartInst              72 CPMgtDbCfg
```

注意 `CorSimSrvr`(232)、`orSysObjectsManager`(145)、`CPMgtCfg`(138)、`CPSpiceProject`(135)、`pSpiceExplorerServer`(86) 这些**在 headless 里完全不存在的家族**。

## 3. `Place*` 家族：63 条（这就是找了几轮的放置 API）

```text
PlaceArc PlaceBezier PlaceBlock PlaceBlockWithDialog PlaceBookMark
PlaceBookMarkWithDialog PlaceBus PlaceBusEntry PlaceCisDatabasePart
PlaceEllipse PlaceGround PlaceGroundWithDialog PlaceJunction PlaceLine
PlaceNetAlias PlaceNetAliasWithDialog PlaceNetgroup PlaceNetgroupBlock
PlaceNetgroupGround PlaceNetgroupOffPage PlaceNetgroupPort PlaceNetgroupPower
PlaceNew PlaceNextBezierPoint PlaceNextPolygonPoint PlaceNextPolylinePoint
PlaceNoConnect PlaceOffPage PlaceOffPageWithDialog PlacePart PlacePartAddLib
PlacePartClickPlace PlacePartDump PlacePartEx PlacePartGetLibIndex
PlacePartGetPartIndex PlacePartReloadLib PlacePartRemoveLib
PlacePartSelectDeviceIndex PlacePartSelectLibIndex
PlacePartSelectPartByNameAndLib PlacePartSelectPartIndex PlacePartToolTip
PlacePartWithDialog PlacePicture PlacePin PlacePinWithDialog PlacePolygon
PlacePolyline PlacePort PlacePortWithDialog PlacePower PlacePowerWithDialog
PlaceRectangle PlaceText PlaceTextWithDialog PlaceTitleBlock
PlaceTitleBlockWithDialog PlaceWire
```

**直接回答了三轮前的问题**：想加网络标签用 `PlaceNetAlias`，页间连接符用 `PlaceOffPage`，端口用 `PlacePort`，器件用 `PlacePart*` 系列。**它们不是 Dbo 方法，是宿主命令**——所以 `DboWire_NewName` 才会"返回 OK 却什么都不做"。

规律：多数放置命令有 `Xxx` 与 `XxxWithDialog` 两个变体（后者弹对话框让用户填参数），`PlacePart` 有一整套配套（`AddLib`/`SelectLibIndex`/`SelectPartIndex`/`Dump`），说明"放置器件"其实是**多步交互协议**，不是一次调用。

## 4. 关键宿主命令的存在性（逐条核对）

| 命令 | 在 | 说明 |
| --- | --- | --- |
| `RegisterAction` / `InsertXMLMenu` / `RefreshMenu` | ✅ | 菜单注册三件套 |
| `GetSelectedObjects` / `GetActivePage` / `GetActivePMDesign` | ✅ | 取上下文 |
| `capTrue` | ✅ | 万能 enabler |
| `PlaceWire` / `PlacePart` / `PlaceNetAlias` / `PlaceOffPage` | ✅ | 放置 |
| `AddMenu` / `AddAccessoryMenu` / `AskUserInput` / `AutoWire` / `BusWire` | ✅ | 其它 UI/编辑入口 |
| `ExecuteAction` / `ExecuteCommand` / `RegisterEvent` / `AddAccessory` | ❌ | **不存在**（旧文档里提到的名字要删掉） |

## 5. `cap*` 家族：533 条

抽样（含几条很值钱的）：

| 命令 | 价值 |
| --- | --- |
| `CapPdfPrint` / `CapPdfAddMarkStart` / `CapPdfAddMarkData` / `CapPdfAddMarkEnd` / `CapPdfSetOption` | **官方 PDF 打印与标注 API**，此前只知道有 `capPDFExport` 脚本，不知道有直接命令 |
| `CapFindObjects` / `FindNets` / `FindDPByName` / `FindHierarchicalPorts` | 按条件查对象 |
| `capAnySchematicPageOpened` | 判断是否有页打开 |
| `CapCustomDRCElectricalAddItem` / `CapCustomDRCPhysicalAddItem` | 自定义 DRC 项 |
| `<feature>_capLaunchWidget` / `<feature>_RegisterActions` | 与 plugin-lifecycle 里的约定一致（如 `capAutoAnnotateHBlockPageUtil_RegisterActions`） |

## 6. arity 探测的收获（`arity-probe.txt`，210 行）

零参调用把参数名逼了出来，例如：

```text
FindBookMarks          Wrong number of arguments :FindBookMarks value boolvalue2  argument 1
FindNets               Wrong number of arguments :FindNets value boolvalue2  argument 1
FindDPByName           Wrong number of arguments :FindDPByName designName diffPairName  argument 1
FindHierarchicalPorts  Wrong number of arguments :FindHierarchicalPorts value boolvalue2  argument 1
FindEcSet              Wrong number of arguments :FindEcSet designName ecsetName  argument 1
```

两点观察：

1. 一批 `Find*` 的参数名是 `value, boolvalue2` —— 典型的**通用桩命名**，说明这些命令的形参在绑定层被泛化了，名字不可全信，但**个数可信**；
2. 探测本身可复现，下一轮把允许前缀扩到 `Place|Add|Register|Cap|Get|Set` 就能拿到放置类的参数个数。

## 7. 对旧结论的修正

| 旧结论（错的） | 实际 |
| --- | --- |
| "命令表里找不到 `Place*`，所以放置由 action 触发" | 命令表只含 Dbo 面；宿主人面里有 63 条 `Place*`，放置是**宿主命令** |
| "找不到程序化创建 net alias / off-page 的办法" | `PlaceNetAlias` / `PlaceOffPage` 就是；只是不在 Dbo 面 |
| "`ExecuteAction` 在 headless 不存在" | 对，但**在 Capture 里也不存在**——触发自己注册的 action 要走菜单点击或直接把逻辑抽成 proc |

## 8. 下一步（可复现）

1. 用同一脚本的二版（允许前缀加 `Place|Add|Register|Cap|Set`）再导一次 arity-probe，拿到 `Place*` 的参数个数；
2. 在 Capture 里试 `PlaceNetAlias` 的最小调用（先 `PlaceNetAliasWithDialog` 看它弹什么参数），把可用形态固化成一个 `examples/place-net-alias.tcl`；
3. 把 `CapPdfPrint` / `CapPdfAddMark*` 纳入"PDF 导出"专章——现在 PDF 相关能力有两套（Dbo 侧 `capPDFExport` 脚本 + 宿主 `CapPdf*` 命令），需要说明各自适用场景。

## 9. v2 导出实测（166 条探测，含真实参数名）

v2 脚本（`scripts/export-host-commands.tcl`）在 Capture 17.4 里跑出的结果：**9,832 条命令 / 166 条探测**，`report.txt` 的关键命令核对 **21 个 YES / 2 个 `-`**（`ExecuteAction`、`ExecuteCommand` 确实不存在）。

探测按报错类型分布：`wrongnum` 105、`other` 48（多为"成功返回了值"）、`ok` 11、`overloaded` 2。

### 9.1 恢复出的签名（参数名是宿主给的，不是猜的）

| 命令 | 参数 |
| --- | --- |
| `FindBookMarks` / `FindDRCMarks` / `FindNets` / `FindParts` / `FindPins` / `FindText` / `FindOffPageConnectors` / `FindHierarchicalPorts` | `value boolvalue2`（通用桩命名，名字不可信、个数可信） |
| `FindDPByName` | `designName diffPairName` |
| `FindEcSet` | `designName ecsetName` |
| `FindXnetByName` | `designName xnetName` |
| `FindPinByNumber` | `compID pinNumber` |
| `FindProp` | `objectID propType` |
| `FindPropByName` | `objectID propName` |
| `FindProps` | `objectID propType numPropIDs propIDs` |
| `FindXMLMenu` / `FindXMLToolbar` | `pArgv` |
| `GetCompClass` | `compID` |
| `GetCompPins` | `compId numOfPins pinIDs` |
| `GetNetPins` | `netID numPins pinIDs` |
| `GetEnv` | `pEnvKey` |
| `GetLibrary` | `isNew libPath` |
| `GetDRCSettings` | `pDesignName pStrParam pStrDefault` |
| `GetECSetCnsValue` | `ecsetID propType propName` |
| `GetDPMembers` | `diffPairID memberID1 memberID2` |
| `GetDesignSpecificPM` | `pDesignName` |
| `GetColumnDataType` | `pSqlQuery` |
| `GetCisExplorerRowFieldValue` | `nRow pFieldName` |
| `GetModifiedTime` | `lFileName` |
| `GetActivateData` | `data` |

规律：`Find*` 普遍是 `(匹配值, 是否…)` 两参；`Get*` 普遍是 `(某个 ID)` 一参或 `(ID, 计数, 出参)` 三参——**"出参"形态（`pinIDs`/`propIDs`）意味着这些命令要把数组句柄传进去**，用法与 Dbo 侧的 `sMake*` 指针一致。

### 9.2 关键发现：`GetActivePMDesign` 是宿主→Dbo 的桥

零参调用直接返回活对象（探测记录里能看到类型）：

| 命令 | 返回 |
| --- | --- |
| `GetActivePM` | `_…_p_COrCapturePMDoc`（宿主文档对象） |
| `GetActivePMDesign` | `_…_p_DboDesign`（**Dbo 设计对象**） |
| `GetActiveOpjName` | `…\HSD_FPGA.opj`（工程文件路径） |
| `GetActivePage` | 无页打开时抛 `RuntimeError: Command Requires SchematicView` |
| `GetActivePMLastLibrary` | `NULL`（当前无库上下文） |

也就是说：**插件从宿主侧拿到 `DboDesign` 只需要一次 `GetActivePMDesign`**，不必自己 `DboSession_GetDesign` 去开文件；反过来 `GetActivePage` 在"没有打开的原理图页"时会直接抛错，必须 `catch` 包住。这两条把前面几轮"Dbo 面 / 宿主人面"的接缝补上了。

### 9.3 还没拿到的：`Place*` 的参数

这轮没加 `--probe-place`（默认关闭，避免交互态），所以 63 条 `Place*` 只有存在性、没有参数。下一次导出请加该开关：

```tcl
::hostdump::Run "D:/tmp/capture-host-v2-place" --probe-place
```

预期能拿到 `PlaceWire` / `PlaceNetAlias` / `PlaceOffPage` / `PlacePort` / `PlacePart` 的参数个数与名字——那是写"自动放置"工具的最后一块拼图。
