$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$header = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.hpp'))
$source = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.cpp'))
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$main = [IO.File]::ReadAllText((Join-Path $repo 'main.cpp'))
$bridge = [IO.File]::ReadAllText((Join-Path $repo 'owf_scripting.cpp'))
$luau = [IO.File]::ReadAllText((Join-Path $repo 'owf_luau.hpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $a = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($a -lt 0) { throw "DE VM AUTHORITY FAIL: missing $Description start: $Start" }
    $b = $Text.IndexOf($End, $a + $Start.Length, [StringComparison]::Ordinal)
    if ($b -le $a) { throw "DE VM AUTHORITY FAIL: missing $Description end: $End" }
    return $Text.Substring($a, $b - $a)
}

foreach ($marker in @(
    'TransactionResult transact(',
    'bool restored = false;',
    'CurrentVmProtectedResult run_current_vm_protected(',
    'CurrentVmProtectedResult run_current_vm_rethrowable(',
    '[[noreturn]] void rethrow_current_vm_error(',
    'int protected_call(',
    'bool commit_flash_publication(',
    'bool transaction_active_for(',
    'bool transaction_generation_alive()'
)) {
    if (-not $header.Contains($marker)) { throw "DE VM AUTHORITY FAIL: public contract missing: $marker" }
}

foreach ($marker in @(
    'signature_lock_enter',
    'signature_lock_leave',
    'signature_locked_dispatcher',
    'signature_protected_call',
    'signature_raw_protected_run',
    'signature_vm_throw',
    'signature_flash_shutdown',
    'dispatcher.add(26).rip()',
    'dispatcher.add(40).rip()',
    'dispatcher_enter != enter.as<void*>()',
    'flash_shutdown_hook.create();',
    'flash_shutdown_hook.enable();',
    'authority_ready.store(true',
    'raw_protected_run = raw_pcall.as<RawProtectedRun>();',
    'vm_throw = throw_error.as<VmThrow>();',
    'raw_protected_run = nullptr;',
    'vm_throw = nullptr;',
    'close_generation("FlashMgr.Shutdown.exact-object")',
    'RENOVICE.DE_VM_AUTHORITY.host.v109',
    'root_host_closure(',
	'stock_flash_shutdown_will_teardown(',
	'internal_owner_offset = 0xC8',
    'resource_offset = 0x10',
    'resource_reference_count_offset = 0x0C',
    'resource == flash_null_sentinel',
    'reference_count < 2',
    'shutdown.add(0x2A).rip()',
    'flash_null_sentinel = shutdown_null_sentinel;',
    'flash_null_sentinel = nullptr;',
    'current == object'
)) {
    if (-not $source.Contains($marker)) { throw "DE VM AUTHORITY FAIL: exact-build primitive missing: $marker" }
}

# 2026-09-29 (Hotfix 44.0.2): ScriptMgr lock thunks resolve by exact identity
# (thunk body + named KERNEL32 IAT slot), cross-checked against the locked
# dispatcher's enter call and leave tail-jump. Neighbour-function prologue bytes
# must never again be part of a lock signature: the linker moves them per build.
$core = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority_core.hpp'))
foreach ($marker in @(
    'signature_lock_thunk[] =',
    '"48 8B 09 48 8B 09 48 FF 25 ? ? ? ?";',
    'lock_import_module[] = "KERNEL32.dll";',
    'signature_lock_enter_import[] = "EnterCriticalSection";',
    'signature_lock_leave_import[] = "LeaveCriticalSection";',
    'signature_locked_dispatcher_epilogue[] =',
    'inline std::uint32_t find_import_slot_rva(',
    'return matches == 1 ? found : 0;'
)) {
    if (-not $core.Contains($marker)) { throw "DE VM AUTHORITY FAIL: lock identity data missing: $marker" }
}
foreach ($marker in @(
    '#include "de_vm_authority_core.hpp"',
    'soup::Pointer resolve_lock_thunk(',
    'find_import_slot_rva(',
    'count < lock_thunk_scan_capacity && matches == 1',
    'resolve_lock_thunk(',
    'signature_locked_dispatcher_epilogue',
    'dispatcher_leave != leave.as<void*>()'
)) {
    if (-not $source.Contains($marker)) { throw "DE VM AUTHORITY FAIL: lock identity resolution missing: $marker" }
}
foreach ($forbidden in @('48 FF 25 ? ? ? ? CC', 'signature_lock_enter_u44', 'signature_lock_leave_u44')) {
    if ($source.Contains($forbidden) -or $core.Contains($forbidden)) {
        throw "DE VM AUTHORITY FAIL: lock signature depends on linker-neighbour bytes: $forbidden"
    }
}

$stockPredicate = Get-Region $source 'bool stock_flash_shutdown_will_teardown(' 'soup::Pointer resolve_unique(' 'stock Flash teardown predicate'
foreach ($marker in @(
    'readable_committed_range(owner_slot, sizeof(void*))',
    'readable_committed_range(owner, sizeof(void*))',
    'if (owned_resource == nullptr) return false;',
    'readable_committed_range(resource_slot, sizeof(void*))',
    'if (resource == flash_null_sentinel) return true;',
    'readable_committed_range(',
    'reference_count_slot, sizeof(std::uint32_t)',
    'return reference_count < 2;'
)) {
    if (-not $stockPredicate.Contains($marker)) { throw "DE VM AUTHORITY FAIL: stock Flash predicate invariant missing: $marker" }
}
$ownerPredicate = $stockPredicate.IndexOf('if (owned_resource == nullptr) return false;', [StringComparison]::Ordinal)
$resourcePredicate = $stockPredicate.IndexOf('if (resource == flash_null_sentinel) return true;', [StringComparison]::Ordinal)
$referencePredicate = $stockPredicate.IndexOf('return reference_count < 2;', [StringComparison]::Ordinal)
if ($ownerPredicate -lt 0 -or $resourcePredicate -le $ownerPredicate -or $referencePredicate -le $resourcePredicate) {
    throw 'DE VM AUTHORITY FAIL: stock Flash teardown predicate order drifted from exact 0x510180 branch'
}

$initialise = Get-Region $source 'bool initialise(' 'bool ready()' 'authority initialization'
$sentinelResolve = $initialise.IndexOf('shutdown.add(0x2A).rip()', [StringComparison]::Ordinal)
$sentinelCommit = $initialise.IndexOf('flash_null_sentinel = shutdown_null_sentinel;', [StringComparison]::Ordinal)
$shutdownEnable = $initialise.IndexOf('flash_shutdown_hook.enable();', [StringComparison]::Ordinal)
if ($sentinelResolve -lt 0 -or $sentinelCommit -le $sentinelResolve -or $shutdownEnable -le $sentinelCommit) {
    throw 'DE VM AUTHORITY FAIL: Flash null sentinel is not resolved and committed before shutdown hook enable'
}

$protectedRoot = Get-Region $source 'void root_host_closure_protected(' 'bool root_host_closure(' 'protected host-root body'
foreach ($marker in @(
    'injection::reserve_game_vm_stack(state, 2)',
    'luau_pushcclosurek(',
    'luau_pushstring(',
    'luau_settable(',
    'luau_gettable('
)) {
    if (-not $protectedRoot.Contains($marker)) { throw "DE VM AUTHORITY FAIL: protected host-root operation missing: $marker" }
}
if (-not $protectedRoot.Contains('luau_settable(state, -10000);') -or
    -not $protectedRoot.Contains('luau_gettable(state, -10000);') -or
    $protectedRoot.Contains('luau_settable(state, -10002);') -or
    $protectedRoot.Contains('luau_gettable(state, -10002);')) {
    throw 'DE VM AUTHORITY FAIL: protected host closure is not rooted and read back from the DE registry'
}

$rawFrameRecovery = Get-Region $source `
    'struct RawVmFrameSnapshot' `
    'void* lock_holder = nullptr;' `
    'raw protected VM activation recovery'
foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<RawVmFrameSnapshot>);',
    'bool capture_raw_vm_frame(',
    'state->intop > state->outtop',
    'state->outtop > state->ci->top',
    'frame_offset % sizeof(luau_CallInfo) != 0',
    'bool restore_raw_vm_frame(',
    'state->ci = frame;',
    'state->intop = luau_restorestack(state, snapshot.intop_offset);',
    'state->outtop = luau_restorestack(state, snapshot.outtop_offset);',
    'frame->top = luau_restorestack(state, snapshot.frame_top_offset);'
)) {
    if (-not $rawFrameRecovery.Contains($marker)) {
        throw "DE VM AUTHORITY FAIL: raw protected activation recovery missing: $marker"
    }
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::lock_guard', 'Scoped',
    'catch', 'throw', ' new ', ' delete '
)) {
    if ($rawFrameRecovery.Contains($forbidden)) {
        throw "DE VM AUTHORITY FAIL: raw protected activation recovery owns forbidden state: $forbidden"
    }
}

$rootWrapper = Get-Region $source 'bool root_host_closure(' 'struct LockLease' 'protected host-root wrapper'
foreach ($marker in @(
    'raw_protected_run(',
    '&root_host_closure_protected',
    'capture_raw_vm_frame(state, frame_snapshot)',
    'restore_raw_vm_frame(state, frame_snapshot)',
    'if (status != 0 || !context.exact) return false;'
)) {
    if (-not $rootWrapper.Contains($marker)) { throw "DE VM AUTHORITY FAIL: host-root protection invariant missing: $marker" }
}
foreach ($forbidden in @(
    'luau_pushcclosurek(',
    'luau_pushstring(',
    'luau_settable(',
    'luau_gettable('
)) {
    if ($rootWrapper.Contains($forbidden)) { throw "DE VM AUTHORITY FAIL: throwing host-root API remains outside raw protection: $forbidden" }
}
$rawRun = $rootWrapper.IndexOf('raw_protected_run(', [StringComparison]::Ordinal)
$stackRestore = $rootWrapper.IndexOf('restore_raw_vm_frame(state, frame_snapshot)', [StringComparison]::Ordinal)
$statusGate = $rootWrapper.IndexOf('if (status != 0 || !context.exact) return false;', [StringComparison]::Ordinal)
if ($rawRun -lt 0 -or $stackRestore -le $rawRun -or $statusGate -le $stackRestore) {
    throw 'DE VM AUTHORITY FAIL: host-root stack/status restoration is not ordered after raw protection'
}

$publication = Get-Region $source 'bool commit_flash_publication(' 'TransactionResult transact(' 'Flash publication transaction'
$publicationLock = $publication.IndexOf('lock_enter(lock_holder);', [StringComparison]::Ordinal)
$publicationRoot = $publication.IndexOf('root_host_closure(state, host_callback, next_host)', [StringComparison]::Ordinal)
if (($publicationLock -lt 0) -or ($publicationRoot -le $publicationLock) -or (-not $publication.Contains('LockLease publication_lock{true};'))) {
    throw 'DE VM AUTHORITY FAIL: Flash publication root is not owned by the ScriptMgr lock'
}

$shutdown = Get-Region $source 'void flash_shutdown_detour(' 'struct LockLease' 'Flash shutdown detour'
$stockOwnerGate = $shutdown.IndexOf('stock_flash_shutdown_will_teardown(object)', [StringComparison]::Ordinal)
$closeGeneration = $shutdown.IndexOf('close_generation("FlashMgr.Shutdown.exact-object")', [StringComparison]::Ordinal)
$stockShutdown = $shutdown.IndexOf('original(object)', [StringComparison]::Ordinal)
if ($stockOwnerGate -lt 0 -or $closeGeneration -le $stockOwnerGate -or
    $stockShutdown -le $closeGeneration) {
    throw 'DE VM AUTHORITY FAIL: Flash admission must close before stock teardown'
}

$transaction = Get-Region $source 'TransactionResult transact(' 'CurrentVmProtectedResult run_current_vm_protected(' 'owned transaction'
foreach ($marker in @(
    'lock_enter(lock_holder);',
    'LockLease lock{true};',
    'owner_thread != GetCurrentThreadId()',
    'state->global_state != global_state',
    'state->ci != state->base_ci',
    'in_flight.fetch_add(1',
    'published_generation.load(std::memory_order_acquire) != generation',
    'ThreadTransaction transaction(state, generation);',
	'const auto value = body(state, context);',
	'const bool generation_survived = transaction_generation_alive()',
	'if (generation_survived)',
	'result.executed = true;'
)) {
    if (-not $transaction.Contains($marker)) { throw "DE VM AUTHORITY FAIL: transaction invariant missing: $marker" }
}
$bodyCall = $transaction.IndexOf('const auto value = body(state, context);', [StringComparison]::Ordinal)
$survivalCheck = $transaction.IndexOf('const bool generation_survived', [StringComparison]::Ordinal)
$successCommit = $transaction.IndexOf('result.executed = true;', [StringComparison]::Ordinal)
if ($bodyCall -lt 0 -or $survivalCheck -le $bodyCall -or $successCommit -le $survivalCheck) {
    throw 'DE VM AUTHORITY FAIL: transaction success commits before post-body generation validation'
}
if (-not $source.Contains('if (owned && lock_leave != nullptr) lock_leave(lock_holder);')) {
    throw 'DE VM AUTHORITY FAIL: ScriptMgr lock does not have unconditional RAII release'
}

$currentVmRunner = Get-Region $source `
    'CurrentVmProtectedResult run_current_vm_protected(' `
    'CurrentVmProtectedResult run_current_vm_rethrowable(' `
    'current-VM raw protected runner'
foreach ($marker in @(
    'raw_protected_run(state, body, context)',
    'transaction_depth != 0 && !transaction_active_for(state)',
    'result.admitted = true;',
    'capture_raw_vm_frame(state, frame_snapshot)',
    'result.restored = restore_raw_vm_frame(state, frame_snapshot);'
)) {
    if (-not $currentVmRunner.Contains($marker)) {
        throw "DE VM AUTHORITY FAIL: current-VM raw runner invariant missing: $marker"
    }
}

$rethrowableRunner = Get-Region $source `
    'CurrentVmProtectedResult run_current_vm_rethrowable(' `
    'int protected_call(' `
    'rethrowable current-VM raw protected runner'
foreach ($marker in @(
    'raw_protected_run(state, body, context)',
    'capture_raw_vm_frame(state, frame_snapshot)',
    'if (result.status == 0)',
    'result.restored = restore_raw_vm_frame(state, frame_snapshot);',
    '[[noreturn]] void rethrow_current_vm_error(',
    'vm_throw(state, status);'
)) {
    if (-not $rethrowableRunner.Contains($marker)) {
        throw "DE VM AUTHORITY FAIL: exact rethrow runner invariant missing: $marker"
    }
}
$rethrowRawAt = $rethrowableRunner.IndexOf(
    'raw_protected_run(state, body, context)', [StringComparison]::Ordinal)
$rethrowStatusAt = $rethrowableRunner.IndexOf(
    'if (result.status == 0)', [StringComparison]::Ordinal)
$rethrowRestoreAt = $rethrowableRunner.IndexOf(
    'result.restored = restore_raw_vm_frame(state, frame_snapshot);', [StringComparison]::Ordinal)
$exactThrowAt = $rethrowableRunner.IndexOf(
    'vm_throw(state, status);', [StringComparison]::Ordinal)
if ($rethrowRawAt -lt 0 -or $rethrowStatusAt -le $rethrowRawAt -or
    $rethrowRestoreAt -le $rethrowStatusAt -or $exactThrowAt -le $rethrowRestoreAt) {
    throw 'DE VM AUTHORITY FAIL: exact rethrow boundary ordering drifted'
}
if ($rethrowableRunner.Contains('else') -and
    $rethrowableRunner.Contains('restore_raw_vm_frame(state, frame_snapshot)')) {
    throw 'DE VM AUTHORITY FAIL: rethrow path may restore the stock error TValue before propagation'
}
foreach ($forbidden in @(
    'std::lock_guard', 'std::string', 'std::vector', 'config::',
    'conout', 'catch'
)) {
    if ($rethrowableRunner.Contains($forbidden)) {
        throw "DE VM AUTHORITY FAIL: exact rethrow runner owns forbidden state: $forbidden"
    }
}
$currentRawAt = $currentVmRunner.IndexOf(
    'raw_protected_run(state, body, context)', [StringComparison]::Ordinal)
$currentRestoreAt = $currentVmRunner.IndexOf(
    'result.restored = restore_raw_vm_frame(state, frame_snapshot);', [StringComparison]::Ordinal)
if ($currentRawAt -lt 0 -or $currentRestoreAt -le $currentRawAt) {
    throw 'DE VM AUTHORITY FAIL: current-VM activation restore does not follow raw protection'
}
foreach ($forbidden in @(
    'std::lock_guard', 'std::string', 'std::vector', 'config::',
    'conout', 'catch', 'throw'
)) {
    if ($currentVmRunner.Contains($forbidden)) {
        throw "DE VM AUTHORITY FAIL: current-VM raw runner owns forbidden state: $forbidden"
    }
}

$setByHash = Get-Region $main 'static void lua_set_global_by_hash_detour' 'static DetourHook lua_set_global_hook' 'hashed publication hook'
$setByName = Get-Region $main 'static void lua_set_global_detour' 'void populate_autostart_scripts' 'named publication hook'
foreach ($hook in @($setByHash, $setByName)) {
    $stock = $hook.IndexOf('lua_set_global', [StringComparison]::Ordinal)
    $commit = $hook.LastIndexOf('commit_flash_publication', [StringComparison]::Ordinal)
    if ($stock -lt 0 -or $commit -lt 0 -or $commit -le $stock) {
        throw 'DE VM AUTHORITY FAIL: gFlashMgr publication is not committed after the stock setter'
    }
}

$application = Get-Region $main 'static bool game_application_frame_detour(' 'static bool try_install_game_application_frame_hook(' 'Application clock'
foreach ($marker in @(
    'renovice::de_vm_authority::transact(',
    '&run_openwf_frame_transaction',
    'transaction.executed',
    'transaction.generation'
)) {
    if (-not $application.Contains($marker)) { throw "DE VM AUTHORITY FAIL: Application transaction missing: $marker" }
}
if ($application.Contains('tick_openwf_scripts_at_native_frame(')) {
    throw 'DE VM AUTHORITY FAIL: Application clock directly invokes Pluto without protected DE host frame'
}

$protectedHost = Get-Region $main 'static int run_openwf_frame_transaction(' 'using game_application_frame_t' 'protected Pluto host'
foreach ($marker in @(
    'transaction_active_for(L)',
    'renovice::de_vm_authority::push_host_closure(L)',
    'renovice::de_vm_authority::protected_call(',
    'StackRestore'
)) {
    if (-not $protectedHost.Contains($marker)) { throw "DE VM AUTHORITY FAIL: protected host invariant missing: $marker" }
}

$pushHost = Get-Region $source 'bool push_host_closure(' 'bool transaction_active_for(' 'reserved host-closure append'
if (-not $pushHost.Contains('append_game_vm_stack_value_reserved(state, host_closure)') -or
    $pushHost.Contains('append_game_vm_stack_value(state, host_closure)') -or
    $pushHost.Contains('check_stack')) {
    throw 'DE VM AUTHORITY FAIL: host closure append can still grow or error outside the protected call'
}

$protectedOperation = Get-Region $bridge `
    'bool run_protected_game_vm_operation(' `
    'std::string protected_game_vm_error(' `
    'protected game VM operation'
foreach ($marker in @(
    '!valid_game_vm_stack_window(state)',
    '(current_frame - frame_begin) % sizeof(luau_CallInfo) != 0',
    'state->stack_last - state->outtop < required',
    'state->ci->top - state->outtop < required',
    'push_host_closure(state)'
)) {
    if (-not $protectedOperation.Contains($marker)) {
        throw "DE VM AUTHORITY FAIL: protected operation CallInfo capacity proof missing: $marker"
    }
}
$stackWindow = Get-Region $bridge `
    'bool valid_game_vm_stack_window(' `
    'bool game_vm_slot_index_to_offset(' `
    'common game VM stack-window validator'
foreach ($marker in @(
    'state->ci == nullptr',
    'state->base_ci == nullptr',
    'state->end_ci == nullptr',
    'state->ci->top == nullptr',
    'outtop <= frame_top',
    'frame_top <= stack_last'
)) {
    if (-not $stackWindow.Contains($marker)) {
        throw "DE VM AUTHORITY FAIL: common CallInfo validation missing: $marker"
    }
}
$frameCapacityAt = $protectedOperation.IndexOf(
    'state->ci->top - state->outtop < required', [StringComparison]::Ordinal)
$hostPushAt = $protectedOperation.IndexOf(
    'push_host_closure(state)', [StringComparison]::Ordinal)
if ($frameCapacityAt -lt 0 -or $hostPushAt -le $frameCapacityAt) {
    throw 'DE VM AUTHORITY FAIL: host closure can be pushed before current CallInfo capacity is proven'
}

$reservedAppend = Get-Region $injection `
    'bool append_game_vm_stack_value_reserved(' `
    'void maybe_wrap_global(' `
    'reserved no-growth append'
foreach ($marker in @(
    'state->ci == nullptr',
    'state->ci->top == nullptr',
    'state->ci->top > state->stack_last',
    'state->outtop >= state->ci->top'
)) {
    if (-not $reservedAppend.Contains($marker)) {
        throw "DE VM AUTHORITY FAIL: reserved append lacks current CallInfo gate: $marker"
    }
}
if ($reservedAppend.Contains('check_stack(')) {
    throw 'DE VM AUTHORITY FAIL: reserved append can grow or raise outside protection'
}

$ivkrCall = Get-Region $bridge 'OWF_SET_GLOBAL(L, "ivkr_push_value");' 'OWF_SET_GLOBAL(L, "ivkr_get_top");' 'ivkr_call bridge'
foreach ($marker in @(
    'valid_game_vm_stack_window(luau_L)',
    'ProtectedGameVmOperationKind::push_closure',
    'run_protected_game_vm_operation(',
    'std::memmove(call_base + 1, call_base,',
    'renovice::de_vm_authority::protected_call(',
    'transaction_generation_alive()',
    'call_base = luau_restorestack(luau_L, base_offset);'
)) {
    if (-not $ivkrCall.Contains($marker)) { throw "DE VM AUTHORITY FAIL: protected ivkr_call invariant missing: $marker" }
}
if ($ivkrCall.Contains('f(luau_L)') -or $bridge.Contains('luauD_call(luau_L')) {
    throw 'DE VM AUTHORITY FAIL: raw borrowed-state call path remains'
}

$callback = Get-Region $bridge 'int invoke_openwf_callback_owned(' 'bool queue_deferred_game_registry_release(' 'owned callback'
foreach ($marker in @(
    'std::lock_guard owner_lock(running_scripts_mtx);',
    'CallbackContextRestore',
    'previous_callback_context',
    'transaction_generation_id()',
    'lua_pcall(script->main, 2, 1, 0)',
    'lua_settop(script->main, original_top)',
    'luau_L = state;'
)) {
    if (-not $callback.Contains($marker)) { throw "DE VM AUTHORITY FAIL: callback ownership invariant missing: $marker" }
}
if (-not $bridge.Contains('renovice::de_vm_authority::transact(')) {
    throw 'DE VM AUTHORITY FAIL: DE callback does not enter the shared authority transaction'
}
if (-not $bridge.Contains('call_top = luau_restorestack(luau_L, call_top_offset)')) {
    throw 'DE VM AUTHORITY FAIL: ivkr_call2 retains a raw stack pointer across protected execution'
}
if (-not $luau.Contains('using luauD_call_t = void(*)(luau_State* L, luau_TValue* func, int nresults);')) {
    throw 'DE VM AUTHORITY FAIL: luauD_call ABI is not the verified void return type'
}

Write-Host 'DE VM AUTHORITY PASS clock=Application ownership=ScriptMgr generation=Flash protected-call=DE callback-owner=retained raw-current-vm=destructor-free-leaf-only'
