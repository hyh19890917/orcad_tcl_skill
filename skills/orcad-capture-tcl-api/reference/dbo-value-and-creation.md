# DboValue 类型与"创建类" API：实测到的长相

签名表里 `GetEffectivePropValueType self,name,nType,bEditable,bDeletable` 看不出参数到底是什么；`NewJunction`/`NewName`/`NewOffPageConnector` 只知道名字。下面全部是用**类型错误文本 + 回读**测出来的。

## 1. `GetEffectivePropValueType` 的真实参数

签名表：`self,name,nType,bEditable,bDeletable`。用"传错类型看报错"的办法逐位逼出来：

| 传参 | 报错 | 结论 |
| --- | --- | --- |
| 第 3 个传 Tcl 变量名 / `sMakeInt` | `argument 3 of type 'DboValue::ValueType &'` | 第 3 参是**枚举引用**，不是 int |
| 第 3 个传 `DboTclHelper_sMakeDboValueType` | `argument 4 of type 'int &'` | 第 3 参对了；第 4 参是 **int** |
| 第 4 个传 `sMakeBool` | 同上（仍报 arg4） | bool 指针**不被接受**，必须 `sMakeInt` |
| 第 4/5 传 `sMakeInt` | 调用成功（code=0） | 正确组合 |

可用调用：

```tcl
set vt [DboTclHelper_sMakeDboValueType]          ;# DboValue::ValueType*
set e  [DboTclHelper_sMakeInt 0]                 ;# int*  editable
set d  [DboTclHelper_sMakeInt 0]                 ;# int*  deletable
set code [catch {$part GetEffectivePropValueType $nameC $vt $e $d} err]
# 读 editable/deletable：
set editable  [DboTclHelper_sGetInt $e]
set deletable [DboTclHelper_sGetInt $d]
# 清理：
DboTclHelper_sDeleteDboValueType $vt
DboTclHelper_sDeleteInt $e
DboTclHelper_sDeleteInt $d
```

**部分解决（2026-11-28 实测）**：`ValueType*` 本身仍读不出数值，但**枚举的编号体系已经被测出来**，配套的类型名查询也可用：

```tcl
# 1) 枚举值 → 类型名（实测可用，0..16）
set out [DboTclHelper_sMakeCString ""]
DboValue_GetLogicalTypeName $enumValue $out
set typeName [DboTclHelper_sGetConstCharPtr $out]      ;# 见下表
DboTclHelper_sDeleteCString $out
```

| 枚举 | 名称 | 枚举 | 名称 |
| --- | --- | --- | --- |
| 0 | String | 9 | Line Width |
| 1 | Long Integer | 10 | Fill Style |
| 2 | Integer | 11 | Hatch Style |
| 3 | Boolean | 12 | Rotation Value |
| 4 | Color | 13 | Primitive Type |
| 5 | Font | 14 | Implementation Type |
| 6 | Time | 15 | Display Type |
| 7 | Pin Type | 16 | Invalid Object |
| 8 | Line Style | | |

`[实测]` **`DboValue::ValueType` 与这套 LogicalType 用的是同一套编号**——用 `sMakeDboValue` + 各 `Set*` 后读 `$v GetType $st` 得到：`SetString`→0、`SetLong`→1、`SetInt`→2、`SetColor`→4、`SetLineWidth`→9、`SetRotation`→12、`SetDisplayType`→15，与上表逐一吻合（注意：同一个 `DboValue` 连续调不同 `Set*` 时类型不一定会变，要每次新建对象再测）。

结论：**类型名可以直接查；类型值只能间接获得**——`GetEffectivePropValueType` 的第 3 参是只写不读的 `ValueType&`。补充两条实测依据：

- `DboTclHelper_sGetInt $vt` 返回空（读不出）；`sGetBool`/`sGetULong` 同样无值。
- **`DboTclHelper_sCastPtr` 用猜测的参数组合会让 tclsh 直接崩溃**（`sCastPtr "int" $vt $i` 实测把进程打死）。要么确定签名再试，要么放弃这条路，别在正式脚本里赌。

替代方案（可用）：先用 `DboTclHelper_sMakeDboValue` 造一个 DboValue，用 `SetString/SetInt/SetBool/SetColor/...` 反推某属性"能不能按字符串读"——能读字符串就说明是 String 类，够大多数批量改属性的场景用。

实测补充：这个方法在 **`PartInst` 上直接可用**（不必转 occurrence）；属性名不存在（如 `xyzzy`）也返回 code=0，不报错——所以不能拿它探测属性是否存在。

