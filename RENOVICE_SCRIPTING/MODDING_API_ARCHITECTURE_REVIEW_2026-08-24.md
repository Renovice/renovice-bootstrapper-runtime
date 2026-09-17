# Renovice modding API architecture review

Date: 2026-08-24

This review compares Renovice with the public architectures documented by
BepInEx, Harmony, Reloaded-II, Microsoft Detours, and Lua's module loader. It is
guidance for this private Warframe environment, not a proposal to add those
frameworks as dependencies.

> 2026-09-07 status: the content-keyed host now live-proves standalone addon
> loading, card projection, damage-event reachability, and instruction-addressed
> argument hooks without per-ability support scripts. V48's radial batching is
> rejected for effect timing; the next damage contract dispatches every
> engine-reported calculated result immediately. Calculated damage may include
> overkill and is not target health or effective-health loss.

## Conclusion

The addon goal is valid. The rejected implementations failed because they
tried to infer semantic ownership from module-load timing, Lua call stacks, or
cached closure publication. Established modding systems install one stable
host-owned interception for each semantic event and maintain a central registry
of addon callbacks.

The current ability-resource matcher is the correct transition away from
timing inference. The long-term contract should make the target declarative and
use canonical resource identity rather than requiring every addon author to
write an arbitrary matching function.

## External patterns

### Plugin loader owns lifecycle and identity

BepInEx uses a chainloader and common plugin contract, with central metadata,
dependencies, configuration, and logging. Reloaded-II likewise gives mods a
loader-owned lifecycle and explicit load/unload events. Reloaded's native-mod
guidance requires unloadable mods to deactivate hooks and release resources.

Applied to Renovice:

- the DLL owns discovery, validation, activation, cleanup, logging, and F9;
- every addon has a stable unique ID and API version;
- addons never install their own native detours;
- deleting or replacing an addon is a cleanup transaction.

Sources:

- https://docs.bepinex.dev/master/api/index.html
- https://github.com/Reloaded-Project/Reloaded-II/blob/master/docs/CheatSheet/ReloadedIIApi.md
- https://github.com/Reloaded-Project/Reloaded-II/blob/master/docs/NativeMods.md

### Hook once, dispatch many callbacks

Harmony permits multiple independently owned patches on one original method
and defines prefix, postfix, finalizer, priority, before, and after semantics.
It recommends postfixes for compatible additive behavior and uses explicit
owner IDs and ordering rather than accidental load order.

Applied to Renovice:

- install one native hook for `AbilityCard.BuildRows`, one for the chosen
  damage event, one for cast events, and so on;
- keep an ordered handler list behind each event;
- route all addons through that list;
- do not create one machine-code hook per addon;
- use deterministic priority plus addon ID ordering;
- preserve the stock call unless a hook explicitly has replacement authority.

Sources:

- https://harmony.pardeike.net/articles/patching.html
- https://harmony.pardeike.net/articles/patching-postfix.html
- https://harmony.pardeike.net/articles/priorities.html

### Native hook installation is transactional

Microsoft Detours stages attach/detach operations and makes them effective only
when the transaction commits; it can abort the pending transaction. Renovice
uses its own hook implementation, but should retain the same invariant:
validate all addresses and ABI expectations first, then publish the whole hook
set or none of it.

Sources:

- https://github.com/microsoft/Detours/wiki/DetourTransactionBegin
- https://github.com/microsoft/Detours/wiki/Using-Detours

### Loaded Lua code is cached state

Lua 5.1's `require` consults `package.loaded` and returns the already-loaded
module rather than reading its file again. DE's environment is not assumed to
implement stock `require`, but the architectural lesson applies: changing a
file does not replace already-captured closures. Renovice needs its explicit
generation registry and cleanup rather than expecting a filesystem change to
rewrite live references.

Source:

- https://www.lua.org/manual/5.1/manual.html#5.3

## Hypothesis ledger

| Hypothesis | Evidence | Result |
|---|---|---|
| A modular addon API requires each addon to patch the game independently. | Established loaders centralize hook installation and route registered plugins. | **FALSE** |
| Addon ownership should be inferred from which loader call happened nearby. | Loader timing did not correlate with the real DE card transaction; mature APIs require explicit target identity. | **FALSE** |
| A base-ability addon is registered once but may execute on every relevant runtime event. | Central hook systems register once and invoke callbacks whenever the original event occurs. | **TRUE** |
| Per-event invocation is equivalent to polling or scanning every instance. | Event dispatch happens only at the already-occurring engine boundary; no filesystem or world scan is involved. | **FALSE** |
| Arbitrary new behavior can always be added without a replacement or a known hook point. | Additive behavior requires an event carrying sufficient context; otherwise the original control flow must be replaced or a new semantic hook researched. | **FALSE** |
| The current `matchesAbility` contract is a reasonable proof. | It uses the exact Ability resource carried by the proven card query and eliminates load timing. | **TRUE for POC; pending live** |
| Localization text keys are the best permanent identity. | They can be shared or renamed and are presentation metadata rather than canonical object identity. | **FALSE for final API** |

