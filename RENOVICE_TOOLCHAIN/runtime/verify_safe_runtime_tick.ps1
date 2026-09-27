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
$injectionCore = [System.IO.File]::ReadAllText((Join-Path $repo 'renovice\injection_core.hpp'))
$config = [System.IO.File]::ReadAllText($configPath)
$header = [System.IO.File]::ReadAllText($headerPath)
$apiFrame = [System.IO.File]::ReadAllText((Join-Path $repo 'renovice\vm_api_frame.hpp'))
$interruptBudget = [System.IO.File]::ReadAllText((Join-Path $repo 'renovice\injected_interrupt_budget.hpp'))
$detourBase = [System.IO.File]::ReadAllText((Join-Path $repo 'modules\Soup\soup\DetourHookBase.cpp'))
foreach ($marker in @('frame_offset_', 'limit_offset_', 'state_->base_ci',
    'state_->stack', 'frame->top = limit', 'frame == state_->ci')) {
    if (-not $apiFrame.Contains($marker)) { throw "VM API frame restoration missing: $marker" }
}
foreach ($marker in @('struct LuaCallBeforeLeafContext', 'lua_call_before_protected_leaf',
    'de_vm_authority::run_current_vm_protected(',
    'context.base_offset = base_offset;', 'stock_argument_base_offset',
    'capacity-restore=all-api-owners',
    'lua-call-boundary=de-interrupt-counter-leaf-before-only')) {
    if (-not $injection.Contains($marker)) { throw "Raw-protected Lua provider phase missing: $marker" }
}
if ($apiFrame.Contains('state_->intop =') -or $apiFrame.Contains('state->intop =')) {
    throw 'VM API frame guard must not invent a base outside native CallInfo ownership'
}
$apiReservationOwnerCount = [regex]::Matches(
    $injection, 'ScopedVmApiFrame frame_capacity\(state\);').Count
if ($apiReservationOwnerCount -eq 0) {
    throw 'No current VM API reservation owners remain in the runtime'
}

# An exact file-wide owner count is brittle: adding or removing an unrelated,
# correctly scoped API helper must not weaken this gate.  Pin the property that
# matters instead: none of the rawrunprotected leaves may contain a C++ frame
# owner whose destructor a DE longjmp could skip.
foreach ($leafSpec in @(
    @('// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF', '// END LUA_CALL_BEFORE_PROTECTED_LEAF', 'luaCalls.before'),
    @('// BEGIN GUARDED_RUN_PROTECTED_LEAF', '// END GUARDED_RUN_PROTECTED_LEAF', 'guarded module run'),
    @('// BEGIN LIFECYCLE_OPERATION_PROTECTED_LEAF', '// END LIFECYCLE_OPERATION_PROTECTED_LEAF', 'addon lifecycle')
)) {
    $leafStart = $injection.IndexOf($leafSpec[0], [StringComparison]::Ordinal)
    $leafEnd = if ($leafStart -ge 0) {
        $injection.IndexOf($leafSpec[1], $leafStart + $leafSpec[0].Length,
            [StringComparison]::Ordinal)
    } else { -1 }
    if ($leafStart -lt 0 -or $leafEnd -le $leafStart) {
        throw "Missing raw-protected $($leafSpec[2]) leaf markers"
    }
    $leaf = $injection.Substring($leafStart, $leafEnd - $leafStart)
    if ($leaf.Contains('ScopedVmApiFrame')) {
        throw "C++ VM API frame owner entered raw-protected $($leafSpec[2]) leaf"
    }
}

