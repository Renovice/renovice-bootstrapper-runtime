# Mallet performance follow-up — 2026-08-27

## Status

Superseded by
[`RUNTIME_PERFORMANCE_AUDIT_2026-08-28.md`](RUNTIME_PERFORMANCE_AUDIT_2026-08-28.md).
The later audit isolated current-process log evidence and confirmed three
implementation-level risks: production gameplay tracing, false region reloads,
and process-wide VM/UI inspection. No optimization was shipped in either pass.

## User observation

The scripts and native SCRIPTS controls work correctly. A mission restart is
occasionally needed before a changed script affects newly created gameplay
objects. The user also noticed a small intermittent lag while Mallet is active.

## Hypotheses

| Hypothesis | Current result | Reason |
|---|---|---|
| The SCRIPTS menu continuously scans or refreshes files | **FALSE BY IMPLEMENTATION** | Discovery occurs when building the submenu; reload is requested only by Confirm or F9. |
| The occasional hitch is caused by repeated script refresh | **NOT PROVEN** | No repeated reload log, callback count, or A/B frame-time evidence has been collected. |
| Mallet's damage callback or addon work is too frequent | **PLAUSIBLE, UNTESTED** | Mallet can receive many damage events, but invocation frequency and per-call cost have not been measured. |
| Native gameplay/VFX/enemy load is responsible | **PLAUSIBLE, UNTESTED** | There is no stock-versus-custom baseline under the same mission conditions. |

## Required future measurement

1. Capture the same mission, enemy count, Mallet placement, and graphics state.
2. Compare stock replacement/addons disabled versus each Mallet component
   enabled separately.
3. Record frame-time percentiles rather than visual impressions alone.
4. Count reload transactions; any transaction without Confirm/F9 is a defect.
5. Count Mallet damage callbacks and time the custom work per callback.
6. Separate one-time cast/activation cost from sustained damage-event cost.
7. Optimize only the component with a reproducible regression, then repeat the
   same A/B test.

## Boundary

Do not add polling, caching with unproven lifetime, dropped callbacks, or a
lower-frequency approximation merely to make the hitch disappear. Gameplay
and ability-card semantics must remain identical while performance is measured.
