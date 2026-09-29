# Offline gate for the optional internal settings bridges (2026-09-30).
#
# - ScriptSettingsBridgeV1.luau (SCRIPT SETTINGS editor, shipped with the main DLL)
# - ScriptSettingsProbeP0.luau  (Phase 0 UI probe, loaded ONLY by a
#   -SettingsProbeP0 diagnostic build)
#
# Each bridge is compiled with the U44 profile (the same command that
# reproduces the installed U44 SCRIPTS bridge byte for byte), round-tripped,
# checked against the Warframe API contracts, and pinned for the stock calls
# its design depends on. The runtime side is pinned too: the bridges are
# optional, loaded after the managed transaction, and the probe is only
# admitted by the probe build.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$workspaceRepos = Split-Path -Parent (Split-Path -Parent $repo)
$toolchain = Join-Path $workspaceRepos "toolchains\de-luau-toolchain"
$derecomp = Join-Path $toolchain "bin\derecomp.exe"
$apiChecker = Join-Path $toolchain "check_ability_api.bat"
$internal = Join-Path $repo "RENOVICE_SCRIPTING\INTERNAL"

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "SCRIPT SETTINGS BRIDGE GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}

$bridges = @(
    @{
        Source = 'ScriptSettingsProbeP0.luau'
        Output = '_RENOVICE_INTERNAL_ScriptSettingsProbeP0.lua_B'
        Required = $true
        Pins = @(
            'openProbe = openProbe',
            'openProbeFromHotkey = openProbeFromHotkey',
            'movie:Execute("SetConfirmButtonVisibleWhenInactive", "true")',
            'movie:Execute("SetConfirmButtonActive", "true")',
            'movie:Execute("ShowHideSearchBox", "true")',
            'parentMovie:PushChildMovie(settingsResource)',
            'local open = _T.OpenScreen',
            'mOnValidateSetting',
            'movie:Execute("FinishSelection", "")'
        )
        Forbidden = @('io.', 'os.', 'loadstring', 'ScriptStates', 'Settings/')
    },
    @{
        Source = 'ScriptSettingsBridgeV1.luau'
        Output = '_RENOVICE_INTERNAL_ScriptSettingsBridgeV1.lua_B'
        Required = $true
        Pins = @(
            'openScriptSettings = openScriptSettings',
            'child:Execute("SetConfirmButtonVisibleWhenInactive", "true")',
            'child:Execute("SetConfirmButtonActive", "true")',
            'lotusUtilities.CHECKBOX',
            'lotusUtilities.INPUTCOUNT',
            'lotusUtilities.INPUTBOX',
            'lotusUtilities.TOGGLE',
            'lotusUtilities.BUTTON',
            'lotusUtilities.TITLE',
            'lotusUtilities.SPACER'
        )
        Forbidden = @('io.', 'os.', 'loadstring', 'SLIDER')
    }
)

foreach ($required in @($derecomp, $apiChecker)) {
    Require (Test-Path -LiteralPath $required -PathType Leaf) "toolchain present: $required"
}

$built = 0
foreach ($bridge in $bridges) {
    $source = Join-Path $internal $bridge.Source
    $output = Join-Path $internal $bridge.Output
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        if ($bridge.Required) { throw "SCRIPT SETTINGS BRIDGE GATE FAIL: missing $source" }
        Write-Output "SKIP`t$($bridge.Source) not present in this revision"
        continue
    }
    $text = [IO.File]::ReadAllText($source)
    foreach ($pin in $bridge.Pins) {
        Require ($text.Contains($pin)) "$($bridge.Source) keeps: $pin"
    }
    foreach ($forbidden in $bridge.Forbidden) {
        Require (-not $text.Contains($forbidden)) "$($bridge.Source) never uses: $forbidden"
    }
    Require (-not [regex]::IsMatch($text, 'Execute\("[A-Za-z]+"\)')) "$($bridge.Source) calls Execute with the two-argument stock form only"

    & $derecomp recompile-u44 $source $output
    if ($LASTEXITCODE -ne 0) { throw "SCRIPT SETTINGS BRIDGE GATE FAIL: U44 compile failed: $($bridge.Source)" }
    & $derecomp de-roundtrip $output
    if ($LASTEXITCODE -ne 0) { throw "SCRIPT SETTINGS BRIDGE GATE FAIL: byte-exact roundtrip failed: $($bridge.Output)" }
    $resolvedSource = (Resolve-Path -LiteralPath $source).Path
    $apiOutput = @(& $apiChecker $resolvedSource --show-unknown 2>&1 | ForEach-Object { $_.ToString() })
    $apiExit = $LASTEXITCODE
    $apiOutput | Write-Output
    Require ($apiExit -eq 0) "$($bridge.Source) passes the Warframe API contract check (0 violations)"
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $output).Hash
    $size = (Get-Item -LiteralPath $output).Length
    Write-Output "BRIDGE`t$($bridge.Output) bytes=$size sha256=$hash"
    $built++
}

