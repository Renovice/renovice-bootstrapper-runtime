[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repo = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$analyzer = Join-Path $repo 'RENOVICE_SCRIPTING\DIAGNOSTICS\AnalyzeCombatBattleLog.ps1'
$fixture = [IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'fixtures\scripted-damage.log'))
$work = Join-Path $repo 'work\battle-log-analyzer-verification'
New-Item -ItemType Directory -Path $work -Force | Out-Null
$utf8 = [Text.UTF8Encoding]::new($false)

$explicit = @($fixture | ForEach-Object {
    [regex]::Replace($_, ' auto_capture=.*?(?= pid=)', '').Replace(
        'AUTO_SCRIPTED_DAMAGE_DD','EXPLICIT_TEST_DAMAGE').Replace(
        'arg5_tag=9=0x111','arg5_tag=9=0x333')
})
$mixed = [Collections.Generic.List[string]]::new()
for ($index = 0; $index -lt $fixture.Length; $index++) {
    $mixed.Add($fixture[$index])
    $mixed.Add($explicit[$index])
}
# Same process/VM/counter/auto sequence after a reset must start a fresh group.
foreach ($line in $fixture) { $mixed.Add($line.Replace('arg5_tag=9=0x111','arg5_tag=9=0x555')) }
$mixedPath = Join-Path $work 'mixed-reset.log'
[IO.File]::WriteAllLines($mixedPath,$mixed,$utf8)

function Analyze-Test([string]$name, [string]$log, [hashtable]$filters,
        [int]$records, [int]$transactions, [int]$complete, [int]$incomplete) {
    $json = Join-Path $work ($name + '.json')
    $output = @(& $analyzer -Quiet -LogPath $log -OutputPath $json @filters)
    if ($output.Count -ne 0) { throw "${name}: Quiet emitted formatting objects" }
    $report = Get-Content -LiteralPath $json -Raw | ConvertFrom-Json
    if ($report.Schema -ne 2 -or $report.RecordCount -ne $records -or
            $report.TransactionCount -ne $transactions -or
            $report.CompleteCount -ne $complete -or
            $report.IncompleteCount -ne $incomplete) {
        throw "$name count or completeness mismatch"
    }
    Write-Host "PASS $name records=$records transactions=$transactions complete=$complete incomplete=$incomplete"
    return $report
}

$report = Analyze-Test 'mixed-independent-counters-and-reset' $mixedPath @{} 27 3 3 0
if (@($report.Transactions | Where-Object Target -eq '0x111').Count -ne 1 -or
        @($report.Transactions | Where-Object Target -eq '0x333').Count -ne 1 -or
        @($report.Transactions | Where-Object Target -eq '0x555').Count -ne 1 -or
        @($report.Transactions | Where-Object { $_.RawRecords.Count -ne 9 }).Count -ne 0) {
    throw 'Mixed capture inherited another transaction target or records'
}
[void](Analyze-Test 'exact-auto-source-filter' $mixedPath @{
    SourceBody='08faf07b504d058f'; SourcePath='/Lotus/Powersuits/Test/TestAbility'
    TargetType='/Lotus/Types/Game/Avatar'
} 18 2 2 0)
[void](Analyze-Test 'explicit-label-filter' $mixedPath @{Label='EXPLICIT_TEST_DAMAGE'} 9 1 1 0)
[void](Analyze-Test 'unknown-source-filter' $mixedPath @{SourceBody='1111111111111111'} 0 0 0 0)

