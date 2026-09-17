# Ice Wave immutable numeric baseline restore V73 — 2026-09-14

## Result

V72 still allowed adjacent enemies to share the previous target's damage.
The exact cause was an aliased engine-owned `UpgradedValue`, not a wrong target
lookup and not deferred damage evaluation.

In live batch 23, packet `0x1c1cbe399d0` had stock raw damage `1771`:

- target 1 had three Cold stacks and correctly installed `5313`;
- V72 reported `restoredRaw=5313`, proving its saved wrapper no longer
  represented `1771`;
- target 2 had zero Cold stacks and requested `1771`, but began with
  `observedRaw=5313`;
- because V72 skipped `SetBaseAmount` for a 1x target, target 2 took the leaked
  three-stack amount.

The native call changed target health before its after hook returned. That
rejects the earlier possibility that the engine consumes the packet later.

## Hypotheses

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| The exact target argument supplies the wrong enemy's Cold stacks. | **False.** | V72 records distinct target objects and the expected target-local stack counts, including zero. |
| `DamageDD` defers packet evaluation until after the addon's after hook. | **False.** | Health loss is already visible in `COMBAT_END_STATE` for the same synchronous call. |
| `GetBaseAmount()` returns a stable value snapshot. | **False.** | A saved stock wrapper reads the installed multiplied value after `SetBaseAmount`. |
| Saving numeric `stockRaw`, explicitly installing every target amount, and rebuilding the stock wrapper on restore isolates targets. | **True offline.** | The live-alias harness makes V72 fail and V73 pass shared `10/0/6` and reverse `0/10` sequences. Live gameplay remains a separate gate. |

## Fix

The authoritative stock setter remains prototype 7 instruction 41. The exact
per-target damage call remains prototype 7 instruction 64. V73:

1. captures the immutable numeric stock amount once per stock packet batch;
2. reads Cold stacks only from the current `DamageDD` target;
3. installs an explicit amount for every target, including the 1x case;
4. lets the one stock native call apply damage;
5. restores `Engine.UpgradedValue(stockRaw)` immediately after that call;
6. emits `ICE_WAVE_RESTORE_MISMATCH` if the numeric restore does not hold.

The addon still uses stock damage construction, targeting, proc application,
armor handling, and native `DamageDD`. It adds no alternate damage system.

## Verification boundary

- unchanged V72 under live-alias harness: **FAIL**, as required by the
  regression fixture;
- V73 live-alias behavior harness: **PASS**;
- shared `10/0/6` and reverse `0/10`: **PASS**;
- explicit 1x install and numeric per-call restore: **PASS**;
- deterministic compile: **PASS**;
- artifact: 6,472 bytes, SHA-256
  `8000A06CD5E842721316D8669EA9F49C244BC32982A2A70762F32321FC40E7A2`;
- exact DE-container roundtrip: **28/28**;
- Semantic Plan: **28/28**;
- Semantic IR: **28/28**;
- strict API: **26 calls, zero violations, zero unknown calls**.

Deployment and startup completed with the V72 runtime unchanged. The user then
reported that mixed-stack Ice Wave damage worked without the shared-target
leak: **live gameplay PASS**. The same session did not emit addon battle-log
records because V72's callback transport supplied no usable host trace closure,
so this is user-observed gameplay acceptance rather than trace-backed numeric
proof. V74 addresses that diagnostic transport separately without changing the
V73 damage algorithm.
