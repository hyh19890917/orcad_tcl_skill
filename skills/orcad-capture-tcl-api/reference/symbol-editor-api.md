# 符号编辑器 API：`OrSymbolEditor_*` + `::OrEntrySymbolEditorConfig::`

做"符号库工具"最容易忽略的一条路：**封装/符号可以按 XML 往返**——读出来、改、写回去，不用碰 Dbo 的对象模型。这套能力在符号编辑器面板里。

## 1. 两层结构

| 层 | 数量 | 作用 |
| --- | --- | --- |
| `OrSymbolEditor_*`（薄壳 proc） | 22 | 注册事件、把调用转发给面板方法，全部带 `"hostedClientId"` |
| `::OrEntrySymbolEditorConfig::*`（面板方法） | **59** | 真正干活：XML 往返、图形放置、命令通道、库包管理 |

薄壳的固定形态（`capSymbolEditorConfigInit.tcl`）：

```tcl
proc OrSymbolEditor_DoEditPart { args } {
    if { [catch {package require orPrmDesigner}] } { } else {
        set lDesignName  [lindex $args 0]
        set lPackageName [lindex $args 1]
        set lSchematicDoc[lindex $args 2]
        ::OrEntrySymbolEditorConfig::DoEditPart $lDesignName $lPackageName $lSchematicDoc "hostedClientId"
    }
}
```

启动入口参数最多：`capLaunchWidget pLibrary pPackage pMode pType pDMDoc pStrClientId` → 内部 `initialize` 同签名。

## 2. 59 个面板方法（按功能分组）

### 2.1 XML 往返（做库工具的关键）

| 方法 | 参数 | 用途 |
| --- | --- | --- |
| `GetPackageXmL` | `pLibraryPath pPackageName pEncodeBase64 pStrClientId` | **把一个封装读成 XML** |
| `GetSymbolXmL` | `pLibraryPath pSymbolName pEncodeBase64 pStrClientId` | 读单个符号 |
| `GetSymbolArXmL` | `pLibraryPath pStrSymbolNameArJson pEncodeBase64 pStrClientId` | 批量（符号名 JSON 数组） |
| `savePackageData` | `pLibrary pPackageName pPackageXml pStrClientId` | **把 XML 写回封装** |
| `saveAsPackageData` | 同上 | 另存 |
| `updatePartInMemory` | 同上 | 只更新内存 |
| `viewPackageData` | 同上 | 预览 |
| `writePartXMLToFile` | `p_strFilePath p_strPartXml pStrClientId` | 落盘成文件 |
| `writePropertyDataToFile` | `p_strFilePath p_strJson pStrClientId` | 属性 JSON 落盘 |
| `getImageBase64Data` | `pStrClientId` | 取当前视图图片（base64） |

**这就是"读 → 改 → 写回"的完整闭环**，配合上面的 `GetPackageXmL`/`savePackageData` 即可批量改封装，不必理解 Dbo 的 `NewDisplayProp` 那些参数。

### 2.2 图形放置（面板侧的 12 个 `OnClickPlace*`）

`OnClickPlaceArc` `BezierCurve` `Ellipse` `EllipticalArc` `IEEESymbol` `Line` `Picture` `Pin` `PinArray` `Polyline` `Rectangle` `Text`

全部只收 `pStrClientId`——它们是"让面板进入某绘制模式"，具体坐标由后续命令给出。

### 2.3 命令通道

| 方法 | 参数 | 说明 |
| --- | --- | --- |
| `RunCommand` | `pCommand pStrClientId` | 执行一条面板命令（JSON 串） |
| `OnAppCommand` | `pCmd pStrClientId` | 接受应用消息（由 `_cdnOnHandleAppMsg` 事件转进来） |
| `requestAppToExecuteCmd` | `pCmd pStrClientId` | 反向请求宿主执行 |
| `setNotifyCommands` | `pJson p_currentCmd pStrClientId` | 设置通知命令表 |
| `completeSyncCommand` | `pStrClientId` | 完成同步命令 |
| `LogCommand` | `pCommand pStrClientId` | 记录命令（`capLogTclCommand` 同源） |

