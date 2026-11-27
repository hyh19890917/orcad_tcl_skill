# 事件钩子：`RegisterAction` 的保留名目录（约 100 个）

之前我在插件生命周期那篇里写过"没找到通用事件注册 API"——**那是错的**。事件系统的入口就是 `RegisterAction`，只是动作名是**保留名**：Capture 在对应时机去触发它们。官方 `capDRCImpl.tcl` 就是这么挂上去的。

## 1. 机制

```tcl
RegisterAction "_cdnOrOnDesignPostSave" "::orCAPDRC_IMPL::capTrue" "" \
               "::orCAPDRC_IMPL::OnEventNotifyDesignSaved" ""
```

- 第 1 参是**保留动作名**（下表），由宿主在事件发生时调用；
- 第 2 参 enabler 一般直接给 `capTrue`（事件不涉及可用性）；
- 第 4 参是你的 handler，**签名通常是 `args` 或具体对象**（如 `pDesign`）。

注册通常集中在插件自己的 `registerEvents` proc 里，在 autoload 时调一次：

```tcl
proc ::myplug::registerEvents {} {
    RegisterAction "_cdnOrOnInitComplete"  "::myplug::capTrue" "" "::myplug::OnInit"   ""
    RegisterAction "_cdnOrOnDesignPostSave" "::myplug::capTrue" "" "::myplug::OnSaved"  ""
}
::myplug::registerEvents
```

## 2. 事件目录（官方脚本里出现过的保留名）

### 2.1 设计 / 应用生命周期

| 保留名 | 时机 |
| --- | --- |
| `_cdnOrOnInitComplete` | Capture 初始化完成 |
| `_cdnOrNotifyDesignOpened` | 设计打开后 |
| `_cdnOrOnDesignPostSave` | 设计保存后 |
| `_cdnOrNotifyDesignPostSaveAs` | 另存为后（参数：旧名、新名） |
| `_cdnOrNotifyDesignPreClose` | 设计关闭前 |
| `_cdnOrOnPreExit` / `_cdnOrAtCaptureExit` | 退出前 / 退出时 |
| `_cdnOrOnIdle` | 空闲 |

### 2.2 页与连接性

`_cdnOrOnNewSchematicPage` · `_cdnOrOnNewSchematicPagePreCreate` · `_cdnOrOnSchematicPageAttributeChange` · `_cdnOrOnPreDesignConnectivityChange` · `_cdnOrOnPostDesignConnectivityChange` · `_cdnOrOnPreNetrevRun` · `_cdnOrOnPostNetrevRun` · `_cdnOrOnPrePstswpRun` · `_cdnOrOnPostPstswpRun`

### 2.3 选择与操作

`_cdnOrNotifyObjectSelect` · `_cdnOrNotifyObjectDeSelect` · `_cdnOrNotifyOperationStart` · `_cdnOrNotifyOperationEnd` · `_cdnOrNotifyCMUIOperationCompleted` · `_cdnOrNotifyCMOccHierUpdate`

### 2.4 菜单挂载（上下文菜单）

`_cdnCapTclAddDesignCustomMenu` · `_cdnCapTclAddPageCustomMenu` —— 往设计树/页的右键菜单里加项。

### 2.5 工具入口：`_cdnCapAction<Feature>` + `_cdnCapUpdate<Feature>` 成对出现

```text
_cdnCapActionPDFExport      / _cdnCapUpdatePDFExport
_cdnCapActionDesignView     / _cdnCapUpdateDesignView
_cdnCapActionDesignDiff     / _cdnCapUpdateDesignDiff
_cdnCapActionUnifiedSearch  / _cdnCapUpdateUnifiedSearch
_cdnCapActionSymbolExtractor/ _cdnCapUpdateSymbolExtractor
_cdnCapActionISCFExport     / _cdnCapUpdateISCFExport
_cdnCapActionHTML/XML 导入导出系列…
```

规律：`Action` 是点击后执行，`Update` 是刷新可用状态（enabler）。

### 2.6 PDF 的两个钩子（解释了之前"0 字节 PS"的谜）

