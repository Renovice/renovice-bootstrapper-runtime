$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$source = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$authority = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.cpp'))
$header = [IO.File]::ReadAllText((Join-Path $repo 'renovice\de_vm_authority.hpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $a = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($a -lt 0) { throw "STOCK LOADER PROTECTION FAIL: missing $Description start: $Start" }
    $b = $Text.IndexOf($End, $a + $Start.Length, [StringComparison]::Ordinal)
    if ($b -le $a) { throw "STOCK LOADER PROTECTION FAIL: missing $Description end: $End" }
    return $Text.Substring($a, $b - $a)
}

foreach ($marker in @(
    'CurrentVmProtectedResult run_current_vm_rethrowable(',
    '[[noreturn]] void rethrow_current_vm_error('
)) {
    if (-not $header.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: authority contract missing: $marker"
    }
}

foreach ($marker in @(
    'RVA 0x991C90',
    'CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93',
    '48 83 EC 28 48 8B 41 18 4C 8B C1 48 8B 88 B8 04 00 00 48 85 C9 74 12 89 51 08 48 83 C1 10 BA 01 00 00 00',
    'vm_throw = throw_error.as<VmThrow>();',
    'vm_throw(state, status);'
)) {
    if (-not $authority.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: pinned exact throw evidence missing: $marker"
    }
}

$leaf = Get-Region $source `
    'void protected_stock_loader_leaf(' `
    'ProtectedStockLoaderResult invoke_stock_loader_protected(' `
    'destructor-free stock Loader leaf'
foreach ($marker in @(
    'context->loader(context->manager, context->descriptor);',
    'context->returned = true;'
)) {
    if (-not $leaf.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: leaf contract missing: $marker"
    }
}
foreach ($forbidden in @(
    'std::', 'Scoped', 'lock_guard', 'unique_lock', 'shared_ptr',
    'config::', 'conout', 'catch', 'throw', ' new ', ' delete '
)) {
    if ($leaf.Contains($forbidden)) {
        throw "STOCK LOADER PROTECTION FAIL: leaf owns forbidden C++ state: $forbidden"
    }
}

$wrapper = Get-Region $source `
    'ProtectedStockLoaderResult invoke_stock_loader_protected(' `
    'struct GuardedRunLeafContext' `
    'shared stock Loader wrapper'
foreach ($marker in @(
    'de_vm_authority::run_current_vm_rethrowable(',
    'de_vm_authority::run_current_vm_protected(',
    '&protected_stock_loader_leaf',
    'result.status = protected_result.status;',
    'result.returned = context.returned;'
)) {
    if (-not $wrapper.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: shared wrapper contract missing: $marker"
    }
}

$runGuarded = Get-Region $source `
    '// BEGIN GUARDED_RUN_PROTECTED_LEAF' `
    '// END GUARDED_RUN_PROTECTED_LEAF' `
    'run_guarded protected Loader use'
foreach ($marker in @(
    'ProtectedStockLoaderContext loader_context{};',
    'loader_context.loader = context->loader;',
    'protected_stock_loader_leaf(state, &loader_context);',
    'loader_context.returned && loader_context.value'
)) {
    if (-not $runGuarded.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: run_guarded gate missing: $marker"
    }
}
if ($runGuarded.Contains('invoke_stock_loader_protected(')) {
    throw 'STOCK LOADER PROTECTION FAIL: run_guarded nests the shared raw wrapper beneath its outer raw boundary'
}

$ownedDetour = Get-Region $source `
    'LoaderDetourOutcome loader_detour_owned(' `
    'bool loader_detour(void* manager, void* descriptor)' `
    'owned Loader detour'
foreach ($marker in @(
    'StockLoaderErrorPolicy::PreserveForStockRethrow',
    'replacements::complete_module_load(manager, descriptor);',
    'loader_result.admitted && loader_result.status != 0',
    'LoaderDetourDisposition::RethrowStockError'
)) {
    if (-not $ownedDetour.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: owned detour contract missing: $marker"
    }
}
$protectedCall = $ownedDetour.IndexOf('invoke_stock_loader_protected(', [StringComparison]::Ordinal)
$complete = $ownedDetour.IndexOf('replacements::complete_module_load(manager, descriptor);', [StringComparison]::Ordinal)
$errorBranch = $ownedDetour.IndexOf('loader_result.admitted && loader_result.status != 0', [StringComparison]::Ordinal)
if ($protectedCall -lt 0 -or $complete -le $protectedCall -or $errorBranch -le $complete) {
    throw 'STOCK LOADER PROTECTION FAIL: module-load ownership is not released before error propagation'
}
if ($ownedDetour.Contains('loader_hook.original')) {
    throw 'STOCK LOADER PROTECTION FAIL: owned detour still invokes Loader directly'
}

$outerDetour = Get-Region $source `
    'bool loader_detour(void* manager, void* descriptor)' `
    'bool run_chunk(' `
    'outer Loader detour'
foreach ($marker in @(
    'const auto outcome = loader_detour_owned(state, manager, descriptor);',
    'de_vm_authority::rethrow_current_vm_error(outcome.state, outcome.status);',
    'return outcome.value;'
)) {
    if (-not $outerDetour.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: outer detour contract missing: $marker"
    }
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::lock_guard', 'std::unique_lock',
    'Scoped', 'config::', 'conout'
)) {
    if ($outerDetour.Contains($forbidden)) {
        throw "STOCK LOADER PROTECTION FAIL: outer rethrow tail owns forbidden state: $forbidden"
    }
}
$ownedCall = $outerDetour.IndexOf('loader_detour_owned(state, manager, descriptor)', [StringComparison]::Ordinal)
$rethrow = $outerDetour.IndexOf('rethrow_current_vm_error(outcome.state, outcome.status)', [StringComparison]::Ordinal)
if ($ownedCall -lt 0 -or $rethrow -le $ownedCall) {
    throw 'STOCK LOADER PROTECTION FAIL: stock error is not rethrown after owned detour return'
}

$refreshLeaf = Get-Region $source `
    '// BEGIN NATIVE_MODULE_REFRESH_PROTECTED_LEAF' `
    '// END NATIVE_MODULE_REFRESH_PROTECTED_LEAF' `
    'native refresh protected leaf'
foreach ($marker in @(
    'static_cast<NativeModuleRefreshLeafContext*>(',
    'capture_guard_outer_error_jump(state)',
    'AddVectoredExceptionHandler(1, fault_handler)',
    'context->guard_prepared = true;',
    'setjmp(guard.jump)',
    'restore_guard_outer_error_jump_after_fault()',
    'invoke_stock_loader_protected(',
    'StockLoaderErrorPolicy::ContainAndRestore',
    'disarm_guard_exception_handler();'
)) {
    if (-not $refreshLeaf.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: native refresh leaf gate missing: $marker"
    }
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::ostringstream', 'std::lock_guard',
    'std::unique_lock', 'Scoped', 'config::', 'conout', 'throw', 'catch'
)) {
    if ($refreshLeaf.Contains($forbidden)) {
        throw "STOCK LOADER PROTECTION FAIL: native refresh leaf owns forbidden C++ state: $forbidden"
    }
}
$captureJump = $refreshLeaf.IndexOf(
    'capture_guard_outer_error_jump(state)', [StringComparison]::Ordinal)
