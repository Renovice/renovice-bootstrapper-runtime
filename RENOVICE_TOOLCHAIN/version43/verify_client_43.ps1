param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath,
    [string]$ProxyDllPath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$certifiedClients = @(
    @{
		Version = "2026.07.11.15.28"
        Sha256 = "87d3c0f946d6fff8b95567b2fce396d407721bc86cafabdafc44ee8f60fb92b0"
        UndumpRaw = "197d430"
        UndumpRva = "197e030"
    },
    @{
		Version = "2026.08.19.11.06"
        Sha256 = "d01b5cb5cff51afc5ffb7d3af051674aafa84000bee764780ff71d9d073cad93"
        UndumpRaw = "197f210"
        UndumpRva = "197fe10"
    },
    @{
		Version = "2026.08.19.11.06"
		Sha256 = "cca46d604a498cd95f0d28e3e8f3eee8833f5d362666a8e5c820c535f7c2af93"
		UndumpRaw = "197f210"
		UndumpRva = "197fe10"
	}
)
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ProxyDllPath = if ([string]::IsNullOrWhiteSpace($ProxyDllPath)) {
    Join-Path $repo "wtsapi32.dll"
} else {
    $ProxyDllPath
}
$source = Join-Path $PSScriptRoot "verify_client_43.cpp"
$binaryDir = Join-Path (Split-Path -Parent $PSScriptRoot) "bin\version43"
$binary = Join-Path $binaryDir "verify_client_43.exe"
$object = Join-Path $binaryDir "verify_client_43.obj"

$resolvedExe = (Resolve-Path -LiteralPath $ExePath).Path
$actualVersion = (Get-Item -LiteralPath $resolvedExe).VersionInfo.ProductVersion
$actualSha256 = (Get-FileHash -LiteralPath $resolvedExe -Algorithm SHA256).Hash.ToLowerInvariant()
$versionCandidates = @($certifiedClients | Where-Object Version -eq $actualVersion)
if ($versionCandidates.Count -eq 0) {
    throw "Client version is not certified: actual=$actualVersion certified=$((@($certifiedClients.Version | Sort-Object -Unique)) -join ',')"
}
$expected = @($versionCandidates | Where-Object Sha256 -eq $actualSha256) | Select-Object -First 1
if ($null -eq $expected) {
    throw "Client SHA256 mismatch for version $actualVersion`: expected one of $($versionCandidates.Sha256 -join ',') actual=$actualSha256"
}

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
    throw "Visual Studio 2022 x64 C++ tools were not found"
}
Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null

$resolvedProxy = (Resolve-Path -LiteralPath $ProxyDllPath).Path
$wtsImportOutput = @(dumpbin /nologo /imports:wtsapi32.dll $resolvedExe 2>&1)
if ($LASTEXITCODE -ne 0) {
    throw "Could not inspect client WTS imports: $LASTEXITCODE"
}
$proxyExportOutput = @(dumpbin /nologo /exports $resolvedProxy 2>&1)
if ($LASTEXITCODE -ne 0) {
    throw "Could not inspect proxy exports: $LASTEXITCODE"
}
$clientWtsImports = @(
    $wtsImportOutput | ForEach-Object {
        if ($_ -match '^\s+[0-9A-F]+\s+(WTS[A-Za-z0-9_]+)\s*$') {
            $Matches[1]
        }
    } | Sort-Object -Unique
)
$proxyWtsExports = @(
    $proxyExportOutput | ForEach-Object {
        if ($_ -match '^\s+\d+\s+[0-9A-F]+\s+[0-9A-F]+\s+(WTS[A-Za-z0-9_]+)\s*$') {
            $Matches[1]
        }
    } | Sort-Object -Unique
)
if ($clientWtsImports.Count -eq 0) {
    throw "Client WTS import scan returned no named imports"
}
$missingProxyExports = @($clientWtsImports | Where-Object { $_ -notin $proxyWtsExports })
if ($missingProxyExports.Count -ne 0) {
    throw "Proxy is missing client-required WTS exports: $($missingProxyExports -join ', ')"
}
Write-Host "PASS`tWTS proxy export coverage imports=$($clientWtsImports.Count) names=$($clientWtsImports -join ',')"

New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null
$compileOutput = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
$compileOutput | Write-Output
if ($LASTEXITCODE -ne 0) {
    throw "Version 43 verifier compilation failed: $LASTEXITCODE"
}

& $binary $resolvedExe $expected.UndumpRaw $expected.UndumpRva
if ($LASTEXITCODE -ne 0) {
    throw "Version 43 executable scan failed: $LASTEXITCODE"
}

$seedData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\vv\wf_fnv_2_initial.json") -Raw
$hashData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\hash_to_code_version.json") -Raw
$tunableData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\tunables.json") -Raw
$mainSource = Get-Content -LiteralPath (Join-Path $repo "main.cpp") -Raw

$dataChecks = [ordered]@{
    "v43 seed" = $seedData.Contains('"43.0.0": 2119891177')
    "June exact undump fallback" = $tunableData.Contains('"renovice_undump_rva_2026_06_19_13_22": 0x197C9F0')
    "July exact undump fallback" = $tunableData.Contains('"renovice_undump_rva_2026_07_11_15_28": 0x197E030')
    "August exact undump fallback" = $tunableData.Contains('"renovice_undump_rva_2026_08_19_11_06": 0x197FE10')
    "July manifest mapping" = $hashData.Contains('"7fwjVVacxcBzO-xahK2RZg": "2026.07.11.15.28"')
    "v45 coarse cutoff" = $tunableData.Contains('"toonew": { "$gv": "45.0.0" }')
    "July exact allowlist" = $tunableData.Contains('"2026.07.11.15.28"')
    "August exact allowlist" = $tunableData.Contains('"2026.08.19.11.06"')
	"Current Amir Shockwave SHA256 allowlist" = $tunableData.Contains('"cca46d604a498cd95f0d28e3e8f3eee8833f5d362666a8e5c820c535f7c2af93"')
    "unknown U43 absent" = -not $tunableData.Contains('"2026.07.12.00.00"')
    "source exact-build gate" = $mainSource.Contains('supported_builds_43') -and $mainSource.Contains('joaat::hashRange(build_version, 16)')
	"source exact-executable-hash gate" = $mainSource.Contains('supported_client_sha256_43') -and $mainSource.Contains('sha256::hash(executable_reader)')
	"source executable-hash case normalization" = $mainSource.Contains('executable_sha256_hex = string::bin2hexLower(')
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

Write-Host "V43 COMPATIBILITY PASS version=$actualVersion sha256=$actualSha256 undump_rva=0x$($expected.UndumpRva) data_checks=$($dataChecks.Count)"
