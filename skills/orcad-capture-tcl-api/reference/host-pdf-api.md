# PDF 打印与标注：`CapPdf*` 六个命令（从调用点恢复的签名）

Capture 17.4 的 PDF 能力分两层：**宿主命令 `CapPdf*`（真正干活）** 与 **脚本层 `capPdfUtil` / `capPDFExport`（准备数据 + 面板）**。之前几轮只看到脚本层，这轮把命令层的签名和选项表从官方调用点里挖出来了。

## 1. 六个命令

| 命令 | 参数的来源 | 形态 |
| --- | --- | --- |
| `CapPdfSetOption` | 探测：`lOptionName lOptionValue` | 选项名 + 值 |
| `CapPdfGetOption` | 探测：`lOptionName` | 选项名 → 返回字符串 |
| `CapPdfPrint` | 探测：`lOutDir lOutFileName` | 输出目录 + 文件名 |
| `CapPdfAddMarkStart` | 探测：`pStartPtX pStartPtY pEndPtX pEndPtY pId pAttributeMarkType` | 包围盒两角点 + 标识 + **标注类型** |
| `CapPdfAddMarkData` | 探测：`pName pValue` | 一条键值对 |
| `CapPdfAddMarkEnd` | 探测：零参（返回 ok） | 闭合当前标注 |

> 六个签名现在全部来自**真机零参探测**（参数名由宿主报出），不是从调用点猜的。第 6 参的名字是 `pAttributeMarkType`——**它是"标注类型"标记，不是简单布尔**；官方 18 处调用里 **0 与 1 都出现过**，规律见 §8.1。

## 2. 选项表（从 `CapPdfSetOption` 的调用点归纳）

| 选项 | 取值 | 说明 |
| --- | --- | --- |
| `InstMode` | `"True"` / `"False"` | 实例模式（官方据此设 `mIsInstMode`） |
| `CreateNetBookMarks` | `"True"` / `"False"` | 为网络生成书签 |
| `CreateRefdesBookMarks` | `"True"` / `"False"` | 为位号生成书签 |
| `CreatePropertiesPdfFile` | `"True"` / `"False"` | 附带属性 PDF |
| `LandscapeOrientation` | `"True"` / `"False"` | 横向 |
| `PaperSize` | 索引值（`$::capPdfUtil::mPaperSizeListIndex`，默认 0） | 纸张，**传的是列表索引不是名字**（见 2.1） |
| `PostscriptDriver` | 驱动名字符串，默认 `"Acrobat Distiller"` | 打印驱动；官方从 ini `capPDFPrintingMode` 兜底 |

### 2.1 纸张索引表（`capPdfUtil::populatePaperSizeList`，共 70 项 0..69）

`PaperSize` 的取值就是这张表的下标，**0 = Default**。常用项：

| 索引 | 名称 |
| --- | --- |
| 0 | Default |
| 1 | US Letter 8 1/2 x 11 in |
| 3 | US Tabloid 11 x 17 in |
| 4 | US Ledger 17 x 11 in |
| 5 | US Legal 8 1/2 x 14 in |
| 8 | A3 297 x 420 mm |
| 9 | A4 210 x 297 mm |
| 11 | A5 148 x 210 mm |
| 12 | B4 (JIS) 257 x 364 mm |
| 13 | B5 (JIS) 182 x 257 mm |
| 42 | B4 (ISO) 250 x 353 mm |
| 66 | A2 420 x 594 mm |

表里还有信封尺寸（19–23、27–36、47、69）、Fanfold（39–41）、Transverse 变体（54–56、61–62、67–68）、以及第 **48/49 项是 `RESERVED--DO NOT USE`**（别传这两个）。

`examples/export-pdf.tcl` 支持写别名（`--paper a4` → 9、`--paper letter` → 1、`--paper tabloid` → 3），映射不到时按原值透传。

### 2.2 配套的偏好键（`GetOptionString` / `SetOptionString`）

面板把用户上次的选择存在 Capture 偏好里。**本机 `…\cdssetup\OrCAD_Capture\17.4.0\Capture.ini` 里的实际键（12 条）**：

