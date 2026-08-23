$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..")).Path
$toolchain = Join-Path $repo "RENOVICE_TOOLCHAIN"
& (Join-Path $toolchain "bootstrap_tools.ps1")

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
    throw "Visual Studio 2022 with x64 C++ tools was not found"
}
Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null

$binaryDir = Join-Path $toolchain "bin\config"
New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null
$binary = Join-Path $binaryDir "verify_config_core.exe"
$source = Join-Path $PSScriptRoot "verify_config_core.cpp"

$object = Join-Path $binaryDir "verify_config_core.obj"
& cl /nologo /std:c++20 /W4 /WX /EHsc /O2 $source /Fo:$object /Fe:$binary
if ($LASTEXITCODE -ne 0) { throw "Config verifier compile failed: $LASTEXITCODE" }
& $binary
if ($LASTEXITCODE -ne 0) { throw "Config verifier failed: $LASTEXITCODE" }
