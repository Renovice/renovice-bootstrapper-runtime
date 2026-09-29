<!-- V80 installed 2026-09-15: engine capture enabled; startup/live acceptance pending. V79 preserved as rollback. -->
# RENOVICE runtime diagnostics

Updated: 2026-09-16
Current installed runtime: V96 persistent memory evidence, with V95 DLL/config
preserved as rollback. Battle/engine/caster/buff diagnostics are OFF;
`Logging=true` and `DiagnosticsMemory=true` are ON. Startup and the next
pre-crash memory timeline remain live-pending; this is not an OOM repair.
V80 statements and profiles below retain their original dated acceptance scope.
`DiagnosticsMemory` is an independent exact boolean key, default false. With
ordinary Logging enabled it appends a UTC/PID-specific physical file at
`OpenWF\CustomScripts\Logs\renovice_memory_<UTC>_<PID>.log`, no more than once
per five seconds at natural owning-VM returns. It reads native Lua allocation,
collector state/cycles/roots and Windows process memory; above64MiB Lua
allocation it includes bounded raw queue headers. It does not create Lua
objects, retain a log queue or activate battle observers. Config off returns
before reading/formatting. Native scheduling and gameplay remain unchanged.
Read the [V96 operational/evidence guide](../../../../Documentation/04-Runtime-and-UI/Persistent-Memory-Evidence-V96-2026-09-16.md)
for limits, non-atomic observations, exact fingerprints and known failures.

The diagnostic system is part of the universal target-addon runtime. It does
not require an ability-specific C++ branch, logging support addon, timer,
watchdog, or per-frame poll.

## Configuration

The live file is
`OpenWF\CustomScripts\renovice.cfg` under the game directory.

```ini
DiagnosticsMemory=false
DiagnosticsMode=off
DiagnosticsMaxEvents=4096
DiagnosticsTarget=
DiagnosticsMethod=
DiagnosticsAddon=
DiagnosticsDamageCapture=off
DiagnosticsDamageSource=
DiagnosticsDamageTargetType=
DiagnosticsDamageType=
```

| Setting | Accepted value | Behavior |
| --- | --- | --- |
| `DiagnosticsMemory` | boolean, default false | Independent lightweight native memory evidence; requires Logging, works with battle mode off. Physical per-session file; one admitted natural VM return per5000ms. |
| `DiagnosticsMode` | `off` | Returns before bridge lookup, engine-value formatting, or event output and removes RENOVICE's owned bridge on the next accepted transaction. |
| `DiagnosticsMode` | `errors` | Records exact runtime event names containing `error`, `reject`, or `failed`; no Lua trace bridge is installed. |
| `DiagnosticsMode` | `battle` or `combat` | Installs the observation bridge and accepts explicit addon `BATTLE_*` records while suppressing routine successful runtime chatter; runtime failures remain visible. |
| `DiagnosticsMode` | `trace` | Records the full selected addon, Lua-call, and native-call event stream and accepts explicit addon trace records. |
| `DiagnosticsMaxEvents` | integer 1-65536 | Bounds one diagnostic generation; invalid input returns to 4096 and one suppression record reports exhaustion. |
| `DiagnosticsTarget` | optional 1-16 digit hex body key | Selects one exact target-addon body. In automatic damage mode it selects the exact source module body. Invalid or zero input fails closed. Blank selects all. |
| `DiagnosticsMethod` | optional exact method name | Filters native-call runtime records case-insensitively. Leave blank for an addon battle log. |
| `DiagnosticsAddon` | optional exact addon filename | Filters provider runtime records case-insensitively. Leave blank for an addon battle log. |
| `DiagnosticsDamageCapture` | `off`, `scripted`, or `engine` | `scripted` records Luau `DamageDD`. `engine` also observes the registered native per-target DamageControl handlers, including damage that bypasses Lua. It needs no per-ability logger. Native coverage requires live acceptance on the current build. |
| `DiagnosticsDamageSource` | optional exact module path or module name | Isolates automatic records to one cataloged source module. Matching is case-insensitive and exact. Blank captures all cataloged and uncataloged scripted callers. |
| `DiagnosticsDamageTargetType` | optional exact engine type name | Isolates automatic records to one receiver type, such as an avatar subtype. Blank accepts every target type. |
| `DiagnosticsDamageType` | optional integer 0-19 | Records a transaction only when the input packet has a nonzero fraction at that exact numeric damage-type index. Values outside 0-19 fail closed. |

