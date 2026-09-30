[CmdletBinding()]
param(
    [string]$LogPath = 'C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts\Logs\renovice_source.log',
    [long]$SinceByte = 0,
    [string]$Label = '',
    [string]$SourceBody = '',
    [string]$SourcePath = '',
    [string]$TargetType = '',
    [string]$OutputPath = '',
    [string]$CsvPath = '',
    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $LogPath -PathType Leaf)) {
    throw "Battle log does not exist: $LogPath"
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
        [int]$MaximumIndex = 64
    )
    for ($index = 0; $index -le $MaximumIndex; $index++) {
        if ((Read-TraceArgument -Line $Line -Index $index) -ceq $Field) {
            return Read-TraceArgument -Line $Line -Index ($index + $Offset)
        }
    }
    return $null
}

function Read-HeaderField {
    param([string]$Line, [string]$Field)
    $match = [regex]::Match($Line, '(?:^| )' + [regex]::Escape($Field) + '=(?<value>[^ ]+)')
    if ($match.Success) { return $match.Groups['value'].Value }
    return $null
}

function Get-OptionalProperty {
    param([object]$Value, [string]$Name)
    if ($null -ne $Value -and $Value.PSObject.Properties[$Name]) { return $Value.$Name }
    return $null
}

function Read-HeaderTextField {
    param([string]$Line, [string]$Field)
    $pattern = '(?:^| )' + [regex]::Escape($Field) + '=(?:"(?<quoted>[^"]*)"|(?<plain>[^ ]+))'
    $match = [regex]::Match($Line, $pattern)
    if (-not $match.Success) { return $null }
    if ($match.Groups['quoted'].Success) { return $match.Groups['quoted'].Value }
    return $match.Groups['plain'].Value
}

function Convert-TraceBoolean {
    param([object]$Value)
    if ($null -eq $Value) { return $null }
    if ([string]$Value -ceq 'true') { return $true }
    if ([string]$Value -ceq 'false') { return $false }
    return $null
}

function Normalize-HexBodyKey {
    param([object]$Value)
    if ($null -eq $Value) { return '' }
    $text = [string]$Value
    if ($text.StartsWith('0x', [StringComparison]::OrdinalIgnoreCase)) {
        $text = $text.Substring(2)
    }
    return $text.ToLowerInvariant()
}

