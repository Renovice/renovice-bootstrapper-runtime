[CmdletBinding()]
param(
    [string]$LogPath = 'C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts\Logs\renovice_source.log',
    [long]$SinceByte = 0,
    [string]$Label = '',
    [string]$OutputPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $LogPath -PathType Leaf)) {
    throw "Combat diagnostic log does not exist: $LogPath"
}

$resolvedLog = (Resolve-Path -LiteralPath $LogPath).Path
$length = (Get-Item -LiteralPath $resolvedLog).Length
if ($SinceByte -lt 0 -or $SinceByte -gt $length) {
    throw "SinceByte must be between 0 and the current log length $length"
}

function Read-TraceArgument {
    param([string]$Line, [int]$Index)
    $pattern = 'arg' + $Index + '_tag=\d+(?:="(?<quoted>[^"]*)"|=(?<plain>[^ ]+))?'
    $match = [regex]::Match($Line, $pattern)
    if (-not $match.Success) { return $null }
    if ($match.Groups['quoted'].Success) { return $match.Groups['quoted'].Value }
    if ($match.Groups['plain'].Success) { return $match.Groups['plain'].Value }
    return $null
}

function Read-TraceArgumentAfterField {
    param(
        [string]$Line,
        [string]$Field,
        [int]$Offset = 1,
        [int]$MaximumIndex = 48
    )
    for ($index = 0; $index -le $MaximumIndex; $index++) {
        $value = Read-TraceArgument -Line $Line -Index $index
        if ($value -ceq $Field) {
            return Read-TraceArgument -Line $Line -Index ($index + $Offset)
        }
    }
    return $null
}

$stream = [IO.File]::Open($resolvedLog, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
try {
    [void]$stream.Seek($SinceByte, [IO.SeekOrigin]::Begin)
    $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::UTF8, $true, 4096, $true)
    try {
        $records = [Collections.Generic.List[object]]::new()
        while (($line = $reader.ReadLine()) -ne $null) {
            if (-not $line.Contains('RENOVICE TRACE build=')) { continue }
            $event = Read-TraceArgument -Line $line -Index 0
            if ($null -eq $event -or -not $event.StartsWith('COMBAT_')) { continue }
            $correlationText = Read-TraceArgument -Line $line -Index 1
            $recordLabel = Read-TraceArgument -Line $line -Index 2
            if ($Label.Length -gt 0 -and $recordLabel -ne $Label) { continue }
            $tickMatch = [regex]::Match($line, ' tick_ms=(?<tick>\d+)')
            $records.Add([pscustomobject]@{
                Event = $event
                Correlation = if ($null -eq $correlationText) { $null } else { [int][double]$correlationText }
                Label = $recordLabel
                TickMs = if ($tickMatch.Success) { [long]$tickMatch.Groups['tick'].Value } else { $null }
                Line = $line
            })
        }
    }
    finally {
        $reader.Dispose()
    }
}
finally {
    $stream.Dispose()
}