`Diagnostics=true` remains a legacy alias for `DiagnosticsMode=trace`, and
`Diagnostics=false` means `off`. If both old and named keys occur, the last
exact key in file order wins.

Diagnostics are appended to
`OpenWF\CustomScripts\Logs\renovice_source.log`. `DiagnosticsMode` controls
diagnostic events independently of ordinary `Logging=true` output.

Write path (2026-09-29, `feat/script-packages-2026-09-29`): the log file stays
open; operational lines are written immediately, diagnostic lines go through a
bounded 64 KiB buffer flushed at least every 250 ms, before every operational
line, at process exit and when the near-null fault recorder fires. A hard kill
can lose at most the last ~250 ms of diagnostic lines. In `trace` mode the
per-hit lanes (`damage.*`, `dispatch.*`, `native.*`, `lua.call.*`) admit at most
32 lines per event name per second; each limited second is summarized once as
`event=trace.rate-limited suppressed_event=<name> admitted=<n> suppressed=<n>
untracked_dropped=<n>`. Suppressed lines do not consume `DiagnosticsMaxEvents`.
With `Diagnostics=false` no diagnostic string is formatted.

## Recommended profiles

V80 native damage test profile: use the broad profile below with
`DiagnosticsDamageCapture=engine`. Native observations are compact JSON begin/end
records in the same Logs/renovice_source.log; the same analyzer reads them.
They include source context when a cataloged Lua damage/area request is active,
target/control/packet identity, damage fractions and base amount, and immediate
health/shield/Overguard changes. A native source without Lua context remains
unknown instead of acquiring an inferred ability label. Missing or unverified
native getters yield null; life/status/armor readings remain unavailable in this
new lane. Existing richer Lua/addon snapshots remain intact.

Native and Lua records can observe the same stock hit. Their quantities must
not be added together. Native capture has its own bounded budget, independently
of zero-amount scripted status traffic. F9 resets its generation budget and
updates filters; native trampolines are never retired during F9. A new DLL still
requires a game restart. `DiagnosticsMode=off` returns directly to stock before
native state reading or formatting. Research and acceptance:
`RESEARCH/NATIVE_DAMAGE_BOUNDARY_2026-09-15/README.md`.

Ordinary play:

```ini
DiagnosticsMode=off
DiagnosticsMaxEvents=4096
DiagnosticsTarget=
DiagnosticsMethod=
DiagnosticsAddon=
DiagnosticsDamageCapture=off
DiagnosticsDamageSource=
DiagnosticsDamageTargetType=
DiagnosticsDamageType=
```

Automatic scripted-damage battle log for every source:

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

After the broad capture reveals a source path or body key, isolate it without
editing or recompiling the source ability:

```ini
DiagnosticsMode=battle
DiagnosticsMaxEvents=8192
DiagnosticsTarget=f62b70b45fc7fdf9
DiagnosticsMethod=DamageDD
DiagnosticsAddon=
DiagnosticsDamageCapture=scripted
DiagnosticsDamageSource=
DiagnosticsDamageTargetType=
DiagnosticsDamageType=4
```

Complete low-level trace of one native method:

```ini
DiagnosticsMode=trace
DiagnosticsMaxEvents=4096
DiagnosticsTarget=08faf07b504d058f
DiagnosticsMethod=PushFloatArg
DiagnosticsAddon=
DiagnosticsDamageCapture=off
```

## Runtime and reload behavior

Startup reads the file once. F9 stages the config together with the managed
script snapshot and commits both only after the generation succeeds. The
runtime reconciles the bridge, embedded automatic observer, and exact native
hook contract in the current VM after commit. Turning automatic capture on or
off and changing its filters therefore does not require editing an ability
addon. A process restart remains the most complete way to catalog the source
identity of modules that were already loaded before capture was enabled;
uncataloged calls still record when no source-body or source-name filter is set.

The bridge is a runtime-owned C closure cached as a verified Luau value for the
target callback transport. A cached value is used only while it remains a
readable Lua closure; otherwise it is discarded and the exact `_T` binding is
checked again. RENOVICE neither overwrites nor removes a foreign
`_T.RENOVICE_TRACE` value.