# Runtime-side pins: optional, capability-local, probe build only.
$core = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection_core.hpp'))
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
Require ($core.Contains('|| (kind == InternalChunk::SettingsProbeP0 && settings_probe_build);')) 'the probe bridge is admitted only by a probe build'
Require ($injection.Contains("#if defined(RENOVICE_SETTINGS_PROBE_P0)`nconstexpr bool settings_probe_build = true;")) 'probe admission is a compile-time switch'
$reconcile = $injection.IndexOf('reconcile_optional_bridges_locked(state, optional_bridges);', [StringComparison]::Ordinal)
$scriptsFlag = $injection.IndexOf('return is_internal_scripts_ui_bridge(chunk.name);', $injection.IndexOf('bool apply_generation(', [StringComparison]::Ordinal), [StringComparison]::Ordinal)
$commit = $injection.IndexOf('active_chunks = candidate;', $injection.IndexOf('bool apply_generation(', [StringComparison]::Ordinal), [StringComparison]::Ordinal)
Require ($reconcile -gt $commit -and $reconcile -gt $scriptsFlag) 'optional bridges are reconciled only after the managed generation commits'
Require ($injection.Contains('scope=capability-local generation=continues')) 'an optional bridge failure is logged as capability-local'
$scan = $injection.Substring($injection.IndexOf('// BEGIN OPTIONAL_INTERNAL_BRIDGE_SCAN', [StringComparison]::Ordinal))
$scan = $scan.Substring(0, $scan.IndexOf('// END OPTIONAL_INTERNAL_BRIDGE_SCAN', [StringComparison]::Ordinal))
Require ($scan.Contains('continue;') -and -not $scan.Contains('snapshot.emplace_back')) 'reserved internal files never enter the ordinary Inject lanes'
Require ($injection.Contains('"RENOVICE Script Settings row append ")')) 'the second pause-menu row reports its own PASS/FAIL'

# SCRIPT SETTINGS host (main build only; the probe build carries the probe row).
$hostStart = $injection.IndexOf('// BEGIN SCRIPT_SETTINGS_HOST', [StringComparison]::Ordinal)
$hostEnd = $injection.IndexOf('// END SCRIPT_SETTINGS_HOST', [StringComparison]::Ordinal)
Require ($hostStart -ge 0 -and $hostEnd -gt $hostStart) 'SCRIPT SETTINGS host block present'
$hostBlock = $injection.Substring($hostStart, $hostEnd - $hostStart)
Require ($hostBlock.Contains('#if !defined(RENOVICE_SETTINGS_PROBE_P0)')) 'the diagnostic probe build never carries the editor'
Require ($injection.Contains('if (!script_settings_row_available()) return false;')) 'SCRIPT SETTINGS row only with a committed bridge and declared settings'
Require ($hostBlock.Contains('request_reload("Script settings applied");') -and -not $hostBlock.Contains('apply_generation(')) 'changes apply only through the ordinary F9 transaction'
Require ($hostBlock.Contains('settings_ui::stage(') -and $hostBlock.Contains('if (depth != 1)')) 'clicks and child closes only stage; the root close applies'
Require ($hostBlock.Contains('staged=discarded') -and $hostBlock.Contains('owning-vm-changed')) 'a VM change or a malformed completion discards the session (fail closed)'
$pageLeafStart = $injection.IndexOf('// BEGIN SCRIPT_SETTINGS_PAGE_PROTECTED_LEAF', [StringComparison]::Ordinal)
$pageLeafEnd = $injection.IndexOf('// END SCRIPT_SETTINGS_PAGE_PROTECTED_LEAF', [StringComparison]::Ordinal)
$pageLeaf = $injection.Substring($pageLeafStart, $pageLeafEnd - $pageLeafStart)
foreach ($forbidden in @('std::string', 'std::vector', 'std::lock_guard', 'std::shared_ptr', 'std::ostringstream', 'config::', 'conout', 'catch (', ' new ', ' delete ')) {
    Require (-not $pageLeaf.Contains($forbidden)) "page leaf is destructor-free: no $forbidden"
}
Require ($injection.Contains('static_assert(std::is_trivially_copyable_v<SettingsPageLeafContext>);') -and $injection.Contains('static_assert(std::is_trivially_copyable_v<SettingsRowView>);')) 'page leaf contexts are POD'
Require (-not $injection.Contains('Pluto') -or $hostBlock.IndexOf('pluto', [StringComparison]::OrdinalIgnoreCase) -lt 0) 'no Pluto involvement in the editor host'

Write-Output "SCRIPT SETTINGS BRIDGES PASS built=$built"
