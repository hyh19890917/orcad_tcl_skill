---
name: orcad-capture-tcl-api
description: Write, extend, or debug Tcl against Cadence OrCAD Capture (16.6 / 17.2 / 17.4 / 22.1+). Covers the official Dbo Tcl API (objects, properties, iterators, marshalling), Capture host commands (menus, actions, control bars, placement), the executeTcl web-panel bridge, and headless tclsh jobs that convert XML to/from .olb symbol libraries. Load when touching any Capture .tcl plugin, generating .olb files, editing schematic properties from Tcl, or building a Capture docked panel.
---

# OrCAD Capture Tcl 开发手册

面向"要动真格写 Tcl 插件/批处理"的场景。所有结论都来自本机 Cadence 实测导出，不是凭记忆写的；参考表在 [`reference/`](reference/)，可直接 grep。

## 0. 先判定你走哪条路线

| 需求 | 路线 | 入口 |
| --- | --- | --- |
| 在 Capture 里加菜单、面板、改原理图属性、定位器件、放置器件 | **进程内插件** | `capAutoLoad\*.tcl` → `package require` / `source` |
| 批量生成/检查 .olb、XML⇄OLB 转换、脱离 GUI 的巡检 | **headless tclsh** | `tclsh script.tcl` + `load orDb_Dll_Tcl*.dll DboTclWriteBasic` |
| 给插件做网页 UI | **控制条 + executeTcl** | 见 [`host-api.md`](reference/host-api.md) 的 3.3 |

进程内插件能拿到"当前设计/选中对象"；headless 只能开文件，拿不到 GUI 状态，但不需要 Capture 在跑、可以并行。

## 1. 三个必须先确认的环境事实

写任何代码前先钉死这三件事，否则 90% 的坑都从这来：

1. **Capture 版本** → 决定可用的 Tcl 语法与命令签名。
2. **Tcl 版本** → 8.4 没有 `dict`/`try`/`binary decode base64`/`source -encoding`。
3. **Dbo DLL 的位数** → 32 位 Tcl 只能 `load` 32 位 DLL。

```powershell
# 版本 = 主程序文件版本；Tcl = 自带 tclsh 的 patchLevel
(Get-Item 'D:\Cadence\SPB_17.4\tools\bin\Capture.exe').VersionInfo.ProductVersion
'puts $tcl_patchLevel; exit' | & 'D:\Cadence\SPB_17.4\tools\bin\tclsh.exe'
```

实测矩阵（[`version-matrix.md`](reference/version-matrix.md) 有完整对照与增量）：

| Capture | Tcl | Dbo DLL |
| --- | --- | --- |
| 16.6 | 8.4.15 x86 | `<root>\tools\capture\orDb_Dll_Tcl.dll` |
| 17.2 | 8.6.0 x64 | `<root>\tools\bin\orDb_Dll_Tcl64.dll` |
| 17.4 | 8.6.5 x64 | `<root>\tools\bin\orDb_Dll_Tcl64.dll` |

**坑（会让人白折腾半天）**：`tcl_platform(wordSize)` 在 Windows 上**恒为 4**，连 64 位 Tcl 8.6.17 也返回 4。不要用它判断 ABI（见过真实的批量后端用 `wordSize` 选 DLL，结果永远先试 32 位那个）。判位数用 PE 头或直接按"先 64 后 32 / 先 32 后 64"逐个 `load` 试。

## 2. 自检：这一步必须过

```powershell
# 64 位 release；16.6 换成 tools\capture\orDb_Dll_Tcl.dll 与 32 位 tclsh
$env:PATH = 'D:\Cadence\SPB_17.4\tools\bin;' + $env:PATH   # DLL 依赖同目录
'load D:/Cadence/SPB_17.4/tools/bin/orDb_Dll_Tcl64.dll DboTclWriteBasic; puts [llength [info commands Dbo*]]; exit' |
  & 'D:\Cadence\SPB_17.4\tools\bin\tclsh.exe'
```

- 成功：输出命令数（16.6=3927，17.2=4483，17.4=4185 个 `Dbo*`，总命令数见矩阵）。
- `invalid argument` = 位数不匹配（Tcl 对此只有这一句提示）。
- `couldn't load file` = 依赖 DLL 不在 `PATH`（把 `tools\bin` / `tools\capture` 加进去）。

