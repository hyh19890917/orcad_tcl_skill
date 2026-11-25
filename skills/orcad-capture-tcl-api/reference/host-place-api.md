# 放置类宿主命令：`Place*` 的完整签名（实测）

在 Capture 17.4 里用 `scripts/export-host-commands.tcl --probe-place` 零参探测得到的真实参数表。**这些不是 Dbo 方法，是宿主命令**——所以之前用 `DboWire_NewName` 建网络标签才会"返回 OK 却什么都不做"。

## 1. 完整签名表

### 1.1 坐标类（`x y` 或 `x1 y1 x2 y2`）

| 命令 | 参数 | 说明 |
| --- | --- | --- |
| `PlaceWire` | `x1 y1 x2 y2` | 画一段导线（一段 = 一个 wire 对象，不是折线） |
| `PlaceBus` | `x1 y1 x2 y2` | 画总线 |
| `PlaceLine` | `x1 y1 x2 y2` | 直线 |
| `PlaceRectangle` | `x1 y1 x2 y2` | 矩形（对角两点） |
| `PlaceEllipse` | `x1 y1 x2 y2` | 椭圆（外接矩形） |
| `PlacePolyline` | `x1 y1 x2 y2` | 折线首段（后续用 `PlaceNextPolylinePoint` 续点） |
| `PlacePolygon` | `x1 y1 x2 y2` | 多边形首段（后续用 `PlaceNextPolygonPoint`） |
| `PlaceBezier` | `x1 y1 x2 y2` | 贝塞尔首段（后续用 `PlaceNextBezierPoint`） |
| `PlaceArc` | `x1 y1 x2 y2 x3 y3 x4 y4` | 圆弧：**四个点** |
| `PlaceJunction` | `x y` | 连接点 |
| `PlaceNoConnect` | `x y` | 不连接标记 |
| `PlaceNetAlias` | `x y netAlias` | **网络标签（别名）** |
| `PlaceBookMark` | `x y markName` | 书签 |
| `PlacePicture` | `x y fileName` | 贴图 |
| `PlaceText` | `x1 y1 x2 y2 commentText` | 文本（两角点定框） |

### 1.2 需要库与符号名的（`x y libName symbolName <名字>`）

| 命令 | 参数 |
| --- | --- |
| `PlacePort` | `x y libName symbolName PortName` |
| `PlaceOffPage` | `x y libName symbolName OffPageName` |
| `PlacePower` | `x y libName symbolName PowerName` |
| `PlaceGround` | `x y libName symbolName GroundName` |
| `PlaceTitleBlock` | `x y libName symbolName titleblockName` |
| `PlacePin` | `x y pinName pinType boolvalue5` |

这组是"**符号来自库**"的放置：`libName` + `symbolName` 指定用哪个库里的哪个符号，最后一个参数是显示名。之前几轮想用 Dbo 造 off-page connector 卡住，正解就是这里——`PlaceOffPage x y <lib> <symbol> <name>`。

### 1.3 器件放置（有状态的多步协议）

| 命令 | 参数 | 行为 |
| --- | --- | --- |
| `PlacePart` | `x y libName pkgName device boolvalue6` | 直接放置：库 + 封装名 + 器件 |
| `PlacePartEx` | （重载，参数未暴露） | 扩展版 |
| `PlacePartAddLib` | `aLibName` | 把库加入放置会话的库列表 |
| `PlacePartSelectLibIndex` | `aIndex` | 按索引选库 |
| `PlacePartSelectPartIndex` | `aIndex` | 按索引选件 |
| `PlacePartSelectDeviceIndex` | `aIndex` | 按索引选 device |
| `PlacePartSelectPartByNameAndLib` | `pPartName pLibFullPathName` | **按"件名 + 库全路径"选件**（最稳） |
| `PlacePartGetLibIndex` | （零参）→ 返回 `0` | 当前选中的库索引 |
| `PlacePartGetPartIndex` | （零参）→ 返回 `-1` | 当前选中的件索引（未选时为 -1） |
| `PlacePartClickPlace` | （零参）→ 返回 `1` | 进入"点击放置"模式 |
| `PlacePartDump` | （零参）→ 返回 `1` | 导出当前放置会话状态 |
| `PlacePartToolTip` | `value` | 放置时的提示文本 |
| `PlaceCisDatabasePart` | `aPartNumber` | 按 CIS 料号放置 |

