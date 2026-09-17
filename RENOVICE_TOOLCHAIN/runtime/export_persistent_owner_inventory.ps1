param(
    [string]$CustomScriptsRoot = 'C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts',
    [string]$OutputPath = ''
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $CustomScriptsRoot).Path
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $PSScriptRoot 'persistent-owner-inventory.json'
}

$statesPath = Join-Path $root 'ScriptStates.json'
$states = $null
if (Test-Path -LiteralPath $statesPath -PathType Leaf) {
    $states = (Get-Content -LiteralPath $statesPath -Raw | ConvertFrom-Json).scripts
}

function Get-ExplicitState {
    param([string]$Key)
    if ($null -eq $states) { return $null }
    $property = $states.PSObject.Properties[$Key]
    if ($null -eq $property) { return $null }
    return [bool]$property.Value
}

function New-FileOwnerRecord {
    param(
        [System.IO.FileInfo]$File,
        [string]$Kind,
        [string]$RelativePath,
        [string]$StatePrefix,
        [string]$Lifetime,
        [string]$Cleanup
    )
    $stateKey = ($StatePrefix + ':' + $File.Name).ToLowerInvariant()
    [ordered]@{
        relativePath = $RelativePath
        kind = $Kind
        bodyKey = if ($File.Name -match '^(?<key>[0-9a-fA-F]{16})') { $Matches.key.ToLowerInvariant() } else { $null }
        stateKey = $stateKey
        explicitEnabled = Get-ExplicitState $stateKey
        bytes = $File.Length
        sha256 = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        owner = if ($Kind -eq 'Replacement') { 'stock module loader and replacement snapshot' } else { 'RENOVICE injection generation' }
        lifetime = $Lifetime
        cleanup = $Cleanup
    }
}

$files = [System.Collections.Generic.List[object]]::new()
Get-ChildItem -LiteralPath $root -File | Where-Object { $_.Name -match '\.lua_B$' } | Sort-Object Name | ForEach-Object {
    $files.Add((New-FileOwnerRecord $_ 'Replacement' $_.Name 'replacement' 'module load plus refreshed stock object lifetime' 'removing or disabling schedules stock-body restoration at the owning VM boundary'))
}

$injectRoot = Join-Path $root 'Inject'
if (Test-Path -LiteralPath $injectRoot -PathType Container) {
    Get-ChildItem -LiteralPath $injectRoot -File | Where-Object { $_.Name -match '\.lua_B$' } | Sort-Object Name | ForEach-Object {
        $kind = 'OrdinaryOneShot'
        $prefix = 'inject'
        $lifetime = 'one execution after accepted generation commit'
        $cleanup = 'none; one-shot side effects are script-owned and not automatically reversible'
        if ($_.Name -ieq '_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B') {
            $kind = 'ManagedAddon'
            $prefix = 'addon'
            $lifetime = 'generation-owned registry lifecycle root'
            $cleanup = 'cleanup callback followed by registry-root release'
        } elseif ($_.Name -match '(?i)\.target\.addon\.lua_B$') {
            $kind = 'TargetManagedAddon'
            $prefix = 'target-addon'
            $lifetime = 'body-key, VM, owner-thread, shared-table and generation scoped registry root'
            $cleanup = 'cleanup callback and root release after in-flight generation callbacks drain'
        } elseif ($_.Name -match '(?i)\.addon\.lua_B$') {
            $kind = 'ManagedAddon'
            $prefix = 'addon'
            $lifetime = 'generation-owned registry lifecycle root'
            $cleanup = 'cleanup callback followed by registry-root release'
        }
        $files.Add((New-FileOwnerRecord $_ $kind ('Inject\' + $_.Name) $prefix $lifetime $cleanup))
    }
}

$architecture = @(
    [ordered]@{ owner = 'Loader and VM execute detours'; scope = 'process'; payload = 'native trampolines'; activation = 'runtime initialization'; cleanup = 'process unload'; f9 = 'unchanged' },
    [ordered]@{ owner = 'RunScript and native method detours'; scope = 'process'; payload = 'native trampolines and original targets'; activation = 'first required contract'; cleanup = 'process unload'; f9 = 'installed superset retained; current generation selects handlers' },
    [ordered]@{ owner = 'Published target handler snapshot'; scope = 'generation'; payload = 'immutable addon records, VM identity, target key, native method claims'; activation = 'atomic publication after commit'; cleanup = 'after admission closes and every lease drains'; f9 = 'atomically replaced' },
    [ordered]@{ owner = 'Managed addon lifecycle roots'; scope = 'generation and VM'; payload = 'Lua lifecycle tables'; activation = 'activate callback'; cleanup = 'cleanup callback then registry nil'; f9 = 'transactional replace or exact-content reuse' },
    [ordered]@{ owner = 'Target module identity roots'; scope = 'stock module instance and VM'; payload = 'original stock closure plus verified prototype graph'; activation = 'successful exact target module load'; cleanup = 'VM destruction or later proven module-instance retirement'; f9 = 'retained because live stock objects may still execute; contains no addon handler closure' },
    [ordered]@{ owner = 'Fault diagnostics'; scope = 'diagnostic configuration'; payload = 'VEH, dbghelp module, physical fault log handle'; activation = 'diagnostics on'; cleanup = 'observer removal, in-flight drain, handle close, module unload'; f9 = 'reconciled' },
    [ordered]@{ owner = 'Automatic battle diagnostics'; scope = 'diagnostic generation and VM'; payload = 'embedded Lua runtime, trace bridge, source prototype roots and native lookup catalog'; activation = 'battle or trace capture requested'; cleanup = 'current VM roots clear at F9; other VM roots clear at next natural module boundary'; f9 = 'reconciled after in-flight handler drain' },
    [ordered]@{ owner = 'Ordinary operational logging'; scope = 'process'; payload = 'bounded physical text log'; activation = 'Logging=true'; cleanup = 'stream close at process exit; 64 MiB rotation'; f9 = 'configuration updated; separate from Diagnostics' }
)

$document = [ordered]@{
    schema = 1
    generatedUtc = [DateTime]::UtcNow.ToString('o')
    customScriptsRoot = $root
    scriptStatesSha256 = if (Test-Path -LiteralPath $statesPath -PathType Leaf) { (Get-FileHash -LiteralPath $statesPath -Algorithm SHA256).Hash.ToLowerInvariant() } else { $null }
    architecture = $architecture
    files = $files
}

$parent = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
$document | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding utf8
$hash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash.ToLowerInvariant()
Write-Host "PERSISTENT OWNER INVENTORY PASS files=$($files.Count) output=$OutputPath sha256=$hash"