## 3. 调用形态：两种写法都合法，先记住这个

Dbo 把 C++ 成员注册成**全局命令** `Dbo<类>_<方法>`，同时每个对象本身就是一条 Tcl 命令（名字形如 `_1a2b_p_DboLib`）。所以：

```tcl
# 对象形态：self 隐含
set st [$lib GetPackage $name $state]

# 全局形态：self 显式（和对象形态完全等价）
set st [DboLib_GetPackage $lib $name $state]
```

返回值规律（实测）：**返回字符串/数值的方法同时返回一个 `DboState` 对象**，必须 `$st -delete`；返回对象的方法返回对象名或 `"NULL"`。

```tcl
set state [$obj GetName $name]      ;# $state 是 DboState
if {![$state OK]} { ... }           ;# 或 [$state Failed]
$state -delete                      ;# 不删会泄漏
```

**全局命令只按"声明类"注册**（这条决定你查表的方式）：

- `DboBaseObject_GetName` 存在，`DboDesign_GetName`、`DboSchematic_GetName` **不存在** —— 因为 `GetName` 声明在基类；
- 但运行时 `$design GetName $ptr` **完全可用**：对象命令沿继承链解析方法。

所以：**写代码一律用对象形态**（`$obj Method`），[`signatures.md`](reference/signatures.md) 当"方法名 + 参数"字典来 grep（按声明类搜索），不要因为查不到 `DboXxx_某方法` 就以为方法不存在。

**签名从哪查**：[`signatures.md`](reference/signatures.md)（按类分组，含 C++ 类型）或 [`signatures-17.4.csv`](reference/signatures-17.4.csv)。想要任意 release 的真实签名，跑 [`dump-dbo-signatures.tcl`](scripts/dump-dbo-signatures.tcl) —— 它零参调用每条命令，宿主会把完整参数表打进错误信息：

```text
% DboLib_GetPackage
Wrong number of arguments :DboLib_GetPackage self name status  argument 1
```

## 4. 最小可运行骨架

### 4.1 进程内插件（有 GUI，能读当前设计）

```tcl
namespace eval ::demo {}
proc ::demo::Init {} {
    # 1) 注册 action（宿主按 id 回调）
    RegisterAction "demoOpen" "::demo::Enabled" "" "::demo::Run" ""
    # 2) 建 XML 菜单（FindXMLMenu 返回 "NULL" 表示不存在）
    if {[FindXMLMenu [list "demo"]] eq "NULL"} {
        InsertXMLMenu [list [list "demo"] "" "" [list "popup" "Demo" "0"]]
        InsertXMLMenu [list [list "demo" "Run"] "" "" [list "action" "Run" "0" "demoOpen" "demoOpen"]]
    }
    if {[llength [info commands RefreshMenu]]} { RefreshMenu }
}
proc ::demo::Enabled {args} { return true }
proc ::demo::Run {args} { ::demo::DumpDesign }
```

> 也可以只在 `capAutoLoad` 里 `source` 上面的文件并调用 `::demo::Init`。注意宿主在 `capAutoLoad` 之后会重建菜单，若要自动出现，用 `after 1000` 重试（实践中用 4 次上限）。

### 4.2 headless 批处理（无 GUI，只能开文件）

```tcl
set root "D:/Cadence/SPB_17.4"
foreach n {orDb_Dll_Tcl64.dll orDb_Dll_Tcl.dll} {
    foreach sub {bin capture} {
        set dll [file join $root tools $sub $n]
        if {[file exists $dll] && ![catch {load $dll DboTclWriteBasic}]} { set loaded 1; break }
    }
    if {[info exists loaded]} break
}
set s  [DboTclHelper_sCreateSession]
set st [DboState]
set p  [DboTclHelper_sMakeCString "C:/work/lib.olb"]
set lib [DboSession_GetLib $s $p $st]
if {$lib eq "NULL" || [$st Failed]} { error "open failed" }
# ... 干活 ...
DboSession_RemoveLib $s $lib
DboTclHelper_sDeleteCString $p
$st -delete
DboTclHelper_sDeleteSession $s
```