$stream = [IO.File]::Open($resolvedLog, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
try {
    [void]$stream.Seek($SinceByte, [IO.SeekOrigin]::Begin)
    $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::UTF8, $true, 4096, $true)
    try {
        $records = [Collections.Generic.List[object]]::new()
        $engineRecords = [Collections.Generic.List[object]]::new()
        $casterRecords = [Collections.Generic.List[object]]::new()
        $buffRecords = [Collections.Generic.List[object]]::new()
        $buffNativeProbes = [Collections.Generic.List[object]]::new()
        $buffOwners = [Collections.Generic.List[object]]::new()
        $activeTransactions = [Collections.Generic.Dictionary[string,string]]::new(
            [StringComparer]::Ordinal)
        $transactionOrdinal = 0
        while (($line = $reader.ReadLine()) -ne $null) {
            if ($line.StartsWith('RENOVICE BUFF_NATIVE build=')) {
                # Standalone binding probes have no damage/contributor join.
                if ($SourceBody.Length -gt 0 -or $SourcePath.Length -gt 0) { continue }
                $probe = [ordered]@{}
                foreach ($field in @('build','pid','vm','tick_ms','event','sequence',
                    'binding_slot','method','lane','reentrant','observer_running','reason',
                    'returned_count','result0_tag')) { $probe[$field] = Read-HeaderField $line $field }
                if ($probe.event -notin @('ingress','selection','return','suppressed','observer-before','observer-after') -or
                    $probe.lane -notin @('stock','observer') -or $null -eq $probe.sequence) {
                    throw 'Invalid native buff getter probe'
                }
                $probe.RawLine = $line
                $buffNativeProbes.Add([pscustomobject]$probe)
                continue
            }
            if ($line.StartsWith('RENOVICE CASTER_STATS build=') -and $line.Contains(' json=')) {
                $offset = $line.IndexOf(' json=', [StringComparison]::Ordinal)
                $caster = $line.Substring($offset + 6) | ConvertFrom-Json
                if ($caster.Schema -ne 1 -or $caster.Snapshot -ne
                    [long](Read-HeaderField $line 'snapshot')) { throw 'Invalid caster snapshot schema or identity' }
                $body = Read-HeaderField $line 'source_body'
                $path = Read-HeaderTextField $line 'source_path'
                $name = Read-HeaderTextField $line 'source_name'
                if ($SourceBody.Length -gt 0 -and (Normalize-HexBodyKey $body) -cne (Normalize-HexBodyKey $SourceBody)) { continue }
                if ($SourcePath.Length -gt 0 -and $path -ine $SourcePath -and $name -ine $SourcePath) { continue }
                foreach ($field in @('pid','vm','tick_ms','event','build')) {
                    $caster | Add-Member -NotePropertyName $field -NotePropertyValue (Read-HeaderField $line $field)
                }
                $caster | Add-Member -NotePropertyName SourceBody -NotePropertyValue $body
                $caster | Add-Member -NotePropertyName SourcePath -NotePropertyValue $path
                $caster | Add-Member -NotePropertyName SourceName -NotePropertyValue $name
                $caster | Add-Member -NotePropertyName RawLine -NotePropertyValue $line
                if ($caster.event -eq 'BUFF_LIST') { $buffRecords.Add($caster) }
                elseif ($caster.event -eq 'BUFF_OWNER') { $buffOwners.Add($caster) }
                else { $casterRecords.Add($caster) }
                continue
            }
            if ($line.StartsWith('RENOVICE ENGINE_DAMAGE json=')) {
                $native = $line.Substring('RENOVICE ENGINE_DAMAGE json='.Length) | ConvertFrom-Json
                if ($native.Schema -ne 1 -or $native.Phase -notin @('begin','end')) {
                    throw 'Unrecognized native battle record schema or phase'
                }
                if ($Label.Length -gt 0 -and $Label -ne 'AUTO_ENGINE_DAMAGE') { continue }
                if ($SourceBody.Length -gt 0 -and
                    (Normalize-HexBodyKey $native.SourceBody) -cne (Normalize-HexBodyKey $SourceBody)) { continue }
                if ($SourcePath.Length -gt 0 -and $native.SourcePath -ine $SourcePath -and
                    $native.SourceName -ine $SourcePath) { continue }
                if ($TargetType.Length -gt 0 -and $native.TargetType -ine $TargetType) { continue }
                $native | Add-Member -NotePropertyName RawLine -NotePropertyValue $line
                $engineRecords.Add($native)
                continue
            }
            if (-not $line.Contains('RENOVICE TRACE build=')) { continue }
            $event = Read-TraceArgument -Line $line -Index 0
            if ($event -in @('BUFF_OWNER','BUFF_LIST','CASTER_STATS','CASTER_CALCULATION')) {
                $payloadMatch = [regex]::Match($line, ' arg2_tag=(?:5|6)="(?<json>.*)"$')
                if (-not $payloadMatch.Success) { throw 'Missing generic caster JSON payload' }
                $caster = $payloadMatch.Groups['json'].Value | ConvertFrom-Json
                if ($caster.Schema -ne 1 -or $caster.Snapshot -ne
                    [long](Read-TraceArgument -Line $line -Index 1)) { throw 'Invalid generic caster snapshot schema or identity' }
                $body = Read-HeaderField $line 'source_body'
                $path = Read-HeaderTextField $line 'source_path'
                $name = Read-HeaderTextField $line 'source_name'
                if ($SourceBody.Length -gt 0 -and (Normalize-HexBodyKey $body) -cne (Normalize-HexBodyKey $SourceBody)) { continue }
                if ($SourcePath.Length -gt 0 -and $path -ine $SourcePath -and $name -ine $SourcePath) { continue }
                foreach ($field in @('pid','vm','tick_ms','build')) {
                    $caster | Add-Member -NotePropertyName $field -NotePropertyValue (Read-HeaderField $line $field)
                }
                $caster | Add-Member -NotePropertyName event -NotePropertyValue $event
                $caster | Add-Member -NotePropertyName SourceBody -NotePropertyValue $body
                $caster | Add-Member -NotePropertyName SourcePath -NotePropertyValue $path
                $caster | Add-Member -NotePropertyName SourceName -NotePropertyValue $name
                $caster | Add-Member -NotePropertyName RawLine -NotePropertyValue $line
                if ($event -eq 'BUFF_OWNER') { $buffOwners.Add($caster) }
                elseif ($event -eq 'BUFF_LIST') { $buffRecords.Add($caster) }
                else { $casterRecords.Add($caster) }
                continue
            }
            if ($null -eq $event -or -not $event.StartsWith('BATTLE_')) { continue }
            $correlationText = Read-TraceArgument -Line $line -Index 1
            $recordLabel = Read-TraceArgument -Line $line -Index 2
            if ($null -eq $correlationText) { continue }
            if ($Label.Length -gt 0 -and $recordLabel -ne $Label) { continue }
            $recordSourceBody = Read-HeaderField -Line $line -Field 'source_body'
            $recordSourcePath = Read-HeaderTextField -Line $line -Field 'source_path'
            $recordSourceName = Read-HeaderTextField -Line $line -Field 'source_name'
            $recordTargetType = Read-HeaderTextField -Line $line -Field 'target_type'
            if ($SourceBody.Length -gt 0 -and
                (Normalize-HexBodyKey $recordSourceBody) -cne
                (Normalize-HexBodyKey $SourceBody)) { continue }
            if ($SourcePath.Length -gt 0 -and
                $recordSourcePath -ine $SourcePath -and
                $recordSourceName -ine $SourcePath) { continue }
            if ($TargetType.Length -gt 0 -and $recordTargetType -ine $TargetType) { continue }
            $processId = Read-HeaderField -Line $line -Field 'pid'
            $vm = Read-HeaderField -Line $line -Field 'vm'
            $tick = Read-HeaderField -Line $line -Field 'tick_ms'
            $build = Read-HeaderField -Line $line -Field 'build'
            $autoCapture = Read-HeaderField -Line $line -Field 'auto_capture'
            $autoSequence = Read-HeaderField -Line $line -Field 'auto_sequence'
            # Each producer owns its counter; automatic and explicit counters
            # can coincide. A fresh begin also separates counters reused on F9.
            $scope = ConvertTo-Json -Compress -InputObject @(
                $processId, $vm, $build, $recordLabel,
                $autoCapture, $autoSequence, $correlationText)
            if ($event -eq 'BATTLE_TX_BEGIN' -or
                    -not $activeTransactions.ContainsKey($scope)) {
                $transactionOrdinal++
                $activeTransactions[$scope] = "$scope|$transactionOrdinal"
            }
            $records.Add([pscustomobject]@{
                Event = $event
                TransactionKey = $activeTransactions[$scope]
                Build = $build
                Correlation = [int][double]$correlationText
                Label = $recordLabel
                Pid = $processId
                Vm = $vm
                SessionKey = "$processId`:$vm"
                TickMs = if ($null -eq $tick) { $null } else { [long]$tick }
                AutoCapture = $autoCapture
                AutoSequence = $autoSequence
                SourceBody = $recordSourceBody
                SourcePrototype = Read-HeaderField -Line $line -Field 'source_prototype'
                SourceInstruction = Read-HeaderField -Line $line -Field 'source_instruction'
                SourcePath = $recordSourcePath
                SourceName = $recordSourceName
                TargetType = $recordTargetType
                Line = $line
            })
            if ($event -eq 'BATTLE_MATH') {
                [void]$activeTransactions.Remove($scope)
            }
        }
    }
    finally { $reader.Dispose() }
}
finally { $stream.Dispose() }

