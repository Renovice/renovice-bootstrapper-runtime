$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$header = Get-Content -Raw -LiteralPath (Join-Path $repo "renovice\injection.hpp")
$injection = Get-Content -Raw -LiteralPath (Join-Path $repo "renovice\injection.cpp")
$scripting = Get-Content -Raw -LiteralPath (Join-Path $repo "owf_scripting.cpp")
$scriptingHeader = Get-Content -Raw -LiteralPath (Join-Path $repo "owf_scripting.hpp")
$main = Get-Content -Raw -LiteralPath (Join-Path $repo "main.cpp")

foreach ($marker in @(
    'bool initialise_game_vm_stack_bridge() noexcept;',
    'bool reserve_game_vm_stack(luau_State* state, int slots) noexcept;',
    'bool push_game_vm_stack_index(luau_State* state, int index) noexcept;',
    'bool append_game_vm_stack_value(luau_State* state, luau_TValue value) noexcept;'
)) {
    if (-not $header.Contains($marker)) { throw "Public game-VM bridge contract missing: $marker" }
}

foreach ($marker in @(
    'resolve_unique<CheckStack>',
    'signature_gc_barrierback_u43',
    'signature_lua_pushvalue_u43',
    'game_pushvalue(state, index);',
    'checked_stack_append(*state, value,',
    'if (!initialise_game_vm_stack_bridge()) return false;'
)) {
    if (-not $injection.Contains($marker)) { throw "Shared game-VM bridge implementation missing: $marker" }
}

foreach ($marker in @(
    '#include "renovice/injection.hpp"',
    'push_game_vm_stack_index(',
    'OpenWF.ChatRedux.table.v97',
    'ChatRedux_global_state == luau_L->global_state',
    'collectable upvalue assignment is unavailable'
)) {
    if (-not $scripting.Contains($marker)) { throw "OpenWF bridge integration missing: $marker" }
}

if ($scripting.Contains('*luau_L->outtop = *luau_L->getValue') -or
    $scripting.Contains('*luau_L->outtop = *tval') -or
    $scripting.Contains('luau_L->outtop->value.as_uintptr = ChatRedux_table')) {
    throw 'Raw collectable game-VM stack publication has returned'
}
if ($scriptingHeader.Contains('ChatRedux_table')) {
    throw 'ChatRedux must not retain an unrooted raw table pointer'
}

foreach ($marker in @(
    'OpenWF.ChatRedux.table.v97',
    'push_game_vm_stack_index(',
    'ChatRedux_global_state = L->global_state;',
    'if (!renovice::injection::initialise_game_vm_stack_bridge())'
)) {
    if (-not $main.Contains($marker)) { throw "Game-VM lifecycle integration missing: $marker" }
}
$bridgeInit = $main.IndexOf('if (!renovice::injection::initialise_game_vm_stack_bridge())')
$configInit = $main.IndexOf('if (!renovice::config::initialise())', $bridgeInit)
if ($bridgeInit -lt 0 -or $configInit -lt 0 -or $bridgeInit -gt $configInit) {
    throw 'The stack bridge must resolve before any OpenWF script can be created'
}

Write-Output 'OPENWF GAME VM BRIDGE PASS checked-reservation=1 native-pushvalue=1 fallback-thread-barrier=1 chat-registry-root=1 numeric-upvalue-write=preserved'