完整可用版见 [`batch-olb-index.tcl`](examples/batch-olb-index.tcl)（把 OLB 里的 Package/Part/Pin 全量导出成 TSV）。

## 5. 对象模型地图

| 层 | 类 | 拿法 | 关键方法 |
| --- | --- | --- | --- |
| 会话 | `DboSession` | 进程内 `$::DboSession_s_pDboSession`；批处理 `DboTclHelper_sCreateSession` | `GetLib` `GetOpenLib` `CreateLib` `RemoveLib` `SaveLib` `GetActiveDesign` `GetOpenDesigns` |
| 库 | `DboLib` | `DboSession_GetLib` / `CreateLib` | `NewPackagesIter` `NewPartsIter` `GetPackage` `CopyPackageAll` `SavePackageAll` `SetPCBFootprint` `MarkModified` |
| 设计 | `DboDesign` | `DboSession_GetActiveDesign`（GUI）/ `GetDesign` | `NewViewsIter` `GetSchematic` `NewPartInstsIter` `NewCachesIter` |
| 原理图 | `DboSchematic` | `DboDesign_GetSchematic` 或 `DboViewToDboSchematic` | `NewPagesIter` `GetPage` `Expand` |
| 页 | `DboPage` | `DboSchematic_GetPage` / `NewPagesIter` | `NewPartInstsIter` `NewWiresIter` `NewNetsIter` `NewPortsIter` `GetOwner` |
| 实例 | `DboPartInst` | `DboPage_NewPartInstsIter` | `GetId` `GetObjectType` `GetEffectivePropStringValue` `NewDisplayPropsIter` |
| 层级发生 | `DboInstOccurrence` | `DboOccurrenceToDboInstOccurrence` | `GetPartInst` `GetId` `IsPrimitive` `NewChildrenIter` |
| 符号 | `DboLibPart` / `DboPackage` / `DboDevice` | `DboLib_NewPartsIter` / `GetPackage` / `DboPackage_NewDevicesIter` | `NewLPinsIter` `GetPinPosition` `NewDevicesIter` `GetCellName` |
| 管脚 | `DboSymbolPin` | `DboLibPart_NewLPinsIter` | `GetPinName` `GetPinType` `GetIsVisible` `GetHotSpot` `NewDisplayProp` |
| 属性标注 | `DboDisplayProp` | `Dbo*_GetDisplayProp` / `NewDisplayProp` | `SetLocation` `SetRotation` `SetFont` `SetDisplayType` `SetColor` |
| 值 | `DboValue` | `DboTclHelper_sMakeDboValue` | `SetColor` `GetString`（颜色表 0–48） |
| 状态 | `DboState` | `DboState`（构造）/ 各方法返回 | `OK` `Failed` `-delete` |

对象类型码（`GetObjectType`）实测/推断：`5`=Lib，`13`=PartInst，`31`=设计缓存里的 Package，`66`=InstOccurrence。判断"是不是 occurrence"用 66，别用类名猜。

### 5.1 显示属性放到器件旁边（别自己算坐标）

`DboPartInst_PositionDisplayProp <page> <displayProp>` 让 Capture 用它自己的算法把显示属性贴到器件旁，效果等同"手动取消选中后属性自动归位"。17.4 实测可用，比自己算 anchor 坐标稳得多：

```tcl
set dp [$inst NewDisplayProp $st $namePtr $org $::DboValue_NOROTATION $lf 8]
$dp SetDisplayType $::DboValue_VALUE_ONLY
set page [$inst GetOwner]
DboPartInst_PositionDisplayProp $page $dp     ;# 关键：交给宿主定位
```

- 多 pin（IC）器件效果特别好；2 pin 阻容可以继续用"逐行下推"的自算方式。
- 顺序不能反：先 `NewDisplayProp`，再定位。
- 想微调就在定位后 `$dp GetLocation $st` 读回坐标、叠加偏移再 `SetLocation`。
- 同一器件连续放多个属性（Value / PCB Footprint / 自定义）时，每次造完就定位一次，Capture 会自己错开。

## 6. 属性模型：三套语义，别混