$transactions = [Collections.Generic.List[object]]::new()
$grouped = $records | Group-Object TransactionKey |
    Sort-Object { ($_.Group | Select-Object -First 1).TickMs }
foreach ($group in $grouped) {
    $tx = $group.Group | Where-Object Event -eq 'BATTLE_TX_BEGIN' | Select-Object -First 1
    $stateBegin = $group.Group | Where-Object Event -eq 'BATTLE_STATE_BEGIN' | Select-Object -First 1
    $lifeBegin = $group.Group | Where-Object Event -eq 'BATTLE_LIFE_BEGIN' | Select-Object -First 1
    $statusBegin = $group.Group | Where-Object Event -eq 'BATTLE_STATUS_BEGIN' | Select-Object -First 1
    $damageInput = $group.Group | Where-Object Event -eq 'BATTLE_DAMAGE_INPUT' | Select-Object -First 1
    $stateEnd = $group.Group | Where-Object Event -eq 'BATTLE_STATE_END' | Select-Object -First 1
    $lifeEnd = $group.Group | Where-Object Event -eq 'BATTLE_LIFE_END' | Select-Object -First 1
    $statusEnd = $group.Group | Where-Object Event -eq 'BATTLE_STATUS_END' | Select-Object -First 1
    $math = $group.Group | Where-Object Event -eq 'BATTLE_MATH' | Select-Object -First 1
    $complete = $null -ne $tx -and $null -ne $stateBegin -and
        $null -ne $lifeBegin -and $null -ne $statusBegin -and
        $null -ne $damageInput -and $null -ne $stateEnd -and
        $null -ne $lifeEnd -and $null -ne $statusEnd -and $null -ne $math
    $duplicateEvents = @($group.Group | Group-Object Event |
        Where-Object Count -gt 1).Count
    $complete = $complete -and $duplicateEvents -eq 0
    $first = $group.Group | Sort-Object TickMs | Select-Object -First 1
    $last = $group.Group | Sort-Object TickMs | Select-Object -Last 1

    $statusBeforeText = if ($null -ne $statusBegin) {
        Read-TraceArgument -Line $statusBegin.Line -Index 3
    } else { $null }
    $statusAfterText = if ($null -ne $statusEnd) {
        Read-TraceArgument -Line $statusEnd.Line -Index 4
    } else { $null }

    $transactions.Add([pscustomobject]@{
        TransactionKey = $first.TransactionKey
        Build = $first.Build
        Session = $first.SessionKey
        Pid = $first.Pid
        Vm = $first.Vm
        Correlation = $first.Correlation
        Label = $first.Label
        Complete = $complete
        DuplicateEventCount = $duplicateEvents
        AutoCapture = $first.AutoCapture
        AutoSequence = $first.AutoSequence
        SourceBody = $first.SourceBody
        SourcePrototype = $first.SourcePrototype
        SourceInstruction = $first.SourceInstruction
        SourcePath = $first.SourcePath
        SourceName = $first.SourceName
        TargetType = $first.TargetType
        Prototype = if ($null -ne $tx) { Read-TraceArgument -Line $tx.Line -Index 3 } else { $null }
        Instruction = if ($null -ne $tx) { Read-TraceArgument -Line $tx.Line -Index 4 } else { $null }
        Target = if ($null -ne $tx) { Read-TraceArgument -Line $tx.Line -Index 5 } else { $null }
        Packet = if ($null -ne $tx) { Read-TraceArgument -Line $tx.Line -Index 6 } else { $null }
        Source = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'source' } else { $null }
        SourceKnown = if ($null -ne $tx) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $tx.Line -Field 'source' -Offset 2) } else { $null }
        SourceAbility = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'sourceAbility' } else { $null }
        SourceAbilityKnown = if ($null -ne $tx) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $tx.Line -Field 'sourceAbility' -Offset 2) } else { $null }
        BatchId = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'batch' } else { $null }
        TargetOrdinal = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'batch' -Offset 2 } else { $null }
        PendingDepth = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'batch' -Offset 3 } else { $null }
        Calculation = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'calculation' } else { $null }
        ModifierName = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'modifier' } else { $null }
        ModifierValue = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'modifier' -Offset 2 } else { $null }
        ModifierScaleName = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'modifierScale' } else { $null }
        ModifierScaleValue = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'modifierScale' -Offset 2 } else { $null }
        BaseMultiplier = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'baseMultiplier' } else { $null }
        BonusPerStack = if ($null -ne $tx) { Read-TraceArgumentAfterField -Line $tx.Line -Field 'bonusPerStack' } else { $null }
        HealthBefore = if ($null -ne $stateBegin) { Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'health' } else { $null }
        HealthMaximum = if ($null -ne $stateBegin) { Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'health' -Offset 3 } else { $null }
        HealthAfter = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'health' -Offset 2 } else { $null }
        HealthLoss = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'health' -Offset 3 } else { $null }
        ShieldBefore = if ($null -ne $stateBegin) { Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'shield' } else { $null }
        ShieldMaximum = if ($null -ne $stateBegin) { Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'shield' -Offset 3 } else { $null }
        ShieldAfter = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'shield' -Offset 2 } else { $null }
        ShieldLoss = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'shield' -Offset 3 } else { $null }
        OverguardBefore = if ($null -ne $stateBegin) { Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'overguard' } else { $null }
        OverguardAfter = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'overguard' -Offset 2 } else { $null }
        OverguardLoss = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'overguard' -Offset 3 } else { $null }
        ArmourBefore = if ($null -ne $stateBegin) { Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'armour' } else { $null }
        ArmourBeforeAvailable = if ($null -ne $stateBegin) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $stateBegin.Line -Field 'armour' -Offset 2) } else { $null }
        ArmourAfter = if ($null -ne $stateEnd) { Read-TraceArgumentAfterField -Line $stateEnd.Line -Field 'armour' -Offset 2 } else { $null }
        KilledBefore = if ($null -ne $lifeBegin) { Read-TraceArgumentAfterField -Line $lifeBegin.Line -Field 'killed' } else { $null }
        KilledAfter = if ($null -ne $lifeEnd) { Read-TraceArgumentAfterField -Line $lifeEnd.Line -Field 'killed' -Offset 2 } else { $null }
        KilledAvailable = if ($null -ne $lifeEnd) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $lifeEnd.Line -Field 'killed' -Offset 3) } else { $null }
        DeadBefore = if ($null -ne $lifeBegin) { Read-TraceArgumentAfterField -Line $lifeBegin.Line -Field 'dead' } else { $null }
        DeadAfter = if ($null -ne $lifeEnd) { Read-TraceArgumentAfterField -Line $lifeEnd.Line -Field 'dead' -Offset 2 } else { $null }
        DeadAvailable = if ($null -ne $lifeEnd) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $lifeEnd.Line -Field 'dead' -Offset 3) } else { $null }
        RagdollBefore = if ($null -ne $lifeBegin) { Read-TraceArgumentAfterField -Line $lifeBegin.Line -Field 'ragdollPresent' } else { $null }
        RagdollAfter = if ($null -ne $lifeEnd) { Read-TraceArgumentAfterField -Line $lifeEnd.Line -Field 'ragdollPresent' -Offset 2 } else { $null }
        RagdollAvailable = if ($null -ne $lifeEnd) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $lifeEnd.Line -Field 'ragdollPresent' -Offset 3) } else { $null }
        StockRaw = if ($null -ne $damageInput) { Read-TraceArgumentAfterField -Line $damageInput.Line -Field 'stockRaw' } else { $null }
        Multiplier = if ($null -ne $damageInput) { Read-TraceArgumentAfterField -Line $damageInput.Line -Field 'multiplier' } else { $null }
        RequestedRaw = if ($null -ne $damageInput) { Read-TraceArgumentAfterField -Line $damageInput.Line -Field 'requestedRaw' } else { $null }
        ObservedRaw = if ($null -ne $damageInput) { Read-TraceArgumentAfterField -Line $damageInput.Line -Field 'observedRaw' } else { $null }
        InstalledRaw = if ($null -ne $math) { Read-TraceArgumentAfterField -Line $math.Line -Field 'installedRaw' } else { $null }
        DecodeLayout = $null; RawReason = $null; HealthReason = $null; ShieldReason = $null; OverguardReason = $null
        RestoredRaw = if ($null -ne $math) { Read-TraceArgumentAfterField -Line $math.Line -Field 'restoredRaw' } else { $null }
        ReportedRaw = if ($null -ne $math) { Read-TraceArgumentAfterField -Line $math.Line -Field 'reportedRaw' } else { $null }
        VisiblePoolLoss = if ($null -ne $math) { Read-TraceArgumentAfterField -Line $math.Line -Field 'visiblePoolLoss' } else { $null }
        VisiblePoolLossComplete = if ($null -ne $math) { Convert-TraceBoolean (Read-TraceArgumentAfterField -Line $math.Line -Field 'visiblePoolLossComplete') } else { $null }
        RawMinusVisiblePoolLoss = if ($null -ne $math) { Read-TraceArgumentAfterField -Line $math.Line -Field 'rawMinusVisiblePoolLoss' } else { $null }
        VisibleToInstalledRatio = if ($null -ne $math) { Read-TraceArgumentAfterField -Line $math.Line -Field 'visibleToInstalledRatio' } else { $null }
        DamageProfile = if ($null -ne $damageInput) { Read-TraceArgument -Line $damageInput.Line -Index 11 } else { $null }
        StatusBefore = $statusBeforeText
        StatusAfter = $statusAfterText
        StatusChanged = if ($null -eq $statusBeforeText -or $null -eq $statusAfterText) { $null } else { $statusBeforeText -cne $statusAfterText }
        BeginTickMs = $first.TickMs
        EndTickMs = $last.TickMs
        DurationMs = if ($null -eq $first.TickMs -or $null -eq $last.TickMs) { $null } else { $last.TickMs - $first.TickMs }
        RawRecords = @($group.Group.Line)
    })
}

