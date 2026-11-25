# `DboTclHelper_*` 编组层（90 个，17.4 实测）

Dbo 的 C++ 侧全部用指针/引用传值。Tcl 侧唯一合法的桥是 `DboTclHelper_*`：先造指针 → 传给方法 → 读回 → 再删。

## 1. 两条所有权路线（**最关键的规则**）

宿主对"造出来的指针"有两种记账方式：

| 路线 | 造法 | 谁来释放 | 适用 |
| --- | --- | --- | --- |
| **登记（默认）** | `sMakeCString <str>`、`sMakeInt <n>`、`sMakeCPoint x y` … | 宿主在编辑器关闭时统一释放 | 一次性的短脚本 |
| **登记 + 手动批清** | 同上 + 结尾 `sReleaseAllCreatedPtrs` | 你显式批清 | 长驻脚本 |
| **不登记（AppOwned）** | `sMakeCString <str> 0`、`sMakeCStringAppOwned`、`sMakeIntAppOwned` | **你**必须 `sDeleteCString` 等 | 插件/常驻代码（推荐） |

踩过的坑：默认登记 + 自己也 `sDeleteCString` = 宿主二次释放 = 崩溃或堆损坏。所以成熟实现的所有 `CString` 都传 `0` 并显式删除。

## 2. 分组清单

### 字符串
`sMakeCString <str> ?0?` · `sMakeCStringAppOwned` · `sMakeCStringSet` · `sSetCString` · `sGetConstCharPtr` · `sGetConstCharPtrFromVector` · `sDeleteCString` · `sDeleteCStringSet` · `sFindInCStringSet` · `sInsertToCStringSet`

### 数值
`sMakeInt` · `sMakeIntAppOwned` · `sGetInt` · `sDeleteInt` · `sMakeBool` · `sGetBool` · `sDeleteBool` · `sMakeULong` · `sGetULong` · `sDeleteULong`

### 几何
`sMakeCPoint x y` · `sGetCPointX/Y` · `sDeleteCPoint` · `sMakeCRect` · `sGetCRectTopLeft/BottomRight` · `sDeleteCRect` · `sMakeCSize` · `sGetCSizeX/Y` · `sDeleteCSize`

### 字体（LOGFONT，14 参）
`sMakeLOGFONT <face> <height> <width> <escapement> <orientation> <weight> <italic> <underline> <strikeOut> <charSet> <outPrecision> <clipPrecision> <quality> <pitchAndFamily>`
读端：`sGetLFName` `sGetLFHeight` `sGetLFWidth` `sGetLFWeight` `sGetLFItalic` `sGetLFUnderline` `sGetLFStrikeOut` `sGetLFEscapement` `sGetLFOrientation` `sGetLFCharSet` `sGetLFOutPrecision` `sGetLFClipPrecision` `sGetLFQuality` `sGetLFPitchAndFamily`
释放：`sDeleteLOGFONT`

> 16.6 会把负字号做取整缩水；用 `sGetLFHeight` 反复试探补偿（二分即可，见下）。

### 值对象
`sMakeDboValue` · `sMakeDboValueType` · `sDeleteDboValue` · `sDeleteDboValueType`
配套：`DboValue_SetColor <0..48>` + `DboValue_GetString <out>`（25.1 的 `SetColor` 返回值不可靠，用 `GetString` 当权威）

### 容器
`sMakeStdStr` `sDeleteStdStr` · `sMakeStdVector` `sPushBackToVector` `sRemoveFromVector` `sGetVectorSize` · `sMakeDboObjectVector`?（以全表为准）· `sGetStringMap` `sGetStringMapData` `sGetValueFromStringMap` `sAddToStringMap` `sDeleteStringMap`

### 会话与对象身份
`sCreateSession` · `sDeleteSession` · `sCastPtr` · `sGetDboObjectInProcess` · `sSetDboObjectInProcess` · `sSetDboSessionKey`（跨解释器/跨进程传对象）

### 进程/环境/模式（有副作用，慎用）
`sSetServerMode` · `sSetLiteMode` · `sSetEnv` `sGetEnv` · `sSetTimeZone` `sSetRegionalSetting` · `sCheckIsWritable` `sCheckNativeIsExec` · `sLockProperty` · `sEvalPage` · `sGetTclList` · `sGetBase64BitmapForOle` `sGetBase64DataOfOle`

### 一次性工具（不在上面的 s* 家族里）
`DboTclHelper_CleanOrCADRegistry` · `DboTclHelper_ReRegisterOrCADPlugins` · `DboTclHelper_DesignDiffAndDump`

## 3. 三个可直接抄的封装

```tcl
# 读字符串：一次造指针、读、删，state 也删
proc ::idz::Text {object method} {
    set ptr [DboTclHelper_sMakeCString "" 0]
    try {
        set st [$object $method $ptr]
        catch {$st -delete}
        return [DboTclHelper_sGetConstCharPtr $ptr]
    } finally { DboTclHelper_sDeleteCString $ptr }
}

# 读属性（存在性 + 值）
proc ::idz::Prop {object name {user 0}} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString "" 0]
    try {
        if {$user} { set st [$object GetUserPropStringValue $n $v] } \
        else       { set st [$object GetEffectivePropStringValue $n $v] }
        set found [$st OK]; $st -delete
        return [list $found [DboTclHelper_sGetConstCharPtr $v]]
    } finally { DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v }
}

# 16.6 字号补偿：找到一个让 sGetLFHeight 精确等于目标的请求高度
proc ::idz::ExactFont {face size weight} {
    set lo [expr {$size * 8}]; set hi [expr {$size - 1}]
    while {$lo <= $hi} {
        set mid [expr {($lo + $hi) / 2}]
        set f [DboTclHelper_sMakeLOGFONT $face $mid 0 0 0 $weight 0 0 0 0 7 0 1 16]
        set h [DboTclHelper_sGetLFHeight $f]
        if {$h == $size} { return $f }
        DboTclHelper_sDeleteLOGFONT $f
        if {$h < $size} { set lo [expr {$mid + 1}] } else { set hi [expr {$mid - 1}] }
    }
    return [DboTclHelper_sMakeLOGFONT $face $size 0 0 0 $weight 0 0 0 0 7 0 1 16]
}
```

## 4. 类型映射速查（签名里出现的 C++ 类型 → Tcl 值）

| 签名里的类型 | Tcl 侧 |
| --- | --- |
| `CString&` | `DboTclHelper_sMakeCString` 造的指针（出参） |
| `CPoint` / `CRect` / `CSize` | `sMakeCPoint` / `sMakeCRect` / `sMakeCSize` |
| `LOGFONT&` | `sMakeLOGFONT` |
| `DboValue::RotationT` / `DboValue::ColorT` | 整数（`0/1` 或 `0..48`） |
| `DboState&` | `DboState` 对象（通常作为最后一步返回，可 `-delete`） |
| `int&` / `bool&` | `sMakeInt` / `sMakeBool` |
| `std::vector<T>&` | `sMakeStdVector` + `sPushBackToVector` |
| 对象参数（`DboXxx*`） | 直接传对象名，或 `"NULL"` |

全量列表：`reference/signatures.md`（每个命令的真实参数名与类型，来自宿主自己的错误文本）。