| 诉求 | API | 说明 |
| --- | --- | --- |
| 读"生效值"（含继承） | `GetEffectivePropStringValue <name> <out>` | 实例/l库/共享页合并后的值 |
| 写"实例覆盖" | `SetEffectivePropStringValue <name> <value>` | 在实例层建档 |
| 只读/删"本地值" | `GetUserPropStringValue` / `DeleteUserProp` | 删本地值才会回落到继承值 |
| 删继承覆盖 | `DeleteEffectiveProp <name>` | 影响所有引用同一定义的对象 |
| 遍历全部生效属性 | `NewEffectivePropsIter` + `NextEffectiveProp <name> <value> <type> <editable>` | `type`/`editable` 是复用型指针（见 §7） |
| 标注（显示） | `GetDisplayProp` / `NewDisplayProp` / `DeleteDisplayProp` | 与"值"分开：可见性、位置、字体、颜色 |

写属性的固定套路（**先读 before，再写，再回读校验，失败回滚**）：

```tcl
set before [::x::Text $obj GetEffectivePropStringValue $name]
set st [$obj SetEffectivePropStringValue $namePtr $valuePtr]
if {![$st OK]} { $st -delete; error "write rejected" }
$st -delete
$obj MarkModified
if {[::x::Text $obj GetEffectivePropStringValue $name] ne $value} { error "readback mismatch" }
```

[`safe-edit-prop.tcl`](examples/safe-edit-prop.tcl) 是带回滚的完整版。

## 7. 指针与值编组（`DboTclHelper_*`，90 个）

| 类型 | 造 | 读 | 删 |
| --- | --- | --- | --- |
| C 字符串 | `sMakeCString <str> ?0?` / `sMakeCStringAppOwned` | `sGetConstCharPtr` | `sDeleteCString` |
| 整数/布尔/无符号 | `sMakeInt` `sMakeBool` `sMakeULong`（都有 `AppOwned` 变体） | `sGetInt` `sGetBool` `sGetULong` | `sDeleteInt` `sDeleteBool` `sDeleteULong` |
| 坐标/矩形/尺寸 | `sMakeCPoint` `sMakeCRect` `sMakeCSize` | `sGetCPointX/Y` `sGetCRectTopLeft/BottomRight` `sGetCSizeX/Y` | `sDeleteCPoint` `sDeleteCRect` `sDeleteCSize` |
| 字体 | `sMakeLOGFONT <face> <h> <w> <esc> <orient> <weight> …`（14 参） | `sGetLFHeight` `sGetLFName` `sGetLFWeight` … | `sDeleteLOGFONT` |
| 值/类型 | `sMakeDboValue` `sMakeDboValueType` | `DboValue_GetString` 等 | `sDeleteDboValue` `sDeleteDboValueType` |
| 容器 | `sMakeStdStr` `sMakeStdVector` `sPushBackToVector` `sMakeCStringSet` `sAddToStringMap` | `sGetVectorSize` `sGetStringMap` | `sDeleteStdStr` `sDeleteStringMap` `sDeleteCStringSet` |

**所有权规则（最容易踩）**：默认造的指针会被宿主**登记**，在编辑器关闭时统一释放；自己也会释放 → 二次释放崩溃。两种正确做法：

1. 用 `sMakeCString <str> 0`（第二参 0 = 不登记）或 `sMakeCStringAppOwned`，自己 `sDeleteCString`；
2. 或者全部登记、结束时统一 `DboTclHelper_sReleaseAllCreatedPtrs`。

另外：`sMakeDboValueType` / `sMakeInt` 在 25.1 没有单独释放 API，**做成会话级复用**（每次 `NextEffectiveProp` 前重置），不要每行都造。

## 8. 迭代器协议

```tcl
set it [$page NewPartInstsIter $st]      ;# New*Iter
for {set o [$it NextPartInst $st]} {$o ne "NULL"} {set o [$it NextPartInst $st]} {
    # ...
}
delete_DboPagePartInstsIter $it          ;# 用同名 delete_ 命令
catch {$it -delete}                      ;# 部分版本两者只生效其一
```

- 迭代器类名 = `Dbo<X>Iter`，`Next` 方法名随类型不同（`NextPart` / `NextPage` / `NextProp` / `NextWire` …）。全表见 [`iterators.md`](reference/iterators.md)。
- 通用成员：`GetKey` `Next`。
- **不要**用错的 `delete_`：每个迭代器只认自己那条（`delete_DboPagePartInstsIter` ≠ `delete_DboLibPartsIter`）。

