# Live script toggle: first-transaction starvation — 2026-09-03
## Correct live target

The accepted V31 test used:

`C:/Users/Bartek/OneDrive/Dokumenter/Warframe`

The separate Steam installation is not evidence for this run.

## V31 evidence

One process performed this sequence:

1. enabling the Metronome replacement committed generation 2;
2. disabling the same replacement persisted `false` and queued a reload;
3. no later `F9 DRAIN` or `F9 COMMITTED` occurred;
4. disabling the Mallet target add-on also persisted `false`, but inherited the
   already-pending reload and likewise never reached cleanup.

The exact TopMenu VM continued to execute after the failed disable. This rules
out a closed menu, missing VM capture, or failed policy write as the immediate
cause.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| OFF was not saved. | Both settings callbacks logged `commit PASS`; `ScriptStates.json` contained `false`. | **False live.** |
| The inverse cleanup/restoration path ran and failed. | The failed transaction never logged `F9 DRAIN`; cleanup was never attempted. | **False at this boundary.** |
| V31 could repair the failure with a second pass inside the same accepted runtime tick. | No V31 `FOLLOW-UP` record appeared. The request was queued after the last accepted callback rather than during the callback body that V31 retried. | **False live.** |
| The problem is transaction order rather than the boolean OFF value. | The first transaction in the process committed; later ones starved. | **Supported by this run; reverse-order live proof still required.** |
| A VM/scheduler safety guard remains active after the first transaction. | Later exact-VM returns do not enter the scheduler, but V31 did not record which guard rejected them. | **Plausible; not yet proven.** |

## V32 correction and diagnostic boundary

V32 removes the disproven same-tick follow-up. VM execution depth and the
runtime callback-running latch are now scope-owned, so a normal C++ exception
unwind cannot leave them set for the rest of the process. Every pending reload
rejected at an outer VM return now records the exact rejecting invariant:

- captured VM and boundary VM;
- captured thread and boundary thread;
- VM nesting depth;
- RENOVICE execution depth;
- scheduler callback-running state;
- current and base `CallInfo` pointers.

The drain itself separately reports if the transaction guard, VM, context, or
thread rejects work. Diagnostics are rate-limited per reload request.

V32 is not called live-proven until ON -> OFF -> ON succeeds in one process.
If it still defers, the new single-line reason is sufficient to replace the
remaining bad boundary without guessing.
