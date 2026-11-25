# 用 Dbo 从零建符号（官方 PSpice 符号生成器的完整序列）

生成 `.olb` 有两条完全不同的路：**写 XML 交给 XMATIC**，或者**在 Tcl 里直接建对象**。Cadence 自己的 PSpice 符号生成器（`tools\capture\tclscripts\capPSpiceModelApp\PWL\...`）走的是第二条，一个脚本里 81 处 Dbo 调用，把"建库→建封装→建器件→画线→加管脚→加属性→保存"全做完了。这条路线没有 XML schema 依赖，也没有 XMATIC 的回调/日志/重开校验那套负担。

## 1. 两条路线怎么选

| | XMATIC（XML→OLB） | 直接建对象（本文） |
| --- | --- | --- |
| 入口 | `XMATIC_XML2OLB xml olb mode log callback` | `sCreateSession` + `Lib.NewPackage/NewPart` + `SaveLib` |
| 依赖 | `olb.xsd` schema、回调文件、日志判定 | 只有 Dbo 本身 |
| 失败可见性 | 需要"六项判定"才发现丢字段 | 每步都有 `DboState`，可逐步校验 |
| 适合 | 已有成熟 XML 生成器、批量导入 | 需要精细控制（字体槽、包围盒、管脚标量、显示属性）、增量建库 |
| 版本 | 16.6 只有 2 参重载 | 16.6 起全可用 |

## 2. 官方九步序列（每一步的真实调用）

```tcl
# ② 开一个离屏会话（不需要 Capture GUI）
set sess [DboTclHelper_sCreateSession]
set st   [DboState]

# ② 打开或新建库；新建后先把默认字体槽填上
set lib [DboSession_GetLib $sess $pathCString $st]        ;# 或 CreateLib
$lib SetDefaultFont 0 [DboTclHelper_sMakeLOGFONT "Arial" 8 0 0 0 400 0 0 0 0 7 0 1 16]
# …字体槽 1..23 同理（Capture 库有 24 个默认字体槽）

# ③ 建封装（Package）
set pkg [$lib NewPackage $nameCString $st]                 ;# DboLib_NewPackage self,name,status
$pkg SetReferenceTemplate $refDesPrefixCString
$pkg SetPCBLib $pcbLibCString
$pkg SetPCBFootprint $footprintCString

# ④ 建器件单元（Part/Cell）
set part [$lib NewPart $partNameCString $st]               ;# DboLib_NewPart self,name,status
# 多单元符号另建 Cell： set cell [$lib NewCell $cellName $st]
set libPart [DboSymbolToDboLibPart $part]                  ;# 类型转换（NewPart 返回的是 Symbol）

# ⑤ 器件级开关
$libPart SetPinNumbersAreVisible 0
$libPart SetPinNamesAreRotated   1
$part SetColor 48
$part SetBoundingBox [DboTclHelper_sMakeCRect 0 0 50 $y2]  ;# 必设，否则后续布局/显示计算异常

# ⑥ 画图形：线段/圆弧/矩形/多边形（坐标单位与库一致）
#    官方封装了 makeLine / makeArc，内部仍是 Symbol 的 New* 方法

# ⑦ 加管脚（标量管脚 = 单根，非总线）
set pin [$part NewSymbolPinScalar $st $pinNameCString $pinType \
            [DboTclHelper_sMakeCPoint $x1 $y1] [DboTclHelper_sMakeCPoint $x2 $y2] 1 $pinNumber]
$pin SetIsLong $long
$pin NewUserProp $propNameCString $propValueCString $st    ;# 管脚级用户属性

# ⑧ 加显示属性（符号上看得见的那几行字）
set dp [$part NewDisplayProp $st $labelCString $locationCPoint 0 $fontCString 48]
$dp SetHorizontalTextJustification 0
$dp SetFont  $fontCString
$dp SetColor 48

# ⑨ 保存并关闭
set st2 [$sess SaveLib $lib]; # 检查 $st2
$sess RemoveLib $lib
DboTclHelper_sDeleteSession $sess
```

要点与陷阱：

1. **`NewPart` 返回的是 `Symbol`**，设置器件级开关（`SetPinNumbersAreVisible` 等）要先 `DboSymbolToDboLibPart` 转换；反过来 `DboLibObjectToDboPackage`、`DboSymbolPinToDboSymbolPinScalar`、`DboSymbolPinToDboSymbolPinBus` 也是同类转换。
2. **`NewSymbolPinScalar` 是重载方法**，官方实证参数序：`(status, nameCString, pinType, startPoint, hotPoint, <1>, pinNumber)`；`SetIsLong` 控制引脚线长风格。
3. **`SetBoundingBox` 必设**：不设也能存，但后续标注默认位置、缩放、显示范围都会异常。
4. **默认字体槽 24 个（0–23）**：新建库必须先灌默认字体，否则符号里的文字用系统默认字体，跨机器打开会变形。
5. **颜色用 `DboValue` 颜色表**（0–48），线/文字/管脚可以各自设；官方常量在 `::DboValue_*` 里。
6. **保存前不需要 `MarkModified`**（新建对象自带 dirty），但**保存后要检查 `DboState`**——官方脚本里到处 `if {[$status Failed]} exit`，因为任何一步失败都必须中止，否则会留下半个符号。
7. 建完最好**重开一次**枚举（`GetLib` → `NewPartsIter`/`NewLPinsIter`）核对管脚数与名字；这是最便宜的回归测试。

