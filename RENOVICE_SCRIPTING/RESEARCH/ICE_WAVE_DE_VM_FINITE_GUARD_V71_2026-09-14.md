# Ice Wave DE-VM finite guard V71 — 2026-09-14

## Result

The user's V70 test showed inconsistent stock 177 and apparent 1,770 hits.
The live diagnostic log proves V70 did not complete any addon damage
transaction:

- exact `SetBaseAmount` callback failures: 150
- exact `SetBaseAmount` provider errors: 150
- `ICE_WAVE_BASE_CAPTURE`: 0
- `COMBAT_BEGIN_STATE`: 0
- error: `attempt to compare number < nil`

The failure was `validPositiveNumber` comparing the stock number against
`math.huge`. Standard Luau exposes that field; the game's DE VM did not. Every
setter callback failed before recording the stock amount, and the runtime
restored the unmodified native arguments. The following `DamageDD` therefore
ran at stock damage.

## Hypotheses

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| V70 sometimes captured the wrong target. | **False.** | There were zero successful capture events. |
| Some ten-stack reads returned zero. | **Unreached.** | No combat transaction reached the Cold-stack getter. |
| The stock setter and damage native hooks bound. | **True.** | Both exact prototype 7 instruction 41 and instruction 64 provider callbacks entered. |
| The finite-value guard is incompatible with the DE VM. | **True.** | All 150 setter callbacks failed at `number < nil`; `math.huge` is the only right-hand operand on that comparison path. |

## Fix

V71 replaces the unavailable library field with a compile-time finite ceiling:

`MAX_VALID_RAW_DAMAGE = 1e30`

The guard remains fail-closed for non-numbers, NaN, zero/negative values, and
absurd values. No transaction, target association, status lookup, native
callsite, runtime DLL, or other script changed.

The offline harness now shadows the standard `math` library with a table that
retains only the required `min` helper and deliberately omits `huge`. This
reproduces the relevant DE environment and prevents the original failure from
passing offline again.

## Verification and deployment

- DE-like missing-`math.huge` harness: PASS
- adjacent 10/0/6-stack isolation with deliberate object reuse: PASS
- mismatch and stale-capture rejection: PASS
- deterministic authored compile: PASS
- artifact size: 6,171 bytes
- artifact SHA-256:
  `886142C10441E81139DCE55F12D4A48083CA5828DA712C7B08D5DDC1B16A1791`
- exact self-roundtrip: 28/28 PASS
- Semantic Plan: 28/28 PASS
- Semantic IR: 28/28 PASS
- strict API: 22 calls, zero violations, zero unknown calls

Deployment at `2026-09-14T02:24:07.2503276+02:00` changed only the live Ice
Wave addon while PID 17332 remained running. The V69 runtime hash, 26 other
non-log CustomScripts files, configuration, and ScriptStates were preserved.
Because both native methods were already bound, one F9 transaction is required
to replace the changed addon generation. Live damage acceptance remains
pending that reload and test.
