# Icebind Solo (opt-in package)

Run **The Icebind** with 1 to 6 Tenno, and let the mission scale its complications to the real squad size.

- Client: Warframe 44.1.0, build `2026.10.06.16.12` (stock pack `stock-a71c700d9520b4a5`).
- Kind: one folder package (`Packages\IcebindSolo`), one SCRIPTS row `[PACKAGE] Icebind Solo`, state id
  `package:icebindsolo`.
- Made: 2026-10-08. Research record: `work/research/U44.1.0-2026-10-08/icebind-solo/README.md` (RENOVICE workspace).

## What it changes

Both members are exact content-key **root replacements**. Each is the stock module of this build with only the listed
instruction words changed (same prototypes, string pool, constants and code size). No addon, no shim, no C++ change.

| Member | Stock module (content key) | Site | Stock | Icebind Solo |
|---|---|---|---|---|
| `112349dd35bbea7a (Icebind Solo squad gate).lua_B` | `/Lotus/Interface/SixStackSetup.lua` (`112349dd35bbea7a`) | `OnSquadMembersChanged`, P40 i18 | `if #members ~= ICE_BLADE_HUB_MAX_PLAYERS then` cancel the countdown | `if not (#members <= ICE_BLADE_HUB_MAX_PLAYERS) then` cancel |
| same file | same module | squad hint, P17 i51 | `if not (#members < MAX)` equip-Cryobell hint, else "full squad" hint | `if not (MAX < #members)` equip-Cryobell hint, else "full squad" hint |
| `4db007fa8f0145bd (Icebind Solo squad scaling).lua_B` | `/Lotus/Scripts/KuvaPath/KuvaPath.lua` (`4db007fa8f0145bd`) | `MasterInit`, P65 i76 | `_T.CalculatedSquadSize = 6` | `_T.CalculatedSquadSize = nil` |

What stays stock:

- `LotusUtilities.ICE_BLADE_HUB_MAX_PLAYERS = 6`: the session maximum, the 6 squad slots, the vote list.
- The start conditions other than squad size: every member present has offered a Cryobell (`AllPlayersOfferedKey`)
  and no two members use the same Warframe (the `SetupHintSameSuit` check).
- Voting, the tie-break (host's vote, then random), the countdown times (60 s, 30 s at half the votes, 10 s when all
  voted) and the launch.
- The developer-only `[HC] FORCE COUNTDOWN` button path (`StartCountdown`, shown only when the server URL contains
  `api-dev`).

How the squad size is found: `KuvaPath.MasterInit` creates the KuvaPath complications manager right after this
assignment. That manager (`/Lotus/Scripts/Modes/ComplicationsMgr/ComplicationsMgr.lua`, master only) already contains
DE's own rule: when `_T.CalculatedSquadSize` is not set it stores
`Clamp(gRegion:GetNumHumanPlayers() + Server.NumVirtualTestClients, 1, 6)` and prints
`Calculated squad size = N`. Stock KuvaPath pre-set 6, so that rule never ran in the Icebind. The complication scripts
(Kuva Saturation, Toxin Inoculation, Volatile Atmosphere) read the value through tables indexed 1 to 6.

## Files

| Path | SHA-256 |
|---|---|
| `IcebindSolo/112349dd35bbea7a (Icebind Solo squad gate).lua_B` (45,813 bytes) | `59ae40be77ca2a959d4b742d4b6cf9600d4545abc7fb3898d972c332354cc060` |
| `IcebindSolo/4db007fa8f0145bd (Icebind Solo squad scaling).lua_B` (54,350 bytes) | `46222b8a806ccaf1d8552d91fdb58aebbc770bc5f86c8b483535562cb326b1d5` |
| `IcebindSolo/package.json` | `5054fa37d50860c403f49fcaf4de542507a022f8542292f9c3dcf8ce6e48a5f6` |

- `src/edits.json`: the exact instruction edits (canonical opcode names, operands, reasons).
- `src/build_members.py`, `src/disasm.py`: the builder and its gates. They run inside the RENOVICE workspace (paths are
  workspace-absolute; the canonical copy is in the research folder above) and write `build/` next to `src/`.