```ini
capPDFOutputFolder=
capPDFDriver=OrCADPS_17.4
capPDFCommandIndex=2
capPDFConverter=Ghostscript 64 bit / equivalent
capPDFExcludeProp=Line Style!!Line Width!!Color!!Location X-Coordinate!!Location Y-Coordinate
capPDFCommand2={gswin64c.exe} -sDEVICE=pdfwrite -sOutputFile=$::capPdfUtil::mPdfFilePath -dBATCH -dNOPAUSE $::capPdfUtil::mPSFilePath
capPDFCommand0=
capPDFCommand1=
capPDFCommand3=
capPDFPrintingMode=0
capPDFOrientation=1
capPDFCreatePropertiesFile=0
capPDFCreateNetAndBookmark=1
capPDFPaperSize=9
```

| 键 | 作用 |
| --- | --- |
| `capPDFDriver` | PostScript 打印机名（本机 `OrCADPS_17.4`） |
| `capPDFConverter` | 转换器描述（人读，如 `Ghostscript 64 bit / equivalent`） |
| `capPDFCommandIndex` + `capPDFCommand<N>` | 选中的转换命令；命令是**一段可 `eval exec` 的 Tcl 串**，里面引用 `$::capPdfUtil::mPdfFilePath` / `mPSFilePath` |
| `capPDFExcludeProp` | **要排除的属性名列表，用 `!!` 分隔** —— `capPdfUtil::isFilteredProp` 就是读它来过滤标注属性 |
| `capPDFOutputFolder` | 上次输出目录 |
| `capPDFOrientation` | 纸张方向（1 = ？与 `LandscapeOrientation` 不同键） |
| `capPDFPaperSize` | 纸张索引（与 `PaperSize` 同值域 0..69） |
| `capPDFPrintingMode` | 打印模式（0/1） |
| `capPDFCreatePropertiesFile` / `capPDFCreateNetAndBookmark` | 附带属性 PDF / 网络与位号书签 |

**实测印证**：用 `SetOptionString capPDFPaperSize 9` 写过一次之后，这份 ini 里的值确实变成了 `9` —— 说明"写 ini → `setPdfGenerationOptions` 读取 → 生效"这条链是通的，这也是控制官方编排层选项的正确入口。

自己写工具时，**读这些键可以继承用户上次的选择**，不用每次硬编码。

相关的宿主命令还有 `capIsPrinterDriverAvailable`（判断驱动是否可用，做前置检查用）与 `GetOptionString` / `SetOptionString`（Capture 偏好读写，官方用 `capPDFPrintingMode` 存"打印模式"）。

## 3. 两条流程

### 3.1 打一份 PDF

```tcl
# 前置：必须有设计
set d [GetActivePMDesign]
if {$d eq "NULL"} { error "no active design" }

CapPdfSetOption "InstMode"             "True"
CapPdfSetOption "CreateNetBookMarks"   "True"
CapPdfSetOption "CreateRefdesBookMarks" "True"
CapPdfSetOption "LandscapeOrientation" "False"
CapPdfSetOption PaperSize              $paperIndex

if {[catch {CapPdfPrint $outDir $outFile} res]} {
    puts "pdf print failed: $res"
} else {
    puts "pdf ok: [file join $outDir $outFile]"
}
```

注意 `CapPdfPrint` **返回的是"成功/失败"而不是文件**，真正的落盘路径由你传的 `outDir/outFile` 决定；官方也是用 `catch` 判成败。

### 3.2 给某个对象加标注（书签/链接区域）

```tcl
# 官方 annotate* 的通用套路：先取对象包围盒 → Start → 若干 Data → End
set bbox [$obj GetBoundingBox]
set tl [DboTclHelper_sGetCRectTopLeft $bbox]
set br [DboTclHelper_sGetCRectBottomRight $bbox]
CapPdfAddMarkStart [DboTclHelper_sGetCPointX $tl] [DboTclHelper_sGetCPointY $tl] \
                   [DboTclHelper_sGetCPointX $br] [DboTclHelper_sGetCPointY $br] \
                   $idOrName 0
CapPdfAddMarkData "Part Reference" "R101"
CapPdfAddMarkData "Value" "10k"
CapPdfAddMarkEnd
```

