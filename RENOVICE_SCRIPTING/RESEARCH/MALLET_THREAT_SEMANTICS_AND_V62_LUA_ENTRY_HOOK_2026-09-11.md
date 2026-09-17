# Mallet threat semantics and V62 Lua-entry hook

Date: 2026-09-11

## Conclusion

The current ability corpus supports a high-confidence behavioral conclusion:
the unresolved engine method `0xecb31eeb` accepts a signed AI target
desirability or priority value. Positive `5` is repeatedly used for decoys,
summons, and enemy-attracting states; `0` restores or clears the change;
negative values suppress priority. This is not proven to be a hard target lock.
Several abilities combine it with spawning, faction, charm, registration, or
explicit agent-target changes.

The exact symbolic name of `0xecb31eeb` remains unresolved. It must stay
`Name__ecb31eeb` in strict output. `SetThreatLevel` is a different, verified
native hash, `0x1601bdaf`. A legacy name `SetEntityFaction__ecb31eeb` is an
explicitly unverified guess and must not be promoted into the API catalog.

## Mallet's stock behavior

Current Mallet body key: `08faf07b504d058f`.

Stock `BoxLoop` owns an accumulated incoming-damage pool. It adds the current
damage-buffer contribution, spends part of that pool on each damage beat, and
then computes:

```lua
math.floor(Lerp(5, 0, math.min(1, accumulatedDamage / 1500)))
```

When the integer changes, stock Lua puts it in a `SecondaryScriptArgs` float
and activates secondary script `SetThreatLevel`. Prototype 18 is that exact Lua
function. Its third parameter flows directly to Mallet's stored box through
`boxValue:Name__ecb31eeb(p18_2)`.

Therefore stock standalone Mallet is not simply fixed at threat 1. It begins at
the high end while the accumulated pool is near zero, falls toward zero as the
pool grows, and can change again as damage beats consume the pool. The user's
observation that enemies initially attack Mallet and later prefer Octavia is
consistent with this stock formula.

V62 leaves this entire path intact and changes only prototype 18 argument 3 to
`5` at Lua function entry. The original stock function remains authoritative.

## Current Warframe ability census

Pinned catalog counts: 62 Warframes, 248 abilities, 246 unique verified body
modules, 88,869 callsites, and 3,072 resolved exports.

Twenty unique current ability modules contain 41 calls to either unresolved
`0xecb31eeb` or verified `SetThreatLevel`:

| Warframe | Ability | Observed values or form | Calls | Interpretation in surrounding stock code |
|---|---|---:|---:|---|
| Atlas | Rumblers | 3, 0 | 2 | Raise summon priority, then clear. |
| Caliban | Lethal Progeny | dynamic | 1 | Dynamic summon priority. |
| Frumentarius | Evade | -5, 0 | 2 | Suppress target priority, then restore. |
| Khora | Strangledome | 5, 0 | 2 | Raise affected target priority, then clear. |
| Loki | Decoy | 5, 0, 5 | 3 | High decoy priority across spawn paths and cleanup. |
| Loki | Radial Disarm | 5, 1 | 2 | Augment target-priority changes plus explicit AI refresh/target work. |
| Loki | Switch Teleport | -5, 5, 0, 0 | 4 | Signed temporary changes across switch states. |
| Mirage | Hall of Mirrors | -5, 5, 0 | 3 | Signed clone/caster priority changes and cleanup. |
| Nekros | Shadows of the Dead | 5 | 1 | High summon-related priority. |
| Nyx | Absorb | 5, 0 | 2 | Attract during Absorb, clear afterward. |
| Nyx | Chaos | 1, 5 | 2 | Intermediate and high affected-target priority. |
| Octavia | Mallet | dynamic 5..0 | 1 | Dynamic Mallet box priority from the accumulated-damage pool. |
| Oraxia | Widow's Brood | 5 | 1 | High summon priority. |
| Revenant | Enthrall | 5, 0 | 2 | Raise controlled-target priority, then clear. |
| Saryn | Molt | 5, -1, 0 | 3 | Decoy high, caster suppressed, cleanup restore. |
| Styanax | Rally Point | 5, 0 | 2 | Uses verified native `SetThreatLevel`, a distinct method. |
| Titania | Razorwing | 5, -5, 0 | 3 | Signed summon/caster priority and cleanup. |
| Wisp | Wil-O-Wisp | 5 | 1 | High decoy priority. |
| Wukong | Defy | 5, 0 | 2 | Attract during Defy, clear afterward. |
| Xaku | The Lost | -5, 0 | 2 | Suppress priority during the relevant state, then restore. |

The wider pinned corpus has 43 calls to `0xecb31eeb` across 22 modules. All are
void receiver-plus-one-argument calls. The two modules outside the current
Warframe ability catalog are additional Archwing/Stalker-era behavior evidence;
they do not change the 20-module current-ability denominator.

## Why Loki Decoy is stronger evidence than a numeric comparison

Loki Decoy uses value 5, but its script also attaches an ability object,
registers spawned/clone/faction/unique-power relationships, and in related Loki
paths explicitly clears or refreshes AI targets. Resonator uses a charm/control
system. These mechanisms can make the gameplay result stronger than Mallet even
when both pass 5. Threat 5 means the AI should prefer the entity within the
engine's normal decision rules; it does not prove every enemy must abandon all
other targets immediately.

## Failed wrapper hypothesis

| Hypothesis | Evidence | Result |
|---|---|---|
| A normal addon source global named `SetThreatLevel` resolves Mallet's DE hashed export because the addon borrows the module environment. | The addon chunk loaded, but repeated F9 generations and fresh startup logged `addon lifecycle FAIL ... field=activate reason=protected-call-rejected` followed by `TARGET ADDON ROLLBACK ... new activation rejected`. | **FALSE live.** |
| The failed wrapper modified gameplay despite rollback. | The lifecycle transaction never committed the new addon generation. | **FALSE.** |
| The separate internal SCRIPTS bridge error explains the wrapper failure. | Wrapper activation failed repeatedly both before and after the one bridge `pcall=-1`; a fresh startup loaded the bridge and still rejected the wrapper. | **FALSE.** |

## V62 implementation and proof boundary

The runtime now exposes generic Lua-entry argument copyback. A
`luaCalls[prototype].before` callback may replace only finite same-tag numbers
or booleans. The host validates the exact live argument count and all requested
changes before writing any slot. After-phase argument mutation, type changes,
nonfinite values, and GC-backed identities are rejected. Upvalue rules and the
V61 terminal-frame guard remain intact.

The Mallet addon owns all ability-specific data:

```lua
hooks = {
    luaCalls = {
        [18] = {
            before = function(prototype, arguments, upvalues)
                arguments[3] = 5
            end,
        },
    },
}
```

Offline verification proves deterministic compilation, exact addon-body
roundtrip, semantic acceptance, API contracts, argument transformation, and
preservation of the existing Overguard/card fixtures. Deployment proves the
installed hashes and preservation of every other functional CustomScripts
file. Only a restarted V62 client can prove startup and actual enemy preference.
