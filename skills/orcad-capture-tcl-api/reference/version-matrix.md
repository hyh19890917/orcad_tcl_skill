# 版本对照与 API 增量（本机实测）

数据来自三台本机安装：对每个 release 的 `orDb_Dll_Tcl*.dll` 执行 `scripts/dump-dbo-api.tcl`，命令总数与类数由命令名前缀统计。

## 1. 环境矩阵

| Capture | Capture.exe 版本 | Tcl | 位数 | Dbo DLL | DLL 大小 | 全量命令 | `Dbo<类>_` 类数 | helper | delete_ | XMATIC | 强转 DboXToDboY |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 16.6 | 16.6.0 | 8.4.15 | x86 | `<root>\tools\capture\orDb_Dll_Tcl.dll` | 22.3 MB | 4962 | 277 | 74 | 145 | 14 | 109 |
| 17.2 | 17.2-2016 | 8.6.0 | x64 | `<root>\tools\bin\orDb_Dll_Tcl64.dll` | 41.9 MB | 6022 | 286 | 87 | 146 | 18 | 112 |
| 17.4 | 17.4-2019 | 8.6.5 | x64 | `<root>\tools\bin\orDb_Dll_Tcl64.dll` | 41.7 MB | 6109 | 291 | 90 | 151 | 18 | 112 |

本机路径：16.6 与 17.4 在 `D:\Cadence\Cadence\SPB_*`，17.2 在 `D:\Cadence\SPB_17.2`（注意不是同一层）。商业插件常支持、但本机未装的版本：22.1 / 23.1 / 24.1 / 25.1 / 26.1。

## 2. 增量

| 跳变 | 新增命令 | 移除命令 | 新增类 |
| --- | --- | --- | --- |
| 16.6 → 17.2 | +1069 | −9 | 9 |
| 17.2 → 17.4 | +88 | 0 | 5 |

17.2 新增的类（与设计比较/BOM/JSON 相关，说明从 17.2 起官方把 CIS 侧的设施也暴露进了 Tcl）：

`DboConnectivityChangeIter` `DboDBQuery` `DboJsonUtils` `DboObjectLocationStruct` `DboPageStructOcc` `DboRefDesLog` `DboRefDesRTData` `DboTclBom` `DboTclUtilHelper`

17.4 新增的类（实例发生/封装实例遍历，配合 `DboDesignPackageInstOcc` 系列）：

`DboConnectivityObjectsAtPointIter` `DboDesignPackageInstOccIter` `DboPackageInstOccurrencesIter` `DboPackageReferencedPartInstIter` `DboPkgInstOcc`

16.6 → 17.2 被移除的 9 条命令（升级时要改调用点；可用 `reference/commands-16.6.txt` 与 `-17.2.txt` diff 复现）：

```powershell
Compare-Object (Get-Content reference\commands-16.6.txt) (Get-Content reference\commands-17.2.txt) |
  Where-Object SideIndicator -eq '<=' | Select-Object -ExpandProperty InputObject
```

## 3. 各版本必须注意的行为差异

| 项 | 16.6 | 17.2 | 17.4 | 22.1+ |
| --- | --- | --- | --- | --- |
| Tcl 语法 | 8.4：无 `dict`/`try`/`binary decode base64`/`source -encoding` | 8.6 | 8.6 | 8.6 |
| 放置 | `PlaceNew lib part unit` | `PlaceNew` | `PlacePartEx` 6 参 | `PlacePartEx` 7 参（末尾 `1`） |
| Web 面板 | IE WebBrowser（`orPrmWebComp 1.0`） | IE | CEF（`::orPrm::WF_CEF`）或 IE | CEF |
| `IsSchematicViewActive` | 有 | 有 | 无（用 `capGetIsSchematicEditingDisabled`） | 同 17.4 |
| `XMATIC_XML2OLB` | 2 参 | 5 参 | 5 参 | 5 参 |
| 设计属性长度上限 | 未验证 | 未验证 | 未验证 | 25.1 上 >32767 字节会崩，需分块 |
| Dbo 对象命令 | 有 | 有 | 有 | 有（25.x 增加了 `DboTclBom` 等） |