官方在 `capPdfUtil::annotateAlias` / `annotateEffectiveProp` 里就是这么做的：**包围盒两角点 + 一个标识 + 0**，中间叠 `AddMarkData` 键值对，最后 `AddMarkEnd`。

## 4. 与脚本层的关系

```text
capAutoPDFExport_RegisterActions        ;# 注册菜单（RegisterAction + _cdnCapActionPDFExport）
  └─ capAutoPDFExport_ExportToPDF       ;# 面板入口: ::OrEntryPDFExport::capLaunchWidget "hostedClientId"
capPdfUtil::annotatePageObjects …       ;# 遍历页对象，调 Dbo 取包围盒/属性
  ├─ DboTclHelper_sSetDboObjectInProcess $obj   ;# 把对象交给渲染侧
  └─ CapPdfAddMarkStart/Data/End                ;# 打标注
CapPdfPrint outDir outFile              ;# 真正生成 PDF
```

也就是说：**脚本层负责"准备什么"，命令层负责"生成"**。自己写导出工具时，可以跳过 `capPdfUtil` 只调 `CapPdf*`，但页对象的遍历/包围盒/属性过滤仍要自己做（那部分逻辑在 `capPdfUtil` 里，可参考）。

## 7. 真机实测记录（17.4，`examples/export-pdf.tcl`）

第一次在真实 Capture 里跑，结果值得记下来——**选项全通，但不出文件**：

```text
set InstMode = True (readback: True)
set CreateNetBookMarks = True (readback: True)
set CreateRefdesBookMarks = True (readback: True)
set CreatePropertiesPdfFile = False (readback: False)
set LandscapeOrientation = False (readback: False)
set PaperSize = 9 (readback: 9)
CapPdfPrint code=0 ret=  elapsed=4ms
file NOT created: D:/tmp/pdf-out/test.pdf
result: FAILED (print returned ok but no file)
```

结论与下一步：

1. **七个选项的 Set/Get 全部可靠**（readback 逐项一致），`PaperSize=9` 也被接受——选项层不用怀疑；
2. `CapPdfPrint` **返回成功但什么都没生成**，耗时仅 4 ms（不像真在渲染）。两个最可能的原因：
   - **`PostscriptDriver` 没设**：官方 `capPdfUtil::setPdfGenerationOptions` 里**总是**先 `CapPdfSetOption "PostscriptDriver"`（ini `capPDFDriver` 优先，否则默认 `"Acrobat Distiller"`），而脚本第一版只在显式 `--driver` 时才设；
   - **PS→PDF 转换器缺失**：官方代码里有 `mPSToPDFConverterCommand` / `capPDFCommand$index` 这一层——说明它先把页面打成 PostScript，再调用外部转换器生成 PDF。机器上没有 Ghostscript/Acrobat 命令行时，"打印成功"只意味着 PS 阶段没报错。
3. `capIsPrinterDriverAvailable` 在真机上**返回空串**，不能当布尔用。

脚本已按这两条改进：**总是设置 `PostscriptDriver`**（含 ini 回退），打印后**列出输出目录内容**（看是否只生成了 `.ps`），并在 `--dry-run` 时打印一段诊断（ini 键、驱动可用性、`gswin64c/ps2ps/ps2pdf` 是否存在、目录内容）。用同一命令重跑即可定位是"驱动没设"还是"转换器缺失"。

### 7.1 复跑诊断：原因锁定在"少了编排层"

第二次真机运行（带诊断）拿到关键三行：

```text
set PostscriptDriver = OrCADPS_17.4 (readback: OrCADPS_17.4)
ini capPDFDriver = «OrCADPS_17.4»
ini capPDFCommand2 = «{gswin64c.exe} -sDEVICE=pdfwrite -sOutputFile=$::capPdfUtil::mPdfFilePath -dBATCH -dNOPAUSE $::capPdfUtil::mPSFilePath»
CapPdfPrint code=0 ret=  elapsed=2ms      ← 仍然不出文件
```

