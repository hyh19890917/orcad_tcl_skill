# 官方脚本里的 Dbo 用法（实测统计）与推荐范式

Cadence 自己就用这套 Tcl API 写了 564 个官方脚本（SPB 17.4 的 `tools\capture\tclscripts`，约 4.2 MB）。把它们当语料统计一遍，能回答一个很实际的问题：**哪些写法是官方惯用的、哪些只适合一次性脚本、常驻插件该怎么改。**

统计命令（可复现）：对 `*.tcl` 全文做正则计数。

## 1. 频次：官方到底怎么用这套 API

| 用法 | 出现次数 | 读法 |
| --- | --- | --- |
| `DboTclHelper_sMakeCString` | 1315 | 字符串编组是最高频操作 |
| ├ 其中带第二参 `0`（不登记所有权） | 78 | 官方**多数**依赖宿主清理，只有少数显式接管 |
| `DboTclHelper_sGetConstCharPtr` | 529 | 读回必然紧跟造指针 |
| `DboTclHelper_sDeleteCString` | 141 | 与 1315 的造指针比例 ≈ 1:9 → 官方脚本普遍不手工释放 |
| `DboState` | 441 | 状态对象用量大 |
| ├ 显式 `$st OK]` / `$st Failed]` 判定 | 15 / 19 | 绝大多数脚本**不检查**状态 |
| `catch {... -delete}` | 13 | 少数地方用 catch 兜住删除 |
| `delete_Dbo*Iter` | 176 | 迭代器释放是官方惯例 |
| `NewPartsIter` / `NextPart` | 11 / 51 | 库遍历的标准组合 |
| `NewPagesIter` / `NextPage` | 22 / 59 | 页遍历 |
| `NewViewsIter` | 20 | 视图遍历（需 `::IterDefs_*` 过滤） |
| `GetEffectivePropStringValue` | 109 | 读属性**只用 effective** |
| `SetEffectivePropStringValue` | 14 | 写属性 |
| `GetUserPropStringValue` / `DeleteUserProp` | 0 / 0 | 官方脚本几乎不碰"本地值"语义 |
| `MarkModified` | 13 | 提交修改 |
| `MarkAllLibForSave` / `SaveLib` / `SaveDesign` | 15 / 14 / 13 | 保存三件套 |
| `RemoveLib` / `CreateLib` | 23 / 5 | 临时库用完即关 |
| `GetActivePMDesign` | 78 | 取当前设计的标准入口 |
| `ui::SchematicActivate` | 11 | 刷新/激活 |
| `capGetIsSchematicEditingDisabled` | 15 | 编辑前判据 |
| `tk_messageBox` / `error` | 51 / 363 | 官方偏好直接报错 + 弹窗 |

**结论**：官方脚本是"短生命周期、跑完就退"的写法——不检查状态、不释放大部分字符串、不细分 user/effective。**常驻插件不能照抄这三条**，否则长会话必泄漏、必静默失败。

## 2. 宿主提供的全局常量（直接可用）

这些常量在 Capture 的 Tcl 解释器里预置，不需要自己定义：

| 常量 | 用途 |
| --- | --- |
| `::IterDefs_SCHEMATICS` / `_ALL` / `_INSTS` / `_PORTS` / `_NETS` / `_BUSES` / `_PACKAGES` / `_PIN_SHAPES` / `_OFFPAGES` / `_TITLEBLOCKS` / `_PRIMITIVES` | 传给 `NewViewsIter` / `NewChildrenIter` 的过滤位 |
| `::DboValue_NOROTATION` `_NINETY` `_ONEEIGHTY` `_TWOSEVENTY` | 旋转枚举（配 `SetRotation` / `NewDisplayProp`） |
| `::DboValue_POWER` `_DEFAULT_OBJECT_COLOR` `_COLOR40` | 颜色/符号类型常量 |
| `::DboValue_MEDIUM_WIDTH` `_WIDE_WIDTH` | 线宽 |
| `::DboValue_SOLID_FILL` `_HATCHED_FILL` `_HORIZONTAL_HATCH` `_DASH_DOT_DOT_LINE` | 填充/线型 |
| `::DboValue_DO_NOT_DISPLAY` | 显示类型（隐藏标注） |
| `::DboValue_SCHEMATIC_VIEW_TYPE` | 视图类型 |