$transactions = [Collections.Generic.List[object]]::new()
foreach ($group in ($records | Group-Object Correlation | Sort-Object { [int]$_.Name })) {
    $begin = $group.Group | Where-Object Event -eq 'COMBAT_BEGIN_STATE' | Select-Object -First 1
    $beginProfile = $group.Group | Where-Object Event -eq 'COMBAT_BEGIN_PROFILE' | Select-Object -First 1
    $end = $group.Group | Where-Object Event -eq 'COMBAT_END_STATE' | Select-Object -First 1
    $endProfile = $group.Group | Where-Object Event -eq 'COMBAT_END_PROFILE' | Select-Object -First 1
    $complete = $null -ne $begin -and $null -ne $beginProfile -and $null -ne $end -and $null -ne $endProfile

    $transactions.Add([pscustomobject]@{
        Correlation = [int]$group.Name
        Label = if ($null -ne $begin) { $begin.Label } else { ($group.Group | Select-Object -First 1).Label }
        Complete = $complete
        Prototype = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 3 } else { $null }
        Instruction = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 4 } else { $null }
        Target = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 5 } else { $null }
        Packet = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 6 } else { $null }
        HealthBefore = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 8 } else { $null }
        HealthAfter = if ($null -ne $end) { Read-TraceArgument -Line $end.Line -Index 9 } else { $null }
        HealthLoss = if ($null -ne $end) { Read-TraceArgument -Line $end.Line -Index 10 } else { $null }
        ShieldBefore = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 13 } else { $null }
        ShieldAfter = if ($null -ne $end) { Read-TraceArgument -Line $end.Line -Index 13 } else { $null }
        ShieldLoss = if ($null -ne $end) { Read-TraceArgument -Line $end.Line -Index 14 } else { $null }
        OverguardBefore = if ($null -ne $begin) { Read-TraceArgument -Line $begin.Line -Index 18 } else { $null }
        OverguardAfter = if ($null -ne $end) { Read-TraceArgument -Line $end.Line -Index 17 } else { $null }
        OverguardLoss = if ($null -ne $end) { Read-TraceArgument -Line $end.Line -Index 18 } else { $null }
        StockRaw = if ($null -ne $begin) { Read-TraceArgumentAfterField -Line $begin.Line -Field 'damage' -Offset 1 } else { $null }
        Multiplier = if ($null -ne $begin) { Read-TraceArgumentAfterField -Line $begin.Line -Field 'damage' -Offset 2 } else { $null }
        RequestedRaw = if ($null -ne $begin) { Read-TraceArgumentAfterField -Line $begin.Line -Field 'damage' -Offset 3 } else { $null }
        BatchId = if ($null -ne $begin) { Read-TraceArgumentAfterField -Line $begin.Line -Field 'batchContext' -Offset 1 } else { $null }
        TargetOrdinal = if ($null -ne $begin) { Read-TraceArgumentAfterField -Line $begin.Line -Field 'batchContext' -Offset 2 } else { $null }
        PacketOrdinal = if ($null -ne $begin) { Read-TraceArgumentAfterField -Line $begin.Line -Field 'packetContext' -Offset 1 } else { $null }
        ObservedRaw = if ($null -ne $begin) {
            $value = Read-TraceArgumentAfterField -Line $begin.Line -Field 'batchContext' -Offset 3
            if ($null -eq $value) { $value = Read-TraceArgumentAfterField -Line $begin.Line -Field 'packetContext' -Offset 2 }
            $value
        } else { $null }
        ColdStacks = if ($null -ne $begin) {
            $value = Read-TraceArgumentAfterField -Line $begin.Line -Field 'batchContext' -Offset 4
            if ($null -eq $value) { $value = Read-TraceArgumentAfterField -Line $begin.Line -Field 'packetContext' -Offset 3 }
            $value
        } else { $null }
        PendingDepth = if ($null -ne $begin) {
            $value = Read-TraceArgumentAfterField -Line $begin.Line -Field 'batchContext' -Offset 5
            if ($null -eq $value) { $value = Read-TraceArgumentAfterField -Line $begin.Line -Field 'packetContext' -Offset 4 }
            $value
        } else { $null }
        EffectivePoolLoss = if ($null -ne $end) { Read-TraceArgumentAfterField -Line $end.Line -Field 'effectivePoolLoss' } else { $null }
        InstalledRaw = if ($null -ne $end) { Read-TraceArgumentAfterField -Line $end.Line -Field 'installedRaw' } else { $null }
        RestoredRaw = if ($null -ne $end) { Read-TraceArgumentAfterField -Line $end.Line -Field 'restoredRaw' } else { $null }
        DamageProfile = if ($null -ne $beginProfile) { Read-TraceArgument -Line $beginProfile.Line -Index 3 } else { $null }
        StatusBefore = if ($null -ne $beginProfile) { Read-TraceArgument -Line $beginProfile.Line -Index 4 } else { $null }
        StatusAfter = if ($null -ne $endProfile) { Read-TraceArgument -Line $endProfile.Line -Index 3 } else { $null }
        BeginTickMs = if ($null -ne $begin) { $begin.TickMs } else { $null }
        EndTickMs = if ($null -ne $end) { $end.TickMs } else { $null }
        RawRecords = @($group.Group.Line)
    })
}

$summary = [pscustomobject]@{
    Schema = 3
    LogPath = $resolvedLog
    SinceByte = $SinceByte
    EndByte = $length
    LabelFilter = $Label
    RecordCount = $records.Count
    TransactionCount = $transactions.Count
    CompleteCount = @($transactions | Where-Object Complete).Count
    IncompleteCount = @($transactions | Where-Object { -not $_.Complete }).Count
    Transactions = @($transactions)
}

if ($OutputPath.Length -gt 0) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent.Length -gt 0) { [IO.Directory]::CreateDirectory($parent) | Out-Null }
    $summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding utf8NoBOM
}

$transactions | Format-Table Correlation,Label,Complete,BatchId,TargetOrdinal,ColdStacks,ObservedRaw,StockRaw,Multiplier,RequestedRaw,InstalledRaw,RestoredRaw,EffectivePoolLoss -AutoSize
Write-Host ("COMBAT METER ANALYSIS records={0} transactions={1} complete={2} incomplete={3} bytes={4}..{5}" -f $summary.RecordCount,$summary.TransactionCount,$summary.CompleteCount,$summary.IncompleteCount,$SinceByte,$length)
if ($OutputPath.Length -gt 0) { Write-Host "JSON=$OutputPath" }
