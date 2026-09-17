# F9 root reactivation and Ice Wave packet baseline, V68

Date: 2026-09-13

## Scope

This record separates the reproduced F9 crash from the Frost Ice Wave damage
spike. Both involved state reused across a transaction boundary, but they have
different owners and corrections. V68 changes the generic target-addon
lifecycle path and one standalone Ice Wave addon. It does not change Pluto,
the server, stock Frost bytecode, or any replacement body.

## F9 hypotheses and results

| Hypothesis | Result | Evidence |
|---|---|---|
| F9 input detection failed. | **FALSE** | The final live records contain `F9 QUEUED` followed by `F9 DRAIN entered same-VM script boundary`. |
| The Ice Wave addon crashed inside its damage hook. | **FALSE for this crash** | F9 stopped at `9dfe563d26eb6527.EliteSanctuaryNoRank.target.addon.lua_B`; the Ice Wave target generation was never reached during that transaction. |
| The failing ESO loader returned a valid lifecycle table. | **FALSE** | The exact record is `fault_stage=0 fault_code=0 closure_tag=8 pcall=-1 result_tag=8 registry_restored=1`. The execution did not store a new lifecycle root. |
| The old failure path nevertheless tried to release a lifecycle root. | **TRUE by source inspection** | `run_chunk` previously entered lifecycle release whenever a lifecycle key was requested, independently of `RunResult.lifecycle_stored`. |
| The exact GPF instruction was captured inside the release operation. | **UNPROVEN** | The log ends immediately after the failed loader and EE records the GPF, but no instruction-level crash dump pins the faulting native instruction. The invalid cleanup operation is removed without overstating that boundary. |
| A byte-identical target addon must rerun its top-level loader when only `_T` changed. | **FALSE for the current V26+ lifecycle architecture** | Its lifecycle table remains rooted in the DE VM registry. Cleanup and activation through that root unregister and register behavior against the current shared table without creating a second root. |

## Generic F9 correction

Target generations now have three explicit actions:

1. Reuse when filename, bytes, registry ownership, and shared-table identity all
   match.
2. Reactivate existing roots when filename and bytes match but `_T` identity
   changed. Cleanup runs for every root, then activation runs for every root.
   Cleanup or activation rejection restores the prior active generation;
   rollback failure disables the injection subsystem.
3. Replace roots when membership or bytes changed. This retains the existing
   staged load, cleanup, activation, release, and rollback transaction.

A failed chunk now releases a lifecycle root only if that execution reports
`lifecycle_stored=true`. Otherwise it records
`addon lifecycle release SKIP ... reason=no-stored-root`. This rule applies
generically; there is no ESO-specific branch.

Repeated `lua.call.after.skip` diagnostics retain occurrences 1 through 8 and
then every 256th recurrence. Aggregated callback statistics remain complete.
This stops one yielded-call skip family from exhausting the trace budget before
combat transaction records are written.

## Ice Wave hypotheses and results

| Hypothesis | Result | Evidence |
|---|---|---|
| Extreme damage is independent of target count. | **FALSE by live observation** | The user reports correct scaling for isolated targets and occasional extreme values when a cast reaches multiple targets. |
| Stock Ice Wave allocates a separate `DamageData` for each target. | **FALSE** | The current stock Frost body creates `Engine.DamageData()` before the target loop and passes the same local object to every target's `DamageDD` call. |
| Re-reading the observed amount before every target is a sound baseline. | **FALSE** | Any mutation visible between target calls can become a later target's input. Multiplying that observed value again allows cross-target compounding. |
| The observed huge value's exact live writer is already identified. | **UNPROVEN** | Combat Meter V2 never loaded because F9 crashed before the Ice Wave generation refresh. V68 removes the compounding condition and V3 records both observed and canonical values so the next run can identify any remaining writer. |
| A canonical per-packet baseline prevents target-to-target multiplication. | **TRUE offline** | The harness injects an observed second-target value of `70000`; the addon still installs `700 × 6 = 4200`, then restores the exact original object and numeric value `700`. |

## Ice Wave correction

At exact body key `f62b70b45fc7fdf9`, prototype 7, instruction 64:

- the first call for a `DamageData` object captures its exact stock
  `UpgradedValue` and numeric modified value;
- every target in that packet calculates `canonical stock damage × max(1,
  pre-hit Cold stack count)`;
- a depth-one call restores the exact canonical `UpgradedValue` object;
- a nested call restores its immediate caller's object;
- cleanup clears all packet and transaction state;
- no per-frame loop, poller, replacement, health setter, or target-specific C++
  behavior is used.

Combat Meter V3 logs packet pointer, ordinal, target pointer, observed raw input,
canonical stock raw input, Cold stacks, pending depth, requested and installed
damage, restored damage, health, shield, Overguard, damage fractions, and status
counts. The meter is dormant before any expensive reads when the centralized
trace bridge is absent.

## Verification

- Private x64 runtime: **PASS**, 4,596,224 bytes, zero warnings, zero errors,
  SHA-256 `EDA79C8B2DFA87BDD326C18DBAB720C6E21ACDFF5A90B5A87F7CB4A3CEF238FA`.
- Generic injection verifier: **PASS**, including root reactivation rollback,
  missing-root release gating, and sparse recurrence sampling.
- Ice Wave behavior harness: **PASS**, including one-target, shared-packet,
  deliberate observed-value contamination, exact restore, wrong-callsite
  rejection, and dormant diagnostics.
- Addon compile/reparse: **PASS**, 5,391 bytes, 25 prototypes, no hashed globals
  or fields.
- DE-container self-roundtrip: **PASS 25/25**.
- Semantic Plan: **PASS 25/25**.
- Semantic IR: **PASS 25/25**.
- Strict API check: **PASS**, 19 contract-verified calls, 4 catalog matches,
  zero violations, zero unknown calls.
- Deployment: **PASS** while the game process was stopped. Exactly
  `WTSAPI32.dll` and the Ice Wave addon changed; the other 30 CustomScripts
  files remained byte-identical.
- F9 and gameplay: **PENDING LIVE ACCEPTANCE** after a full restart because the
  DLL changed.

## Hash-pinned package

`RENOVICE_DEPLOYMENTS/F9_ROOT_REACTIVATION_AND_ICE_WAVE_PACKET_BASELINE_V68_2026-09-13`

The package contains exact V67 runtime and Combat Meter V2 addon rollbacks,
source, bytecode, Combat Meter V3, analyzer, fixture, pre/post deployment
inventories, and `verify_package.ps1`.

## Superseded Ice Wave conclusion after live V68 evidence

The V68 F9 correction remains accepted: the user completed repeated F9 reloads
without a crash, and generations 2 through 7 each logged a complete commit with
`managed_generation=reused`, zero one-shot failures, and zero pending targets.

The V68 Ice Wave packet model is rejected. Exact raw decompilation of the stock
prototype 7 helper shows `c8v6 = nil` inside the target loop, followed by
`Engine.DamageData()`, `SetBaseAmount(c8v2)`, and the target's `DamageDD(c8v6)`.
Stock therefore creates a new logical damage packet for every target; `c8v2`,
the helper's third argument, is the authoritative common damage input.

The live native trace also records two consecutive targets at tick 17870828
with different target addresses but the same `DamageData` address
`0x1629b1dab90`. That is allocator address reuse, not proof that the two targets
share one logical object. V68 compared Lua/native packet identity and could
therefore retain a prior target's canonical value when an address was reused.
Its shared-packet behavior harness tested a false stock model. V69 removes all
packet-address grouping and captures the stock helper argument instead.
