# 宿主预置常量（17.4 实测导出，437 个）

由 Dbo 扩展初始化时注册到 Tcl 全局命名空间，直接可用，无需 `package require`。导出方法见同目录 [`dump-constants.tcl`](dump-constants.tcl)（换版本重跑即可），全量清单见 [`constants-17.4.txt`](constants-17.4.txt)。

## 1. 对象类型 `DboBaseObject_*`（`GetObjectType` 的返回值）

| 常量 | 值 | 对应对象 |
| --- | --- | --- |
| `::DboBaseObject_DESIGN` | 4 | 设计 |
| `::DboBaseObject_LIBRARY` | 5 | 库(.olb) |
| `::DboBaseObject_PART_CELL` | 6 | 器件单元(Cell) |
| `::DboBaseObject_PAGE` | 10 | 原理图页 |
| `::DboBaseObject_DRAWN_INSTANCE` | 12 | 图形实例 |
| `::DboBaseObject_PLACED_INSTANCE` | 13 | 放置实例 |
| `::DboBaseObject_WIRE_SCALAR` | 20 | 单线 |
| `::DboBaseObject_WIRE_BUS` | 21 | 总线 |
| `::DboBaseObject_LIBRARY_PART` | 24 | 库中器件 |
| `::DboBaseObject_SYMBOL_PIN` | 25 | 符号管脚 |
| `::DboBaseObject_PACKAGE` | 31 | 封装(Package) |
| `::DboBaseObject_DEVICE` | 32 | 器件单元(Device) |
| `::DboBaseObject_OFF_PAGE_CONNECTOR` | 38 | 页间连接符 |
| `::DboBaseObject_DISPLAY_PROP` | 39 | 显示属性 |
| `::DboBaseObject_ALIAS` | 49 | 网络别名 |
| `::DboBaseObject_NET_SCALAR` | 52 | 单网络 |
| `::DboBaseObject_GRAPHIC_INSTANCE` | 54 | 图形实例基类 |
| `::DboBaseObject_INST_OCCURRENCE` | 66 | 层级发生 |
| `::DboBaseObject_FLAT_NET` | 74 | 扁平网络 |
| `::DboBaseObject_ERC_OBJECT` | 77 | ERC 对象 |
| `::DboBaseObject_BOOK_MARK` | 78 | 书签 |
| `::DboBaseObject_CUSTOMITEM_INSTANCE` | 97 | 自定义实例 |
| `::DboBaseObject_DELETED_OBJECT` | 106 | 已删对象 |

> 类型码不是魔法数：13=放置实例、31=封装、66=层级发生 都有官方名字。**代码里用常量，不用数字**（数字随版本可能变，名字不会）。

## 2. 编辑/锁定标志与掩码（`ATTR_*` / `MASK_*`）

```text
DboBaseObject_ATTR_DELETE_LOCK=8
DboBaseObject_ATTR_DISPLAY_LOCK=4
DboBaseObject_ATTR_LOCATION_LOCK=2
DboBaseObject_ATTR_NOLOCK=0
DboBaseObject_ATTR_PRESERVE_EDIT=128
DboBaseObject_ATTR_SUPPORT_PRETRIGGER=32
DboBaseObject_ATTR_SYSTEM_LOCK=16
DboBaseObject_ATTR_VALUE_LOCKED=1
DboBaseObject_MASK_ALL=-1
DboBaseObject_MASK_BOXOFF=8
DboBaseObject_MASK_LOCKED=1
DboBaseObject_MASK_NONE=0
DboBaseObject_MASK_SELECTED=2
DboBaseObject_MASK_TEMPINVISIBLE=16
DboBaseObject_MASK_TEMPLOCK=4
DboBaseObject_MASK_UNUSED10=512
DboBaseObject_MASK_UNUSED11=1024
DboBaseObject_MASK_UNUSED12=2048
DboBaseObject_MASK_UNUSED13=4096
DboBaseObject_MASK_UNUSED14=8192
DboBaseObject_MASK_UNUSED15=16384
DboBaseObject_MASK_UNUSED16=32768
DboBaseObject_MASK_UNUSED17=65536
DboBaseObject_MASK_UNUSED18=131072
DboBaseObject_MASK_UNUSED19=262144
DboBaseObject_MASK_UNUSED20=524288
DboBaseObject_MASK_UNUSED21=1048576
DboBaseObject_MASK_UNUSED22=2097152
DboBaseObject_MASK_UNUSED23=4194304
DboBaseObject_MASK_UNUSED24=8388608
DboBaseObject_MASK_UNUSED26=33554432
DboBaseObject_MASK_UNUSED27=67108864
DboBaseObject_MASK_UNUSED28=134217728
DboBaseObject_MASK_UNUSED29=268435456
DboBaseObject_MASK_UNUSED30=536870912
DboBaseObject_MASK_UNUSED31=1073741824
DboBaseObject_MASK_UNUSED32=-2147483648
DboBaseObject_MASK_UNUSED6=32
DboBaseObject_MASK_UNUSED7=64
DboBaseObject_MASK_UNUSED8=128
DboBaseObject_MASK_UNUSED9=256
DboBaseObject_MASK_VALUE_IFVALUE=16777216
DboBaseObject_MASK_WAIVE_ERC=16777216
```

