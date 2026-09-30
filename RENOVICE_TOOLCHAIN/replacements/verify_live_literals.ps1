# Deterministic gates for LIVE_LITERALS_V1 (2026-09-30): script-literal values
# made typeable in game by host-side replacement synthesis (contract
# CONTRACT_PHASE1.md Revision R8).
#
# Offline only; it never reads or writes a game folder.
#   1. The shared patch core renovice/live_literal_patch_core.hpp is the pinned
#      copy (the ability-editor generator pins the same SHA-256); when the
#      ability-editor checkout carries its copy, both must be byte-identical.
#   2. MSVC /W4 /WX checker (verify_live_literals.cpp) with the exact
#      packages.cpp and live_literals.cpp: core self-tests, the real generated
#      Missions recipe (parse, merge, negative cases), byte-exact synthesis of
#      the five staged baked replacements from the real U44 stock bytes, every
#      value at its min and max, precedence/default/off cases, fail-closed
#      synthesis, the package scan end to end, the SCRIPT SETTINGS page model.
#   3. Source pins for the runtime integration (replacements.cpp, packages.cpp,
#      injection.cpp, settings UI) and no target names in the primitive.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$replacementsDir = $PSScriptRoot
$toolchainDir = Split-Path -Parent $replacementsDir
$repo = Split-Path -Parent $toolchainDir
. (Join-Path $toolchainDir 'gate_paths.ps1')
$scratch = Get-GateScratch $repo 'live-literals'
$fixtureDir = Join-Path $replacementsDir 'fixtures\live_literals'
$coreSha = 'b933c7c7ece076daadd008e702a00e572e63ca6fcdc6a568a4bbd1070b1b3761'

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "LIVE LITERALS GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}
function Read-Lf([string]$Path) { return [IO.File]::ReadAllText($Path).Replace("`r`n", "`n") }
function Count([string]$Text, [string]$Needle) { return ([regex]::Matches($Text, [regex]::Escape($Needle))).Count }
function Index([string]$Text, [string]$Needle) { return $Text.IndexOf($Needle, [StringComparison]::Ordinal) }

# 1. Shared core pin.
$core = Join-Path $repo 'renovice\live_literal_patch_core.hpp'
Require ((Get-FileHash -LiteralPath $core -Algorithm SHA256).Hash.ToLowerInvariant() -eq $coreSha) "shared patch core is the pinned copy ($($coreSha.Substring(0, 16)))"
$workspace = $repo
while ($workspace -and -not (Test-Path -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -PathType Leaf)) {
    $parent = Split-Path -Parent $workspace
    if ($parent -eq $workspace) { $workspace = $null; break }
    $workspace = $parent
}
Require ($null -ne $workspace) 'workspace root (WORKSPACE.json) found'
$workspaceJson = Get-Content -LiteralPath (Join-Path $workspace 'WORKSPACE.json') -Raw | ConvertFrom-Json
$editorCopy = Join-Path $workspace (Join-Path $workspaceJson.repos.ability_editor 'include\renovice\live_literal_patch_core.hpp')
if (Test-Path -LiteralPath $editorCopy -PathType Leaf) {
    Require ((Get-FileHash -LiteralPath $editorCopy -Algorithm SHA256).Hash.ToLowerInvariant() -eq $coreSha) 'ability-editor copy of the shared core is byte-identical'
}
else {
    Write-Output "INFO`tability-editor checkout has no live_literal_patch_core.hpp yet (branch feat/live-literals-recipes-2026-09-30 not merged); pin checked on this side"
}

# Inputs: the fixture recipe (generated), the stock corpus, the staged baked replacements.
$corpus = Join-Path $workspace 'shared\corpus\de-luau-u44.0.2-authoring'
Require (Test-Path -LiteralPath (Join-Path $corpus 'Lotus_Scripts_MobileDefense.lua_B') -PathType Leaf) 'U44 stock corpus present (shared/corpus/de-luau-u44.0.2-authoring)'
$baked = Join-Path $workspace 'work\staging\missions-full-package\Packages\Missions'
$bakedArgument = if (Test-Path -LiteralPath $baked -PathType Container) { ConvertTo-GateLongPath $baked } else { '-' }
if ($bakedArgument -eq '-') { Write-Output "INFO`tstaged baked package absent; byte-exact synthesis is checked against the pinned SHA-256 only" }
foreach ($name in @('literals.json', 'package.json', 'expected_order.txt')) {
    Require (Test-Path -LiteralPath (Join-Path $fixtureDir $name) -PathType Leaf) "fixture $name present"
}
$recipeHash = (Get-FileHash -LiteralPath (Join-Path $fixtureDir 'literals.json') -Algorithm SHA256).Hash
Write-Output "INFO`tfixture literals.json sha256=$recipeHash"

# 2. Checker.
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
    $mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\replacements\verify_live_literals.cpp')
    $source = Join-Path $mirror 'RENOVICE_TOOLCHAIN\replacements\verify_live_literals.cpp'
    $scanner = Join-Path $mirror 'renovice\packages.cpp'
    $runtime = Join-Path $mirror 'renovice\live_literals.cpp'
    $binary = Join-Path $scratch 'verify_live_literals.exe'
    $objects = Join-Path $scratch 'obj'
    New-Item -ItemType Directory -Path $objects -Force | Out-Null
    Push-Location $objects
    try {
        $output = @(& cl /nologo /std:c++20 /O2 /W4 /WX /EHsc /DRENOVICE_PACKAGES_OFFLINE_GATE /Fe:$binary $source $scanner $runtime 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
        $compileExit = $LASTEXITCODE
    }
    finally { Pop-Location }
    $output | Write-Output
    if ($compileExit -ne 0) { throw "LIVE LITERALS GATE FAIL: checker compilation failed: $compileExit" }
    & $binary $work (ConvertTo-GateLongPath $fixtureDir) (ConvertTo-GateLongPath $corpus) $bakedArgument
    if ($LASTEXITCODE -ne 0) { throw "LIVE LITERALS GATE FAIL: checker failed: $LASTEXITCODE" }
}
finally {
    foreach ($name in @(Get-ChildItem Env: | Select-Object -ExpandProperty Name)) {
        if (-not $originalEnvironment.ContainsKey($name)) { Remove-Item -LiteralPath "Env:$name" }
    }
    foreach ($entry in $originalEnvironment.GetEnumerator()) {
        Set-Item -LiteralPath "Env:$($entry.Key)" -Value $entry.Value
    }
}

