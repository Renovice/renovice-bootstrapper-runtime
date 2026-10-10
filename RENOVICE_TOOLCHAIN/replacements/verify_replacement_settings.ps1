# Deterministic gates for REPLACEMENT_SETTINGS_V1 (2026-09-30): SCRIPT SETTINGS
# values read by exact content-key replacement members of a script package
# through the read-only RENOVICE_SCRIPT_SETTINGS accessor.
#
# Offline only; it never reads or writes a game folder.
#   1. Real U44 replacement fixture (RETRIEVAL/Hijack module fb346b59e2b7687a):
#      compiled with the U44 raw-hash path (derecomp recompile-u44), container
#      round trip, compile determinism. The fixture source is the stock
#      decompile (decompile-mod-u44) plus ONE block that reads one setting. The
#      baseline (block removed) is compiled too; CONST-ID and CFG-ID between
#      baseline and fixture prove the block is the only change: one hashed
#      global (the accessor) and four string field keys, all in the root
#      prototype. When the stock corpus is present, the baseline source must
#      equal the stock decompile exactly and pass CONST-ID and CFG-ID against
#      the stock bytes (the fixture is a faithful replacement except the block).
#   2. MSVC /W4 /WX checker: the pure rules, the accessor-name hash against the
#      compiled fixture and the 922k-name base, and the exact packages.cpp +
#      replacement_settings.cpp code end to end with the fixture bytes.
#   3. Source pins for the runtime integration (injection.cpp block and call
#      sites, replacements.cpp, packages.cpp, main.cpp).
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$replacementsDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $replacementsDir
$repo = Split-Path -Parent $toolchainDir
$deToolchain = [IO.Path]::GetFullPath((Join-Path $repo '..\..\toolchains\de-luau-toolchain'))
$derecomp = Join-Path $deToolchain 'bin\derecomp.exe'
$namebase = Join-Path $deToolchain 'data\namebase_verified.tsv'
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'replacement-settings'
$fixtureDir = Join-Path $replacementsDir 'fixtures\replacement_settings'
$fixtureKey = 'fb346b59e2b7687a'
$stockName = 'Lotus_Scripts_Modes_RetrievalMission.lua_B'
$accessorHash = '04ace428'

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "REPLACEMENT SETTINGS GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Get-Region([string]$Text, [string]$Begin, [string]$End, [string]$Label) {
    $start = $Text.IndexOf($Begin, [StringComparison]::Ordinal)
    $stop = if ($start -ge 0) { $Text.IndexOf($End, $start + $Begin.Length, [StringComparison]::Ordinal) } else { -1 }
    if ($start -lt 0 -or $stop -le $start) { throw "REPLACEMENT SETTINGS GATE FAIL: missing region $Label" }
    return $Text.Substring($start, $stop - $start)
}
function Index([string]$Text, [string]$Needle) { return $Text.IndexOf($Needle, [StringComparison]::Ordinal) }
function Count([string]$Text, [string]$Needle) { return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }
function Read-Lf([string]$Path) { return [IO.File]::ReadAllText($Path).Replace("`r`n", "`n") }
function Write-Lf([string]$Path, [string]$Text) { [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false)) }
function Get-BodyKey([string]$Path) {
    [UInt64]$hash = 1469598103934665603
    [UInt64]$prime = 1099511628211
    foreach ($byte in [IO.File]::ReadAllBytes($Path)) {
        $hash = $hash -bxor [UInt64]$byte
        $hash = [UInt64]([Numerics.BigInteger]::Remainder([Numerics.BigInteger]$hash * $prime, [Numerics.BigInteger]::Pow(2, 64)))
    }
    return $hash.ToString('x16')
}
function Invoke-Derecomp([string[]]$Arguments) {
    $output = @(& $derecomp @Arguments 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    return [pscustomobject]@{ Exit = $LASTEXITCODE; Lines = $output; Text = ($output -join "`n") }
}

# The one block the fixture adds to the stock decompile (after `v5 = 10000`,
# the root local that holds the Hijack payload base health).
$block = @"
  do
    -- REPLACEMENT_SETTINGS_V1 fixture: the only change against stock.
    local renovice_accessor = RENOVICE_SCRIPT_SETTINGS
    if renovice_accessor ~= nil then
      local renovice_settings = renovice_accessor()
      local renovice_entry = renovice_settings ~= nil and renovice_settings["hijack.payload_health"] or nil
      if renovice_entry ~= nil and renovice_entry.enabled == true and renovice_entry.stock == 10000 and renovice_entry.value ~= nil then
        v5 = renovice_entry.value
      end
    end
  end

"@
$block = $block.Replace("`r`n", "`n")

# 1. The real U44 replacement fixture.
Require (Test-Path -LiteralPath $derecomp -PathType Leaf) 'toolchain derecomp.exe present'
$fixtureText = Read-Lf (Join-Path $fixtureDir 'RetrievalMission.settings.u44.luau')
Require ($fixtureText.StartsWith("-- RENOVICE_NAME_HASH_SEED: 768e5ed0`n")) 'fixture is a U44 raw-hash source (seed 768e5ed0 declared)'
Require ((Count $fixtureText $block) -eq 1 -and (Count $fixtureText "  v5 = 10000`n$block") -eq 1) 'fixture holds the settings block exactly once, directly after the stock payload-health assignment'
Require ((Count $fixtureText 'RENOVICE_SCRIPT_SETTINGS') -eq 1) 'fixture reads the accessor exactly once'
$fixtureSource = Join-Path $scratch 'fixture.luau'
$baselineSource = Join-Path $scratch 'baseline.luau'
Write-Lf $fixtureSource $fixtureText
Write-Lf $baselineSource ($fixtureText.Replace($block, ''))
$fixture = Join-Path $scratch "$fixtureKey.fixture.lua_B"
$fixtureAgain = Join-Path $scratch "$fixtureKey.fixture.again.lua_B"
$baseline = Join-Path $scratch "$fixtureKey.baseline.lua_B"
foreach ($pair in @(@($fixtureSource, $fixture), @($fixtureSource, $fixtureAgain), @($baselineSource, $baseline))) {
    $result = Invoke-Derecomp @('recompile-u44', $pair[0], $pair[1])
    Require ($result.Exit -eq 0 -and $result.Text.Contains('raw-hash-source=yes')) "recompile-u44 (raw-hash path): $(Split-Path -Leaf $pair[1])"
}
Require ((Get-FileHash -LiteralPath $fixture).Hash -eq (Get-FileHash -LiteralPath $fixtureAgain).Hash) 'fixture compile is deterministic'
$roundtrip = Invoke-Derecomp @('de-roundtrip', $fixture)
Require ($roundtrip.Exit -eq 0 -and $roundtrip.Text.Contains('FULL BODY identical: True')) 'fixture DE 09 03 container round trip is byte-exact'

$const = Invoke-Derecomp @('const-identity', $baseline, $fixture, '--u44')
$diffProtos = @($const.Lines | Where-Object { $_ -match '^proto \d+ (HASH|STRING|KEYUSE) ' } | ForEach-Object { ($_ -split ' ')[1] } | Sort-Object -Unique)
$rootProto = if ($diffProtos.Count -eq 1) { $diffProtos[0] } else { '' }
Require ($rootProto -ne '') "CONST-ID baseline vs fixture: differences in exactly one prototype (root $rootProto)"
Require ($const.Text.Contains("proto $rootProto HASH only-stock=[] only-candidate=[$accessorHash]")) "CONST-ID: the only new native-name hash is the accessor global ($accessorHash)"
Require ($const.Text.Contains("proto $rootProto STRING only-stock=[] only-candidate=[`"enabled`", `"hijack.payload_health`", `"stock`", `"value`"]")) 'CONST-ID: the only new strings are the settings id and the three entry fields'
Require ($const.Text.Contains("proto $rootProto KEYUSE only-stock=[] only-candidate=[FIELD S:enabled, FIELD S:hijack.payload_health, FIELD S:stock, FIELD S:value, GLOBAL H:$accessorHash]")) 'CONST-ID: string-class field reads (as the host writes them) and one hashed global read'
Require ($const.Text.Contains('CLASS_SWAPS hash_string_class_swaps=0')) 'CONST-ID: no hash/string class swap'
$cfg = Invoke-Derecomp @('cfg-identity', $baseline, $fixture, '--u44')
$protoCount = if ($cfg.Text -match 'CFG_IDENTITY protos_stock=(\d+) protos_candidate=(\d+) cfg_equal=(\d+)') { [int]$Matches[1] } else { -1 }
$cfgEqual = if ($cfg.Text -match 'cfg_equal=(\d+)') { [int]$Matches[1] } else { -1 }
$cfgDiffs = @($cfg.Lines | Where-Object { $_ -match '^proto \d+ CFG_DIFF' } | ForEach-Object { ($_ -split ' ')[1] } | Sort-Object -Unique)
Require ($protoCount -gt 1 -and $cfgEqual -eq $protoCount - 1 -and $cfgDiffs.Count -eq 1 -and $cfgDiffs[0] -eq $rootProto) "CFG-ID: every prototype but the root has identical control flow ($cfgEqual/$protoCount)"

# Stock comparison when the shared corpus is present (read-only).
$workspace = $repo
while (-not (Test-Path -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -PathType Leaf)) {
    $parent = Split-Path -Parent $workspace
    if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $workspace) { $workspace = ''; break }
    $workspace = $parent
}
$stock = if ($workspace) { Join-Path $workspace "shared\corpus\de-luau-u44.0.2-authoring\$stockName" } else { '' }
if ($stock -and (Test-Path -LiteralPath $stock -PathType Leaf)) {
    $stockCopy = Copy-GateInput $stock $scratch
    Require ((Get-BodyKey $stockCopy) -eq $fixtureKey) "stock $stockName has content key $fixtureKey (the member filename key)"
    $render = Join-Path $scratch 'stock.decompiled.luau'
    $decompiled = Invoke-Derecomp @('decompile-mod-u44', $stockCopy, $render)
    Require ($decompiled.Exit -eq 0) 'stock decompile-mod-u44'
    Require ((Read-Lf $render) -eq ($fixtureText.Replace($block, ''))) 'fixture = stock decompile + the settings block (nothing else edited)'
    $stockConst = Invoke-Derecomp @('const-identity', $stockCopy, $baseline, '--u44')
    Require ($stockConst.Text -match 'CONST_IDENTITY .* verdict=PASS') 'baseline vs stock: CONST-ID PASS (names, strings and key classes as stock)'
    $stockCfg = Invoke-Derecomp @('cfg-identity', $stockCopy, $baseline, '--u44')
    Require ($stockCfg.Text -match 'CFG_IDENTITY .* verdict=PASS') 'baseline vs stock: CFG-ID PASS (control flow as stock)'
}
else {
    Write-Output "SKIP`tstock comparison (shared corpus $stockName not present)"
}

# 1b. SCRIPT SETTINGS rows of the example package: the exact page model
# (verify_addon_settings.ps1 -Package) must print the pinned rows file that
# verify_script_settings_render.ps1 (section 4b) renders through the stock list.
$examplePackage = Join-Path $scratch 'package\HijackSettingsExample'
New-Item -ItemType Directory -Path $examplePackage -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $fixtureDir 'HijackSettingsExample\package.json') -Destination $examplePackage
Copy-Item -LiteralPath $fixture -Destination (Join-Path $examplePackage "$fixtureKey (hijack payload health from settings).lua_B")
# The child gate enters its own VS shell; its native stderr notices must not
# become terminating errors here, so only its exit code and output decide.
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try { $pageModel = @(& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $toolchainDir 'settings\verify_addon_settings.ps1') -Package $examplePackage -Settings (Join-Path $fixtureDir 'Settings\HijackSettingsExample.json') 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") }); $pageModelExit = $LASTEXITCODE }
finally { $ErrorActionPreference = $previousPreference }
Require ($pageModelExit -eq 0 -and ($pageModel -contains 'ADDON SETTINGS GATES PASS')) 'example package passes the real scanner, settings evaluation and page model (verify_addon_settings -Package)'
Require ($pageModel -contains "DELIVER`t$fixtureKey (hijack payload health from settings).lua_B context.settings[`"hijack.payload_health`"] = { enabled = true, value = 20000, stock = 10000 }") 'example package: the replacement member receives hijack.payload_health = 20000 (stock 10000)'
$rows = @($pageModel | Where-Object { $_ -match '^(PAGE|ROW|VALPAGE|VALROW)\t' })
$pinnedRows = @((Read-Lf (Join-Path $fixtureDir 'HijackSettingsExample.rows.txt')).TrimEnd("`n").Split("`n"))
Require ($rows.Count -gt 0 -and (($rows -join "`n") -eq ($pinnedRows -join "`n"))) "example package rows equal the pinned rows file rendered by the settings render gate ($($rows.Count) lines)"

# 1c. Second, unrelated fixture: the recommended pattern for generated
# replacements (many values, reads inside hot functions, a cache keyed by the
# committed serial). Compiled on the U44 raw-hash path; CONST-ID against the
# same module with a settings-free helper shows exactly the accessor global and
# the three string-class entry fields; then executed in plain Luau against a
# mock of the host contract (stock fallback, custom values, one table per
# committed serial over 20000 reads, stock guard, removal, empty call).
$patternText = Read-Lf (Join-Path $fixtureDir 'GeneratedReplacementPattern.u44.luau')
$helperStart = $patternText.IndexOf('local function setting(id, stock)', [StringComparison]::Ordinal)
$helperEnd = $patternText.IndexOf("`nend`n", $helperStart, [StringComparison]::Ordinal)
Require ($helperStart -gt 0 -and $helperEnd -gt $helperStart) 'pattern fixture: the setting(id, stock) helper is present'
$patternBaselineText = $patternText.Substring(0, $helperStart) + "local function setting(id, stock)`n  return stock`nend`n" + $patternText.Substring($helperEnd + 5)
$patternSource = Join-Path $scratch 'pattern.luau'
$patternBaselineSource = Join-Path $scratch 'pattern.baseline.luau'
Write-Lf $patternSource $patternText
Write-Lf $patternBaselineSource $patternBaselineText
$pattern = Join-Path $scratch 'pattern.lua_B'
$patternBaseline = Join-Path $scratch 'pattern.baseline.lua_B'
foreach ($pair in @(@($patternSource, $pattern), @($patternBaselineSource, $patternBaseline))) {
    $result = Invoke-Derecomp @('recompile-u44', $pair[0], $pair[1])
    Require ($result.Exit -eq 0 -and $result.Text.Contains('raw-hash-source=yes')) "recompile-u44 (raw-hash path): $(Split-Path -Leaf $pair[1])"
}
$patternRoundtrip = Invoke-Derecomp @('de-roundtrip', $pattern)
Require ($patternRoundtrip.Exit -eq 0 -and $patternRoundtrip.Text.Contains('FULL BODY identical: True')) 'pattern fixture DE 09 03 container round trip is byte-exact'
$patternConst = Invoke-Derecomp @('const-identity', $patternBaseline, $pattern, '--u44')
$patternProtos = @($patternConst.Lines | Where-Object { $_ -match '^proto \d+ (HASH|STRING|KEYUSE) ' } | ForEach-Object { ($_ -split ' ')[1] } | Sort-Object -Unique)
Require ($patternProtos.Count -eq 1) "pattern CONST-ID: the differences are confined to the helper prototype ($($patternProtos -join ','))"
$helperProto = if ($patternProtos.Count -eq 1) { $patternProtos[0] } else { '' }
Require ($patternConst.Text.Contains("proto $helperProto HASH only-stock=[] only-candidate=[$accessorHash]")) 'pattern CONST-ID: the helper reads the accessor global by its native-name hash'
Require ($patternConst.Text.Contains("proto $helperProto KEYUSE only-stock=[] only-candidate=[FIELD S:enabled, FIELD S:stock, FIELD S:value, GLOBAL H:$accessorHash]")) 'pattern CONST-ID: entry fields are string-class reads (as the host writes them)'
Require ($patternConst.Text.Contains('CLASS_SWAPS hash_string_class_swaps=0')) 'pattern CONST-ID: no hash/string class swap'
$luau = Join-Path $deToolchain 'bin\luau.exe'
Require (Test-Path -LiteralPath $luau -PathType Leaf) 'toolchain luau.exe present'
$harnessFile = Join-Path $scratch 'pattern_harness_run.luau'
Write-Lf $harnessFile ("PATTERN_MODULE = function(...)`n" + $patternText + "`nend`n" + (Read-Lf (Join-Path $fixtureDir 'pattern_harness.luau')))
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try { $patternRun = @(& $luau $harnessFile 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") }); $patternExit = $LASTEXITCODE }
finally { $ErrorActionPreference = $previousPreference }
$patternRun | ForEach-Object { Write-Output "PATTERN`t$_" }
Require ($patternExit -eq 0 -and @($patternRun | Where-Object { $_ -like 'PATTERN HARNESS PASS*' }).Count -eq 1 -and @($patternRun | Where-Object { $_ -like 'FAIL*' }).Count -eq 0) 'pattern harness: stock fallback, custom values, one table per committed serial, guards (plain Luau against the host contract)'

# 2. Pure rules, accessor-name hash and the exact loader code end to end.
$work = ConvertTo-GateLongPath (Join-Path $scratch 'work')
$originalEnvironment = @{}
foreach ($entry in Get-ChildItem Env:) { $originalEnvironment[$entry.Name] = $entry.Value }
try {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsPath = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath).Trim()
    $vsId = (& $vswhere -latest -version "[17.0,18.0)" -products "*" -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property instanceId).Trim()
    if ([string]::IsNullOrWhiteSpace($vsPath) -or [string]::IsNullOrWhiteSpace($vsId)) {
        throw "Visual Studio 2022 x64 C++ tools were not found"
    }
    Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
    Enter-VsDevShell -VsInstanceId $vsId -SkipAutomaticLocation -Arch amd64 -HostArch amd64 | Out-Null
    $mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\replacements\verify_replacement_settings.cpp', 'RENOVICE_TOOLCHAIN\common')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\replacements\verify_replacement_settings.cpp'
    $scanner = Join-Path $mirror 'renovice\packages.cpp'
    $literals = Join-Path $mirror 'renovice\live_literals.cpp' # LIVE_LITERALS_V1: packages.cpp attaches recipes
    $engineParams = Join-Path $mirror 'renovice\engine_params.cpp' # R16: packages.cpp attaches engine_params.json
    $store = Join-Path $mirror 'renovice\replacement_settings.cpp'
    $binary = Join-Path $scratch 'verify_replacement_settings.exe'
    $objects = Join-Path $scratch 'obj'
    New-Item -ItemType Directory -Path $objects -Force | Out-Null
    Push-Location $objects
    try {
        $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /DRENOVICE_PACKAGES_OFFLINE_GATE /Fe:$binary $source $scanner $store $literals $engineParams 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
        $compileExit = $LASTEXITCODE
    }
    finally { Pop-Location }
    $output | Write-Output
    if ($compileExit -ne 0) { throw "REPLACEMENT SETTINGS GATE FAIL: checker compilation failed: $compileExit" }
    & $binary $work (ConvertTo-GateLongPath $fixtureDir) (ConvertTo-GateLongPath $fixture) $accessorHash (ConvertTo-GateLongPath $namebase)
    if ($LASTEXITCODE -ne 0) { throw "REPLACEMENT SETTINGS GATE FAIL: checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 3. Runtime integration pins.
$injection = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.cpp'))
$injectionHeader = [IO.File]::ReadAllText((Join-Path $repo 'renovice\injection.hpp'))
$replacements = [IO.File]::ReadAllText((Join-Path $repo 'renovice\replacements.cpp'))
$packages = [IO.File]::ReadAllText((Join-Path $repo 'renovice\packages.cpp'))
$main = [IO.File]::ReadAllText((Join-Path $repo 'main.cpp'))
$core = [IO.File]::ReadAllText((Join-Path $repo 'renovice\replacement_settings_core.hpp'))
$store = [IO.File]::ReadAllText((Join-Path $repo 'renovice\replacement_settings.cpp'))

$block = Get-Region $injection '// BEGIN REPLACEMENT_SETTINGS_ACCESSOR' '// END REPLACEMENT_SETTINGS_ACCESSOR' 'accessor block'
Require (-not $block.Contains('-10002')) 'the accessor never touches the VM global table (V26 live negative: not visible to module code)'
$install = Get-Region $block 'void replacement_settings_install_leaf(' 'void publish_replacement_settings_accessor(' 'install leaf'
Require ((Index $install 'key_builder(registry_key, 0x104, context->name_handle);') -ge 0 -and (Index $install 'getfield(state, -10000, registry_key);') -gt (Index $install 'key_builder(')) 'install resolves the loaded root closure from the module registry (same as the target identity)'
Require ((Index $install 'push_environment_table(state, closure->env, base + 1)') -gt 0 -and $install.Contains('closure->isC')) 'install targets the environment of the undumped Lua root closure'
Require ($install.Contains('name.value.as_bool = wf_hash(replacement_settings::accessor_global_name);') -and $install.Contains('name.type = LUAU_BOOL;')) 'install writes the DE native-name hash key of RENOVICE_SCRIPT_SETTINGS (the key class the compiler emits)'
Require ((Index $install 'context->action = replacement_settings::install_action(context->slot);') -lt (Index $install 'luau_settable(state, -3);') -and $install.Contains('InstallAction::RejectForeign)')) 'the slot is classified before any write; a foreign value is never overwritten'
Require ($install.Contains('upvalue.type = LUAU_LIGHTUSERDATA;') -and $install.Contains('luau_pushcclosurek(state, &replacement_settings_accessor,') -and $install.Contains('"RENOVICE replacement settings accessor", 1, nullptr);')) 'the accessor is a C closure whose only upvalue is the key as plain bits'
Require ($install.Contains('installed->c.func == &replacement_settings_accessor') -and $install.Contains('== bound_key;')) 'install reads the slot back and verifies closure and bound key'
$publish = Get-Region $injection 'void publish_replacement_settings_accessor(' '// END REPLACEMENT_SETTINGS_ACCESSOR' 'publish'
Require ((Index $publish 'if (entry == nullptr) return;') -gt 0 -and (Index $publish 'if (entry == nullptr) return;') -lt (Index $publish 'run_current_vm_protected')) 'no entry -> return before any VM access (replacements without declarations are untouched)'
Require ((Index $publish 'vm_loader_may_drain_pending(lua_execution_depth)') -lt (Index $publish 'run_current_vm_protected')) 'nested RENOVICE execution defers (same boundary rule as the loader drain)'
Require ($publish.Contains('InstallAction::Keep') -and $publish.Contains('&& context.passed) return;')) 'an already-correct accessor is kept silently (no per-load log line)'
$accessor = Get-Region $block '// RENOVICE_SCRIPT_SETTINGS([key] [, knownSerial]) -> settings table or nil, serial' 'struct ReplacementSettingsInstallContext' 'accessor'
Require ((Index $accessor 'if (!check_stack(state, 2)) return 0;') -lt (Index $accessor 'replacement_settings::committed()')) 'both C result slots are reserved before any owning C++ object exists'
Require ((Index $accessor '!replacement_settings::caller_is_current(plan, snapshot->serial)') -gt 0 -and (Index $accessor '!replacement_settings::caller_is_current(plan, snapshot->serial)') -lt (Index $accessor 'replacement_settings_build_leaf')) 'hot path: a caller holding the current serial gets no table (no protected leaf, no allocation)'
Require ($accessor.Contains('return 2;') -and $accessor.Contains('replacement_settings::serial_number(snapshot->serial)')) 'every resolved call returns settings-or-nil and the committed serial'
Require ((Index $accessor 'replacement_settings::committed()') -gt 0 -and -not $accessor.Contains('packages::candidate()')) 'the accessor reads only the committed snapshot (never a prepared F9)'
Require ($accessor.Contains('replacement_settings_build_leaf') -and $accessor.Contains('clear_replacement_settings_return_root(state)')) 'the table is built in a protected leaf and its temporary registry root is always cleared'
Require ((Index $accessor 'config::diagnostics_mode() != config::DiagnosticsMode::off') -lt (Index $accessor 'RENOVICE REPLACEMENT SETTINGS READ')) 'Diagnostics=false: the READ line is neither formatted nor written'
$build = Get-Region $block 'void replacement_settings_build_leaf(' 'struct ReplacementSettingsClearContext' 'build leaf'
Require ($build.Contains('raw_table_set_bool(state, -1, "enabled", true)') -and $build.Contains('raw_table_set_number(state, -1, "value", entry.value)') -and $build.Contains('raw_table_set_number(state, -1, "stock", entry.stock)') -and $build.Contains('setfield(state, -2, entry.id);')) 'entries have exactly the context.settings shape { enabled = true, value, stock }'

$loader = Get-Region $injection 'LoaderDetourOutcome loader_detour_owned(' 'bool loader_detour(void* manager, void* descriptor)' 'loader detour'
$drainAt = Index $loader 'replacements::drain_pending_for_vm(state);'
$publishAt = Index $loader 'publish_replacement_settings_accessor('
Require ($drainAt -gt 0 -and $publishAt -gt $drainAt -and (Index $loader 'if (vm_loader_may_drain_pending(lua_execution_depth)') -lt $drainAt) 'the load call site is inside the non-nested loader boundary block'
Require ($loader.Contains('if (result && replacements::completed_replacement_load(') -and (Index $loader 'LoaderDetourDisposition::RethrowStockError') -lt $publishAt) 'only after a successful stock Loader (never after a stock error) and only when replacement bytes were undumped'
$commit = Get-Region $injection 'auto commit_prepared = [state]' 'riven::commit_prepared_gate();' 'F9 commit'
Require ((Index $commit 'packages::commit_prepared_reload();') -lt (Index $commit 'replacement_settings::commit(packages::candidate(), "F9");') -and (Index $commit 'replacement_settings::commit(') -lt (Index $commit 'replacements::commit_prepared_reload();')) 'F9: the snapshot is published right after the package commit, before the replacement map'
Require ($injectionHeader.Contains('void publish_replacement_settings_accessor(')) 'publish is declared for the replacement refresh path'

$complete = Get-Region $replacements 'void complete_module_load(void* manager, void* descriptor)' 'bool reexecute_changed_loaded' 'complete_module_load'
Require ($complete.Contains('if (active.descriptor == descriptor && active.target_valid && active.replacement_undumped)') -and $complete.Contains('completed_replacement_load_record = {};')) 'the load record is reset per load and set only when the undump used replacement bytes'
$drain = Get-Region $replacements 'bool drain_pending_for_vm(luau_State* state)' 'bool completed_replacement_load(' 'drain'
Require ($drain.Contains('if (current && !job.restoring_stock)') -and $drain.Contains('"F9-refresh"')) 'an F9 refresh to replacement bytes attaches the accessor; a restore to stock does not'
Require ($replacements.Contains('publish_settings_accessors_for_loaded(state);') -and $replacements.Contains('context.global_state != state->global_state') -and $replacements.Contains('context.owner_thread != owner_thread')) 'F9 commit: already-loaded replacement modules of this exact VM and owner thread only'
Require ($packages.Contains('replacement_settings::member_receives_delivery(') -and $packages.Contains('member.kind == MemberKind::Replacement, declarations, member.filename))')) 'packages.cpp: one delivery rule for addon and replacement members'
Require ((Index $main 'renovice::packages::initialise()') -lt (Index $main 'renovice::replacement_settings::commit(renovice::packages::candidate(), "startup");') -and (Index $main 'replacement_settings::commit(') -lt (Index $main 'renovice::replacements::initialise(')) 'startup: the snapshot is published after the package scan and before the replacement hook'
Require ($store.Contains('if (snapshot->entries.empty() && (previous == nullptr || previous->entries.empty())) return;')) 'a setup without replacement settings writes no new log line'
Require (-not $core.Contains('Missions') -and -not $core.Contains('Hijack') -and -not $core.Contains('Mallet') -and -not $block.Contains('Hijack') -and -not $block.Contains('fb346b59')) 'the primitive names no mission, ability or file (universal)'

Write-Output "REPLACEMENT SETTINGS GATES PASS"
