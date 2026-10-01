# Deterministic gates for ADDON_SETTINGS_V1, `member:` states and the SCRIPT
# SETTINGS page model (2026-09-30). Offline only: builds the exact
# renovice/packages.cpp scanner plus settings_core.hpp / settings_ui_core.hpp
# with stub providers, runs it on a temporary CustomScripts tree in the gate
# scratch folder (gate_paths.ps1, long-path safe), then pins the runtime
# integration in injection.cpp, replacements.cpp and script_control.cpp. It
# never reads or writes a game folder.
#
# -Package <folder>[,<folder>...] [-Settings <file>[,<file>...]]: additionally
# run real package folders (package.json plus member files) and, optionally,
# their values files (same order; '' = none) through the same scanner, the
# settings evaluation, the deliveries and the SCRIPT SETTINGS page model, and
# print every reachable page and row (PAGEDUMP/PAGEROW), the navigation tree
# (TREE) and the flat page (PAGE/ROW/VALROW). Each values file is copied to
# Settings\<package folder>.json in the temporary tree.
#
# -Tape <plan> (with -Package): R7 host tape for the stock render harness
# (verify_script_settings_render.ps1): the pages after every planned host call
# and the EXPECTFILE/EXPECTROW checks of the plan.
param(
    [string[]]$Package = @(),
    [string[]]$Settings = @(),
    [string]$Tape = '',
    # With -Tape: the U44 stock corpus; EXPECTPLAN then also synthesizes each planned module (R9).
    [string]$Corpus = '',
    # R13: -ScriptStates <ScriptStates.json> (with -Package) replays an installed
    # policy file (read-only copy); every delivered value must reach a staged member.
    [string]$ScriptStates = ''
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$settingsDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $settingsDir
$repo = Split-Path -Parent $toolchainDir
. (Join-Path $toolchainDir 'gate_paths.ps1')
# A child "powershell -File" call passes one string: entries may also be joined with ';'.
$Package = @($Package | ForEach-Object { $_ -split ';' } | Where-Object { $_ -ne '' })
$Settings = @($Settings | ForEach-Object { $_ -split ';' })
if ($Package.Count -eq 0 -and $Settings.Count -gt 0) {
    throw "ADDON SETTINGS GATE FAIL: -Settings requires -Package"
}
if ($Settings.Count -gt $Package.Count) { throw "ADDON SETTINGS GATE FAIL: more -Settings than -Package entries" }
if ($Tape -ne '' -and $Package.Count -eq 0) { throw "ADDON SETTINGS GATE FAIL: -Tape requires -Package" }
$scratch = Get-GateScratch $repo 'addon-settings'

function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "ADDON SETTINGS GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "ADDON SETTINGS GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}

