$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$mainPath = Join-Path $repo 'main.cpp'
$injectionPath = Join-Path $repo 'renovice\injection.cpp'
$configPath = Join-Path $repo 'renovice\config.cpp'
$headerPath = Join-Path $repo 'renovice\injection.hpp'
$bgscriptPath = Join-Path $repo 'OpenWF\bgscript.pluto'

$main = [System.IO.File]::ReadAllText($mainPath)
$injection = [System.IO.File]::ReadAllText($injectionPath)
$config = [System.IO.File]::ReadAllText($configPath)
$header = [System.IO.File]::ReadAllText($headerPath)
$apiFrame = [System.IO.File]::ReadAllText((Join-Path $repo 'renovice\vm_api_frame.hpp'))
foreach ($marker in @('frame_offset_', 'limit_offset_', 'state_->base_ci',
    'state_->stack', 'frame->top = limit', 'frame == state_->ci')) {
    if (-not $apiFrame.Contains($marker)) { throw "VM API frame restoration missing: $marker" }
}
foreach ($marker in @('protected_lua_call_phase_callback', 'RENOVICE_LuaCallHostFrame_V95',
    'protected_callback_call(state, 0, 0, 0, "luaCalls.host-frame")',
    'context.stock_base_offset', 'target_lua_arguments_captured = true',
    'capacity-restore=all-48-api-owners')) {
    if (-not $injection.Contains($marker)) { throw "Protected Lua host frame missing: $marker" }
}
if ($apiFrame.Contains('state_->intop =') -or $apiFrame.Contains('state->intop =')) {
    throw 'VM API frame guard must not invent a base outside native CallInfo ownership'
}
if ([regex]::Matches($injection, 'ScopedVmApiFrame frame_capacity\(state\);').Count -ne 52) {
    throw 'Expected all 49 temporary reservation owners plus protected host entry, argument-root release, and diagnostic-root release'
}

foreach ($marker in @(
    'scripts_directory / L"Logs"',
    'scripts_directory / L"Diagnostics"',
    'logs_directory / L"renovice_source.log"'
)) {
    if (-not $config.Contains($marker)) {
        throw "Generated-output directory marker missing from config.cpp: $marker"
    }
}

$requiredMain = @(
    'drain_renovice_transactions_at_de_vm_return',
    'tick_openwf_scripts_at_native_frame',
    'game_application_frame_detour',
    'start_game_application_frame_hook_installer',
    'capture_openwf_ui_state',
    'openwf_ui_state_is_idle',
    'L->ci != L->base_ci',
    'OpenWF native-frame Pluto scheduler FIRST PASS',
    'renovice::application_frame::select_unique_profile',
    'renovice::application_frame::current_u43_pattern',
    'bgscript->tick()',
    'set_safe_runtime_tick',
    'poll_openwf_script_controls',
    'set_safe_runtime_control_poll'
)
foreach ($marker in $requiredMain) {
    if (-not $main.Contains($marker)) {
        throw "Safe runtime tick marker missing from main.cpp: $marker"
    }
}

$requiredInjection = @(
    'OpenWF\\CustomScripts\\Logs\\renovice_fault.log',
    'OpenWF\\CustomScripts\\Diagnostics\\renovice_fault.dmp',
    'RENOVICE ADDON_TRACE build=V79',
    'RENOVICE TRACE build=V79',
    'RENOVICE NATIVE_INGRESS build=V79',
    'mode=outer-vm-return',
    'captured_global_state',
    'safe_runtime_tick_running',
    'safe_runtime_transaction_should_run',
    'runtime_work_pending()',
    'safe_runtime_tick_boundary_blocker',
    'inspect_lua_mutation_boundary',
    'RENOVICE reload DEFERRED boundary=lua-mutation-host',
    'ScopedVmExecutionDepth',
    'ScopedSafeRuntimeTick',
    'RENOVICE reload DEFERRED boundary=outer-vm-return',
    'reload_pending()',
    'safe_runtime_control_poll_ready',
    'maybe_poll_runtime_controls',
    'RENOVICE F9 latch registered: Lua-free owner-thread VM returns',
    'RENOVICE pending-only transaction drain registered',
    'idle_vm_generation_work_allowed',
    'maintain_current_vm_generation',
    'RENOVICE Scripts UI bridge REBOUND',
    'RENOVICE target addon _T generation CHANGE'
)
foreach ($marker in $requiredInjection) {
    if (-not $injection.Contains($marker)) {
        throw "Safe runtime tick marker missing from injection.cpp: $marker"
    }
}