用法：`$obj SetRotation $::DboValue_NINETY`；`$design NewViewsIter $st $::IterDefs_SCHEMATICS`。**别硬编码 0/1/90/270 这种魔法数**（值可能随版本变），也不要自己 `set` 同名全局。

## 3. 官方封装层：先看有没有现成的

### 3.1 `package require capDB`（`tclscripts\capDB\`）

| 文件 | 提供 |
| --- | --- |
| `capDboGeom.tcl` | `list2CPoint` / `list2CRect` / `cRect2List` / `rotation2DboRotation`（90/180/270 → `::DboValue_*`） |
| `capLibPropUtil.tcl` | `add_prop_lib` / `del_prop_lib` / `addp_iter` / `delp_iter` / `make_display_prop` / `mkdisp_iter` / `get_default_disp_prop_location` |
| `capRev.tcl` / `capShortNet.tcl` / `capExportDesignCache.tcl` | 版本串、短网名、缓存导出 |
| `olb.xsd` / `dsn.xsd` | `XMATIC_OLB2XML` / `XMATIC_DSN2XML` 的 schema |

### 3.2 `package require orPrmDboUtils`（`share\orTclscripts`）

`initSession` / `SetSessionId` / `getDefaultLib` / `isLib` / `isDBObject` / `isDBType` / `getLibObject` / `getDesign` / `getPackage` / `getSchematic` / `getPage` / `openPage` / `openPackage` / `GetAllPackageNames` / `GetPackageXML`。
需要"给一个名字就拿到对象"时优先用它，别自己写一遍 `GetLib`+`NewPartsIter` 的样板。

## 4. 七组对照：官方写法 → 常驻插件该怎么写

| 主题 | 官方样本 | 常驻插件推荐 |
| --- | --- | --- |
| 会话 | 53 处 `$::DboSession_s_pDboSession` + `DboSession -this $s`；21 处 `DboTclHelper_sCreateSession`（批处理） | 进程内继承宿主会话；批处理自建会话并在 `finally` 里 `sDeleteSession` |
| 字符串 | 造 1315 / 删 141 | **一律** `sMakeCString <s> 0` 或 `sMakeCStringAppOwned`，自己在 `finally` 删 |
| 状态 | 441 个状态对象，34 处判定 | 每次写都 `if {![$st OK]} {...}`，读用回读校验；`$st -delete` 一个不漏 |
| 遍历 | `New*Iter` + `Next*` + `delete_Dbo*Iter` | 同上，另加 `catch {$it -delete}` 兜底（个别版本只认其一） |
| 属性 | 只用 effective | 私有状态用 user prop，但必须能以 `DeleteUserProp` 精确撤除 |
| 保存 | `MarkAllLibForSave` + `Save*` | 保存前全量回读，失败逆序恢复，并明确告知"请勿保存" |
| 错误 | `error` + `tk_messageBox` | 日志留 `$::errorInfo`，UI 只给可执行的一句话 + 错误码 |

## 5. 官方标注位置算法（值得照抄）

官方 `capLibPropUtil::get_default_disp_prop_location` 的做法可以概括成三步：取器件包围盒右下角为起点 → 遍历已有标注，把 Y 抬到已有标注的最大值 → 再 `+10`（数据库单位）。

```tcl
proc newLabelPoint {obj} {
    set st [DboState]
    set box [$obj GetBoundingBox]
    set br  [DboTclHelper_sGetCRectBottomRight $box]
    set x   [DboTclHelper_sGetCPointX $br]
    set y   [DboTclHelper_sGetCPointY $br]
    DboTclHelper_sDeleteCPoint $br
    DboTclHelper_sDeleteCRect $box
    set it [$obj NewDisplayPropsIter $st]
    try {
        for {set d [$it NextProp $st]} {$d ne "NULL"} {set d [$it NextProp $st]} {
            set p [$d GetLocation $st]
            set py [DboTclHelper_sGetCPointY $p]
            if {$py > $y} { set y $py }
            DboTclHelper_sDeleteCPoint $p
        }
    } finally { delete_DboDisplayPropsIter $it; catch {$it -delete}; $st -delete }
    return [DboTclHelper_sMakeCPoint $x [expr {$y + 10}]]
}
```

