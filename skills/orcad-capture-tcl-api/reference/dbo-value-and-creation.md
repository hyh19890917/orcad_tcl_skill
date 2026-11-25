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

**未解决**：`ValueType*` 这个指针怎么读回枚举值——`DboTclHelper_sGetInt` 对它返回空；又没有 `sGetDboValueType`（只有 `sMakeDboValueType` / `sDeleteDboValueType`）。要么枚举值留给宿主内部用，要么得先 `sCastPtr` 成 int 指针再 `sGetInt`（未验证，别当结论）。

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
