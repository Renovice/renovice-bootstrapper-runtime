# RENOVICE scripting guide

Current implementation handoff:
[CURRENT_BOOTSTRAPPER_STATE.md](CURRENT_BOOTSTRAPPER_STATE.md).

Architecture reference:
[modding API architecture review](MODDING_API_ARCHITECTURE_REVIEW_2026-08-24.md).

Reusable runtime logging and exact filters:
[DIAGNOSTICS_CONFIG.md](DIAGNOSTICS_CONFIG.md).

Additive wrappers around target-module Lua exports:
[EXPORTED_LUA_FUNCTION_HOOKS.md](EXPORTED_LUA_FUNCTION_HOOKS.md).

Exact target-module Lua prototype hooks and their value/copyback rules:
[NATIVE_TARGET_ADDON_HOOKS.md](NATIVE_TARGET_ADDON_HOOKS.md).

This is the practical guide for editing Warframe behavior with the source-built
RENOVICE bootstrapper. It describes the paths that are actually in use, the
transactional F9 behavior proven in the live game, and the boundary between a
full Lua replacement and an additive addon.

## Pick the smallest mechanism that owns the required behavior

| Goal | Use | Why |
|---|---|---|
| Change an ability's existing local control flow, formula, or unnamed closure | Full `.lua_B` replacement | The original module itself must change. |
| Run additive behavior before or after an exported function such as `ActivateAbility` | Target `.target.addon.lua_B` with an owned Lua wrapper | The stock closure is called directly and restored by addon cleanup. |
| Read or change verified arguments/upvalues immediately before one exact stock Lua prototype runs | Target `.target.addon.lua_B` with `hooks.luaCalls[prototype].before` | V107 observes the real nested CALL boundary, validates exact body/VM/prototype identity and permits only finite same-tag scalar copyback. Lua `after` declarations fail closed until complete call retirement exists. |
| Add behavior at an existing RENOVICE hook without recreating the stock ability | Managed `.addon.lua_B` | The stock ability remains authoritative and the addon owns only its addition. |
| Change an ability name or description | `Label Replacements.cat.txt` | The card paragraph comes from a localization tag, not the ability's numeric-row function. |
| Add another number to a modified ability card | Generate another native row inside that ability's `GetAbilityUpgradeLevelInfo` | Warframe's existing bottom-row renderer remains authoritative. |
| Run a one-time diagnostic | Ordinary `.lua_B` in `Inject` | It executes after a successful F9 commit but has no automatic undo. |

Prefer an addon when the needed event already exists. Use a full replacement
when the original control flow itself must be changed or when no trustworthy
hook exists. Do not invent an event by polling every frame.

Survival timers are the first verified before-only `luaCalls` example. Body
`1e3647332a578b78`, prototype 64, capture 19 (elapsed reward time), capture 22
(pickup config), and capture 70 (reward config) are locked by the editor and
runtime. The stock mission module remains loaded, including its keypad/start
path. The historical full replacement is rejected because live testing failed
to start the mission and its reward-progress insertion targeted remaining life
support instead of elapsed reward time.

## Live folders

The live root is:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\CustomScripts`

- Full replacements live directly in `CustomScripts` and begin with the
  module's 16-hex content key.
- Managed addons live in `CustomScripts\Inject` and contain `.addon` before
  the `.lua_B` extension.
- Renaming a script to `.disabled` keeps it as evidence without loading it.
- Source, research, and build products belong in the RE project, not scattered
  through the live game folder.

## Native Warframe API reference

The authoring API is intentionally separate from the decompiler implementation:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\de-luau-toolchain\api\warframe`

- `contracts.tsv` is the detailed argument, return, callback, authority, and
  lifetime source of truth.
- `selected_catalog.tsv` is the generated 225-API authoring set; 175 of those
  are also in the stricter high-confidence tier.
- `evidence.tsv` binds claims to stock, native, or live evidence.
- `negative_contracts.tsv` records disproven assumptions so they are not
  accidentally reused.
- `README.md` explains the confidence model and current boundary.

Before compiling an intentional edit, run the focused fast check:

```powershell
& "C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\de-luau-toolchain\check_ability_api.bat" input.luau
```

This checks the one source file; it does not rescan the 286-module corpus. For
a small fully authored addon that should contain no unknown calls, use the
checker in strict-unknown mode. For reconstructed stock modules, inspect
unknown calls only in the part intentionally changed.

## Full replacements

Example filename:

`08faf07b504d058f (Mallet ...).lua_B`

The prefix is the loader key for the stock module body. The remainder is a
human description only. A replacement is compiled through the canonical
source-to-DE pipeline:

```powershell
& "C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\repos\toolchains\de-luau-toolchain\bin\derecomp.exe" recompile input.luau output.lua_B
```

