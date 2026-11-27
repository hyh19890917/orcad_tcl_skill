# 文档索引（按主题分组 · 带依据等级）

32 篇 reference 分五组。**依据等级**说明每篇的可靠性来源：

| 等级 | 含义 |
| --- | --- |
| **实测** | 在本机 Cadence 17.4/16.6 上跑过命令或导出过数据 |
| **原文** | 直接引用 Cadence 自带 `.tcl` 源码的调用点 |
| **推断** | 由调用点/报错反推，未单独验证 |
| **查阅** | 大表，用来查不要通读 |

## A. Dbo 面（对象模型与 API）

| 文档 | 内容 | 等级 |
| --- | --- | --- |
| [signatures.md](signatures.md) | **主查表**：3,941 条命令的参数名 + C++ 类型（17.4），按类分组 | 实测·查阅 |
| [dbo-classes.md](dbo-classes.md) | 291 个类的成员总表 | 实测·查阅 |
| [iterators.md](iterators.md) | 127 个迭代器 → `Next*` → `delete_*` 对应关系 | 实测 |
| [marshalling.md](marshalling.md) | 90 个 `DboTclHelper_*`：指针生命周期、所有权规则 | 实测 |
| [constants.md](constants.md) · [constants-17.4.txt](constants-17.4.txt) | 437 个宿主常量（对象类型/值枚举/迭代位） | 实测 |
| [dbo-advanced.md](dbo-advanced.md) | 事务、BOM JSON（实测 5,169B/403B 两种输出）、位号、路径 | 实测 |
| [dbo-value-and-creation.md](dbo-value-and-creation.md) | `DboValue::ValueType&`/`int&` 出参的正确指针；`NewJunction` 可用、`NewName` 假成功 | 实测 |
| [official-patterns.md](official-patterns.md) | 官方 564 个 tcl 的用法统计与推荐范式 | 实测+原文 |
| [official-symbol-builder.md](official-symbol-builder.md) | 官方符号生成器十步序列 + 两个必踩坑（NewDevice / MarkAllLibForSave） | 实测 |
| [official-workflows.md](official-workflows.md) | 应用级 `C*` 类、StringMap、CIS 分组 | 原文 |
| [official-ui-layout-export.md](official-ui-layout-export.md) | 偏好表单、对齐/分布选项模型、PDF 标注管线、对象流分层 | 原文 |

## B. 宿主面（Capture 进程内的命令与面板）

| 文档 | 内容 | 等级 |
| --- | --- | --- |
| [host-commands-surface.md](host-commands-surface.md) | **盘点**：Capture 内 9,830 vs headless 6,112；`Place*` 63 条全清单；关键命令核对 | 实测 |
| [host-place-api.md](host-place-api.md) | `Place*` 完整签名（`PlaceWire`/`PlaceNetAlias`/`PlaceOffPage`/`PlacePart` 索引状态机） | 实测 |
| [host-pdf-api.md](host-pdf-api.md) | `CapPdf*` 六签名、纸张索引 0..69、编排层 `printPdf`→PS→GS 全链路、真机 0 字节 PS 记录 | 实测+原文 |
| [host-event-hooks.md](host-event-hooks.md) | **事件钩子目录**：`_cdn*` 保留名约 100 个、`SubscribeForDBChange` | 原文 |
| [host-actions.md](host-actions.md) | `RegisterAction` 5 参数、`InsertXMLMenu` 嵌套结构、enabler/handler 契约 | 原文 |
| [plugin-lifecycle.md](plugin-lifecycle.md) | `capAutoLoad` 即入口、`<Feature>Init.tcl` 壳与体、面板三步 | 原文 |
| [web-panel-bridge.md](web-panel-bridge.md) | `orPrmConnector` ↔ `executeTcl`（服务端直接 eval）、白名单骨架 | 原文 |
| [host-panel-api.md](host-panel-api.md) | 240 命名空间 / 3,126 方法；`pStrClientId` 契约；`capObjectAlignment` 120 方法 | 实测 |
| [symbol-editor-api.md](symbol-editor-api.md) | 符号编辑器 59 方法；**`GetPackageXmL`→改→`savePackageData` 往返** | 原文 |
| [orjson-usage.md](orjson-usage.md) | `orjson_*` 64 命令、五个配方、五个坑 | 实测+原文 |
| [host-capability-map.md](host-capability-map.md) | 家族地图：谁管 BOM/变体/CIS/仿真/XML | 实测 |
| [host-api.md](host-api.md) | 早期整理的宿主命令概览（菜单/控制条/放置） | 原文 |

