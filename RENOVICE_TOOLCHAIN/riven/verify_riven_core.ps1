$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..")).Path
$toolchain = Join-Path $repo "RENOVICE_TOOLCHAIN"
& (Join-Path $toolchain "bootstrap_tools.ps1")
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) { throw "Visual Studio C++ tools unavailable" }
Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
$binaryDir = Join-Path $toolchain "bin\riven"
New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null
$source = Join-Path $PSScriptRoot "verify_riven_core.cpp"
$object = Join-Path $binaryDir "verify_riven_core.obj"
$binary = Join-Path $binaryDir "verify_riven_core.exe"
& cl /nologo /std:c++20 /W4 /WX /EHsc /O2 $source /Fo:$object /Fe:$binary
if ($LASTEXITCODE -ne 0) { throw "Riven verifier compile failed: $LASTEXITCODE" }
& $binary
if ($LASTEXITCODE -ne 0) { throw "Riven verifier failed: $LASTEXITCODE" }

# R5 source pins: the optional Riven gate never rejects the F9 transaction.
$repoText = [IO.File]::ReadAllText((Join-Path $repo "renovice\injection.cpp"))
$rivenText = [IO.File]::ReadAllText((Join-Path $repo "renovice\riven.cpp"))
if ($repoText.Contains("Riven gate reload rejected") -or -not $repoText.Contains("if (transaction_valid) riven::prepare_gate_reload();")) {
    throw "Riven verifier failed: the Riven gate can still reject the F9 transaction"
}
if ($rivenText.Contains("is_regular_file(") -or -not $rivenText.Contains("classify_gate_file(gate_file_path(), error)")) {
    throw "Riven verifier failed: the gate file is not read through classify_gate_file"
}
Write-Output "PASS`tR5: the Riven gate file is classified (absent = off) and never rejects F9"
Write-Output "RIVEN GATE PASS"
