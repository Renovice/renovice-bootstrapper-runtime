[CmdletBinding()]
param(
    [string]$ResearchRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$sourcePath = Join-Path $ResearchRoot 'TopMenu.current.decompiled.luau'
$irPath = Join-Path $ResearchRoot 'TopMenu.current.ir.txt'

foreach ($requiredPath in @($sourcePath, $irPath)) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Required input is missing: $requiredPath"
    }
}

$source = Get-Content -LiteralPath $sourcePath
$ir = Get-Content -LiteralPath $irPath

function Write-Tsv {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string[]]$Header,
        [Parameter(Mandatory)] [object[]]$Rows
    )

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add(($Header -join "`t"))
    foreach ($row in $Rows) {
        $fields = foreach ($column in $Header) {
            $value = $row.$column
            if ($null -eq $value) { '' } else { ([string]$value).Replace("`t", ' ').Replace("`r", ' ').Replace("`n", ' ') }
        }
        $lines.Add(($fields -join "`t"))
    }
    Set-Content -LiteralPath $Path -Value $lines -Encoding utf8
}

# Every prototype header comes from derecomp's DE-aware IR reader. Standard Lua
# bytecode tools reject DE's extended constant tag 19, so they are deliberately
# not used here.
$prototypeRows = [System.Collections.Generic.List[object]]::new()
foreach ($line in $ir) {
    if ($line -match '^== proto\[(?<Index>\d+)\] maxstack=(?<MaxStack>\d+) nparams=(?<Params>\d+) nups=(?<Upvalues>\d+) vararg=(?<Vararg>\d+) insns=(?<Instructions>\d+) consts=(?<Constants>\d+) ==$') {
        $prototypeRows.Add([pscustomobject]@{
            GlobalProto = [int]$Matches.Index
            MaxStack = [int]$Matches.MaxStack
            ExplicitParameters = [int]$Matches.Params
            Upvalues = [int]$Matches.Upvalues
            Vararg = [int]$Matches.Vararg
            Instructions = [int]$Matches.Instructions
            Constants = [int]$Matches.Constants
        })
    }
}
if ($prototypeRows.Count -ne 384) {
    throw "Expected 384 prototypes, parsed $($prototypeRows.Count)"
}
Write-Tsv -Path (Join-Path $ResearchRoot 'prototypes.tsv') `
    -Header @('GlobalProto','MaxStack','ExplicitParameters','Upvalues','Vararg','Instructions','Constants') `
    -Rows $prototypeRows.ToArray()

$keyRoles = @(
    [pscustomobject]@{ Role='BuildMenuOptions'; GlobalProto=295; SourceSymbol='vT[144]'; SourceStart=4923; SourceEnd=9134; Contract='0 params; 59 upvalues; constructs 62-option tree; assigns mMenuOptions; invokes U58 filter' },
    [pscustomobject]@{ Role='PopulateVisibleRows'; GlobalProto=313; SourceSymbol='vT[29]'; SourceStart=9630; SourceEnd=9740; Contract='follows _T.MenuSelectedIndex; creates row DTOs; calls List:AddElement' },
    [pscustomobject]@{ Role='CreateList'; GlobalProto=328; SourceSymbol='vT[150]'; SourceStart=10043; SourceEnd=10124; Contract='requires EE.Interface.Components.List; CreateList(mMovie, MenuItem); binds input callbacks' },
    [pscustomobject]@{ Role='FinishInitialize'; GlobalProto=347; SourceSymbol='vT[157] then FinishInitialize'; SourceStart=11735; SourceEnd=11737; Contract='exported finalization entry point' },
    [pscustomobject]@{ Role='Initialize'; GlobalProto=349; SourceSymbol='vT[157] then Initialize'; SourceStart=11736; SourceEnd=12464; Contract='builds options, creates native list, starts transition, schedules row population' },
    [pscustomobject]@{ Role='ModuleRoot'; GlobalProto=383; SourceSymbol='root chunk'; SourceStart=1; SourceEnd=$source.Count; Contract='imports modules, initializes state, publishes global callbacks' }
)
Write-Tsv -Path (Join-Path $ResearchRoot 'key_prototypes.tsv') `
    -Header @('Role','GlobalProto','SourceSymbol','SourceStart','SourceEnd','Contract') `
    -Rows $keyRoles