Copy the built bytecode over the matching live replacement and press F9. If the
module has already loaded, RENOVICE queues its original native descriptor at
the owning manager/VM/thread boundary. Warframe's own loader refreshes the
existing gameplay and UI objects. A closure or active loop already executing
may finish on the old generation; recast or respawn the affected object.

This is live proven for Mallet gameplay and native Arsenal rows. Require log
evidence containing `native module refresh PASS`, VM-local delivery with zero
failures/pending work, and `module_refresh=PASS`. A generic file-scan or addon
PASS is not equivalent to a full-module refresh.

## Managed addons

A persistent addon returns an idempotent lifecycle table:

```lua
local shared = _T
local active = false

local function activate()
    if active then return end
    -- Install this generation's handler or callback.
    active = true
end

local function cleanup()
    if not active then return end
    -- Remove only behavior owned by this generation.
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
```

Important rules:

1. The bootstrap chunk constructs and validates state but does not install
   gameplay behavior before `activate()`.
2. `activate()` and `cleanup()` take no arguments, do not yield, and are safe
   to call repeatedly.
3. `cleanup()` reverses every callback, global, spawned object, or listener the
   addon owns.
4. Bare `_T` is the proven shared Warframe table for the **current table
   generation** in the loader-assigned closure environment. It is not callback-
   state vararg two. DE may replace the `_T` table while retaining the same VM
   pointer, so target-addon generation identity includes the exact `_T` object.
5. Addon hooks should be protected at the calling site with `pcall` so a UI or
   optional addon failure cannot break the stock ability.

The live Mallet test proved this complete lifecycle: deploy addon, F9 activate,
cast receives 30,000 Overguard, remove addon, F9 cleanup, temporary behavior is
gone while the permanent Mallet replacement remains functional.

That historical 30,000 test exercised activation and consumption inside one
`_T` lifetime. It did not prove persistence across a region transition. The
later reflected-damage test exposed that missing case; target addons now clean
and reactivate transactionally whenever the exact `_T` identity changes, even
when their filename and bytecode are unchanged.

### Targeted managed addons

A filename shaped as `<16-hex-key>.<name>.target.addon.lua_B` loads the addon
in the exact environment of the naturally loaded module with that original-body
key. This mechanism is generic; adding an addon for another ability does not
require changing or rebuilding the bootstrapper.

`activate` and `cleanup` are the complete mandatory contract. A target addon
may perform its own environment edits or registrations without returning a
`hooks` table. The optional native `hooks` table provides reusable host events
such as ability-card and applied-damage callbacks. When one of those optional
callbacks is present, its matching predicate remains mandatory. Unrelated
addons are not required to opt into those native events.

For an additive wrapper around `ActivateAbility` or another exported Lua
function, use `EXPORTED_LUA_FUNCTION_HOOKS.md` and its validated template. The
addon installs the wrapper from `activate()` and restores the exact original
from `cleanup()`; do not mutate the export while the candidate chunk is merely
being staged.

## What F9 actually does

There is no idle file watcher and no per-frame folder scan. Pressing F9 causes
one transaction:

```text
read current files
  -> stage config, SWF, replacements, Riven gate, and Inject chunks
  -> validate managed addon lifecycle tables
  -> cleanup old addon generation
  -> activate new addon generation
       failure: cleanup partial new generation, restore old generation
  -> atomically commit staged snapshots
  -> refresh already-captured replacement and target-addon contexts per VM
  -> report RELOAD PASS or ROLLBACK
```

Therefore F9 has essentially no cost while it is not pressed. File deletion is
also state: removing an addon cleans the old generation; removing a captured
full replacement schedules/restores the saved stock body.

## Ability descriptions and native stat rows

Descriptions and number rows are separate systems.

### Description

Ability metadata points at a localization key. Mallet uses:

`/Lotus/Language/Suits/BardMusicAbilityDesc`

Override that key in:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe\OpenWF\Label Replacements.cat.txt`

Then call the local OpenWF endpoint:

```text
http://localhost:6900/reload_label_replacements
```

Move off the ability and hover it again so the UI rebuilds the popup.

### Additional native stat rows

Warframe should continue owning the correct bottom panel; do not create a
custom card renderer. Ability scripts create its native rows inside
`GetAbilityUpgradeLevelInfo`, set their `Modded` state, and assign the finished
array to `_T.AbilityUpgradeLevelInfo`.

The failed global/cross-VM and cached-module-export experiments were not a hard
proof that addon-owned rows are impossible. They proved those attachment models
were wrong. Addon-owned rows are now **TRUE live** when the provider appends to
the exact stock table, returns that same table, and avoids redundant borrowed-
environment `type(...)` guards. The actual UI runs the selected ability
producer twice through a synchronous native `RunScript` call and immediately consumes
`_T.AbilityUpgradeLevelInfo` in that same state. The corrected addon proposal is
therefore a same-state post-`RunScript` result adapter, keyed by the queried
ability resource. See `NATIVE_TARGET_ADDON_HOOKS.md` and the authoritative
pipeline audit it references. Direct rows inside a full replacement remain the
only live-proven compatibility path.

The editor must generate more instances of that existing native row shape
directly inside the ability module:

```lua
table.insert(rows, {
    Label = "Overguard Cap",
    Value = overguardCap,
})

