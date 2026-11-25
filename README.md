# orcad_tcl_skill

> OrCAD Capture / Cadence SPB 的 **Tcl 开发手册**，以 [Agent Skill](https://agentskills.io) 形式发布。
> 装进 VS Code Copilot / Claude Code / Codex / **DSH（DeepSeek Harness）** 后，AI 写 Capture 插件时就不再瞎猜 API 了。

![license](https://img.shields.io/badge/license-MIT-blue)
![targets](https://img.shields.io/badge/Capture-16.6%20%7C%2017.2%20%7C%2017.4%20%7C%2022.1%2B-brightgreen)

## 这是什么

Cadence 没有公开的 Capture Tcl API 参考手册（Dbo API 只在安装目录的 DLL 里，函数签名得靠猜）。这个仓库解决的就是这件事：

- **API 面是实测导出来的**，不是凭记忆写的：装一个 Cadence，`load orDb_Dll_Tcl*.dll` 进 tclsh，`info commands` 就是官方命令表；
  再把每条命令零参调用一次，宿主自己会把完整参数表打进错误信息（`Wrong number of arguments :DboLib_GetPackage self name status`），
  于是 **3941 条命令的参数名 + C++ 类型**全拿到了。
- 覆盖 **对象模型、属性三套语义、迭代器协议、指针编组、宿主命令（菜单/控制条/放置）、`executeTcl` 网页面板桥、headless 的 XML⇄OLB 转换**。
- 附了 4 个能直接跑的脚本（探针 / 安全写属性 / 批量 OLB 索引 / 插件骨架），全部在 Tcl 8.4 与 8.6 下验证过。

## 支持版本

| Capture | Tcl | Dbo DLL | 命令数 | 状态 |
| --- | --- | --- | --- | --- |
| 16.6 | 8.4.15 (x86) | `tools\capture\orDb_Dll_Tcl.dll` | 4962 | 实测导出 |
| 17.2 | 8.6.0 (x64) | `tools\bin\orDb_Dll_Tcl64.dll` | 6022 | 实测导出 |
| 17.4 | 8.6.5 (x64) | `tools\bin\orDb_Dll_Tcl64.dll` | 6109 | 实测导出（签名表基于此版本） |
| 22.1 / 23.1 / 24.1 / 25.1 / 26.1 | 8.6.x | 同上 | — | 代码按兼容层写，但**没有实测**；用 `scripts/` 里的脚本可自行导出 |

## 安装

Agent Skills 是开放标准：VS Code 里的 Copilot、Claude Code、Codex，以及 **DSH（DeepSeek Harness）** 都直接吃 `SKILL.md`，
不需要扩展或转换。区别只在"放在哪个目录"。

```powershell
git clone https://github.com/hyh19890917/orcad_tcl_skill
cd orcad_tcl_skill\skills

# 装到当前项目（DSH / Copilot / Claude / Codex 四处一起）
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-vscode-skill.ps1

# 装到用户目录（任意项目可用）
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-vscode-skill.ps1 -Scope User

# 只装某一处
... .\install-vscode-skill.ps1 -Harn dsh
```

脚本默认建**目录联接**指向 `skills\orcad-capture-tcl-api`（一份源、多处可见），`-Mode Copy` 才是物理拷贝。
Workspace 作用域装到**当前工作目录**，所以在你的项目目录里运行本脚本就装到那个项目；`-RepoRoot` 可显式指定。

也可以手工拷：把 `skills\orcad-capture-tcl-api` 整个目录放到下列任一位置。

| Harness | 项目内 | 用户级 |
| --- | --- | --- |
| **DSH（DeepSeek Harness）** | `<项目根>/.dsh/skills/orcad-capture-tcl-api/` | `~/.dsh/skills/orcad-capture-tcl-api/`（`$DSH_HOME` 可覆盖） |
| **DSH**（与其它工具共用的根） | `<项目根>/.agents/skills/orcad-capture-tcl-api/` | `~/.agents/skills/orcad-capture-tcl-api/`（`$DSH_AGENTS_HOME` 可覆盖） |
| GitHub Copilot | `.github/skills/orcad-capture-tcl-api/` | `~/.copilot/skills/orcad-capture-tcl-api/` |
| Claude / Claude Code | `.claude/skills/orcad-capture-tcl-api/` | `~/.claude/skills/orcad-capture-tcl-api/` |
| Codex / 通用 | `.agents/skills/orcad-capture-tcl-api/` | `~/.agents/skills/orcad-capture-tcl-api/` |

### DSH 的根有优先级

DSH 的 `dsh-skill-filesystem` 按 rank 从小到大扫，同名的 skill 取 rank 小的那份：

| rank | 来源 | 路径 |
| --- | --- | --- |
| 100 | project-dsh | `<项目根>/.dsh/skills` |
| 200 | project-agents | `<项目根>/.agents/skills` |
| 300 | custom | `Config.customSkillDirs` |
| 400 | user-dsh | `<dshHome>/skills`（默认 `~/.dsh/skills`） |
| 500 | user-agents | `<agentsHome>/skills`（默认 `~/.agents/skills`） |

项目根 = 最近的含 `.git` 的祖先目录；没有 `.git` 时就是当前工作目录。DSH 的发现器**支持目录联接/符号链接**
（本仓库的安装脚本默认就用联接），所以"一份源、多处可见"在 DSH 上同样成立。
如果不想往固定位置装，也可以在 DSH 的 `dsh-skill-filesystem` 配置里用 `customSkillDirs` 直接指向本仓库的
`skills/orcad-capture-tcl-api`（rank 300，优先于用户级）。

**验证（VS Code / Copilot）**：`Ctrl+Shift+P` → *Developer: Reload Window*，然后在 Chat 输入 `/`，应能看到 `orcad-capture-tcl-api`；
看不到时走 *Chat: Open Customizations → Skills* 确认（最常见原因是目录名与 frontmatter 的 `name` 不一致，会静默不加载）。

**验证（DSH）**：新开一个会话，技能列表里应出现 `orcad-capture-tcl-api`；直接说"给 Capture 写个 Tcl 插件"会按 description 自动加载。
会话中途新增 skill 需要新会话（或重载窗口）才可见。

## 怎么用

点名调用：

```text
/orcad-capture-tcl-api 给 Capture 17.4 写个批量改 PCB Footprint 的插件，要能回滚
```

或者直接说需求（description 里写了触发条件，会自动加载）：

```text
把这个 .olb 里的封装、管脚名、管脚号导成 TSV
为什么我的 $part NewLPinsIter 返回 NULL？
```

## 仓库结构

```text
orcad_tcl_skill/
├─ README.md                      ← 你正在看的
├─ LICENSE                        (MIT)
└─ skills/
   ├─ README.md                   安装/卸载/排错细节
   ├─ install-vscode-skill.ps1    安装器（frontmatter 校验 + junction/copy + 回校）
   ├─ sync-skill-copies.ps1       把 skill 镜像到物理副本并逐文件校验 SHA256
   └─ orcad-capture-tcl-api/      ← 真正的 skill
      ├─ SKILL.md                 主文件：路线选择 / 环境自检 / 调用形态 / 对象模型 / 属性 / 迭代器 / 编组 / 版本适配 / 14 条坑
      ├─ reference/
      │  ├─ signatures.md         3941 条命令的参数名与 C++ 类型（按类分组）
      │  ├─ signatures-17.4.csv   同上，机读
      │  ├─ dbo-classes.md        291 个类的成员总表
      │  ├─ iterators.md          127 个迭代器 → Next 方法 → delete 命令
      │  ├─ host-api.md           Capture 宿主命令（菜单/控制条/放置）+ executeTcl 桥
      │  ├─ marshalling.md        90 个 DboTclHelper_* 与指针所有权规则
      │  ├─ version-matrix.md     三版本实测对照与 API 增量
      │  └─ commands-{16.6,17.2,17.4}.txt  全量命令名（diff 用）
      ├─ scripts/
      │  ├─ dump-dbo-api.tcl        导出命令面
      │  ├─ dump-dbo-signatures.tcl 导出参数签名（零参调用法）
      │  ├─ probe-calling-form.tcl  验证调用形态/对象命名/类型码
      │  └─ debug-olb.tcl           单库诊断
      └─ examples/
         ├─ batch-olb-index.tcl     headless：OLB → TSV（Package/Symbol/Part/Pin）
         ├─ safe-edit-prop.tcl      批量改属性 + 回读校验 + 逆序回滚（8.4 兼容）
         ├─ probe-design.tcl        进程内：设计/页/实例/选中体检
         └─ plugin-skeleton.tcl     进程内：菜单 + 控制条 + executeTcl 白名单脚手架
```

## 30 秒上手：headless 导出 OLB 清单

```powershell
$root = 'D:\Cadence\Cadence\SPB_17.4'
$env:PATH = "$root\tools\bin;" + $env:PATH
& "$root\tools\bin\tclsh.exe" skills\orcad-capture-tcl-api\examples\batch-olb-index.tcl `
    "$root\tools\bin\orDb_Dll_Tcl64.dll" `
    'D:\Cadence\Cadence\SPB_16.6\tools\capture\library\Discrete.olb' `
    .\discrete.tsv
# packages=1200 symbols=0 -> .\discrete.tsv
```

想先确认环境对不对，只跑两行：

```powershell
$env:PATH = "$root\tools\bin;" + $env:PATH
'load D:/Cadence/Cadence/SPB_17.4/tools/bin/orDb_Dll_Tcl64.dll DboTclWriteBasic; puts [llength [info commands Dbo*]]; exit' |
  & "$root\tools\bin\tclsh.exe"
# 4185
```

## 两个最容易踩的坑（全文见 SKILL.md）

1. **全局命令只按"声明类"注册**：`DboBaseObject_GetName` 存在，`DboDesign_GetName` 不存在，但 `$design GetName $ptr` 照样能用。
   所以代码一律用**对象形态**调用，查表按声明类 grep。
2. **`tcl_platform(wordSize)` 在 Windows 恒为 4**，连 64 位 Tcl 8.6.17 也一样 —— 不能用它判断 DLL 位数，否则 64 位插件永远先试 32 位 DLL。

## 数据来源与可复现性

所有 `reference/` 表都由 `scripts/` 里的两个脚本从本机 Cadence 安装导出，原始输出（`commands-*.txt`、`signatures-*.tsv`）一并入库，
你可以换一个版本自己重跑并 diff：

```powershell
& $tclsh scripts\dump-dbo-api.tcl        $dboDll reference\commands-23.1.txt
& $tclsh scripts\dump-dbo-signatures.tcl $dboDll reference\signatures-23.1.tsv
```

本仓库**不包含** Cadence 的任何二进制、反编译产物或授权文件；只包含 API 名称、签名、行为描述，以及自行编写的 Tcl/PowerShell 代码。
Cadence、OrCAD 是 Cadence Design Systems 的商标，本项目与其无关。

## 已知限制

- `signatures.*` 只导出了 17.4；16.6 / 17.2 有命令面（`commands-*.txt`）但没有逐条签名。
- 22.1 及以上版本未实测（本机没有安装），版本差异请以 `version-matrix.md` 的适配清单为起点自行验证。
- `orPrm::*` 等宿主命令没有官方文档，`host-api.md` 里的参数形态来自真实调用点与实测，跨大版本时请用 `info commands` 做能力检测。

## 贡献

欢迎补新版本的数据：跑上面两条 `dump-*` 命令，把生成的 `commands-<ver>.txt` / `signatures-<ver>.tsv` 和 `version-matrix.md` 的对照行一起 PR。
新增示例请确保 **Tcl 8.4 与 8.6 都能 `source` 通过**（`skills/README.md` 里有检查方法）。

## License

[MIT](LICENSE) © 2026 hyh19890917