## 9. 事务、保存、回滚

```tcl
# 设计
$obj MarkModified
DboSession_MarkAllLibForSave $s $design    ;# 或 $obj 所在的 lib
DboSession_SaveDesign $s $design
# 库
$lib MarkModified
DboSession_MarkAllLibForSave $s $lib
DboSession_SaveLib $s $lib
```

铁律：**改完必须回读**（`GetEffectivePropStringValue` 再读一次比对），不一致就按逆序恢复并放弃保存。Cadence 的 DB 层会拒绝某些写入而不报错（`DboState` 为 OK 但值没变），只信回读。

## 10. GUI 集成（菜单 / 控制条 / 网页面板）

- 菜单：`RegisterAction` + `InsertXMLMenu` / `FindXMLMenu` / `DeleteXMLMenu` / `RefreshMenu`，动态菜单挂 `_cdnCapTclAddPageCustomMenu` / `_cdnCapTclAddDesignCustomMenu` + `AddAccessoryMenu`。
- 面板：`package require orPrmWebComp 1.0` + `orPrm::CreateControlBar` / `LoadResource` / `ShowWidget` / `Execute`；CEF 机型用 `::orPrm::WF_CEF` 标志。
- 网页 → Tcl：宿主桥 `executeTcl`（CEF `OrDzServerInterface.nativeCall`，IE `window.external.orPrmConnector`）。
- 完整命令表、参数形态与坑见 [`host-api.md`](reference/host-api.md)。

## 11. 版本适配清单（照这个顺序改，别猜）

1. `capture/<root>/tools/capture/tclscripts` 里是否有你要用的命令 → 没有就换路线。
2. 字符串/菜单：16.6 的菜单标题**只用 ASCII**（宿主有 ANSI/UTF-8 转换缺陷），中文放进网页或 `.tcl` 内部数据。
3. `PlacePartEx` 签名：早期 17.4 只有 6 参重载，≥22.1 有 7 参（第 7 参控制是否继承 Characteristic 显示行）。16.6/17.2 用 `PlaceNew`。
4. `XMATIC_XML2OLB`：16.6 只有 2 参重载，新版 5 参（xml,olb,mode,log,callback）；重试前先确认错误文本是 `No matching function for overloaded`，不要把解析错误也重试成另一签名。
5. 8.4 环境：`dict`→数组/列表、`try`→`catch … options`、`binary encode base64`→`base64::encode -maxlen 0`、`source`→切 `encoding system`。
6. CEF 生命周期：17.4 退出/Ota 重开时宿主会卸载 libcef 后再回调（崩溃点）。要么别在 `PreExit` 里 `DestroyWidget` 活跃控制条，要么 `load` 一个保活 DLL。

## 12. 已知坑（每一条都有出处）