## 2. 指针对象的生命周期

- 每种指针都有配对构造/读取/释放：`sMakeInt`/`sGetInt`/`sDeleteInt`、`sMakeBool`/`sGetBool`/`sDeleteBool`、`sMakeCPoint`/`sGetCPointX|Y`/`sDeleteCPoint`、`sMakeDboValueType`/`sDeleteDboValueType`。
- 另有 **`DboTclHelper_sReleaseAllCreatedPtrs`**：一次性释放本会话创建的所有指针，长脚本收尾时用它兜底，比逐个 delete 省事。

## 3. 创建类 API 实测

| 调用 | 结果 |
| --- | --- |
| `$wire NewJunction $point` | **成功**：返回 `DboState`，`NewJunctionsIter` 读回数量 1 |
| `$wire NewName "ZZNET" $point $font 0 48` | 返回 code=0，但**别名数为 0、wire 的 net name 未变**（仍是 `N649924`）→ "假成功"，创建 net label 不能只调这一个 |
| `$page NewOffPageConnector`（1..4 个空参） | 全部 `No matching function for overloaded` → 真重载，必须给真实类型参数（status/name/location…），靠猜不可行 |

`NewName` 的签名是 `self,name,location,font,rotation,color`——参数齐全、返回成功、却没有任何可观测副作用，这类 API 必须**回读验证**（查 `NewAliasesIter`，或查 net 名变化），不能只看返回值。

## 4. 复现这些结论的最小脚本骨架

```tcl
load $dll DboTclWriteBasic
set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set d    [$sess GetDesign [DboTclHelper_sMakeCString $dsn 0] $st]
# …取 page / part / wire…
# 1) 属性类型：sMakeDboValueType + sMakeInt ×2
# 2) 创建：先调用，再***回读***（iter 计数 / GetNetName / GetBoundingBox）
# 3) 收尾：DboTclHelper_sReleaseAllCreatedPtrs
```

原则：**任何"创建/写入"API，都以回读结果为准**。本仓库已经踩到三个"返回值说 OK 但没生效"的样本：`SaveLib`（未标记脏）、`SetUserPropStringValue`、`DboWire_NewName`。

## 5. 为什么 alias / off-page 建不出来：官方自己也不这么建

把 Cadence 自带 `tclscripts` 下所有 `.tcl` 扫了一遍，搜 `NewAlias` / `NewName` / `NewJunction` / `NewOffPageConnector` 的真实调用点：

| 搜索结果 | 说明 |
| --- | --- |
| `capChangeName.tcl` 里的 `lNewName` | 只是局部变量名，不是 API 调用 |
| `OrHandlerSymbolEditorConfig.tcl` 里的 `lNewAlias` | 同上 |
| 真正的 `$obj NewAlias/NewName/NewJunction/NewOffPageConnector` | **一个都没有** |

也就是说：**官方脚本不通过 Dbo 创建 API 造这些对象**。它们走宿主命令——在真实 Capture 里导出的命令表确认存在 `Place*` 家族 63 条（`PlaceNetAlias`/`PlaceOffPage`/`PlacePort`/`PlaceWire`/`PlacePart`…，见 [host-commands-surface.md](host-commands-surface.md)）。

> 勘误：早期版本的本文档写过"命令表里找不到 `Place*`，放置是 action 触发的"——那是基于**只含 Dbo 面**的命令导出得出的错误结论。宿主命令面（`capture.exe` 启动时注册、共约 3,700 条）必须用 `scripts/export-host-commands.tcl` 在 Capture 内导出才看得见。

因此写工具的路线应该是：

1. **能改属性/位置的，用 Dbo**（`SetEffectivePropStringValue`、`SetLocation`、`NewJunction`）；
2. **要"放置"新对象的（页间连接符、网络标签、端口），走宿主 action**（`RegisterAction` / `ExecuteAction` 那套，见 §host-api）；
3. 凡是走 Dbo 创建路径的，一律**回读验证**（iter 计数、`GetNetName`、`GetBoundingBox`），因为至少有三类 API 会"返回成功但什么都没做"。

`DboWire_NewName` 的参数形态（`self,name,location,font,rotation,color`）已经拿到，但它在 headless 会话里没有任何可观测副作用——**要么依赖宿主交互上下文，要么需要额外的 net 解析步骤**，目前没有定论，按"不可用"处理。
