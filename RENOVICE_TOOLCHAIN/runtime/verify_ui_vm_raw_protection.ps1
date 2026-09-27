$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$source = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $startIndex = $Text.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) {
        throw "UI VM RAW PROTECTION FAIL: missing $Description start: $Start"
    }
    $endIndex = $Text.IndexOf(
        $End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -le $startIndex) {
        throw "UI VM RAW PROTECTION FAIL: missing $Description end: $End"
    }
    $Text.Substring($startIndex, $endIndex - $startIndex)
}

function Require-Contains {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Marker,
        [Parameter(Mandatory)][string]$Description
    )
    if ($Text.IndexOf($Marker, [StringComparison]::Ordinal) -lt 0) {
        throw "UI VM RAW PROTECTION FAIL: $Description`: $Marker"
    }
}

foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<PauseMenuAppendContext>);',
    'static_assert(std::is_trivially_copyable_v<LifecycleHookValueContext>);',
    'static_assert(std::is_trivially_copyable_v<SharedTableLeafContext>);',
    'static_assert(std::is_trivially_copyable_v<InspectSharedTableContext>);',
    'static_assert(std::is_trivially_copyable_v<ClearDiagnosticModuleRootsContext>);',
    'static_assert(std::is_trivially_copyable_v<PauseInitializeInstallContext>);',
    'static_assert(std::is_trivially_copyable_v<PauseEnvironmentReadContext>);'
)) {
    Require-Contains $source $marker 'POD context contract missing'
}

