# V79 automatic scripted battle capture: first live acceptance

The immutable session snapshot covers original log bytes 17477213..18056940
(579727 bytes), PID 22648, build V79. The installed DLL is
`C55253FF351B914958E6D8F4207F318A5134FFD1B6A7985FF85FFD3C067327F9`.

Hypothesis: the restricted-math repair permits automatic observer startup and
capture. **TRUE for this session.** The embedded observer loaded with `pcall=0`.
There were zero injector failures, callback failures, and automatic runtime
failures. All 64 automatic transactions had the nine canonical battle events.

Hypothesis: automatic capture requires a manually authored logger per ability.
**FALSE for the recorded sources.** It identified:

| Recorded source | Transactions | Scope |
| --- | ---: | --- |
| Avalanche.lua, body 8df5382b6ccae2b3 | 61 | Automatic; proto 11, instructions 163, 500, 629 |
| SpreadStatusOnCondition.lua, body 747cf21f29196286 | 3 | Automatic; proto 4, instruction 122 |
| Ice Wave explicit logger | 36 | Existing richer target provider; automatic duplicate suppressed |

Avalanche's 61 calls include 41 zero-amount status transactions and 20
3795-amount damage transactions. Zero raw amounts must not be discarded: a
zero-amount packet can still apply a status. One measured ten-Cold-stack target
had raw/installed damage 3795 and health 30056 -> 26261; the automatic observer
did not install a Cold multiplier. The separate Ice Wave records had two
zero-stack and 34 ten-stack hits, with zero multiplier or restoration failures.
Across both capture lanes, 57 transactions had positive visible pool loss and
43 had changed numeric status profiles. Getter availability remains explicit;
`IsDead` was unavailable in this session, not proven false.

## Analyzer rejection and correction

Hypothesis: the original analyzer correctly separates independent emitters.
**FALSE.** It grouped only by process/VM/correlation. The automatic observer and
explicit addon own independent counters; 36 explicit transactions collided
with automatic correlations. The old schema-1 report incorrectly returned 64
apparently complete groups from 900 records. It is preserved as
`live-v79-first-test.schema1-rejected.json` and must not be used for arithmetic.

Schema 2 separates producer scope by process, VM, build, label, automatic lane,
automatic sequence, and correlation. A fresh begin assigns a new transaction
instance, so F9 reuse of the same counter is separate. Missing or duplicate
canonical events cannot pass completeness. Explicit producers must use distinct
labels; an overlapping ambiguous begin leaves incomplete evidence rather than
silently certifying a mixed transaction. `-Quiet` permits automated JSON/CSV
generation without PowerShell formatting objects in a caller's output pipeline.

The corrected immutable-session analysis has **900 records, 100 transactions,
100 complete, zero incomplete**. Regression cases pass for interleaved
automatic/explicit counter collisions, reset counter reuse, target isolation,
source/label filters, unknown source, missing event, duplicate event, and quiet
script use. These are analyzer changes; the deployed gameplay DLL is unchanged.

Hypothesis: a discovered source can be isolated from the saved live capture.
**TRUE.** Exact Avalanche body plus filename returned exactly 61 complete
transactions; the status-spread body returned exactly three complete
transactions. Runtime config filtering after F9 remains **UNTESTED LIVE**.

## Coverage and remaining gates

V79 passes live automatic scripted DamageDD capture across two independent
sources, together with the richer existing explicit lane. This is a generic
call-boundary observer, not an engine-wide every-damage-source certification.
No Freeze source was automatically recorded here; absence alone does not
establish its route or prove it was cast. Fully native weapon/projectile damage
and area-only requests remain unresolved coverage paths. No hidden native
damage formula, universally available getter, or universal performance claim
is inferred. Diagnostic configuration remains enabled for the current tests.

Evidence is under
`RENOVICE_DEPLOYMENTS/AUTOMATIC_DAMAGE_RESTRICTED_MATH_FIX_V79_2026-09-15/evidence/`.
The reusable regression entry point is
`RENOVICE_TOOLCHAIN/diagnostics/verify_battle_log_analyzer.ps1`.
