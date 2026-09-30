# Offline gate: SCRIPT SETTINGS rows through the real stock render (R3, 2026-09-30).
#
# Live defect (bridge 2e337a43, DLL 731fdb11): every float value BUTTON carried
# mSubLabel without mButtonWidth. The stock 44.0.2 element draw callback of
# ThemedGenericSettings computes `mButtonWidth - (mSubLabelOffset or 100)` for a
# BUTTON with a sub-label (source line 991), so the draw raised "attempt to
# perform arithmetic (sub) on nil and number", the List Redraw and the populate
# layout after it were aborted, and recycled clips kept stale content.
#
# This gate runs the bridge under test through the stock code itself:
#   settings_render/stock/*.u44.luau   derecomp decompile-mod-u44 renders of the
#                                      44.0.2 stock ThemedGenericSettings and
#                                      EE.Interface.Components.List bytecode
#                                      (hashes pinned in STOCK_INPUTS.txt; the
#                                      render is re-made and compared when the
#                                      stock corpus and derecomp are present);
#   settings_render/harness_*.luau     recording Flash movie + engine stubs and a
#                                      driver (open, populate, 14-row scroll bar,
#                                      every scroll position, mouse wheel).
# Checks: no Lua error on any path, every visible clip shows its own row (frame,
# label, background, no leftover sub-label), the stock scroll contract holds,
# and the stock layout runs (search box inside the panel).
# Negative control: the R2 bridge (fixtures/ScriptSettingsBridgeV1.r2-2e337a43.luau,
# the installed bytes) must fail with the live nil-arithmetic error inside the
# stock BUTTON sub-label statement.
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$workspaceRepos = Split-Path -Parent (Split-Path -Parent $repo)
$toolchain = Join-Path $workspaceRepos "toolchains\de-luau-toolchain"
$luau = Join-Path $toolchain "bin\luau.exe"
$derecomp = Join-Path $toolchain "bin\derecomp.exe"
$renderDir = Join-Path $PSScriptRoot "settings_render"
$bridgeSource = Join-Path $repo "RENOVICE_SCRIPTING\INTERNAL\ScriptSettingsBridgeV1.luau"
$negativeBridge = Join-Path $renderDir "fixtures\ScriptSettingsBridgeV1.r2-2e337a43.luau"

function Require([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "SCRIPT SETTINGS RENDER GATE FAIL: $Message" }
    Write-Output "PASS`t$Message"
}

function Get-Sha256([string]$Path) {
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

# Text fixtures are pinned by their LF form, so a CRLF checkout keeps its hash.
function Get-TextSha256([string]$Path) {
    $bytes = [IO.File]::ReadAllBytes($Path)
    $text = [Text.Encoding]::UTF8.GetString($bytes).Replace("`r`n", "`n")
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $digest = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($text)) } finally { $sha.Dispose() }
    return (($digest | ForEach-Object { $_.ToString('x2') }) -join '')
}

Require (Test-Path -LiteralPath $luau -PathType Leaf) "toolchain luau.exe present"

# Stock inputs of record.
$inputs = @{}
foreach ($line in [IO.File]::ReadAllLines((Join-Path $renderDir "stock\STOCK_INPUTS.txt"))) {
    if ($line -match '^(render|stock)\t([^\t]+)\t([0-9a-f]{64})$') { $inputs["$($Matches[1]):$($Matches[2])"] = $Matches[3] }
}
$modules = @(
    @{ Name = 'Lotus.Interface.ThemedGenericSettings'; Stem = 'Lotus_Interface_ThemedGenericSettings' },
    @{ Name = 'EE.Interface.Components.List'; Stem = 'EE_Interface_Components_List' }
)
. (Join-Path $repo 'RENOVICE_TOOLCHAIN\gate_paths.ps1')
$scratch = Get-GateScratch $repo 'settings-render'
$stockCorpus = Join-Path $toolchain "work\u44-rawhash-2026-09-29\stock"
foreach ($module in $modules) {
    $render = Join-Path $renderDir "stock\$($module.Stem).u44.luau"
    Require ($inputs.ContainsKey("render:$($module.Stem)") -and (Get-TextSha256 $render) -eq $inputs["render:$($module.Stem)"]) "stock render of $($module.Name) matches STOCK_INPUTS.txt"
    $stock = Join-Path $stockCorpus "$($module.Stem).lua_B"
    if ((Test-Path -LiteralPath $stock -PathType Leaf) -and (Test-Path -LiteralPath $derecomp -PathType Leaf)) {
        Require ((Get-Sha256 $stock) -eq $inputs["stock:$($module.Stem)"]) "stock bytecode $($module.Stem).lua_B is the 44.0.2 input of record"
        $shortStock = Copy-GateInput $stock $scratch
        $fresh = Join-Path $scratch "$($module.Stem).fresh.luau"
        & $derecomp decompile-mod-u44 $shortStock $fresh | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "SCRIPT SETTINGS RENDER GATE FAIL: derecomp render failed for $($module.Stem)" }
        Require ((Get-TextSha256 $fresh) -eq $inputs["render:$($module.Stem)"]) "re-rendered stock $($module.Stem) is byte-identical to the fixture"
    } else {
        Write-Output "SKIP`tstock corpus or derecomp not present; fixture hash pinned only ($($module.Stem))"
    }
}

