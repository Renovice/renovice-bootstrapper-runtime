param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath,
    [string]$ProxyDllPath
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$certifiedClients = @(@{
    Version = "2026.09.24.13.29"
    Sha256 = "45fa6ad0769cc8ca7fa7e0ffdee65c0c0932e11744146781ad18c45b16e4a81c"
    UndumpRaw = "1919d60"
    UndumpRva = "191a960"
}, @{
    Version = "2026.09.24.13.29"
    Sha256 = "87fc60ce65e015c6c8d4be5ac353538c37392efb6793dd17f0a17cf126d3fb5c"
    UndumpRaw = "1919d60"
    UndumpRva = "191a960"
}, @{
    # Hotfix 44.0.2 (Steam)
    Version = "2026.09.28.13.06"
    Sha256 = "00cf876132443b8e2bcb7450d05c89d0f8695ec51c5881976f784233dbc94374"
    UndumpRaw = "191a480"
    UndumpRva = "191b080"
}, @{
    # Hotfix 44.0.2 (Sideloadify 1.1.0; identical executable code)
    Version = "2026.09.28.13.06"
    Sha256 = "0124f0b93516e60ae362c59090809de24a42551143a6adf84963bd2120ab7d33"
    UndumpRaw = "191a480"
    UndumpRva = "191b080"
}, @{
    # 2026.09.30.14.45 (native update tool 2026-10-04)
    Version = "2026.09.30.14.45"
    Sha256 = "e546599b62d0574db955fc93a6434728625be72ca1a0731e475d1ffa350ccf05"
    UndumpRaw = "191a100"
    UndumpRva = "191ad00"
}, @{
    # 2026.09.30.14.45 (native update tool 2026-10-04)
    Version = "2026.09.30.14.45"
    Sha256 = "ab759d955ee56d08be6f27e2a4272914d64f216196ece8e994393f4a5c92db4d"
    UndumpRaw = "191a100"
    UndumpRva = "191ad00"
})
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ProxyDllPath = if ([string]::IsNullOrWhiteSpace($ProxyDllPath)) {
    Join-Path $repo "wtsapi32.dll"
} else {
    $ProxyDllPath
}
$source = Join-Path $PSScriptRoot "verify_client_44.cpp"
$binaryDir = Join-Path (Split-Path -Parent $PSScriptRoot) "bin\version44"
$binary = Join-Path $binaryDir "verify_client_44.exe"
$object = Join-Path $binaryDir "verify_client_44.obj"

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
    throw "Version 44 verifier compilation failed: $LASTEXITCODE"
}

& $binary $resolvedExe $expected.UndumpRaw $expected.UndumpRva
if ($LASTEXITCODE -ne 0) {
    throw "Version 44 executable scan failed: $LASTEXITCODE"
}

$seedData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\vv\wf_fnv_2_initial.json") -Raw
$hashData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\hash_to_code_version.json") -Raw
$tunableData = Get-Content -LiteralPath (Join-Path $repo "OpenWF\tunables.json") -Raw
$mainSource = Get-Content -LiteralPath (Join-Path $repo "main.cpp") -Raw

$dataChecks = [ordered]@{
    "U44 seed" = $seedData.Contains('"44.0.0": 1989041872')
    "U45 coarse cutoff" = $tunableData.Contains('"toonew": { "$gv": "45.0.0" }')
    "U44 exact build" = $tunableData.Contains('"2026.09.24.13.29"')
    "U44 exact executable hash" = $tunableData.Contains('"45fa6ad0769cc8ca7fa7e0ffdee65c0c0932e11744146781ad18c45b16e4a81c"')
    "Source exact build gate" = $mainSource.Contains('supported_builds_44') -and $mainSource.Contains('joaat::hashRange(build_version, 16)')
    "Source exact hash gate" = $mainSource.Contains('supported_client_sha256_44') -and $mainSource.Contains('sha256::hash(executable_reader)')
    "Existing U43 gate retained" = $mainSource.Contains('supported_client_sha256_43')
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
    throw "Version 44 source-data gate failed: failures=$failed"
}

Write-Host "V44 COMPATIBILITY PASS version=$actualVersion sha256=$actualSha256 undump_rva=0x$($expected.UndumpRva) data_checks=$($dataChecks.Count)"