1. `tcl_platform(wordSize)` 在 Windows 恒 4 —— 别判 ABI。
2. `sMakeCString` 默认登记 → 与宿主二次释放；用 `0` 或 `AppOwned`。
3. 忘记 `$state -delete` / 忘记 `delete_Dbo*Iter` → 长会话泄漏、最终卡死。**显示属性相关流程最容易漏**（`NewDisplayProp`/`SetLocation` 前后都会新造 state）：一个 proc 里复用同一个 `DboState`，`return` 前统一 `-delete` 最省心。
4. 25.1 的 `DboValue_SetColor` 返回未初始化的 state；用 `GetString` 当权威结果。
5. 设计属性 >32767 字节时 Capture 25.1 会崩 → 分块写：首字段放"块数+版本"，每块 base64，单块约 16 KB，写后回读校验。
6. `CopyPackageAll` 会丢内置管脚标注 → 复制后逐管脚补 `NewDisplayProp`。
7. 16.6 会对负字号做取整缩水；用 `GetLFHeight` 二分补偿。
8. 没有 `Redraw` 命令，但 **`Menu View::Zoom::Redraw` 可用**（17.4 实测）：新增/删除显示属性（`NewDisplayProp`/`DeleteDisplayProp`）后必须调它才会立刻刷新，否则要等取消选中才显示出来。批量操作收尾时再用 `ui::SchematicActivate [capGetMostRecentSchFrameID]` 刷一次更保险。
9. `http::geturl` 会进 `vwait`；在退出/销毁路径上用它可能重入宿主事件循环 → 用 `socket -async` + 手写 HTTP。
10. 菜单/action 的 `InsertXMLMenu` 是幂等的：先 `FindXMLMenu` 判 `"NULL"`，升级时先 `DeleteXMLMenu` 再插，否则会出现重复项。
11. 别在 `capAutoLoad` 阶段做长耗时操作（`package require`、`file`、网络），宿主还没进事件循环；用 `after`。
12. `DboSession_GetActiveDesign` 只在 GUI 进程内有意义；headless 下用 `GetDesign`/`GetLib`。
13. **库里的东西不一定叫 Package**：`capsym.olb`（电源/地/图框符号）用 `NewPackagesIter` / `NewPartsIter` / `NewCellsIter` 全部枚举为 0，只有 `NewSymbolsIter` 能列出 38 个 Symbol（`GND_EARTH`、`TitleBlock0`…）。写"库清单"类功能时必须做 Package→Symbol 兜底，否则会漏掉整类库。
14. 枚举计数别只信 `NewPackagesIter` 的首项：先在 `Discrete.olb` 这类常规库上验证逻辑（实测 1200 packages / 9492 行），再对特殊库跑兜底分支。

## 13. 验证

```powershell
# 语法/装载检查（不需要 Capture）：把 source 包一层，8.4 与 8.6 各跑一遍
Set-Content -Path _check.tcl -Encoding ascii -Value @'
if {[catch {source D:/work/yourscript.tcl} e]} { puts "FAIL: $e"; puts $::errorInfo } else { puts OKLOAD }
exit 0
'@
& 'D:\Cadence\Cadence\SPB_16.6\tools\tcl84\bin\tclsh84.exe' _check.tcl   # 8.4 语法关
& 'D:\Cadence\Cadence\SPB_17.4\tools\bin\tclsh.exe'        _check.tcl   # 8.6 语法关
```

- 单元级：把 Dbo 调用包一层，先跑 headless 版（文件级）验证逻辑，再进 GUI。[`batch-olb-index.tcl`](examples/batch-olb-index.tcl) 就是可跑的回归基线（对同一批 OLB 输出 diff）。
- 集成级：在 Capture 里 `source` 后 `puts` 关键状态；把 `$::errorInfo` 原样打到日志（Tcl 的错误链比 `catch` 的结果有用得多）。
- 宿主能力检测统一用 `if {[llength [info commands <cmd>]]}`，不要按版本号硬分叉。

## 14. 官方脚本里的范式（564 个文件实测统计）

Cadence 自己用这套 API 写了 564 个官方 tcl（`tools\capture\tclscripts`，约 4.2 MB）。统计它们的写法，能直接回答"哪些是官方惯例、哪些只适合一次性脚本"：

- 字符串：`sMakeCString` 1315 次 vs `sDeleteCString` 141 次，其中只有 78 次带 `0` → **官方多数依赖宿主清理**；
- 状态：441 个 `DboState`，显式判 `OK`/`Failed` 仅约 34 处 → **官方大量忽略状态**；
- 属性：`GetEffectivePropStringValue` 109 次，`GetUserPropStringValue` **0 次** → 官方只用 effective 语义，几乎不碰本地值；
- 迭代器：`delete_Dbo*Iter` 176 次 → 按类型释放是官方惯例。

**结论**：官方样本是"跑完就退"的短生命周期写法；常驻插件必须自己管指针、判状态、写后回读（见 §12 的坑）。

另外三样现成的东西别自己造：宿主预置常量（`::IterDefs_*` / `::DboValue_*`，别硬编码 90/270 这类魔法数）、官方封装包（`capDB` 的 `capLibPropUtil`/`capDboGeom`、`orPrmDboUtils`）、官方标注位置算法（包围盒右下角 + 已有标注最大 Y + 10）。

完整频次表、常量清单、七组"官方 → 常驻插件"对照、可抄范式与反模式清单见 [`official-patterns.md`](reference/official-patterns.md)。

