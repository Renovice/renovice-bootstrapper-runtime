$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
. (Join-Path $repo 'RENOVICE_TOOLCHAIN\gate_paths.ps1')
# The checker source, object and binary live in the short gate scratch folder.
# The Soup headers and soup.lib (a 17 MB build product) are still read in place,
# which bounds this gate at a repository path of about 200 characters.
$binaryDir = Get-GateScratch $repo 'detour-relocatability'
$source = Join-Path (Copy-GateSources $repo $binaryDir @('RENOVICE_TOOLCHAIN\runtime\verify_detour_relocatability.cpp')) 'RENOVICE_TOOLCHAIN\runtime\verify_detour_relocatability.cpp'
$binary = Join-Path $binaryDir 'verify_detour_relocatability.exe'
$object = Join-Path $binaryDir 'verify_detour_relocatability.obj'
$soupDir = Join-Path $repo 'modules\Soup\soup'
$soupLib = Join-Path $soupDir 'soup.lib'

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = (& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
$vsId = (& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
    throw 'Visual Studio 2022 x64 C++ tools were not found'
}
if (-not (Test-Path -LiteralPath $soupLib -PathType Leaf)) {
    throw "Soup static library was not found: $soupLib"
}

Import-Module (Join-Path $vsPath 'Common7\Tools\Microsoft.VisualStudio.DevShell.dll')
Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null

$output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /I $soupDir /Fo:$object /Fe:$binary $source $soupLib 2>&1 |
    ForEach-Object { $_.ToString().TrimEnd("`r") })
$output | Write-Output
if ($LASTEXITCODE -ne 0) {
    throw "Detour relocatability verifier compilation failed: $LASTEXITCODE"
}

& $binary
if ($LASTEXITCODE -ne 0) {
    throw "Detour relocatability verifier failed: $LASTEXITCODE"
}
