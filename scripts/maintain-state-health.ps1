param(
    [int]$SnapshotLineThreshold = 900,
    [int]$ChangeLogLineThreshold = 500,
    [int]$SnapshotSizeKbThreshold = 120,
    [int]$ChangeLogSizeKbThreshold = 120,
    [int]$SnapshotBlockThreshold = 35,
    [int]$ChangeLogBlockThreshold = 25,
    [int]$ArchiveIdleDays = 14,
    [switch]$AutoArchive,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Get-LastArchiveDate {
    param([string]$IndexPath)
    if (-not (Test-Path $IndexPath)) {
        return $null
    }

    $lines = Get-Content -Path $IndexPath
    for ($i = $lines.Count - 1; $i -ge 0; $i--) {
        $line = $lines[$i]
        if ($line -match "(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})") {
            return [datetime]::ParseExact($Matches[1], "yyyy-MM-dd HH:mm:ss", $null)
        }
    }
    return $null
}

function Get-BlockCount {
    param(
        [string]$FilePath,
        [string]$HeadingRegex
    )

    if ([string]::IsNullOrWhiteSpace($HeadingRegex)) {
        return -1
    }

    $count = 0
    foreach ($line in Get-Content -Path $FilePath) {
        if ($line -match $HeadingRegex) {
            $count++
        }
    }
    return $count
}

$repoRoot = Get-RepoRoot
$repairScript = Join-Path $repoRoot "scripts/repair-session-snapshot-tail.ps1"
if (Test-Path $repairScript) {
    if ($DryRun) {
        & $repairScript -DryRun
    }
    else {
        & $repairScript
    }
}

$targets = @(
    @{
        Name = "session-snapshot"
        FileRel = "workspace_state/core/session-snapshot.md"
        IndexRel = "workspace_state/logs/session-history-index.md"
        LineThreshold = $SnapshotLineThreshold
        SizeThreshold = $SnapshotSizeKbThreshold
        BlockThreshold = $SnapshotBlockThreshold
        HeadingRegex = "^## 本轮更新"
    },
    @{
        Name = "thinking-patterns-change-log"
        FileRel = "user_profile/logs/thinking-patterns-change-log.md"
        IndexRel = "user_profile/logs/change-log-history-index.md"
        LineThreshold = $ChangeLogLineThreshold
        SizeThreshold = $ChangeLogSizeKbThreshold
        BlockThreshold = $ChangeLogBlockThreshold
        HeadingRegex = "^## \d{4}-\d{2}-\d{2}"
    }
)

$report = New-Object System.Collections.Generic.List[object]
$triggered = New-Object System.Collections.Generic.List[object]
$now = Get-Date

foreach ($target in $targets) {
    $filePath = Join-Path $repoRoot $target.FileRel
    $indexPath = Join-Path $repoRoot $target.IndexRel
    if (-not (Test-Path $filePath)) {
        throw "Missing file: $filePath"
    }

    $lineCount = (Get-Content -Path $filePath | Measure-Object -Line).Lines
    $blockCount = Get-BlockCount -FilePath $filePath -HeadingRegex $target.HeadingRegex
    $sizeKb = [math]::Round(((Get-Item -Path $filePath).Length / 1KB), 2)
    $lastArchive = Get-LastArchiveDate -IndexPath $indexPath
    $daysSinceLastArchive = if ($null -eq $lastArchive) { -1 } else { [math]::Floor(($now - $lastArchive).TotalDays) }

    $reasons = New-Object System.Collections.Generic.List[string]
    if ($blockCount -ge 0 -and $blockCount -ge $target.BlockThreshold) {
        $reasons.Add("block_count($blockCount) >= $($target.BlockThreshold)")
    }
    if ($lineCount -ge $target.LineThreshold) {
        $reasons.Add("line_count($lineCount) >= $($target.LineThreshold)")
    }
    if ($sizeKb -ge $target.SizeThreshold) {
        $reasons.Add("size_kb($sizeKb) >= $($target.SizeThreshold)")
    }
    if ($ArchiveIdleDays -gt 0 -and $daysSinceLastArchive -ge 0 -and $daysSinceLastArchive -ge $ArchiveIdleDays) {
        $reasons.Add("days_since_last_archive($daysSinceLastArchive) >= $ArchiveIdleDays")
    }
    if ($ArchiveIdleDays -gt 0 -and $daysSinceLastArchive -lt 0) {
        $reasons.Add("archive_index_missing")
    }

    $triggeredThis = $reasons.Count -gt 0
    $report.Add([PSCustomObject]@{
            target = $target.Name
            file = $target.FileRel
            blocks = if ($blockCount -ge 0) { $blockCount } else { "-" }
            lines = $lineCount
            size_kb = $sizeKb
            last_archive = if ($null -eq $lastArchive) { "-" } else { $lastArchive.ToString("yyyy-MM-dd HH:mm:ss") }
            triggered = $triggeredThis
            reasons = if ($reasons.Count -eq 0) { "-" } else { ($reasons -join "; ") }
        })
    if ($triggeredThis) {
        $triggered.Add($target.Name) | Out-Null
    }
}

$report | Format-Table -AutoSize

if ($triggered.Count -eq 0) {
    Write-Host "PASS: no archive trigger hit."
    exit 0
}

Write-Host "TRIGGERED: $($triggered -join ', ')"
if (-not $AutoArchive) {
    Write-Host "No archive executed. Re-run with -AutoArchive to apply archiving."
    exit 0
}

$archiveScript = Join-Path $repoRoot "scripts/archive-analyst-state.ps1"
if (-not (Test-Path $archiveScript)) {
    throw "Missing script: $archiveScript"
}

if ($DryRun) {
    & $archiveScript -DryRun
}
else {
    & $archiveScript
}

Write-Host "DONE: dynamic maintenance completed."
