$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$bridge = [IO.File]::ReadAllText((Join-Path $repo 'owf_scripting.cpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $a = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($a -lt 0) { throw "OPENWF BRIDGE BOUNDS FAIL: missing $Description start: $Start" }
    $b = $Text.IndexOf($End, $a + $Start.Length, [StringComparison]::Ordinal)
    if ($b -le $a) { throw "OPENWF BRIDGE BOUNDS FAIL: missing $Description end: $End" }
    $Text.Substring($a, $b - $a)
}

foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<ProtectedGameVmOperation>);',
    'bool readable_game_vm_memory(',
    'bool valid_game_vm_stack_window(',
    '!renovice::de_vm_authority::transaction_active_for(state)',
    'outtop <= frame_top',
    'frame_top <= stack_last',
    'bool resolve_game_vm_target_window(',
    'bool resolve_game_vm_target_value(',
    'bool resolve_game_vm_upvalue(',
    'bool project_game_vm_value(',
    'game_version >= GV(38, 5, 0)',
    'readable_game_vm_memory(second, sizeof(void*))'
)) {
    if (-not $bridge.Contains($marker)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: common validation missing: $marker"
    }
}

$runner = Get-Region $bridge `
    'bool run_protected_game_vm_operation(' `
    'std::string protected_game_vm_error(' `
    'protected operation orchestrator'
foreach ($marker in @(
    '!valid_game_vm_stack_window(state)',
    'state->outtop - state->intop < existing_operands',
    'operation.target_intop_offset = luau_savestack(state, state->intop);',
    'operation.target_outtop_offset = luau_savestack(state, state->outtop);',
    'operation.target_frame_offset =',
    'operation.target_frame_top_offset = luau_savestack(',
    'state->ci->top - state->outtop < required',
    'append_game_vm_stack_value_reserved(',
    'protected table argument publication failed',
    'protected operand publication failed',
    'const bool exact_target = resolve_game_vm_target_window(',
    'state->ci == target_frame && state->intop == target_base',
    '> state->ci->top)',
    'operation.kind == ProtectedGameVmOperationKind::set_stack_top',
    'operation.kind == ProtectedGameVmOperationKind::pop_values',
    'operation.kind == ProtectedGameVmOperationKind::set_stack_base'
)) {
    if (-not $runner.Contains($marker)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: orchestrator gate missing: $marker"
    }
}

$dispatcher = Get-Region $bridge `
    'int dispatch_openwf_protected_game_vm_operation(' `
    'std::size_t drain_deferred_game_registry_releases(' `
    'POD bridge dispatcher'
foreach ($marker in @(
    '!renovice::de_vm_authority::transaction_active_for(state)',
    '!valid_game_vm_stack_window(state)',
    'ProtectedGameVmOperationKind::stack_top',
    'ProtectedGameVmOperationKind::stack_base',
    'ProtectedGameVmOperationKind::set_stack_top',
    'ProtectedGameVmOperationKind::set_stack_base',
    'ProtectedGameVmOperationKind::pop_values',
    'ProtectedGameVmOperationKind::inspect_value',
    'ProtectedGameVmOperationKind::pop_value',
    'ProtectedGameVmOperationKind::get_upvalue',
    'ProtectedGameVmOperationKind::set_upvalue',
    'ProtectedGameVmOperationKind::registry_owner',
    'state->global_state != operation->pointer',
    '--state->outtop;'
)) {
    if (-not $dispatcher.Contains($marker)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: protected dispatcher case missing: $marker"
    }
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::deque', 'std::lock_guard',
    'std::unique_ptr', 'std::shared_ptr', 'ObfusString'
)) {
    if ($dispatcher.Contains($forbidden)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: dispatcher owns longjmp-skipped C++ state: $forbidden"
    }
}

$stackBindings = Get-Region $bridge `
    'OWF_SET_GLOBAL(L, "ivkr_call");' `
    'OWF_SET_GLOBAL(L, "ivkr_gettable");' `
    'stack/upvalue/type bridge bindings'
foreach ($marker in @(
    'ProtectedGameVmOperationKind::stack_top',
    'ProtectedGameVmOperationKind::set_stack_top',
    'ProtectedGameVmOperationKind::stack_base',
    'ProtectedGameVmOperationKind::set_stack_base',
    'ProtectedGameVmOperationKind::pop_values',
    'ProtectedGameVmOperationKind::pop_value',
    'ProtectedGameVmOperationKind::inspect_value',
    'ProtectedGameVmOperationKind::get_upvalue',
    'ProtectedGameVmOperationKind::set_upvalue',
    'ProtectedGameVmValueProjection::userdata_payload',
    'ProtectedGameVmValueProjection::object_pointer',
    'ProtectedGameVmValueProjection::c_function'
)) {
    if (-not $stackBindings.Contains($marker)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: protected binding missing: $marker"
    }
}
foreach ($forbidden in @(
    'luau_L->outtop[-', '--luau_L->outtop', 'luau_L->outtop -=',
    'luau_L->getValue(', 'luau_L->outtop =', 'luau_L->intop ='
)) {
    if ($stackBindings.Contains($forbidden)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: raw bridge stack access remains: $forbidden"
    }
}

$pushInt = Get-Region $bridge `
    'OWF_SET_GLOBAL(L, "ivkr_push_int_as_bool");' `
    'OWF_SET_GLOBAL(L, "ivkr_push_string");' `
    'numeric bridge pushes'
if ([regex]::Matches($pushInt,
    'operation\.kind = ProtectedGameVmOperationKind::append_value;').Count -ne 2 -or
    $pushInt.Contains('luau_push_number(luau_L')) {
    throw 'OPENWF BRIDGE BOUNDS FAIL: numeric pushes bypass the protected append-value family'
}

$registry = Get-Region $bridge `
    'OWF_SET_GLOBAL(L, "ivkr_push_string");' `
    'OWF_SET_GLOBAL(L, "ivkr_defer_registry_release");' `
    'registry owner binding'
if (-not $registry.Contains(
    'operation.kind = ProtectedGameVmOperationKind::registry_owner;') -or
    $registry.Contains('luau_L->global_state')) {
    throw 'OPENWF BRIDGE BOUNDS FAIL: registry owner bypasses the protected owner transaction'
}

$chat = Get-Region $bridge `
    'OWF_SET_GLOBAL(L, "register_websocket_message_prefix");' `
    'OWF_SET_GLOBAL(L, "ivkr_push_chat_redux");' `
    'ChatRedux binding'
foreach ($marker in @(
    'operation.kind = ProtectedGameVmOperationKind::chat_redux;',
    'operation.pointer = ChatRedux_global_state;',
    'run_protected_game_vm_operation('
)) {
    if (-not $chat.Contains($marker)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: ChatRedux protected predicate missing: $marker"
    }
}
foreach ($forbidden in @(
    'luau_L->global_state', '--luau_L->outtop', 'luau_L->outtop--'
)) {
    if ($chat.Contains($forbidden)) {
        throw "OPENWF BRIDGE BOUNDS FAIL: ChatRedux raw state/top access remains: $forbidden"
    }
}

if ([regex]::IsMatch($bridge, 'luau_push_number\s*\(\s*luau_L')) {
    throw 'OPENWF BRIDGE BOUNDS FAIL: a numeric game-VM push still bypasses protected append_value'
}

Write-Host 'OPENWF BRIDGE BOUNDS PASS transaction=exact stack-window=ci-bounded mutations=protected-two-phase typed-pops=checked upvalues=checked registry-owner=protected chat-top=exact'
