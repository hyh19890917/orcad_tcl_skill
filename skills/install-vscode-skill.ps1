<#
.SYNOPSIS
    把 orcad-capture-tcl-api 这个 skill 安装到 VS Code / Copilot / Claude Code 的识别目录。

.DESCRIPTION
    Agent Skills 是"目录 + SKILL.md"的标准格式（agentskills.io），VS Code 里由 Copilot 消费。
    识别位置（按 harness）：
        Copilot      项目 .github/skills/<name>/   个人 ~/.copilot/skills/<name>/
        Claude       项目 .claude/skills/<name>/    个人 ~/.claude/skills/<name>/
        Codex        项目 .agents/skills/<name>/    个人 ~/.agents/skills/<name>/
    本脚本默认用目录联接（junction）指向 skills\<name>，保持"一份源文件、多处可见"，
    改一处全部生效；-Mode Copy 则做物理拷贝（便于提交到 git 或分发）。

.PARAMETER Scope
    Workspace（默认，装到当前仓库）| User（装到用户目录，跨仓库可用）

.PARAMETER Mode
    Junction（默认，零拷贝、自动跟随源）| Copy

.PARAMETER Harn
    all（默认）| copilot | claude | agents

.PARAMETER Force
    目标已存在时，仅当它是指向本源的 junction 才重建；真实目录一律不删。

.EXAMPLE
    .\install-vscode-skill.ps1
    # 装到 <repo>\.github\skills / .claude\skills / .agents\skills（junction）

.EXAMPLE
    .\install-vscode-skill.ps1 -Scope User -Harn copilot
    # 装到 %USERPROFILE%\.copilot\skills\orcad-capture-tcl-api
