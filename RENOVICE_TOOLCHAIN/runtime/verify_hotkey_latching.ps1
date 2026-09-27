$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$main = [System.IO.File]::ReadAllText((Join-Path $repo 'main.cpp'))
$header = [System.IO.File]::ReadAllText((Join-Path $repo 'owf_hotkeys.hpp'))
$source = [System.IO.File]::ReadAllText((Join-Path $repo 'owf_hotkeys.cpp'))

function Get-Region([string]$Text, [string]$Start, [string]$End, [string]$Name) {
    $a = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($a -lt 0) { throw "$Name start marker missing: $Start" }
    $b = $Text.IndexOf($End, $a + $Start.Length, [StringComparison]::Ordinal)
    if ($b -le $a) { throw "$Name end marker missing: $End" }
    return $Text.Substring($a, $b - $a)
}

foreach ($marker in @(
    'poll_openwf_hotkey_inputs(bool input_allowed) noexcept',
    'pop_latched_openwf_hotkey_script(std::string& script) noexcept',
    'openwf_hotkey_edges_captured() noexcept',
    'openwf_hotkey_scripts_dispatched() noexcept',
    'openwf_hotkey_edges_dropped() noexcept',
    'openwf_hotkey_scripts_pending() noexcept'
)) {
    if (-not $header.Contains($marker)) { throw "Hotkey latch contract missing: $marker" }
}

foreach ($marker in @(
    'constexpr std::size_t max_latched_hotkey_scripts = 64;',
    'if (!hotkeys_mtx.tryLock()) return;',
    'const bool pressed = hk.isPressed();',
    'const bool just_pressed = pressed && !hk.was_pressed;',
    'hk.was_pressed = pressed;',
    'if (!input_allowed || !just_pressed) continue;',
    'latched_hotkey_edges_captured.fetch_add(1',
    'latched_hotkey_edges_dropped.fetch_add(1'
)) {
    if (-not $source.Contains($marker)) { throw "Process hotkey capture invariant missing: $marker" }
}

$poll = Get-Region $source 'void poll_openwf_hotkey_inputs(' 'bool pop_latched_openwf_hotkey_script(' 'process hotkey poll'
foreach ($forbidden in @('start_script_from_string(', 'start_script_from_file(', 'luau_', 'ivkr_')) {
    if ($poll.Contains($forbidden)) { throw "Process hotkey poll performs VM/script work: $forbidden" }
}

$detour = Get-Region $main 'static bool game_application_frame_detour(' 'static bool try_install_game_application_frame_hook(' 'Application detour'
$pollAt = $detour.IndexOf('poll_openwf_hotkey_inputs(')
$transactionAt = $detour.IndexOf('renovice::de_vm_authority::transact(')
if ($pollAt -lt 0 -or $transactionAt -lt 0 -or $pollAt -gt $transactionAt) {
    throw 'Process-owned hotkey edge is not captured before the owner-checked UI transaction'
}
if (-not $detour.Contains('foreground_pid == GetCurrentProcessId()') -or
    -not $detour.Contains('active_input_filter_allows_hotkeys') -or
    -not $detour.Contains('!prohibit_scripts')) {
    throw 'Hotkey capture no longer honors focus, input filter, and script prohibition'
}

$tickDeclaration = $main.IndexOf('static int tick_openwf_scripts_at_native_frame(')
$tickDefinition = $main.IndexOf('static int tick_openwf_scripts_at_native_frame(', $tickDeclaration + 1)
if ($tickDefinition -lt 0) { throw 'Safe Pluto dispatch definition is missing' }
$tickEnd = $main.IndexOf('struct OpenWfFrameTransaction', $tickDefinition)
if ($tickEnd -le $tickDefinition) { throw 'Safe Pluto dispatch end marker is missing' }
$tick = $main.Substring($tickDefinition, $tickEnd - $tickDefinition)
foreach ($marker in @(
    'pop_latched_openwf_hotkey_script(latched_hotkey_script)',
    'start_script_from_string(latched_hotkey_script);',
    'note_openwf_hotkey_script_dispatched();',
    'dispatched != 8'
)) {
    if (-not $tick.Contains($marker)) { throw "Safe hotkey dispatch invariant missing: $marker" }
}
foreach ($forbidden in @('GetAsyncKeyState(', 'hk.wasJustPressed()', 'GetForegroundWindow()')) {
    if ($tick.Contains($forbidden)) { throw "Key-edge capture still depends on an idle UI VM: $forbidden" }
}

foreach ($field in @(
    'openwf_hotkey_edges_captured',
    'openwf_hotkey_scripts_dispatched',
    'openwf_hotkey_edges_dropped',
    'openwf_hotkey_scripts_pending'
)) {
    if (-not $main.Contains("obj.add(`"$field`"")) { throw "Hotkey status field missing: $field" }
}

Write-Host 'HOTKEY LATCH PASS capture=process-application-frame dispatch=owner-checked-pluto queue=64 dispatch-per-tick=8 status=visible'
