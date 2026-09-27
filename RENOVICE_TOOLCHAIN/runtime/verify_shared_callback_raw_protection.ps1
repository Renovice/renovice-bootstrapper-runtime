$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$source = [System.IO.File]::ReadAllText(
    (Join-Path $repo 'renovice\injection.cpp'))

function Get-Region {
    param(
        [Parameter(Mandatory)][string]$Start,
        [Parameter(Mandatory)][string]$End,
        [Parameter(Mandatory)][string]$Description
    )
    $startIndex = $source.IndexOf($Start, [StringComparison]::Ordinal)
    if ($startIndex -lt 0) {
        throw "SHARED CALLBACK RAW PROTECTION FAIL: missing $Description start: $Start"
    }
    $endIndex = $source.IndexOf(
        $End, $startIndex + $Start.Length, [StringComparison]::Ordinal)
    if ($endIndex -le $startIndex) {
        throw "SHARED CALLBACK RAW PROTECTION FAIL: missing $Description end: $End"
    }
    $source.Substring($startIndex, $endIndex - $startIndex)
}

function Require-Marker {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Marker,
        [Parameter(Mandatory)][string]$Description
    )
    if ($Text.IndexOf($Marker, [StringComparison]::Ordinal) -lt 0) {
        throw "SHARED CALLBACK RAW PROTECTION FAIL: $Description`: $Marker"
    }
}

$leaf = Get-Region `
    '// BEGIN SHARED_CALLBACK_PROTECTED_LEAF' `
    '// END SHARED_CALLBACK_PROTECTED_LEAF' `
    'destructor-free callback leaf'

foreach ($marker in @(
    'void shared_callback_protected_leaf(luau_State* state, void* opaque)',
    'check_stack(state, static_cast<int>(required_slots))',
    'shared_callback_leaf_push_value(state, context->function)',
    'shared_callback_leaf_push_value(state, context->arguments[index])',
    'context->callback_status = protected_call(',
    'getfield(state, -1, shared_callback_error_fields[index]);',
    'context->results[index] = base[index];',
    'context->completed = true;'
)) {
    Require-Marker $leaf $marker 'protected leaf marker missing'
}
foreach ($forbidden in @(
    'std::string', 'std::vector', 'std::deque', 'std::lock_guard',
    'std::shared_ptr', 'std::unique_ptr', 'ScopedVmApiFrame',
    'ScopedInjectedInterruptBudget', 'require_stack(', 'push_stack_value(',
    'protected_callback_call(', 'std::ostringstream', 'config::', 'conout',
    'trace_addon(', 'catch (', ' new ', ' delete '
)) {
    if ($leaf.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
        throw "SHARED CALLBACK RAW PROTECTION FAIL: protected leaf owns/calls forbidden construct: $forbidden"
    }
}
if ([regex]::IsMatch($leaf, '(?m)^\s*throw\b')) {
    throw 'SHARED CALLBACK RAW PROTECTION FAIL: protected leaf throws a C++ exception'
}

foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<SharedCallbackLeafContext>);',
    'static_assert(std::is_trivially_copyable_v<SharedCallbackMemorySnapshot>);'
)) {
    Require-Marker $source $marker 'POD contract missing'
}

$invoke = Get-Region `
    'bool invoke_shared_callback(' `
    'std::string shared_callback_error_details(' `
    'shared callback outer orchestrator'
foreach ($marker in @(
    'ScopedInjectedInterruptBudget interrupt_budget(state->interrupt_count);',
    'de_vm_authority::run_current_vm_protected(',
    'outcome.admitted = protected_result.admitted;',
    'outcome.restored = protected_result.restored;',
    'outcome.raw_status = protected_result.status;',
    'report_shared_callback_memory(state, label, memory);',
    'outcome.admitted && outcome.restored && outcome.raw_status == 0',
    'outcome.leaf.completed'
)) {
    Require-Marker $invoke $marker 'outer orchestrator marker missing'
}
$rawAt = $invoke.IndexOf(
    'de_vm_authority::run_current_vm_protected(', [StringComparison]::Ordinal)