**关键推论**：`GetLibIndex` 返回 `0`、`GetPartIndex` 返回 `-1`、`SelectXxxIndex` 接受索引——说明宿主内部维护一个"**当前待放置件**"的状态机。所以 `PlacePart` 是"六参一次性放置"，而 `PlacePartAddLib → SelectLibIndex → SelectPartIndex → ClickPlace` 是"交互式放置"那条路。写批处理脚本优先用 `PlacePartSelectPartByNameAndLib`（不依赖索引顺序）。

### 1.4 网络组（特殊，需要页上下文）

| 命令 | 参数 |
| --- | --- |
| `PlaceNetgroupBlock` | `x1 y1 x2 y2 sinstName NetgroupOwner` |
| `PlaceNetgroupPort` | `x y libName symbolName OffPageName NetgroupOwnerName` |
| `PlaceNetgroupOffPage` | 同上 |
| `PlaceNetgroupPower` | 同上 |
| `PlaceNetgroupGround` | 同上 |
| `PlaceNetgroup` | 零参时报 `RuntimeError: Command Requires SchematicView` |

### 1.5 层级块

| 命令 | 参数 |
| --- | --- |
| `PlaceBlock` | `x1 y1 x2 y2 libName viewName instName primitiveType` |

## 2. 三条使用规则

1. **必须有打开的页**：`PlaceNetgroup` 在无页时直接抛 `RuntimeError: Command Requires SchematicView`。所有放置命令都依赖当前 schematic 视图——跑批前先 `GetActivePage`（并 `catch`）。
2. **坐标是数据库单位**（通常 1/100 inch），与 Dbo 的 `GetLocation` 同一坐标系；先用 Dbo 读包围盒算好坐标，再调 `Place*`。
3. **一次 `PlaceWire` = 一段**：折线要多次调用，或用 `PlaceNextPolylinePoint` 续点。这与 Dbo 侧"每根 Wire 就是一段"一致。

## 3. 最小可用骨架（需在 Capture 内运行，headless 无这些命令）

```tcl
# 前置：取当前设计/页（宿主侧）
if {[catch {set page [GetActivePage]}]} { error "no schematic page open" }

# 1) 画一段导线
catch {PlaceWire 100 100 200 100}

# 2) 在导线中点打网络标签
catch {PlaceNetAlias 150 100 "VDD_3V3"}

# 3) 打连接点
catch {PlaceJunction 100 100}

# 4) 放一个页间连接符（libName/symbolName 换成你库里实际存在的）
catch {PlaceOffPage 300 100 "CAPSYM" "OFFPAGELEFT-R" "VDD_3V3"}

# 5) 放器件：优先"按名字+库路径"，避免索引状态
catch {PlacePartSelectPartByNameAndLib "R" "D:/libs/Discrete.olb"}
catch {PlacePart 400 100 "Discrete" "RES_0603" "R" 1}
```

要点：**全部用 `catch` 包住**——放置类命令失败时可能抛 `RuntimeError`（无页/无库/符号不存在），不是返回状态码。

## 4. 尚未验证的部分

- `PlacePart` 的第 6 参 `boolvalue6` 语义未知（推测是"是否自动编号/是否弹属性框"），需要在真实会话里试；
- `PlacePartEx` / `PlaceNew` 是真重载，参数表未暴露；
- `PlaceNext*Point` 的续点坐标语义（是绝对坐标还是相对上一点）未测；
- 各 `Place*WithDialog` 变体未测（会弹窗，不适合批处理）。