$nativeGroups = @($engineRecords | Group-Object {
    "$($_.Pid):$($_.Thread):$($_.Generation):$($_.Correlation)"
})
foreach ($group in $nativeGroups) {
    $begins = @($group.Group | Where-Object Phase -eq 'begin')
    $ends = @($group.Group | Where-Object Phase -eq 'end')
    $first = $group.Group | Select-Object -First 1
    $begin = if ($begins.Count) { $begins[0] } else { $first }
    $end = if ($ends.Count) { $ends[0] } else { $null }
    $complete = $begins.Count -eq 1 -and $ends.Count -eq 1 -and
        $begin.Target -ceq $end.Target -and $begin.Packet -ceq $end.Packet
    $getEnd = { param($field) if ($null -ne $end) { $end.$field } else { $null } }
    # Per-build codec records (2026-09-30) name their layout and the exact reason for each null
    # decoded field; older records have neither.
    $optional = { param($record, $field) if ($null -ne $record -and $record.PSObject.Properties[$field]) { $record.$field } else { $null } }
    $reasonRecord = if ($null -ne $end) { $end } else { $begin }
    $transactions.Add([pscustomobject]@{
        Build=$first.Build; Correlation=$first.Correlation; Label='AUTO_ENGINE_DAMAGE'
        Complete=$complete; DuplicateEventCount=([Math]::Max(0,$begins.Count-1)+[Math]::Max(0,$ends.Count-1))
        RecordCount=$group.Count; SessionKey="$($first.Pid):$($first.Vm)"; TransactionKey=$group.Name
        AutoCapture='engine-damage'; AutoSequence=$first.Correlation; Pid=$first.Pid; Vm=$first.Vm
        Generation=$first.Generation; ParentCorrelation=$first.ParentCorrelation; HandlerSlot=$first.HandlerSlot
        SourceBody=$first.SourceBody; SourcePrototype=$first.SourcePrototype; SourceInstruction=$first.SourceInstruction
        SourcePath=$first.SourcePath; SourceName=$first.SourceName; TargetType=$first.TargetType
        Prototype=$first.SourcePrototype; Instruction=$first.SourceInstruction; Target=$first.Target; Packet=$first.Packet
        Method=$first.Method; DamageControl=$first.DamageControl; Source=$null; SourceKnown=$false
        CasterSnapshot=if ($first.PSObject.Properties['CasterSnapshot']) { $first.CasterSnapshot } else { 0 }
        SourceAbility=$null; SourceAbilityKnown=$false; Calculation='native-handler-observed-input-and-pool-delta'
        ModifierName='none'; ModifierValue=1; StockRaw=$null; Multiplier=1
        RequestedRaw=$begin.ObservedRaw; ObservedRaw=$begin.ObservedRaw; InstalledRaw=$begin.ObservedRaw
        DecodeLayout=(& $optional $begin 'Layout'); RawReason=(& $optional $begin 'RawReason')
        HealthReason=(& $optional $reasonRecord 'HealthReason'); ShieldReason=(& $optional $reasonRecord 'ShieldReason')
        OverguardReason=(& $optional $reasonRecord 'OverguardReason')
        RestoredRaw=$null; ReportedRaw=$null; DamageProfile=$begin.DamageFractions
        HealthBefore=$begin.HealthBefore; HealthAfter=(& $getEnd 'HealthAfter'); HealthLoss=(& $getEnd 'HealthLoss')
        ShieldBefore=$begin.ShieldBefore; ShieldAfter=(& $getEnd 'ShieldAfter'); ShieldLoss=(& $getEnd 'ShieldLoss')
        OverguardBefore=$begin.OverguardBefore; OverguardAfter=(& $getEnd 'OverguardAfter'); OverguardLoss=(& $getEnd 'OverguardLoss')
        VisiblePoolLoss=(& $getEnd 'VisiblePoolLoss'); VisiblePoolLossComplete=(& $getEnd 'VisiblePoolLossComplete')
        HealthMaximum=$null; ShieldMaximum=$null; ArmourBefore=$null; ArmourAfter=$null; ArmourBeforeAvailable=$false
        KilledBefore=$null; KilledAfter=$null; KilledAvailable=$false; DeadBefore=$null; DeadAfter=$null; DeadAvailable=$false
        RagdollBefore=$null; RagdollAfter=$null; RagdollAvailable=$false
        StatusBefore=$null; StatusAfter=$null; StatusChanged=$null
        BeginTickMs=$begin.BeginTickMs; EndTickMs=if ($end) {$end.TickMs} else {$null}
        DurationMs=if ($end) {$end.TickMs-$begin.BeginTickMs} else {$null}
        RawRecords=@($group.Group.RawLine)
    })
}