# luaCalls.before is observed from the unique stock counter leaf reached by
# DE's negative-state interrupt callback. The leaf has a relocation-safe
# 13-byte body, unlike callback 0x197EC80's relative JNS/CALL prologue. The
# stock increment and result must be preserved exactly once before filtering.
# Failure of this optional observer must leave ordinary Inject/Replacement and
# the Scripts UI bridge enabled. Exact after-call retirement is not yet proven,
# so an after declaration must fail closed at manifest admission.
$interruptEnd = $injection.LastIndexOf('void vm_execute_detour(')
$interruptStart = if ($interruptEnd -ge 0) {
    $injection.LastIndexOf('std::uint32_t de_luau_interrupt_increment_detour(', $interruptEnd)
} else { -1 }
$interruptDetour = if ($interruptStart -ge 0 -and $interruptEnd -gt $interruptStart) {
    $injection.Substring($interruptStart, $interruptEnd - $interruptStart)
} else { '' }
foreach ($marker in @(
    'de_luau_interrupt_hook.original',
    'const auto stock_count = original(state);',
    'exact_current_lua_instruction(state, raw_instruction)',
    'decode_de_lua_call_instruction(raw_instruction, decoded, game_version >= GV(44, 0, 0))',
    'resolve_de_lua_call_window(',
    'target_provider_claims_lua_before(',
    'dispatch_lua_call_phase(',
    'state, call, "before", arguments, argument_base',
    'preserve_stock_interrupt_result(stock_count, [&]',
    'struct ScopedObserverStack',
    'luau_savestack(state, state->intop)',
    'luau_savestack(state, state->outtop)'
)) {
    if (-not $interruptDetour.Contains($marker)) {
        throw "DE interrupt luaCalls.before contract missing: $marker"
    }
}
foreach ($marker in @(
    'de_interrupt_limit_u43 = 800000',
    'static_cast<std::int32_t>(stock_count) > de_interrupt_limit_u43',
    'std::forward<Observer>(observer)();',
    'catch (...)',
    'return stock_count;'
)) {
    if (-not $injectionCore.Contains($marker)) {
        throw "Stock interrupt observer transparency contract missing: $marker"
    }
}
if ([regex]::Matches($interruptDetour, [regex]::Escape('original(state);')).Count -ne 1) {
    throw 'DE interrupt counter detour must invoke the stock leaf exactly once'
}
$originalCall = $interruptDetour.IndexOf('original(state);')
$firstObserverGate = $interruptDetour.IndexOf('if (state == nullptr')
if ($originalCall -lt 0 -or $firstObserverGate -lt 0 -or $originalCall -gt $firstObserverGate) {
    throw 'DE stock interrupt counter leaf must run before RENOVICE observer gates'
}

