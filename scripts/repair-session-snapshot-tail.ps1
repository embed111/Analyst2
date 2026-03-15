param(
    [string]$SnapshotPath,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Get-HeadingSections {
    param(
        [string[]]$Lines,
        [string]$HeadingRegex
    )

    $indexes = New-Object System.Collections.Generic.List[int]
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i] -match $HeadingRegex) {
            $indexes.Add($i)
        }
    }

    if ($indexes.Count -eq 0) {
        return $null
    }

    $prefix = @()
    if ($indexes[0] -gt 0) {
        $prefix = $Lines[0..($indexes[0] - 1)]
    }

    $sections = New-Object System.Collections.Generic.List[object]
    for ($j = 0; $j -lt $indexes.Count; $j++) {
        $start = $indexes[$j]
        $end = if ($j -lt $indexes.Count - 1) { $indexes[$j + 1] - 1 } else { $Lines.Count - 1 }
        $heading = [string]$Lines[$start]
        $markerId = $null
        if ($heading -match "<!--\s*session-turn-id:\s*([0-9-]+)\s*-->") {
            $markerId = $Matches[1]
        }
        $sections.Add([PSCustomObject]@{
                Heading = $heading
                MarkerId = $markerId
                Lines = @($Lines[$start..$end])
                OriginalIndex = $j
            })
    }

    $sectionArray = @()
    if ($sections.Count -gt 0) {
        $sectionArray = $sections.ToArray()
    }

    return [PSCustomObject]@{
        Prefix = @($prefix)
        Sections = $sectionArray
    }
}

if (-not $SnapshotPath) {
    $SnapshotPath = Join-Path (Get-RepoRoot) "workspace_state/core/session-snapshot.md"
}

if (-not (Test-Path $SnapshotPath)) {
    throw "Missing file: $SnapshotPath"
}

$lines = Get-Content -Path $SnapshotPath
$parts = Get-HeadingSections -Lines $lines -HeadingRegex "^## 本轮更新"
if ($null -eq $parts) {
    Write-Host "SKIP: no session blocks found."
    exit 0
}

$sections = @($parts.Sections)
$marked = @($sections | Where-Object { $_.MarkerId })
if ($marked.Count -eq 0) {
    Write-Host "SKIP: no marked session blocks found."
    exit 0
}

$unmarked = @($sections | Where-Object { -not $_.MarkerId })
$sortedMarked = @($marked | Sort-Object MarkerId, OriginalIndex)
$newSections = @($unmarked + $sortedMarked)

$changed = $false
if ($newSections.Count -ne $sections.Count) {
    $changed = $true
}
else {
    for ($i = 0; $i -lt $sections.Count; $i++) {
        if ($sections[$i].Heading -ne $newSections[$i].Heading) {
            $changed = $true
            break
        }
    }
}

if (-not $changed) {
    Write-Host "PASS: session-snapshot tail order already normalized."
    exit 0
}

$newContent = New-Object System.Collections.Generic.List[string]
foreach ($line in $parts.Prefix) {
    $newContent.Add([string]$line)
}
foreach ($section in $newSections) {
    foreach ($line in $section.Lines) {
        $newContent.Add([string]$line)
    }
}

if ($DryRun) {
    Write-Host ("DRY-RUN: would reorder {0} marked blocks to file tail." -f $marked.Count)
    exit 0
}

Set-Content -Path $SnapshotPath -Value $newContent -Encoding UTF8
Write-Host ("REPAIRED: reordered {0} marked session blocks to file tail." -f $marked.Count)