function Get-CasterSnapshotKey {
    param($PidValue, $VmValue, $SnapshotValue)
    $pointer = ([string]$VmValue).ToLowerInvariant()
    if ($pointer.StartsWith('0x')) { $pointer = $pointer.Substring(2) }
    $pointer = $pointer.TrimStart('0')
    return "$($PidValue):$($pointer):$($SnapshotValue)"
}
$snapshotsByKey = @{}
foreach ($snapshot in $casterRecords | Where-Object event -eq 'CASTER_STATS') {
    $key = Get-CasterSnapshotKey $snapshot.pid $snapshot.vm $snapshot.Snapshot
    if ($snapshotsByKey.ContainsKey($key)) { throw 'Duplicate process/VM/caster snapshot identity' }
    $snapshotsByKey[$key] = $snapshot
}
$buffLists = [Collections.Generic.List[object]]::new()
$combatBuffListsByKey = @{}
$hudQueueListsByKey = @{}
foreach ($group in $buffRecords | Group-Object {
    (Get-CasterSnapshotKey $_.pid $_.vm $_.Snapshot) + ':' + $_.ObservedAt
}) {
    $chunks = @($group.Group | Sort-Object Chunk)
    $first = $chunks[0]
    $seenChunks = @{}
    $seenOrdinals = @{}
    $entries = [Collections.Generic.List[object]]::new()
    foreach ($chunk in $chunks) {
        if ($chunk.Chunk -lt 1 -or $chunk.Chunk -gt $first.Chunks -or
            $chunk.Chunks -ne $first.Chunks -or $chunk.Chunks -gt 16 -or
            $chunk.CapturedCount -ne $first.CapturedCount -or
            $chunk.NativeCount -ne $first.NativeCount -or
            $chunk.Receiver -cne $first.Receiver -or
            $chunk.Available -ne $first.Available -or
            $chunk.Truncated -ne $first.Truncated -or
            $seenChunks.ContainsKey($chunk.Chunk)) { throw 'Invalid or duplicate buff-list chunk' }
        foreach ($field in @('GetterSucceeded','ReturnType','GetterError','EmptyNativeList')) {
            if ((Get-OptionalProperty $chunk $field) -cne (Get-OptionalProperty $first $field)) {
                throw 'Conflicting native buff getter metadata across chunks'
            }
        }
        $seenChunks[$chunk.Chunk] = $true
        foreach ($entry in $chunk.Records) {
            if ($entry.Ordinal -lt 1 -or $entry.Ordinal -gt $first.CapturedCount -or
                $seenOrdinals.ContainsKey($entry.Ordinal)) { throw 'Invalid or duplicate native buff ordinal' }
            $seenOrdinals[$entry.Ordinal] = $true
            $entries.Add($entry)
        }
    }
    $list = [pscustomobject]@{
        Pid=$first.pid;Vm=$first.vm;Snapshot=$first.Snapshot;TickMs=$first.tick_ms
        ObservedAt=$first.ObservedAt;Receiver=$first.Receiver;ReceiverType=$first.ReceiverType
        Available=$first.Available;Reason=$first.Reason
        GetterSucceeded=(Get-OptionalProperty $first 'GetterSucceeded')
        ReturnType=(Get-OptionalProperty $first 'ReturnType')
        GetterError=(Get-OptionalProperty $first 'GetterError')
        EmptyNativeList=(Get-OptionalProperty $first 'EmptyNativeList')
        NativeCount=$first.NativeCount;CapturedCount=$first.CapturedCount;Truncated=$first.Truncated
        Complete=($chunks.Count -eq $first.Chunks -and $entries.Count -eq $first.CapturedCount)
        CompleteContributorList=$false;Buffs=@($entries);RawChunks=$chunks
    }
    $buffLists.Add($list)
    if ($first.ObservedAt -eq 'caster-combat-boundary') {
        $key = Get-CasterSnapshotKey $first.pid $first.vm $first.Snapshot
        if ($combatBuffListsByKey.ContainsKey($key)) { throw 'Duplicate caster buff-list identity' }
        $combatBuffListsByKey[$key] = $list
    } elseif ($first.ObservedAt -eq 'caster-hud-queue-boundary') {
        $key = Get-CasterSnapshotKey $first.pid $first.vm $first.Snapshot
        if ($hudQueueListsByKey.ContainsKey($key)) { throw 'Duplicate caster HUD queue identity' }
        $hudQueueListsByKey[$key] = $list
    }
}
foreach ($transaction in $transactions) {
    $caster = $null
    $buffs = $null
    $hudQueue = $null
    if ($transaction.PSObject.Properties['CasterSnapshot'] -and $transaction.CasterSnapshot -gt 0) {
        $key = Get-CasterSnapshotKey $transaction.Pid $transaction.Vm $transaction.CasterSnapshot
        if ($snapshotsByKey.ContainsKey($key)) { $caster = $snapshotsByKey[$key] }
        if ($combatBuffListsByKey.ContainsKey($key)) { $buffs = $combatBuffListsByKey[$key] }
        if ($hudQueueListsByKey.ContainsKey($key)) { $hudQueue = $hudQueueListsByKey[$key] }
    }
    $transaction | Add-Member -NotePropertyName CasterStats -NotePropertyValue $caster
    $transaction | Add-Member -NotePropertyName CasterBuffs -NotePropertyValue $buffs
    $transaction | Add-Member -NotePropertyName CasterHudQueue -NotePropertyValue $hudQueue
}