# Initialize captures these closures in this exact zero-based upvalue order. The
# values were resolved from proto[349]'s NEWCLOSURE capture stream back to the
# module root's local closure registers.
$initializeCaptures = @(
    73,49,24,15,0,51,5,27,28,23,1,31,20,21,144,55,65,150,155,33,40,77,18
)
$captureRows = for ($i = 0; $i -lt $initializeCaptures.Count; $i++) {
    $symbol = "vT[$($initializeCaptures[$i])]"
    $role = switch ($i) {
        14 { 'BuildMenuOptions' }
        17 { 'CreateList' }
        18 { 'TransitionSetup' }
        default { '' }
    }
    [pscustomobject]@{
        InitializeUpvalue = $i
        RootClosureSlot = $initializeCaptures[$i]
        SourceSymbol = $symbol
        KnownRole = $role
    }
}
Write-Tsv -Path (Join-Path $ResearchRoot 'initialize_upvalues.tsv') `
    -Header @('InitializeUpvalue','RootClosureSlot','SourceSymbol','KnownRole') `
    -Rows $captureRows

# Parse the builder's table records and take a snapshot when each record is
# inserted into the final array. Variables are aggressively reused by the
# compiler, so delaying the snapshot until the end would produce false names.
$builderStart = 4922 # zero-based array index for source line 4923
$builderEnd = 9133   # zero-based array index for source line 9134
$records = @{}
$menu = @{}
$menuArrayVariable = $null

function New-Record {
    param([string]$Variable, [string]$Body, [int]$Line)
    $name = ''
    $description = ''
    if ($Body -match '(?:^\s*|,\s*)Name\s*=\s*(?<Name>"(?:[^"\\]|\\.)*"|nil|[^,}]+)') {
        $name = $Matches.Name.Trim()
    }
    if ($Body -match '(?:^|,\s*)Description\s*=\s*(?<Description>"(?:[^"\\]|\\.)*"|nil|[^,}]+)') {
        $description = $Matches.Description.Trim()
    }
    return [pscustomobject]@{
        Variable = $Variable
        NameExpression = $name
        DescriptionExpression = $description
        DefinitionLine = $Line
    }
}

function Snapshot-Record {
    param([int]$Index, [string]$Variable, [int]$AssignmentLine)
    if ($records.ContainsKey($Variable)) {
        $record = $records[$Variable]
        $menu[$Index] = [pscustomobject]@{
            Index = $Index
            Variable = $Variable
            NameExpression = $record.NameExpression
            DescriptionExpression = $record.DescriptionExpression
            DefinitionLine = $record.DefinitionLine
            AssignmentLine = $AssignmentLine
        }
    } else {
        $menu[$Index] = [pscustomobject]@{
            Index = $Index
            Variable = $Variable
            NameExpression = '<dynamic-or-unresolved>'
            DescriptionExpression = ''
            DefinitionLine = ''
            AssignmentLine = $AssignmentLine
        }
    }
}

