# 自己挖 API 空白：两条可复现的探测手法

签名表里有一批命令是"重载未暴露"（`No matching function for overloaded`），另有 `DboState` 的错误语义从没文档过。这两块都能用**构造性探测**补上，不需要反编译。

## 1. 手法 A：用类型错误文本读参数

给命令传"真实对象 + 空串"，宿主在类型检查阶段就会报：

```text
% DboLib_GetPackage $lib "" ""
TypeError in method 'DboLib_GetPackage', argument 2 of type 'CString &'
```

于是 **参数位置与类型直接读出来**（arg1 = self，arg2 = CString&，arity = 3）。实测样本：

| 命令 | 探测结果 |
| --- | --- |
| `DboLib_GetPackage $lib "" ""` | `argument 2 of type 'CString &'` → (self, name, status) |
| `DboLib_NewPackage $lib "" ""` | 同上 |
| `DboSymbolPin_GetPinName $pin ""` | `argument 1 of type 'DboSymbolPin *'` → arity 2 |
| `DboPackage_GetPCBFootprint $pkg ""` | `argument 1 of type 'DboPackage *'` → arity 2 |

**更有用的一种**：如果传入的 self 恰好匹配该命令声明的类，错误文本会直接列出**完整参数名**：

```text
% DboBaseObject_NewDisplayProp <不是该类的对象> ...
Wrong number of arguments :DboBaseObject_NewDisplayProp self status CString ... 
```

这和零参调用得到的是同一类信息，但能覆盖"零参时报 overloaded"的那批命令。

**限制**：真正的 C++ 重载（同名多签名）在参数类型不匹配时统一报 `No matching function for overloaded 'X'`，**拿不到参数表**——只能靠官方脚本里的调用点反推（例如 `NewSymbolPinScalar` 的实例用法是 `(status, name, type, startPoint, hotPoint, 1, number)`）。

## 2. 手法 B：先建一个临时对象，再拿它当 self

重载方法常常"参数类型对了才告诉你下一步"，所以先用 `DboTclHelper_sCreateSession` + `CreateLib` 造一个库，把它当第一个参数喂进去，再逐级补空串，能一层层逼近真实签名：

```tcl
set sess [DboTclHelper_sCreateSession]
set st   [DboState]
set lib  [$sess CreateLib [DboTclHelper_sMakeCString $tmpOlb 0] $st]
foreach c {DboLib_GetPackage DboLib_NewPackage DboSymbolPin_GetPinName} {
    for {set n 2} {$n <= 6} {incr n} {
        set args [list $lib]; for {set k 1} {$k < $n} {incr k} { lappend args "" }
        catch {uplevel #0 [list $c {*}$args]} r
        if {[regexp {argument (\d+) of type '([^']+)'} $r -> pos typ]} { puts "$c arg$pos: $typ"; break }
    }
}
```

成本：每条命令 5 次调用；全程只在一个临时 OLB 上操作，跑完删除。

## 3. `DboState` 到底怎么报错（实测）

| 观察 | 说明 |
| --- | --- |
| `$st Message` 带参数才合法（`self,msg`） | **`Message` 是 setter，不是 getter**；读消息用 `GetExtendedText` |
| `$st GetExtendedText` 返回 **CString 指针** | 要 `DboTclHelper_sGetConstCharPtr`，不是直接字符串 |
| `$st Code` / `$st Severity` 在失败路径常常是 **0** | 不能用它们判成功/失败 |
| 失败有时**抛异常**而非置状态 | 例：`$design GetPage "NOPE" $st` → Tcl `catch` 返回 1，而 `$st` 仍 `Code=0` |

所以判失败要三条一起看：`[$st Failed]`、调用是否抛错、以及**业务结果本身**（返回对象是否为 `NULL`、回读值是否等于期望）。这也是为什么"读回校验"比"看返回值"可靠——`SaveLib` 会返回 OK 但什么都不写，就是最典型的例子。

## 4. 建议的探测顺序

1. 先跑零参：拿到 `Wrong number of arguments :cmd self a b c`（参数名最全）；
2. 零参报 `No matching function` 的，用"真实对象 + 空串"拿 `argument N of type`；
3. 还是拿不到的（真重载），去官方 tcl 脚本里找调用点，用实例反推；
4. 把三次结果合并进签名表，并标注来源（`arity` / `types` / `usage`），别把推断写成实测。

## 5. 为什么有些 API 只能在 Capture 进程里探（而不能像 Dbo 那样离线跑）

两条注册路径决定了一切：

| 面 | 注册者 | 能否在普通 `tclsh` 里出现 |
| --- | --- | --- |
| Dbo 面（6,112 条） | `orDb_Dll_Tcl64.dll`，可 `load` | **能**——`load` 完命令就在，零参一调就报参数名，3,941 条签名就是这么来的 |
| 宿主面（约 3,700 条） | `Capture.exe` 启动时注入 Tcl 解释器 | **不能**——`info commands RegisterAction` 在 headless 是 0 |

由此得出三条硬约束：

1. **参数名只存在于"调用失败的错误文本"里**。没有头文件、没有公开文档（5.3 MB 的 `OrCAD_Capture_TclTk_Extensions.pdf` 里 `CapPdf`/`AddMarkStart` 零命中），所以必须**能真正调用**才有信息。
2. **二进制里只有命令名，没有参数名**。`Capture.exe` 能捞到 9,830 个名字（所以有清单），但 SWIG 风格的参数绑定是代码不是字符串表。
3. **官方脚本只能救有调用点的那部分**。`CNewBOm`/`CVariant`/`CDiff*`/`orExprEval` 在 `tclscripts` 里 0 命中——没有调用点就没有形态可抄。

`Capture.exe` 本身没有公开的批处理开关（strings 里 `tcl`/`batch`/`console`/`nogui` 均 0 命中），所以宿主面探测只能借一次真实会话。

## 6. 旁路：`tools\bin` 里的 CLI 转换器（可省掉一部分 GUI 依赖）

同一目录下有一批**控制台程序**（无参运行会打印 `No Product License selected... Translation cancelled.`，说明它们不是 GUI）：

| 程序 | 用途 |
| --- | --- |
| `cap2xml.exe` / `xml2cap.exe` | 设计 ↔ XML（对应宿主 `DBXMLWriter` 家族） |
| `cap2con.exe` / `con2cap.exe` | 设计 ↔ Concept |
| `sch2cap.exe` | 转换工具（**无参会挂住等输入**，别裸跑） |

有 license 的环境里，`cap2xml` 可以**无 GUI**产出 XML —— 也就是说 `DBXMLWriter` 那 148 条命令的"输出长什么样"可以离线研究（拿 XML 反推结构），不必开 Capture。但 `CNewBOm`/`CVariant`/`CDiff*` 这类**纯进程内对象操作**没有 CLI 等价物，仍然只能在会话里探。
