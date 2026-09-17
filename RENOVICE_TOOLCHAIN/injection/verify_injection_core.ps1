param(
    [string]$InjectionDirectory = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$toolchain = Split-Path -Parent $PSScriptRoot
$source = Join-Path $PSScriptRoot "verify_injection_core.cpp"
$binaryDir = Join-Path $toolchain "bin\injection"
$binary = Join-Path $binaryDir "verify_injection_core.exe"
$object = Join-Path $binaryDir "verify_injection_core.obj"

$originalEnvironment = @{}
foreach ($entry in Get-ChildItem Env:) { $originalEnvironment[$entry.Name] = $entry.Value }
function Restore-ProcessEnvironment([hashtable]$Snapshot) {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $Snapshot.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $Snapshot.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

try {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
        throw "Visual Studio 2022 x64 C++ tools were not found"
    }
    Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null

    New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null
    $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $output | Write-Output
    if ($LASTEXITCODE -ne 0) {
        throw "Injection core verifier compilation failed: $LASTEXITCODE"
    }
    if ([string]::IsNullOrWhiteSpace($InjectionDirectory)) {
        & $binary
    } else {
        & $binary (Resolve-Path -LiteralPath $InjectionDirectory).Path
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Injection core verifier failed: $LASTEXITCODE"
    }
}
finally {
    Restore-ProcessEnvironment $originalEnvironment
}