foreach ($marker in @(
    'safe_runtime_tick_should_run',
    'previous_safe_runtime_tick_ms',
    'safe_runtime_tick_followup_required',
    'RENOVICE safe runtime tick FOLLOW-UP reason=pending-request-during-active-tick',
    'vm_generation_maintenance_interval_ms',
    'previous_vm_generation_maintenance_ms'
)) {
    if ($injection.Contains($marker)) {
        throw "Rejected same-tick follow-up scheduler returned: $marker"
    }
}

if (-not $header.Contains('using SafeRuntimeTick')) {
    throw 'Safe runtime tick callback contract is missing from injection.hpp'
}
if (-not $header.Contains('bool runtime_work_pending() noexcept;')) {
    throw 'Pending-only transaction authorization is missing from injection.hpp'
}

$expectedBgscriptHash = 'DC072A9E16937160A4F7DD6AB9A8B89077E3BE137362263ABF813282A2FDD015'
if (-not (Test-Path -LiteralPath $bgscriptPath -PathType Leaf)) {
    throw "Upstream OpenWF background script is missing: $bgscriptPath"
}
$actualBgscriptHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bgscriptPath).Hash
if ($actualBgscriptHash -ne $expectedBgscriptHash) {
    throw "OpenWF background script differs from the pinned upstream 0.13.6 LF-normalized source: $actualBgscriptHash"
}

$plutoStart = $main.IndexOf('static void tick_openwf_scripts_at_native_frame')
$plutoEnd = $main.IndexOf('static void poll_openwf_script_controls', $plutoStart)
$plutoCallback = if ($plutoStart -ge 0 -and $plutoEnd -gt $plutoStart) {
    $main.Substring($plutoStart, $plutoEnd - $plutoStart)
} else { '' }
foreach ($marker in @(
    'luau_L = L;',
    'bgscript->tick()',
    '(*i)->tick()',
    'game_application_frame_og(application)',
    'openwf_ui_state_is_idle(L)',
    'VmContextRestore',
    'InterlockedCompareExchangePointer'
)) {
    if (-not $plutoCallback.Contains($marker)) {
        throw "Native-frame UI-VM Pluto scheduler marker is missing: $marker"
    }
}
foreach ($marker in @(
    'renovice::injection::drain(',
    'renovice::injection::poll_f9(',
    'renovice::injection::request_reload('
)) {
    if ($plutoCallback.Contains($marker)) {
        throw "RENOVICE transaction work leaked into the native-frame UI-VM Pluto scheduler: $marker"
    }
}

foreach ($marker in @(
    'UpdateFlashMarkers',
    'lua_LotusHudStatus_UpdateFlashMarkers'
)) {
    if ($main.Contains($marker)) {
        throw "Rejected Lua method-table scheduler returned to main.cpp: $marker"
    }
}

$callbackStart = $main.IndexOf('static void drain_renovice_transactions_at_de_vm_return')
$callbackEnd = $main.IndexOf('template <typename T>', $callbackStart)
$callback = if ($callbackStart -ge 0 -and $callbackEnd -gt $callbackStart) {
    $main.Substring($callbackStart, $callbackEnd - $callbackStart)
} else { '' }
if (-not $callback.Contains('renovice::injection::drain(L);')) {
    throw 'The pending-only callback does not drain the RENOVICE transaction'
}
foreach ($marker in @(
    'bgscript',
    'running_scripts',
    'luau_L =',
    'raise_script_error_fp',
    'panic_func',
    'hotkeys'
)) {
    if ($callback.Contains($marker)) {
        throw "Legacy OpenWF scheduler work remains in the DE VM return callback: $marker"
    }
}

