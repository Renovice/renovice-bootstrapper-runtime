[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$manifestPath = Join-Path $PSScriptRoot 'custom_feature_manifest.tsv'
$targetsPath = Join-Path $PSScriptRoot 'target_requirements.tsv'

$expectedHeader = 'feature_id', 'subsystem', 'feature', 'custom_source',
    'line_anchor', 'stock_equivalent', 'current_state', 'parity_required',
    'runtime_gate', 'migration_target', 'risk', 'parity_test', 'notes'
$actualHeader = (Get-Content -LiteralPath $manifestPath -TotalCount 1) -split "`t"
if (($actualHeader -join "`n") -ne ($expectedHeader -join "`n")) {
    throw 'Unexpected custom_feature_manifest.tsv header.'
}

$rows = @(Import-Csv -LiteralPath $manifestPath -Delimiter "`t")
$allowedStates = 'DEPLOYED_CUSTOM', 'EXPERIMENTAL_CUSTOM', 'DISABLED_CUSTOM',
    'PATCHED_COMPANION'
$allowedRisks = 'low', 'medium', 'high', 'critical'
$ids = @{}
$failures = [System.Collections.Generic.List[string]]::new()

foreach ($row in $rows) {
    if ([string]::IsNullOrWhiteSpace($row.feature_id)) {
        $failures.Add('A feature row has an empty feature_id.')
        continue
    }
    if ($ids.ContainsKey($row.feature_id)) {
        $failures.Add("Duplicate feature_id: $($row.feature_id)")
    } else {
        $ids[$row.feature_id] = $true
    }
    if ($row.current_state -notin $allowedStates) {
        $failures.Add("$($row.feature_id): invalid current_state $($row.current_state)")
    }
    if ($row.risk -notin $allowedRisks) {
        $failures.Add("$($row.feature_id): invalid risk $($row.risk)")
    }
    if ($row.parity_required -notin @('yes', 'no')) {
        $failures.Add("$($row.feature_id): parity_required must be yes or no")
    }
    if ($row.parity_required -eq 'yes' -and
        ([string]::IsNullOrWhiteSpace($row.parity_test) -or $row.parity_test -eq '-')) {
        $failures.Add("$($row.feature_id): required feature has no parity test")
    }
    if ([string]::IsNullOrWhiteSpace($row.migration_target)) {
        $failures.Add("$($row.feature_id): empty migration_target")
    }

    $source = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $row.custom_source))
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        $failures.Add("$($row.feature_id): source does not exist: $source")
        continue
    }
    if ($row.line_anchor -notmatch '^\d+$') {
        $failures.Add("$($row.feature_id): line_anchor is not numeric")
        continue
    }
    $lineCount = ([System.IO.File]::ReadLines($source) | Measure-Object).Count
    if ([int]$row.line_anchor -lt 1 -or [int]$row.line_anchor -gt $lineCount) {
        $failures.Add("$($row.feature_id): line_anchor $($row.line_anchor) exceeds $lineCount lines")
    }
}

$targetHeader = (Get-Content -LiteralPath $targetsPath -TotalCount 1) -split "`t"
if (($targetHeader -join "`n") -ne
    (('requirement_id','category','requirement','acceptance_test','status') -join "`n")) {
    $failures.Add('Unexpected target_requirements.tsv header.')
}
$targets = @(Import-Csv -LiteralPath $targetsPath -Delimiter "`t")
$targetIds = @{}
foreach ($target in $targets) {
    if ($targetIds.ContainsKey($target.requirement_id)) {
        $failures.Add("Duplicate requirement_id: $($target.requirement_id)")
    } else {
        $targetIds[$target.requirement_id] = $true
    }
    if ($target.status -notin @('PENDING','IN_PROGRESS','PASS','FAIL','BLOCKED')) {
        $failures.Add("$($target.requirement_id): invalid status $($target.status)")
    }
    if ([string]::IsNullOrWhiteSpace($target.acceptance_test)) {
        $failures.Add("$($target.requirement_id): empty acceptance_test")
    }
}

if ($failures.Count) {
    $failures | ForEach-Object { Write-Error $_ }
    throw "Manifest verification failed with $($failures.Count) error(s)."
}

$required = @($rows | Where-Object parity_required -eq 'yes').Count
$deployed = @($rows | Where-Object current_state -eq 'DEPLOYED_CUSTOM').Count
$experimental = @($rows | Where-Object current_state -eq 'EXPERIMENTAL_CUSTOM').Count
$disabled = @($rows | Where-Object current_state -eq 'DISABLED_CUSTOM').Count
$patched = @($rows | Where-Object current_state -eq 'PATCHED_COMPANION').Count
$critical = @($rows | Where-Object risk -eq 'critical').Count

Write-Host "MANIFEST PASS features=$($rows.Count) required=$required deployed=$deployed experimental=$experimental disabled=$disabled patched_companion=$patched critical=$critical targets=$($targets.Count)"
