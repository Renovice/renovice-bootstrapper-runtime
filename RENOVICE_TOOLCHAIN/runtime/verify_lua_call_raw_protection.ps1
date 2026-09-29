$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$authorityHeader = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.hpp'))
$authoritySource = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.cpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $startIndex = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) { throw "LUA CALL RAW PROTECTION FAIL: missing $Description start" }
    $endIndex = $Text.IndexOf($End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -le $startIndex) { throw "LUA CALL RAW PROTECTION FAIL: missing $Description end" }
    $Text.Substring($startIndex, $endIndex - $startIndex)
}

foreach ($marker in @(
    'using CurrentVmProtectedBody = void(*)(luau_State* state, void* context);',
    'struct CurrentVmProtectedResult',
    'bool restored = false;',
    'CurrentVmProtectedResult run_current_vm_protected('
)) {
    if (-not $authorityHeader.Contains($marker)) {
        throw "LUA CALL RAW PROTECTION FAIL: authority declaration missing: $marker"
    }
}

$authorityRunner = Get-Region $authoritySource `
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
    if (-not $authorityRunner.Contains($marker)) {
        throw "LUA CALL RAW PROTECTION FAIL: authority runner marker missing: $marker"
    }
}
$runnerRawAt = $authorityRunner.IndexOf(
    'raw_protected_run(state, body, context)', [StringComparison]::Ordinal)
$runnerRestoreAt = $authorityRunner.IndexOf(
    'result.restored = restore_raw_vm_frame(state, frame_snapshot);', [StringComparison]::Ordinal)
if ($runnerRawAt -lt 0 -or $runnerRestoreAt -le $runnerRawAt) {
    throw 'LUA CALL RAW PROTECTION FAIL: current-VM activation restore does not follow the raw runner'
}
foreach ($forbidden in @(
    'std::lock_guard', 'std::string', 'std::vector', 'std::shared_ptr',
    'config::', 'conout', 'catch', 'throw'
)) {
    if ($authorityRunner.Contains($forbidden)) {
        throw "LUA CALL RAW PROTECTION FAIL: authority runner owns forbidden state: $forbidden"
    }
}

$leaf = Get-Region $injection `
    '// BEGIN LUA_CALL_BEFORE_PROTECTED_LEAF' `
    '// END LUA_CALL_BEFORE_PROTECTED_LEAF' `
    'destructor-free luaCalls.before leaf'
foreach ($marker in @(
    'void lua_call_before_protected_leaf(luau_State* state, void* raw_context)',
    'luau_createtable(',
    'luau_gettable(',
    'luau_settable(',
    'getfield(',
    'protected_call(state, 4, 0, 0)',
    'context->completed = true;'
)) {
    if (-not $leaf.Contains($marker)) {
        throw "LUA CALL RAW PROTECTION FAIL: protected leaf marker missing: $marker"
    }
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::deque', 'std::lock_guard',
    'std::shared_ptr', 'std::unique_ptr', 'Scoped', 'config::', 'conout',
    'ostringstream', 'catch', 'throw', ' new ', ' delete ',
    'hook_addons_snapshot', 'target_diagnostic_trace_callback_value',
    'lua_call_hook_value', 'call_value(', 'protected_callback_call(',
    'require_stack(', 'push_stack_value(', 'table_set_array_value(',
    'table_get_array_value('
)) {
    if ($leaf.Contains($forbidden)) {
        throw "LUA CALL RAW PROTECTION FAIL: protected leaf owns/calls forbidden construct: $forbidden"
    }
}

# Read-back must never overwrite a view table (live run 2026-09-29: reading the
# argument table from a top one slot above it reused the upvalue table's slot, so
# upvalue read-back indexed the last argument -> "stage=read-upvalue index=0"
# DE errors and nil "mutation rejected upvalue=1").
foreach ($marker in @(
    'bool lua_call_before_leaf_get_array_at(',
    'lua_call_before_leaf_push_value(state, table)',
    'luau_gettable(state, -2);',
    'if (!is_table(table.type)) return false;',
    'lua_call_before_leaf_get_array_at(state, arguments_table_offset,',
    'lua_call_before_leaf_get_array_at(state, upvalues_table_offset,'
)) {
    if (-not $leaf.Contains($marker)) {
        throw "LUA CALL RAW PROTECTION FAIL: non-clobbering view read-back marker missing: $marker"
    }
}
foreach ($removed in @(
    'state->outtop = luau_restorestack(state, arguments_table_offset) + 1;',
    'bool lua_call_before_leaf_get_array('
)) {
    if ($leaf.Contains($removed)) {
        throw "LUA CALL RAW PROTECTION FAIL: view read-back can overwrite the upvalue table: $removed"
    }
}
$readArgumentsAt = $leaf.IndexOf('LuaCallBeforeLeafStage::read_argument;', [StringComparison]::Ordinal)
$readArgumentsTop = $leaf.IndexOf('state->outtop = luau_restorestack(state, upvalues_table_offset) + 1;', $readArgumentsAt, [StringComparison]::Ordinal)
$readArgumentsCall = $leaf.IndexOf('lua_call_before_leaf_get_array_at(state, arguments_table_offset,', $readArgumentsAt, [StringComparison]::Ordinal)
if ($readArgumentsAt -lt 0 -or $readArgumentsTop -lt 0 -or $readArgumentsCall -le $readArgumentsTop) {
    throw 'LUA CALL RAW PROTECTION FAIL: argument read-back does not keep the top above both view tables'
}

