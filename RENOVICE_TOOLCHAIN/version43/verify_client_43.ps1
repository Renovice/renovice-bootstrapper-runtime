param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$expectedVersion = "2026.07.11.15.28"
$expectedSha256 = "87d3c0f946d6fff8b95567b2fce396d407721bc86cafabdafc44ee8f60fb92b0"
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$source = Join-Path $PSScriptRoot "verify_client_43.cpp"
$binaryDir = Join-Path (Split-Path -Parent $PSScriptRoot) "bin\version43"
$binary = Join-Path $binaryDir "verify_client_43.exe"
$object = Join-Path $binaryDir "verify_client_43.obj"

$resolvedExe = (Resolve-Path -LiteralPath $ExePath).Path
$actualVersion = (Get-Item -LiteralPath $resolvedExe).VersionInfo.ProductVersion
$actualSha256 = (Get-FileHash -LiteralPath $resolvedExe -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actualVersion -ne $expectedVersion) {
    throw "Client version mismatch: expected=$expectedVersion actual=$actualVersion"
}
if ($actualSha256 -ne $expectedSha256) {
    throw "Client SHA256 mismatch: expected=$expectedSha256 actual=$actualSha256"
}

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
    throw "Visual Studio 2022 x64 C++ tools were not found"
}
Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null

New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null
$compileOutput = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
$compileOutput | Write-Output
if ($LASTEXITCODE -ne 0) {
    throw "Version 43 verifier compilation failed: $LASTEXITCODE"
}

& $binary $resolvedExe
if ($LASTEXITCODE -ne 0) {
    throw "Version 43 executable scan failed: $LASTEXITCODE"
}

$seedData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\vv\wf_fnv_2_initial.json") -Raw
$hashData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\hash_to_code_version.json") -Raw
$tunableData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\tunables.json") -Raw
$mainSource = Get-Content -LiteralPath (Join-Path $repo "main.cpp") -Raw

$dataChecks = [ordered]@{
    "v43 seed" = $seedData.Contains('"43.0.0": 2119891177')
    "July manifest mapping" = $hashData.Contains('"7fwjVVacxcBzO-xahK2RZg": "2026.07.11.15.28"')
    "v44 coarse cutoff" = $tunableData.Contains('"toonew": { "$gv": "44.0.0" }')
    "July exact allowlist" = $tunableData.Contains('"2026.07.11.15.28"')
    "unknown U43 absent" = -not $tunableData.Contains('"2026.07.12.00.00"')
    "source exact-build gate" = $mainSource.Contains('supported_builds_43') -and $mainSource.Contains('joaat::hashRange(build_version, 16)')
}

$failed = 0
foreach ($check in $dataChecks.GetEnumerator()) {
    if ($check.Value) {
        Write-Host "PASS`t$($check.Key)"
    } else {
        Write-Host "FAIL`t$($check.Key)"
        $failed++
    }
}
if ($failed -ne 0) {
    throw "Version 43 source-data gate failed: failures=$failed"
}

Write-Host "V43 COMPATIBILITY PASS version=$actualVersion sha256=$actualSha256 data_checks=$($dataChecks.Count)"
