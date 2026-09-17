# V79 automatic battle observer restricted-math repair

## V78 live evidence

The preserved session covers log bytes 16348164..16556337, PID 26332.
The embedded observer loaded with `pcall=0`; zero `Inject FAIL` records occurred.
The automatic `before` callback failed 91 times with `arithmetic (unm) on nil`.
There were zero automatic battle transactions. Ice Wave's existing explicit
logger produced 405 records, 45 complete transactions, and zero incomplete
transactions. Its 14 zero-stack and 31 ten-stack records all passed
`installedRaw = stockRaw * max(1, coldStacks)` and immediate stock restoration.
These explicit records do not certify automatic multi-source capture.

Hypothesis: V78's managed lifecycle repair failed. **FALSE.** Observer startup
passed. Hypothesis: automatic multi-source capture worked. **FALSE.** Its
callback errors prevented every automatic transaction in this session.

## Reproduction and correction

The observer's only unary-minus expression is `-math.huge` in its raw-value
finite-number guard. Giving the observer module an empty math table in the
deterministic harness reproduces exactly `arithmetic (unm) on nil` at source
line 301, before any battle transaction. This establishes a reproducible
restricted-environment failure; the upstream Luau harness had supplied
`math.huge` and previously missed it. A traceback's borrowed game-script label
does not establish that named script as the damage source.

V79 reads either a numeric amount or the protected UpgradedValue getter result,
then validates the number with `result ~= result or result - result ~= 0`.
Finite values subtract from themselves to zero. NaN and infinities are recorded
as unavailable raw values, while the target observation remains possible.
This does not depend on an optional math-table export or change game damage.

The harness now removes the observer's math exports and verifies both numeric
and wrapped finite values, positive infinity, negative infinity, NaN, lifecycle,
filtering, cleanup, and unchanged target pools. The old observer fails the new
restricted-math test; the corrected observer passes it.

- DE compile/reparse: PASS, 7527 bytes, 34 prototypes.
- DE self-roundtrip: PASS, 34/34 full bodies.
- Semantic IR: PASS, 34/34 prototypes.
- Observer SHA-256: `431D2FDE4A5E40460B58A3731130171BF2D58B317E925A0CB5D2B2A9B6260CB0`.
- Private x64 build: PASS, zero warnings/errors, 4644352 bytes.
- DLL SHA-256: `C55253FF351B914958E6D8F4207F318A5134FFD1B6A7985FF85FFD3C067327F9`.
- Package: PASS, file hashes, x64 PE, config/injection, observer and analyzer checks. Deployment: PASS, installed runtime/config/addon hashes verified. Pre-restart live log baseline: 17477213 bytes.
- Automatic multi-source capture: LIVE PASS, 64 automatic transactions across two sources; 36 explicit Ice Wave transactions, 100/100 complete total, zero runtime failures. Saved-log source isolation: PASS. Runtime F9 source filtering: UNTESTED LIVE. See AUTOMATIC_DAMAGE_LIVE_ACCEPTANCE_V79_2026-09-15.md.

Coverage remains any loaded scripted per-target DamageDD boundary. Fully native
damage and area-only requests are separate unresolved coverage paths. The
gameplay addons, replacement scripts, and packet setters are unchanged.