驱动是设好的、Ghostscript 的转换命令也在 ini 里，**问题不在驱动也不在转换器本身**，而在调用层次：

读 `capPdfUtil.tcl` 可见完整链路：

```text
::capPdfUtil::printPdf {outDir outFile {removeTemp 1}}
  ├─ ::capPdfUtil::setOptionValues      ;# 初始化 mPSToPDFConverterCommand、返回 0 则中止
  ├─ set ::capPdfUtil::mOutDir / mOutFile
  ├─ ::capPdfUtil::setPdfGenerationOptions   ;# 从 ini 读驱动/InstMode/书签，逐个 CapPdfSetOption
  ├─ CapPdfPrint $outDir $outFile            ;# 打印到 PostScript
  └─ ::capPdfUtil::printPdfFromPS …          ;# exec $mPSToPDFConverterCommand 把 .ps → .pdf
```

**裸调 `CapPdfPrint` 只走到第 4 步**：`mPdfFilePath` / `mPSFilePath` / `mPSToPDFConverterCommand` 都还没初始化，于是它 2 ms 返回、什么都不生成——这正是那两次"code=0 但没文件"的原因。

正确用法（脚本已改）：

```tcl
package require capPdfUtil                      ;# 编排层在 capPDFExport/tcl 里
# 想控制选项就先写 ini（setPdfGenerationOptions 是从 ini 读的）
SetOptionString capPDFPaperSize 9               ;# A4
SetOptionString capPDFDriver    "OrCADPS_17.4"
SetOptionString capPDFCreateNetAndBookmark 1
::capPdfUtil::printPdf $outDir $outFile         ;# 初始化 → 打印 → PS→PDF → 打开
```

两条附加事实：

- `capIsPrinterDriverAvailable` **要带驱动名**：官方 `OrHandlerPDFExport::checkPrinterDriver` 是 `capIsPrinterDriverAvailable $pPrinterDriver`，用它做 1/0 判断。之前无参调用得到空串，是**用法错**，不能据此说"驱动不可用"；
- ini 的转换命令是**一段可 `eval exec` 的 Tcl 串**，里面直接引用 `$::capPdfUtil::mPdfFilePath` 与 `$::capPdfUtil::mPSFilePath`——也就是说这两个变量由编排层在调用前填好，单独调 `CapPdfPrint` 就永远为空。

### 7.2 走编排层之后：PS 出来 0 字节

第三次真机运行（改用 `::capPdfUtil::printPdf`）：

```text
using official orchestrator: ::capPdfUtil::printPdf
printPdf code=0 ret=
outDir now has: CapOutput.ps (0 B)
file NOT created: D:/tmp/pdf-out/test.pdf
```

也就是说**编排层走通了、但打印阶段产出空 PostScript**（0 字节），后续 GS 转换自然没有输入。官方面板在调 `printPdf` 之前有三个前置检查，正是针对这种"静默出空文件"的场景：

| 官方检查 | 判据 |
| --- | --- |
| `OrHandlerPDFExport::checkPrinterDriver $driver` | `capIsPrinterDriverAvailable <驱动名>` == 1 |
| `OrHandlerPDFExport::checkWritableOutDir $dir` | `file writable` |
| `OrHandlerPDFExport::checkToolPath $cmd` | `auto_execok [lindex $cmd 0]` 非空 |

三者任一不满足，面板会弹消息框并**直接 return**，不会去调 `printPdf`。

脚本已按这三条改造：打印前打印 `driver «X» available = «0/1»`、`converter exe «gswin64c.exe» found = «path»`，并在驱动不可用时明确提示"会产出 0 字节 PS"。这样下一次运行就能一句话判断是"虚拟打印机没装/没注册"还是"Ghostscript 不在 PATH"。

## 8. 未验证的点

| 项 | 状态 |
| --- | --- |
| `CapPdfAddMarkStart` 第 6 参的语义 | **已由 18 个官方调用点解出**（§8.1）：第 5 参是"标识或形状名"，第 6 参 0/1 分工明确。具体枚举名仍未知，但用法可照抄 |

### 8.1 `CapPdfAddMarkStart` 的 18 个官方调用点（全部来自 `capPdfUtil.tcl`）

