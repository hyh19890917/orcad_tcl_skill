# 事实库（给模型直接取用 · 全部有出处）

> 用法：先读本文件拿到硬结论与精确签名；需要细节/推导过程再展开对应文档。
> 标注约定：`[实测]` 本机跑过；`[原文]` Cadence 自带 tcl 调用点；`[推断]` 未单独验证；`[未知]` 明确没验证，禁止当作事实输出。

## 1. 环境事实

- `[实测]` 17.4：`Capture.exe` 内 `info commands` = **9,830**；`tclsh` + `orDb_Dll_Tcl64.dll` = **6,112**；差 ~3,718 条宿主命令。
- `[实测]` 17.4 tcl = 8.6.5 x64；17.2 = 8.6.0 x64（`D:\Cadence\SPB_17.2`，少一层目录）；16.6 = 8.4.15 x86。
- `[实测]` `tcl_platform(wordSize)` 在 Windows 上恒为 4，**不能用来判 ABI**。
- `[实测]` Dbo DLL 路径：17.4 `tools\bin\orDb_Dll_Tcl64.dll`；16.6 `tools\capture\orDb_Dll_Tcl.dll`。
- `[实测]` 命令数：16.6 = 4,962；17.2 = 6,022；17.4 = 6,109（`commands-*.txt` 口径）。
- `[实测]` `DboTclBom_*`（BOM JSON 助手）**17.x 才有**，16.6 `invalid command name`。
- `[实测]` PDF 脚本层位置：16.6 `tclscripts\capUtils\capPdfUtil.tcl`；17.4 `tclscripts\capPDFExport\tcl\capPdfUtil.tcl`。

## 2. 硬规则（违反即出错）

1. `[实测]` **对象式调用**：`$obj Method args`（self 隐含）；全局式 `DboClass_Method $obj args` 等价。写代码一律用对象式。
2. `[实测]` 方法**按继承分发**：`$design GetName` 可用，但 `DboDesign_GetName` 这个全局命令可能不存在。查存在性用 `catch {$obj Method}`，**不要用 `info commands DboX_Method`**。
3. `[实测]` 指针必须成对释放：`sMakeCString`→`sDeleteCString`、`sMakeCPoint`→`sDeleteCPoint`、`sMakeInt`→`sDeleteInt`、`sMakeBool`→`sDeleteBool`、`sMakeDboValueType`→`sDeleteDboValueType`；长脚本收尾用 `DboTclHelper_sReleaseAllCreatedPtrs`。
4. `[实测]` 迭代器用完必须 `delete_Dbo<X>Iter`（127 个，见 `iterators.md`）。
5. `[实测]` `SaveLib` 前必须 `DboSession_MarkAllLibForSave $sess $lib`，否则**返回 OK 但文件里什么都没有**（16.6 与 17.4 一致）。
6. `[实测]` `NewPackage` 之后必须 `$pkg NewDevice <designator> <position> <cell>`，否则重开库时 Package 里看不到 Part。
7. `[实测]` 任何"创建/写入"API 以**回读结果**为准，不以返回值为准（见 §3 假成功清单）。
8. `[实测]` 放置类命令失败是**抛异常**（例 `RuntimeError: Command Requires SchematicView`），必须 `catch`，不能查状态码。
9. `[原文]` 宿主命令只在 `Capture.exe` 会话存在：`RegisterAction` / `InsertXMLMenu` / `RefreshMenu` / `Place*` / `CapPdf*` 在 `tclsh` 里 `info commands` 为空。插件必须自检降级：`if {[llength [info commands RegisterAction]] == 0} { return }`。
10. `[实测]` 输出模板（HTML/JSON/日志）只用 ASCII：`tclsh` 按系统编码读脚本，源码里的中文会被双重编码成乱码；Tcl 注释里的中文无影响。
11. `[原文]` 事件注册用 `RegisterAction "_cdn*" ...`（保留名，~100 个，见 `host-event-hooks.md`）；自创名只用于自己的菜单动作。
12. `[实测]` 事务：`DboPageTransaction` 可用；保存链 `MarkAllLibForSave` + `SaveDesign`。