$forbidden = @(
    'lua_runtime_reload_boundary_hook',
    'lua_runtime_reload_boundary_detour'
)
foreach ($marker in $forbidden) {
    if ($main.Contains($marker)) {
        throw "Rejected RENOVICE reload-boundary hook is still present: $marker"
    }
}

if ($main -match '\*\s*method_pointer\s*=') {
    throw 'The reload boundary must not replace the native method-table entry'
}

$runGuardedStart = $injection.IndexOf('RunResult run_guarded(')
$runGuardedEnd = $injection.IndexOf('bool lifecycle_operation(', $runGuardedStart)
$runGuarded = if ($runGuardedStart -ge 0 -and $runGuardedEnd -gt $runGuardedStart) {
    $injection.Substring($runGuardedStart, $runGuardedEnd - $runGuardedStart)
} else { '' }
if ($runGuarded.IndexOf('require_stack(state, 8);') -lt 0 -or
    $runGuarded.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);') -lt 0 -or
    $runGuarded.IndexOf('require_stack(state, 8);') -gt
        $runGuarded.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);')) {
    throw 'run_guarded must reserve stack capacity before capturing its relocation-safe stack offset'
}

$lifecycleStart = $injection.IndexOf('bool lifecycle_operation(')
$lifecycleEnd = $injection.IndexOf('bool read_loader_name_handle(', $lifecycleStart)
$lifecycle = if ($lifecycleStart -ge 0 -and $lifecycleEnd -gt $lifecycleStart) {
    $injection.Substring($lifecycleStart, $lifecycleEnd - $lifecycleStart)
} else { '' }
if ($lifecycle.IndexOf('inspect_lua_mutation_boundary(state)') -lt 0 -or
    $lifecycle.IndexOf('inspect_lua_mutation_boundary(state)') -gt
        $lifecycle.IndexOf('require_stack(state, 4);')) {
    throw 'lifecycle_operation must reject an unsafe coroutine before touching its stack'
}
if ($lifecycle.IndexOf('require_stack(state, 4);') -lt 0 -or
    $lifecycle.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);') -lt 0 -or
    $lifecycle.IndexOf('require_stack(state, 4);') -gt
        $lifecycle.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);')) {
    throw 'lifecycle_operation must reserve stack capacity before capturing its relocation-safe stack offset'
}

# The native reservation returns int. V93 preserves the existing ordering
# checks while requiring rejection before a failed reservation can be written.
foreach ($marker in @(
    'using CheckStack = int(*)(luau_State* state, int slots);',
    '!check_stack(state, slots)',
    'checked_stack_append(*state, value,',
    'signature_gc_barrierback_u43',
    'gc_barrierback == nullptr',
    'prepare_stack_write(state)'
)) {
    if (-not $injection.Contains($marker)) { throw "VM stack contract missing: $marker" }
}
if ($injection -match '\*state->outtop\+\+\s*=') {
    throw 'Raw TValue appends must use the shared checked GC publication helper'
}

foreach ($marker in @(
    'diagnostic_snapshot_work_allowed(flags.diagnostics_mode, used, flags.diagnostics_max_events)',
    'const bool observer_capacity = diagnostic_snapshot_capacity_available(flags);',
    'const bool caster_selected = observer_capacity &&',
    'bool automatic_selected = observer_capacity &&',
    'const bool buffs_selected = observer_capacity &&',
    '|| !diagnostic_snapshot_capacity_available(flags)',
    'observer-work-suppressed reason=output-budget-exhausted'
)) {
    if (-not $injection.Contains($marker)) { throw "Pre-allocation diagnostic admission missing: $marker" }
}

