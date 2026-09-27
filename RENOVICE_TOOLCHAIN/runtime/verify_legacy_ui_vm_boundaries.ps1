$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$sourcePath = Join-Path $root 'main.cpp'
$source = Get-Content -LiteralPath $sourcePath -Raw
$injectionPath = Join-Path $root 'renovice\injection.cpp'
$injection = Get-Content -LiteralPath $injectionPath -Raw

function Get-FunctionBlock([string]$name, [string]$nextName) {
    $startMarker = "static int $name"
    $start = $source.IndexOf($startMarker, [StringComparison]::Ordinal)
    if ($start -lt 0) { throw "Missing function: $name" }
    $end = if ([string]::IsNullOrEmpty($nextName)) {
        $source.Length
    } else {
        $value = $source.IndexOf($nextName, $start + $startMarker.Length, [StringComparison]::Ordinal)
        if ($value -lt 0) { throw "Missing boundary after $name`: $nextName" }
        $value
    }
    return $source.Substring($start, $end - $start)
}

$browser = Get-FunctionBlock 'lua_OpenWebBrowser_detour(luau_State* L)' 'static luau_CFunction lua_FlashInstance_GetStringVariable_og;'
$chat = Get-FunctionBlock 'lua_FlashInstance_GetStringVariable_detour(luau_State* L)' '#if LABEL_REPLACEMENTS'

foreach ($marker in @(
    'make_local_warframe_redirect(',
    'char rewritten_url[4096]{};',
    'return lua_OpenWebBrowser_og(L);'
)) {
    if (-not $browser.Contains($marker)) { throw "Browser boundary missing: $marker" }
}
foreach ($forbidden in @('std::string new_url', 'ObfusString sub(', 'ObfusString sub2(')) {
    if ($browser.Contains($forbidden)) { throw "Browser stock boundary retains C++ owner: $forbidden" }
}

foreach ($marker in @(
    'auto ret = lua_FlashInstance_GetStringVariable_og(L);',
    'run_current_vm_protected(',
    '&capture_chat_redux_table_leaf',
    'protected_capture.status == 0',
    'capture.captured'
)) {
    if (-not $chat.Contains($marker)) { throw "Chat boundary missing: $marker" }
}
if ($chat.Contains('while (--i > -20)')) { throw 'Unbounded historical ChatRedux reverse scan remains' }

$leafStart = $source.IndexOf('static void capture_chat_redux_table_leaf', [StringComparison]::Ordinal)
$leafEnd = $source.IndexOf('static int lua_FlashInstance_GetStringVariable_detour', $leafStart, [StringComparison]::Ordinal)
if ($leafStart -lt 0 -or $leafEnd -le $leafStart) { throw 'ChatRedux protected leaf missing' }
$leaf = $source.Substring($leafStart, $leafEnd - $leafStart)
foreach ($marker in @(
    'const int maximum_scan',
    'L->outtop - L->stack',
    'reserve_game_vm_stack(L, 3)',
    'luau_settable(L, -10000)',
    'context->captured = true'
)) {
    if (-not $leaf.Contains($marker)) { throw "Chat protected leaf missing: $marker" }
}
foreach ($forbidden in @('std::string', 'std::vector', 'std::lock_guard', 'ObfusString', '-10002')) {
    if ($leaf.Contains($forbidden)) { throw "Chat protected leaf is not destructor-free/correct-registry: $forbidden" }
}

$cardStart = $injection.IndexOf('struct TargetCardReadContext', [StringComparison]::Ordinal)
$cardEnd = $injection.IndexOf('bool same_lua_value(', $cardStart, [StringComparison]::Ordinal)
if ($cardStart -lt 0 -or $cardEnd -le $cardStart) { throw 'Ability-card boundary block missing' }
$card = $injection.Substring($cardStart, $cardEnd - $cardStart)
foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<TargetCardReadContext>)',
    'void read_target_card_values_leaf(',
    'append_game_vm_stack_value(state, environment)',
    'run_current_vm_protected(',
    'protected_read.status == 0',
    'generation_dispatch_gate.try_dispatch()'
)) {
    if (-not $card.Contains($marker)) { throw "Ability-card protected read missing: $marker" }
}
$protectedRead = $card.IndexOf('run_current_vm_protected(', [StringComparison]::Ordinal)
$lease = $card.IndexOf('generation_dispatch_gate.try_dispatch()', [StringComparison]::Ordinal)
if ($lease -lt $protectedRead) { throw 'Ability-card generation lease still spans the raw card read' }

