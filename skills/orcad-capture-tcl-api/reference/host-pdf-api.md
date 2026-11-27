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

> 六个签名现在全部来自**真机零参探测**（参数名由宿主报出），不是从调用点猜的。第 6 参的名字是 `pAttributeMarkType`——**它是"标注类型"，不是布尔**；官方 18 处调用一律传 `0`（默认类型）。

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

面板把用户上次的选择存在 Capture 偏好里，键名与选项的对应关系：

| 偏好键 | 对应 |
| --- | --- |
| `capPDFCreatePropertiesFile` | `CreatePropertiesPdfFile` |
| `capPDFCreateNetAndBookmark` | `CreateRefdesBookMarks` / `CreateNetBookMarks` |
| `capPDFPaperSize` | `PaperSize`（存的就是索引） |
| `capPDFDriver` | `PostscriptDriver` |
| `capPDFPrintingMode` | 打印模式（面板/驱动选择） |

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

## 8. 未验证的点

| 项 | 状态 |
| --- | --- |
| `CapPdfAddMarkStart` 第 6 参的语义 | 官方 18 处调用**全部传 `0`**；第 5 参是自由文本标识（有一处传的是 `"… (Wire ID = 123 )"` 这种拼接串）。含义仍未定 |
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