$safeTickStart = $injection.IndexOf('void maybe_run_safe_runtime_tick(')
$safeTickEnd = $injection.IndexOf('bool run_chunk(', $safeTickStart)
$safeTick = if ($safeTickStart -ge 0 -and $safeTickEnd -gt $safeTickStart) {
    $injection.Substring($safeTickStart, $safeTickEnd - $safeTickStart)
} else { '' }
if ($safeTick.IndexOf('inspect_lua_mutation_boundary(state)') -lt 0 -or
    $safeTick.IndexOf('inspect_lua_mutation_boundary(state)') -gt
        $safeTick.IndexOf('ScopedSafeRuntimeTick runtime_tick_scope;')) {
    throw 'The pending transaction must wait for a mutation-safe native host frame'
}

$runChunkDeclaration = $injection.IndexOf('bool run_chunk(', $runGuardedEnd)
$runChunkStart = $injection.IndexOf('bool run_chunk(', $runChunkDeclaration + 1)
$runChunkEnd = $injection.IndexOf('bool activate_target_addons(', $runChunkStart)
$runChunk = if ($runChunkStart -ge 0 -and $runChunkEnd -gt $runChunkStart) {
    $injection.Substring($runChunkStart, $runChunkEnd - $runChunkStart)
} else { '' }
if ($runChunk.IndexOf('inspect_lua_mutation_boundary(boundary_state)') -lt 0 -or
    $runChunk.IndexOf('inspect_lua_mutation_boundary(boundary_state)') -gt
        $runChunk.IndexOf('game_allocate(chunk.bytes.size(), 0)')) {
    throw 'run_chunk must reject an unsafe coroutine before allocation or loader execution'
}

$drainStart = $injection.IndexOf('void drain(luau_State* state)')
$drainEnd = $injection.IndexOf('bool drain_requested(', $drainStart)
$drain = if ($drainStart -ge 0 -and $drainEnd -gt $drainStart) {
    $injection.Substring($drainStart, $drainEnd - $drainStart)
} else { '' }
if ($drain.IndexOf('inspect_lua_mutation_boundary(state)') -lt 0 -or
    $drain.IndexOf('inspect_lua_mutation_boundary(state)') -gt
        $drain.IndexOf('f9_pending.exchange(false')) {
    throw 'drain must preserve the F9 latch until a mutation-safe coroutine is available'
}

foreach ($marker in @(
    'const auto base_offset = luau_savestack(state, base);',
    'state->outtop = luau_restorestack(state, saved_top_offset);',
    'assigned_slot = luau_restorestack(state, assigned_slot_offset);'
)) {
    if (-not $injection.Contains($marker)) {
        throw "VM stack relocation guard missing: $marker"
    }
}

foreach ($marker in @(
    'push_environment_table(state, target_environment, base)',
    'target-environment-dispatcher.install'
)) {
    if (-not $injection.Contains($marker)) {
        throw "Exact target-environment dispatcher marker missing: $marker"
    }
}
if ($injection.Contains('target-registry-dispatcher.install')) {
    throw 'The disproven global-only target dispatcher is still active'
}

Write-Host "SAFE RUNTIME TICK SOURCE PASS renovice_pending_only=yes native_application_frame_pluto=yes stock_UpdateFlashMarkers=yes upstream_bgscript_sha256=$actualBgscriptHash renovice_drain_in_pluto_tick=no exact_ui_vm=yes owner_thread=yes idle_base_ci=yes recursion_guard=scoped f9_latch_any_owner_vm=yes explicit_reload_unthrottled=yes blocked_reason_diagnostics=yes exact_T_rebind=yes"

if ($runGuarded.Contains('guard.base =') -or -not $runGuarded.Contains('RENOVICE.guarded-module-original') -or -not $injection.Contains('luau_restorestack(guard.state, guard.base_offset)')) { throw 'Guard must use relocation-safe addresses and keep the displaced original GC-rooted' }
