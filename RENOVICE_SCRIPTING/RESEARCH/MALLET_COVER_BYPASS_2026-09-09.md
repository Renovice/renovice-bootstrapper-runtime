# Mallet cover behavior and exact addon hook

> **2026-09-11 correction:** the live hypothesis below was falsified. Although
> the addon loaded, accumulated target traces contained zero Mallet
> `RadialDamage` callback events and enemies behind cover remained unaffected.
> The replacement package now edits the two authoritative stock boolean loads
> directly and restores the live-accepted V57 target addon. See
> `RENOVICE_DEPLOYMENTS/MISSION_TIMER_AND_MALLET_LOS_RECOVERY_2026-09-11`.

## Question

Does stock Octavia Mallet perform a line-of-sight or cover check, and can an
addon disable it without replacing the ability or introducing a second damage
system?

## Evidence

The readable stock BardMusic body at the damage-pulse construction assigns
`true` to `RadialDamageData.checkForCover`, assigns `true` to
`RadialDamageData.staticCoverOnly`, assigns zero falloff, and then invokes
`gRegion:RadialDamage(packet)`. This establishes that the packet sent by Mallet
explicitly requests the engine's cover behavior.

The current instruction-addressed callsite map contains exactly one
`RadialDamage` call for body key `08faf07b504d058f`: prototype 16, instruction
576, `Region` receiver, one `RadialDamageData` argument. The record is
`CONFIRMED` with `WF-STOCK-BARD-BOXLOOP` and
`WF-LIVE-MALLET-2026-08-23` evidence.

The V61 generic native-call contract passes the receiver at `arguments[1]` and
the explicit packet at `arguments[2]` to a `before` hook. Mutating fields on
that packet preserves its identity and leaves the stock native damage call as
the authoritative producer.

## Conclusion

**TRUE offline:** Mallet opts into cover checks on its existing radial-damage
packet. The standalone addon can disable them at the exact existing callsite
by setting both flags to false immediately before the engine consumes the same
packet. This does not use the rejected radial batching design: `RadialDamage`
does not time or aggregate Overguard, and no effect is deferred until return.

**PENDING live:** enemies behind solid cover must be compared in game after
launch. Offline checks prove the target, source, compiled artifact, and hook
shape; they do not prove the engine's observed gameplay result.
