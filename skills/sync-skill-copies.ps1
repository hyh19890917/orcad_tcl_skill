<#
.SYNOPSIS
    把 skills\orcad-capture-tcl-api 同步到指定的物理副本目录，并逐个文件校验哈希。

.DESCRIPTION
    skill 有一份权威源（本目录下的 orcad-capture-tcl-api），其它地方有两种存在形式：
      * 联接（junction）：自动跟随源，无需同步，只需校验；
      * 物理副本（例如要提交到 git 的仓库目录）：必须显式镜像。
    本脚本做后者，并把校验结果打出来（缺文件 / 多文件 / 哈希不一致）。

.PARAMETER Target
    目标目录（会被镜像成与源一致）。默认同步到 ..\OrCAD_TCL_Skill\skills\orcad-capture-tcl-api。

.PARAMETER SkipVerifyJunctions
    跳过对 6 个已安装联接位置的校验。

.EXAMPLE
    .\sync-skill-copies.ps1
    .\sync-skill-copies.ps1 -Target D:\backup\skl\orcad-capture-tcl-api
#>
[CmdletBinding()]
param(
    [string[]]$Target = @(),
    [switch]$SkipVerifyJunctions
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
if ($Target.Count -eq 0) { $Target = @((Join-Path (Split-Path $repoRoot -Parent) 'OrCAD_TCL_Skill\skills\orcad-capture-tcl-api')) }
$source = Join-Path $PSScriptRoot 'orcad-capture-tcl-api'
if (!(Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) { throw "源不存在：$source\SKILL.md" }

function Get-Tree { param($root)
    $map = @{}
    Get-ChildItem -LiteralPath $root -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($root.Length).TrimStart('\')
        $map[$rel] = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
    return $map
}

$srcTree = Get-Tree $source
Write-Host ("[src] {0}  ({1} 个文件)" -f $source, $srcTree.Count) -ForegroundColor Cyan

foreach ($dest in $Target) {
    Write-Host ""
    Write-Host "[sync] $dest" -ForegroundColor Yellow

    if (Test-Path -LiteralPath $dest) {
        $item = Get-Item -LiteralPath $dest -Force
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
            throw "目标是联接，不是物理副本：$dest（联接无需同步，删掉它再用脚本安装）"
        }
    } else {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
    }

    # 镜像：先删目标里源没有的文件，再复制/覆盖
    $dstTree = Get-Tree $dest
    foreach ($rel in $dstTree.Keys) {
        if (!$srcTree.ContainsKey($rel)) {
            Remove-Item -LiteralPath (Join-Path $dest $rel) -Force
            Write-Host "  [del] $rel"
        }
    }
    foreach ($rel in $srcTree.Keys) {
        $from = Join-Path $source $rel
        $to = Join-Path $dest $rel
        $dir = Split-Path $to -Parent
        if (!(Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        $needCopy = $true
        if ($dstTree.ContainsKey($rel) -and $dstTree[$rel] -eq $srcTree[$rel]) { $needCopy = $false }
        if ($needCopy) {
            Copy-Item -LiteralPath $from -Destination $to -Force
            Write-Host "  [put] $rel"
        }
    }

    # 校验
    $after = Get-Tree $dest
    $missing = @($srcTree.Keys | Where-Object { !$after.ContainsKey($_) })
    $extra   = @($after.Keys   | Where-Object { !$srcTree.ContainsKey($_) })
    $diff    = @($srcTree.Keys | Where-Object { $after.ContainsKey($_) -and $after[$_] -ne $srcTree[$_] })
    if ($missing.Count + $extra.Count + $diff.Count -eq 0) {
        Write-Host ("  [ok ] 与源一致：{0} 个文件，SHA256 全匹配" -f $after.Count) -ForegroundColor Green
    } else {
        Write-Host ("  [BAD] missing={0} extra={1} hash-diff={2}" -f $missing.Count, $extra.Count, $diff.Count) -ForegroundColor Red
        $missing + $extra + $diff | ForEach-Object { Write-Host "    $_" }
        exit 1
    }
}

if (!$SkipVerifyJunctions) {
    Write-Host ""
    Write-Host "[verify] 已安装的联接位置（应全部指向同一份源）" -ForegroundColor Yellow
    $srcSkill = (Resolve-Path -LiteralPath (Join-Path $source 'SKILL.md')).Path
    $srcHash = (Get-FileHash -LiteralPath $srcSkill -Algorithm SHA256).Hash
    $dshHome = if ($env:DSH_HOME) { $env:DSH_HOME } else { Join-Path ([Environment]::GetFolderPath('UserProfile')) '.dsh' }
    $links = @(
        (Join-Path (Split-Path $PSScriptRoot -Parent) '.dsh\skills\orcad-capture-tcl-api'),
        (Join-Path (Split-Path $PSScriptRoot -Parent) '.github\skills\orcad-capture-tcl-api'),
        (Join-Path (Split-Path $PSScriptRoot -Parent) '.claude\skills\orcad-capture-tcl-api'),
        (Join-Path (Split-Path $PSScriptRoot -Parent) '.agents\skills\orcad-capture-tcl-api'),
        (Join-Path $dshHome 'skills\orcad-capture-tcl-api'),
        (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.dsh\skills\orcad-capture-tcl-api'),
        (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.copilot\skills\orcad-capture-tcl-api'),
        (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.claude\skills\orcad-capture-tcl-api'),
        (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.agents\skills\orcad-capture-tcl-api')
    )
    $bad = 0
    foreach ($l in $links) {
        if (!(Test-Path -LiteralPath $l)) { Write-Host "  [--] 未安装：$l" -ForegroundColor DarkGray; continue }
        $h = (Get-FileHash -LiteralPath (Join-Path $l 'SKILL.md') -Algorithm SHA256).Hash
        $item = Get-Item -LiteralPath $l -Force
        $isLink = (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        if ($h -eq $srcHash) { Write-Host "  [ok] $l  (link=$isLink)" -ForegroundColor Green }
        else { Write-Host "  [BAD] 内容不是最新：$l" -ForegroundColor Red; $bad++ }
    }
    if ($bad) { exit 1 }
}