$incompletePath = Join-Path $work 'missing-event.log'
[IO.File]::WriteAllLines($incompletePath,@($fixture | Where-Object { -not $_.Contains('"BATTLE_LIFE_END"') }),$utf8)
[void](Analyze-Test 'missing-event-is-incomplete' $incompletePath @{} 8 1 0 1)
$duplicatePath = Join-Path $work 'duplicate-event.log'
$duplicate = [Collections.Generic.List[string]]::new()
foreach ($line in $fixture) {
    $duplicate.Add($line)
    if ($line.Contains('"BATTLE_STATE_BEGIN"')) { $duplicate.Add($line) }
}
[IO.File]::WriteAllLines($duplicatePath,$duplicate,$utf8)
[void](Analyze-Test 'duplicate-event-is-incomplete' $duplicatePath @{} 10 1 0 1)
$nativeBegin = [ordered]@{
    Schema=1;Build='V80';Phase='begin';Pid=123;Thread=77;Generation=0;Correlation=1
    ParentCorrelation=0;HandlerSlot=0;Vm='0xabc';SourceBody='0x1234';SourcePrototype=3
    SourceInstruction=12;SourcePath='/Lotus/Powersuits/Test/';SourceName='AreaTest.lua'
    Method='RadialDamage';Target='0x777';TargetType='Avatar';DamageControl='0x888';Packet='0x999'
    BeginTickMs=100;TickMs=100;ObservedRaw=500;HealthBefore=1000;ShieldBefore=0;OverguardBefore=0
    DamageFractions=@(0,0,0,0,0,0,0,0,0,0,0,1);LifeStateAvailable=$false;StatusProfileAvailable=$false
}
$nativeEnd = [ordered]@{}
foreach ($key in $nativeBegin.Keys) { $nativeEnd[$key]=$nativeBegin[$key] }
$nativeEnd.Phase='end';$nativeEnd.TickMs=101
$nativeEnd.HealthAfter=867;$nativeEnd.ShieldAfter=0;$nativeEnd.OverguardAfter=0
$nativeEnd.HealthLoss=133;$nativeEnd.ShieldLoss=0;$nativeEnd.OverguardLoss=0
$nativeEnd.VisiblePoolLoss=133;$nativeEnd.VisiblePoolLossComplete=$true
$nativeLines = @($nativeBegin,$nativeEnd | ForEach-Object {
    'RENOVICE ENGINE_DAMAGE json=' + (ConvertTo-Json -Compress -Depth 5 -InputObject $_)
})
$nativePath = Join-Path $work 'native-133-damage.log'
[IO.File]::WriteAllLines($nativePath,$nativeLines,$utf8)
$nativeReport = Analyze-Test 'native-133-damage' $nativePath @{} 2 1 1 0
if ($nativeReport.Transactions[0].HealthLoss -ne 133 -or
    $nativeReport.Transactions[0].HealthBefore -ne 1000 -or
    $nativeReport.Transactions[0].HealthAfter -ne 867 -or
    $nativeReport.Transactions[0].ObservedRaw -ne 500 -or
    $nativeReport.ObservationLayersAreAdditive -ne $false) { throw 'Native pool loss was confused with requested damage' }
[void](Analyze-Test 'native-source-and-type-filter' $nativePath @{
    SourceBody='1234';SourcePath='AreaTest.lua';TargetType='Avatar'
} 2 1 1 0)
$nativeMissingPath=Join-Path $work 'native-missing-return.log'
[IO.File]::WriteAllLines($nativeMissingPath,@($nativeLines[0]),$utf8)
[void](Analyze-Test 'native-missing-return-is-incomplete' $nativeMissingPath @{} 1 1 0 1)
$nativeMixedPath=Join-Path $work 'native-and-lua-independent-counters.log'
[IO.File]::WriteAllLines($nativeMixedPath,@($fixture)+$nativeLines,$utf8)
[void](Analyze-Test 'native-and-lua-counter-isolation' $nativeMixedPath @{} 11 2 2 0)
$nativeResetPath=Join-Path $work 'native-generation-reset.log'
$nativeResetLines=@($nativeLines)+@($nativeLines | ForEach-Object { $_.Replace('"Generation":0','"Generation":1') })
[IO.File]::WriteAllLines($nativeResetPath,$nativeResetLines,$utf8)
[void](Analyze-Test 'native-F9-generation-counter-isolation' $nativeResetPath @{} 4 2 2 0)
$nativeEndOnlyPath=Join-Path $work 'native-end-without-begin.log'
[IO.File]::WriteAllLines($nativeEndOnlyPath,@($nativeLines[1]),$utf8)
[void](Analyze-Test 'native-end-without-begin-is-incomplete' $nativeEndOnlyPath @{} 1 1 0 1)
Write-Output 'BATTLE LOG ANALYZER PASS producer isolation, reset reuse, exact filters, missing/duplicate detection, quiet automation'

