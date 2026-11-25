# 插件生命周期：从 `capAutoLoad` 到面板启动

写一个"装上就能用"的 Capture 插件，要过的三关是：**自动加载 → 注册菜单/动作 → 启动面板**。这三关的官方做法在 `tools\capture\tclscripts\capAutoLoad\` 里能看到全部样本。

## 1. 自动加载：目录即入口

`<install>\tools\capture\tclscripts\capAutoLoad\*.tcl` —— 启动时被逐个执行。实测该目录下同时存在两类文件：

| 类型 | 例子 | 大小 | 特征 |
| --- | --- | --- | --- |
| 注册壳 | `capAdvancedAnnotationInit.tcl` | 188 B | **只定义 proc，不做事** |
| 注册壳 | `capAutoAddOnModels.tcl` | 198 B | 同上 |
| 功能体 | `auto_test.tcl` | 41 KB | 自带 `RegisterAction` 调用 |
| 功能体 | `capAssociatePSpiceModel.tcl` | 26 KB | 完整业务逻辑 |

命名约定：`<Feature>Init.tcl` 是"壳"，`<Feature>.tcl` 是"体"。壳文件全文就一个 proc：

```tcl
proc capAdvancedAnnotation_capLaunchWidget { args } {
    if { [catch {package require orPrmDesigner}] } {
        # 没有面板框架就什么都不做（静默降级）
    } else {
        ::OrEntryAdvancedAnnotation::capLaunchWidget "hostedClientId"
    }
}
```

## 2. 约定式 proc 名

autoload 里的 proc 遵循可被宿主/启动器识别的命名：

| proc 形态 | 作用 |
| --- | --- |
| `<feature>_capLaunchWidget {args}` | 启动该功能的 UI（面板/对话框） |
| `<feature>_shouldProcess {args}` | 返回 true/false，决定是否可用 |
| `<feature>_EnableXxxActions` / `_HideXxxActions` | 动态开关菜单项 |
| `<feature>_CompareDesigns {}` 之类 | 具体业务入口 |

注意：**这些文件大多不自我注册**（不调 `RegisterAction`）；注册集中在少数"菜单总装"文件里（例：`capAppLaunchMenu.tcl` 里 `RegisterAction "_cdnCapTclAddPageCustomMenu" "capTrue" "" "capAddAppLauncher" ""`）。也就是说官方把"注册"与"实现"分开，便于统一管理菜单结构。

## 3. 面板启动：`package require orPrmDesigner`

官方面板（hosted widget）的启动三步，在多个 autoload 文件里重复出现：

```tcl
if { [catch {package require orPrmDesigner}] } {
    # 面板框架不可用：静默跳过（headless / 精简安装）
} else {
    ::OrEntry<Feature>::InitDefaultDsnData "hostedClientId"   ;# 可选：预置数据
    ::OrEntry<Feature>::capLaunchWidget "hostedClientId"      ;# 拉起面板
}
```

`"hostedClientId"` 是宿主侧的面板容器标识（固定字符串，不是变量）。这套机制与"网页面板 + `executeTcl` 桥"是同一条链：**面板是宿主里的浏览器控件，Tcl 侧通过 `package require orPrmDesigner` 拿到控制入口**。

## 4. 三条硬边界（实测）

1. **宿主命令在 headless 不存在**：`tclsh` + Dbo DLL 里 `RegisterAction` / `InsertXMLMenu` / `RefreshMenu` / `ExecuteAction` 全部 `info commands` 为空 → UI 部分必须自检降级（`if {[llength [info commands RegisterAction]] == 0} { return }`）。
2. **面板框架缺失要能静默跳过**：官方写法就是 `catch {package require orPrmDesigner}`，失败就什么都不做——插件在无面板环境（批处理、服务器）里仍可加载。
3. **命令表存在结构性盲区**：我们导出的 6109 条命令全部来自 Dbo DLL（前缀分布：`DboLib` 326、`DboPage` 266、`delete_*` 224、`new_*` 181…），**宿主命令（`RegisterAction`、`GetSelectedObjects`、`GetActivePMDesign`、`capTrue` 等）一条都不在里面**——因为它们是 `capture.exe` 启动时注册的，headless 枚举不到。

## 5. 写插件的推荐骨架

```tcl
# 1) 纯逻辑层：不碰宿主命令，headless 可测
proc ::MyPlugin::DoWork { args } { ... }

# 2) 自检：有宿主才注册 UI
if {[llength [info commands RegisterAction]]} {
    proc ::MyPlugin::CapTrue { args } { return true }
    proc ::MyPlugin::Handler { args } { ::MyPlugin::DoWork; return true }
    catch {RegisterAction "myPluginAction" "::MyPlugin::CapTrue" "" "::MyPlugin::Handler" ""}
    catch {InsertXMLMenu [list [list "Tools" "MyPlugin"] "" "" \
        [list "action" "Run My Plugin" "0" "myPluginAction" "myPluginAction" "" ""] ""]}
    catch {RefreshMenu}
}

# 3) 面板（可选）：框架在就拉起，不在就跳过
proc ::MyPlugin::Launch { args } {
    if {[catch {package require orPrmDesigner}]} { return }
    catch {::OrEntryMyPlugin::capLaunchWidget "hostedClientId"}
}
```

要点：**逻辑与 UI 分离、注册用 catch 包住、面板缺失静默跳过**。这三点官方脚本全都在做，照抄即可。