for ($i = $builderStart; $i -le $builderEnd; $i++) {
    $lineNumber = $i + 1
    $line = $source[$i]

    if ($line -match '^\s*(?<Var>c293v\d+)\s*=\s*\{(?<Body>.*)\}\s*$') {
        $variable = $Matches.Var
        $body = $Matches.Body
        if ($variable -eq 'c293v16' -and $body -match '^\s*c293v\d+(?:\s*,\s*c293v\d+)+\s*$') {
            $members = @($body -split '\s*,\s*')
            if ($members.Count -eq 16) {
                $menuArrayVariable = $variable
                for ($memberIndex = 0; $memberIndex -lt $members.Count; $memberIndex++) {
                    Snapshot-Record -Index ($memberIndex + 1) -Variable $members[$memberIndex] -AssignmentLine $lineNumber
                }
            } else {
                $records[$variable] = New-Record -Variable $variable -Body $body -Line $lineNumber
            }
        } else {
            $records[$variable] = New-Record -Variable $variable -Body $body -Line $lineNumber
        }
        continue
    }

    if ($line -match '^\s*(?<Var>c293v\d+)\.Name\s*=\s*(?<Value>.+?)\s*$') {
        $variable = $Matches.Var
        if ($records.ContainsKey($variable)) { $records[$variable].NameExpression = $Matches.Value.Trim() }
        continue
    }
    if ($line -match '^\s*(?<Var>c293v\d+)\.Description\s*=\s*(?<Value>.+?)\s*$') {
        $variable = $Matches.Var
        if ($records.ContainsKey($variable)) { $records[$variable].DescriptionExpression = $Matches.Value.Trim() }
        continue
    }
    if ($null -ne $menuArrayVariable -and $line -match ('^\s*' + [regex]::Escape($menuArrayVariable) + '\[(?<Index>\d+)\]\s*=\s*(?<Var>c293v\d+)\s*$')) {
        Snapshot-Record -Index ([int]$Matches.Index) -Variable $Matches.Var -AssignmentLine $lineNumber
    }
}

if ($menu.Count -ne 62) {
    throw "Expected exactly 62 final menu entries, parsed $($menu.Count)"
}
$menuRows = @($menu.Values | Sort-Object Index)
Write-Tsv -Path (Join-Path $ResearchRoot 'menu_options.tsv') `
    -Header @('Index','Variable','NameExpression','DescriptionExpression','DefinitionLine','AssignmentLine') `
    -Rows $menuRows

$anchors = @(
    [pscustomobject]@{ Event='Module state and imports'; StartLine=1; EndLine=124; Evidence='mMovie, mMenuOptions, imported UI modules and root state' },
    [pscustomobject]@{ Event='Recursive ShouldDisplay filter'; StartLine=3879; EndLine=3914; Evidence='filters the option tree before materialization' },
    [pscustomobject]@{ Event='BuildMenuOptions'; StartLine=4923; EndLine=9134; Evidence='constructs the 62-entry option tree' },
    [pscustomobject]@{ Event='Publish and filter mMenuOptions'; StartLine=9130; EndLine=9133; Evidence='assigns final array then invokes vT[120]' },
    [pscustomobject]@{ Event='PopulateVisibleRows'; StartLine=9630; EndLine=9740; Evidence='creates visible row DTOs from current submenu' },
    [pscustomobject]@{ Event='List:AddElement'; StartLine=9735; EndLine=9735; Evidence='hands each row to the native Flash list' },
    [pscustomobject]@{ Event='CreateList'; StartLine=10043; EndLine=10124; Evidence='requires List module and binds MenuItem callbacks' },
    [pscustomobject]@{ Event='Initialize calls builder'; StartLine=12043; EndLine=12043; Evidence='vT[144]()' },
    [pscustomobject]@{ Event='Initialize creates list'; StartLine=12150; EndLine=12150; Evidence='vT[150]()' },
    [pscustomobject]@{ Event='Export Initialize'; StartLine=12464; EndLine=12464; Evidence='Initialize = vT[157]' },
    [pscustomobject]@{ Event='Published MenuItem callbacks'; StartLine=12901; EndLine=13481; Evidence='focus, unfocus, press and refresh callbacks exported to movie' }
)
Write-Tsv -Path (Join-Path $ResearchRoot 'source_anchors.tsv') `
    -Header @('Event','StartLine','EndLine','Evidence') `
    -Rows $anchors

