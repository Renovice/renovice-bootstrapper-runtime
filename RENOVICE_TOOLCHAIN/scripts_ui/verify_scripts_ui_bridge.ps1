$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$workspaceRepos = Split-Path -Parent (Split-Path -Parent $repo)
$toolchain = Join-Path $workspaceRepos "toolchains\de-luau-toolchain"
$derecomp = Join-Path $toolchain "bin\derecomp.exe"
$apiChecker = Join-Path $toolchain "check_ability_api.bat"
$source = Join-Path $repo "RENOVICE_SCRIPTING\INTERNAL\ScriptsSettingsBridgeV10.luau"
$bytecode = Join-Path $repo "RENOVICE_SCRIPTING\INTERNAL\_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B"
$semantic = Join-Path $repo "RENOVICE_SCRIPTING\INTERNAL\ScriptsSettingsBridgeV10.semantic.luau"

foreach ($required in @($derecomp, $apiChecker, $source)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "Required Scripts UI bridge input/tool is missing: $required"
    }
}

$sourceText = Get-Content -Raw -LiteralPath $source
foreach ($requiredCall in @(
    'child:Execute("SetConfirmButtonVisibleWhenInactive", "true")',
    'child:Execute("SetConfirmButtonActive", "true")'
)) {
    if (-not $sourceText.Contains($requiredCall)) {
        throw "Scripts UI bridge is missing required stock Confirm control call: $requiredCall"
    }
}

& $derecomp recompile $source $bytecode
if ($LASTEXITCODE -ne 0) { throw "Scripts UI bridge recompile failed: $LASTEXITCODE" }

& $derecomp de-roundtrip $bytecode
if ($LASTEXITCODE -ne 0) { throw "Scripts UI bridge byte-exact roundtrip failed: $LASTEXITCODE" }

& $derecomp plan-verify $bytecode
if ($LASTEXITCODE -ne 0) { throw "Scripts UI bridge ownership plan failed: $LASTEXITCODE" }

& $derecomp semantic-ir-verify $bytecode
if ($LASTEXITCODE -ne 0) { throw "Scripts UI bridge Semantic IR failed: $LASTEXITCODE" }

& $derecomp semantic-ir-render-module $bytecode $semantic
if ($LASTEXITCODE -ne 0) { throw "Scripts UI bridge Semantic IR render failed: $LASTEXITCODE" }

$resolvedSource = (Resolve-Path -LiteralPath $source).Path
& $apiChecker $resolvedSource --show-unknown
if ($LASTEXITCODE -ne 0) { throw "Scripts UI bridge API contract check failed: $LASTEXITCODE" }

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bytecode).Hash
$size = (Get-Item -LiteralPath $bytecode).Length
if ($size -le 0) { throw "Scripts UI bridge output is empty" }
Write-Host "SCRIPTS UI BRIDGE PASS bytes=$size sha256=$hash"