$installVeh = $refreshLeaf.IndexOf(
    'AddVectoredExceptionHandler(1, fault_handler)', [StringComparison]::Ordinal)
$nativeJump = $refreshLeaf.IndexOf(
    'setjmp(guard.jump)', [StringComparison]::Ordinal)
$loaderCall = $refreshLeaf.IndexOf(
    'invoke_stock_loader_protected(', [StringComparison]::Ordinal)
if ($captureJump -lt 0 -or
    $installVeh -le $captureJump -or
    $nativeJump -le $installVeh -or
    $loaderCall -le $nativeJump) {
    throw 'STOCK LOADER PROTECTION FAIL: native refresh fault/error-jump nesting order changed'
}

$refresh = Get-Region $source `
    'bool execute_native_module_refresh(' `
    'InitialiseResult initialise()' `
    'native refresh Loader use'
foreach ($marker in @(
    'de_vm_authority::run_current_vm_protected(',
    '&native_module_refresh_protected_leaf',
    'if (context.guard_prepared) disarm_guard_exception_handler();',
    'disarm_guard_exception_handler();',
    '!protected_result.admitted || !protected_result.restored',
    'protected_result.status != 0 || !context.completed'
)) {
    if (-not $refresh.Contains($marker)) {
        throw "STOCK LOADER PROTECTION FAIL: native refresh gate missing: $marker"
    }
}
foreach ($forbidden in @(
    'loader_hook.original', 'invoke_stock_loader_protected(',
    'AddVectoredExceptionHandler(', 'setjmp(guard.jump)',
    'restore_lua_top();', 'finish_guard();'
)) {
    if ($refresh.Contains($forbidden)) {
        throw "STOCK LOADER PROTECTION FAIL: native refresh outer crosses fault/raw boundary: $forbidden"
    }
}

$directLoaderCalls = [regex]::Matches(
    $source,
    '(?:context->loader|original)\s*\(\s*(?:context->manager|manager)\s*,\s*(?:context->descriptor|descriptor)\s*\)')
if ($directLoaderCalls.Count -ne 3) {
    throw "STOCK LOADER PROTECTION FAIL: expected one protected leaf and two stock-only startup/invalid-state forwards; found $($directLoaderCalls.Count)"
}

Write-Host 'STOCK LOADER PROTECTION PASS: all active Loader paths use one POD raw boundary; stock errors retain their DE error TValue until exact status rethrow after C++ ownership release.'