# Render corrections (applied in the harness copy only; the fixtures stay the
# byte-exact derecomp output). Each one is a proven toolchain rendering defect
# with its bytecode evidence; the count must match exactly.
$renderPatches = @(
    @{
        Module = 'EE.Interface.Components.List'
        Find = "`n    c87v3 = {c87v4}`n"
        Replace = "`n    c87v3[1] = c87v4`n"
        Evidence = 'CreateList (proto 86) pc 143 SETLIST A=3 B=4 C=2 appends R4 to the constructor table R3; derecomp renders it as a fresh table and loses every list field'
    },
    @{
        Module = 'EE.Interface.Components.List'
        Find = "            if not c55v3 then`n              c55v22 = function()`n                local c54v0, c54v1, c54v2`n                c54v0 = c55v0`n                c54v2 = c55v17`n                c54v0:OnElementTransitionEnded(c54v2)`n                c54v1 = c55v19`n                c54v0 = IsNull`n                c54v0 = c54v0(c54v1)`n                if not c54v0 then`n                  c54v0 = c55v19`n"
        Replace = "            if not c55v3 then`n              local __capturedElement, __capturedCallback = c55v17, c55v19`n              c55v22 = function()`n                local c54v0, c54v1, c54v2`n                c54v0 = c55v0`n                c54v2 = __capturedElement`n                c54v0:OnElementTransitionEnded(c54v2)`n                c54v1 = __capturedCallback`n                c54v0 = IsNull`n                c54v0 = c54v0(c54v1)`n                if not c54v0 then`n                  c54v0 = __capturedCallback`n"
        Evidence = 'Redraw (proto 54) pc 308-311 NEWCLOSURE proto 53 with CAPTURE A=0 (by value) of R19/R21; derecomp renders the by-value captures as shared function locals that the draw loop later overwrites'
    }
)

function Get-PatchedRender($Module) {
    $text = [IO.File]::ReadAllText((Join-Path $renderDir "stock\$($Module.Stem).u44.luau")).Replace("`r`n", "`n")
    foreach ($patch in @($renderPatches | Where-Object { $_.Module -eq $Module.Name })) {
        $count = ([regex]::Matches($text, [regex]::Escape($patch.Find))).Count
        if ($count -ne 1) { throw "SCRIPT SETTINGS RENDER GATE FAIL: render patch expected once, found $count ($($patch.Evidence))" }
        $text = $text.Replace($patch.Find, $patch.Replace)
    }
    # DE VM semantics: LENGTH of nil yields 0 instead of raising. Stock relies
    # on it: the layout callback (ThemedGenericSettings proto 16 pc 45-52)
    # evaluates #element.mClipName and #element.mAlignment for every TITLE row,
    # and stock screens draw TITLE rows without mAlignment (AllianceView
    # permission lists through _T.OpenScreen("GenericSettings")). Emulated with
    # __de_len; every rewritten site is a plain `x = #register` statement.
    $lengthSites = [regex]::Matches($text, '(?m)^(\s*)([A-Za-z_][A-Za-z0-9_]*) = #([A-Za-z_][A-Za-z0-9_]*)$').Count
    $allLength = [regex]::Matches($text, '#[A-Za-z_(]').Count
    if ($lengthSites -ne $allLength) { throw "SCRIPT SETTINGS RENDER GATE FAIL: $($Module.Name) has a length operator outside the statement form ($lengthSites of $allLength)" }
    $text = [regex]::Replace($text, '(?m)^(\s*)([A-Za-z_][A-Za-z0-9_]*) = #([A-Za-z_][A-Za-z0-9_]*)$', '$1$2 = __de_len($3)')
    return $text
}