$settingsStart = $injection.IndexOf('constexpr const char* scripts_settings_elements_return_root', [StringComparison]::Ordinal)
$settingsEnd = $injection.IndexOf('int scripts_settings_changed_callback', $settingsStart, [StringComparison]::Ordinal)
if ($settingsStart -lt 0 -or $settingsEnd -le $settingsStart) { throw 'Scripts-settings protected result block missing' }
$settings = $injection.Substring($settingsStart, $settingsEnd - $settingsStart)
foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<ScriptsSettingsElementsLeafContext>)',
    'void scripts_settings_elements_leaf(',
    'run_current_vm_protected(',
    'append_game_vm_stack_value_reserved(state, result_table)',
    'scripts_settings_elements_return_root',
    'row-count-unrepresentable',
    'This is an ABI representability bound, not a loader/menu policy.'
)) {
    if (-not $settings.Contains($marker)) { throw "Scripts-settings protected result missing: $marker" }
}
if ($settings.Contains('scripts.size() > 4096')) { throw 'Arbitrary Scripts-menu row cap returned' }

$settingsLeafStart = $settings.IndexOf('void scripts_settings_elements_leaf(', [StringComparison]::Ordinal)
$settingsLeafEnd = $settings.IndexOf('struct ScriptsSettingsElementsRootContext', $settingsLeafStart, [StringComparison]::Ordinal)
$settingsLeaf = $settings.Substring($settingsLeafStart, $settingsLeafEnd - $settingsLeafStart)
foreach ($forbidden in @('std::string', 'std::vector', 'std::lock_guard', 'ScopedVmApiFrame', 'config::log')) {
    if ($settingsLeaf.Contains($forbidden)) { throw "Scripts-settings raw leaf owns rich C++ state: $forbidden" }
}

$openStart = $injection.IndexOf('struct OpenScriptsSettingsLeafContext', [StringComparison]::Ordinal)
$openEnd = $injection.IndexOf('std::size_t array_next_index', $openStart, [StringComparison]::Ordinal)
if ($openStart -lt 0 -or $openEnd -le $openStart) { throw 'Scripts-settings protected open block missing' }
$open = $injection.Substring($openStart, $openEnd - $openStart)
foreach ($marker in @(
    'static_assert(std::is_trivially_copyable_v<OpenScriptsSettingsLeafContext>)',
    'void open_scripts_settings_leaf(',
    'protected_call(state, 5, 1, 0)',
    'run_current_vm_protected(',
    'clear_scripts_settings_callbacks(state)',
    'context.opened'
)) {
    if (-not $open.Contains($marker)) { throw "Scripts-settings protected open missing: $marker" }
}
$openLeafStart = $open.IndexOf('void open_scripts_settings_leaf(', [StringComparison]::Ordinal)
$openLeafEnd = $open.IndexOf('int open_scripts_settings_callback', $openLeafStart, [StringComparison]::Ordinal)
$openLeaf = $open.Substring($openLeafStart, $openLeafEnd - $openLeafStart)
foreach ($forbidden in @('std::string', 'std::vector', 'std::lock_guard', 'ScopedVmApiFrame', 'config::log')) {
    if ($openLeaf.Contains($forbidden)) { throw "Scripts-settings open leaf owns rich C++ state: $forbidden" }
}

$clearStart = $injection.IndexOf('struct ClearScriptsSettingsCallbacksContext', [StringComparison]::Ordinal)
$clearEnd = $injection.IndexOf('constexpr const char* scripts_settings_elements_return_root', $clearStart, [StringComparison]::Ordinal)
if ($clearStart -lt 0 -or $clearEnd -le $clearStart) { throw 'Scripts-settings protected clear block missing' }
$clear = $injection.Substring($clearStart, $clearEnd - $clearStart)
foreach ($marker in @(
    'void clear_scripts_settings_callbacks_leaf(',
    'run_current_vm_protected(',
    'scripts_settings_done_name'
)) {
    if (-not $clear.Contains($marker)) { throw "Scripts-settings protected clear missing: $marker" }
}

Write-Output 'LEGACY UI VM BOUNDARIES PASS browser_stock=naked chat_stock=naked chat_probe=raw-protected reverse_scan=bounded registry=-10000 ability_card_read=raw-protected lease=post-read scripts_rows=full-inventory-protected features=preserved'