#>
[CmdletBinding()]
param(
    [ValidateSet('Workspace','User')][string]$Scope = 'Workspace',
    [ValidateSet('Junction','Copy')][string]$Mode = 'Junction',
    [ValidateSet('all','dsh','copilot','claude','agents')][string]$Harn = 'all',
    [string]$RepoRoot = '',
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$skillName = 'orcad-capture-tcl-api'
$source = Join-Path $PSScriptRoot $skillName

# Workspace 作用域装到哪个仓库：默认是"当前工作目录"（所以从你自己的项目里运行本脚本时，
# 装的就是你的项目）；显式 -RepoRoot 可覆盖。
$repoRoot = if ($RepoRoot) { [IO.Path]::GetFullPath($RepoRoot) } else { (Get-Location).Path }

# --- 1. 校验源 ---------------------------------------------------------------
if (!(Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
    throw "源 skill 不完整：缺少 $source\SKILL.md"
}
$skillFile = Join-Path $source 'SKILL.md'
$raw = [IO.File]::ReadAllText($skillFile, [Text.Encoding]::UTF8)
if ($raw -notmatch '(?s)^---\r?\n(.*?)\r?\n---') { throw 'SKILL.md 缺少 YAML frontmatter' }
$front = $Matches[1]
$name = if ($front -match '(?m)^name:\s*(\S+)\s*$') { $Matches[1] } else { '' }
$desc = if ($front -match '(?m)^description:\s*(.+)$') { $Matches[1].Trim() } else { '' }

if ($name -ne $skillName) {
    throw "frontmatter 的 name（$name）必须与目录名（$skillName）一致，否则 VS Code 会静默不加载"
}
if ($name -notmatch '^[a-z0-9-]{1,64}$') { throw "name 只能是小写字母/数字/连字符且 ≤64 字符：$name" }
if ($desc.Length -lt 20) { throw 'description 太短，Copilot 无法判断何时加载' }
if ($desc.Length -gt 1024) { throw "description 超过 1024 字符（当前 $($desc.Length)）" }

Write-Host "[ok] frontmatter 合法：name=$name, description=$($desc.Length) 字符" -ForegroundColor Green

# --- 2. 目标路径 -------------------------------------------------------------
# 各 harness 的 skills 根目录（项目级 / 用户级）。DSH = DeepSeek Harness：
#   项目 <root>/.dsh/skills (rank 100) > .agents/skills (rank 200)
#   用户 <dshHome>/skills  (rank 400) > <agentsHome>/skills (rank 500)
# dshHome = $DSH_HOME 或 ~/.dsh；agentsHome = $DSH_AGENTS_HOME 或 ~/.agents。
# 注意：$DSH_HOME 本身就是 home，不要再拼一层 .dsh（本脚本早期版本踩过这个坑）。
$harns = if ($Harn -eq 'all') { @('dsh','copilot','claude','agents') } else { @($Harn) }

$userProfile = [Environment]::GetFolderPath('UserProfile')
$dshHome    = if ($env:DSH_HOME)        { $env:DSH_HOME }        else { Join-Path $userProfile '.dsh' }
$agentsHome = if ($env:DSH_AGENTS_HOME) { $env:DSH_AGENTS_HOME } else { Join-Path $userProfile '.agents' }

$destinations = foreach ($h in $harns) {
    switch ($h) {
        'dsh' {
            if ($Scope -eq 'Workspace') { Join-Path $repoRoot '.dsh\skills' }
            else {
                # 主根：<dshHome>/skills；同时补一份文档默认的 ~/.dsh/skills（两者常同时存在）
                $main = Join-Path $dshHome 'skills'
                $fallback = Join-Path $userProfile '.dsh\skills'
                $main
                if ($fallback -ne $main) { $fallback }
            }
        }
        'copilot' {
            if ($Scope -eq 'Workspace') { Join-Path $repoRoot '.github\skills' } else { Join-Path $userProfile '.copilot\skills' }
        }
        'claude' {
            if ($Scope -eq 'Workspace') { Join-Path $repoRoot '.claude\skills' } else { Join-Path $userProfile '.claude\skills' }
        }
        'agents' {
            if ($Scope -eq 'Workspace') { Join-Path $repoRoot '.agents\skills' } else { Join-Path $agentsHome 'skills' }
        }
    }
}
$destinations = $destinations | Select-Object -Unique

# --- 3. 安装 -----------------------------------------------------------------
$installed = @()
foreach ($parent in $destinations) {
    $dest = Join-Path $parent $skillName
    if (!(Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }

    if (Test-Path -LiteralPath $dest) {
        $item = Get-Item -LiteralPath $dest -Force
        $isLink = ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
        $existingTarget = $null
        if ($isLink) {
            $t = $item.Target
            if ($t -is [array]) { $t = $t[0] }
            if ($t) { $existingTarget = [IO.Path]::GetFullPath($t).TrimEnd('\') }
        }
        $sourceFull = [IO.Path]::GetFullPath($source).TrimEnd('\')
        if ($existingTarget -and ($existingTarget -ieq $sourceFull)) {
            Write-Host "[skip] 已是指向源的联接：$dest"
            $installed += $dest
            continue
        }
        if (!$Force) {
            $why = if ($isLink) { "指向别处：$existingTarget" } else { '是真实目录（上次用 -Mode Copy 装的？）' }
            Write-Warning "[skip] 目标已存在，$why —— 未覆盖：$dest（确认后加 -Force）"
            continue
        }
        if (!$isLink) { throw "拒绝删除真实目录：$dest（请自行移走）" }
        cmd /c rmdir "$dest" | Out-Null      # 只删联接本身，不动源目录
    }

    if ($Mode -eq 'Junction') {
        New-Item -ItemType Junction -Path $dest -Target $source | Out-Null
        Write-Host "[add ] junction  $dest  ->  $source" -ForegroundColor Cyan
    } else {
        Copy-Item -LiteralPath $source -Destination $dest -Recurse -Force
        Write-Host "[add ] copy      $dest" -ForegroundColor Cyan
    }
    $installed += $dest
}

# --- 4. 验证 -----------------------------------------------------------------
foreach ($dest in $installed) {
    $check = Join-Path $dest 'SKILL.md'
    if (!(Test-Path -LiteralPath $check)) { throw "安装后校验失败：$check 不存在" }
    $files = (Get-ChildItem -LiteralPath $dest -Recurse -File | Measure-Object).Count
    Write-Host ("[ok ] {0}  ({1} 个文件)" -f $dest, $files) -ForegroundColor Green
}

Write-Host @"

下一步（VS Code）：
  1. 重新加载窗口：Ctrl+Shift+P → "Developer: Reload Window"
  2. 打开 Chat，输入 "/" 应能看到 $skillName；
     直接说"给 Capture 写个 Tcl 插件"也会按 description 自动触发。
  3. 看不到时：命令面板 → "Chat: Open Customizations" → Skills，确认它被列出；
     仍看不到就确认工作区根目录是 $repoRoot（skills 目录必须在工作区里或装在 User 作用域）。
"@ -ForegroundColor Yellow