## C. 版本与策略

| 文档 | 内容 | 等级 |
| --- | --- | --- |
| [version-matrix.md](version-matrix.md) | 16.6/17.2/17.4 实测对照；族级增量；两版行为差异 | 实测 |
| [coverage.md](coverage.md) | 覆盖面盘点（69.7%）、未覆盖家族分三层、收尾顺序 | 实测 |

## D. 方法学（自己补 API 空白）

| 文档 | 内容 | 等级 |
| --- | --- | --- |
| [probing-api-gaps.md](probing-api-gaps.md) | 类型错误文本反推参数、临时对象当 self、`DboState` 报错真实语义 | 实测 |
| [allegro-3d-and-models.md](allegro-3d-and-models.md) | 封装↔3D 绑定：`axlStepSet/Get` 读回校验、清单哈希与 `height_source` | 原文+实测 |
| [../SKILL.md](../SKILL.md) §13 | 验证方法（headless 冒烟、回读校验、编码陷阱） | 实测 |

## E. 数据文件（查阅型，别通读）

| 文件 | 规模 | 内容 |
| --- | --- | --- |
| [signatures-17.4.csv](signatures-17.4.csv) / [.tsv](signatures-17.4.tsv) | 3.9k 行 | 同 signatures.md，机读 |
| [dbo-commands-17.4.csv](dbo-commands-17.4.csv) / [-16.6.csv](dbo-commands-16.6.csv) | ~6100 / 4962 行 | 类·方法·种类·命令名，便于 diff |
| [commands-17.4.txt](commands-17.4.txt) · [-17.2](commands-17.2.txt) · [-16.6](commands-16.6.txt) | 6.1k / 6.0k / 5.0k 行 | 各版本命令全量清单 |

## F. 机器可筛产物（给模型按需加载）

| 产物 | 规模 | 用法 |
| --- | --- | --- |
| [classes/](classes/README.md) | 293 个文件 / 256 KB | **按类拆分的签名表**：每个 Dbo 类一个文件（`DboLibPart.md` 等），只加载需要的类，不必吞 245 KB 的 signatures.md；[classes/README.md](classes/README.md) 是全类索引（类名 → 方法数 → 文件） |
| [traps.tsv](traps.tsv) | 30 行 / 7 列 | **坑表**：`api` `area` `symptom` `cause` `fix` `evidence` `status`；可直接按 `area`/`status` 过滤。`status` 取值：`verified`(23) / `unknown`(6) / `unknown-enum`(1) |
| [llm-facts.md](llm-facts.md) | 事实库 | 硬规则、精确签名、假成功清单、报错映射、决策表、未验证清单——先读这个 |

## 建议阅读路径

- **只写一个改属性的脚本**：[SKILL.md](../SKILL.md) §4.2 + §6 + [`safe-edit-prop.tcl`](../examples/safe-edit-prop.tcl)
- **写插件（菜单/面板）**：§10 + [host-actions.md](host-actions.md) + [plugin-lifecycle.md](plugin-lifecycle.md) + [host-event-hooks.md](host-event-hooks.md) + [`plugin-skeleton.tcl`](../examples/plugin-skeleton.tcl)
- **做符号库工具**：[symbol-editor-api.md](symbol-editor-api.md)（改旧）+ [official-symbol-builder.md](official-symbol-builder.md)（新建）
- **做放置/连线工具**：[host-place-api.md](host-place-api.md) + [`place-from-csv.tcl`](../examples/place-from-csv.tcl)
- **做 BOM/导出**：[dbo-advanced.md](dbo-advanced.md) §10 + [host-capability-map.md](host-capability-map.md) §3（`CNewBOm`）
- **想自己继续挖**：[probing-api-gaps.md](probing-api-gaps.md) + [`export-host-commands.tcl`](../scripts/export-host-commands.tcl)