### 2.4 库 / 封装管理

`DoEditPart pDesignPath pPackageName pSchematicDoc` · `DoCloseEditPart pTabDoc` · `GetPartName pTabDoc` · `capIsPackageOpened pLibName pPkgName` · `capCloseEditorIfOpened` · `SetPackageModified pLibPath pPackage` · `AssociatePspiceModel pLibPath pPackage` · `GetLibAlias pLibName` · `replacePackageAlias pLibrary pPackageName pAliasjson` · `GetCapsymPinShapeSymbolsNameWithLibPath pLibName` · `ActivateTab pLibName pPackageName` · `HandleCloseTabs pMode`

### 2.5 配置 / 日志 / 调试

`GetConfigJson` · `GetFontJson` · `GetPrefJson` · `capOnPreferenceSetting` · `WriteToSessionLog pMessage` · `capDialogHelp pHelpId` · `capEnableDebug` · `browseImplementationPath p_strPath`

## 3. 命令协议：用 `orjson_*` 拼 JSON

`OrSymbolEditor::execute` 是一份完整的样本（原文精简）：

```tcl
proc OrSymbolEditor::execute { args } {
    set rootNode       [orjson_new "\5"]        ;# 对象
    set lPartPropArray [orjson_new "\4"]        ;# 数组
    orjson_set_name $lPartPropArray "Cmd"       ;# 数组挂在 key "Cmd" 下
    foreach lval $args {
        if { [OrSymbolEditor::isnumeric $lval] } {
            set prop [orjson_new_f "" [expr $lval]]     ;# 浮点
        } elseif { [OrSymbolEditor::isboolean $lval] == 1 } {
            set prop [orjson_new_b "" 1]                 ;# 布尔
        } elseif { [OrSymbolEditor::isboolean $lval] == 0 } {
            set prop [orjson_new_b "" 0]
        } else {
            set prop [orjson_new_a "" $lval]             ;# 字符串
        }
        orjson_push_back $lPartPropArray $prop
    }
    orjson_push_back $rootNode $lPartPropArray
    set text [orjson_write $rootNode]
    orjson_delete $rootNode
    ::OrEntrySymbolEditorConfig::RunCommand $text "hostedClientId"
}
```

**顺带证实了 `orjson` 那一页里我标"推断"的类型标记**：`orjson_new "\5"` = 对象、`"\4"` = 数组——这里是官方原样用法，不再是推断。另外注意**类型必须显式**：数字用 `new_f`、布尔用 `new_b`、字符串用 `new_a`，全走 `new_a` 会让面板把 `"1"` 当字符串收。

## 4. 两条路线怎么选

| 需求 | 走 Dbo（`build-symbol.tcl` 那种） | 走符号编辑器 XML |
| --- | --- | --- |
| 从零批量生成大量符号 | ✅ 无需面板、可 headless | ❌ 需要 GUI 会话 |
| 改**已有**封装的图形/管脚 | 要逐个 `NewDisplayProp`/`SetLocation` | ✅ `GetPackageXmL` → 改 XML → `savePackageData` |
| 精确控制 XML 结构（导出给别的系统） | 不支持 | ✅ 原生就是 XML |
| 面屏交互（用户点选） | 不支持 | ✅ `OnClickPlace*` |

实践建议：**批量新建用 Dbo，批量改旧用 XML 往返**。

## 5. 坑

1. **每个方法最后一个参数都是 `"hostedClientId"`**，漏了就调不到；
2. `GetPackageXmL` 的 `pEncodeBase64` 传 1 会得到 base64，传 0 得原始 XML——大封装建议 base64，避免 Tcl 字符串里的换行/引号问题；
3. 面板方法**只在 GUI 会话存在**（`package require OrEntrySymbolEditorConfig` 需要宿主），headless 里没有；
4. `OrSymbolEditor_RegisterAction` 注册的是 `_cdnOnHandleAppMsg`——**应用消息事件**（见 [host-event-hooks.md](host-event-hooks.md)），想收宿主动作回执就从这里进。
