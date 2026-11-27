# 覆盖面盘点：还差多少、哪些值得继续挖

用真机导出（`commands-all.txt`，9,832 条）对照现有 reference 文档做了一次量化盘点。**结论：按家族提及率算约 70%，但剩下 30% 里绝大部分对写插件没价值。**

## 1. 数字

| 指标 | 值 |
| --- | --- |
| 宿主可见命令 | 9,832 |
| headless 可见（Dbo 面） | 6,112 |
| 命令所在的"家族"（按首个 `_` 前的前缀） | 400+ |
| 文档中**提到过**家族名的命令 | 6,849（69.7%） |
| 从未提及的 | 2,947（30.3%） |

注意口径：这里只统计"家族名是否在文档里出现过"，**不等于该家族的方法被逐个验证过**。真实"已验证方法"远低于 69.7%。

## 2. 未覆盖的 Top 20 家族，按性质分三层

### A 层：有官方调用点 → **可以离线挖**

| 家族 | 条数 | 官方调用 | 说明 |
| --- | --- | --- | --- |
| `OrSymbolEditor*` | 22+ | 39 处 | 符号编辑器面板（`::OrSymbolEditorConfig` 命名空间） |
| `COrDRCTclInterface` | 23 | 9 处 | DRC 计数/查询，例如 `COrDRCTclInterface_GetPhysicalDRCCount $name $::COrDRCTclInterface_DRC_ERROR` |

### B 层：零调用点、但业务价值高 → **只能真机探测**

| 家族 | 条数 | 用途 |
| --- | --- | --- |
| `CDiffDesignReader` / `CDiffComparator` / `CDiffObject` | 37+34+21 | **设计比对**（两份 .dsn 差异） |
| `CNewBOm` / `CVariant` | 40+72 | BOM 结构操作 / 变体 |
| `DBXMLWriter` | 148 | 设计 → XML 导出 |
| `RefDesQueryObject` | 33 | 位号查询对象 |
| `orExprEval` | 25 | 表达式求值器 |
| `CPMgt*` 子族（DbFieldDef 等） | 45+ | CIS 库字段定义 |

### C 层：绑定层类，对脚本作者基本无用 → **不必挖**

`CAlias`(24) `IAlias`(22) `CDiffObject`(21) `PSpiceCallback`(31) `orPIOObject`(31) `ERCData`(30) `CISBase`(31) `Psp2CapBaseInfo`(21) `CPSpiceNode`(20) `OrISimObj*`(37+35+22)…

这些是 C++ 对象的 Tcl 绑定，官方脚本一次都没用；语义要靠真机试，收益接近零。

## 3. 所以"还有的挖吗"

有，但**性质和前几轮不同了**：

1. **离线可挖的只剩两支**：`OrSymbolEditor*`（符号编辑器面板 API）与 `COrDRCTclInterface`（DRC 查询）。这两支有官方调用点，能直接读出参数与用法，不需要再麻烦你开 Capture。
2. **高价值但必须真机**：`CNewBOm`/`CVariant`/`CDiff*`/`orExprEval`。其中 BOM+变体已经准备好一键探测（`--probe-bom`），跑一次就能补上参数表。
3. **剩下的 30% 里，C 层占比很大**——把这些算进"待挖"会高估缺口。

## 4. 建议的收尾顺序

1. 跑一次 `--probe-bom`，把 BOM/变体/XML/orjson 的参数表补齐（一次性）；
2. 读 `OrSymbolEditor*` 与 `COrDRCTclInterface` 的官方调用点，写成两页（离线）；
3. 之后转入**收口整理**：把 30 篇 reference 按主题合并（宿主面 / Dbo 面 / 实战示例），统一"实测 / 推断 / 未知"标注，而不是继续加新篇。

理由：现在文档数量已经超过"一个人能顺畅读完"的规模，继续追加的边际价值低于重新组织。
