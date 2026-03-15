param(
    [Parameter(Mandatory = $true)]
    [string]$HeadingSuffix,
    [string]$BodyText,
    [string]$BodyFilePath,
    [ValidateSet("是", "否")]
    [string]$PreferencesUpdated = "否",
    [ValidateSet("是", "否")]
    [string]$RequirementsUnderstood = "是",
    [string]$SnapshotPath,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Split-BodyLines {
    param(
        [string]$Text,
        [string]$FilePath
    )

    if ($FilePath) {
        if (-not (Test-Path $FilePath)) {
            throw "Missing body file: $FilePath"
        }
        return @(Get-Content -Path $FilePath)
    }

    if ([string]::IsNullOrWhiteSpace($Text)) {
        throw "Either -BodyText or -BodyFilePath is required."
    }

    $normalized = $Text -replace "`r", ""
    return @($normalized -split "`n")
}

if (-not $SnapshotPath) {
    $SnapshotPath = Join-Path (Get-RepoRoot) "workspace_state/core/session-snapshot.md"
}

if (-not (Test-Path $SnapshotPath)) {
    throw "Missing file: $SnapshotPath"
}

$repairScript = Join-Path (Get-RepoRoot) "scripts/repair-session-snapshot-tail.ps1"
if (Test-Path $repairScript) {
    if ($DryRun) {
        & $repairScript -SnapshotPath $SnapshotPath -DryRun | Out-Null
    }
    else {
        & $repairScript -SnapshotPath $SnapshotPath | Out-Null
    }
}

$bodyLines = Split-BodyLines -Text $BodyText -FilePath $BodyFilePath
$lines = @(Get-Content -Path $SnapshotPath)

$updatedDate = (Get-Date).ToString("yyyy-MM-dd")
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^- 最后更新:") {
        $lines[$i] = "- 最后更新: $updatedDate"
        break
    }
}

while ($lines.Count -gt 0 -and [string]::IsNullOrWhiteSpace($lines[$lines.Count - 1])) {
    if ($lines.Count -eq 1) {
        $lines = @()
    }
    else {
        $lines = @($lines[0..($lines.Count - 2)])
    }
}

$appendId = (Get-Date).ToString("yyyyMMdd-HHmmssfff")
$heading = "## 本轮更新（$updatedDate）- $HeadingSuffix <!-- session-turn-id: $appendId -->"
$checkLine = "快照检查：用户偏好已更新=$PreferencesUpdated；用户需求已完全理解=$RequirementsUnderstood"

$newContent = New-Object System.Collections.Generic.List[string]
foreach ($line in $lines) {
    $newContent.Add([string]$line)
}
$newContent.Add($heading)
foreach ($line in $bodyLines) {
    $newContent.Add([string]$line)
}
$newContent.Add($checkLine)

if ($DryRun) {
    Write-Host ("DRY-RUN: would append session block `{0}` to file tail." -f $HeadingSuffix)
    exit 0
}

Set-Content -Path $SnapshotPath -Value $newContent -Encoding UTF8
Write-Host ("APPENDED: session block `{0}` written to file tail." -f $HeadingSuffix)
