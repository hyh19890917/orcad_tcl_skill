# 宿主 action / 菜单：`RegisterAction` + `InsertXMLMenu` 的真实契约

要给 Capture 加菜单项、工具条按钮、右键项，绕不开这两个命令。下面是从 Cadence 自带脚本里读出来的**实际调用形态**，以及一条重要的可用性边界。

## 1. `RegisterAction` 是 5 个参数

两个独立来源（`capArrowCloudConnector/tcl/OrCloudArrowMenu.tcl`、`capAutoLoad/auto_test.tcl`）都是同一形态：

```tcl
RegisterAction <actionName> <enablerProc> <accel> <handlerProc> <helpText>
```

实例：

```tcl
RegisterAction "orCloudArrowWorkspaceMenuAction"  \
               "::OrCloudArrowMenu::CloudArrowMenuActionCapTrue" "" \
               "::OrCloudArrowMenu::CloudArrowMenuActionHandler" ""
```

- `actionName`  → 菜单项里引用的 ID（字符串，需全局唯一）；
- `enablerProc` → 返回真/假决定该菜单项**是否可点**（不是是否显示）；
- `accel`       → 快捷键字符串，没用就给 `""`；
- `handlerProc` → 真正干活的 proc；
- `helpText`    → 状态栏提示，可 `""`。

**handler 与 enabler 的签名都是 `{args}`**，返回 `true`：

```tcl
proc ::MyPlugin::ActionCapTrue { args } { return true }
proc ::MyPlugin::ActionHandler { args } {
    # 干活
    return true
}
```

**重复注册要吞异常**——官方自己就是这么写的：

```tcl
if {![catch {RegisterAction "_cdnCapTclAddDesignCustomMenu" "::schtool::autotest::capTrue" "" \
                             "::schtool::autotest::onDesignMenu" ""}]} { }
```

## 2. `InsertXMLMenu` 收一个嵌套 list

```tcl
InsertXMLMenu [list \
    [list $topMenuName $subMenuName] "" "" \
    [list "action" $labelText "0" $actionName $enablerName "" ""] ""]
RefreshMenu
```

结构拆开看：

| 位置 | 内容 | 说明 |
| --- | --- | --- |
| 第 1 项 | `[list <顶级菜单> <子菜单>]` | 插入到哪个菜单下，如 `File` + `FileOpen` |
| 第 4 项 | `[list "action" <标签> "0" <actionName> <enablerName> "" ""]` | 菜单项节点；`"action"` 是节点类型关键字，`"0"` 位置参数 |
| 末尾 | `""` | 占位 |

标签里可以用 `&` 指定助记键（官方用 `De&mo Designs` 这种写法）。插入/删除后必须 **`RefreshMenu`**，否则菜单栏不刷新。

## 3. 硬边界：这些命令只在 Capture 里存在

headless（`tclsh` + `orDb_Dll_Tcl64.dll`）实测：

```text
RegisterAction: exists=0
InsertXMLMenu:  exists=0
RefreshMenu:    exists=0
ExecuteAction:  exists=0
```

**结论**：宿主 action/菜单 API 无法在 headless 里注册或回归测试；它们由 `capture.exe` 的 Tcl 应用在启动时才注册。写插件时必须自检：

```tcl
if {[llength [info commands RegisterAction]] == 0} {
    # headless / 非 Capture 环境：跳过 UI 注册，只保留纯 Dbo 逻辑
    return
}
```

这条也解释了为什么"把逻辑写成两层"是必要的：**能 headless 跑的部分放前面（可测），需要宿主的部分包一层**。

## 4. 现成的 enabler 可以复用

官方脚本里有一批 enabler proc，可以直接拿来做"菜单项何时可点"：

| enabler | 用途 |
| --- | --- |
| `capTrue` | 永远可点（最常用） |
| `capPSpAppTrue` | PSpice 相关上下文 |
| `capDemoBrwrAppTrue` | 示例浏览器上下文 |
| `capAutoDRCConfig_EnableDRCConfig` | DRC 配置页上下文 |
| `capAutoDesignView_EnableDesignViewActions` | Design View 上下文 |

要"只在有选中对象时可点"，自己写一个 enabler 即可（`GetSelectedObjects` 判断非空 → 返回 1/0）。

## 5. 拿不到 action 的"程序化调用"入口

`ExecuteAction` 在 headless 不存在，官方脚本也没有用它调用自己注册的 action——它们都是**通过菜单点击触发**。若确实需要在脚本里触发同一段逻辑，正确做法是把逻辑抽成普通 proc，菜单 handler 只是薄壳：

```tcl
proc ::MyPlugin::DoWork { args } { ... }          ;# 可被任何地方调用
proc ::MyPlugin::MenuHandler { args } { ::MyPlugin::DoWork; return true }
```

这样 headless 测试调 `DoWork`，GUI 里点菜单也走 `DoWork`——同一份逻辑，两种入口。
