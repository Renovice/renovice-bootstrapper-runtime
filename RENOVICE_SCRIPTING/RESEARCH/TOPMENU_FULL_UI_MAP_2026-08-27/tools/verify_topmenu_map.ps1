[CmdletBinding()]
param(
    [string]$ResearchRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$Decompiler = 'C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\de-luau-toolchain\bin\derecomp.exe'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "VERIFY FAIL: $Message" }
}

$generator = Join-Path $PSScriptRoot 'generate_topmenu_map.ps1'
& $generator -ResearchRoot $ResearchRoot

$bytecode = Join-Path $ResearchRoot 'TopMenu.current.lua_B'
$closureMap = Join-Path $ResearchRoot 'TopMenu.current.closure-map.tsv'
$expectedHash = 'D3279EE9A715B90BD078D9F614ACC691FD050E957212723541E5C92DD6639D94'
$actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bytecode).Hash
Assert-True ($actualHash -eq $expectedHash) "captured TopMenu SHA256 drifted: $actualHash"

$closureMapOutput = @(& $Decompiler closure-map $bytecode $closureMap 2>&1)
$closureMapExit = $LASTEXITCODE
Assert-True ($closureMapExit -eq 0) "closure-map exited $closureMapExit`: $($closureMapOutput -join ' | ')"
$closureRows = @(Import-Csv -Delimiter "`t" -LiteralPath $closureMap)
$failedClosureRows = @($closureRows | Where-Object Status -ne 'PASS')
Assert-True ($closureRows.Count -eq 381) "closure-map contains $($closureRows.Count) sites, expected 381"
Assert-True ($failedClosureRows.Count -eq 0) "closure-map contains $($failedClosureRows.Count) failed rows"
$initializeClosure = @($closureRows | Where-Object {
    $_.parent_proto -eq '383' -and $_.operand_namespace -eq 'child' -and
    $_.operand_index -eq '132' -and $_.target_proto -eq '349'
})
Assert-True ($initializeClosure.Count -eq 1) 'module-root child[132] does not resolve uniquely to proto[349]'
Assert-True ($initializeClosure[0].target_upvalues -eq '23' -and
    $initializeClosure[0].capture_count -eq '23') 'Initialize closure shape/capture count drifted'
Assert-True ($initializeClosure[0].captures -match '(?:^|;)14=VAL:R144(?:;|$)') `
    'Initialize.U14 is not captured from root register R144'
Assert-True ($initializeClosure[0].captures -match '(?:^|;)17=VAL:R150(?:;|$)') `
    'Initialize.U17 is not captured from root register R150'

$prototypeRows = @(Import-Csv -Delimiter "`t" -LiteralPath (Join-Path $ResearchRoot 'prototypes.tsv'))
$menuRows = @(Import-Csv -Delimiter "`t" -LiteralPath (Join-Path $ResearchRoot 'menu_options.tsv'))
$upvalueRows = @(Import-Csv -Delimiter "`t" -LiteralPath (Join-Path $ResearchRoot 'initialize_upvalues.tsv'))
Assert-True ($prototypeRows.Count -eq 384) "prototype count is $($prototypeRows.Count), expected 384"
Assert-True ($menuRows.Count -eq 62) "menu-option count is $($menuRows.Count), expected 62"
Assert-True ($upvalueRows.Count -eq 23) "Initialize upvalue count is $($upvalueRows.Count), expected 23"

$u14 = $upvalueRows | Where-Object InitializeUpvalue -eq '14'
$u17 = $upvalueRows | Where-Object InitializeUpvalue -eq '17'
Assert-True ($u14.SourceSymbol -eq 'vT[144]' -and $u14.KnownRole -eq 'BuildMenuOptions') 'Initialize.U14 is not mapped to BuildMenuOptions'
Assert-True ($u17.SourceSymbol -eq 'vT[150]' -and $u17.KnownRole -eq 'CreateList') 'Initialize.U17 is not mapped to CreateList'

$p295 = $prototypeRows | Where-Object GlobalProto -eq '295'
$p328 = $prototypeRows | Where-Object GlobalProto -eq '328'
$p349 = $prototypeRows | Where-Object GlobalProto -eq '349'
Assert-True ($p295.Upvalues -eq '59' -and $p295.MaxStack -eq '48') 'BuildMenuOptions prototype contract drifted'
Assert-True ($p328.Upvalues -eq '12' -and $p328.MaxStack -eq '10') 'CreateList prototype contract drifted'
Assert-True ($p349.Upvalues -eq '23') 'Initialize prototype contract drifted'

$semanticLines = Get-Content -LiteralPath (Join-Path $ResearchRoot 'TopMenu.current.semantic-verify.txt')
$verifiedCount = @($semanticLines | Where-Object { $_ -match '^SIR proto=\d+ status=VERIFIED\b' }).Count
$failureCount = @($semanticLines | Where-Object { $_ -match 'status=(?!VERIFIED)\w+' }).Count
Assert-True ($verifiedCount -eq 384) "semantic verifier reported $verifiedCount verified prototypes, expected 384"
Assert-True ($failureCount -eq 0) "semantic verifier contains $failureCount non-VERIFIED statuses"

Assert-True (Test-Path -LiteralPath $Decompiler -PathType Leaf) "DE-aware decompiler missing: $Decompiler"
$roundtripOutput = @(& $Decompiler de-roundtrip $bytecode 2>&1)
$roundtripExit = $LASTEXITCODE
Assert-True ($roundtripExit -eq 0) "DE byte-exact roundtrip exited $roundtripExit"
Assert-True (($roundtripOutput -join "`n") -match 'consts re-encode exact: 384/384' `
    -and ($roundtripOutput -join "`n") -match 'FULL BODY identical: True') `
    'DE byte-exact roundtrip did not report 384/384 constants and an identical body'

$verification = @(
    'TOPMENU FULL UI MAP VERIFICATION: PASS',
    "captured_sha256=$actualHash",
    "prototype_count=$($prototypeRows.Count)",
    "semantic_verified=$verifiedCount",
    "menu_option_count=$($menuRows.Count)",
    "initialize_upvalue_count=$($upvalueRows.Count)",
    "closure_map_sites=$($closureRows.Count)",
    "closure_map_failures=$($failedClosureRows.Count)",
    'closure_map_initialize=parent_383/child_132/proto_349/captures_23',
    'closure_map_initialize_u14=VAL:R144',
    'closure_map_initialize_u17=VAL:R150',
    'initialize_u14=BuildMenuOptions/global_proto_295/upvalues_59/maxstack_48',
    'initialize_u17=CreateList/global_proto_328/upvalues_12/maxstack_10',
    "de_roundtrip_exit=$roundtripExit",
    ($roundtripOutput -join ' | ')
)
$verification | Set-Content -LiteralPath (Join-Path $ResearchRoot 'verification.txt') -Encoding utf8
$verification | ForEach-Object { Write-Host $_ }
