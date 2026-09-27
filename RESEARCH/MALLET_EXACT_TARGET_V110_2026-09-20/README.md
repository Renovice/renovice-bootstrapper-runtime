# V110 Mallet exact-target recovery

Date: 2026-09-20

## Scope

Restore the existing universal target-addon damage callback used by Mallet,
remove ordinary-play diagnostic overhead through the existing master switch,
and preserve every loader lane and script byte.

## Hypotheses and results

### H1: the Mallet addon did not load

**FALSE.** V109 logged `Inject PASS` for
`08faf07b504d058f.MalletOverguardAndCard.target.addon.lua_B` and
`TARGET ADDON PASS key=8faf07b504d058f addons=1`.

### H2: stock Mallet stopped producing damage

**FALSE.** The retained live log is 40,702,494 bytes and contains 1,528 records
with `SourceBody=0x8faf07b504d058f`. Stock Mallet and its radial damage path were
active.

### H3: the Overguard math or grant calls were wrong

**FALSE as the immediate failure.** V109 recorded zero `damage.callback.enter`
and zero `afterDamage` dispatches. The addon never reached its existing 1%
Strength-scaled conversion, 5% ceiling, 15,000 Strength-scaled cap, or vanilla
Overguard calls.

### H4: native target association failed before callback installation

**TRUE.** `SetSourceObject.detour-entry` occurred, followed by
`SetSourceObject.target.missing`. There were zero target matches and zero
`SetSourceObject.attachDamageCallback` events. Strict closure ownership rejected
the live call because its closure environment differed from the published
module frame, while the current-generation prototype identity remained exact.

### H5: diagnostics caused the ability stutter

**TRUE.** `Diagnostics=true` enabled engine-damage, caster, buff, and HUD
observers and produced a 40.7 MB session log. The existing verifier proves that
off mode performs no observer work. V110 uses `Diagnostics=false`; Logging and
Verbose remain available for low-volume lifecycle evidence.

## Repair

`target_key_for_active_call_stack` retains its strict closure/environment route.
Only when that route has no match and no ambiguity does it consult the generic
native-call bus's exact prototype plus `CallInfo.savedpc` result. The fallback
must identify one current-generation target and an exact instruction. Ambiguous
or incomplete evidence returns zero.

This restores the authoritative stock sequence:

```text
Mallet target prototype calls SetSourceObject(packet, ability)
  -> exact target identity is resolved
  -> additive SetDamageCallback is installed on that packet
  -> stock RadialDamage resolves each target
  -> positive engine result synchronously dispatches afterDamage
  -> addon grants damage-derived Overguard through vanilla calls
```

The runtime contains no Mallet body key, no periodic setter, no damage queue,
no radial-return batch, and no replacement of stock Mallet control flow.

## Verification

- focused injection core verifier: PASS;
- exact-stack selection tests: strict identity wins, exact fallback admits,
  non-exact fallback rejects, ambiguity rejects;
- unified diagnostics verifier: PASS, off means observers unregistered;
- full private x64 build: PASS, zero warnings and zero errors;
- candidate: 4,857,856 bytes,
  `3319C7372C9756B599F624BA3794B39FEC79AD3FB2A1BDE409E49E2C7365B85C`;
- exact V109 rollback:
  `45B8BDA11BEF71F2873A1DE1E90837A6AAFE7FE4C157ED16CBEE4D6A719F1C69`;
- package and independent post-install audits: PASS;
- installed change set: `WTSAPI32.dll` only;
- preserved CustomScripts: 41/41, aggregate SHA-256
  `221BCE4F0B22B0EB77705F407555E88312F3DA1C70184EF169D7069972E1A1A0`.

## Live acceptance boundary

Offline proof establishes build, identity, fail-closed routing, packaging, and
installation. It does not prove gameplay. A fresh process must confirm Mallet
card rows, threat rewrite, positive Overguard on damage, immediate timing, and
normal ability performance. Ice Wave, Scripts UI, ordinary Inject,
Replacement, F9, F10, search, Arsenal, and mission transitions remain regression
checks rather than inferred successes.
