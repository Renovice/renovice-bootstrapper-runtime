$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repo = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$workspace = $repo
while (-not (Test-Path -LiteralPath (Join-Path $workspace 'WORKSPACE.json'))) {
    $parent = Split-Path -Parent $workspace
    if ($parent -eq $workspace) { throw 'WORKSPACE.json not found' }
    $workspace = $parent
}
$topMenu = Join-Path $repo 'RENOVICE_SCRIPTING\RESEARCH\TOPMENU_FULL_UI_MAP_2026-08-27\TopMenu.current.lua_B'
if (-not (Test-Path -LiteralPath $topMenu -PathType Leaf)) {
    throw "Pinned current TopMenu bytecode not found: $topMenu"
}
$output = Join-Path $env:TEMP 'renovice_verify_scripts_ui_core.exe'
$compiler = 'C:\msys64\ucrt64\bin\g++.exe'
if (-not (Test-Path -LiteralPath $compiler -PathType Leaf)) {
    throw "Certified standalone verifier compiler not found: $compiler"
}
& $compiler -std=c++20 -Wall -Wextra -Werror `
    (Join-Path $PSScriptRoot 'verify_scripts_ui_core.cpp') -o $output
if ($LASTEXITCODE -ne 0) { throw 'Scripts UI core verifier compile failed' }
& $output $topMenu
if ($LASTEXITCODE -ne 0) { throw 'Scripts UI core verifier failed' }
