# `DboTclUtils` / 容器 helper：JSON 输出与 `std::string&` 出参的用法（实测）

`DboTclUtils_*` 里有一批"直接产出 JSON"的助手（属性块树、BOM、组件列表）。它们的签名在 `signatures-17.4.csv` 里**参数名和顺序都不可靠**，但用类型错误探测可以逐位确定。以下是全部实测结果。

## 1. 通用出参模式：`std::string&`

`signatures` 里写 `prStrJSONProp`，实际类型是 **`std::string &`**，必须用 `sMakeStdStr` 造对象：

```tcl
proc mk {v} { return [DboTclHelper_sMakeCString $v 0] }
set out [DboTclHelper_sMakeStdStr [DboTclHelper_sMakeCString ""]]   ;# 1 个参数：初始 CString
DboTclUtils_sGetDesignPartPropertyJSON $design $cstringSet $out
set json [DboTclHelper_sGetConstCharPtr $out]
DboTclHelper_sDeleteStdStr $out
```

坑：`sMakeStdStr` **不接受零参**（零参报 `No matching function for overloaded`），必须给一个 `CString`。空 `std::string` 被 `sGetConstCharPtr` 读出来会得到指针字符串（形如 `_xxxx_p_CString`），非空才返回正文——所以判空要用 `string length` 而不是比较内容。

## 2. `DboTclUtils` 逐个实测

### 2.1 `sGetDesignPartPropertyJSON`：属性块 JSON

```tcl
DboTclUtils_sGetDesignPartPropertyJSON <design> <CStringSet> <std::string&>
```

- 第 2 参是 **`std::set<CString>&`**（要 `sMakeCStringSet` 造，传字符串会报 `argument 2 of type 'std::set< CString > &'`）；
- 第 3 参是 `std::string&`（见 §1）。
- 实测输出（PS15 与 HSD_FPGA 均为）：`{"Pkgs":[]}` —— 结构是"按封装的属性块列表"，这两个样本设计里没有 CIS 属性块，所以为空。**schema 形状确认，内容为空**。

### 2.2 `GetPropertyBlockHierachy`：属性树（**11.8 KB 真实 JSON**）

```tcl
set p [DboTclUtils_GetPropertyBlockHierachy <design> <CString propName>]   ;# 返回 CString*
set json [DboTclHelper_sGetConstCharPtr $p]
```

`GetPropertyBlockHierachy $design "Value"` 在 HSD_FPGA 上返回 11,829 字节，结构（截断样例）：

```json
{"Name":"BlockTree",
 "IsFlatDesign":false,
 "attrShowCheckBox":true,
 "attrRMBMenuItemsShow":true,
 "onRMBMenuClick":{"attrItems":{
   "rmbselectallchildren_pb":{"attrItemLabel":"Select All Children","attrEnabled":true},
   "rmbunselectallchildren_pb":{"attrItemLabel":"Unselect All Children","attrEnabled":true}}},
 "data":[
   {"name":"X.DSN","nodeType":"rootocc","ref":"0","value":"Value","id":"1",
    "refRange":{"IsDataMigrated":1},
    "refCount":[
      {"name":"Value=0","count":{"*":6,"R":6}},
      {"name":"Value=0.28","count":{"*":1,"R":1}},
      {"name":"Value=01_SWITCH_REG","count":{"*":1,"Power Supply":1}},
      {"name":"Value=1.2k","count":{"*":2,"R":2}},
      {"name":"Value=1.8u","count":{"*":3,"L":3}}
    ]}
 ]}
```

要点：

- `data[].nodeType` 见 `rootocc`；层级设计 `IsFlatDesign=false`，平面设计为 `true`；
- `refCount[]` 是**该属性值的分布统计**：`count` 里 `*` 是总数，其他键是**符号类型/参考类型**（`R`、`L`、`Power Supply`、`FPGA`…）；
- 这是"属性编辑器/批量改属性"面板的数据源——要做"按某属性值筛选器件"，直接拿这棵树，不用自己遍历。

### 2.3 `GetReferencePrefix`：位号前缀

```tcl
set p [DboTclUtils_GetReferencePrefix [DboTclHelper_sMakeCString "R101"]]   ;# 返回 CString*
set prefix [DboTclHelper_sGetConstCharPtr $p]                               ;# "R"
```

纯函数，不需要 design。

### 2.4 `GetReferenceFromID`：**只要 2 个参数**

```tcl
set p [DboTclUtils_GetReferenceFromID <design> <CString id>]   ;# 第三参会报 Wrong # args
set ref [DboTclHelper_sGetConstCharPtr $p]
```

ID 是**字符串**（`GetId` 的返回值直接用，如 `"0"`、`"650852"`）。

### 2.5 `sGetPartRefAllOccOfParts`：参数顺序与 CSV 不同

CSV 写的是 `pDesign,pOccId,pPropToRead,prStrJSONProp`，实测 **第 2 参要 `std::set<CString> const&`**：

```tcl
DboTclUtils_sGetPartRefAllOccOfParts <design> <CStringSet> <CString propToRead> <std::string&>
```

（传字符串当第 2 参会报 `argument 2 of type 'std::set< CString > const &'`。）

## 3. 容器 helper 全表

| 容器 | 创建 | 增 | 查 / 读 | 删 |
| --- | --- | --- | --- | --- |
| `std::set<CString>` | `sMakeCStringSet`（零参） | `sInsertToCStringSet pSet pStr` | `sFindInCStringSet pSet pStr` | `sDeleteCStringSet` |
| `std::string` | `sMakeStdStr <CString>` | `sSetCString pStr pVal` | `sGetConstCharPtr` | `sDeleteStdStr` |
| `std::vector<std::string>` | `sMakeStdVector` | `sPushBackToVector pVec char const *` | `sGetVectorSize` / `sGetConstCharPtrFromVector pVec i` | `sRemoveFromVector pVec i` |
| `std::map<string,string>` | `sGetStringMap`（取得现有 map） | `sAddToStringMap pMap key value` | `sGetStringMapData pMap pVectorStr` / `sGetValueFromStringMap` | `sDeleteStringMap` |

**注意**：`sFindInCStringSet` 对刚插入的值返回 **0**，看起来不是"找到/未找到"的布尔语义（可能是索引或别的含义），未验证清楚，别拿它做成员判断——要做成员判断就自己维护 Tcl 列表。

## 4. 结论与坑

1. `signatures-17.4.csv` 对 `DboTclUtils_*` 的**参数名与顺序不可信**，逐位探测（传错类型看报错）是唯一可靠办法；
2. `std::string&` 出参必须 `sMakeStdStr <CString>`，零参调用会失败；
3. 出参 JSON 直接是字符串，**可以用 `orjson_parse` 接手**继续加工（宿主里 `orjson_*` 可用）；
4. `GetPropertyBlockHierachy` 是现成的"属性值分布树"，做批量改属性/按值分组工具时优先用它，别自己算。