function Invoke-Harness([string]$Bridge, [string]$Tag) {
    $builder = New-Object System.Text.StringBuilder
    $offsets = @{}
    $append = {
        param([string]$Text)
        [void]$builder.Append($Text)
        if (-not $Text.EndsWith("`n")) { [void]$builder.Append("`n") }
    }
    $linesSoFar = { ([regex]::Matches($builder.ToString(), "`n")).Count }
    & $append ([IO.File]::ReadAllText((Join-Path $renderDir "harness_prelude.luau")))
    foreach ($module in $modules) {
        & $append "MODULE_SOURCES[`"$($module.Name)`"] = function(...)"
        $offsets[$module.Name] = & $linesSoFar
        & $append (Get-PatchedRender $module)
        & $append "end"
    }
    & $append "MODULE_SOURCES[`"bridge`"] = function(...)"
    $offsets['bridge'] = & $linesSoFar
    & $append ([IO.File]::ReadAllText($Bridge))
    & $append "end"
    & $append ([IO.File]::ReadAllText((Join-Path $renderDir "harness_driver.luau")))
    $file = Join-Path $scratch "harness_$Tag.luau"
    [IO.File]::WriteAllText($file, $builder.ToString(), (New-Object System.Text.UTF8Encoding($false)))
    $output = @(& $luau $file 2>&1 | ForEach-Object { $_.ToString() })
    return @{ Output = $output; Exit = $LASTEXITCODE; Offsets = $offsets; File = $file }
}

# Map "harness_x.luau:<line>:" in an error back to a stock render line.
function Resolve-RenderLine($Run, [string]$Text) {
    $match = [regex]::Match($Text, 'harness_[a-z0-9]+\.luau:(\d+):')
    if (-not $match.Success) { return $null }
    $line = [int]$match.Groups[1].Value
    $offset = $Run.Offsets['Lotus.Interface.ThemedGenericSettings']
    return $line - $offset
}

# 1. Bridge under test.
$run = Invoke-Harness $bridgeSource 'current'
$run.Output | ForEach-Object { Write-Output "HARNESS`t$_" }
Require ($run.Exit -eq 0) "harness process exits cleanly (current bridge)"
Require (@($run.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0) "no Lua error on open, populate, scroll bar or wheel (current bridge)"
Require (@($run.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "every visible row renders its own frame, label and background through the stock draw (current bridge)"

# 2. Negative control: the installed R2 bridge reproduces the live error.
Require ((Get-TextSha256 $negativeBridge) -eq $inputs['render:ScriptSettingsBridgeV1.r2-2e337a43']) "negative-control bridge is the R2 source of the installed 2e337a43 bytes"
$negative = Invoke-Harness $negativeBridge 'r2'
$negative.Output | Select-Object -First 12 | ForEach-Object { Write-Output "NEGATIVE`t$_" }
$nilError = @($negative.Output | Where-Object { $_ -like 'ERROR*' -and $_.Contains('attempt to perform arithmetic (sub) on nil and number') })
Require ($nilError.Count -ge 1) "negative control: the R2 bridge raises the live nil arithmetic in the stock draw"
$renderLine = Resolve-RenderLine $negative $nilError[0]
$tgsLines = [IO.File]::ReadAllLines((Join-Path $renderDir "stock\Lotus_Interface_ThemedGenericSettings.u44.luau"))
$statement = if ($null -ne $renderLine -and $renderLine -ge 1 -and $renderLine -le $tgsLines.Count) { $tgsLines[$renderLine - 1].Trim() } else { '' }
$context = if ($null -ne $renderLine -and $renderLine -ge 5) { ($tgsLines[($renderLine - 5)..($renderLine - 1)] -join "`n") } else { "" }
Require ($statement -match '^c47v5 = c47v6 - __renovice_local_0$' -and $context.Contains('c47v6 = c47v0.mButtonWidth') -and $context.Contains('"SubLabel"')) "negative control fails at the stock BUTTON sub-label statement mButtonWidth - offset (render line $renderLine = stock source line 991)"
Require (@($negative.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS FAIL*' }).Count -eq 1) "negative control is reported as a harness FAIL"

# 3. Static pins on the bridge under test.
$bridgeText = [IO.File]::ReadAllText($bridgeSource)
Require (-not [regex]::IsMatch($bridgeText, 'mSubLabel\s*=')) "the bridge never builds a stock mSubLabel (the stock draw needs mButtonWidth for it)"
Require ($bridgeText.Contains('local function buttonLabel(spec)')) "the bridge folds a host subLabel into the BUTTON label"

Write-Output "SCRIPT SETTINGS RENDER PASS"
