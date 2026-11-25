# skills/ — 本地 Agent Skills

`orcad-capture-tcl-api/` 是标准的 **Agent Skills** 目录（`SKILL.md` + `reference/` + `scripts/` + `examples/`），
VS Code 里的 GitHub Copilot 原生支持这个格式，不需要任何转换或扩展，只要放对位置。

## 一键安装

```powershell
# 装到当前仓库（推荐，团队共享）：.github/skills / .claude/skills / .agents/skills
powershell -NoProfile -ExecutionPolicy Bypass -File .\skills\install-vscode-skill.ps1

# 装到用户目录（跨仓库可用）：%USERPROFILE%\.copilot\skills / .claude\skills / .agents\skills
powershell -NoProfile -ExecutionPolicy Bypass -File .\skills\install-vscode-skill.ps1 -Scope User

# 只要 Copilot 一家；或改成物理拷贝（便于提交/分发）
... .\install-vscode-skill.ps1 -Harn copilot
... .\install-vscode-skill.ps1 -Mode Copy
```

默认用**目录联接（junction）**指向 `skills/orcad-capture-tcl-api`：一份源文件、多处可见，改源即生效。
`-Mode Copy` 才做物理复制。脚本会先校验 frontmatter（`name` 必须等于目录名、`description` ≤1024 字符），再安装并回校文件数。

> 为什么需要 `-ExecutionPolicy Bypass`：多数机器默认 `Restricted`，直接 `.\xxx.ps1` 会被拦。
> 只想永久放行本机脚本：`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`。

## 各 harness 的识别位置

VS Code 的 Copilot / Claude / Codex 走 Agent Skills 标准目录；**DSH（DeepSeek Harness）另有自己的根，且带优先级**。

| Harness | 项目内 | 用户级 |
| --- | --- | --- |
| **DSH（rank 100 / 400）** | `<项目根>/.dsh/skills/<name>/` | `<dshHome>/skills/<name>/`（默认 `~/.dsh/skills`，`$DSH_HOME` 可覆盖） |
| DSH（rank 200 / 500，与其它工具共用） | `<项目根>/.agents/skills/<name>/` | `<agentsHome>/skills/<name>/`（默认 `~/.agents/skills`） |
| GitHub Copilot | `.github/skills/<name>/` | `~/.copilot/skills/<name>/` |
| Claude / Claude Code | `.claude/skills/<name>/` | `~/.claude/skills/<name>/` |
| Codex / 通用 | `.agents/skills/<name>/` | `~/.agents/skills/<name>/` |

DSH 的根按 rank 从小到大命中（同名的 skill 取 rank 小的那份）：`100 项目 .dsh` → `200 项目 .agents` →
`300 Config.customSkillDirs` → `400 用户 .dsh` → `500 用户 .agents`。项目根 = 最近的含 `.git` 的祖先目录，
没有 `.git` 时就是当前工作目录；DSH 的发现器支持目录联接/符号链接（本脚本默认就用联接）。
不想安装到固定位置，也可以在 DSH 的 `dsh-skill-filesystem` 配置里用 `customSkillDirs` 直接指到本目录。

安装后的本文档目录会长这样：

```text
.github/skills/orcad-capture-tcl-api  →（junction）→ skills/orcad-capture-tcl-api
.claude/skills/orcad-capture-tcl-api  →（junction）→ 同上
.agents/skills/orcad-capture-tcl-api  →（junction）→ 同上
.dsh/skills/orcad-capture-tcl-api     →（junction）→ 同上     ← DSH 最高优先级
```

## 验证与使用

1. VS Code 里 `Ctrl+Shift+P` → **Developer: Reload Window**（新装的 skill 需要重载窗口才被发现）。
2. Chat 输入 `/`，列表里应出现 `orcad-capture-tcl-api`；点它可当命令用：
   `/orcad-capture-tcl-api 帮我写个批量改 PCB Footprint 的 Capture 插件`
3. 不点名也行：description 里写清了触发场景，说"给 Capture 8.4 写个 Tcl 插件"就会自动加载。
4. 排错：命令面板 → **Chat: Open Customizations** → **Skills**，确认它被列出、来源路径正确。
   看不到时优先检查：工作区根目录是否是本仓库（项目级 skill 只从工作区根往下找）、以及 `name` 与目录名是否一致（不一致会静默不加载）。

## 卸载

```powershell
# 只删联接，不碰源文件
foreach ($d in '.github\skills','.claude\skills','.agents\skills') {
    Remove-Item -LiteralPath (Join-Path $PWD "$d\orcad-capture-tcl-api") -Force -ErrorAction SilentlyContinue
}
foreach ($d in '.copilot\skills','.claude\skills','.agents\skills') {
    Remove-Item -LiteralPath (Join-Path $HOME "$d\orcad-capture-tcl-api") -Force -ErrorAction SilentlyContinue
}
```

## 注意

- 本仓库当前没有 `.git`。若以后建仓，junction 会被 git 当作实体目录收录，建议把 `.github/skills/orcad-capture-tcl-api/`、`.claude/skills/orcad-capture-tcl-api/`、`.agents/skills/orcad-capture-tcl-api/` 写进 `.gitignore`，只提交 `skills/orcad-capture-tcl-api/` 这一份源；或者改用 `-Mode Copy` 后按需提交。
- `SKILL.md` 里的资源引用用的是相对 Markdown 链接（`[signatures.md](reference/signatures.md)`），这是 Agent Skills 的规范写法，Copilot 会按需加载被引用的文件；用反引号写路径不会被自动读入。
- 这个 skill 的正文是中文，frontmatter 的 `description` 是英文——description 决定"是否加载"，正文决定"加载后怎么干"，两者都可以按你的习惯改。