## 6. 推荐范式（自写，可直接改用）

```tcl
# 读属性：{exists value}
proc propGet {obj name} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString "" 0]
    set code [catch {
        set st [$obj GetEffectivePropStringValue $n $v]
        set ok [$st OK]; $st -delete
        list $ok [DboTclHelper_sGetConstCharPtr $v]
    } r]
    DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v
    if {$code} { return -code $code -errorinfo $::errorInfo -errorcode $::errorCode $r }
    return $r
}

# 写属性：写后回读，不一致立即报错（调用方负责回滚）
proc propSetVerified {obj name value} {
    set n [DboTclHelper_sMakeCString $name 0]
    set v [DboTclHelper_sMakeCString $value 0]
    try {
        set st [$obj SetEffectivePropStringValue $n $v]
        if {![$st OK]} { $st -delete; error "宿主拒绝写入 $name" }
        $st -delete
        set st [$obj MarkModified]; if {![$st OK]} { $st -delete; error "MarkModified 失败" }; $st -delete
    } finally { DboTclHelper_sDeleteCString $n; DboTclHelper_sDeleteCString $v }
    if {[lindex [propGet $obj $name] 1] ne $value} { error "回读不一致：$name" }
}
```

## 7. 反模式清单（每条都能踩出问题）

1. 照抄官方"不检查状态"的写法进常驻插件 → 静默失败、数据没落地还显示成功。
2. `sMakeCString` 不传 `0` 又自己 `sDeleteCString` → 宿主二次释放，退出时崩。
3. 迭代器用错 `delete_Dbo*Iter`（不同对象不通用）→ 泄漏或崩溃。
4. 用 `tcl_platform(wordSize)` 判断 DLL 位数（Windows 上恒为 4）→ 永远先试错的那个。
5. 在 `capAutoLoad` 阶段做网络/文件重活 → 宿主还没进事件循环。
6. 退出路径调用会 `vwait` 的 API（`http::geturl`）→ 重入宿主拆除流程。
7. 直接改页级图形去改"某分支的显示" → 污染共享页的兄弟分支。
8. 把私有状态塞进普通业务属性名 → 与用户字段冲突；应留前缀并做保留名校验。
9. 保存前不回读 → 某些写入被 DB 层静默丢弃。
10. 菜单标题用非 ASCII → 宿主按 ANSI 转换，出现乱码。

## 8. 版本与能力检测

- 能力检测优先于版本判断：`if {[llength [info commands <cmd>]]}`、`if {[info exists ::orPrm::WF_CEF]}`、`[package vcompare [info patchlevel] 8.5]`。
- 已知的版本差异：`PlaceNew`（16.6/17.2）vs `PlacePartEx`（17.4 六参 / ≥22.1 七参）；`XMATIC_XML2OLB` 2 参（16.6）vs 5 参；`IsSchematicViewActive`（16.6）vs `capGetIsSchematicEditingDisabled`；`binary encode base64`（8.6）vs `base64::encode`（8.4）。
- 8.4 入口脚本里不要出现 `dict` / `try` / `lassign` / `lreverse`。

## 9. 发布前自检

```powershell
# 语法关：8.4 与 8.6 各过一遍
Set-Content _check.tcl -Encoding ascii -Value @'
if {[catch {source D:/work/your.tcl} e]} { puts "FAIL: $e"; puts $::errorInfo } else { puts OK }
exit 0
'@
& 'D:\Cadence\Cadence\SPB_16.6\tools\tcl84\bin\tclsh84.exe' _check.tcl
& 'D:\Cadence\Cadence\SPB_17.4\tools\bin\tclsh.exe' _check.tcl
```

清单：状态全判、指针全删、迭代器全放、写后回读、错误带 `$::errorInfo`、宿主能力检测、无魔法常量、无第三方产品名。
