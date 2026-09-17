# V48 gameplay timing closeout

Date: 2026-09-07

Feature: `LI-013` universal target-addon hook bus

Target body key: `08faf07b504d058f`

## Accepted intent

The Mallet addon converts every positive engine-reported Mallet damage result
into caster Overguard by a configured percentage:

```text
grant = reported Mallet damage * damageToOverguardFraction(caster)
```

The reported damage may include overkill. This matches the intended Warframe
ability-style damage calculation. It is not clamped to the enemy's remaining
health, shields, or theoretical effective health. Stock Mallet decides which
targets inside its damage circle receive damage; the addon must not perform a
second area scan.

The base fraction is 1%, Strength modifies the same function used by gameplay
and the modded ability-card row, the conversion fraction caps at 5%, and total
Overguard caps at 15,000.

## Hypotheses and results

### H1: V48 loads the standalone addon without a shim

**TRUE live.** PID 26948 published the complete 22-prototype target graph,
logged `TARGET ADDON PASS`, and installed one implementation for each of
`SetDamageCallback`, `SetSourceObject`, `RadialDamage`, and `PushFloatArg`.
No base-script shim or support Lua script was installed. The replacement path
was unchanged.

### H2: V48 grants Overguard in gameplay

**TRUE by user observation.** Mallet damage produced real caster Overguard.
This proves a gameplay callback reached the addon effect; it does not validate
the timing or threat transformation.

### H3: the apparent delay is only the HUD notification

**FALSE by user observation.** The frame did not have the Overguard initially.
Its actual Overguard state increased later, for as long as roughly 1.5 seconds
after the enemy died. The UI was displaying a real late state change.

### H4: one synchronous `RadialDamage` lifetime is the correct effect boundary

**FALSE live for Mallet.** V48 accumulates callback values while a stock
`RadialDamage` call is active, dispatches their sum when the native call
returns, and directly dispatches callbacks outside an active batch. The live
result did not reproduce the immediate timing of the old pre-universal working
script. The current evidence does not yet distinguish later Mallet radial calls
from callbacks deferred outside their originating native call, so neither
mechanism is claimed without a correlated trace.

### H5: calculated damage should be replaced with target-pool loss

**FALSE by accepted semantics.** Overkill remains valid input. The timing bug
must be fixed without changing the damage value or adding an effective-health
calculation.

### H6: the universal architecture requires support scripts per ability

**FALSE for implemented hook contracts.** The host loads one content-keyed
`.target.addon.lua_B`, owns lifecycle and native attachment, and exposes generic
callbacks. Mallet-specific formula and callsite selection live in the addon.
No Mallet-specific native branch is present. A future behavior that lacks an
event contract may require one new generic host hook, implemented once for all
addons; that is hook-catalog growth, not an ability support script.

## Next-session implementation boundary

Do not change the calculated damage semantics, card percentage, Overguard cap,
standalone filename contract, replacement loader, Scripts menu, Pluto runtime,
or instruction-addressed threat hook.

Replace only the rejected effect-timing policy:

```text
exact target module associates the Mallet source
  -> positive resolved damage callback arrives
  -> afterDamage(sourceAbility, reportedDamage) runs immediately
  -> addon applies Overguard immediately
```

`RadialDamage` may remain as diagnostic context only if it helps correlate a
callback with a pulse. It must not hold or delay the effect. Preserve bounded
sampling and aggregate performance counters; do not restore per-hit disk-log
spam.

Before editing, if the delayed behavior remains reproducible under V48, capture
one cast and classify each late grant against `RadialDamage.batch-dispatch`,
direct dispatch, and callback timestamps. This separates a later radial pulse
from an out-of-batch deferred result.

## Universal API status

The host architecture currently supports standalone target addons for:

- activation and cleanup;
- native ability-card augmentation;
- resolved damage callbacks;
- instruction-addressed float-argument transformation.

An addon using those events needs one correctly named compiled file in
`OpenWF/CustomScripts/Inject`. It does not need a shim, a second Lua support
file, or an ability-specific bootstrapper edit. This does not claim that every
possible game event is already exposed.

## End state

- Game process PID 26948: exited.
- Live DLL SHA-256:
  `041D975199D6C71B47309326C972D23D22D29A62C603213BA994D492BD836BE2`.
- Live addon SHA-256:
  `CABFD1489FE5BF5965BD3DDF174D51C667506960C4C6787595E8A1D60146717B`.
- V48 startup: PASS.
- V48 Overguard reachability: PASS.
- V48 immediate timing: FAIL.
- Threat 5 gameplay effect: unverified.
- Next implementation: intentionally deferred to the next work session.