$rawHelpers = Get-Region $source `
    'bool ui_leaf_push_environment_table(' `
    'enum class PauseMenuAppendFailure' `
    'UI raw helper family'
foreach ($marker in @(
    'append_game_vm_stack_value_reserved(state, value)',
    'bool append_scripts_menu_raw(',
    'check_stack(state, 12)',
    '"Name", "SCRIPTS"',
    '&open_scripts_settings_callback',
    'setfield(state, -2, "CallBack")'
)) {
    Require-Contains $rawHelpers $marker 'UI raw helper/capability marker missing'
}

$leafSpecs = @(
    @{
        Name = 'pause menu append'
        Start = '// BEGIN PAUSE_MENU_APPEND_PROTECTED_LEAF'
        End = '// END PAUSE_MENU_APPEND_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 16)',
            'ui_leaf_push_environment_table(state, context->environment)',
            'getfield(state, -1, "mMovie")',
            'append_scripts_menu_raw('
        )
    },
    @{
        Name = 'lifecycle hook lookup'
        Start = '// BEGIN LIFECYCLE_HOOK_VALUE_PROTECTED_LEAF'
        End = '// END LIFECYCLE_HOOK_VALUE_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 4)',
            'getfield(state, -10000, context->registry_key)',
            'getfield(state, -1, "hooks")',
            'getfield(state, -1, context->hook_name)',
            'context->output = *(base + 2);'
        )
    },
    @{
        Name = 'target shared table'
        Start = '// BEGIN TARGET_SHARED_TABLE_PROTECTED_LEAF'
        End = '// END TARGET_SHARED_TABLE_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 8)',
            'ui_leaf_push_vm_global(state, "_T")',
            'classify_diagnostic_bridge_action(',
            'ui_leaf_write_registry_value(',
            '"RENOVICE_TRACE"'
        )
    },
    @{
        Name = 'shared table inspection'
        Start = '// BEGIN INSPECT_SHARED_TABLE_PROTECTED_LEAF'
        End = '// END INSPECT_SHARED_TABLE_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 4)',
            'ui_leaf_push_vm_global(state, "_T")',
            'ui_leaf_push_hashed_table_field(',
            'scripts_settings_bridge_name'
        )
    },
    @{
        Name = 'diagnostic root clear'
        Start = '// BEGIN CLEAR_DIAGNOSTIC_MODULE_ROOTS_PROTECTED_LEAF'
        End = '// END CLEAR_DIAGNOSTIC_MODULE_ROOTS_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 2)',
            'ui_leaf_write_registry_value(state, key, nil)',
            'context->failure_index = index;',
            'context->passed = true;'
        )
    },
    @{
        Name = 'pause Initialize install'
        Start = '// BEGIN PAUSE_INITIALIZE_INSTALL_PROTECTED_LEAF'
        End = '// END PAUSE_INITIALIZE_INSTALL_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 8)',
            'ui_leaf_push_environment_table(state, context->environment)',
            'append_game_vm_stack_value_reserved(',
            '&pause_menu_builder_wrapper',
            'setfield(state, -2, "_RENOVICEPauseMenuDispatchWrapper")',
            '*context->dispatch_slot = wrapper_value;'
        )
    },
    @{
        Name = 'pause environment read'
        Start = '// BEGIN PAUSE_ENVIRONMENT_READ_PROTECTED_LEAF'
        End = '// END PAUSE_ENVIRONMENT_READ_PROTECTED_LEAF'
        Markers = @(
            'check_stack(state, 8)',
            'ui_leaf_push_environment_table(state, context->environment)',
            'getfield(state, -1, "mMenuOptions")',
            'getfield(state, -1, "Initialize")',
            'context->initialize_value = *(base + 1);'
        )
    }
)

foreach ($spec in $leafSpecs) {
    $leaf = Get-Region $source $spec.Start $spec.End $spec.Name
    foreach ($marker in $spec.Markers) {
        Require-Contains $leaf $marker "$($spec.Name) leaf marker missing"
    }
    foreach ($forbidden in @(
        'std::string', 'std::vector', 'std::deque', 'std::lock_guard',
        'std::shared_ptr', 'std::unique_ptr', 'ScopedVmApiFrame',
        'ScopedExecutionDepth', 'require_stack(', 'prepare_stack_write(',
        'std::ostringstream', 'config::', 'conout', 'catch (',
        ' new ', ' delete '
    )) {
        if ($leaf.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
            throw "UI VM RAW PROTECTION FAIL: $($spec.Name) leaf owns/calls forbidden construct: $forbidden"
        }
    }
    if ([regex]::IsMatch($leaf, '(?m)^\s*throw\b')) {
        throw "UI VM RAW PROTECTION FAIL: $($spec.Name) leaf throws a C++ exception"
    }
}

$outerSpecs = @(
    @{
        Name = 'pause menu wrapper'
        Start = '// BEGIN PAUSE_MENU_BUILDER_OUTER'
        End = '// END PAUSE_MENU_BUILDER_OUTER'
        Leaf = 'state, &pause_menu_append_protected_leaf, &context)'
    },
    @{
        Name = 'lifecycle hook lookup outer'
        Start = '// BEGIN LIFECYCLE_HOOK_VALUE_OUTER'
        End = '// END LIFECYCLE_HOOK_VALUE_OUTER'
        Leaf = 'state, &lifecycle_hook_value_protected_leaf, &context)'
    },
    @{
        Name = 'target shared table outer'
        Start = 'bool prepare_target_shared_table('
        End = 'struct InspectSharedTableContext'
        Leaf = 'state, &prepare_target_shared_table_protected_leaf, &context)'
    },
    @{
        Name = 'shared table inspection outer'
        Start = 'bool inspect_current_shared_table('
        End = 'struct TargetCardReadContext'
        Leaf = 'state, &inspect_current_shared_table_protected_leaf, &context)'
    },
    @{
        Name = 'diagnostic root clear outer'
        Start = 'bool clear_diagnostic_module_roots_for_vm(luau_State* state)'
        End = 'void remember_pause_menu_identity('
        Leaf = 'state, &clear_diagnostic_module_roots_protected_leaf, &context)'
    },
    @{
        Name = 'pause Initialize install outer'
        Start = '// BEGIN PAUSE_INITIALIZE_INSTALL_OUTER'
        End = '// END PAUSE_INITIALIZE_INSTALL_OUTER'
        Leaf = 'state, &decorate_pause_initialize_assignment_protected_leaf, &context)'
    },
    @{
        Name = 'pause environment read outer'
        Start = 'bool decorate_pause_menu_environment('
        End = 'TargetExecutionBoundary inspect_pause_vm_root_execution('
        Leaf = 'state, &decorate_pause_menu_environment_protected_leaf, &context)'
    }
)

foreach ($spec in $outerSpecs) {
    $outer = Get-Region $source $spec.Start $spec.End $spec.Name
    Require-Contains $outer 'de_vm_authority::run_current_vm_protected(' `
        "$($spec.Name) bypasses raw protection"
    Require-Contains $outer $spec.Leaf "$($spec.Name) protected leaf call missing"
    foreach ($forbidden in @(
        'ScopedVmApiFrame', 'require_stack(', 'prepare_stack_write(',
        'getfield(state,', 'setfield(state,', 'luau_gettable(',
        'luau_settable(', 'luau_createtable(', 'luau_pushcclosurek(',
        'push_environment_table(', 'push_vm_global(', 'push_hashed_table_field('
    )) {
        if ($outer.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
            throw "UI VM RAW PROTECTION FAIL: $($spec.Name) retains direct DE VM operation: $forbidden"
        }
    }
}

$rootOuter = Get-Region $source `
    'bool clear_diagnostic_module_roots_for_vm(luau_State* state)' `
    'void remember_pause_menu_identity(' `
    'diagnostic root clear outer'
$rawAt = $rootOuter.IndexOf(
    'de_vm_authority::run_current_vm_protected(', [StringComparison]::Ordinal)
$eraseAt = $rootOuter.IndexOf(
    'diagnostic_module_roots.erase(', [StringComparison]::Ordinal)
if ($rawAt -lt 0 -or $eraseAt -le $rawAt) {
    throw 'UI VM RAW PROTECTION FAIL: diagnostic root metadata commits before protected registry clear'
}

Write-Host 'UI VM RAW PROTECTION PASS leaves=7 pause-menu=preserved lifecycle-hook=protected shared-table=protected diagnostics-roots=two-phase decorators=protected exact-frame=required'