## Recommended host architecture

```text
                    Renovice native host
                            |
        +-------------------+-------------------+
        |                   |                   |
  hook resolver       addon manager       F9 transaction
  build profiles      manifests           scan on keypress
  signatures          API versions        stage + validate
  ABI validation      dependencies        atomic publish
        |                   |                   |
        +-------------------+-------------------+
                            |
                immutable event registry
                            |
          +-----------------+------------------+
          |                 |                  |
  Ability.BuildRows   Ability.AfterCast   Damage.Applied
          |                 |                  |
     ordered addon      ordered addon       ordered addon
       callbacks          callbacks           callbacks
```

There is one native interception per semantic event, not per addon. An addon is
registered against a stable target once. Its callback naturally runs for each
matching card request, cast, spawn, or damage event because those are the
events it requested.

## Recommended addon manifest

The GUI should generate a declarative document and Luau callbacks. A future
contract can resemble:

```lua
return {
    manifest = {
        id = "renovice.octavia.mallet_overguard",
        apiVersion = 1,
        target = {
            abilityResource = "/Lotus/Powersuits/Bard/Abilities/BardMusicAbility",
        },
        priority = 400,
    },

    activate = function(context) end,
    cleanup = function(context) end,

    hooks = {
        abilityCardRows = function(context)
            return {
                {
                    label = "Overguard Cap",
                    value = 15000,
                },
                {
                    label = "Overguard From Damage",
                    value = context:StrengthScaledPercent(1, 5),
                    unit = "percent",
                },
            }
        end,

        afterAbilityDamage = function(context)
            context:AddCasterOverguard(context.actualDamage * 0.01, 15000)
        end,
    },
}
```

The GUI should normally generate `target.abilityResource`; `matchesAbility`
should remain an advanced escape hatch for targets that cannot yet be described
declaratively.

## Card-row contract correction

The current proof lets `afterAbilityCard` mutate the stock table directly. That
is sufficient for a controlled live proof, but the final API should have each
addon return row descriptors into a staging area:

1. run every eligible provider under a protected call;
2. validate every returned descriptor;
3. resolve duplicate row IDs and ordering deterministically;
4. append all accepted rows to the stock array only after every required gate
   passes;
5. leave the stock result untouched if a required provider fails.

This prevents an addon from inserting one row and then throwing, which would
otherwise leave a partially changed card.

## Gameplay-event contract correction

Base-ability ownership and runtime instances are different concepts:

- ownership is declared once by canonical ability resource;
- runtime context is delivered on each cast/damage event;
- no world scan is required.

For Mallet, the best final gameplay event is not a generic `SetSource` call plus
Lua-stack inference. The host should expose a semantic event whose payload
contains, or can deterministically derive:

- canonical source ability;
- caster;
- damage source/entity;
- target;
- attempted damage;
- engine-reported calculated damage, including possible overkill;
- host/client authority;
- event generation.

If the engine's final damage callback lacks canonical source ability, the host
may associate the created damage source with the ability once at its verified
creation/cast boundary and remove that association on destruction. That is an
event-owned handle map, not polling or scanning every object.

## F9 transaction

F9 should remain inactive until pressed:

1. read the current addon folder;
2. parse manifests and dependencies;
3. compile changed sources into a staged generation;
4. validate target identities, hook schemas, and API versions;
5. call staged activation;
6. atomically swap the immutable handler registry;
7. let callbacks already in progress finish with their retained old generation;
8. clean and release the old generation when no callback owns it;
9. keep the previous generation if any pre-commit step fails.

UI changes take effect the next time the card provider rebuilds its rows. Active
loops and already-captured stock closures do not magically change merely
because the source file changed.

## Performance target

Idle F9 cost is zero filesystem work. Each semantic event performs:

- one stable target-ID lookup;
- one immutable handler-list read;
- protected calls only for matching addons.

This is the normal cost shape of an addon API. The expensive and fragile part
is discovering and maintaining the small set of native semantic hook points,
not dispatching registered addon callbacks.

## Next order after the current live test

1. Prove or reject the deployed ability-resource card matcher.
2. Replace the localization-tag proof with a canonical resource identity
   resolver.
3. Convert direct row mutation into validate-then-merge providers.
4. Research one real ability-damage event carrying deterministic source
   ownership; retire Lua-stack inference for gameplay routing.
5. Add manifest ID, API version, priority, dependencies, conflicts, and declared
   capabilities.
6. Implement immutable handler generations and in-flight reference ownership.
7. Expose these contracts through the ability editor; keep full replacement as
   the explicit fallback for control-flow edits.
