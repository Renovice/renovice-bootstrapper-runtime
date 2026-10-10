$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Offline gate: script folder layout V2 (2026-10-10). ScriptStates.json schema-2 helpers and package auto-join.
$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$compiler = 'C:\msys64\ucrt64\bin\g++.exe'
if (-not (Test-Path -LiteralPath $compiler -PathType Leaf)) {
    throw "Certified standalone verifier compiler not found: $compiler"
}
. (Join-Path $repo 'RENOVICE_TOOLCHAIN\gate_paths.ps1')
$scratch = Get-GateScratch $repo 'layout-v2'
$mirror = Copy-GateSources $repo $scratch @('renovice', 'RENOVICE_TOOLCHAIN\layout\verify_layout_v2.cpp')
$output = Join-Path $scratch 'verify_layout_v2.exe'
& $compiler -std=c++20 -Wall -Wextra -Werror `
    (Join-Path $mirror 'RENOVICE_TOOLCHAIN\layout\verify_layout_v2.cpp') -o $output
if ($LASTEXITCODE -ne 0) { throw 'Layout V2 verifier compile failed' }
# Optional: -StateFile <ScriptStates.json> checks an external (migrated) file against the loader's composition.
if ($args.Count -gt 0) { & $output (Copy-GateInput $args[0] $scratch) } else { & $output }
if ($LASTEXITCODE -ne 0) { throw 'Layout V2 verifier failed' }
