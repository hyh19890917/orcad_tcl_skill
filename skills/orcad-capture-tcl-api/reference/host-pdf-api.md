# PDF 打印与标注：`CapPdf*` 六个命令（从调用点恢复的签名）

Capture 17.4 的 PDF 能力分两层：**宿主命令 `CapPdf*`（真正干活）** 与 **脚本层 `capPdfUtil` / `capPDFExport`（准备数据 + 面板）**。之前几轮只看到脚本层，这轮把命令层的签名和选项表从官方调用点里挖出来了。

## 1. 六个命令

| 命令 | 参数的来源 | 形态 |
| --- | --- | --- |
| `CapPdfSetOption` | `CapPdfSetOption "InstMode" $value` | 选项名（字符串）+ 值 |
| `CapPdfGetOption` | `if {[CapPdfGetOption InstMode] == "True"}` | 选项名 → 返回字符串（注意 `InstMode` 这里**不带引号**，两种写法都行） |
| `CapPdfPrint` | `capPdfPrint $mOutDir $mOutFile`（官方 `catch` 包裹） | 输出目录 + 文件名 |
| `CapPdfAddMarkStart` | `CapPdfAddMarkStart x1 y1 x2 y2 <idOrName> 0` | 包围盒两角点 + 标识 + 一个标志位（官方恒传 0） |
| `CapPdfAddMarkData` | `CapPdfAddMarkData <name> <value>` | 一条键值对（标注内容） |
| `CapPdfAddMarkEnd` | `CapPdfAddMarkEnd` | 无参，闭合当前标注 |

## 2. 选项表（从 `CapPdfSetOption` 的调用点归纳）

| 选项 | 取值 | 说明 |
| --- | --- | --- |
| `InstMode` | `"True"` / `"False"` | 实例模式（官方据此设 `mIsInstMode`） |
| `CreateNetBookMarks` | `"True"` / `"False"` | 为网络生成书签 |
| `CreateRefdesBookMarks` | `"True"` / `"False"` | 为位号生成书签 |
| `CreatePropertiesPdfFile` | `"True"` / `"False"` | 附带属性 PDF |
| `LandscapeOrientation` | `"True"` / `"False"` | 横向 |
| `PaperSize` | 索引值（`$::capPdfUtil::mPaperSizeListIndex`） | 纸张，**传的是列表索引不是名字** |
| `PostscriptDriver` | 驱动名字符串 | 打印驱动；官方从 ini 读 `capPDFPrintingMode` 兜底 |

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

## 5. 未验证的点

| 项 | 状态 |
| --- | --- |
| `CapPdfAddMarkStart` 第 6 参的语义 | 官方恒传 `0`，含义未知（推测为"标注类型/是否链接"） |
| `PaperSize` 索引范围与对应纸张名 | 官方从 `mPaperSizeListIndex` 取，列表本身在面板 JS 里，未提取 |
| `PostscriptDriver` 与 ini `capPDFPrintingMode` 的映射 | 只看到"ini 值直接当驱动名传"，具体取值未列 |
| `CreatePropertiesPdfFile` 生成的文件名规则 | 未测 |
| 零参/少参调用的报错形态 | 这轮没做 arity 探测（v2 默认白名单不含 `CapPdf*`），可在下次导出时加 `--probe-pdf` 补一版 |

## 6. 自测建议

1. 先 `capIsPrinterDriverAvailable`，不可用就别往下走；
2. `CapPdfSetOption` 全部用字符串字面量（`"True"` 而不是 `True`），与官方一致；
3. `CapPdfPrint` 用 `catch` 判成败，并**回读 `file exists`**——返回值不等于文件存在；
4. 标注只在"确实要 PDF 里可搜索/可点"时才加，`AddMarkStart` 缺 `AddMarkEnd` 会导致后续标注串在一起。