## 3. 假成功清单（返回 OK 但没做事）

| API | 现象 | 正确做法 |
| --- | --- | --- |
| `SaveLib`（未标记脏） | 返回 OK，重开文件为空 | 先 `DboSession_MarkAllLibForSave` |
| `SetUserPropStringValue` | code=0，但 effective/user 都仍为空 | 改走 `SetEffectivePropStringValue`（它会同时建立本地覆盖） |
| `DboWire_NewName` | code=0，别名数与 net 名均未变 | 用宿主 `PlaceNetAlias x y name` |
| `CapPdfPrint`（裸调） | code=0，2–4 ms 返回，无文件（或 0 字节 `.ps`） | 走 `::capPdfUtil::printPdf $dir $file`（内部先 `setOptionValues` 再打印再 `printPdfFromPS`） |
| `capIsPrinterDriverAvailable`（无参） | 返回空串 | 必须带驱动名：`capIsPrinterDriverAvailable "OrCADPS_17.4"` → 1/0 |

## 4. 精确签名（逐字可用）

### 4.1 Dbo 关键方法

```tcl
$part GetEffectivePropStringValue  $nameC $outC     ;# outC 需 sMakeCString 预分配
$part SetEffectivePropStringValue  $nameC $valC
$part GetUserPropStringValue       $nameC $outC     ;# 实例本地覆盖，空 = 未覆盖
$part GetEffectivePropValueType    $nameC $vtPtr $intPtr $intPtr   ;# vt=sMakeDboValueType
$part NewSymbolPinScalar $st $nameC $pinType $startCPoint $hotCPoint 1 $number
$part NewDisplayProp     $st $nameC $locCPoint 0 $fontLOGFONT 48    ;# 48=颜色，不是字号
$part SetBoundingBox     $crect
$lib  NewPackage $nameC $st ; $lib NewCell $nameC $st ; $lib NewPart "$pkg.Normal" $st
$cell AddPart $part ; $part SetCellPtr $cell ; $part SetPackagePtr $pkg
$pkg  NewDevice $designatorC $position $cell $st
$wire GetPointCount $st ; $wire GetPoint $i $st      ;# 返回 CPoint*
$po   GetPointPosition ...                          ;# 亦可用
```

### 4.2 宿主放置（`Place*`，仅 GUI 会话）

```tcl
PlaceWire      x1 y1 x2 y2
PlaceBus       x1 y1 x2 y2
PlaceLine      x1 y1 x2 y2
PlaceRectangle x1 y1 x2 y2
PlaceEllipse   x1 y1 x2 y2
PlacePolyline  x1 y1 x2 y2      ;# 续点 PlaceNextPolylinePoint
PlacePolygon   x1 y1 x2 y2      ;# 续点 PlaceNextPolygonPoint
PlaceBezier    x1 y1 x2 y2      ;# 续点 PlaceNextBezierPoint
PlaceArc       x1 y1 x2 y2 x3 y3 x4 y4
PlaceJunction  x y
PlaceNoConnect x y
PlaceNetAlias  x y netAlias
PlaceBookMark  x y markName
PlacePicture   x y fileName
PlaceText      x1 y1 x2 y2 commentText
PlacePort      x y libName symbolName PortName
PlaceOffPage   x y libName symbolName OffPageName
PlacePower     x y libName symbolName PowerName
PlaceGround    x y libName symbolName GroundName
PlaceTitleBlock x y libName symbolName titleblockName
PlacePin       x y pinName pinType boolvalue5
PlaceBlock     x1 y1 x2 y2 libName viewName instName primitiveType
PlaceNetgroupBlock  x1 y1 x2 y2 sinstName NetgroupOwner
PlaceNetgroupPort   x y libName symbolName OffPageName NetgroupOwnerName
PlaceNetgroupOffPage/Power/Ground  x y libName symbolName OffPageName NetgroupOwnerName
PlacePart      x y libName pkgName device boolvalue6
PlacePartAddLib aLibName
PlacePartSelectLibIndex / SelectPartIndex / SelectDeviceIndex  aIndex
PlacePartSelectPartByNameAndLib pPartName pLibFullPathName   ;# 批处理首选
PlacePartGetLibIndex -> 0 ; PlacePartGetPartIndex -> -1 (未选)
PlaceCisDatabasePart aPartNumber
PlaceNetgroup (零参) -> RuntimeError: Command Requires SchematicView
PlaceNew / PlacePartEx -> No matching function（真重载）
```