table.insert(rows, {
    Label = "Overguard From Damage",
    Value = damageToOverguardPercent,
    ValueUnit = "/Lotus/Language/Game/UNIT_PERCENT",
})
```

These entries appear in the same bottom list as Damage Multiplier, Radius, and
Duration. The game continues to own layout, localization, units, icons,
base/modded presentation, comparison arrows, and green/red formatting.

The displayed values and gameplay values must come from the same generated
stat definitions and formulas. For every custom stat the editor records:

- its base value;
- whether Strength, Duration, Range, Efficiency, or no mod family affects it;
- its gameplay expression;
- its card-display expression;
- label, unit, optional icon, rounding, and ordering.

When `_T.AbilityLevelQueryParms.Modded` is true, the native row uses the same
modified value used by gameplay. When false, it uses the base value. A value
that gameplay intentionally leaves unmodified must remain unchanged in both
views; the card must never imply scaling the ability does not actually use.

The attempted `_T.RENOVICE_AUGMENT_ABILITY_CARD` bridge and borrowed-
environment/root-export decorators are retired. The later native card-result
adapter is live-certified for Mallet, but the gameplay owner bus is **live
refuted**: its target-addon environment contained no active `mOwner`, so it
never associated Mallet's `SetSourceObject` call and never installed the damage
callback. Loading an addon in a target VM/environment is not the same as
inserting it into the target module's call graph.

That owner-bus result is historical. The V43-V48 work implemented exact native
function-call interception and a content-keyed target-addon registry. V48
live-proved that one standalone `.target.addon.lua_B` can load against the
untouched stock module, publish card rows, receive a gameplay damage event, and
grant Overguard without a generated hook shim or support script. The current
timing policy remains rejected: `RadialDamage` batching produced late real
Overguard increments and must be replaced by immediate per-result callback
dispatch. See `NATIVE_TARGET_ADDON_HOOKS.md` and
`RESEARCH/V48_GAMEPLAY_TIMING_CLOSEOUT_2026-09-07.md`.

The canonical base/modded normalization, `Engine.UpgradedValue`, suit
`ModifyValue`, percent-unit conversion, clamping, and single-source gameplay/UI
pattern is documented in
[`CARD_UI/NATIVE_ABILITY_CARD_ROWS.md`](CARD_UI/NATIVE_ABILITY_CARD_ROWS.md).

## Minimal validation for a custom edit

Custom edits do not require a whole-corpus research run every time. Use this
short gate:

1. Recompile succeeds and the output reparses.
2. `derecomp de-roundtrip output.lua_B` reports `FULL BODY identical: True`.
3. For a full replacement, run `derecomp plan-verify output.lua_B` and require
   `failures=0` for every prototype.
4. Keep a known-working bytecode rollback.
5. Press F9 and require `RELOAD PASS`, not `ROLLBACK` or `FATAL`.
6. Test the intended behavior and one nearby stock behavior in game.
7. Read the current EE log for new script exceptions or crashes.

Corpus-wide evaluation belongs to decompiler R&D or a suspected shared
compiler defect. It is not the default acceptance test for every intentional
ability mod.

## Future C++ editor

The project-wide editor contract now lives in:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE\RENOVICE Ability Editor`

It defines the machine-readable project schema, quick/native/addon/card-attached
authoring modes, one-stat/multiple-projection model, evidence boundary, GUI
screens, deterministic build transaction, and quantified implementation
checklist. Mallet is retained only as the live-proven reference implementation.

The editor should sit above these already-proven mechanisms rather than invent
a second loader:

```text
Warframe metadata/cache decoder
  -> ability browser (name, description, script, identifier, icon/video)
  -> readable Luau editor with typed native API completion
  -> native ability stat-row editor
  -> description/localization editor
  -> build through derecomp recompile
  -> offline gates and rollback snapshot
  -> deploy to CustomScripts / Inject
  -> F9 reload and log result
```

The existing `WarframeMetaDataEditor` C# core is the authoritative reference
for current cache decoding. A C++ UI may port or invoke that proven logic, but
must preserve the directory-only TOC parent rule and snapshot/rollback design.
