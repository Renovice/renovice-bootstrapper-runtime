param(
    [string]$ReplacementDirectory = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$toolchain = Split-Path -Parent $PSScriptRoot
$source = Join-Path $PSScriptRoot "verify_replacement_core.cpp"
$binaryDir = Join-Path $toolchain "bin\replacements"
$binary = Join-Path $binaryDir "verify_replacement_core.exe"
$object = Join-Path $binaryDir "verify_replacement_core.obj"

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
    throw "Replacement core verifier compilation failed: $LASTEXITCODE"
}
if ([string]::IsNullOrWhiteSpace($ReplacementDirectory)) {
    & $binary
} else {
    & $binary (Resolve-Path -LiteralPath $ReplacementDirectory).Path
}
if ($LASTEXITCODE -ne 0) {
    throw "Replacement core verifier failed: $LASTEXITCODE"
}