### 4.3 宿主 PDF（`CapPdf*`，仅 GUI 会话）

```tcl
CapPdfSetOption lOptionName lOptionValue
CapPdfGetOption lOptionName
CapPdfPrint     lOutDir lOutFileName
CapPdfAddMarkStart pStartPtX pStartPtY pEndPtX pEndPtY pId pAttributeMarkType   ;# 官方恒传 0
CapPdfAddMarkData  pName pValue
CapPdfAddMarkEnd
```

选项：`InstMode` `CreateNetBookMarks` `CreateRefdesBookMarks` `CreatePropertiesPdfFile` `LandscapeOrientation`（值一律 `"True"/"False"`）、`PaperSize`（**索引 0..69**，0=Default，3=Tabloid，9=A4）、`PostscriptDriver`（默认 `"Acrobat Distiller"`；本机 ini 值 `OrCADPS_17.4`）。

### 4.4 面板与事件

```tcl
::OrEntry<Feature>::capLaunchWidget   pStrClientId
::OrEntry<Feature>::capDestroyWidget  pStrClientId
::OrEntry<Feature>::InitDefaultDsnData pStrClientId
::OrEntry<Feature>::<Method> args...  pStrClientId    ;# clientId 恒为最后一个参数
RegisterAction <name> <enablerProc> <accel> <handlerProc> <helpText>
InsertXMLMenu [list [list <top> <sub>] "" "" [list "action" <label> "0" <action> <enabler> "" ""] ""]
RefreshMenu
```

### 4.5 JSON 工具（`orjson_*`）

```tcl
orjson_new "\5"        ;# 对象容器
orjson_new "\4"        ;# 数组容器
orjson_set_name  $node "key"
orjson_new_a / _f / _b / _i $key $value    ;# 字符串/浮点/布尔/整数，必须显式区分
orjson_push_back $parent $child
orjson_at     $arr $i
orjson_size   $arr
orjson_get    $obj $key         ;# 返回节点，必须 as_*
orjson_get_nocase $obj $key
orjson_as_string/_int/_float/_bool/_array/_node $node
orjson_parse  $str  / orjson_parse_unformatted $str
orjson_write  $node / orjson_write_formatted $node
orjson_encode64 $node / orjson_decode64 $b64
orjson_delete $node / orjson_free $node
```

### 4.6 符号编辑器（XML 往返，改已有封装的最短路径）

```tcl
::OrEntrySymbolEditorConfig::GetPackageXmL   $libPath $pkgName $encodeBase64 "hostedClientId"
::OrEntrySymbolEditorConfig::savePackageData $lib $pkgName $newXml "hostedClientId"
::OrEntrySymbolEditorConfig::GetSymbolXmL    $libPath $symbolName $encodeBase64 "hostedClientId"
::OrEntrySymbolEditorConfig::RunCommand      $jsonCmd "hostedClientId"
::OrEntrySymbolEditorConfig::initialize      $lib $pkg $mode $type $dkDoc "hostedClientId"
```

## 5. 报错文本 → 含义（探测与调试通用）