| 行号 | 所在 annotate proc | 第 5 参 | 第 6 参 |
| --- | --- | --- | --- |
| 680 | `annotateAlias` | `[sGetConstCharPtr $lName]`（网络别名文本） | **0** |
| 764 / 769 | `annotateWire` | `$lID`（含 `" (Wire ID = N )"` 的拼接串） | **0** |
| 826 | `annotateGlobal` | 名字 | **0** |
| 890 | `annotatePort` | `$lID` | **0** |
| 959 | `annotateOffPageConnector` | `$lID` | **0** |
| 1027 | `annotateTitleBlock` | `$lID` | **0** |
| 1075 | `annotateERCS` | 名字 | **0** |
| 1154 | `annotateBusEntry` | `$lID` | **0** |
| 1236 | `annotatePart` | `$lID` | **0** |
| 1274 | `annotateGraphicBoxInst` | `"Rectangle"` | **0** |
| 1310 | `annotateGraphicLineInst` | `"Line"` | **1** |
| 1347 | `annotateGraphicEllipseInst` | `"Ellipse"` | **1** |
| 1384 | `annotateGraphicArcInst` | `"Arc"` | **1** |
| 1421 | `annotateGraphicPolylineInst` | `"Polyline"` | **1** |
| 1459 | `annotateGraphicPolygonInst` | `"Polygon"` | **1** |
| 1501 | `annotateGraphicCommentTextInst` | `[sGetConstCharPtr $lTxt]` | **0** |
| 1541 | `annotateGraphicBitMapInst` | `"Bitmap"` | **1** |

规律（`[推断]`，与全部 18 条一致）：

- **第 5 参**：文本/属性类标注传"标识字符串"（别名名、`ID`、`"... (Wire ID = N )"`、注释文本）；图形类标注传**形状名**（`"Rectangle"`/`"Line"`/`"Ellipse"`/`"Arc"`/`"Polyline"`/`"Polygon"`/`"Bitmap"`）。
- **第 6 参**：**0 = 用包围盒矩形即可**（文本、属性、别名、导线、端口、页间连接符、标题栏、ERC、总线入口、器件、`Rectangle`、注释文本）；**1 = 标注要按第 5 参给出的形状绘制**（`Line`/`Ellipse`/`Arc`/`Polyline`/`Polygon`/`Bitmap`）。`Rectangle` 传 0 是自洽的——盒子的形状本来就等于它的包围盒。

实践含义：**做纯矩形热区（可点/可搜索）用 `0`；要让 PDF 里的标注呈现真实轮廓，用 `1` 并在第 5 参给形状名。**
| ~~`PaperSize` 索引范围~~ | **已解决**：0..69 共 70 项，见 2.1；默认 0 |
| ~~`PostscriptDriver` 取值~~ | **部分解决**：默认值是 `"Acrobat Distiller"`；ini 键 `capPDFDriver` / `capPDFPrintingMode` 存的是驱动名/模式字符串 |
| `CreatePropertiesPdfFile` 生成的文件名规则 | 未测 |
| 零参/少参调用的报错形态 | 已给 `export-host-commands.tcl` 加 `--probe-pdf`，跑一次即可补齐 |

另外确认过：安装目录里的 `OrCAD_Capture_TclTk_Extensions.pdf`（5.3 MB）**不含** `CapPdf*` 文档——把 1089 个 PDF 流全部解压后搜 `CapPdf`/`AddMarkStart`/`PaperSize` 均为 0 命中。所以这些签名只能靠调用点与探测恢复，官方没有公开文档。

## 6. 自测建议

1. 先 `capIsPrinterDriverAvailable`，不可用就别往下走；
2. `CapPdfSetOption` 全部用字符串字面量（`"True"` 而不是 `True`），与官方一致；
3. `CapPdfPrint` 用 `catch` 判成败，并**回读 `file exists`**——返回值不等于文件存在；
4. 标注只在"确实要 PDF 里可搜索/可点"时才加，`AddMarkStart` 缺 `AddMarkEnd` 会导致后续标注串在一起。
