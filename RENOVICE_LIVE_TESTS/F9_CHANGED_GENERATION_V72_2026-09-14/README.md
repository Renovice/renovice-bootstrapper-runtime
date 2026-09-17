# V72 F9 changed-generation live test

Date: 2026-09-14

This fixture tests a real byte-distinct target-addon generation without changing
the addon's behavior. It uses the enabled `EliteSanctuaryNoRank` addon because
that target was present at the V71 crash boundary.

The candidate adds only this ignored top-level return-table field:

```lua
generationProbe = "F9_CHANGED_GENERATION_V72"
```

The runtime reads the addon's `activate`, `cleanup`, and `hooks` contracts and
does not use this marker. The behavior harness proves that the activation,
cleanup, exact native callsite `25:10`, and `mission.maxSuitReq = false`
behavior are unchanged.

## Pinned artifacts

- installed/rollback generation: 471 bytes, SHA-256
  `19D8B54AF74F5D8ADF7250359FBDF2740503B72D9FBD269EB70D825C1BE1FF59`;
- behavior-identical candidate: 534 bytes, SHA-256
  `ECC382D46973FB54F0CDA4D45A23E9BC9F00FDD03D28EF770EB0FD21D8372DF5`.

Offline gates pass: behavior harness, deterministic DE compilation/reparse,
DE-container roundtrip 4/4, Semantic Plan 4/4, Semantic IR 4/4, raw marker and
contract retention, and strict API verification.

## Live sequence

1. Start the game with the deployed V72 DLL and unchanged 471-byte addon.
2. Press F9 three times, about two seconds apart, to prove unchanged refreshes.
3. Copy the 534-byte candidate over the live addon while the game is running.
4. Press F9 once and require a changed-generation commit without a crash.
5. Copy the exact 471-byte rollback over the live addon.
6. Press F9 once and require a second changed-generation commit without a crash.

A deferred boundary is allowed and keeps the request latched. Acceptance
requires a later commit in the same request sequence. A crash, rejected
generation, partial publication, missing reactivation, or lost hook is failure.