还有一批**存在但官方 tcl 从未使用**的进阶族——事务与撤销（DboPageTransaction）、BOM/器件 JSON（DboTclBom、DboTclUtils_*JSON）、位号状态机（DboRefDes*）、路径与内存目录（DboPathMgr/DboDirectory）、扩展属性、以及官方 web 宿主（orPrmWebApp）。用它们能省掉大段自研代码，但没有官方示例，需先自测：见 [dbo-advanced.md](reference/dbo-advanced.md)。

## 15. 文件索引

| 文件 | 内容 |
| --- | --- |
| [`signatures.md`](reference/signatures.md) | **主查表**：3941 条命令的官方参数名与 C++ 类型（17.4），按类分组 |
| [`signatures-17.4.csv`](reference/signatures-17.4.csv) / `.tsv` | 同上，机读（command,class,method,params,note） |
| [`dbo-classes.md`](reference/dbo-classes.md) | 291 个类的成员总表（17.4） |
| [`dbo-commands-17.4.csv`](reference/dbo-commands-17.4.csv) / `-16.6.csv` | 类/方法/种类/命令名，便于 diff |
| [`iterators.md`](reference/iterators.md) | 127 个迭代器 → Next 方法 → delete 命令 |
| [`host-api.md`](reference/host-api.md) | Capture 宿主命令（菜单、控制条、放置、文档）与 executeTcl 桥 |
| [`marshalling.md`](reference/marshalling.md) | 90 个 `DboTclHelper_*` 分组与所有权规则 |
| [`version-matrix.md`](reference/version-matrix.md) | 三版本实测对照、增量、适配清单 |
| [official-patterns.md](reference/official-patterns.md) | 官方 564 个 tcl 的用法统计、宿主常量、capDB/orPrmDboUtils 封装、推荐范式与反模式 |
| [dbo-advanced.md](reference/dbo-advanced.md) | 进阶族：事务/撤销、器件与 BOM JSON、位号标注、路径与内存目录、扩展属性、官方 web 宿主 |
| [`commands-16.6.txt`](reference/commands-16.6.txt) · [`-17.2`](reference/commands-17.2.txt) · [`-17.4`](reference/commands-17.4.txt) | 全量命令名（diff / grep 用） |
| [`dump-dbo-api.tcl`](scripts/dump-dbo-api.tcl) | 换机器/换版本时重新导出命令面 |
| [`dump-dbo-signatures.tcl`](scripts/dump-dbo-signatures.tcl) | 重新导出参数签名（零参调用法） |
| [`probe-calling-form.tcl`](scripts/probe-calling-form.tcl) | 验证调用形态 / 对象命名 / 类型码 |
| [`debug-olb.tcl`](scripts/debug-olb.tcl) | 单库诊断：打开是否成功、Package 迭代器是否为空 |
| [`batch-olb-index.tcl`](examples/batch-olb-index.tcl) | headless：OLB → TSV（Package/Symbol/Part/Pin 全量，已对真实库验证） |
| [`safe-edit-prop.tcl`](examples/safe-edit-prop.tcl) | 批量改属性：before/after 校验 + 逆序回滚（8.4 兼容） |
| [`probe-design.tcl`](examples/probe-design.tcl) | 进程内：设计/页/实例/选中体检（只读） |
| [`plugin-skeleton.tcl`](examples/plugin-skeleton.tcl) | 进程内：菜单 + 控制条 + executeTcl 白名单入口骨架 |

> `signatures.*` 目前只导出了 17.4；16.6 / 17.2 只有命令面（`commands-*.txt`）。需要签名时按 §4 的两行命令自己生成对应版本即可（同一脚本，换 DLL 与输出名）。

重新生成整套参考（换 Cadence 版本时）：

```powershell
$env:PATH = '<root>\tools\bin;' + $env:PATH
'<root>\tools\bin\tclsh.exe' scripts\dump-dbo-api.tcl '<root>\tools\bin\orDb_Dll_Tcl64.dll' reference\commands-<ver>.txt
'<root>\tools\bin\tclsh.exe' scripts\dump-dbo-signatures.tcl '<root>\tools\bin\orDb_Dll_Tcl64.dll' reference\signatures-<ver>.tsv
```