$casterPayload = [ordered]@{
    Schema=1;Snapshot=42;Method='RadialDamage';Caster='0x100';CasterKnown=$true
    Base=@{available=$false;reason='rank-aware baseline unverified'}
    Loadout=@{available=$false;reason='temporary upgrade separation unverified'}
    Live=@{strength=@{value=3;available=$true};health=@{value=555;available=$true}}
    LongEvidence=('quoted " path \' * 100)
}
$casterLine='RENOVICE CASTER_STATS build=V82 pid=123 vm=0000ABC tick_ms=100 event=CASTER_STATS snapshot=42 source_body=0x1234 source_path="/Lotus/Powersuits/Test/" source_name="AreaTest.lua" json=' + (ConvertTo-Json -InputObject $casterPayload -Compress -Depth 7)
$nativeWithCaster=@($nativeLines | ForEach-Object { $_.Replace('"Correlation":1','"Correlation":1,"CasterSnapshot":42') })
$casterPath=Join-Path $work 'caster-long-payload-and-native-join.log'
[IO.File]::WriteAllLines($casterPath,@($casterLine)+$nativeWithCaster,$utf8)
$casterReport=Analyze-Test 'caster-long-json-and-exact-native-join' $casterPath @{} 2 1 1 0
if ($casterReport.CasterRecordCount -ne 1 -or $casterReport.CasterSnapshots.Count -ne 1 -or
    $casterReport.Transactions[0].CasterStats.Live.strength.value -ne 3 -or
    $casterReport.Transactions[0].CasterStats.LongEvidence -cne $casterPayload.LongEvidence -or
    $casterReport.Transactions[0].CasterStats.Base.available -ne $false) { throw 'Caster payload truncated, mislabeled or incorrectly joined' }
$wrongPidPath=Join-Path $work 'caster-other-process-no-join.log'
[IO.File]::WriteAllLines($wrongPidPath,@($casterLine.Replace('pid=123','pid=124'))+$nativeWithCaster,$utf8)
$wrongPid=Analyze-Test 'caster-other-process-no-inherited-stats' $wrongPidPath @{} 2 1 1 0
if ($null -ne $wrongPid.Transactions[0].CasterStats) { throw 'Caster snapshot inherited from another process' }
$noCasterPath=Join-Path $work 'caster-missing-snapshot.log'
[IO.File]::WriteAllLines($noCasterPath,$nativeWithCaster,$utf8)
$noCaster=Analyze-Test 'caster-missing-snapshot-stays-unavailable' $noCasterPath @{} 2 1 1 0
if ($null -ne $noCaster.Transactions[0].CasterStats) { throw 'Missing caster snapshot was fabricated' }
Write-Output 'CASTER ANALYZER PASS complete long JSON, pointer normalization, exact process/VM/ID join, missing snapshot stays unavailable'

$buffPayload=[ordered]@{
    Schema=1;Snapshot=42;Method='GetBuffNotifications';ObservedAt='caster-combat-boundary'
    Receiver='0x100';ReceiverType='Avatar';Available=$true;Reason=$null
    NativeCount=3;CapturedCount=3;Truncated=$false;Chunk=1;Chunks=2
    CompleteContributorList=$false
    Records=@(@{Ordinal=1;NameTag='/Lotus/Language/Test/NativeArcane';HudPercent=40;TimerSeconds=15;StackCount=$null},
        @{Ordinal=2;NameTag='/Lotus/Language/Test/Ability';HudNumericValue=6;StackCount=$null})
}
function Buff-Line($payload) {
    'RENOVICE CASTER_STATS build=V85 pid=123 vm=0000ABC tick_ms=100 event=BUFF_LIST snapshot=42 source_body=0x1234 json=' + (ConvertTo-Json -InputObject $payload -Compress -Depth 7)
}
$firstBuffLine=Buff-Line $buffPayload
$buffPayload.Chunk=2;$buffPayload.Records=@(@{Ordinal=3;NameAvailable=$false;BuffType=999;BuffDataExtra=17})
$secondBuffLine=Buff-Line $buffPayload
$buffPath=Join-Path $work 'buff-chunks-and-exact-combat-join.log'
[IO.File]::WriteAllLines($buffPath,@($casterLine,$firstBuffLine,$secondBuffLine)+$nativeWithCaster,$utf8)
$buffReport=Analyze-Test 'native-buff-chunks-and-exact-combat-join' $buffPath @{} 2 1 1 0
if ($buffReport.BuffRecordCount -ne 2 -or $buffReport.BuffListObservations.Count -ne 1 -or
    -not $buffReport.BuffListObservations[0].Complete -or
    $buffReport.Transactions[0].CasterBuffs.Buffs.Count -ne 3 -or
    $buffReport.Transactions[0].CasterBuffs.Buffs[0].TimerSeconds -ne 15 -or
    $null -ne $buffReport.Transactions[0].CasterBuffs.Buffs[0].StackCount -or
    $buffReport.Transactions[0].CasterBuffs.CompleteContributorList) { throw 'Native buffs lost fields, inherited stats or fabricated stacks' }
$missingBuffPath=Join-Path $work 'buff-missing-chunk.log'
[IO.File]::WriteAllLines($missingBuffPath,@($firstBuffLine),$utf8)
$missingBuff=Analyze-Test 'native-buff-missing-chunk-is-incomplete' $missingBuffPath @{} 0 0 0 0
if ($missingBuff.IncompleteBuffListCount -ne 1 -or $missingBuff.BuffListObservations[0].Buffs.Count -ne 2) { throw 'Missing buff chunk fabricated completeness' }
$wrongBuffPath=Join-Path $work 'buff-other-process-no-join.log'
[IO.File]::WriteAllLines($wrongBuffPath,@($firstBuffLine,$secondBuffLine | ForEach-Object {$_.Replace('pid=123','pid=124')})+$nativeWithCaster,$utf8)
$wrongBuff=Analyze-Test 'native-buff-other-process-no-inherited-list' $wrongBuffPath @{} 2 1 1 0
if ($null -ne $wrongBuff.Transactions[0].CasterBuffs) { throw 'Buff list inherited from another process' }
$queueBuffPath=Join-Path $work 'buff-queue-is-not-combat-snapshot.log'
[IO.File]::WriteAllLines($queueBuffPath,@($firstBuffLine,$secondBuffLine | ForEach-Object {$_.Replace('caster-combat-boundary','stock-native-getter-return')})+$nativeWithCaster,$utf8)
$queueBuff=Analyze-Test 'native-buff-queue-is-not-caster-active-list' $queueBuffPath @{} 2 1 1 0
if ($null -ne $queueBuff.Transactions[0].CasterBuffs -or $queueBuff.BuffListObservations.Count -ne 1) { throw 'HUD queue was mislabeled current caster list' }
$duplicateBuffPath=Join-Path $work 'buff-duplicate-chunk.log'
[IO.File]::WriteAllLines($duplicateBuffPath,@($firstBuffLine,$firstBuffLine),$utf8)
$rejected=$false
try { & $analyzer -Quiet -LogPath $duplicateBuffPath } catch { $rejected=$_.Exception.Message -like '*duplicate buff-list chunk*' }
if (-not $rejected) { throw 'Duplicate buff-list chunk not rejected' }
Write-Output 'UNIVERSAL BUFF ANALYZER PASS exact chunks, process/VM/ID joins, missing records, unknown fields, no guessed stack count, queue versus combat list, duplicate rejection'

$emptyNative=[ordered]@{
    Schema=1;Snapshot=42;Method='GetBuffNotifications';ObservedAt='caster-combat-boundary'
    Receiver='0x100';ReceiverType='Avatar';Available=$true;Reason=$null
    GetterSucceeded=$true;ReturnType='nil';GetterError=$null;EmptyNativeList=$true
    NativeCount=0;CapturedCount=0;Truncated=$false;Chunk=1;Chunks=1
    CompleteContributorList=$false;Records=@()
}
$hudNative=[ordered]@{}
foreach($key in $emptyNative.Keys){$hudNative[$key]=$emptyNative[$key]}
$hudNative.ObservedAt='caster-hud-queue-boundary';$hudNative.ReceiverType='HudStatus'
$hudNative.ReturnType='table';$hudNative.EmptyNativeList=$false
$hudNative.NativeCount=1;$hudNative.CapturedCount=1
$hudNative.Records=@(@{Ordinal=1;NameTag='/Lotus/Language/Test/NativeArcane';HudPercent=40;AddBuff=$true;StackCount=$null})
$probeLines=@(
    'RENOVICE BUFF_NATIVE build=V86 pid=123 vm=0000ABC tick_ms=100 event=ingress sequence=1 binding_slot=1 lane=stock reentrant=0 observer_running=0 reason=native-getter-entered returned_count=-1 result0_tag=-1',
    'RENOVICE BUFF_NATIVE build=V86 pid=123 vm=0000ABC tick_ms=100 event=selection sequence=1 binding_slot=1 lane=stock reentrant=0 observer_running=0 reason=buff-observer-selected returned_count=-1 result0_tag=-1',
    'RENOVICE BUFF_NATIVE build=V86 pid=123 vm=0000ABC tick_ms=100 event=return sequence=1 binding_slot=1 lane=stock reentrant=0 observer_running=0 reason=stock-result-before-observer returned_count=1 result0_tag=0'
)
$emptyPath=Join-Path $work 'v86-empty-native-and-distinct-hud-queue.log'
[IO.File]::WriteAllLines($emptyPath,@($casterLine,(Buff-Line $emptyNative),(Buff-Line $hudNative))+$nativeWithCaster+$probeLines,$utf8)
$emptyResult=Analyze-Test 'v86-valid-empty-nil-distinct-hud-queue-native-probes' $emptyPath @{} 2 1 1 0
if(-not $emptyResult.Transactions[0].CasterBuffs.EmptyNativeList -or
    $emptyResult.Transactions[0].CasterBuffs.ReturnType -ne 'nil' -or
    $emptyResult.Transactions[0].CasterHudQueue.Buffs[0].NameTag -ne '/Lotus/Language/Test/NativeArcane' -or
    $emptyResult.NativeBuffGetterProbeRecords.Count -ne 3 -or
    $emptyResult.NativeBuffGetterProbeRecords[2].result0_tag -ne '0') {throw 'V86 empty/queue/probe semantics lost or merged'}
$failureNative=[ordered]@{}
foreach($key in $emptyNative.Keys){$failureNative[$key]=$emptyNative[$key]}
$failureNative.Available=$false;$failureNative.Reason='getter-failed'
$failureNative.GetterSucceeded=$false;$failureNative.GetterError='native "quoted" test-error'
$failureNative.EmptyNativeList=$false;$failureNative.NativeCount=$null
$failurePath=Join-Path $work 'v86-failed-getter-retains-error.log'
[IO.File]::WriteAllLines($failurePath,@((Buff-Line $failureNative)),$utf8)
$failureResult=Analyze-Test 'v86-failed-getter-retains-error-versus-empty' $failurePath @{} 0 0 0 0
if($failureResult.BuffListObservations[0].GetterError -cne $failureNative.GetterError -or
    $failureResult.BuffListObservations[0].GetterSucceeded -or
    $failureResult.BuffListObservations[0].EmptyNativeList) {throw 'Getter failure incorrectly accepted as empty'}
$metadataPath=Join-Path $work 'v86-conflicting-getter-metadata.log'
$metadataLines=@($firstBuffLine.Replace('"Schema":1','"GetterSucceeded":true,"ReturnType":"table","Schema":1'),
    $secondBuffLine.Replace('"Schema":1','"GetterSucceeded":false,"ReturnType":"nil","Schema":1'))
[IO.File]::WriteAllLines($metadataPath,$metadataLines,$utf8)
$rejected=$false
try {& $analyzer -Quiet -LogPath $metadataPath} catch {$rejected=$_.Exception.Message -like '*Conflicting native buff getter metadata*'}
if(-not $rejected){throw 'Conflicting getter metadata silently merged'}
Write-Output 'V86 ANALYZER PASS valid empty nil, retained getter errors, exact separate HUD queue joins, native probe preservation, conflicting metadata rejection'

$ownerPayload=[ordered]@{
    Schema=1;Snapshot=42;Method='GetHudStatus';ObservedAt='stock-hud-owner-getter-return'
    Receiver='0x321';OwnerAvailable=$true;Owner='0x654';OwnerReturnType='userdata'
    QueueGetterAttempted=$true
}
$ownerLine='RENOVICE CASTER_STATS build=V87 pid=123 vm=0000ABC tick_ms=100 event=BUFF_OWNER snapshot=42 source_body=0x1234 json=' + (ConvertTo-Json -InputObject $ownerPayload -Compress -Depth 7)
$stockHud=[ordered]@{}
foreach($key in $hudNative.Keys){$stockHud[$key]=$hudNative[$key]}
$stockHud.ObservedAt='stock-hud-owner-getter-return'
$newProbes=@($probeLines | ForEach-Object {$_.Replace('build=V86','build=V87').Replace(' lane=',' method=GetHudStatus lane=')})
$ownerPath=Join-Path $work 'v87-stock-owner-return-is-separate-evidence.log'
[IO.File]::WriteAllLines($ownerPath,@($ownerLine,(Buff-Line $stockHud))+$nativeWithCaster+$newProbes,$utf8)
$ownerResult=Analyze-Test 'v87-stock-owner-and-queue-are-not-nearest-combat-joins' $ownerPath @{} 2 1 1 0
if($ownerResult.BuffOwnerObservations.Count -ne 1 -or $ownerResult.CasterRecordCount -ne 0 -or
    $ownerResult.BuffOwnerObservations[0].Owner -ne '0x654' -or
    $ownerResult.BuffOwnerObservations[0].OwnerReturnType -ne 'userdata' -or
    $ownerResult.NativeBuffGetterProbeRecords[0].method -ne 'GetHudStatus' -or
    $ownerResult.BuffListObservations.Count -ne 1 -or
    $null -ne $ownerResult.Transactions[0].CasterBuffs -or
    $null -ne $ownerResult.Transactions[0].CasterHudQueue) {throw 'Stock owner/queue fabricated combat context or lost method/type'}
if($null -ne $emptyResult.NativeBuffGetterProbeRecords[0].method) {throw 'Legacy probe method fabricated'}
$ownerOtherPath=Join-Path $work 'v87-owner-other-process.log'
[IO.File]::WriteAllLines($ownerOtherPath,@($ownerLine.Replace('pid=123','pid=124'))+$nativeWithCaster,$utf8)
$ownerOther=Analyze-Test 'v87-owner-other-process-is-not-a-caster-snapshot' $ownerOtherPath @{} 2 1 1 0
if($null -ne $ownerOther.Transactions[0].CasterStats) {throw 'Owner inherited across process or became stats'}
Write-Output 'V87 ANALYZER PASS native owner/type and method preserved; legacy method absent; stock owner/queue never inferred as combat contributor'
