# 应用级 C* 类与官方"成套流程"

Dbo 之外，Capture 的 Tcl 解释器里还注册了一批 **`C*` 前缀的应用层类**（配置、路径、弹窗、差异比较）。它们不在 `orDb_Dll_Tcl` 的语义里，属于 Capture 应用框架，**跨版本更脆弱**，但官方脚本用得很多，值得知道它们存在。下面按用途给清单，并标注官方 564 个 tcl 里的出现次数。

## 1. C* 应用层类（按出现次数）

| 命令 | 次数 | 用途 |
| --- | --- | --- |
| `COrSmiUtils_sSMIGetMessage` | 128 | 取本地化消息串（SMI = 消息接口） |
| `COrConfigField_CFT` | 85 | 配置字段类型枚举 |
| `COrSmiUtils_sShowMessageBox` | 60 | 宿主风格弹窗（比 `tk_messageBox` 更原生） |
| `COrSingleCStringValue` / `COrSingleBoolValue` / `COrMultiValue` | 58 / 27 / 13 | 配置值包装对象 |
| `COrPathUtil_sGetDir` / `sGetCDSRootDir` / `PATHTTYPE` | 20 / 18 / 20 | 安装路径解析（CDSROOT 等） |
| `COrConfigTable_sGetDataInJSON` / `COrConfigTable` | 11 / 11 | 配置表读成 JSON |
| `COrCMTclInterface_SetGlobalConfiguration` | 17 | 写全局配置 |
| `CISTclHelper_sMakeCUIntArray` | 14 | CIS 侧数组编组 |
| `CDiffConfiguration_eLOGICAL` / `eOBJECTID` / `eOBJECTNAME` / `eOBJECTLEVEL` | 12 / 11 / 3 / 3 | 差异比较的匹配口径 |
| `CDesignDiff_eDIFF` / `CDesignDiff` | 2 | 设计差异对象（17.4+） |

**用法建议**：能用 Dbo 就别用 C*。真正值得用的只有两类：
- `COrSmiUtils_sShowMessageBox` —— 需要宿主原生外观的提示/确认框时；
- `CDiffConfiguration_e*` + `CDesignDiff` —— 要做"两个设计/两个库之间对比"时（见 §4），自己实现差异算法成本很高。

## 2. StringMap：C++ ↔ Tcl 传字典

5 个命令，CIS 官方样例里出现 12 次，是"把一批键值对交给 C++"的标准做法：

| 命令 | 说明 |
| --- | --- |
| `DboTclHelper_sMakeStringMap` | 建空 map |
| `DboTclHelper_sAddToStringMap <map> <key> <value>` | 追加 |
| `DboTclHelper_sGetStringMap <map> <key>` | 取值 |
| `DboTclHelper_sGetValueFromStringMap` | 取值的另一种形态 |
| `DboTclHelper_sGetStringMapData <map>` | 导出全部数据 |
| `DboTclHelper_sDeleteStringMap <map>` | 释放 |

典型用法：批量把"属性名→值"喂给某个 C++ 接口，避免几十个位置参数。

## 3. CIS 分组：官方的"分组赋属性"思路

官方样例 `capCustomSamples\capCIS.tcl` 里的流程（112 处 Dbo 调用），核心是几个自建 proc：

| proc | 作用 |
| --- | --- |
| `capCIS::makeGroupSubGroupName` / `getGroupNameStr` / `getSubGroupNameStr` | 把分组键拼成稳定标识 |
| `capCIS::CheckIfSubGroupExist` | 分组是否已存在 |
| `capCIS::AssignPropertyToPartsInGroupSubGroup` | 对整组器件批量写属性 |
| `capCIS::SelectedSchPartAssignPropertyToPartsInGroupSubGroup` | 以当前选中器件为模板，扩散到同组 |
| `capCIS::SetPartMounted` | 标记装配/不装配 |
| `capCIS::CopyLink` / `CopyLinkInfo` | 复制器件与库/物料的关联 |

