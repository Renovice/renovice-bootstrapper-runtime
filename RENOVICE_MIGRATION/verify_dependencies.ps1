$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent $PSScriptRoot
$expected = [ordered]@{
    "modules/Pluto" = "2ea6fd9398d6eaccb8fec283f8ce2005579a59c0"
    "modules/Soup" = "b02796b0b20276277c8a4b4d3759643eeab43ff7"
    "modules/ee-notation-parser" = "fddb8d05b59c3e89778c9a69e0876ed3408f57bb"
    "modules/owf-translations" = "8e6d5ee3a7972a2f38e90d02ce55b0a830419be9"
    "modules/warframe-cache-tools" = "d5cfff2735e70285ae0f182cb91a6bc7e6566714"
}

$failures = [System.Collections.Generic.List[string]]::new()
foreach ($entry in $expected.GetEnumerator()) {
    $path = $entry.Key
    $fullPath = Join-Path $repo ($path -replace "/", "\")
    $stage = @(git -C $repo ls-files --stage -- $path)
    if ($LASTEXITCODE -ne 0 -or $stage.Count -ne 1) {
        $failures.Add("missing gitlink: $path")
        continue
    }
    $fields = $stage[0] -split "\s+"
    if ($fields[0] -ne "160000") {
        $failures.Add("not a gitlink: $path mode=$($fields[0])")
    }
    if ($fields[1] -ne $entry.Value) {
        $failures.Add("wrong staged pin: $path expected=$($entry.Value) actual=$($fields[1])")
    }
    if (-not (Test-Path -LiteralPath (Join-Path $fullPath ".git"))) {
        $failures.Add("submodule not populated: $path")
        continue
    }
    $actual = (git -C $fullPath rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0 -or $actual -ne $entry.Value) {
        $failures.Add("wrong checkout pin: $path expected=$($entry.Value) actual=$actual")
    }
    $dirty = @(git -C $fullPath status --porcelain)
    if ($dirty.Count -ne 0) {
        $failures.Add("dirty submodule: $path")
    }
}

if ($failures.Count -ne 0) {
    $failures | ForEach-Object { Write-Error $_ }
    throw "DEPENDENCY FAIL count=$($failures.Count)"
}

Write-Host "DEPENDENCY PASS submodules=$($expected.Count) source_commit=756bdc17aa9edf61df8204f901cdfff37b47db57"