F9 resets the diagnostic event budget. It does not create a gameplay watcher or
alter stock behavior. Callback or formatter failure preserves the stock path
and becomes a failure record when diagnostics allow it. A DLL replacement
requires a full process restart.

Automatic capture is observation-only. It reads the existing packet and target
state immediately before and after stock `DamageDD`; it never changes damage,
health, shields, Overguard, statuses, results, or another gameplay-owned value.
One automatic transaction uses ten trace records, so the native host also caps
the number of transactions to `DiagnosticsMaxEvents / 10`, with an absolute
maximum of 4096. If an exact target addon already owns that same `DamageDD`
method, its richer explicit record wins and the automatic lane is suppressed
for that call to prevent duplicate transactions.

## Exact coverage boundary

The V78 live test passed observer startup but rejected automatic capture:
91 before-callback errors arose from an unavailable `math.huge` export. V79
removes that dependency and adds a restricted-environment regression test.
Upstream Luau execution and DE bytecode roundtrip alone do not certify the
game's available standard-library exports. See
`RESEARCH/AUTOMATIC_DAMAGE_RESTRICTED_MATH_FIX_V79_2026-09-15.md` for the
preserved failure and repaired-build evidence. Live multi-source acceptance
passed for V79 with 64 automatic transactions across two independent sources.
Together with 36 explicit Ice Wave records, schema-2 analysis has 100 complete
transactions and zero incomplete records or runtime failures. Exact source
isolation of the saved live capture passes; runtime F9 filter acceptance remains
untested. See `RESEARCH/AUTOMATIC_DAMAGE_LIVE_ACCEPTANCE_V79_2026-09-15.md`.

The `scripted` lane automatically covers per-target damage delivered through
the Luau-visible `BaseAvatar:DamageDD(DamageData)` boundary. This includes any
ability or other loaded script using that boundary; no source list is required.
It does not yet prove coverage of weapon, projectile, or other damage resolved
entirely inside native engine code without a Luau `DamageDD` call. `RadialDamage`
is an area request and does not expose trustworthy per-target resolved results
at its Luau boundary, so it is not mislabeled as a completed battle transaction.

## Reuse for another ability

First try the automatic profile. If the ability reaches `DamageDD`, no logging
code belongs in the ability addon. Run a broad capture, inspect `SourceBody`,
`SourcePath`, `SourcePrototype`, and `SourceInstruction` in the analyzer output,
then apply an exact config or analyzer filter.

Only use the explicit-addon procedure below for an authoritative boundary that
automatic scripted capture cannot observe, or when the addon owns richer
source-specific values:

1. Prove the exact authoritative callsite and the available receiver/arguments.
2. Embed `CombatTransactionBattleLogV5.luau` in that target addon.
3. Supply only fields proven at that callsite. Mark source/ability or other
   unavailable values unknown instead of inferring them.
4. Call `battleLogBegin` immediately before the one native combat call and
   `battleLogFinish` immediately after it.
5. Select the target with `DiagnosticsMode=battle`, record the pretest log byte
   boundary, reproduce once, and run `AnalyzeCombatBattleLog.ps1`.
6. Treat the output as callsite evidence. Gameplay meaning and displayed combat
   numbers remain separate claims.
7. Return to `DiagnosticsMode=off` after the capture.

The detailed transaction schema and analyzer instructions are in
`RENOVICE_SCRIPTING\DIAGNOSTICS\README.md`.

## V82 caster stats (2026-09-15)

DiagnosticsCasterStats=true enables the existing managed observer's effective
Warframe snapshots and immutable stock upgrade-calculation inputs/outputs in
battle/trace mode with automatic damage capture enabled. False defaults off.
Output stays in CustomScripts/Logs/renovice_source.log. IDs are process-monotonic;
F9 resets the bounded snapshot budget and weak packet associations, so recast.
Rank-aware base, permanent-only loadout and contributor separation remain
explicitly unavailable; dispatch records are not cast-start snapshots.
Read the central Documentation/03-Abilities-and-Combat/Caster-Stats-2026-09-15.md
guide and the WARFRAME_STAT_DIAGNOSTICS_V82_2026-09-15 deployment package.
