# Ice Wave stock-setter transaction V70 — 2026-09-14

## Result

V69 was rejected by live evidence. Its native `DamageDD` hook ran, but the
`luaCalls[7].before` callback that owned the authoritative stock amount ran zero
times. The addon therefore had no active batch and correctly left every hit at
stock damage.

V70 removes the Lua-entry dependency and captures the stock amount at the
game's exact assignment instead:

- body key: `f62b70b45fc7fdf9`
- helper prototype: `7`
- stock amount assignment: instruction `41`, `SetBaseAmount`
- target damage call: instruction `64`, `DamageDD`

The runtime DLL is unchanged V69. V70 changes only the Ice Wave target addon.

## Hypotheses and evidence

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| V69 failed because the damage multiplier or Cold-stack getter was wrong. | **False.** | Post-boundary live log records exact `DamageDD` provider entry/return with no provider errors, but no Ice Wave or combat event. |
| V69's authoritative Lua helper callback ran. | **False.** | After log byte 7,113,373: `luaCalls.7.before=0`, `ICE_WAVE_BATCH_BEGIN=0`, `COMBAT_BEGIN_STATE=0`; `trace bridge PASS=1`. |
| The stock amount has an exact native assignment inside each target iteration. | **True.** | Exact callsite inventory identifies prototype 7 instruction 41 `SetBaseAmount`; raw stock source calls `c8v6:SetBaseAmount(c8v2)` before instruction 64 `c8v11:DamageDD(c8v6)`. |
| Capturing instruction 41 and consuming it at instruction 64 can avoid target inheritance. | **True offline.** | The V70 harness reuses the same logical damage object for adjacent 10-stack, zero-stack, and six-stack targets and obtains 7,000, 700, and 4,200 from stock 700. |
| A bad association can poison a later target. | **False by V70 design and harness.** | The newest capture is always consumed once. Exact `DamageData` mismatch rejects it; a following uncaptured call remains stock. |
| V70 works in the live game. | **Pending.** | Fresh-process method binding and multi-target gameplay have not yet been observed. |

## Transaction

1. The exact stock instruction 41 `SetBaseAmount` callback captures argument 2
   and its exact `DamageData` receiver.
2. Stock `SetBaseAmount` executes normally.
3. At exact instruction 64 `DamageDD`, the addon consumes the newest capture.
4. It requires the captured and received `DamageData` objects to compare equal.
5. It reads Cold stacks from only the current target and clamps them to ten.
6. It temporarily installs `captured stock raw × max(1, Cold stacks)`.
7. Stock `DamageDD` executes once.
8. The exact stock base object is restored in the after callback.

There is no pointer grouping, per-frame work, polling, Lua-entry hook, or
cross-target canonical packet. Diagnostic reads occur only when the host trace
closure is present.

## Offline verification

- behavior harness: PASS
- adjacent-target isolation: PASS
- deliberate object/address reuse: PASS
- mismatch consumption and stale-state rejection: PASS
- diagnostics-off gameplay path: PASS
- deterministic DE compile: PASS
- artifact: 6,181 bytes
- artifact SHA-256: `8B602693D395B1E6EAB782D6EE5D0FF8667B156174CCCD7FABDB57775232776E`
- exact DE self-roundtrip: 28/28 prototypes
- raw decompiled-source first-pass identity with the authored artifact: **FAIL**
  (`000912...` versus authored `8B602...`); this is recorded as a distinct
  compiler canonicalization result, not described as byte identity
- raw compiler-closed stability after the first canonicalizing pass: **PASS**;
  pass 1 and pass 2 both SHA-256
  `0009120655437AC0B9BFBA2A4F067E1ED3B8B1F07AC48DC4AEFE14F629E257F2`
- Semantic Plan: 28/28
- Semantic IR: 28/28
- API audit: 22 calls, zero violations, zero unknown calls, strict mode

## Deployment

Deployment at `2026-09-14T02:12:25.4571321+02:00` stopped exact game PID
29076 and changed only:

`OpenWF/CustomScripts/Inject/f62b70b45fc7fdf9.IceWaveColdStackDamage.target.addon.lua_B`

Preserved:

- V69 `WTSAPI32.dll` SHA-256
  `53370FED9AA6843BB01CF80ECBEB57266CF71AFF39D6344383C1F39B99DD7451`
- 26 non-log CustomScripts files
- `renovice.cfg` SHA-256
  `6984FC78D14FE6FB4E8149C2E31484E589C9A75996C27CEBFA6606CB9013C42A`
- `ScriptStates.json` SHA-256
  `74FED6FF3933A0D61BD2B5CAED450E2DF6E2FEBB1F245A8F736C7885568FBA0B`

The package contains the V69 addon as the rollback artifact. Live acceptance
requires a restart, startup confirmation for both `SetBaseAmount` and
`DamageDD`, and repeated adjacent-target tests in both stack orders.