# 1. Pure rules + the real scanner end to end (MSVC /W4 /WX, like the build).
$work = ConvertTo-GateLongPath (Join-Path $scratch 'work')
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
    # cl.exe compiles short copies (the repository may be deeper than MAX_PATH).
    $mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\settings\verify_addon_settings.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\settings\verify_addon_settings.cpp'
    $scanner = Join-Path $mirror 'renovice\packages.cpp'
    $literals = Join-Path $mirror 'renovice\live_literals.cpp' # LIVE_LITERALS_V1: packages.cpp attaches recipes
    $binary = Join-Path $scratch 'verify_addon_settings.exe'
    $objects = Join-Path $scratch 'obj'
    New-Item -ItemType Directory -Path $objects -Force | Out-Null
    Push-Location $objects
    try {
        $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /DRENOVICE_PACKAGES_OFFLINE_GATE /Fe:$binary $source $scanner $literals 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
        $compileExit = $LASTEXITCODE
    }
    finally { Pop-Location }
    $output | Write-Output
    if ($compileExit -ne 0) { throw "ADDON SETTINGS GATE FAIL: checker compilation failed: $compileExit" }
    $arguments = @($work, (ConvertTo-GateLongPath (Join-Path $settingsDir 'fixtures\phase2i')))
    for ($index = 0; $index -lt $Package.Count; $index++) {
        $arguments += @('--package', (ConvertTo-GateLongPath $Package[$index]))
        if ($index -lt $Settings.Count -and -not [string]::IsNullOrWhiteSpace($Settings[$index])) {
            $arguments += @('--settings', (ConvertTo-GateLongPath $Settings[$index]))
        }
    }
    if ($Tape -ne '') { $arguments += @('--tape', (ConvertTo-GateLongPath $Tape)) }
    if ($Corpus -ne '') { $arguments += @('--corpus', (ConvertTo-GateLongPath $Corpus)) }
    if ($ScriptStates -ne '') {
        if ($Package.Count -eq 0) { throw "ADDON SETTINGS GATE FAIL: -ScriptStates requires -Package" }
        $arguments += @('--script-states', (ConvertTo-GateLongPath $ScriptStates))
    }
    & $binary @arguments
    if ($LASTEXITCODE -ne 0) { throw "ADDON SETTINGS GATE FAIL: checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 2. Runtime integration pins.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$replacements = [IO.File]::ReadAllText((Join-Path $repo 'renovice\replacements.cpp'))
$scriptControl = [IO.File]::ReadAllText((Join-Path $repo 'renovice\script_control.cpp'))
$settingsCore = [IO.File]::ReadAllText((Join-Path $repo 'renovice\settings_core.hpp'))

$append = Get-Region $injection '// BEGIN PACKAGE_INJECT_MEMBERS' '// END PACKAGE_INJECT_MEMBERS' 'package Inject members'
Require ($append.IndexOf('if (!member.staged) continue;') -gt $append.IndexOf('target_keys.insert(')) 'a member held back by policy or settings stays inventoried but never staged'
Require ($append.Contains('chunk.settings = member.delivery;')) 'addon members carry their generation-owned delivery into the chunk'
$merge = Get-Region $replacements 'bool merge_package_replacements(' 'bool load_snapshot(' 'package replacement merge'
Require ($merge.IndexOf('if (!member.staged) continue;') -gt $merge.IndexOf('available_keys->emplace(member.key)')) 'replacement members: inventoried first, staged only when admitted'

$activate = Get-Region $injection 'bool activate_target_addons_locked(' 'bool activate_target_addons(' 'target addon activation'
Require ($activate.Contains('settings::target_addon_binding_reusable(')) 'identity-includes-settings: reuse requires the settings identity to match'
Require ($activate.Contains('&& current[i].settings_identity == desired_settings_identity')) 'root reactivation is not chosen across a settings change'
Require ($activate.Contains('candidate.settings_identity = chunk->settings ? chunk->settings->identity : std::string();')) 'staged bindings record their settings identity'
Require (([regex]::Matches($activate, 'lifecycle_operation\(\s*state, addon\.addon, "activate", addon\.settings\.get\(\)\)')).Count -eq 2) 'both activation paths deliver activate(context)'
Require (-not $activate.Contains('lifecycle_operation(state, addon.addon, "activate");')) 'no target-addon activation bypasses the delivery'

$leaf = Get-Region $injection '// BEGIN LIFECYCLE_OPERATION_PROTECTED_LEAF' '// END LIFECYCLE_OPERATION_PROTECTED_LEAF' 'lifecycle leaf'
Require ($leaf.Contains('setfield(state, -2, "settings");') -and $leaf.Contains('raw_table_set_bool(state, -1, "enabled", true)') -and $leaf.Contains('raw_table_set_number(state, -1, "value", entry.value)') -and $leaf.Contains('raw_table_set_number(state, -1, "stock", entry.stock)')) 'context.settings = { [id] = { enabled, value, stock } } is built inside the protected leaf'
Require ($leaf.Contains(': protected_call(state, 1, 0, 0);') -and $leaf.Contains('? protected_call(state, 0, 0, 0)')) 'activate(context) only with a delivery; plain activate() otherwise'
$outer = Get-Region $injection 'bool lifecycle_operation(luau_State* state, const AddonRecord& addon, const char* field)' 'bool read_loader_name_handle(' 'lifecycle orchestrator'
Require ($outer.Contains('return lifecycle_operation(state, addon, field, nullptr);')) 'the historical 3-argument lifecycle call delivers nothing (managed addons unchanged)'
Require ($outer.Contains('if (delivery != nullptr && field != nullptr)')) 'deliveries are copied to POD views outside the leaf'

Require ($scriptControl.Contains('if (is_member_state_id(id))') -and $scriptControl.Contains('package member does not exist or its package is invalid: ')) 'member: ids are admitted into the policy batch only for existing package members'
Require (-not $settingsCore.Contains('Missions') -and -not $settingsCore.Contains('Survival') -and -not $settingsCore.Contains('Mallet')) 'the primitive names no mission, ability or file (universal)'

Write-Output "ADDON SETTINGS GATES PASS"
