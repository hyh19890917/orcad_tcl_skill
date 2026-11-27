# 宿主命令家族地图：3,700 条里都有什么

把真机导出（`commands-all.txt`，9,830 条）减去 headless 可见的 Dbo 面（6,112 条），剩下的宿主命令按前缀归类。这张地图用于回答一个问题：**某个能力（BOM、变体、仿真、CIS、单位换算…）到底该找哪个家族**。

## 1. 家族总表（按数量）

| 家族 | 条数 | 用途 | 我们的掌握度 |
| --- | --- | --- | --- |
| `CorSimSrvr` | 232 | 仿真服务端（PSpice 协同仿真） | 未挖 |
| `CPMgt*`（Cfg/DbCfg/DbFieldDef） | 255 | 器件管理 / CIS 库配置 | 未挖 |
| `DBXMLWriter` | 148 | 把设计写成 XML（含 `AddOffPageConnector`/`AddJunctionTag` 等标签生成） | 未挖（文档级已知存在） |
| `orSysObjectsManager` | 145 | 系统对象管理（xnet / SI 模型 / EC set 关联） | 未挖 |
| `CISDesign` / `CISPartInst` / `CISSchematic` / `CISPage` / `CISVariantPartOBJ` | 123 + 55 + 33 + 33 + 57 | CIS（元件信息系统）数据库器件与变体 | 未挖 |
| `CPSpiceProject` | 135 | PSpice 工程 | 未挖 |
| `pSpiceExplorerServer` | 86 | PSpice 浏览器服务 | 未挖 |
| `CVariant` | 72 | **变体（assemblies）**：分组/子组/克隆/删除 | 未挖 |
| `orjson_*` | 64 | **Tcl 侧 JSON 工具集**（构造/解析/转换/编码） | 部分（官方脚本用法已见） |
| `orDAOPI` | 63 | 数据访问层 | 未挖 |
| `CNewBOm` | 40 | **新 BOM 引擎**：分组/变体/取数 | 未挖 |
| `COrSpecificProjectManagerWrapper` | 53 | 工程管理包装 | 未挖 |
| `COrTree` | 34 | 树控件数据 | 未挖 |
| `COrCMTclInterface` | 42 | Tcl 接口层 | 未挖 |
| `capObjectAlignment` | 24（+120 个 Tcl proc） | 对齐/分布引擎 | **已挖**（见 host-panel-api.md） |
| `capPWL` | 32 | PSpice PWL 源 | 未挖 |
| `capAuto*`（菜单壳） | 60+ | 各功能的 `RegisterActions` / `capLaunchWidget` 壳 | **已挖**（见 plugin-lifecycle.md） |

## 2. `orjson_*`：脚本里可用的 JSON 工具（64 条）

官方脚本里已经在用（`capPdfUtil` / `OrHandlerPDFExport` 都靠它），意味着**写插件时不必自己拼 JSON 字符串**：

```tcl
set node [orjson_new_a "printingMode" [GetOptionString capPDFPrintingMode]]
orjson_push_back $list $node
set obj [orjson_parse $jsonStr]
set v   [orjson_get $obj "outputDirectory"]
set s   [orjson_as_string $v]
set i   [orjson_as_int $v]
```

导出里见到的其它成员（共 64 条，按字母序抽样）：

```text
orjson_as_array / as_binary / as_bool / as_float / as_int / as_node / as_string
orjson_begin / end / clear / copy / cast / duplicate / equal
orjson_decode64 / encode64
orjson_delete / delete_stream / erase / erase_multi
orjson_find / find_nocase
orjson_at
```

用法要点：`orjson_new_a <key> <value>` 造一个键值节点；`orjson_push_back <list> <node>` 追加；`orjson_get <obj> <key>` 取值后必须用 `orjson_as_*` 转成 Tcl 值——**`orjson_get` 返回的是 JSON 节点不是字符串**，这一点和 `capPdfUtil` 里的写法完全一致。

## 3. `CNewBOm`：新 BOM 引擎（40 条）

```text
CNewBOm_AddGroup / AddGroupToBomVariant / AddPartsToBom / AddPtrForBom
CNewBOm_CloneBomVariant / GetAvailBomVariantForGroup
CNewBOm_DeleteGroup / DeleteGroupInBom / DeleteInBom / DeleteParts
CNewBOm_GetAllParts / GetArray / GetBomCount / GetBomData
CNewBOm_CleanBomPtr / ClearAmbig / Close
```

对照前面挖到的 `DboTclBom_GetBOMJSON`（返回 std::string 的 JSON）：**`DboTclBom_*` 是"导出 BOM JSON"，`CNewBOm_*` 是"操作 BOM 结构"**（分组、变体、增删件）。要做"多版本 BOM 对比/合并"这类工具，入口在 `CNewBOm_*` 而不是 `DboTclBom_*`。

## 4. `CVariant`：变体（72 条）

```text
CVariant_AddGroup / AddSubGroup / AddPartsToGroup / AddPartsToSubGroup
CVariant_AddUpdatedPartGroup / AddUpdatedPartSubGroup
CVariant_CreateNewGroupAs / CreateNewSubGroupAs
CVariant_CloneBomVariant（在 CNewBOm 侧）
CVariant_DeletUpDatedPartsFromGroup / DeletePartsFromGroup / DeletePartFromAllVariants
CVariant_Cleanup
```

变体是 17.4 的正式特性（`GetActiveVariant` 在探测里返回 ok），这套命令就是它的编程入口。注意官方命名里有拼写错误（`DeletUpDatedParts`），**照抄时别改**。

## 5. 怎么继续挖（按性价比）

1. **`CNewBOm_*` + `DboTclBom_*` 联合**：BOM 工具的完整链路（结构操作 + JSON 导出），直接把 `export-host-commands.tcl` 的探测前缀加上 `CNewBOm|DboTclBom` 跑一次就能拿到参数个数；
2. **`CVariant_*`**：变体工具的入口，同上；
3. **`DBXMLWriter_*`**：如果要做"设计 → XML"导出/比对，这是官方路径（148 条，含 `Add*Tag` 系列）；
4. **`orjson_*`**：先写一页用法速查（用已有调用点 + 少量探测即可），成本低、收益广——所有面板/参数 JSON 都靠它。

## 6. 已知边界

- 这张表来自**装过第三方插件的环境**，`namespace children` 与命令清单会包含非 Cadence 条目；本文只列默认安装自带家族。
- 数量是 `info commands` 的**命令个数**，不等于方法重载数；参数表仍需 arity 探测（见 `probing-api-gaps.md`）。