- `src/diff_report.md`: byte offsets, raw and canonical words, and every gate result.
- `src/readable_diff.txt`: the decompiled (readable) diff of each member against stock: exactly the three sites above.

## Gates (2026-10-08)

| Gate | Result |
|---|---|
| Stock content key = manifest key = filename key (both members) | PASS |
| Parse with the U44 opcode profile, clean instruction walks | PASS (76 + 76 prototypes) |
| Byte diff against stock only inside the edited instruction words | PASS (3 bytes and 2 bytes) |
| Instruction-level edit script equals the intended sites | PASS |
| `derecomp de-roundtrip` (container re-emits byte-exact) | PASS |
| `derecomp const-identity --u44` (no constant, string or key-use change) | PASS (76/76 each) |
| `derecomp cfg-identity --u44` | reports exactly the edited site (P40 `IF EQ -> IF LE`; P65 the removed `LOAD N:6`), 75/76 equal |
| Update tool rebase onto the same build / a shifted synthetic build | PASS / PASS (edits move to P42 i21, P19 i54, P67 i79) |
| Bootstrapper package scanner (`verify_script_packages.ps1 -AdmitPackage`) | PASS: `RENOVICE PACKAGE ACCEPT ... members=2 replacements=2` |
| Post-update check on the game folder | content.parse / content.keys / content.package_build OK |

No recompile is involved (the members are byte edits of stock), so there is no source fixed-point gate.

## Install, switch, remove

