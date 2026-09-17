# Universal combat transaction meter

Date: 2026-09-13

## Question

Can one reusable, centrally toggleable diagnostic component show the incoming
damage calculation and the target's surrounding combat state without adding an
ability-specific logger to the runtime or leaving a permanent gameplay loop?

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The current runtime already exposes a suitable central diagnostic transport. | V67 installs the observation-only `_T.RENOVICE_TRACE` closure for an exact selected target when `DiagnosticsMode=trace` and both method/addon filters are empty. It removes its own closure when diagnostics are disabled and bounds records with `DiagnosticsMaxEvents`. | **TRUE. No DLL change is required.** |
| Ordinary Lua type labels can safely gate access to that transport. | During the first live reproduction, the bridge installed, the addon activated, and the exact provider entered and returned in both phases with no errors or rejects, yet V1 emitted zero `COMBAT_*` records. V1 silently tested both `type(_T) == "table"` and `type(trace) == "function"`. | **FALSE live for the combined gate. The log cannot distinguish which label failed. V2 uses protected direct field access.** |
| The meter can be dormant during ordinary play. | `combatMeterBegin` checks for the trace closure before any health, shield, Overguard, damage-type, or status-type scan. The offline harness proves that removing the closure produces zero diagnostic events, zero health reads, zero damage-profile reads, and only the one Cold-stack read required by Ice Wave's gameplay edit. | **TRUE offline. Live F9 transition remains to be observed for this component.** |
| A before/after transaction can distinguish requested damage from synchronous combat-pool loss. | The meter records the stock raw amount, chosen multiplier, requested raw amount, numeric damage composition, and health/shield/Overguard before the native call. It then records the same pools and their positive deltas after the native call. The harness applies 7,000 through 500 Overguard, 1,000 shield, and 5,500 health and recovers an exact 7,000 effective-pool loss. | **TRUE offline for the measurement logic. Engine getter availability and timing remain live questions.** |
| The previous per-call restoration fully removed the user's occasional Ice Wave spikes. | The user repeated the test with the exact restoration artifact and still observed occasional approximately 195,000 damage. | **FALSE as a complete explanation. The restoration remains necessary because shared-packet reuse was independently proven.** |

## Evidence-backed fields

The component records:

- exact addon label, prototype, instruction, target userdata, packet userdata,
  and correlation number;
- target health and maximum health;
- damage-controller shield, maximum shield, and Overguard;
- stock raw packet amount, multiplier, requested raw packet amount, and all
  nonzero `GetDamagePct` components over the stock-observed index range 0-19;
- all nonzero status counts over numeric indices 0-19 through the exact native
  hash `Name__ff67e37d`;
- health, shield, and Overguard loss across the synchronous native call, plus
  their summed effective combat-pool loss;
- the raw base amount read after the Ice Wave addon restores the exact original
  `UpgradedValue` object.

The logger intentionally keeps damage and status identifiers numeric. Type 4
is proven as Cold on the Ice Wave path. Human names for every remaining index
are not established for this build, so the component does not invent them.

V2 also records the live `type(_T)` and `type(trace)` labels as evidence only.
Those labels never control bridge access. Its regression harness deliberately
reports `userdata` and `cfunction` while field access and all four correlated
records still succeed.

Stock `StatCompare` is the direct `GetDamagePct` contract evidence. It reads
`GetBaseAmount():GetModifiedValue()`, iterates indices 0 through 19, calls
`GetDamagePct(index)`, and multiplies positive fractions by the base amount:

`de-luau-toolchain/RESEARCH/ABILITY CARD UI/PIPELINE_AUDIT_2026-08-24/GENERATED/StatCompare.decompile.luau:13302-13328`

## Architecture

The canonical source component is:

`RENOVICE_SCRIPTING/DIAGNOSTICS/CombatTransactionMeterV2.luau`

It is embedded into a normal content-keyed target addon. There is no runtime
branch for Frost, no logging support addon, no timer, no polling, no repeated
setter, and no retained engine object after the synchronous `before`/native/
`after` transaction.

For a future ability, identify the exact native combat callsite and its target,
packet, and damage-controller arguments; embed the same component; call
`combatMeterBegin` immediately before that native call and
`combatMeterFinish` immediately afterward. Change the config's exact
`DiagnosticsTarget` to the new 16-hex body key. The analyzer is:

`RENOVICE_SCRIPTING/DIAGNOSTICS/AnalyzeCombatTransactionMeter.ps1`

It reads only records after an exact byte boundary, groups the four meter
records by correlation number, marks incomplete transactions, prints the key
damage fields, and can preserve the complete records as JSON.

## Current Ice Wave capture contract

- body key: `f62b70b45fc7fdf9`
- native method: `DamageDD`
- prototype: `7`
- zero-based instruction: `64`
- label: `FROST_ICE_WAVE_DAMAGE`

The capture config deliberately leaves `DiagnosticsMethod` and
`DiagnosticsAddon` empty. This is required for the generic Lua trace bridge;
the exact target filter still prevents unrelated target addons from emitting
meter records. After F9, test ordinary zero/one-stack hits and ten-stack hits
until the spike is reproduced. The live evidence must determine whether the
large number already exists in `stockRaw`, arises only in `requestedRaw`, or
appears only in the engine's resulting pool delta.

The first V1 attempt is retained as negative evidence under
`RENOVICE_DEPLOYMENTS/UNIVERSAL_COMBAT_METER_LIVE_BRIDGE_FIX_2026-09-13/evidence`.
Its analyzer result is zero records and zero transactions. The V2 pretest byte
boundary is 5,577,510; no numeric claim about the approximately two-million
hit is accepted until a complete V2 transaction captures one.