$restoreAt = $invoke.IndexOf(
    'outcome.restored = protected_result.restored;', [StringComparison]::Ordinal)
$reportAt = $invoke.IndexOf(
    'report_shared_callback_memory(state, label, memory);', [StringComparison]::Ordinal)
$returnAt = $invoke.IndexOf(
    'outcome.admitted && outcome.restored && outcome.raw_status == 0',
    [StringComparison]::Ordinal)
if ($rawAt -lt 0 -or $restoreAt -le $rawAt -or $reportAt -le $restoreAt -or
    $returnAt -le $reportAt) {
    throw 'SHARED CALLBACK RAW PROTECTION FAIL: raw-run, restore observation, rich diagnostics, commit ordering changed'
}

$callValue = Get-Region `
    'bool call_value(' `
    'bool call_boolean_value(' `
    'call_value wrapper'
$callBoolean = Get-Region `
    'bool call_boolean_value(' `
    'bool call_number_value(' `
    'boolean wrapper'
$callNumber = Get-Region `
    'bool call_number_value(' `
    'bool call_identity_value(' `
    'number wrapper'
$callIdentity = Get-Region `
    'bool call_identity_value(' `
    'bool call_table_value(' `
    'identity wrapper'
$callTable = Get-Region `
    'bool call_table_value(' `
    'bool table_set_string(' `
    'table wrapper'

foreach ($entry in @(
    @{ Name = 'call_value'; Text = $callValue },
    @{ Name = 'call_boolean_value'; Text = $callBoolean },
    @{ Name = 'call_number_value'; Text = $callNumber },
    @{ Name = 'call_identity_value'; Text = $callIdentity },
    @{ Name = 'call_table_value'; Text = $callTable }
)) {
    $name = [string]$entry['Name']
    $text = [string]$entry['Text']
    Require-Marker $text 'invoke_shared_callback(' "$name bypasses the shared raw boundary"
    foreach ($forbidden in @(
        'ScopedVmApiFrame', 'require_stack(', 'push_stack_value(',
        'protected_callback_call(', 'protected_call_error_details(',
        'state->outtop =', 'check_stack(', 'protected_call('
    )) {
        if ($text.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) {
            throw "SHARED CALLBACK RAW PROTECTION FAIL: $name retains direct VM operation: $forbidden"
        }
    }
}

foreach ($marker in @(
    'outcome.leaf.actual_result_count == 1',
    'outcome.leaf.results[0].type == LUAU_BOOL'
)) {
    Require-Marker $callBoolean $marker 'boolean result contract missing'
}
foreach ($marker in @(
    'outcome.leaf.actual_result_count == 1',
    'outcome.leaf.results[0].type == LUAU_NUMBER',
    'std::isfinite(outcome.leaf.results[0].value.as_float)'
)) {
    Require-Marker $callNumber $marker 'number result contract missing'
}
foreach ($marker in @(
    'outcome.leaf.actual_result_count == 1',
    'outcome.leaf.results[0].type != LUAU_NIL',
    'outcome.leaf.results[0].value.as_uintptr != 0'
)) {
    Require-Marker $callIdentity $marker 'identity result contract missing'
}
foreach ($marker in @(
    'outcome.leaf.actual_result_count == 1',
    'is_table(outcome.leaf.results[0].type)'
)) {
    Require-Marker $callTable $marker 'table result contract missing'
}
foreach ($marker in @(
    'outcome.leaf.actual_result_count',
    'outcome.leaf.copied_result_count',
    'append_error_value('
)) {
    Require-Marker $callValue $marker 'traced callback result contract missing'
}

Write-Host 'SHARED CALLBACK RAW PROTECTION PASS wrappers=5 pod-leaf=yes raw-errors=captured frame-restore=required typed-results=validated rich-formatting=post-return'