```text
_cdnOrPdfPrintAnnotatePageObjects     ;# 打印时逐页回调 Tcl 去打标注
_cdnOrPdfPrintFromPS                  ;# PostScript 完成后回调 Tcl 去调转换器
```

也就是说：**`CapPdfPrint` 不是"全在 C++ 里做完"，它在两个阶段回调 Tcl** —— 注解阶段和 PS→PDF 阶段。`capPdfUtil::printPdfFromPS` 正是被 `_cdnOrPdfPrintFromPS` 调起来的（那里 `eval exec $mPSToPDFConverterCommand`）。这补上了之前调查里"为什么裸调 `CapPdfPrint` 没反应"的另一半解释：回调没挂上，链路就断在第一段。

### 2.7 其它值得记的

`_cdnCapCustomDRCElectricalAddItem`（自定义 DRC 电气项，6 处注册）· `_cdnCapCustomDRCPhysicalAddItem`（2 处）· `_cdnRegisterFindExntension`（**官方拼写错误**，Extension 拼成 Exntension，照抄别改）· `_cdnOrTclRemoteRequestHandler`（远程请求）· `_cdnOrWinHelp` · `_cdnPatternMatch`

## 3. 官方实例：DRC 框架怎么挂事件

`capOnlineDRC/tcl/capDRCImpl.tcl` 的 `registerEvents` 结构：

```tcl
RegisterAction "_cdnOrOnDesignPostSave"        capTrue "" ::orCAPDRC_IMPL::OnEventNotifyDesignSaved    ""
RegisterAction "_cdnOrNotifyDesignPostSaveAs"  capTrue "" ::orCAPDRC_IMPL::OnEventNotifyDesignPostSaveAs ""
RegisterAction "_cdnOrNotifyDesignPreClose"    capTrue "" ::orCAPDRC_IMPL::OnEventNotifyDesignClosed   ""
# …应用事件同理
```

而 `OnEventNotifyDesignOpened` 里有一处关键编排：

```tcl
COrDRCTclInterface_OnDesignOpened $pDesignName
if {[capIsOnlineDrcEnabled] == 1} {
    COrDRCTclInterface_SubscribeForDBChange $pDesignName   ;# 订阅数据库变更
}
```

**`SubscribeForDBChange` 才是"设计变更"的真正订阅点**，且要先判断在线 DRC 是否开启——这类前置条件在别处文档里是没有的。

## 4. 与之配套的 `COrDRCTclInterface_*`（DRC 侧接口）

| 命令 | 参数 | 用途 |
| --- | --- | --- |
| `COrDRCTclInterface_OnDesignOpened` | 设计名 | 通知 DRC 设计已开 |
| `OnDesignSaved` / `OnDesignSaveAs` | 设计名 / 旧名+新名 | 保存事件 |
| `OnDesignClosed` | 设计名 | 关闭事件 |
| `OnSchematicRename` / `OnSchematicPageRename` | 设计名 + 新名 | 改名事件 |
| `OnMakeRoot` | 设计名 | 设为根 |
| `SubscribeForDBChange` | 设计名 | **订阅数据库变更** |
| `GetPhysicalDRCCount` | 设计名, `$::COrDRCTclInterface_DRC_ERROR` | 取物理 DRC 错误数 |

常量目前只见 `::COrDRCTclInterface_DRC_ERROR` 一个（其它类别应在同样的命名空间下，未逐个验证）。

## 5. 使用建议

1. 事件 handler **不要做重活**：`_cdnOrOnIdle`、`_cdnOrNotifyOperationEnd` 这类会频繁触发；把重活排到队列或只在状态变化时做。
2. `RegisterAction` 重复注册会报错——用 `catch` 包住（官方也是这么写的）。
3. 所有事件名都是**保留名**，不要自创；自创的只是你自己的菜单动作（如 `myPluginAction`）。
4. 事件能否触发取决于插件是否在**该会话**里注册过——headless 里 `RegisterAction` 不存在，所以事件系统天然只活在 GUI 会话。
