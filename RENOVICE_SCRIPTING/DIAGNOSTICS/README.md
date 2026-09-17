# RENOVICE battle-log diagnostics

`CombatTransactionBattleLogV5.luau` is the reusable combat transaction
component. It observes one target at one exact synchronous native combat call.
It does not scan enemies, poll frames, replay damage, or maintain gameplay
state.

V77 also embeds that exact component in an automatic scripted-damage observer.
With `DiagnosticsDamageCapture=scripted`, the native host wraps every observed
Luau `DamageDD` call and supplies the caller module body, module path/name,
prototype, instruction, and target type. Ability files no longer need a copied
battle logger merely to capture this boundary.

The current Ice Wave addon calls `battleLogBegin(hostTrace, context)` directly
before its authoritative `DamageDD` call and calls
`battleLogFinish(transaction, outcome)` directly after it. One correlation ID
therefore belongs to one target and one native hit. A cast that hits five
enemies produces five independent transactions.

## Enable the quiet battle profile

The live configuration is:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts\renovice.cfg`

Use this profile for Ice Wave:

```ini
DiagnosticsMode=battle
DiagnosticsMaxEvents=8192
DiagnosticsTarget=f62b70b45fc7fdf9
DiagnosticsMethod=
DiagnosticsAddon=
DiagnosticsDamageCapture=off
```

`battle` installs the runtime-owned trace bridge and accepts explicit
`BATTLE_*` records from the selected target. It suppresses ordinary successful
loader, hook, and native-call chatter while retaining runtime failures. Use
`trace` only when the complete low-level hook stream is needed. Use `off` for
ordinary play.

F9 applies configuration and addon changes in the current runtime generation.
Replacing `WTSAPI32.dll` still requires a full game restart.

Use this profile to discover every Luau-visible scripted damage source first:

```ini
DiagnosticsMode=battle
DiagnosticsMaxEvents=16384
DiagnosticsTarget=
DiagnosticsMethod=
DiagnosticsAddon=
DiagnosticsDamageCapture=scripted
DiagnosticsDamageSource=
DiagnosticsDamageTargetType=
DiagnosticsDamageType=
```

Leave the isolation fields blank during discovery. The analyzer reports source
identity for every automatic transaction. You can then set an exact
`DiagnosticsTarget` body key, `DiagnosticsDamageSource` module path/name,
`DiagnosticsDamageTargetType`, or numeric `DiagnosticsDamageType` and press F9.

## Recorded transaction

V5 emits exactly these nine records for a complete transaction:

1. `BATTLE_TX_BEGIN`
2. `BATTLE_STATE_BEGIN`
3. `BATTLE_LIFE_BEGIN`
4. `BATTLE_STATUS_BEGIN`
5. `BATTLE_DAMAGE_INPUT`
6. `BATTLE_STATE_END`
7. `BATTLE_LIFE_END`
8. `BATTLE_STATUS_END`
9. `BATTLE_MATH`

The automatic observer emits one additional `AUTO_DAMAGE_IDENTITY` record, for
ten total trace records per hit. The nine `BATTLE_*` records and their
completeness rule remain unchanged.

The records include:

- process, VM, correlation, label, target ordinal, exact prototype, and exact
  instruction;
- target and damage-packet identity;
- optional source and source-ability identity, each with an explicit known
  flag;
- health, maximum health, shield, maximum shield, Overguard, and current armor
  before and after;
- independently protected `IsKilled`, `IsDead`, and ragdoll-presence reads,
  each with an availability flag;
- numeric status counts for indices 0 through 19;
- numeric input damage fractions for indices 0 through 19;
- stock raw damage, modifier name/value, requested raw damage, installed raw
  damage, restored raw damage, and an optional reported raw value;
- visible health, shield, and Overguard loss, their total, and the difference
  between installed raw damage and visible pool loss.

Current armor uses `DamageControl:GetArmourRating()`. Stock
`PostCameraUpdateHud` proves that exact zero-argument read for the target's
current armor display path. No maximum-armor getter has been proven, so V5 does
not invent one.

Status indices remain numeric until their names are separately proven. The
Ice Wave `DamageDD` callback does not provide a proven caster or ability object,
so its current source fields explicitly record `known=false`.

Every optional engine read is protected separately. A target wrapper may lack
`IsDead` or `GetRagdoll`; the logger records the field as unavailable and the
gameplay call continues. When no host trace closure is supplied,
`battleLogBegin` returns before reading any combat state.

## Analyze a bounded run

Record the log byte length before reproducing:

```powershell
$log = 'C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts\Logs\renovice_source.log'
$start = (Get-Item -LiteralPath $log).Length
```

After the test:

```powershell
& .\AnalyzeCombatBattleLog.ps1 `
  -LogPath $log `
  -SinceByte $start `
  -Label FROST_ICE_WAVE_DAMAGE `
  -OutputPath .\battle-run.json `
  -CsvPath .\battle-run.csv
```

Automatic discovery and exact post-capture isolation are also available at
analysis time:

```powershell
& .\AnalyzeCombatBattleLog.ps1 `
  -LogPath $log `
  -SinceByte $start `
  -Label AUTO_SCRIPTED_DAMAGE_DD `
  -SourceBody f62b70b45fc7fdf9 `
  -TargetType AvatarType `
  -OutputPath .\automatic-damage.json
```

The analyzer groups by process, VM, and correlation. It marks a transaction
complete only when all nine records are present. JSON preserves the original
records; CSV provides one row per hit. Automatic rows also expose
`AutoSequence`, `SourceBody`, `SourcePath`, `SourceName`, `SourcePrototype`,
`SourceInstruction`, and `TargetType`. The tool supports Windows PowerShell 5.1
and PowerShell 7 and writes UTF-8 without a BOM.

## Evidence boundary

Analyzer schema 2 separates automatic and explicit producers even when their
correlation counters match, and starts a fresh transaction instance when a
counter is reused after reset. Completeness requires all nine canonical events
without duplicates. Give independent explicit producers distinct labels.
Pass `-Quiet` when another script consumes the JSON/CSV files, so formatting
objects are not emitted into its pipeline. Regression checks are reusable:
`RENOVICE_TOOLCHAIN/diagnostics/verify_battle_log_analyzer.ps1`.

V79 live acceptance recorded 64 automatic transactions across Avalanche and a
separate status-spread script, plus 36 existing explicit Ice Wave transactions.
All 100 were complete, with zero runtime failures. Saved-capture source
isolation passes; F9 config isolation remains a separate untested live gate.
See `../RESEARCH/AUTOMATIC_DAMAGE_LIVE_ACCEPTANCE_V79_2026-09-15.md`.

The log proves inputs and immediate pre/post state at the hooked callsite. It
does not reconstruct DE's hidden native damage equation. Armor, resistance,
damage attenuation, invulnerability, weak points, critical calculations, and
other native rules can make raw damage differ from visible pool loss. The
reported arithmetic is therefore an audit aid, not a claim that
`visiblePoolLoss` is the engine's authoritative damage result.

Offline verification proves field correlation, target isolation, getter
failure handling, numeric packet restoration, the dormant path, analyzer
parsing, and build integrity. Live gameplay remains a separate acceptance gate
for each instrumented ability.

The current automatic lane covers every damage transaction that reaches the
Luau-visible per-target `DamageDD` boundary. Damage delivered wholly inside
native weapon/projectile code is outside this proven lane. The runtime records
that boundary honestly instead of treating an area-level `RadialDamage` request
as if it contained per-target resolved results.