1. Close the game.
2. Copy the folder `IcebindSolo` into `<game>\OpenWF\CustomScripts\Packages\` (giving
   `Packages\IcebindSolo\package.json` and the two `.lua_B` files).
3. Optional: add `"package:icebindsolo": false` to `CustomScripts\ScriptStates.json` so it starts switched off.
4. Start the game and turn **Icebind Solo** on in **SCRIPTS** (closing the menu applies it through F9).

Remove: delete `Packages\IcebindSolo` and press F9 (or restart). The stock modules apply again at their next load.

The package carries an empty settings declaration only for its build label, so SCRIPT SETTINGS lists "Icebind Solo"
with no values (only "Reset all to defaults").

## Live test

1. Close the game. Start the server with `npm run raw` in the SpaceNinjaServer folder.
2. Launch from the game folder and turn on **Icebind Solo** in SCRIPTS.
3. Yuvan Peak: claim a Cryobell at a pillar, go to Melica, choose **Ring a Cryobell**, offer the Cryobell, solo.
4. Expected: the hint shows the countdown instead of the full-squad hint, the countdown starts (60 s, or 10 s after
   your vote), and the mission launches.

Log lines that confirm each part:

| Part | Where | Line |
|---|---|---|
| Package loaded | `CustomScripts\Logs\renovice_source.log` | `RENOVICE PACKAGE ACCEPT trigger=... package=IcebindSolo id=package:icebindsolo members=2 replacements=2 ...` (switched off: `RENOVICE PACKAGE DISABLED ... inventory-only=1`) |
| Setup screen uses the edited module | OpenWF console | `RENOVICE Lua replacement matched key=1234911937267755642 original_bytes=45813 replacement_bytes=45813` (decimal of `112349dd35bbea7a`) |
| Mission script uses the edited module | OpenWF console | `RENOVICE Lua replacement matched key=5597983109543970237 original_bytes=54350 replacement_bytes=54350` (decimal of `4db007fa8f0145bd`) |
| Real squad size used | `%LOCALAPPDATA%\Warframe\EE.log` (host) | `MasterInit!`, then `Calculated squad size = 1` for a solo run (stock always printed 6) |

## Limits

- Live behavior is unproven until the test above passes. Script load proves only load.
- The countdown starts from the squad callbacks (join, leave, loadout change). Offering the Cryobell updates the local
  loadout; whether that callback fires for a solo host is UNRESOLVED until the live test.
- A squad of 0 members is not guarded (stock cancelled it as `0 ~= 6`); it cannot occur from the squad callbacks that
  call this check.
- The squad size is counted when the complications manager starts (after `GameStarted` and its start delay), with
  DE's own rule. A player still loading at that moment is not counted. After a host migration (`MasterInit(true)`)
  the value is unset and the complication scripts use their stock fallback, the live `GetNumHumanPlayers()`.
- Side objectives, enemy levels and other Icebind content tuned for six players are not changed.
- Melica's stock entry rule stays: the setup opens only with Elite Deep Archimedea or Elite Temporal Archimedea
  unlocked (`SetupConquestBlocked`).
- Server-side Icebind support (Cryobell offers, rewards, consumption) is separate (SpaceNinjaServer).
- For client 44.1.0 only. After an update, `renovice_update.py` rebases both members (registered in
  `tools/update_check/authored_addons.json` and the update baseline of the ability editor repository).

## 2026-10-08: Squad Side Objectives scale too

Squad Side Objectives (Lockbox, Cryothermia, Indomitable Ice, Entropy Orb, Signal Chain) wait for
`required = flag ? min(GetNumHumanPlayers(), 6) : 6` nearby players. `KuvaPath.MasterInit` sets that flag to `false`
(P65 i9 `LOADB A=1 B=0`, stored by i10 `SETUPVAL 1`), so a solo run showed "1 / 6" and could never start one. The
squad-scaling member now also sets it to `true` (one byte, `B=1`). The flag's only other reader runs a pending
event from the ImGui debug "Start Event" button, which is unreachable in normal play. Gates: all PASS
(`src/build_members.py`; the shifted-rebase gate now counts the inserts before each of several edits in one
prototype). Member sha256 `2b5c352a1681c358…`. Not yet live-tested.

## 2026-10-08: the side-objective events themselves scale too

Starting an objective was not enough: three event scripts keep their own copy of the same "scale to the real squad"
flag (upvalue 0), set `false` by their `MasterInit` at i3 (`LOADB R1 false; SETUPVAL 0`), and then demand 6 players
inside the event:

| Event script | Content key | Flag reads (all evidence: `work/research/U44.1.0-2026-10-08/icebind-solo/events`) | Edit |
|---|---|---|---|
| `AntiVoidSurgeEvent` | `21f2b1172cc837b7` | players needed inside the crystal zone (gather, maintain, HUD): `flag ? GetNumHumanPlayers() : 6` | P19 i3 `LOADB` B 0 -> 1 |
| `LockedCrateEvent` | `d6111f1566eb30f9` | players needed at the crate and the "n / 6" HUD; also registers the event's debug ImGui panel (DE developer overlay only) | P21 i3 `LOADB` B 0 -> 1 |
| `SignalBridgeEvent` (Signal Chain, "link point A to point B") | `8aad3115f1204cf2` | chain sized for `n` nodes: console spawn range `MapToRange((n-1)/5)` of 20..30, node distance `ceil(dist/(n+1)+3)`; n = 6 made one Tenno unable to bridge | P24 i3 (MasterInit) and P25 i55 (ReplicaInit) `LOADB` B 0 -> 1 |

`HotPotatoEvent` and `RegenCrystalEvent` also set a flag in `MasterInit` but never read it and have no player-count
requirement (no "missing players" objective), so they are unchanged.

Members `21f2b1172cc837b7 (Icebind Solo void surge objective).lua_B` (sha256 `34ffe9267df7bb87…`),
`d6111f1566eb30f9 (Icebind Solo locked crate objective).lua_B` (`268bbbb8fb0d34c3…`),
`8aad3115f1204cf2 (Icebind Solo signal chain objective).lua_B` (`1a12543b2dc41521…`). Gates: 48/48 PASS
(`src/build_members.py`; cfg-identity reports exactly the intended `LOAD B:false -> LOAD B:true` labels). Registered in
the update tool (`authored_addons.json`, package-replacement test 7/7 PASS). Installed into the active game folder
(`Packages/IcebindSolo`, package enabled); prior package backed up in
`work/backups/icebindsolo-before-sideobj-events-2026-10-08`. Not yet live-tested.