## 3. 值枚举 `DboValue_*`（共 155 个，常用节选）

```text
DboValue_COLOR40=40
DboValue_COLOR41=41
DboValue_COLOR42=42
DboValue_COLOR43=43
DboValue_COLOR44=44
DboValue_COLOR45=45
DboValue_COLOR46=46
DboValue_COLOR47=47
DboValue_DASH_DOT_DOT_LINE=4
DboValue_DASH_DOT_LINE=3
DboValue_DASH_LINE=1
DboValue_DEFAULT_OBJECT_COLOR=48
DboValue_DOT_LINE=2
DboValue_DO_NOT_DISPLAY=0
DboValue_HATCHED_FILL=2
DboValue_HORIZONTAL_HATCH=0
DboValue_MEDIUM_WIDTH=1
DboValue_NINETY=1
DboValue_NOROTATION=0
DboValue_ONEEIGHTY=2
DboValue_POWER=7
DboValue_SCHEMATIC_VIEW_TYPE=1
DboValue_SOLID_FILL=0
DboValue_THIN_WIDTH=0
DboValue_TWOSEVENTY=3
DboValue_VERTICAL_HATCH=1
DboValue_WIDE_WIDTH=2
```

## 4. 迭代器过滤位 `IterDefs_*`（共 128 个，前 30）

```text
IterDefs_ALIASES=30
IterDefs_ALL=0
IterDefs_ARCS=12
IterDefs_BEZIERS=32
IterDefs_BITMAPS=17
IterDefs_BOOKMARKS=29
IterDefs_BOXES=10
IterDefs_BUNDLES=3
IterDefs_BUSES=4
IterDefs_CELLS=22
IterDefs_CELL_PART_ITER=20
IterDefs_COMMENTS=16
IterDefs_DESIGN_FLATNET_ITER=18
IterDefs_DESIGN_GLOBAL_ITER=19
IterDefs_DESIGN_OCCURRENCE_ITER=71
IterDefs_DESIGN_SCHEMATIC_OCCURRENCE_ITER=72
IterDefs_DEVICE_NUMBER_ITER=51
IterDefs_DISPLAY_PROP_ITER=87
IterDefs_ELLIPSES=13
IterDefs_ERCS=28
IterDefs_EXPORTBLOCK_COMMENTGRAPHICS_ITER=80
IterDefs_EXPORTBLOCK_CONNECTOR_ITER=78
IterDefs_EXPORTBLOCK_ENTRY_ITER=79
IterDefs_EXPORTBLOCK_GLOBAL_ITER=77
IterDefs_EXPORTBLOCK_PARTINST_ITER=74
IterDefs_EXPORTBLOCK_PORT_ITER=76
IterDefs_EXPORTBLOCK_TITLEBLOCKS_ITER=81
IterDefs_EXPORTBLOCK_WIRE_ITER=75
IterDefs_EXTERNAL_VIEWS=5
IterDefs_FLAT_NET_NET_ITER=83
```

用法：`$design NewViewsIter $st $::IterDefs_SCHEMATICS`、`$occ NewChildrenIter $st $::IterDefs_INSTS`、`$page NewPartInstsIter $st`。