# 3. Source pins.
$replacements = Read-Lf (Join-Path $repo 'renovice\replacements.cpp')
$packagesCpp = Read-Lf (Join-Path $repo 'renovice\packages.cpp')
$injection = Read-Lf (Join-Path $repo 'renovice\injection.cpp')
$ui = Read-Lf (Join-Path $repo 'renovice\settings_ui_core.hpp')
$undumpStart = Index $replacements 'long long undump_detour('
$undump = $replacements.Substring($undumpStart, (Index $replacements 'InitialiseResult initialise(') - $undumpStart)
Require ((Index $undump 'snapshot->find(key)') -ge 0 -and (Index $undump 'snapshot->find(key)') -lt (Index $undump 'live_literals::synthesized(')) 'undump: a byte replacement wins; synthesis only after a byte-snapshot miss'
Require ((Count $undump 'live_literals::synthesized(') -eq 1 -and (Count $undump '"undump")') -eq 1) 'undump: one synthesis call from the stock body being undumped'
Require ((Count $replacements 'build_literal_plans(snapshot, available_keys.get(), "startup")') -eq 1 -and (Count $replacements 'build_literal_plans(*candidate, available_keys.get(), "F9")') -eq 1) 'plans built at startup and at every F9 prepare (recipe keys join the available keys)'
Require ((Count $replacements 'live_literals::commit_prepared();') -eq 1 -and (Count $replacements 'live_literals::discard_prepared();') -eq 1 -and (Count $replacements 'live_literals::prepare(std::move(literal_plans));') -eq 2) 'plan snapshot prepared, committed and discarded with the byte snapshot'
Require ((Count $replacements 'live_literals::changed_keys(*live_literals::active(), *literal_plans)') -eq 1) 'a changed plan is a changed replacement key (F9 refresh of loaded modules)'
Require ((Count $replacements 'effective_replacement(') -eq 3) 'both refresh paths use the effective replacement (bytes, else synthesis from the captured stock)'
Require ((Count $replacements 'literal_held_stock') -eq 4) 'natural load: a plan that failed closed (stock undumped) queues no stock refresh and clears its unresolved entry'
Require ((Count $replacements 'injection::remember_refreshed_target_module(') -eq 1) 'R5-C: a refreshed module re-registers its prototype graph under the stock key'
$loaderStart = Index $injection 'LoaderDetourOutcome loader_detour_owned('
$loader = $injection.Substring($loaderStart, 6000)
$inspectAt = Index $loader 'inspect_target_load(descriptor)'
$beginAt = Index $loader 'replacements::begin_module_load('
$stockAt = Index $loader 'invoke_stock_loader_protected('
Require ($inspectAt -ge 0 -and $inspectAt -lt $beginAt -and $beginAt -lt $stockAt) 'R5-C: the target key is hashed from the descriptor (stock) body before the undump detour can swap in synthesized bytes'
$identityAt = Index $injection "remember_target_module_identity(`n`t`t`t`ttarget_boundary.key, state, manager, target_boundary.name_handle);"
Require ($identityAt -gt $loaderStart) 'R5-C: the module identity (prototype graph) is recorded after the loader returned, from the closure actually loaded'
Require ((Count $packagesCpp 'live_literals::attach_recipes(package, recipe_path);') -eq 1 -and (Count $packagesCpp 'live_literals::resolve_package_plans(') -eq 2) 'package scan: recipe attach and plan resolution'
Require ((Count $injection 'BEGIN LIVE_LITERALS_TARGET_REFRESH') -eq 1 -and (Count $injection 'void remember_refreshed_target_module(') -eq 1 -and (Count $injection '|| !target_key_is_configured(key))') -ge 1) 'injection: refresh identity only for configured target keys'
# Merged R7 + R8 (contract R9): one predicate for baked literals; the kept-value (qval) page, the stored: stage and the
# Quick settings target admit every value that is typeable in game (addon and live literal).
Require ((Count $ui 'return declaration.lane == settings::Lane::Literal && !declaration.live_literal;') -eq 1 -and (Count $ui 'baked_literal(') -ge 7 -and (Count $ui '!settings::editable_in_game(*declaration)') -eq 2 -and (Count $ui '!settings::editable_in_game(*value)') -eq 1) 'SCRIPT SETTINGS: live literal values are typeable (value page, Quick settings kept value); baked literal values stay read-only'
foreach ($file in @('renovice\live_literal_patch_core.hpp', 'renovice\live_literals_core.hpp', 'renovice\live_literals.hpp', 'renovice\live_literals.cpp')) {
    $text = (Read-Lf (Join-Path $repo $file)).ToLowerInvariant()
    $names = @('mobiledefense', 'excavation', 'survival', 'void_flood', 'missions.', 'hijack', 'a807aae3')
    $hits = @($names | Where-Object { $text.Contains($_) })
    Require ($hits.Count -eq 0) "no target names in $file"
}
Write-Output 'LIVE LITERALS GATES PASS'