| 报错 | 含义 | 处置 |
| --- | --- | --- |
| `Wrong number of arguments :<cmd> a b c  argument N` | 参数名齐全，arity = 名字个数 | 直接按名字填参 |
| `TypeError in method 'X', argument N of type 'T'` | 第 N 参类型是 `T` | 按类型造对象（`CString&`→`sMakeCString`，`int&`→`sMakeInt`，`DboValue::ValueType&`→`sMakeDboValueType`） |
| `No matching function for overloaded 'X'` | 真重载，类型不匹配即失败 | 只能找官方调用点或按用途试参 |
| `RuntimeError: Command Requires SchematicView` | 当前没有原理图视图 | 先打开页；放置类前必须 `catch {GetActivePage}` |
| `Demo Limit Exceeded` | PSpice 演示限制 | `capPdfUtil::printPdf` 会弹 ORDBDLL:1232 消息并返回空 |
| `invalid command name "CapPdf..."` | 走错会话（headless） | 只在 Capture 内调 |
| `can't read "x": no such variable` | Tcl 侧 `$x(...)` 被当成数组下标 | 用 `${m}` 或加空格 |

## 6. 决策表

| 需求 | 选择 | 依据 |
| --- | --- | --- |
| 批量新建符号 | Dbo（`NewPackage/NewCell/NewPart/NewDevice/NewSymbolPinScalar`） | 可 headless |
| 批量改已有封装 | `GetPackageXmL` → 改 XML → `savePackageData` | `[原文]` 面板 API |
| 加网络标签 / 页间连接符 / 端口 | 宿主 `PlaceNetAlias` / `PlaceOffPage` / `PlacePort` | Dbo 无对应能力 |
| 改属性 | `SetEffectivePropStringValue` + 回读 | 会同时建立本地覆盖 |
| 对齐/分布 | 会话内用 `::capObjectAlignment::*`（含 `ConvertDocToUser`）；无宿主时自算包围盒 | `[原文]` |
| 导出 PDF | `::capPdfUtil::printPdf $dir $file`（需 GS 充当 PS→PDF） | `[原文]`+`[实测]` |
| 导出 BOM | `DboTclBom_GetBOMJSON`（读）+ `CNewBOm_*`（改结构） | `[实测]`/`[实测清单]` |
| 写面板 | `package require orPrmDesigner` + `::OrEntry<F>::capLaunchWidget "hostedClientId"` | `[原文]` |
| 页面 → 数据 | Dbo 迭代器（`NewPartInstsIter`/`NewWiresIter`/`GetPoint`） | `[实测]` |

## 7. 明确未验证（禁止当事实输出）

- `[未知]` `CapPdfAddMarkStart` 第 6 参 `pAttributeMarkType` 的**取值枚举**（官方恒 0）。
- `[未知]` `PlacePart` 第 6 参语义（先按 0 用）。
- `[未知]` `PlacePartEx` / `PlaceNew` 的重载参数。
- `[未知]` `PlaceNext*Point` 续点坐标是绝对还是相对。
- `[未知]` `DboTclHelper_sMakeDboValueType` 返回值如何**读回**枚举（`sGetInt` 无效）。
- `[未知]` `CNewBOm_*` / `CVariant_*` / `CDiff*` / `orExprEval` 的参数表（零调用点，需 `--probe-bom` 真机探）。
- `[未知]` `DBXMLWriter_*` 的 XML 结构（可用 `cap2xml.exe` 旁路研究，需 license）。
- `[未知]` 22.1+ 版本行为（只在 16.6/17.2/17.4 上实测过）。
- `[未知]` `orjson_new "\5"/"\4"` 之外的类型标记（只见过这两种）。

## 8. 可运行入口

| 目标 | 文件 |
| --- | --- |
| OLB 全量索引 | `examples/batch-olb-index.tcl` |
| 建符号 | `examples/build-symbol.tcl` |
| OLB → JSON | `examples/stream-olb.tcl` |
| 设计层级 / 单页 / 浏览器 | `examples/hier-tree.tcl` / `page-stream.tcl` / `design-browser.tcl` |
| 批量改属性 | `examples/safe-edit-prop.tcl` / `bulk-edit-csv.tcl` |
| 对齐分布 | `examples/align-objects.tcl` |
| 批量放置 | `examples/place-from-csv.tcl` |
| 导出 PDF | `examples/export-pdf.tcl` |
| 插件骨架 | `examples/plugin-skeleton.tcl` |
| 导出宿主人面 | `scripts/export-host-commands.tcl`（`--probe-place` / `--probe-pdf` / `--probe-bom`） |