if (-not $injection.Contains(
    'static_assert(std::is_trivially_copyable_v<LuaCallBeforeLeafContext>);')) {
    throw 'LUA CALL RAW PROTECTION FAIL: leaf context is not statically constrained to POD storage'
}
foreach ($removed in @(
    'LuaCallPhaseContext',
    'lua_call_phase_context',
    'dispatch_lua_call_phase_impl(',
    'protected_lua_call_phase_callback(',
    'RENOVICE_LuaCallHostFrame_V95'
)) {
    if ($injection.Contains($removed)) {
        throw "LUA CALL RAW PROTECTION FAIL: old rich protected-callback path remains: $removed"
    }
}

$dispatch = Get-Region $injection `
    'bool dispatch_lua_call_phase(' `
    'bool dispatch_native_call_phase(' `
    'luaCalls.before outer orchestrator'
foreach ($marker in @(
    'hook_addons_snapshot(',
    'struct ScopedLuaCallHook',
    'std::lock_guard execution_lock(lua_execution_mutex);',
    'ScopedExecutionDepth execution_depth;',
    'std::vector<const char*> provider_registry_keys;',
    'std::vector<luau_TValue> stock_upvalues;',
    'std::vector<luau_TValue> candidate_arguments(arguments.size());',
    'ScopedVmApiFrame frame_capacity(state);',
    'ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);',
    'de_vm_authority::run_current_vm_protected(',
    '!protected_result.restored',
    'state->intop = luau_restorestack(state, original_intop_offset);',
    'state->outtop = luau_restorestack(state, base_offset);',
    'frame_capacity.restore();',
    'exact_frame_return',
    'exact_frame_limit',
    'target_lua_argument_mutation_allowed(',
    'target_lua_scalar_mutation_allowed(',
    '*live_upvalue_slots[index] = candidate_upvalues[index];',
    'live_argument_base[index] = candidate_arguments[index];'
)) {
    if (-not $dispatch.Contains($marker)) {
        throw "LUA CALL RAW PROTECTION FAIL: outer orchestrator marker missing: $marker"
    }
}

$rawCallAt = $dispatch.IndexOf(
    'de_vm_authority::run_current_vm_protected(', [StringComparison]::Ordinal)
$restoreTopAt = $dispatch.IndexOf(
    'state->outtop = luau_restorestack(state, base_offset);', [StringComparison]::Ordinal)
$restoreFrameAt = $dispatch.IndexOf(
    'frame_capacity.restore();', [StringComparison]::Ordinal)
$validateAt = $dispatch.IndexOf(
    'target_lua_argument_mutation_allowed(', [StringComparison]::Ordinal)
$commitAt = $dispatch.IndexOf(
    '*live_upvalue_slots[index] = candidate_upvalues[index];', [StringComparison]::Ordinal)
if ($rawCallAt -lt 0 -or $restoreTopAt -le $rawCallAt -or
    $restoreFrameAt -le $restoreTopAt -or $validateAt -le $restoreFrameAt -or
    $commitAt -le $validateAt) {
    throw 'LUA CALL RAW PROTECTION FAIL: raw-run, stack-restore, validate, commit ordering changed'
}
if (-not $dispatch.Contains('std::strcmp(phase, "before") != 0')) {
    throw 'LUA CALL RAW PROTECTION FAIL: unimplemented luaCalls.after can enter the before-only leaf'
}

Write-Host 'LUA CALL RAW PROTECTION PASS raw-runner=exact leaf=destructor-free outer-ownership=retained relocation-restore=yes mutation=two-phase old-host-closure=absent'
