# Deterministic gates for the generic multi-target target-addon primitive
# (2026-09-29). Offline only: compiles a fixture with the DE Luau toolchain,
# runs the loader's own discovery code on it, and pins the source-level
# invariants of the protected selection leaf and the scanner. It never reads
# or writes a game folder.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$injectionDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $injectionDir
$repo = Split-Path -Parent $toolchainDir
$deToolchain = [IO.Path]::GetFullPath((Join-Path $repo '..\..\toolchains\de-luau-toolchain\bin'))
$binaryDir = Join-Path $toolchainDir "bin\injection"
New-Item -ItemType Directory -Path $binaryDir -Force | Out-Null

function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "MULTI-TARGET GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "MULTI-TARGET GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}

# 1. Real DE bytecode fixture through the loader's own discovery code.
$fixtureSource = Join-Path $injectionDir 'fixtures\MultiTargetFixture.targets.addon.luau'
$fixture = Join-Path $binaryDir 'MultiTargetFixture.targets.addon.u44.lua_B'
& (Join-Path $deToolchain 'derecomp.exe') recompile-u44 $fixtureSource $fixture
if ($LASTEXITCODE) { throw 'MULTI-TARGET GATE FAIL: fixture U44 compilation failed' }
& (Join-Path $deToolchain 'derecomp.exe') de-roundtrip $fixture
if ($LASTEXITCODE) { throw 'MULTI-TARGET GATE FAIL: fixture container roundtrip failed' }
$probeSource = Join-Path $injectionDir 'fixtures\MultiTargetProbe.targets.addon.luau'
$probe = Join-Path $binaryDir 'MultiTargetProbe.targets.addon.lua_B'
& (Join-Path $deToolchain 'derecomp.exe') recompile-u44 $probeSource $probe
if ($LASTEXITCODE) { throw 'MULTI-TARGET GATE FAIL: live-probe U44 compilation failed' }
& (Join-Path $deToolchain 'derecomp.exe') de-roundtrip $probe
if ($LASTEXITCODE) { throw 'MULTI-TARGET GATE FAIL: live-probe container roundtrip failed' }

$originalEnvironment = @{}
foreach ($entry in Get-ChildItem Env:) { $originalEnvironment[$entry.Name] = $entry.Value }
try {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
        throw "Visual Studio 2022 x64 C++ tools were not found"
    }
    Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
    $source = Join-Path $injectionDir 'verify_multi_target_addon.cpp'
    $binary = Join-Path $binaryDir 'verify_multi_target_addon.exe'
    $object = Join-Path $binaryDir 'verify_multi_target_addon.obj'
    $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /Fo:$object /Fe:$binary $source 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $output | Write-Output
    if ($LASTEXITCODE -ne 0) { throw "MULTI-TARGET GATE FAIL: checker compilation failed: $LASTEXITCODE" }
    & $binary $fixture
    if ($LASTEXITCODE -ne 0) { throw "MULTI-TARGET GATE FAIL: fixture checker failed: $LASTEXITCODE" }
    & $binary $probe
    if ($LASTEXITCODE -ne 0) { throw "MULTI-TARGET GATE FAIL: live-probe checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 2. Source invariants of the loader integration.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$scriptControl = [IO.File]::ReadAllText((Join-Path $repo 'renovice\script_control.cpp'))

$leaf = Get-Region $injection '// BEGIN GUARDED_RUN_PROTECTED_LEAF' '// END GUARDED_RUN_PROTECTED_LEAF' 'guarded module-load leaf'
$select = Get-Region $leaf '// MULTI_TARGET_SELECTION' 'guard.stage = 5;' 'multi-target selection block'
Require ($leaf.IndexOf('// MULTI_TARGET_SELECTION', [StringComparison]::Ordinal) -lt $leaf.IndexOf('guard.stage = 7;', [StringComparison]::Ordinal)) 'selection runs inside the protected leaf before the lifecycle root is stored'
Require ($select.Contains('context->multi_target_key != nullptr')) 'selection is inert for every single-key and non-target chunk'
Require ($select.Contains('classify_multi_target_selection(')) 'leaf uses the unit-tested selection model'
Require ($select.Contains('getfield(state, -1, context->multi_target_key);')) 'binding selects targets[exact key text]'
Require ($select.Contains('*(guard_base() + 1) = *(guard_base() + 3);') -and $select.Contains('gc_barrierback(state,')) 'selected entry replaces the container slot behind the GC write barrier'
foreach ($forbidden in @('std::string', 'std::vector', 'std::lock_guard', 'Scoped', 'conout', 'config::', 'catch (', ' new ', ' delete ', 'throw')) {
    Require ($select.IndexOf($forbidden, [StringComparison]::Ordinal) -lt 0) "selection block is destructor-free and non-throwing: no $forbidden"
}
$slots = @([regex]::Matches($select, 'guard_base\(\) \+ ([0-9]+)') | ForEach-Object { [int]$_.Groups[1].Value })
Require ($slots.Count -gt 0 -and (@($slots | Where-Object { $_ -gt 7 }).Count -eq 0)) 'selection stays inside the check_stack(state, 8) reservation'

$scanStart = $injection.IndexOf('bool scan_snapshot(', [StringComparison]::Ordinal)
$scanEnd = $injection.IndexOf('template <typename Function>', $scanStart, [StringComparison]::Ordinal)
$scan = $injection.Substring($scanStart, $scanEnd - $scanStart)
Require ($scan.Contains('discover_multi_target_keys(bytes.data(), bytes.size(), declared)')) 'scanner inventories declared keys from bytecode'
Require ($scan.IndexOf('target_keys.insert(target_keys.end(), declared.begin(), declared.end());', [StringComparison]::Ordinal) -lt $scan.IndexOf('if (!policy_enabled) continue;', [StringComparison]::Ordinal)) 'declared keys are inventoried before enable policy'
Require ($scan.Contains('scope=file-local generation=continues')) 'a malformed multi-target file fails locally instead of rejecting the generation'
Require ($scan.Contains('chunk.multi_target = true;') -and $scan.Contains('chunk.target_key = key;')) 'each declared key becomes one ordinary target-managed binding'

$activateStart = $injection.IndexOf("bool activate_target_addons_locked(`n`tstd::uint64_t target_key,`n`tluau_State* state,`n`tvoid* manager,`n`tconst std::uint32_t* name_handle,`n`tbool current_thread_borrows_generation,", [StringComparison]::Ordinal)
if ($activateStart -lt 0) { throw 'MULTI-TARGET GATE FAIL: activate_target_addons_locked definition not found' }
$activateEnd = $injection.IndexOf('bool activate_target_addons(', $activateStart, [StringComparison]::Ordinal)
$activate = $injection.Substring($activateStart, $activateEnd - $activateStart)
Require ($activate.Contains('chunk->multi_target ? multi_target_key_text : nullptr')) 'only multi-target bindings request targets[key] selection'
Require ($activate.Contains('format_target_key_text(target_key, multi_target_key_text);')) 'selection key text is the exact bound module key'

Require ($scriptControl.Contains('injection::is_multi_target_addon(info.filename)') -and $scriptControl.Contains('injection::discover_multi_target_keys(')) 'Scripts menu summarizes one row per multi-target file from the same inventory'

Write-Output "MULTI-TARGET ADDON GATES PASS"
