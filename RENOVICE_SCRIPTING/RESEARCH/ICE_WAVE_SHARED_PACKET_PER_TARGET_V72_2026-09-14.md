# Ice Wave shared-packet per-target damage V72 — 2026-09-14

## Result

The user's multi-enemy test showed that a target with zero Cold stacks could
inherit a nearby ten-stack target's multiplier while other targets sometimes
received stock damage.

The V72 native trace proves the current stock transaction shape:

- 198 exact prototype-7 instruction-41 `SetBaseAmount` batches were observed;
- 76 of those batches reused the same `DamageData` object for more than one
  exact prototype-7 instruction-64 `DamageDD` target call;
- one shared packet reached as many as nine distinct target calls;
- the retained sample contains one setter for packet `0x1c218a7a0d0` followed
  by three target calls using that exact packet.

## Hypotheses

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| Stock creates and assigns one damage packet for every target. | **False.** | The same packet identity appears in several consecutive target-local `DamageDD` calls after one stock setter. |
| V71's one-shot stock capture matches the live transaction. | **False.** | V71 removed the capture before the second target, so later targets could not use the authoritative stock baseline. |
| The target argument at each exact `DamageDD` is the correct point to read Cold stacks. | **True at the observed boundary.** | Every shared-packet call has a distinct first argument while retaining the same second-argument packet. |
| A batch baseline plus per-call temporary amount can preserve stock behavior. | **True offline.** | Both adjacency orders, 10/0/6 stacks, packet reuse, mismatch isolation, restoration, cleanup reset, and diagnostics-off behavior pass. Live gameplay remains pending. |

## Fix

The addon now treats the exact stock setter as the start of a shared packet
batch. It retains that packet's game-owned `UpgradedValue` as the baseline.
For every matching exact `DamageDD` call it:

1. reads Cold stacks from that call's target;
2. clamps the count to the game's ten-stack limit;
3. computes `stockRaw * max(1, coldStacks)`;
4. temporarily installs that value on the shared packet;
5. lets the stock `DamageDD` run;
6. restores the exact stock `UpgradedValue` immediately afterward.

The next exact stock setter replaces the current batch. A mismatched packet is
rejected without consuming the valid batch. Cleanup and activation clear all
state. There is no polling, per-frame enforcement, replacement body, damage
replay, target list scan, or cross-target aggregate.

## Verification boundary

- behavior harness: PASS;
- shared 10/0/6 packet: PASS;
- reverse 0/10 adjacency: PASS;
- per-target restore to the exact stock wrapper: PASS;
- mismatch isolation and later matching target: PASS;
- cleanup/activation stale-state rejection: PASS;
- diagnostics-off dormant meter: PASS;
- deterministic compile: PASS;
- artifact: 6,204 bytes, SHA-256
  `ECF1A98F720FEFF4F488C728F4A3CDCD1D6212B776CDAC51C895B139EAAFC065`;
- exact DE-container roundtrip: 28/28;
- Semantic Plan: 28/28;
- Semantic IR: 28/28;
- strict API: 22 calls, zero violations and zero unknown calls.

These checks prove the artifact and the corrected transaction model. A live
mixed-stack multi-target hit is still required to prove gameplay acceptance.

## Live correction

The live mixed-stack test **rejected V72**. The packet and target-local stack
model was correct, but the claimed restore was not. `GetBaseAmount()` returned
an engine-owned `UpgradedValue` proxy whose represented number changed after
`SetBaseAmount`; retaining that proxy did not retain the stock number.

One exact trace sequence captured stock `1771`, installed `5313` for a
three-stack target, and then reported `restoredRaw=5313`. The following
zero-stack target requested `1771` but entered with `observedRaw=5313` and took
the leaked amount. Therefore V72's offline “exact wrapper restore” result was a
false positive caused by an inaccurate test double. V73 replaces it with a
live-alias test double, an immutable numeric baseline, an explicit install for
the 1x case, and a newly constructed stock wrapper on every restore. See
`ICE_WAVE_NUMERIC_BASELINE_RESTORE_V73_2026-09-14.md`.
