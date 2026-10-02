# Offline gate: SCRIPT SETTINGS rows through the real stock render (R3, extended R4, 2026-09-30).
#
# R3 live defect (bridge 2e337a43, DLL 731fdb11): every float value BUTTON
# carried mSubLabel without mButtonWidth; the stock draw raised a nil
# arithmetic at source line 991 and aborted the list redraw and the layout.
#
# R4 live defects (bridge 739d8177, DLL a578bb78, full Missions package):
#   - scrolled INPUTCOUNT rows showed an uninitialised count field (raw
#     "SELECT ITEMS", `size="19" color`, "Hold to clear"): stock builds the
#     Minus/Count/Plus widgets once per row, bound to the clip of the first
#     draw (source lines 1081-1152), and never rebuilds them on a scrolled
#     draw, unlike CHECKBOX and TOGGLE (lines 878-880, 927-929);
#   - typing into the stock search box, then clearing it, raised "attempt to
#     index nil with 'mClipName'" in Update (source lines 1627 -> 1474, the
#     per-frame count poll) and the screen could not be left: the filter
#     re-adds populate-time copies, and the polled INPUTCOUNT copy has no
#     widgets.
#
# This gate runs the bridge under test through the stock code itself:
#   settings_render/stock/*.u44.luau   derecomp decompile-mod-u44 renders of the
#                                      44.0.2 stock ThemedGenericSettings and
#                                      EE.Interface.Components.List bytecode
#                                      (hashes pinned in STOCK_INPUTS.txt; the
#                                      render is re-made and compared when the
#                                      stock corpus and derecomp are present);
#   settings_render/harness_*.luau     recording Flash movie (frame-specific
#                                      children reset on a frame change, widget
#                                      binding and stale-write records) + engine
#                                      stubs, and a driver: open, populate, every
#                                      scroll-bar position and the wheel with one
#                                      stock Update per step, every page a BUTTON
#                                      opens (populate, poll, Confirm), the stock
#                                      search filter (type, extend, clear) and
#                                      the Confirm / Exit / Close routes.
# Negative controls: the R2 bridge must fail at the stock sub-label statement
# (line 991); the R3 bridge (the installed 739d8177) must reproduce the R4
# defects: unbound INPUTCOUNT widgets, stale widget writes, the locked-row
# Label dim leak and the line 1474 script error after the search is cleared.
#
# R5 (live 2026-09-30, DLL aebb08e3 + bridge 7b9b9950): a value typed on its
# value page was written with its "Custom" switch off (the switch is a list row
# the completion pass restaged unticked), the list kept showing the old value,
# and an out-of-range value closed with Back was dropped without a message.
# The harness now also drives the nested layout (packages -> package ->
# section -> value page, depth 4) with Confirm, Back (Exit) and Close at every
# level, INPUTBOX and INPUTCOUNT edits, the Back-route validation message, an
# explicit switch click and a section Restore, and prints every host stage
# call; those are replayed through the real C++ host model and values-file
# writer (verify_addon_settings.ps1 -Replay) and each resulting file is
# checked. Negative control R4: the installed bridge 7b9b9950 on the same
# flows leaves the parent page stale and shows no Back-route message.
#
# -PageRows <file>: additionally run the current bridge on the rows of a real
# package: the output of `verify_addon_settings.ps1 -Package <folder>
# -Settings <file>` (PAGE, ROW and VALROW lines), for example a read-only copy
# of the installed Missions package.
param(
    [string]$PageRows = ''
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$workspaceRepos = Split-Path -Parent (Split-Path -Parent $repo)
$toolchain = Join-Path $workspaceRepos "toolchains\de-luau-toolchain"
$luau = Join-Path $toolchain "bin\luau.exe"
$derecomp = Join-Path $toolchain "bin\derecomp.exe"
$renderDir = Join-Path $PSScriptRoot "settings_render"
$bridgeSource = Join-Path $repo "RENOVICE_SCRIPTING\INTERNAL\ScriptSettingsBridgeV1.luau"
$negativeR2 = Join-Path $renderDir "fixtures\ScriptSettingsBridgeV1.r2-2e337a43.luau"
$negativeR3 = Join-Path $renderDir "fixtures\ScriptSettingsBridgeV1.r3-739d8177.luau"
$negativeR4 = Join-Path $renderDir "fixtures\ScriptSettingsBridgeV1.r4-7b9b9950.luau"

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

# R4: the renders are used exactly as derecomp wrote them. The R3 harness had
# to patch two toolchain rendering defects (List CreateList SETLIST into the
# constructor table; List Redraw by-value CAPTURE); derecomp 9c008ae renders
# both correctly. Pin that the fixed forms are present.
$listRender = [IO.File]::ReadAllText((Join-Path $renderDir "stock\EE_Interface_Components_List.u44.luau")).Replace("`r`n", "`n")
Require ($listRender.Contains("`n    c87v3[1] = c87v4`n") -and -not $listRender.Contains("`n    c87v3 = {c87v4}`n")) "List CreateList SETLIST renders as an append (no harness render patch)"
Require ($listRender.Contains('local __renovice_capture_54_1 = c55v17') -and $listRender.Contains('local __renovice_capture_54_2 = c55v19')) "List Redraw by-value captures render as per-closure snapshots (no harness render patch)"

function Get-HarnessRender($Module) {
    $text = [IO.File]::ReadAllText((Join-Path $renderDir "stock\$($Module.Stem).u44.luau")).Replace("`r`n", "`n")
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

# PAGE / ROW / VALROW lines (verify_addon_settings.cpp print_row) -> Luau table.
function ConvertTo-LuauString([string]$Text) {
    $escaped = $Text.Replace('\', '\\').Replace('"', '\"').Replace("`t", '\t')
    return '"' + $escaped + '"'
}
function ConvertTo-LuauRow([string[]]$Fields) {
    # Fields: KIND, setting, label, key=value ... (see print_row).
    $parts = New-Object System.Collections.Generic.List[string]
    $parts.Add("kind = $(ConvertTo-LuauString $Fields[0])")
    if ($Fields[1] -ne '') { $parts.Add("setting = $(ConvertTo-LuauString $Fields[1])") }
    $parts.Add("label = $(ConvertTo-LuauString $Fields[2])")
    $options = New-Object System.Collections.Generic.List[string]
    for ($i = 3; $i -lt $Fields.Count; $i++) {
        $field = $Fields[$i]
        switch -Regex ($field) {
            '^count=(.*)$' { $parts.Add("count = $($Matches[1])"); break }
            '^content=(.*)$' { $parts.Add("content = $(ConvertTo-LuauString $Matches[1])"); break }
            '^value=(on|off)$' { $parts.Add("value = $(if ($Matches[1] -eq 'on') { 'true' } else { 'false' })"); break }
            '^action=(.*)$' { $parts.Add("action = $(ConvertTo-LuauString $Matches[1])"); break }
            '^number=(.*)$' { $parts.Add("number = $($Matches[1])"); break }
            '^option=([^:]*):(.*)$' { $options.Add("{ value = $($Matches[1]), label = $(ConvertTo-LuauString $Matches[2]) }"); break }
            '^min=(.*)$' { $parts.Add("minimum = $($Matches[1])"); break }
            '^max=(.*)$' { $parts.Add("maximum = $($Matches[1])"); break }
            '^validate$' { $parts.Add("validate = true"); break }
            '^integer$' { $parts.Add("integer = true"); break }
            '^invalid=(.*)$' { $parts.Add("invalid = $(ConvertTo-LuauString $Matches[1])"); break }
            '^locked$' { $parts.Add("locked = true"); break }
            '^tooltip=(.*)$' { $parts.Add("tooltip = $(ConvertTo-LuauString $Matches[1])"); break }
            default { throw "SCRIPT SETTINGS RENDER GATE FAIL: unknown row field '$field'" }
        }
    }
    if ($options.Count -gt 0) { $parts.Add("options = { $($options -join ', ') }") }
    return "{ $($parts -join ', ') }"
}
function ConvertTo-HarnessPage([string]$Path) {
    $rows = New-Object System.Collections.Generic.List[string]
    $valpages = @{}
    $titles = @{}
    $title = 'SCRIPT SETTINGS'
    $inlineCounts = 0
    $inputBoxes = 0
    foreach ($line in [IO.File]::ReadAllLines($Path)) {
        $fields = $line.Split("`t")
        if ($fields[0] -eq 'PAGE' -and $fields.Count -ge 2 -and $fields[1] -match '^title=(.*)$') { $title = $Matches[1] }
        elseif ($fields[0] -eq 'ROW') {
            $rows.Add((ConvertTo-LuauRow $fields[1..($fields.Count - 1)]))
            if ($fields[1] -eq 'INPUTCOUNT') { $inlineCounts++ }
            if ($fields[1] -eq 'INPUTBOX') { $inputBoxes++ }
        }
        elseif ($fields[0] -eq 'VALPAGE' -and $fields.Count -ge 3 -and $fields[2] -match '^title=(.*)$') { $titles[$fields[1]] = $Matches[1] }
        elseif ($fields[0] -eq 'VALROW') {
            $action = $fields[1]
            if (-not $valpages.ContainsKey($action)) { $valpages[$action] = New-Object System.Collections.Generic.List[string] }
            $valpages[$action].Add((ConvertTo-LuauRow $fields[2..($fields.Count - 1)]))
        }
    }
    if ($rows.Count -eq 0) { throw "SCRIPT SETTINGS RENDER GATE FAIL: no ROW lines in $Path" }
    $builder = New-Object System.Text.StringBuilder
    [void]$builder.Append("HARNESS_PAGE_DATA = { title = $(ConvertTo-LuauString $title), search = true, source = `"package`", rows = {`n")
    foreach ($row in $rows) { [void]$builder.Append("  $row,`n") }
    [void]$builder.Append("}, valpages = {`n")
    foreach ($action in $valpages.Keys) {
        $pageTitle = if ($titles.ContainsKey($action)) { $titles[$action] } else { '' }
        [void]$builder.Append("  [$(ConvertTo-LuauString $action)] = { title = $(ConvertTo-LuauString $pageTitle), rows = { $($valpages[$action] -join ', ') } },`n")
    }
    [void]$builder.Append("} }`n")
    # Pages the harness opens: every value page, plus (hosts before R4) one
    # row page per inline INPUTCOUNT when the stock list recycles its clips.
    $recycledList = $rows.Count -gt 14 -and $inputBoxes -eq 0
    $expectedPages = $valpages.Count + $(if ($recycledList) { $inlineCounts } else { 0 })
    return @{ Text = $builder.ToString(); Rows = $rows.Count; ValuePages = $valpages.Count; InlineCounts = $inlineCounts; ExpectedPages = $expectedPages }
}

function Invoke-Harness([string]$Bridge, [string]$Tag, [string]$PageData = '', [switch]$R5, [string]$TapeData = '', [switch]$R17, [switch]$R20) {
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
        & $append (Get-HarnessRender $module)
        & $append "end"
    }
    & $append "MODULE_SOURCES[`"bridge`"] = function(...)"
    $offsets['bridge'] = & $linesSoFar
    & $append ([IO.File]::ReadAllText($Bridge))
    & $append "end"
    if ($PageData -ne '') { & $append $PageData }
    if ($R5) { & $append "HARNESS_R5 = true" }
    if ($TapeData -ne '') { & $append $TapeData; & $append $(if ($R20) { "HARNESS_R20 = true" } elseif ($R17) { "HARNESS_R17 = true" } else { "HARNESS_R7 = true" }) }
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
$tgsLines = [IO.File]::ReadAllLines((Join-Path $renderDir "stock\Lotus_Interface_ThemedGenericSettings.u44.luau"))
function Get-RenderStatement($Line) {
    if ($null -ne $Line -and $Line -ge 1 -and $Line -le $tgsLines.Count) { return $tgsLines[$Line - 1].Trim() }
    return ''
}
function Get-RenderContext($Line, [int]$Before) {
    if ($null -ne $Line -and $Line -gt $Before) { return ($tgsLines[($Line - $Before - 1)..($Line - 1)] -join "`n") }
    return ''
}
function Get-Category($Run, [string]$Name) {
    $line = @($Run.Output | Where-Object { $_ -like "CATEGORY`t$Name`t*" })
    if ($line.Count -eq 0) { return 0 }
    return [int]($line[0].Split("`t")[2])
}
function Get-Report($Run) {
    $line = @($Run.Output | Where-Object { $_ -like "REPORT`t*" })
    if ($line.Count -eq 0) { return @{} }
    $report = @{}
    foreach ($pair in $line[0].Substring(7).Split(' ')) {
        $kv = $pair.Split('=', 2)
        if ($kv.Count -eq 2) { $report[$kv[0]] = $kv[1] }
    }
    return $report
}

# 1. Bridge under test, built-in mixed fixture (72 rows: TITLE, CHECKBOX,
# locked CHECKBOX, inline INPUTCOUNT and locked INPUTCOUNT as pre-R4 hosts send
# them, TOGGLE, locked TOGGLE, value BUTTONs with and without a legacy
# subLabel, locked value BUTTONs).
$run = Invoke-Harness $bridgeSource 'current' -R5
$run.Output | Where-Object { $_ -notlike 'CATEGORY*' } | ForEach-Object { Write-Output "HARNESS`t$_" }
$report = Get-Report $run
Require ($run.Exit -eq 0) "harness process exits cleanly (current bridge)"
Require (@($run.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0) "no Lua error on open, populate, scroll bar, wheel, value pages, search filter or close routes (current bridge)"
Require (@($run.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "every visible row renders its own frame, label, background and widgets on its own clip; no stale widget write; no locked-row Label dim (current bridge)"
Require ($report['search_shown'] -eq 'false') "R4: the bridge never shows the stock search box (ShowHideSearchBox is not executed)"
Require ([int]$report['pages'] -ge 12) "R4: every value BUTTON and every INPUTCOUNT stand-in opens a one-row page that populates, polls and confirms ($($report['pages']) pages)"
Require ([int]$report['search_steps'] -eq 21) "the stock search filter was driven through type, extend and clear on the Confirm, Exit and Close opens (21 steps)"
Require ($report['snapshot_revert'] -eq 'true') "stock property pinned (why the search box stays hidden): the filter re-adds populate-time copies, so a CHECKBOX changed before typing shows its old value again"

# 1b. R5 flows (current bridge): nested navigation, returns, refresh, messages.
Require ([int]$report['r5_sessions'] -eq 6) "R5: six recorded editor sessions ran (3 close routes, Frost validation, explicit click, INPUTCOUNT + Restore)"
Require ([int]$report['r5_max_depth'] -eq 4) "R5: nested navigation reaches the value page at depth 4 (packages -> package -> section -> value)"
Require ([int]$report['r5_returns'] -ge 20) "R5: every page closed with Confirm, Back and Close returns to its open, intact parent ($($report['r5_returns']) returns)"
Require ([int]$report['r5_refreshed'] -ge 16) "R5: after each return the parent rows show the staged edit (label, Custom switch, section and package summaries; $($report['r5_refreshed']) checks)"
Require ([int]$report['r5_back_messages'] -eq 1) "R5: Back with an out-of-range value shows the row's stock message (EE.Interface.Utilities.ShowMessage) once"
Require ([int]$report['r5_stock_messages'] -eq 1) "R5: Confirm with an out-of-range value is stopped by the stock validator with its message; the page stays open"

# 1c. R7 (2026-09-30): the real host pages. The fixture packages (the staged R7
# Missions package.json, Frost and Octavia with their author's defaults; member
# files are synthetic: the page model reads only package.json and the member
# names) go through verify_addon_settings.ps1 -Tape, which prints the pages the
# exact C++ page model serves after every planned host call. The bridge under
# test then walks them through the stock screen (HARNESS_R7) and must make
# exactly the planned calls; the tape applies them through the values-file
# writer and checks the resulting files.
$r7Fixture = Join-Path $renderDir 'fixtures\r7'
$r7Packages = Join-Path $scratch 'r7-packages'
if (Test-Path -LiteralPath $r7Packages) { Remove-Item -LiteralPath $r7Packages -Recurse -Force }
$r7Keys = @([IO.File]::ReadAllLines((Join-Path $r7Fixture 'Missions.target_keys.txt')) | Where-Object { $_ -match '^[0-9a-f]{16}$' })
$packageDirs = @()
foreach ($name in @('Missions', 'Frost', 'Octavia')) {
    $dir = Join-Path $r7Packages $name
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $manifestPath = Join-Path $r7Fixture "$name\package.json"
    Copy-Item -LiteralPath $manifestPath -Destination $dir
    # Merged R7 + R8 (R9): the real Missions package carries its live literal recipe.
    $recipePath = Join-Path $r7Fixture "$name\literals.json"
    if (Test-Path -LiteralPath $recipePath -PathType Leaf) { Copy-Item -LiteralPath $recipePath -Destination $dir }
    $manifest = [IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json
    foreach ($member in $manifest.members.PSObject.Properties.Name) {
        $bytes = New-Object System.Collections.Generic.List[byte]
        if ($member -like '*.targets.addon.lua_B') {
            # The synthetic string pool the scanner reads the declared target keys from (as verify_addon_settings.cpp synthetic_pool).
            $bytes.AddRange([byte[]](0x09, 0x03, [byte]$r7Keys.Count))
            foreach ($key in $r7Keys) { $bytes.Add([byte]$key.Length); $bytes.AddRange([Text.Encoding]::ASCII.GetBytes($key)) }
            $bytes.AddRange([byte[]]::new(32))
        }
        else { $bytes.AddRange([Text.Encoding]::ASCII.GetBytes('RENOVICE R7 FIXTURE MEMBER')) }
        [IO.File]::WriteAllBytes((Join-Path $dir $member), $bytes.ToArray())
    }
    $packageDirs += $dir
}
$settingsFiles = @('Missions', 'Frost', 'Octavia') | ForEach-Object { Join-Path $r7Fixture "Settings\$_.json" }
# The stock checkbox reports the first click on a freshly drawn page twice
# (focus, then the widget's ValueChanged); the host takes the unchanged second
# stage as no operation.
$plan = @(
    "STAGE`tactive:missions/survival.reward_interval`tbool`tfalse`tclick",
    "STAGE`tactive:missions/survival.reward_interval`tbool`tfalse`tclick",
    "STAGE`tstored:missions/survival.reward_interval`ttext`t45`trestage",
    "STAGE`tactive:missions/survival.reward_interval`tbool`ttrue`tclick",
    # R10: the Quick settings page holds 14 entries (6 new: Deepmines hold time, Defense waves to finish, Exterminate
    # kills needed, Interception score to win, Spy vault alarm time, Void Armageddon wave time); its completion restages
    # every switch in page order.
    "STAGE`tactive:missions/control_area_deimos.duration`tbool`tfalse`trestage",
    "STAGE`tactive:missions/control_area_nokko.hold_time`tbool`tfalse`trestage",
    "STAGE`tactive:missions/control_area_plains.duration`tbool`tfalse`trestage",
    "STAGE`tactive:missions/defense.waves_to_finish`tbool`tfalse`trestage",
    "STAGE`tactive:missions/excavation.dig_time`tbool`tfalse`trestage",
    "STAGE`tactive:missions/exterminate.kills_scale`tbool`tfalse`trestage",
    "STAGE`tactive:missions/interception.score_goal_scale`tbool`tfalse`trestage",
    "STAGE`tactive:missions/mobiledefense.time_per_terminal`tbool`tfalse`trestage",
    "STAGE`tactive:missions/orphix.spawn_interval`tbool`tfalse`trestage",
    # R11: Quick settings holds 15 entries (new: Railjack: fighters to kill).
    "STAGE`tactive:missions/railjack.fighter_kills_scale`tbool`tfalse`trestage",
    "STAGE`tactive:missions/spy.vault_alarm_scale`tbool`tfalse`trestage",
    "STAGE`tactive:missions/survival.reward_interval`tbool`ttrue`trestage",
    "STAGE`tactive:missions/void_armageddon.wave_time`tbool`tfalse`trestage",
    "STAGE`tactive:missions/void_cascade.pillar_duration`tbool`tfalse`trestage",
    "STAGE`tactive:missions/void_flood.fractures_per_round.normal`tbool`ttrue`trestage",
    "STAGE`tvalue:missions/loopdefend.max_enemies.p4`tnumber`t40`trestage",
    "STAGE`tvalue:missions/survival.reward_interval`ttext`t60`trestage",
    "ACT`treset:Missions/value:survival.reward_interval",
    "STAGE`tvalue:missions/survival.capsule_interval`ttext`t60`trestage",
    "ACT`tresetall:Missions/node:36.0.0",
    # R9 (merged R7 + R8): Mobile Defense -> Timers -> Time per terminal, a live literal (stepper), typed 20.
    "STAGE`tvalue:missions/mobiledefense.time_per_terminal`tnumber`t20`trestage",
    # R10: Defense -> Objectives -> Waves to finish (a MissionInfo count, addon lane, stepper), typed 3.
    "STAGE`tvalue:missions/defense.waves_to_finish`tnumber`t3`trestage",
    # R11: Railjack -> Fighters to kill (an encounter parameter scale, addon lane, INPUTBOX), typed 0.5; Sabotage ->
    # Timers -> Orokin: escape timer (a coupled live literal, stepper), typed 45.
    "STAGE`tvalue:missions/railjack.fighter_kills_scale`ttext`t0.5`trestage",
    "STAGE`tvalue:missions/sabotage.orokin_escape_timer`tnumber`t45`trestage",
    "STAGE`tvalue:frost/ice_wave.bonus_per_cold_stack`ttext`t250`trestage",
    "STAGE`tvalue:frost/ice_wave.bonus_per_cold_stack`ttext`t60`trestage",
    "ACT`tresetall:Frost"
    # Octavia's value page closed with Close (cancel): the stock screen passes no rows, nothing is staged.
)
$tapeExpect = @(
    "EXPECTROW`t3`tquick:Missions`topen:qval:Missions/survival.reward_interval`tSurvival: 45 s",
    # R10 page ids: the Missions package lists 39 mission types (R10 adds Assassination, Rush, Sabotage, Sanctuary
    # Onslaught, Void Armageddon and the Interception, Spy and Legacyte Harvest pages).
    # R11 page ids and steps: the Missions package lists 40 mission types (Railjack is 30; Sabotage 33 and Survival 36
    # move down one); the extra Quick settings restage moves every later step down one.
    "EXPECTROW`t20`tnode:Missions/23.2.0`topen:val:Missions/loopdefend.max_enemies.p4`tSquad: 40",
    "EXPECTROW`t20`tpkg:Missions`topen:node:Missions/23`tMirror Defense: 1 changed",
    "EXPECTROW`t22`tnode:Missions/36.0`topen:val:Missions/survival.reward_interval`tTime between rewards: 300 s (default)",
    "EXPECTROW`t24`tnode:Missions/36.0.0`topen:val:Missions/survival.capsule_interval`tTime between capsules: 90 s (default)",
    "EXPECTROW`t0`tnode:Missions/24.0`topen:val:Missions/mobiledefense.time_per_terminal`tTime per terminal: 60-80 s (default)",
    "EXPECTROW`t0`tquick:Missions`topen:qval:Missions/mobiledefense.time_per_terminal`tMobile Defense: 20 s",
    "EXPECTROW`t25`tnode:Missions/24.0`topen:val:Missions/mobiledefense.time_per_terminal`tTime per terminal: 20 s",
    "EXPECTROW`t25`tpkg:Missions`topen:node:Missions/24`tMobile Defense: 1 changed",
    # R10: the Defense waves-to-finish walk.
    "EXPECTROW`t0`tnode:Missions/9.1`topen:val:Missions/defense.waves_to_finish`tWaves to finish: Endless (default)",
    "EXPECTROW`t0`tquick:Missions`topen:qval:Missions/defense.waves_to_finish`tDefense: Endless (default)",
    "EXPECTROW`t26`tnode:Missions/9.1`topen:val:Missions/defense.waves_to_finish`tWaves to finish: 3",
    "EXPECTROW`t26`tnode:Missions/9`topen:node:Missions/9.1`tObjectives: 1 changed",
    "EXPECTROW`t26`tpkg:Missions`topen:node:Missions/9`tDefense: 1 changed",
    # R11: the Railjack fighters-to-kill walk (one category: the rows sit on the Railjack page) and the Orokin escape
    # timer walk (a coupled live literal).
    "EXPECTROW`t0`tnode:Missions/30`topen:val:Missions/railjack.fighter_kills_scale`tFighters to kill: x1 (20-130) (default)",
    "EXPECTROW`t0`tnode:Missions/30`topen:val:Missions/railjack.crewship_kills_scale`tCrewships to kill: x1 (2-10) (default)",
    "EXPECTROW`t0`tnode:Missions/30`topen:val:Missions/railjack.corpus_fighter_limit_scale`tCorpus fighters: x1 (20-130) (default)",
    "EXPECTROW`t0`tquick:Missions`topen:qval:Missions/railjack.fighter_kills_scale`tRailjack: x1 (20-130) (default)",
    "EXPECTROW`t27`tnode:Missions/30`topen:val:Missions/railjack.fighter_kills_scale`tFighters to kill: 0.5x",
    "EXPECTROW`t27`tpkg:Missions`topen:node:Missions/30`tRailjack: 1 changed",
    "EXPECTROW`t0`tnode:Missions/33.0`topen:val:Missions/sabotage.orokin_escape_timer`tOrokin: escape timer: 30 s (default)",
    "EXPECTROW`t28`tnode:Missions/33.0`topen:val:Missions/sabotage.orokin_escape_timer`tOrokin: escape timer: 45 s",
    "EXPECTROW`t28`tnode:Missions/33`topen:node:Missions/33.0`tTimers: 1 changed",
    "EXPECTROW`t28`tpkg:Missions`topen:node:Missions/33`tSabotage: 1 changed",
    "EXPECTROW`t30`tpkg:Frost`topen:val:Frost/ice_wave.bonus_per_cold_stack`tBonus per Cold stack: 60x",
    "EXPECTROW`t31`tpkg:Frost`topen:val:Frost/ice_wave.bonus_per_cold_stack`tBonus per Cold stack: 50x (default)",
    "EXPECTFILE`tMissions`tloopdefend.max_enemies.p4`tenabled=1`tvalue=40",
    "EXPECTFILE`tMissions`tsurvival.reward_interval`tenabled=0`tvalue=300",
    "EXPECTFILE`tMissions`tsurvival.capsule_interval`tenabled=0`tvalue=90",
    "EXPECTFILE`tFrost`tice_wave.bonus_per_cold_stack`tenabled=0`tvalue=50",
    "EXPECTFILE`tMissions`tmobiledefense.time_per_terminal`tenabled=1`tvalue=20",
    "EXPECTFILE`tMissions`tdefense.waves_to_finish`tenabled=1`tvalue=3",
    "EXPECTFILE`tMissions`trailjack.fighter_kills_scale`tenabled=1`tvalue=0.5",
    "EXPECTFILE`tMissions`tsabotage.orokin_escape_timer`tenabled=1`tvalue=45",
    # R11: the coupled site. 45 s writes the escape timer LOADN 45 and its host-migration threshold LOADN 42 (45 - 3).
    "EXPECTPLAN`tMissions`ta0cea91cc0ac3b31`tvalues=sabotage.orokin_escape_timer`trows=sabotage.orokin_escape_timer=45`tpatches=2",
    # R9: the written file resolves to the LIVE_LITERALS_V1 plans (and, with the stock corpus, synthesizes): the master
    # sets both total-time rows to 20 x 3 = 60 s (20 s per terminal on every node); Void Flood 4 from the shipped file.
    "EXPECTPLAN`tMissions`ta807aae359ffc1eb`tvalues=mobiledefense.time_per_terminal`trows=mobiledefense.total_time.maximum=60,mobiledefense.total_time.minimum=60`tpatches=2",
    "EXPECTPLAN`tMissions`tfc711ff621a75552`tvalues=void_flood.fractures_per_round.normal`trows=void_flood.fractures_per_round.normal=4`tpatches=1",
    "EXPECTFILE`tOctavia`tfile=unchanged"
)
$planFile = Join-Path $scratch 'r7_tape_plan.txt'
[IO.File]::WriteAllText($planFile, ((@($plan) + $tapeExpect) -join "`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    # R9: with the U44 stock corpus the tape also synthesizes every planned module (size, SHA-256, preimages, diff).
    $corpusDir = Join-Path (Split-Path -Parent $workspaceRepos) 'shared\corpus\de-luau-u44.0.2-authoring'
    $corpusArgs = if (Test-Path -LiteralPath (Join-Path $corpusDir 'Lotus_Scripts_MobileDefense.lua_B') -PathType Leaf) { @('-Corpus', $corpusDir) } else { @() }
    $tapeOutput = @(& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo 'RENOVICE_TOOLCHAIN\settings\verify_addon_settings.ps1') -Package ($packageDirs -join ';') -Settings ($settingsFiles -join ';') -Tape $planFile @corpusArgs 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $tapeExit = $LASTEXITCODE
}
finally { $ErrorActionPreference = $previousPreference }
$tapeOutput | Where-Object { $_ -like 'TAPEOP*' -or $_ -like 'TAPESTEPS*' -or $_ -like 'TAPEPLAN*' -or $_ -like 'FAIL*' -or ($_ -like 'PASS*' -and $_.Contains('tape')) } | ForEach-Object { Write-Output "R7-TAPE`t$_" }
$synthesized = @($tapeOutput | Where-Object { $_ -like "TAPEPLAN`tMissions`ta807aae359ffc1eb`t*" -and $_.Contains("`tsynthesis=pass") })
if ($corpusArgs.Count -gt 0) { Require ($synthesized.Count -eq 1) "R9: the Mobile Defense plan of the written values file synthesizes from the real U44 stock bytes (stock size, SHA-256, every preimage, permitted diff)" }
else { Write-Output "INFO`tU44 stock corpus absent: the R9 plan is checked without synthesis" }
Require ($tapeExit -eq 0 -and ($tapeOutput -contains 'ADDON SETTINGS PASS') -and @($tapeOutput | Where-Object { $_ -like 'FAIL*' }).Count -eq 0) "R7 host tape: the fixture packages pass the scanner and page model, every planned call is applied and every EXPECTROW/EXPECTFILE holds ($($tapeExpect.Count) checks)"
$steps = @{}
$pageOrder = @{}
foreach ($line in $tapeOutput) {
    $fields = $line.Split("`t")
    if ($fields[0] -eq 'TAPEPAGE') {
        $key = "$($fields[1])|$($fields[2])"
        $title = ($fields[3] -replace '^title=', '')
        $empty = ($fields[4] -replace '^empty=', '')
        $steps[$key] = @{ Step = [int]$fields[1]; Id = $fields[2]; Title = $title; Empty = $empty; Rows = (New-Object System.Collections.Generic.List[string]) }
    }
    elseif ($fields[0] -eq 'TAPEROW') {
        $key = "$($fields[1])|$($fields[2])"
        $steps[$key].Rows.Add((ConvertTo-LuauRow $fields[3..($fields.Count - 1)]))
    }
}
$tape = New-Object System.Text.StringBuilder
[void]$tape.Append("HARNESS_TAPE = { plan = {`n")
foreach ($call in $plan) { [void]$tape.Append("  $(ConvertTo-LuauString $call),`n") }
[void]$tape.Append("}, steps = {}`n}`n")
foreach ($entry in ($steps.Values | Sort-Object { $_.Step })) {
    [void]$tape.Append("HARNESS_TAPE.steps[$($entry.Step)] = HARNESS_TAPE.steps[$($entry.Step)] or {}`n")
    [void]$tape.Append("HARNESS_TAPE.steps[$($entry.Step)][$(ConvertTo-LuauString $entry.Id)] = { title = $(ConvertTo-LuauString $entry.Title), empty = $(ConvertTo-LuauString $entry.Empty), search = false, rows = {`n")
    foreach ($row in $entry.Rows) { [void]$tape.Append("  $row,`n") }
    [void]$tape.Append("} }`n")
}
Require ($steps.Count -gt 100) "R7 host tape holds the reachable pages and every page a call changed ($($steps.Count) page versions)"
$r7 = Invoke-Harness $bridgeSource 'r7' '' -TapeData $tape.ToString()
$r7.Output | Where-Object { $_ -like 'TAPECALL*' -or $_ -like 'R7REPORT*' -or $_ -like 'FAIL*' -or $_ -like 'ERROR*' -or $_ -like 'SCRIPT SETTINGS RENDER HARNESS*' } | Select-Object -First 80 | ForEach-Object { Write-Output "R7`t$_" }
$r7Line = @($r7.Output | Where-Object { $_ -like "R7REPORT`t*" })
$r7Report = @{}
if ($r7Line.Count -gt 0) { foreach ($pair in $r7Line[0].Substring(9).Split(' ')) { $kv = $pair.Split('=', 2); if ($kv.Count -eq 2) { $r7Report[$kv[0]] = $kv[1] } } }
Require ($r7.Exit -eq 0 -and @($r7.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0 -and @($r7.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "R7: the bridge renders every real host page it opens through the stock screen with no Lua error; every drawn row shows its own label and widgets"
Require ([int]$r7Report['calls'] -eq $plan.Count -and (Get-Category $r7 'r7-plan') -eq 0) "R7: the bridge made exactly the $($plan.Count) planned host calls (edits, restages, resets), in order"
Require ([int]$r7Report['max_depth'] -ge 6) "R7: Missions -> Mirror Defense -> Enemies -> Max enemies at once -> Squad reaches the value page at depth 6"
Require ([int]$r7Report['returns'] -ge 16 -and (Get-Category $r7 'r7-close') -eq 0 -and (Get-Category $r7 'r7-nav') -eq 0) "R7: every page closed with Confirm, Back (Exit) and Close returns to its open, intact parent ($($r7Report['returns']) returns)"
Require ([int]$r7Report['refreshed'] -ge 14 -and (Get-Category $r7 'r7-refresh') -eq 0) "R7: after each return and each in-place reset the rows show the host's new text (value, '(default)', 'N changed', quick on/off; $($r7Report['refreshed']) checks)"
Require ([int]$r7Report['inplace'] -eq 2) "R7: 'Reset all to defaults' re-reads its page in place (Missions Life support, Frost) and the page stays open"
Require ([int]$r7Report['messages'] -eq 1 -and (Get-Category $r7 'r7-validate') -eq 0) "R7: Back with an out-of-range value shows the row's stock message (Frost 250)"
Require ([int]$r7Report['switches'] -eq 0 -and (Get-Category $r7 'r7-switch') -eq 0) "R7: no page the player opens holds a package, member, 'Use stock values', section or Custom switch"
Require ([int]$r7Report['r9'] -eq 1) "R9: Missions -> Mobile Defense -> Timers -> Time per terminal (live literal, range default '60-80 s (default)') opens a stepper, 20 is typed and applied, and the rows read 'Time per terminal: 20 s', 'Timers: 1 changed', 'Mobile Defense: 1 changed'"
$orokinSynthesized = @($tapeOutput | Where-Object { $_ -like "TAPEPLAN`tMissions`ta0cea91cc0ac3b31`t*" -and $_.Contains("`tsynthesis=pass") })
if ($corpusArgs.Count -gt 0) { Require ($orokinSynthesized.Count -eq 1) "R11: the Orokin escape timer plan (a coupled site, value_offset -3) synthesizes from the real U44 stock bytes" }
Require ([int]$r7Report['r11'] -eq 2) "R11: Missions -> Railjack -> Fighters to kill ('x1 (20-130) (default)', one category, rows on the Railjack page) takes 0.5 ('Fighters to kill: 0.5x', 'Railjack: 1 changed'); Missions -> Sabotage -> Timers -> Orokin: escape timer (coupled live literal) takes 45 ('Orokin: escape timer: 45 s', 'Timers: 1 changed', 'Sabotage: 1 changed')"
Require ([int]$r7Report['r10'] -eq 1) "R10: Missions -> Defense -> Objectives -> Waves to finish ('Endless (default)', a MissionInfo count) opens a stepper, 3 is typed and applied, and the rows read 'Waves to finish: 3', 'Objectives: 1 changed', 'Defense: 1 changed'; the values file holds { enabled: true, value: 3 }"

# 1d. R17 (2026-10-01): "All <mission type> missions" masters. A value declared
# quick_on_page shows its Quick settings pair (CHECKBOX on/off + BUTTON with the
# kept number) at the top of its mission-type page. The real R17 Missions
# package (fixtures\r17, the build staged in work\staging\combined-r17) goes
# through the host tape; the bridge under test walks Missions -> Survival ->
# "All Survival missions" (its kept number) -> 60 -> back, then Quick settings
# must show the same 60 (one storage: stored:/active:).
$r17Fixture = Join-Path $renderDir 'fixtures\r17'
$r17Packages = Join-Path $scratch 'r17-packages'
if (Test-Path -LiteralPath $r17Packages) { Remove-Item -LiteralPath $r17Packages -Recurse -Force }
$r17Keys = @([IO.File]::ReadAllLines((Join-Path $r17Fixture 'Missions.target_keys.txt')) | Where-Object { $_ -match '^[0-9a-f]{16}$' })
$r17Dir = Join-Path $r17Packages 'Missions'
New-Item -ItemType Directory -Path $r17Dir -Force | Out-Null
foreach ($name in @('package.json', 'literals.json')) { Copy-Item -LiteralPath (Join-Path $r17Fixture "Missions\$name") -Destination $r17Dir }
$r17Manifest = [IO.File]::ReadAllText((Join-Path $r17Fixture 'Missions\package.json')) | ConvertFrom-Json
foreach ($member in $r17Manifest.members.PSObject.Properties.Name) {
    $bytes = New-Object System.Collections.Generic.List[byte]
    $bytes.AddRange([byte[]](0x09, 0x03, [byte]$r17Keys.Count))
    foreach ($key in $r17Keys) { $bytes.Add([byte]$key.Length); $bytes.AddRange([Text.Encoding]::ASCII.GetBytes($key)) }
    $bytes.AddRange([byte[]]::new(32))
    [IO.File]::WriteAllBytes((Join-Path $r17Dir $member), $bytes.ToArray())
}
$r17Plan = @(
    # The kept-number page closed with Confirm, then the Survival page closed with Back (its switch restaged unchanged).
    "STAGE`tstored:missions/survival.reward_interval`ttext`t60`trestage",
    "STAGE`tactive:missions/survival.reward_interval`tbool`ttrue`trestage"
)
$r17Expect = @(
    "EXPECTROW`t0`tnode:Missions/36`tactive:missions/survival.reward_interval`tAll Survival missions",
    "EXPECTROW`t0`tnode:Missions/36`topen:qval:Missions/survival.reward_interval`tTime between rewards: 150 s",
    "EXPECTROW`t0`tnode:Missions/7`tactive:missions/control_area.hold_time`tAll Control Area missions",
    "EXPECTROW`t0`tnode:Missions/30`topen:qval:Missions/railjack.kill_goals_scale`tKill goals: x1 (default)",
    "EXPECTROW`t1`tnode:Missions/36`topen:qval:Missions/survival.reward_interval`tTime between rewards: 60 s",
    "EXPECTROW`t1`tquick:Missions`topen:qval:Missions/survival.reward_interval`tSurvival: 60 s",
    "EXPECTROW`t2`tquick:Missions`tactive:missions/survival.reward_interval`tSurvival: time between rewards",
    "EXPECTFILE`tMissions`tsurvival.reward_interval`tenabled=1`tvalue=60"
)
$r17PlanFile = Join-Path $scratch 'r17_tape_plan.txt'
[IO.File]::WriteAllText($r17PlanFile, ((@($r17Plan) + $r17Expect) -join "`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    $r17TapeOutput = @(& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo 'RENOVICE_TOOLCHAIN\settings\verify_addon_settings.ps1') -Package $r17Dir -Settings (Join-Path $r17Fixture 'Settings\Missions.json') -Tape $r17PlanFile 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $r17TapeExit = $LASTEXITCODE
}
finally { $ErrorActionPreference = $previousPreference }
$r17TapeOutput | Where-Object { $_ -like 'TAPEOP*' -or $_ -like 'TAPESTEPS*' -or $_ -like 'FAIL*' -or ($_ -like 'PASS*' -and $_.Contains('tape')) } | ForEach-Object { Write-Output "R17-TAPE`t$_" }
Require ($r17TapeExit -eq 0 -and ($r17TapeOutput -contains 'ADDON SETTINGS PASS') -and @($r17TapeOutput | Where-Object { $_ -like 'FAIL*' }).Count -eq 0) "R17 host tape: the R17 Missions package passes the scanner and page model, both planned calls apply and every EXPECTROW/EXPECTFILE holds ($($r17Expect.Count) checks)"
$r17Steps = @{}
foreach ($line in $r17TapeOutput) {
    $fields = $line.Split("`t")
    if ($fields[0] -eq 'TAPEPAGE') {
        $key = "$($fields[1])|$($fields[2])"
        $r17Steps[$key] = @{ Step = [int]$fields[1]; Id = $fields[2]; Title = ($fields[3] -replace '^title=', ''); Empty = ($fields[4] -replace '^empty=', ''); Rows = (New-Object System.Collections.Generic.List[string]) }
    }
    elseif ($fields[0] -eq 'TAPEROW') {
        $r17Steps["$($fields[1])|$($fields[2])"].Rows.Add((ConvertTo-LuauRow $fields[3..($fields.Count - 1)]))
    }
}
$r17Tape = New-Object System.Text.StringBuilder
[void]$r17Tape.Append("HARNESS_TAPE = { plan = {`n")
foreach ($call in $r17Plan) { [void]$r17Tape.Append("  $(ConvertTo-LuauString $call),`n") }
[void]$r17Tape.Append("}, steps = {}`n}`n")
foreach ($entry in ($r17Steps.Values | Sort-Object { $_.Step })) {
    [void]$r17Tape.Append("HARNESS_TAPE.steps[$($entry.Step)] = HARNESS_TAPE.steps[$($entry.Step)] or {}`n")
    [void]$r17Tape.Append("HARNESS_TAPE.steps[$($entry.Step)][$(ConvertTo-LuauString $entry.Id)] = { title = $(ConvertTo-LuauString $entry.Title), empty = $(ConvertTo-LuauString $entry.Empty), search = false, rows = {`n")
    foreach ($row in $entry.Rows) { [void]$r17Tape.Append("  $row,`n") }
    [void]$r17Tape.Append("} }`n")
}
$r17 = Invoke-Harness $bridgeSource 'r17' '' -TapeData $r17Tape.ToString() -R17
$r17.Output | Where-Object { $_ -like 'TAPECALL*' -or $_ -like 'R7REPORT*' -or $_ -like 'FAIL*' -or $_ -like 'ERROR*' -or $_ -like 'SCRIPT SETTINGS RENDER HARNESS*' } | Select-Object -First 40 | ForEach-Object { Write-Output "R17`t$_" }
$r17Line = @($r17.Output | Where-Object { $_ -like "R7REPORT`t*" })
$r17Report = @{}
if ($r17Line.Count -gt 0) { foreach ($pair in $r17Line[0].Substring(9).Split(' ')) { $kv = $pair.Split('=', 2); if ($kv.Count -eq 2) { $r17Report[$kv[0]] = $kv[1] } } }
Require ($r17.Exit -eq 0 -and @($r17.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0 -and @($r17.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "R17: the bridge renders the R17 pages (a CHECKBOX and its kept-number BUTTON on a mission-type page) through the stock screen with no Lua error"
Require ([int]$r17Report['calls'] -eq $r17Plan.Count -and (Get-Category $r17 'r7-plan') -eq 0) "R17: the bridge made exactly the $($r17Plan.Count) planned host calls, in order"
Require ([int]$r17Report['r17'] -eq 2 -and (Get-Category $r17 'r7-refresh') -eq 0 -and (Get-Category $r17 'r7-close') -eq 0 -and (Get-Category $r17 'r7-nav') -eq 0) "R17: Missions -> Survival -> 'All Survival missions' (on) -> 'Time between rewards: 150 s' -> 60 -> back reads 'Time between rewards: 60 s'; Quick settings then shows 'Survival: 60 s' with its switch on (one storage)"

# 1e. R20 (2026-10-02): multiplier minimums. Every "x" multiplier of the
# Missions package accepts 0.001 (or a floor with its reason). The real R20
# Missions package (fixtures\r20, the build staged in work\staging\combined-r20)
# goes through the host tape (the exact C++ page model, staging, values-file
# writer and live-literal synthesis); the bridge under test types 0.001 into the
# stock INPUTBOX of value pages of every editor shape (a scale_count row, a
# master's kept number on its page pair, a scale_inverse master, a named-setting
# count multiplier, a live literal, a multiplier that was whole-number only before
# R20) and Confirms. Each row must then read "<row>: 0.001x", the page opened again
# must show 0.001 in its field, and the written values file must hold exactly
# 0.001. A value under a floor (Void orb value, minimum 0.06) is refused with the
# row's stock message and changes nothing.
$r20Fixture = Join-Path $renderDir 'fixtures\r20'
$r20Packages = Join-Path $scratch 'r20-packages'
if (Test-Path -LiteralPath $r20Packages) { Remove-Item -LiteralPath $r20Packages -Recurse -Force }
$r20Keys = @([IO.File]::ReadAllLines((Join-Path $r20Fixture 'Missions.target_keys.txt')) | Where-Object { $_ -match '^[0-9a-f]{16}$' })
$r20Dir = Join-Path $r20Packages 'Missions'
New-Item -ItemType Directory -Path $r20Dir -Force | Out-Null
foreach ($name in @('package.json', 'literals.json')) { Copy-Item -LiteralPath (Join-Path $r20Fixture "Missions\$name") -Destination $r20Dir }
$r20Manifest = [IO.File]::ReadAllText((Join-Path $r20Fixture 'Missions\package.json')) | ConvertFrom-Json
foreach ($member in $r20Manifest.members.PSObject.Properties.Name) {
    $bytes = New-Object System.Collections.Generic.List[byte]
    $bytes.AddRange([byte[]](0x09, 0x03, [byte]$r20Keys.Count))
    foreach ($key in $r20Keys) { $bytes.Add([byte]$key.Length); $bytes.AddRange([Text.Encoding]::ASCII.GetBytes($key)) }
    $bytes.AddRange([byte[]]::new(32))
    [IO.File]::WriteAllBytes((Join-Path $r20Dir $member), $bytes.ToArray())
}
# Every declared x value accepts 0.001 unless it is one of the R20 floors (the host's own declaration parser is checked
# by the tape run below; this is the fixture's declared range).
$r20Declared = @{}
foreach ($member in $r20Manifest.members.PSObject.Properties) { foreach ($value in $member.Value.settings.values.PSObject.Properties) { $r20Declared[$value.Name] = $value.Value } }
foreach ($value in ([IO.File]::ReadAllText((Join-Path $r20Fixture 'Missions\literals.json')) | ConvertFrom-Json).values.PSObject.Properties) { $r20Declared[$value.Name] = $value.Value.declaration }
$r20Floors = @{ 'interception.scoring_speed' = 0.1; 'void_flood.orb_value_scale' = 0.06; 'purge.alert_tiers.tier1_multiplier' = 0.134; 'purge.alert_tiers.tier2_multiplier' = 0.134; 'purge.alert_tiers.tier3_multiplier' = 0.134 }
$r20X = @($r20Declared.Keys | Where-Object { $r20Declared[$_].unit -eq 'x' })
$r20Above = @($r20X | Where-Object { [double]$r20Declared[$_].min -gt 0.001 -and -not ($r20Floors.ContainsKey($_) -and [double]$r20Declared[$_].min -eq $r20Floors[$_]) })
Require ($r20X.Count -eq 51 -and $r20Above.Count -eq 0 -and @($r20X | Where-Object { $r20Declared[$_].type -ne 'float' }).Count -eq 0) "R20 fixture: the $($r20X.Count) x values of the Missions package are fractional and accept 0.001 except the five recorded floors (scoring speed 0.1, orb value 0.06, Alert Purge tiers 0.134)"
# The walks: path from the Missions page, the row (label prefix), the text typed, the row before and after.
$r20Walks = @(
    @{ Name = 'railjack fighters'; Path = @('Railjack'); Row = 'Fighters to kill'; Before = 'Fighters to kill: x1 (20-130) (default)'; After = 'Fighters to kill: 0.001x'; Setting = 'value:missions/railjack.fighter_kills_scale'; Id = 'railjack.fighter_kills_scale'; Enabled = 1; Invalid = $false },
    @{ Name = 'railjack master'; Path = @('Railjack'); Row = 'Kill goals'; Before = 'Kill goals: x1 (default)'; After = 'Kill goals: 0.001x'; Setting = 'stored:missions/railjack.kill_goals_scale'; Id = 'railjack.kill_goals_scale'; Enabled = 0; Invalid = $false },
    @{ Name = 'exterminate master'; Path = @('Exterminate'); Row = 'Kills needed'; Before = 'Kills needed: x1 (formula) (default)'; After = 'Kills needed: 0.001x'; Setting = 'stored:missions/exterminate.kills_scale'; Id = 'exterminate.kills_scale'; Enabled = 0; Invalid = $false },
    @{ Name = 'void flood capacity'; Path = @('Void Flood', 'Objectives'); Row = 'Tank capacity'; Before = 'Tank capacity: x1 (125-350) (default)'; After = 'Tank capacity: 0.001x'; Setting = 'value:missions/void_flood.tank_capacity_scale'; Id = 'void_flood.tank_capacity_scale'; Enabled = 1; Invalid = $false },
    @{ Name = 'void flood orb floor'; Path = @('Void Flood', 'Objectives'); Row = 'Void orb value'; Before = 'Void orb value: x1 (5-60) (default)'; After = ''; Setting = 'value:missions/void_flood.orb_value_scale'; Id = 'void_flood.orb_value_scale'; Enabled = 0; Invalid = $true },
    @{ Name = 'kela literal'; Path = @('Assassination', 'Enemies', 'Kela De Thaym health'); Row = 'Duo'; Before = 'Duo: 2x (default)'; After = 'Duo: 0.001x'; Setting = 'value:missions/assassination.kela_health.p2'; Id = 'assassination.kela_health.p2'; Enabled = 1; Invalid = $false },
    @{ Name = 'capture solo'; Path = @('Capture', 'Objectives', 'Target health'); Row = 'Solo'; Before = 'Solo: 1x (default)'; After = 'Solo: 0.001x'; Setting = 'value:missions/capture.target_health_player_mult.p1'; Id = 'capture.target_health_player_mult.p1'; Enabled = 1; Invalid = $false }
)
# The bridge stages what the player typed on every close route (R5); the host refuses 0.001 under a floor
# (outside-min-max), so the values file keeps that value unchanged.
$r20Plan = @($r20Walks | ForEach-Object { "STAGE`t$($_.Setting)`ttext`t0.001`trestage" })
$r20Expect = New-Object System.Collections.Generic.List[string]
foreach ($walk in $r20Walks) { $r20Expect.Add("EXPECTFILE`tMissions`t$($walk.Id)`tenabled=$($walk.Enabled)`tvalue=$(if ($walk.Invalid) { '1' } else { '0.001' })") }
# The Kela health literal: the written file resolves to a synthesis plan with the number constant 0.001 (and, with the
# U44 stock corpus, the module is synthesized from its real stock bytes).
$r20Expect.Add("EXPECTPLAN`tMissions`t9ddf18235b5c4abb`tvalues=assassination.kela_health.p2`trows=assassination.kela_health.p2=0.001`tpatches=1")
$r20PlanFile = Join-Path $scratch 'r20_tape_plan.txt'
[IO.File]::WriteAllText($r20PlanFile, ((@($r20Plan) + $r20Expect) -join "`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
$previousPreference = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    $r20TapeOutput = @(& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repo 'RENOVICE_TOOLCHAIN\settings\verify_addon_settings.ps1') -Package $r20Dir -Settings (Join-Path $r20Fixture 'Settings\Missions.json') -Tape $r20PlanFile @corpusArgs 2>&1 | ForEach-Object { $_.ToString().TrimEnd("`r") })
    $r20TapeExit = $LASTEXITCODE
}
finally { $ErrorActionPreference = $previousPreference }
$r20TapeOutput | Where-Object { $_ -like 'TAPEOP*' -or $_ -like 'TAPESTEPS*' -or $_ -like 'TAPEPLAN*' -or $_ -like 'FAIL*' -or ($_ -like 'PASS*' -and $_.Contains('tape')) } | ForEach-Object { Write-Output "R20-TAPE`t$_" }
Require ($r20TapeExit -eq 0 -and ($r20TapeOutput -contains 'ADDON SETTINGS PASS') -and @($r20TapeOutput | Where-Object { $_ -like 'FAIL*' }).Count -eq 0 -and @($r20TapeOutput | Where-Object { $_ -like 'TAPEOP*' -and $_.Contains('REJECT') }).Count -eq 1 -and @($r20TapeOutput | Where-Object { $_ -like "TAPEOP*stage value:missions/void_flood.orb_value_scale = 0.001 (restage) -> REJECT outside-min-max" }).Count -eq 1) "R20 host tape: the R20 Missions package passes the scanner and page model, the host accepts every typed 0.001 except under the orb value floor (REJECT outside-min-max), and the values file holds exactly 0.001 for each accepted value and the default for the refused one ($($r20Expect.Count) checks)"
if ($corpusArgs.Count -gt 0) { Require (@($r20TapeOutput | Where-Object { $_ -like "TAPEPLAN`tMissions`t9ddf18235b5c4abb`t*" -and $_.Contains("`tsynthesis=pass") }).Count -eq 1) "R20: the Kela health plan (number constant 0.001) synthesizes from the real U44 stock bytes" }
$r20Steps = @{}
$r20Labels = New-Object System.Collections.Generic.List[string]
foreach ($line in $r20TapeOutput) {
    $fields = $line.Split("`t")
    if ($fields[0] -eq 'TAPEPAGE') {
        $key = "$($fields[1])|$($fields[2])"
        $r20Steps[$key] = @{ Step = [int]$fields[1]; Id = $fields[2]; Title = ($fields[3] -replace '^title=', ''); Empty = ($fields[4] -replace '^empty=', ''); Rows = (New-Object System.Collections.Generic.List[string]) }
    }
    elseif ($fields[0] -eq 'TAPEROW') {
        $r20Steps["$($fields[1])|$($fields[2])"].Rows.Add((ConvertTo-LuauRow $fields[3..($fields.Count - 1)]))
        $r20Labels.Add($fields[5])
    }
}
foreach ($walk in ($r20Walks | Where-Object { -not $_.Invalid })) { Require ($r20Labels.Contains($walk.After)) "R20 host model: a page row reads '$($walk.After)' after the typed 0.001 (no rounding to 0 or to 2 decimals)" }
$r20Tape = New-Object System.Text.StringBuilder
[void]$r20Tape.Append("HARNESS_TAPE = { plan = {`n")
foreach ($call in $r20Plan) { [void]$r20Tape.Append("  $(ConvertTo-LuauString $call),`n") }
[void]$r20Tape.Append("}, steps = {}`n}`n")
foreach ($entry in ($r20Steps.Values | Sort-Object { $_.Step })) {
    [void]$r20Tape.Append("HARNESS_TAPE.steps[$($entry.Step)] = HARNESS_TAPE.steps[$($entry.Step)] or {}`n")
    [void]$r20Tape.Append("HARNESS_TAPE.steps[$($entry.Step)][$(ConvertTo-LuauString $entry.Id)] = { title = $(ConvertTo-LuauString $entry.Title), empty = $(ConvertTo-LuauString $entry.Empty), search = false, rows = {`n")
    foreach ($row in $entry.Rows) { [void]$r20Tape.Append("  $row,`n") }
    [void]$r20Tape.Append("} }`n")
}
[void]$r20Tape.Append("HARNESS_R20_WALK = {`n")
foreach ($walk in $r20Walks) {
    $pathText = ($walk.Path | ForEach-Object { ConvertTo-LuauString $_ }) -join ', '
    [void]$r20Tape.Append("  { name = $(ConvertTo-LuauString $walk.Name), path = { $pathText }, row = $(ConvertTo-LuauString $walk.Row), text = `"0.001`", before = $(ConvertTo-LuauString $walk.Before), after = $(ConvertTo-LuauString $walk.After), invalid = $(if ($walk.Invalid) { 'true' } else { 'false' }) },`n")
}
[void]$r20Tape.Append("}`n")
$r20 = Invoke-Harness $bridgeSource 'r20' '' -TapeData $r20Tape.ToString() -R20
$r20.Output | Where-Object { $_ -like 'TAPECALL*' -or $_ -like 'R7REPORT*' -or $_ -like 'FAIL*' -or $_ -like 'ERROR*' -or $_ -like 'SCRIPT SETTINGS RENDER HARNESS*' } | Select-Object -First 60 | ForEach-Object { Write-Output "R20`t$_" }
$r20Line = @($r20.Output | Where-Object { $_ -like "R7REPORT`t*" })
$r20Report = @{}
if ($r20Line.Count -gt 0) { foreach ($pair in $r20Line[0].Substring(9).Split(' ')) { $kv = $pair.Split('=', 2); if ($kv.Count -eq 2) { $r20Report[$kv[0]] = $kv[1] } } }
$r20Valid = @($r20Walks | Where-Object { -not $_.Invalid }).Count
Require ($r20.Exit -eq 0 -and @($r20.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0 -and @($r20.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "R20: the bridge renders the R20 pages and value pages through the stock screen with no Lua error"
Require ([int]$r20Report['calls'] -eq $r20Plan.Count -and (Get-Category $r20 'r7-plan') -eq 0) "R20: the bridge made exactly the $($r20Plan.Count) planned host calls (each 0.001 staged as the typed text)"
Require ([int]$r20Report['r20'] -eq $r20Valid -and (Get-Category $r20 'r7-refresh') -eq 0 -and (Get-Category $r20 'r20-field') -eq 0 -and (Get-Category $r20 'r7-close') -eq 0 -and (Get-Category $r20 'r7-nav') -eq 0) "R20: for each of the $r20Valid value pages 0.001 is typed into the stock INPUTBOX and confirmed, the row then reads '<row>: 0.001x', and the page opened again shows 0.001 in its field"
Require ([int]$r20Report['messages'] -eq 1 -and (Get-Category $r20 'r20-floor') -eq 0) "R20: 0.001 under the Void orb value floor (0.06) is refused with the row's stock message on Back and the row keeps its default"

# 2. Negative control R3: the installed bridge 739d8177 on the same page
# reproduces the live R4 defects.
Require ((Get-TextSha256 $negativeR3) -eq $inputs['render:ScriptSettingsBridgeV1.r3-739d8177']) "negative-control bridge is the R3 source of the installed 739d8177 bytes"
$r3 = Invoke-Harness $negativeR3 'r3'
$r3.Output | Where-Object { $_ -like 'CATEGORY*' -or $_ -like 'REPORT*' -or $_ -like 'SCRIPT SETTINGS RENDER HARNESS*' } | ForEach-Object { Write-Output "NEGATIVE-R3`t$_" }
$r3.Output | Where-Object { $_ -like 'FAIL*' } | Select-Object -First 6 | ForEach-Object { Write-Output "NEGATIVE-R3`t$_" }
Require ((Get-Category $r3 'widget-unbound') -ge 1) "negative control R3: a scrolled INPUTCOUNT row shows a count field that was never built on its clip (live glitch 1)"
Require ((Get-Category $r3 'stale-widget-write') -ge 1) "negative control R3: INPUTCOUNT widgets keep writing into a clip another row now owns"
Require ((Get-Category $r3 'locked-dim-leak') -ge 1) "negative control R3: a locked row leaves its Label at alpha 60 for the next row drawn in the clip"
$pollError = @($r3.Output | Where-Object { $_ -like 'ERROR*' -and $_.Contains("attempt to index nil with 'mClipName'") })
Require ($pollError.Count -ge 1) "negative control R3: typing into the stock search box and clearing it raises the live error 'attempt to index nil with 'mClipName''"
$pollLine = Resolve-RenderLine $r3 $pollError[0]
$pollContext = Get-RenderContext $pollLine 10
Require ((Get-RenderStatement $pollLine) -eq 'c56v5 = c56v5.mClipName' -and $pollContext.Contains(':GetElementIndexById(c56v2)') -and $pollContext.Contains('c56v5 = c56v1.mCountButton')) "negative control R3 fails in the stock count poll: element.mCountButton.mClipName (render line $pollLine = stock source line 1474, called from Update line 1627)"
Require (@($r3.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS FAIL*' }).Count -eq 1) "negative control R3 is reported as a harness FAIL"

# 2b. Negative control R4: the installed bridge 7b9b9950 on the R5 flows.
Require ((Get-TextSha256 $negativeR4) -eq $inputs['render:ScriptSettingsBridgeV1.r4-7b9b9950']) "negative-control bridge is the R4 source of the installed 7b9b9950 bytes"
$r4 = Invoke-Harness $negativeR4 'r4' -R5
$r4Report = Get-Report $r4
$r4.Output | Where-Object { $_ -like 'CATEGORY*' -or $_ -like 'REPORT*' -or $_ -like 'SCRIPT SETTINGS RENDER HARNESS*' } | ForEach-Object { Write-Output "NEGATIVE-R4`t$_" }
$r4.Output | Where-Object { $_ -like 'FAIL*' -and $_.Contains('after the return') } | Select-Object -First 3 | ForEach-Object { Write-Output "NEGATIVE-R4`t$_" }
Require ((Get-Category $r4 'r5-refresh') -ge 1) "negative control R4: after a value page closes, the parent still shows the old value and an unticked Custom switch (live R5 symptom)"
Require ((Get-Category $r4 'r5-validate') -ge 1 -and [int]$r4Report['r5_back_messages'] -eq 0) "negative control R4: Back with an out-of-range value shows no message (the live silent 'stage REJECT')"
Require ((Get-Category $r4 'r5-close') -eq 0 -and (Get-Category $r4 'r5-nav') -eq 0) "negative control R4: navigation and every close route already worked (the defect is the stale page and the silent reject, not the push/return)"

# 3. Negative control R2: the sub-label nil arithmetic (R3 defect).
Require ((Get-TextSha256 $negativeR2) -eq $inputs['render:ScriptSettingsBridgeV1.r2-2e337a43']) "negative-control bridge is the R2 source of the installed 2e337a43 bytes"
$r2 = Invoke-Harness $negativeR2 'r2'
$r2.Output | Where-Object { $_ -like 'ERROR*' } | Select-Object -First 3 | ForEach-Object { Write-Output "NEGATIVE-R2`t$($_.Split("`n")[0])" }
$nilError = @($r2.Output | Where-Object { $_ -like 'ERROR*' -and $_.Contains('attempt to perform arithmetic (sub) on nil and number') })
Require ($nilError.Count -ge 1) "negative control R2: the R2 bridge raises the live nil arithmetic in the stock draw"
$renderLine = Resolve-RenderLine $r2 $nilError[0]
$context = Get-RenderContext $renderLine 4
Require ((Get-RenderStatement $renderLine) -match '^c47v5 = c47v6 - __renovice_local_0$' -and $context.Contains('c47v6 = c47v0.mButtonWidth') -and $context.Contains('"SubLabel"')) "negative control R2 fails at the stock BUTTON sub-label statement mButtonWidth - offset (render line $renderLine = stock source line 991)"
Require (@($r2.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS FAIL*' }).Count -eq 1) "negative control R2 is reported as a harness FAIL"

# 4. Static pins on the bridge under test.
$bridgeText = [IO.File]::ReadAllText($bridgeSource)
Require (-not [regex]::IsMatch($bridgeText, 'mSubLabel\s*=')) "the bridge never builds a stock mSubLabel (the stock draw needs mButtonWidth for it)"
Require ($bridgeText.Contains('local function buttonLabel(spec)')) "the bridge folds a host subLabel into the BUTTON label"
Require (-not $bridgeText.Contains('ShowHideSearchBox')) "R4: the bridge never shows the stock search box"
Require ($bridgeText.Contains('local STOCK_VISIBLE_ROWS = 14') -and $bridgeText.Contains('local function recycledPage(specs)')) "R4: the bridge detects the stock recycled list (uniform, more than 14 rows, no INPUTBOX)"
Require ($bridgeText.Contains('openRowPage(movie, standIn.mRenoviceSpec, depth + 1, context.refresh)')) "R4: an INPUTCOUNT on a recycled page opens its own one-row page"
Require ($bridgeText.Contains('stage(value, setting, "click")')) "R5: a value-changed callback stages as a player's click"
Require ($bridgeText.Contains('local function refreshRows(context)') -and $bridgeText.Contains('pcall(onClosed)')) "R5: a child page close refreshes its parent from the host model"
Require ($bridgeText.Contains('eeUtilities.ShowMessage(message)') -and $bridgeText.Contains('if flag ~= nil then')) "R5: Back with an invalid value shows the row's stock message"
Require ($bridgeText.Contains('string.sub(action, 1, 9) == "resetall:"') -and $bridgeText.Contains('context.refresh()')) "R7: 'Reset all to defaults' stages the reset and re-reads its page in place"
Require ($bridgeText.Contains('string.sub(action, 1, 6) == "reset:"') -and $bridgeText.Contains('context.skipRestage = true') -and $bridgeText.Contains('context.skipRestage ~= true')) "R7: 'Reset to default' closes its value page without restaging the old value over the reset"

# 4b. REPLACEMENT_SETTINGS_V1 (2026-09-30): the rows of a replacement member's
# values (example package HijackSettingsExample; the rows file is pinned against
# the page model by RENOVICE_TOOLCHAIN/replacements/verify_replacement_settings.ps1).
$replacementRows = Join-Path (Split-Path -Parent $PSScriptRoot) 'replacements\fixtures\replacement_settings\HijackSettingsExample.rows.txt'
$replacementPage = ConvertTo-HarnessPage $replacementRows
$replacementRun = Invoke-Harness $bridgeSource 'replacement' $replacementPage.Text
$replacementReport = Get-Report $replacementRun
Require ($replacementRun.Exit -eq 0 -and @($replacementRun.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0 -and @($replacementRun.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "replacement-member value rows render through the stock list and value page ($($replacementPage.Rows) rows)"
Require ([int]$replacementReport['pages'] -eq $replacementPage.ExpectedPages -and $replacementPage.ValuePages -ge 1) "replacement-member value BUTTON opens its one-value page ($($replacementReport['pages'])/$($replacementPage.ExpectedPages))"

# 5. Optional: a real package's rows (read-only copy), current bridge.
if (-not [string]::IsNullOrWhiteSpace($PageRows)) {
    $page = ConvertTo-HarnessPage $PageRows
    Write-Output "PACKAGE`trows=$($page.Rows) value_pages=$($page.ValuePages) inline_inputcount=$($page.InlineCounts) source=$PageRows"
    $pkg = Invoke-Harness $bridgeSource 'package' $page.Text
    $pkg.Output | Where-Object { $_ -notlike 'CATEGORY*' } | ForEach-Object { Write-Output "PACKAGE-HARNESS`t$_" }
    $pkgReport = Get-Report $pkg
    Require ($pkg.Exit -eq 0 -and @($pkg.Output | Where-Object { $_ -like 'ERROR*' }).Count -eq 0) "package rows: no Lua error on open, scroll, wheel, value pages, search filter or close routes"
    Require (@($pkg.Output | Where-Object { $_ -like 'SCRIPT SETTINGS RENDER HARNESS PASS*' }).Count -eq 1) "package rows: every visible row renders its own frame, label, background and widgets; no stale write; no dim leak"
    Require ([int]$pkgReport['pages'] -eq $page.ExpectedPages) "package rows: every value BUTTON (and, for pre-R4 host rows, every inline INPUTCOUNT stand-in) opens its one-row page ($($pkgReport['pages'])/$($page.ExpectedPages))"
    Require ($pkgReport['search_shown'] -eq 'false') "package rows: the stock search box stays hidden"
}

Write-Output "SCRIPT SETTINGS RENDER PASS"