$installStart = $injection.IndexOf('bool install_loader_hook()')
$installEnd = $injection.IndexOf("}`r`n}`r`n`r`nbool initialise_game_vm_stack_bridge", $installStart)
if ($installEnd -lt 0) {
    $installEnd = $injection.IndexOf("}`n}`n`nbool initialise_game_vm_stack_bridge", $installStart)
}
$install = if ($installStart -ge 0 -and $installEnd -gt $installStart) {
    $injection.Substring($installStart, $installEnd - $installStart)
} else { '' }
foreach ($marker in @(
    'resolve_unique<DeLuauInterruptIncrement>',
    'signature_interrupt_increment_u43',
    'de_luau_interrupt_hook.target = reinterpret_cast<void*>(interrupt_increment)',
    'vm_execute_hook.enable();',
    'loader_hook.enable();',
    'lua_before_observer_ready.store(false',
    'de_luau_interrupt_hook.create();',
    'lua_before_observer_ready.store(true',
    'base-loader-retained=1'
)) {
    if (-not $install.Contains($marker)) {
        throw "Capability-isolated interrupt observer install missing: $marker"
    }
}
$baseCreatedCheck = 'if (!loader_hook.isCreated() || !vm_execute_hook.isCreated())'
if (-not $install.Contains($baseCreatedCheck) -or
    $install -match '!loader_hook\.isCreated\(\).*de_luau_interrupt_hook\.isCreated') {
    throw 'Nested-call observer must not be part of the mandatory base-loader created gate'
}
if (-not $injection.Contains('luaCalls-before-observer-unavailable:')) {
    throw 'luaCalls providers must reject locally when the optional observer is unavailable'
}
$expectedCounterLeaf = 'FF 81 88 00 00 00 8B 81 88 00 00 00 C3'
if (-not $interruptBudget.Contains($expectedCounterLeaf)) {
    throw 'Exact relocation-safe interrupt counter leaf signature changed'
}
foreach ($marker in @('opr.reg == soup::IP', 'opr.reg == soup::DIS',
    'Instruction interacts with instruction pointer')) {
    if (-not $detourBase.Contains($marker)) {
        throw "Soup detour relocation rejection contract changed: $marker"
    }
}
if ($install.Contains('de_luau_interrupt_hook.target = reinterpret_cast<void*>(interrupt_guard)')) {
    throw 'Relative-branch DE callback entry must never be passed to Soup DetourHook'
}
foreach ($forbiddenMarker in @(
    'RENOVICE_LuaCallArgs_',
    'lua_call_argument_registry_key',
    'target_lua_call_frame_active'
)) {
    if ($injection.Contains($forbiddenMarker)) {
        throw "Retired luaCalls ownership mechanism remains: $forbiddenMarker"
    }
}
foreach ($marker in @(
    'lua_call_request_supported(before, after)',
    'luaCalls-after-retirement-not-implemented:'
)) {
    if (-not $injection.Contains($marker)) {
        throw "Fail-closed luaCalls.after admission missing: $marker"
    }
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
    'const bool exact_idle_return = state != nullptr',
    'state->ci == state->base_ci',
    'if (!exact_idle_return) return;',
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

$plutoDeclaration = $main.IndexOf('static int tick_openwf_scripts_at_native_frame')
$plutoStart = $main.IndexOf('static int tick_openwf_scripts_at_native_frame',
    $plutoDeclaration + 1)
$plutoEnd = $main.IndexOf('struct OpenWfFrameTransaction', $plutoStart)
$plutoCallback = if ($plutoStart -ge 0 -and $plutoEnd -gt $plutoStart) {
    $main.Substring($plutoStart, $plutoEnd - $plutoStart)
} else { '' }
foreach ($marker in @(
    'luau_L = L;',
    'bgscript->tick()',
    '(*i)->tick()',
    'VmContextRestore'
)) {
    if (-not $plutoCallback.Contains($marker)) {
        throw "Protected UI-VM Pluto host marker is missing: $marker"
    }
}

$vmExecuteStart = $injection.LastIndexOf('void vm_execute_detour(luau_State* state)')
$vmExecuteEnd = $injection.IndexOf('void maybe_poll_runtime_controls()', $vmExecuteStart)
$vmExecute = if ($vmExecuteStart -ge 0 -and $vmExecuteEnd -gt $vmExecuteStart) {
    $injection.Substring($vmExecuteStart, $vmExecuteEnd - $vmExecuteStart)
} else { '' }
$stockExecute = 'reinterpret_cast<VmExecute>(vm_execute_hook.original)(state);'
$stockIndex = $vmExecute.IndexOf($stockExecute)
if ($stockIndex -lt 0) {
    throw 'Stock VM execute call missing from interpreter detour'
}
$beforeStock = $vmExecute.Substring(0, $stockIndex)
$afterStock = $vmExecute.Substring($stockIndex + $stockExecute.Length)
foreach ($forbidden in @(
    'ScopedVmExecutionDepth',
    'ScopedTargetExecution',
    'auto generation_dispatch =',
    'std::lock_guard',
    'std::unique_lock'
)) {
    # A generation snapshot may be used in an inner scope before stock, but no
    # such owner may remain lexically open at the stock boundary. The source
    # contract below additionally pins the explicit scope end immediately before
    # logging and the naked stock call.
    if ($forbidden -ne 'auto generation_dispatch =' -and $beforeStock.Contains($forbidden)) {
        throw "C++ ownership marker crosses the stock VM execute boundary: $forbidden"
    }
}
if ($vmExecute.IndexOf('all RENOVICE-owned objects and stateful markers have already been released.') -lt 0 -or
    $afterStock.IndexOf('if (!exact_idle_return) return;') -lt 0) {
    throw 'The interpreter detour must release native ownership before stock and gate post-return mutation on exact idle state'
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

$protectedHostStart = $main.IndexOf('static int run_openwf_frame_transaction')
$protectedHostEnd = $main.IndexOf('using game_application_frame_t', $protectedHostStart)
$protectedHost = if ($protectedHostStart -ge 0 -and $protectedHostEnd -gt $protectedHostStart) {
    $main.Substring($protectedHostStart, $protectedHostEnd - $protectedHostStart)
} else { '' }
foreach ($marker in @(
    'openwf_ui_state_is_idle(L)',
    'transaction_active_for(L)',
    'renovice::de_vm_authority::push_host_closure(L)',
    'renovice::de_vm_authority::protected_call('
)) {
    if (-not $protectedHost.Contains($marker)) {
        throw "Owner-locked protected Pluto host marker is missing: $marker"
    }
}

$applicationStart = $main.IndexOf('static bool game_application_frame_detour')
$applicationEnd = $main.IndexOf('static bool try_install_game_application_frame_hook', $applicationStart)
$application = if ($applicationStart -ge 0 -and $applicationEnd -gt $applicationStart) {
    $main.Substring($applicationStart, $applicationEnd - $applicationStart)
} else { '' }
foreach ($marker in @(
    'game_application_frame_og(application)',
    'poll_openwf_hotkey_inputs(',
    'renovice::de_vm_authority::transact(',
    '&run_openwf_frame_transaction',
    'OpenWF native-frame Pluto scheduler FIRST PASS'
)) {
    if (-not $application.Contains($marker)) {
        throw "Application clock transaction marker is missing: $marker"
    }
}
if ($application.Contains('tick_openwf_scripts_at_native_frame(')) {
    throw 'Application clock bypasses the protected DE host frame'
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

$runGuardedStart = $injection.IndexOf('// BEGIN GUARDED_RUN_PROTECTED_LEAF')
$runGuardedEnd = $injection.IndexOf('// END GUARDED_RUN_PROTECTED_LEAF', $runGuardedStart)
$runGuarded = if ($runGuardedStart -ge 0 -and $runGuardedEnd -gt $runGuardedStart) {
    $injection.Substring($runGuardedStart, $runGuardedEnd - $runGuardedStart)
} else { '' }
if ($runGuarded.IndexOf('check_stack(state, 8) == 0') -lt 0 -or
    $runGuarded.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);') -lt 0 -or
    $runGuarded.IndexOf('check_stack(state, 8) == 0') -gt
        $runGuarded.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);')) {
    throw 'run_guarded raw leaf must reserve stack capacity before capturing its relocation-safe stack offset'
}

$lifecycleStart = $injection.IndexOf('bool lifecycle_operation(')
$lifecycleEnd = $injection.IndexOf('bool read_loader_name_handle(', $lifecycleStart)
$lifecycle = if ($lifecycleStart -ge 0 -and $lifecycleEnd -gt $lifecycleStart) {
    $injection.Substring($lifecycleStart, $lifecycleEnd - $lifecycleStart)
} else { '' }
if ($lifecycle.IndexOf('inspect_lua_mutation_boundary(state)') -lt 0 -or
    $lifecycle.IndexOf('inspect_lua_mutation_boundary(state)') -gt
        $lifecycle.IndexOf('de_vm_authority::run_current_vm_protected(')) {
    throw 'lifecycle_operation must reject an unsafe coroutine before touching its stack'
}
$lifecycleLeafStart = $injection.IndexOf('// BEGIN LIFECYCLE_OPERATION_PROTECTED_LEAF')
$lifecycleLeafEnd = $injection.IndexOf('// END LIFECYCLE_OPERATION_PROTECTED_LEAF', $lifecycleLeafStart)
$lifecycleLeaf = if ($lifecycleLeafStart -ge 0 -and $lifecycleLeafEnd -gt $lifecycleLeafStart) {
    $injection.Substring($lifecycleLeafStart, $lifecycleLeafEnd - $lifecycleLeafStart)
} else { '' }
if ($lifecycleLeaf.IndexOf('check_stack(state, 4) == 0') -lt 0 -or
    $lifecycleLeaf.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);') -lt 0 -or
    $lifecycleLeaf.IndexOf('check_stack(state, 4) == 0') -gt
        $lifecycleLeaf.IndexOf('guard.base_offset = luau_savestack(state, state->outtop);')) {
    throw 'lifecycle_operation raw leaf must reserve stack capacity before capturing its relocation-safe stack offset'
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
$rawAppendMatches = [regex]::Matches($injection, '\*state->outtop\+\+\s*=')
$reservedAppendStart = $injection.IndexOf('bool append_game_vm_stack_value_reserved(')
$reservedAppendEnd = $injection.IndexOf('void maybe_wrap_global(', $reservedAppendStart)
$reservedAppend = if ($reservedAppendStart -ge 0 -and $reservedAppendEnd -gt $reservedAppendStart) {
    $injection.Substring($reservedAppendStart, $reservedAppendEnd - $reservedAppendStart)
} else { '' }
if ($rawAppendMatches.Count -ne 1 -or
    $reservedAppend.IndexOf('*state->outtop++ = value;') -lt 0 -or
    $reservedAppend.IndexOf('state->outtop >= state->stack_last') -lt 0 -or
    $reservedAppend.IndexOf('gc_barrierback(') -lt 0 -or
    $reservedAppend.IndexOf('check_stack(') -ge 0) {
    throw 'Raw TValue append is permitted only in the capacity-proved, barriered, no-growth helper'
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

$dispatcherInstallStart = $injection.IndexOf(
    'struct TargetHookRegistryInstallContext', [StringComparison]::Ordinal)
$dispatcherInstallEnd = $injection.IndexOf(
    'bool install_target_hook_registry_dispatcher(',
    $dispatcherInstallStart,
    [StringComparison]::Ordinal)
if ($dispatcherInstallStart -lt 0 -or $dispatcherInstallEnd -le $dispatcherInstallStart) {
    throw 'Protected target-environment dispatcher install block missing'
}
$dispatcherInstall = $injection.Substring(
    $dispatcherInstallStart, $dispatcherInstallEnd - $dispatcherInstallStart)
foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<TargetHookRegistryInstallContext>)',
    'const auto base_offset = luau_savestack(state, state->outtop);',
    'base = luau_restorestack(state, base_offset);',
    'install_target_hook_registry_dispatcher_leaf'
)) {
    if (-not $dispatcherInstall.Contains($marker)) {
        throw "Target dispatcher relocation/protection guard missing: $marker"
    }
}
if (-not $injection.Contains(
    'assigned_slot = luau_restorestack(state, assigned_slot_offset);')) {
    throw 'SETGLOBAL ability-card slot relocation guard missing'
}

foreach ($marker in @(
    'push_environment_table(state, context->target_environment, base)',
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
