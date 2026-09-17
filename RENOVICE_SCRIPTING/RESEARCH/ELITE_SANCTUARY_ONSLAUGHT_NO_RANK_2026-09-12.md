# Elite Sanctuary Onslaught rank requirement ownership

Date: 2026-09-12; live rejection and corrected hypothesis added 2026-09-13

## Conclusion

The current rank-30 restriction is client Lua behavior owned by
`Lotus.Interface.MissionRequirementUtilities`, not an OpenWF server check. The
exact implementation point is the mission descriptor returned from
`BuildMissionForLocation` inside `TryLaunchOnslaught`. Clearing its existing
`maxSuitReq` field before the stock checker runs removes the Onslaught
suit-rank gate.

The first deployed addon was **live rejected on 2026-09-13**. It loaded and
installed its native hook, but the rank restriction remained. Its additional
`tostring(arguments[2]) == "SolNode802"` condition was not proven at the hook
boundary and is no longer accepted. The corrected addon relies on the already
exact `TryLaunchOnslaught` prototype/instruction scope and does not convert the
engine `Symbol` argument.

## Evidence

Current stock file:

`shared/corpus/de-luau-stock/Lotus_Interface_MissionRequirementUtilities.lua_B`

- size: `34198` bytes;
- SHA-256: `4AD63FD5D545B70BD424D1E63D5390B37A573D66078F195E747D91F7A61D7E5E`;
- RENOVICE body key: `9dfe563d26eb6527`;
- closure map: `28` prototypes, `27` creation sites, `56` captures, zero failures;
- `TryLaunchOnslaught`: prototype `25`;
- `BuildMissionForLocation`: NAMECALL instruction `9`, CALL instruction `10`;
- stock requirement-checker call: instruction `15`.

The readable diagnostic source shows this order:

```lua
node = Ternary(isElite, SANCTUARY_ONSLAUGHT_CHALLENGE_NODE, SANCTUARY_ONSLAUGHT_NODE)
mission = GetStarChart():BuildMissionForLocation(node)
error = CheckMissionRequirements(node, true, mission)
```

The same stock body reads `mission.maxSuitReq`, inspects each squad member's
normal loadout, compares `Level` against `gGameConfig:GetLevelCap`, includes the
Mastery Rank 30 plus Forma fallback, and returns
`/Lotus/Language/Menu/MissionMaxSuitRequired` or its squad variant on failure.

The current OpenWF server source publishes `SolNode802` as the weekly seed node,
but a repository search found no implementation of `maxSuitReq`,
`MissionMaxSuitRequired`, or the Warframe-rank entry test.

## Corrected architecture

The standalone addon declares
`hooks.nativeCalls.BuildMissionForLocation.after`. Runtime targeting first
requires the exact body key and VM. The Lua callback then requires prototype
`25` and instruction `10`. That callsite exists only in
`TryLaunchOnslaught`, after its stock `SolNode801`/`SolNode802` selection. The
callback mutates the returned mission object in place:

```lua
mission.maxSuitReq = false
```

This uses the game-owned mission field and leaves the stock checker and launch
flow authoritative. It introduces no replacement body, server special case,
polling, watchdog, per-frame write, support script, or guessed Symbol-to-string
conversion. Because normal and Elite Onslaught share prototype 25, the single
rank field is cleared for both; other mission launchers cannot reach this
prototype/instruction pair.

## Evidence boundary

The original package's offline validation passed but its gameplay result was
false. The corrected package separately validates the stock hash/body key,
behavior harness, deterministic compilation, exact DE-container roundtrip,
Semantic Plan, Semantic IR, raw symbol retention, and strict API contract.
These facts prove the artifact and exact callsite contract; they do not prove
gameplay acceptance. One below-rank-30 Elite Sanctuary Onslaught launch remains
the corrected live gate.

Deployment record:

- Rejected: `RENOVICE_DEPLOYMENTS/ELITE_SANCTUARY_NO_RANK_ADDON_2026-09-12`
- Corrected: `RENOVICE_DEPLOYMENTS/ELITE_SANCTUARY_NO_RANK_CALLSITE_FIX_2026-09-13`