$flow = @(
    [pscustomobject]@{ Step=1; Owner='Engine/movie loader'; Action='executes module root'; Next='ModuleRoot proto 383'; Evidence='exact captured TopMenu bytecode and root prototype' },
    [pscustomobject]@{ Step=2; Owner='ModuleRoot proto 383'; Action='publishes Initialize and MenuItem callbacks'; Next='Initialize proto 349'; Evidence='source line 12464 and callback exports near 12901' },
    [pscustomobject]@{ Step=3; Owner='Initialize proto 349'; Action='resets _T.MenuSelectedIndex and invokes captured U14'; Next='BuildMenuOptions proto 295'; Evidence='Initialize capture map and source line 12043' },
    [pscustomobject]@{ Step=4; Owner='BuildMenuOptions proto 295'; Action='constructs 62 records and assigns mMenuOptions'; Next='Builder captured U58'; Evidence='source lines 4923-9133' },
    [pscustomobject]@{ Step=5; Owner='Builder U58'; Action='filters final option tree by current state'; Next='CreateList proto 328'; Evidence='IR instructions 2092-2094 and source lines 9131-9133' },
    [pscustomobject]@{ Step=6; Owner='Initialize proto 349'; Action='invokes captured U17'; Next='CreateList proto 328'; Evidence='Initialize capture map and source line 12150' },
    [pscustomobject]@{ Step=7; Owner='CreateList proto 328'; Action='constructs native Flash List bound to MenuItem callbacks'; Next='PopulateVisibleRows proto 313'; Evidence='source lines 10043-10124' },
    [pscustomobject]@{ Step=8; Owner='Transition/timer'; Action='calls PopulateVisibleRows'; Next='List:AddElement'; Evidence='source call sites near 11043 and 12201' },
    [pscustomobject]@{ Step=9; Owner='PopulateVisibleRows proto 313'; Action='walks selected submenu and creates row DTOs'; Next='Native Flash renderer'; Evidence='source lines 9630-9740' },
    [pscustomobject]@{ Step=10; Owner='EE.Interface.Components.List'; Action='AddElement(row, true) renders MenuItem'; Next='Visible Orbiter pause menu'; Evidence='source line 9735' }
)
Write-Tsv -Path (Join-Path $ResearchRoot 'execution_flow.tsv') `
    -Header @('Step','Owner','Action','Next','Evidence') `
    -Rows $flow

$publishedGlobals = [System.Collections.Generic.List[object]]::new()
for ($i = 0; $i -lt $source.Count; $i++) {
    if ($source[$i] -match '^\s{2}(?<Name>[A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?<Value>vT\[\d+\])\s*$') {
        $publishedGlobals.Add([pscustomobject]@{
            SourceLine = $i + 1
            Name = $Matches.Name
            ClosureSlot = $Matches.Value
        })
    }
}
if ($publishedGlobals.Count -lt 10) {
    throw "Expected at least 10 published globals, parsed $($publishedGlobals.Count)"
}
Write-Tsv -Path (Join-Path $ResearchRoot 'published_globals.tsv') `
    -Header @('SourceLine','Name','ClosureSlot') `
    -Rows $publishedGlobals.ToArray()

$counts = [ordered]@{
    Prototypes = $prototypeRows.Count
    MenuOptions = $menuRows.Count
    InitializeUpvalues = $captureRows.Count
    KeyRoles = $keyRoles.Count
    PublishedGlobals = $publishedGlobals.Count
    SourceLines = $source.Count
}
$counts.GetEnumerator() | ForEach-Object { "{0}={1}" -f $_.Key, $_.Value } |
    Set-Content -LiteralPath (Join-Path $ResearchRoot 'map_counts.txt') -Encoding utf8

Write-Host "TopMenu map generated successfully"
Write-Host "  prototypes: $($prototypeRows.Count)"
Write-Host "  menu options: $($menuRows.Count)"
Write-Host "  Initialize upvalues: $($captureRows.Count)"