$summary = [pscustomobject]@{
    Schema = 2
    EvidenceBoundary = 'Observed exact-callsite inputs and immediate pre/post state; no inferred native damage formula'
    LogPath = $resolvedLog
    SinceByte = $SinceByte
    EndByte = $length
    LabelFilter = $Label
    SourceBodyFilter = $SourceBody
    SourcePathFilter = $SourcePath
    TargetTypeFilter = $TargetType
    RecordCount = $records.Count + $engineRecords.Count
    EngineRecordCount = $engineRecords.Count
    CasterRecordCount = $casterRecords.Count
    CasterSnapshots = @($casterRecords | Where-Object event -eq 'CASTER_STATS')
    StockStatCalculations = @($casterRecords | Where-Object event -eq 'CASTER_CALCULATION')
    BuffRecordCount = $buffRecords.Count
    BuffListObservations = @($buffLists)
    NativeBuffGetterProbeRecords = @($buffNativeProbes)
    BuffOwnerObservations = @($buffOwners)
    IncompleteBuffListCount = @($buffLists | Where-Object { -not $_.Complete }).Count
    ObservationLayersAreAdditive = $false
    TransactionCount = $transactions.Count
    CompleteCount = @($transactions | Where-Object Complete).Count
    IncompleteCount = @($transactions | Where-Object { -not $_.Complete }).Count
    Transactions = @($transactions)
}

