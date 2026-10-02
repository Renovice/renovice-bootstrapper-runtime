[CmdletBinding()]
param(
    # Read-only executable images, one or more per registered ENGINE_DAMAGE build
    # (renovice/engine_damage_builds.hpp). Defaults: the pinned 43 native-analysis
    # input, the 44.0.0 pre-update client copy, every native-update reference image
    # (work\native-update\reference) and the client (RENOVICE_GATE_CLIENT_EXE or the
    # installed Warframe.x64.exe); see Get-GateClientImages in gate_paths.ps1.
    [string[]]$Images = @()
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$toolchain = Split-Path -Parent $PSScriptRoot
$repo = Split-Path -Parent $toolchain
. (Join-Path $toolchain 'gate_paths.ps1')

if ($Images.Count -eq 0) {
    $workspace = $repo
    while (-not (Test-Path -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -PathType Leaf)) {
        $parent = Split-Path -Parent $workspace
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $workspace) { throw 'ENGINE_DAMAGE CODEC GATE FAIL: WORKSPACE.json not found' }
        $workspace = $parent
    }
    $Images = @(
        (Join-Path $workspace 'work\native-analysis\inputs\wf-2026.08.19.11.06-cca46d60\Warframe.x64.exe'),
        (Join-Path $workspace 'work\research\U44-2026-09-27\client-before\Warframe.x64.exe')
    ) + @(Get-GateClientImages $repo)
}
foreach ($image in $Images) {
    if (-not (Test-Path -LiteralPath $image -PathType Leaf)) { throw "ENGINE_DAMAGE CODEC GATE FAIL: image missing: $image" }
}

$output = Get-GateScratch $repo 'engine-damage-codec'
$mirror = Copy-GateSources $repo $output @('renovice\engine_damage_builds.hpp', 'RENOVICE_TOOLCHAIN\diagnostics\verify_engine_damage_codec.cpp')
$source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\diagnostics\verify_engine_damage_codec.cpp'
$originalEnvironment = @{}
foreach ($entry in Get-ChildItem Env:) { $originalEnvironment[$entry.Name] = $entry.Value }
try {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = (& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId = (& $vswhere -latest -version '[17.0,18.0)' -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if (-not $vsPath -or -not $vsId) { throw 'Missing certified x64 MSVC tools' }
    Import-Module (Join-Path $vsPath 'Common7/Tools/Microsoft.VisualStudio.DevShell.dll')
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
    $binary = Join-Path $output 'verify_engine_damage_codec.exe'
    $object = Join-Path $output 'verify_engine_damage_codec.obj'
    & cl /nologo /std:c++20 /W4 /WX /EHsc /O2 /Fo:$object /Fe:$binary $source
    if ($LASTEXITCODE) { throw 'ENGINE_DAMAGE codec gate compilation failed' }
    $arguments = @($Images | ForEach-Object { ConvertTo-GateLongPath $_ })
    & $binary @arguments
    if ($LASTEXITCODE) { throw "ENGINE_DAMAGE codec gate failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) { Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value }
}