## 2.1 实测补丁：两个让"建了但读不到"的环节

官方脚本读起来是九步，实际跑通还差两处——这两条是**跑出来的**，不是读出来的：

| 症状 | 原因 | 做法 |
| --- | --- | --- |
| 建了 Package/Cell/Part，重开后 `NewPartsIter` 一个都没有 | Package 通过 **Device** 引用 Cell，没有 Device 时 Package 看不到任何 Part | `$pkg NewDevice <designator> <position> <cell> $st`（单单元用 `A`, 0） |
| `SaveLib` 返回 OK，但文件里什么都没有（重开是空库） | 新建库的对象没有被标脏，`SaveLib` 静默跳过 | 保存前先 `DboSession_MarkAllLibForSave $sess $lib`（或 `$lib MarkModified`） |

完整可跑链路（已用 `examples/build-symbol.tcl` 验证：写 4 个管脚，重开读到 4 个）：

```text
sCreateSession
→ CreateLib / GetLib
→ SetDefaultFont 0..23
→ NewPackage <pkg>
→ NewCell <cell>            ; 通常与 Package 同名
→ NewPart "<pkg>.Normal"    ; 单单元固定 .Normal
→ $cell AddPart $part
→ $part SetCellPtr $cell ; $part SetPackagePtr $pkg
→ $pkg NewDevice A 0 $cell   ; ★ 没有它，Package 里没有 Part
→ SetBoundingBox / NewSymbolPinScalar / NewDisplayProp
→ DboSession_MarkAllLibForSave ; ★ 没有它，SaveLib 静默不写
→ SaveLib → RemoveLib → 重开枚举校验
```

## 3. 最小可用骨架（自写，基于上面序列）

```tcl
# 建一个 2 管脚电阻符号到指定 OLB
proc buildResistor {olbPath libRefDes} {
    set sess [DboTclHelper_sCreateSession]
    set st [DboState]
    set p [DboTclHelper_sMakeCString $olbPath 0]
    set lib [DboSession_GetLib $sess $p $st]
    if {$lib eq "NULL"} { set lib [DboSession_CreateLib $sess $p $st] }
    if {$lib eq "NULL" || [$st Failed]} { error "打不开或建不了库：$olbPath" }

    set face [DboTclHelper_sMakeCString "Arial" 0]
    try {
        $lib SetDefaultFont 0 [DboTclHelper_sMakeLOGFONT $face 8 0 0 0 400 0 0 0 0 7 0 1 16]
    } finally { DboTclHelper_sDeleteCString $face }

    set namePtr [DboTclHelper_sMakeCString "R" 0]
    set pkg  [$lib NewPackage $namePtr $st]
    set part [$lib NewPart    $namePtr $st]
    DboTclHelper_sDeleteCString $namePtr
    if {$pkg eq "NULL" || $part eq "NULL"} { error "建封装/器件失败" }

    set prefix [DboTclHelper_sMakeCString $libRefDes 0]
    $pkg SetReferenceTemplate $prefix
    DboTclHelper_sDeleteCString $prefix

    $part SetBoundingBox [DboTclHelper_sMakeCRect -20 -60 20 60]

    foreach {num y} {1 60 2 -60} {
        set n [DboTclHelper_sMakeCString "~" 0]
        set s [DboTclHelper_sMakeCPoint 0 $y]
        set h [DboTclHelper_sMakeCPoint -20 $y]
        set pin [$part NewSymbolPinScalar $st $n 1 $s $h 1 $num]
        DboTclHelper_sDeleteCString $n
        DboTclHelper_sDeleteCPoint $s
        DboTclHelper_sDeleteCPoint $h
        if {$pin eq "NULL"} { error "建管脚 $num 失败" }
    }

    set st2 [$sess SaveLib $lib]
    if {[$st2 Failed]} { $st2 -delete; error "保存失败" }
    $st2 -delete
    DboSession_RemoveLib $sess $lib
    catch {$st -delete}
    DboTclHelper_sDeleteCString $p
    DboTclHelper_sDeleteSession $sess
    return 1
}
```

> 说明：上面 `NewSymbolPinScalar` 的 `pinType` 用整数（官方脚本里是一个整数变量），具体枚举值需在目标版本上试（`GetPinType` 可回读验证）。`SetBoundingBox` 的坐标是"符号本地坐标"，与库单位一致。

## 4. 什么时候仍要回到 XMATIC

- 已经有稳定的 XML 生成器、且要**批量**导入上千个符号：XML 路线一次调用完成，直接建对象要逐对象、逐管脚，慢一个量级。
- 需要 **OLB→XML 反向导出**做 diff：`XMATIC_OLB2XML` 是唯一现成入口。
- 只想"改"库里的既有符号：`GetUpdatedPackage` + 属性/显示属性修改即可，不必新建。

反过来，**需要精确控制字体槽、包围盒、管脚标量类型、显示属性位置**时，直接建对象明显更省事——这些在 XML schema 里要么没有对应字段，要么语义靠猜。