if ($OutputPath.Length -gt 0) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent.Length -gt 0) { [IO.Directory]::CreateDirectory($parent) | Out-Null }
    $json = $summary | ConvertTo-Json -Depth 8
    [IO.File]::WriteAllText($OutputPath, $json + [Environment]::NewLine,
        [Text.UTF8Encoding]::new($false))
}
if ($CsvPath.Length -gt 0) {
    $parent = Split-Path -Parent $CsvPath
    if ($parent.Length -gt 0) { [IO.Directory]::CreateDirectory($parent) | Out-Null }
    $csv = @($transactions | Select-Object -Property * -ExcludeProperty RawRecords |
        ConvertTo-Csv -NoTypeInformation)
    [IO.File]::WriteAllLines($CsvPath, $csv, [Text.UTF8Encoding]::new($false))
}

if (-not $Quiet) {
    $transactions | Format-Table Correlation,Label,Complete,SourceBody,SourcePrototype,SourceInstruction,TargetType,StockRaw,InstalledRaw,VisiblePoolLoss,ArmourBefore,KilledAfter,RagdollAfter,DurationMs -AutoSize
    Write-Host ("BATTLE LOG ANALYSIS records={0} transactions={1} complete={2} incomplete={3} bytes={4}..{5}" -f $summary.RecordCount,$summary.TransactionCount,$summary.CompleteCount,$summary.IncompleteCount,$SinceByte,$length)
    if ($OutputPath.Length -gt 0) { Write-Host "JSON=$OutputPath" }
    if ($CsvPath.Length -gt 0) { Write-Host "CSV=$CsvPath" }
}