**可借鉴的点**：分组键用"多字段拼接 + 规范化"（大小写/空格统一）而不是哈希；批量写属性时先按组聚合再逐组写，减少 `ReadChange`/`MarkModified` 次数。

## 4. 差异比较、搜索、路径替换、对齐、导出

| 官方包 | 关键命令 | 用途 |
| --- | --- | --- |
| `capDesignDifference` | `CDesignDiff` + `CDiffConfiguration_e*` + `COrSmiUtils_sShowMessageBox` | 两设计差异（按逻辑/对象 id/名字/层级四种口径），输出 JSON |
| `capUnifiedSearch` | 基于 `DboTclUtils` 的 JSON 助手 | 统一搜索（器件/网络/页） |
| `capReplacePathCacheUtil` | `DboPathMgr_*` | 批量替换库/缓存路径（换机器、换库盘） |
| `capAlignObject` | 包围盒 + `SetLocation` | 对齐/分布器件与图形 |
| `capPDFExport` | `capPdfUtil`（284 处 Dbo） | 导出 PDF（页/视图渲染与标题栏处理） |
| `capExtPrefSetup` | `COrConfigField_CFT` + 表单 | 偏好设置界面范式（338 处 Dbo） |

## 5. 官方 Web 宿主：把对象喂给浏览器

`package require orPrmServer`（`tools\capture\tclscripts\orPrmWebApp\tcl`）：

| 命令 | 说明 |
| --- | --- |
| `orPrmServer::run` | 启动宿主侧 web 服务 |
| `orPrmWebProvider::getObjectStream <obj>` | 对象 → 可传输流 |
| `orPrmWebProvider::loadObject <id>` | 由 id 取对象 |
| `orPrmWebProvider::getLibraryNames` / `getDesignNames` | 列出工作区库/设计 |
| `orPrmWebProvider::getWorkspaceElements <sessionId>` | 工作区元素树 |
| `orPrmWebProvider::getPage <file> <schematic> <page> <sessionId>` | 取页内容 |
| `orPrmWebProvider::getContents <file> <type> <sessionId>` | 取文件内容 |
| `orPrmCGI::parseRequest` / `processRequest` / `startContent` / `endContent` | CGI 风格请求处理 |

**对象流协议（实测读源码）**：`getObjectStream` 先看 `$obj GetObjectType`，按 `$::DboBaseObject_PAGE` / `_PACKAGE` / `_LIBRARY` 三选一调用 `orPrmDboStreamer::streamPage|streamPackage|streamLibrary`，再用 `orPrmJSON::encode` 序列化，最后拼成一段 JS：
`oCDNOrPrimeViewer.viewType = <1|2|3>; oCDNOrPrimeViewer.stream = <json>`，由 `loadObject` 在控件里执行 `setTestMode(false); …; viewObject();`。
也就是说：**官方 viewer = "对象→JSON + 注入全局变量"，不是自定义协议**。`orPrmDboStreamer`（64 KB，纯 Tcl）把点/矩形/层/填充/线型/属性逐项 stream，是可以直接拿来做"页/封装预览"的参考实现。

**适合**：只读预览（把页、器件、库内容渲染到网页面板），会话与权限由宿主管。
**不适合**：双向命令（浏览器点一下改原理图）——那需要自己的受限命令通道（一次性 token + 命令白名单 + 超时），或直接用 `executeTcl` 桥。

## 6. 风险与顺序

1. `C*` 类没有文档、也未在 Dbo 命令面里，**跨版本可能改名/消失**：用之前先 `[llength [info commands X]]` 探测，失败要有降级路径（例如弹窗退化为 `tk_messageBox`）。
2. 优先顺序：**Dbo 命令 > capDB 包 > C\* 类**。前两者有官方脚本示例，后者多数只有一处用法。
3. 任何 `C*` 调用都放进 `catch`，并在日志里记录实际返回，方便下一个版本对不上时定位。