## 4. 适配一个新 release 的标准动作

```powershell
$root = 'D:\Cadence\SPB_23.1'
$tclsh = "$root\tools\bin\tclsh.exe"          # 有的版本在 $root\tcltk\bin
$dll   = "$root\tools\bin\orDb_Dll_Tcl64.dll"
$env:PATH = "$root\tools\bin;" + $env:PATH

& $tclsh scripts\dump-dbo-api.tcl        $dll reference\commands-23.1.txt
& $tclsh scripts\dump-dbo-signatures.tcl $dll reference\signatures-23.1.tsv
```

然后：

1. **diff 命令面** —— 找出你依赖的命令是否还在（`DboLib_NewPartsIter` 这类核心命令从未变过，变动集中在新增类）。
2. **diff 签名** —— `DboPartInst_GetId` 这种老命令签名极稳定；变化通常发生在"过载"命令（`GetEffectivePropStringValue`、`NewLPinsIter`、`NewViewsIter`、`XMATIC_*`）。
3. **跑 `examples/batch-olb-index.tcl`** 对同一批 OLB 做输出 diff —— 这是最省事的回归测试。
4. 检查 `info commands` 里宿主命令是否改名/消失（`IsSchematicViewActive` 就是一例）。

## 5. 对象形态 vs 全局形态（版本无关，但必须理解）

`Dbo<类>_<方法>` 只按**声明类**注册，所以：

- `DboBaseObject_GetName` 存在；
- `DboDesign_GetName` / `DboSchematic_GetName` **不存在**（它们继承 `GetName`）；
- 但 `$design GetName $ptr` 在运行时**可用**——对象命令沿继承链解析方法。

结论：**写代码用对象形态**（`$obj Method`），查方法名用全表 grep（按 declaring class 搜）。全局形态主要用于"从对象名反向调用"和探测 API 面。

## 6. 别外推

- 22.1 及以上版本本机没有，本文件不臆测其增量；用 §4 的脚本自己生成。
- 各版本的 `orPrm::*` 宿主命令参数未见官方文档，`reference/host-api.md` 里的形态来自真实调用点，跨大版本时要用 `info commands` 做能力检测。

## 行为差异（实测，同一套探针跑两版）

探针脚本：`createLib → NewPackage/NewCell/NewPart → AddPart/SetCellPtr/SetPackagePtr → NewDevice → NewSymbolPinScalar ×2`，分别在 **16.6（tclsh 8.4.15 x86 + `tools\capture\orDb_Dll_Tcl.dll`）** 与 **17.4（tclsh 8.6.5 x64 + `tools\bin\orDb_Dll_Tcl64.dll`）** 上跑：

| 行为 | 16.6 | 17.4 | 结论 |
| --- | --- | --- | --- |
| `SaveLib` 前不 `MarkAllLibForSave` | `save=ok`，重开 pkg=0/part=0/pin=0 | 同 | **两版都会静默不写**，规则通用 |
| 加 `DboSession_MarkAllLibForSave` 后 | 重开 pkg=1/part=1/pin=2 | 同 | 两版都正确落盘 |
| `$wire GetPointCount $st` | 返回 2 | 返回 2 | 形态一致 |
| `$wire GetPoint 0 $st` | 返回 `CPoint*` | 返回 `CPoint*` | 形态一致（指针串在 32 位下更短，不影响用法） |
| `DboTclBom_GetBOMOptionsJSON` | **不存在**（`invalid command name`） | 存在，返回 `std::string*` | BOM JSON 助手是 **17.x 才有** |

两条工程结论：

1. **写插件时若要把脚本放进 16.6 也能跑的地方，只用 Tcl 8.4 语法**（别用 `dict`/`lmap`/`{*}` 的复杂形态）；探针脚本 `probe-166-vs-174.tcl` 就是这么写的，两版都能执行。
2. 判"功能是否存在"不要按版本号猜，用 `[llength [info commands DboTclBom_GetBOMOptionsJSON]]` —— 17.2/17.4 有、16.6 没有，这属于族级差异而非签名差异。