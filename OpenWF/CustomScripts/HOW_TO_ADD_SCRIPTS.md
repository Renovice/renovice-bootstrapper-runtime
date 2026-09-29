# CustomScripts: current single-DLL layout

Repository copy (2026-09-29, branch `feat/script-packages-2026-09-29`). The copy
in the installed game folder is older. This folder is not packed into the DLL
archive.

The source-built `wtsapi32.dll` reads this folder directly. The old
`wtsapi32_owf.dll` companion is not required.

| Kind | Location | Filename | Behavior |
|---|---|---|---|
| Full replacement | `CustomScripts\` | `<16-hex-content-key> (optional description).lua_B` | Replaces the whole matching stock DE Luau module the next time it loads. |
| Ordinary injection | `CustomScripts\Inject\` | `<name>.lua_B` | Runs once after a successfully committed startup or F9 generation. Its side effects cannot be undone automatically. |
| Managed addon | `CustomScripts\Inject\` | `<name>.addon.lua_B` | Returns `activate` and `cleanup` closures and takes part in transactional generation replacement. |
| Target addon (one module) | `CustomScripts\Inject\` | `<16-hex-content-key>.<Name>.target.addon.lua_B` | Bound to the module whose content key is in the filename. |
| Multi-target addon (several modules) | `CustomScripts\Inject\` | `<Name>.targets.addon.lua_B` (no key prefix) | One file, one Scripts row and one enable/disable state. The file binds to every module key it declares. |
| Script package (optional) | `CustomScripts\Packages\<Name>\` | replacement and target-addon members, optional `package.json` | Several files, one `[PACKAGE] <Name>` row and one state `package:<name>`. Loose files are unaffected. See "Script packages". |
| SWF replacement | `CustomScripts\` | `<name>.swf` | Replaces a matching uncompressed FWS body by content key. |
| Growing SWF metadata | `CustomScripts\` | `<name>.swf.toc` | Optional exact cache-TOC metadata, needed when a replacement is larger than the original. |
| Current logs | `CustomScripts\Logs\` | `renovice_source.log`, `renovice_fault.log` | Loader, addon and F9 evidence, plus native near-null fault records. |
| Historical logs | `CustomScripts\Logs\Legacy\` | old `wf_*` logs and `DEBUG_LOG` | Old evidence. The current DLL does not write to them. |
| Diagnostics | `CustomScripts\Diagnostics\` | dumps and captured bytecode | Crash and research evidence. The loader does not treat these files as root replacements. |

All `.lua_B` files are precompiled DE Luau bytecode, not Lua source. Scripts
are opt-in: nothing in this list is installed by default.

## Full-module replacements

The loader hashes each original bytecode body with FNV-1a-64: offset basis
`1469598103934665603`, prime `1099511628211`. Text after the first 16 hex
characters of the filename is allowed. A replacement may be a different size
from the original. To revert, delete the file and reload the stock module.

F9 rereads the whole replacement map atomically. A stock module that is already
cached keeps its current closure. A changed replacement applies the next time
the matching module loads, which usually means after a relevant transition or a
restart.

## Ordinary Inject files

An ordinary `Inject\<name>.lua_B` chunk loads with the real DE global
environment and runs under a protected call and a native fault boundary. Its
borrowed module-registry entry and VM stack top are restored afterwards. These
scripts run once. The loader cannot undo callbacks or resources they install,
so use the managed format for anything that must be reversible.

## Managed addons

A managed filename contains `.addon` and ends in `.lua_B`. The bootstrap should
only validate and build state, then return one table:

```lua
local active = false

local function activate()
    if active then return end
    active = true
    -- Install this generation's callback, listener or resource.
end

local function cleanup()
    if not active then return end
    -- Remove only what this generation owns.
    active = false
end

return {
    activate = activate,
    cleanup = cleanup,
}
```

Both functions must take no arguments, must not yield, and must be safe to call
repeatedly. `cleanup` must cope with a partial activation. `activate` must cope
with being called again during a rollback.

Files containing `.persist` or `.spawn` are rejected. Those names came from the
retired fabricated-scheduler experiment and must not come back.

## Target addons (one module)

`Inject\<16-hex-content-key>.<Name>.target.addon.lua_B` is loaded in the target
module's environment each time that module loads (lazy binding). Target module
keys are recorded even while the addon is disabled, so enabling it later needs
no restart. The returned table has the managed `activate`/`cleanup` pair plus
optional `hooks`:

```lua
return {
    activate = activate,
    cleanup = cleanup,
    hooks = {
        luaCalls = { [61] = { before = function(prototype, args, upvalues, trace) end } },
        nativeCalls = { BuildMissionForLocation = {
            after = function(prototype, instruction, args, results, trace) end } },
        -- matchesAbility, afterAbilityCard, afterDamage, transformFloatArgument
    },
}
```

`luaCalls[P].after` is rejected, because exact return/yield/error retirement
has not been implemented.

## Multi-target addons (several modules, one Scripts row)

Use this when one feature, for example a single "Missions" script, has to touch
several modules. Name the file `Inject\<Name>.targets.addon.lua_B`, with no key
prefix. Return a container with a `targets` table keyed by exact lowercase
module content keys:

```lua
local function noop() end

return {
    -- Optional defaults. An entry that leaves activate/cleanup ABSENT uses these.
    activate = noop,
    cleanup = noop,
    targets = {
        ["f10a043e7f825db2"] = {            -- SurvivalMission (44.0.2)
            hooks = { luaCalls = { [61] = { before = function(p, args, up) end } } },
        },
        ["6fa60841c9e0f207"] = {
            activate = function() end,      -- per-module lifecycle overrides the default
            cleanup = function() end,
            hooks = { luaCalls = { [79] = { before = function(p, args, up) end } } },
        },
    },
}
```

Rules, all checked by the loader:

- **Declaration.** Every string constant in the file that is exactly 16
  lowercase hex characters is a declared target. The `targets` keys are exactly
  those strings, so the file itself is the manifest. Do not put any other
  lowercase 16-hex string in the file. Write keys in lowercase; uppercase
  strings are not declarations. At most 1,024 targets are allowed per file.
- **File-level problems fail locally.** These are: a key prefix on the
  filename, unreadable bytes, no declared keys, a zero key, or too many keys.
  The file shows as INVALID in the Scripts menu, the log gets
  `MULTI-TARGET ADDON REJECT file=... reason=...`, and every other script in the
  generation still loads.
- **One binding per key.** Each declared key binds lazily when that module
  loads. The whole chunk runs in that module's environment and
  `targets["<key>"]` becomes that binding's addon table. VM ownership,
  generation ownership, F9 behavior and retirement are exactly the same as for a
  single-key target addon.
- **Per-target failures stay local.** A missing `targets[key]`, a non-table
  entry, a top-level `hooks` (put hooks inside each entry, because prototype IDs
  belong to one module), or a lifecycle field that is present but is not a
  function rejects only that key's binding. The log says
  `Inject FAIL ... target=<key> multi_target_reason=<reason>`. The other keys
  still bind.
- **Lifecycle inheritance.** An entry `activate`/`cleanup` that is a function
  wins. If the entry field is absent, the top-level function is used. Hooks are
  never inherited.
- **One row, one policy.** The Scripts menu shows one row, `[ADDON] <Name>`,
  with the tooltip `target N modules`. The single state ID
  `target-addon:<filename lowercased>` enables or disables every target.
- **Reserved names.** Any other top-level or entry field, such as `label` or
  `settings`, is ignored by this runtime. Settings for the in-game editor are
  declared in a package's `package.json` instead (see "Script settings").

## Script packages (optional folders, one Scripts row)

A package bundles several scripts behind **one** Scripts row, but only when you
choose to: put them in their own folder. Loose files keep working exactly as
before (same discovery, same state keys, same behavior). The loose scanners
never look inside subfolders, so a package member is never loaded twice.

```
CustomScripts\
  Packages\
    Missions\
      package.json                                          (optional)
      Missions.targets.addon.lua_B                          multi-target addon
      fc711ff621a75552 (missions_exact-replacement).lua_B   exact replacement
```

**Members.** Every `.lua_B` file directly in the folder is a member and loads
through its normal lane with the normal validation:

| Member file | Lane |
|---|---|
| `<16-hex key> (label).lua_B` | exact root replacement, keyed by the filename prefix |
| `<16-hex key>.<Name>.target.addon.lua_B` | single-key target addon |
| `<Name>.targets.addon.lua_B` | multi-target addon (declared keys from the bytecode) |

Not admissible (the package is rejected with an exact reason):
- an ordinary one-shot chunk (`<name>.lua_B` without a key): it cannot be
  undone, so it cannot be part of an all-or-nothing package;
- an untargeted managed addon (`*.addon.lua_B`): it shares one generation-wide
  staging/activation transaction with every loose managed addon, so its failure
  could not stay local to the package. Keep those as loose files.
- `.spawn`/`.persist` names and bootstrapper infrastructure files.

Other files (README, checksums) are ignored. Subfolders are ignored.

**`package.json`** (optional, strict JSON, at most 512 KiB):

```json
{
  "schema": 1,
  "name": "Missions",
  "description": "Shown in the tooltip.",
  "members": {
    "Missions.targets.addon.lua_B": { "label": "Mission tunables" },
    "fc711ff621a75552 (missions_exact-replacement).lua_B": { "label": "Void Flood fractures" }
  },
  "settings": {}
}
```

- Every field is optional. `name` (1-64 printable characters) replaces the
  folder name in the row label; `description` (up to 1,024 characters) and the
  member `label`s (up to 128) go into the tooltip.
- If `members` is present, the folder must contain **exactly** those `.lua_B`
  files (case-insensitive). A partially copied package fails as a whole.
- `settings` (top level and per member) declares editable values; see
  "Script settings" below. `"settings": {}` declares nothing.
- Unknown fields, duplicate fields, a `schema` other than 1, and trailing data
  reject the package. A per-member `enabled` field is rejected: member on/off is
  enable policy and lives in `ScriptStates.json` as `member:` (below).

**Scripts menu.** One row, `[PACKAGE] <name>`, tooltip
`PACKAGE | <description> | N members: <label> (<file>), ... | <status>`. One
state, `package:<folder name lowercased>`, enables or disables every member.
Status `INVALID: <reason>` means the package failed static validation;
`BLOCKED: <reason>` means it is enabled but conflicts with another source.

**All or nothing.** At startup and on every F9 the loader scans the Packages
folder once, validates every package, and hands the same result to both the
replacement lane and the Inject scanner of that transaction. A package with any
invalid member, a manifest mismatch or a conflict contributes **nothing**; the
log says
`RENOVICE PACKAGE REJECT trigger=... package=<name> ... reason=<exact reason> scope=package-local generation=continues`,
and every other script and package still loads. Deletion is part of the
snapshot: remove the folder and press F9.

**Conflicts.** Two sources that would both apply the same exact replacement
key, or both bind addons to the same target key, conflict when at least one of
them is a package. Loose files sort first, packages after them by lowercase
folder name, and the later-sorted source (the package, or the later package)
fails closed as a whole with
`reason=conflict kind=replacement|target key=<key> holder=<loose:file|package:name>`.
Both are never applied. Only enabled sources count, so disabling the loose file
(or removing it) resolves the conflict on the next F9. Loose-vs-loose behavior
is unchanged.

**Runtime binding stays per module.** A package's target members bind lazily
per module like any target addon. A binding that fails later, at a module load
(for example `targets[key]-missing`), fails for that key only, with the usual
`Inject FAIL ... target=<key>` line; it does not unload the package's other
members. "All or nothing" covers the static F9/startup commit.

**Disabled packages** keep their keys inventoried (like a disabled loose file),
so enabling one later works without a restart.

**Member switches.** `ScriptStates.json` may also hold
`"member:<folder lowercased>/<member file lowercased>": false`. That member stays
validated and inventoried but never enters its lane; the other members load
normally (`RENOVICE PACKAGE MEMBER DISABLED …`). Member rows are not SCRIPTS
rows; edit them in SCRIPT SETTINGS or by hand, then press F9.

## Script settings (ADDON_SETTINGS_V1, package members only)

A package can declare values that the player edits in game (pause menu →
**SCRIPT SETTINGS**) or by hand. Loose files and packages without declarations
are unchanged.

**Declarations** (written by the generator, read-only at runtime), in
`package.json`:

```json
"settings": { "format": "RENOVICE_SETTINGS_DECL_V1", "build": "2026.09.28.13.06",
  "groups": [ { "id": "survival", "label": "Survival", "order": 10, "aliases": ["Hell-Scrub"] } ] },
"members": { "Missions.targets.addon.lua_B": { "settings": { "values": {
  "survival.reward_interval": { "group": "survival", "label": "Reward interval", "unit": "s",
    "type": "float", "stock": 300, "min": 1, "max": 3600, "scope": "All Survival nodes",
    "lane": "addon", "applies": "live_next_read" } } } } }
```

`type` is `int`, `float` or `enum` (enum adds `options: [{label, value}]`),
`lane` is `addon`, `literal` or `metadata`. A declaration error disables only
the settings of that package (`RENOVICE SETTINGS DECLARATIONS REJECT …`); its
scripts still load with their compiled values.

Optional `stock_check` (addon lane only; since bootstrapper 2026-09-30,
`feat/ingame-settings-editor` after `7028479`) says how the addon guards a
custom value. It only changes the SCRIPT SETTINGS tooltip; the addon still owns
the rule.

- `"live"` (the default when absent): the addon writes the value only where the
  live game value still equals stock, for example generated data-table writes.
  The tooltip ends with "Custom value applies only where the live value equals
  stock."
- `"none"`: the addon applies the value itself without comparing it to a live
  value, for example a native argument transform or a damage rewrite. The
  tooltip omits that sentence.

A DLL built before the field existed rejects it as an unknown field, which
disables only that package's settings (compiled values).

**Values** (player state), `CustomScripts\Settings\<package folder>.json`:

```json
{ "format": "RENOVICE_SCRIPT_SETTINGS_V1", "package": "package:missions",
  "build": "2026.09.28.13.06", "use_stock": false,
  "groups": { "survival": true },
  "values": { "survival.reward_interval": { "enabled": true, "value": 150 } } }
```

- A value applies only when the file is valid, `use_stock` is false, its group
  is not `false` (a missing group means on), `enabled` is true and the value is
  in range. Anything else is stock. A missing file means everything is stock.
- A malformed file makes that package stock (`RENOVICE SETTINGS FILE REJECT`);
  a bad entry makes only that value stock (`RENOVICE SETTINGS VALUE REJECT`).
- After a client build change, a value is kept only if its recorded `stock`
  equals the new declaration (SCRIPT SETTINGS records it on save).
- A replacement member with `literal` values is loaded only while at least one
  of its values is enabled and `use_stock` is false.

**What the addon receives.** `activate(context)`, with a fresh table per
generation: `context.settings[id] = { enabled = true, value = <number>, stock = <declared stock> }`
for each value that applies. A value that does not apply is absent. Addons
without declarations get `activate()` exactly as before. Changing only the
values re-runs `cleanup` + `activate` on the next F9 even though the bytes are
the same.

**SCRIPT SETTINGS** (pause menu, directly under SCRIPTS). One native list:
package switch, `Use stock values`, member switches, then one section per group
with `Custom <section> values` and, per value, `Custom <label>` plus its editor.
Clicks only stage; closing the screen writes the file(s) and runs the normal F9
transaction. `SettingsMenuNested=true` in `renovice.cfg` switches to nested
pages (only after the Phase 0 probe proved nested screens).

## Reserved internal names

Files named `_RENOVICE_INTERNAL_*` in `Inject` are bootstrapper infrastructure:
the SCRIPTS bridge (`…ScriptsSettingsBridgeV10.lua_B`) and the optional SCRIPT
SETTINGS bridge (`…ScriptSettingsBridgeV1.lua_B`). They never appear in SCRIPTS
and never run as one-shots; unknown reserved names are ignored.

## Module instances and environments

DE loads a module and later runs its root in a runtime environment. That
environment can differ from the one the loader recorded. The runtime handles
this generically for single-key and multi-target addons alike:

- **Hooks keyed by prototype** (`luaCalls`, `nativeCalls`) dispatch for every
  instance of the module. They match by exact VM plus a live, registry-pinned
  prototype identity. Each call gets that call's own arguments and upvalues, so
  an addon must not assume there is only one instance. If it keeps
  per-instance state, it should key that state by the upvalue or table
  identity it receives.
- **Lifecycle binding is made once**, like a native hook: one binding per VM,
  module key and generation, normally at the module load. Later root instances
  of a bound module do nothing: no rebind, no `activate`/`cleanup` cycle, no log
  line. (The first live run showed why: Ice Wave's `IceSpike.lua` root ran 3,470
  times in one session, and each instance paid a full clean-load-activate.)
- **One root-return retry for an unbound module.** If a module's addons hold no
  binding (for example `activate` failed because it reads globals that the root
  publishes), the runtime watches that module's root once per generation. At
  the root's normal return it binds in the environment the root **published
  into**: the environment of the functions the root itself defined (read from
  the closures still in the root's register window; they must all agree),
  otherwise the root closure's own environment. This is how
  `module(..., package.seeall)` modules work: on 44.0.2 DuviriUtil's root closure
  kept its entry environment, while its functions resolve their globals
  elsewhere. The log shows
  `TARGET ROOT RETURN ... runtime_env=... env_source=child-closure|root-closure child_closures=N reason=unbound retry=once-per-generation action=rebind-queued`,
  then the addon runs and activates there at the next exact idle return. Such an
  addon logs one failed activation at load time, followed by a PASS.
- An addon that needs a fresh lifecycle for every instance is not supported
  as a lifecycle feature. Derive the instance from each hook call's arguments or
  upvalues instead (see above).

## Errors

Failures in lifecycle functions, chunk execution and `luaCalls.before` add a
bounded, sanitized copy of the Lua error, for example
`error_tag=5 error="...: RENOVICE_CIRCUIT_STAGE_XP_GETTER_NOT_FUNCTION"`. This
is operational error reporting and appears even with `Diagnostics=false`.

## F9 transaction

F9 does not poll the folder. When pressed, it reads the current `renovice.cfg`,
SWFs, full replacements, `riven_lock.cfg`, `ScriptStates.json`, the whole
`Inject` folder and the optional `Packages` folder. It validates and stages them, cleans up the old managed
generation, activates the new one, and only then publishes the prepared
snapshots. If a managed generation fails, it tries to roll back to the
previous one. For multi-target files, the inventory of declared keys is part
of that same snapshot.

## Configuration and logs

- `renovice.cfg` supports `Logging`, `Verbose`, `Diagnostics`, `AutoSpawn` and
  `SettingsMenuNested` (default `false`).
- If `riven_lock.cfg` exists, the Riven lock UI system is enabled.
- Source messages go to `CustomScripts\Logs\renovice_source.log` when logging
  is enabled. The file stays open while the game runs. Operational lines are
  written immediately; diagnostic lines are buffered (64 KiB, flushed at least
  every 250 ms, before every operational line, at exit and on a recorded
  near-null fault). In trace mode, per-hit lines (`damage.*`, `dispatch.*`,
  `native.*`, `lua.call.*`) are limited to 32 per event name per second, and
  each limited second ends with one `event=trace.rate-limited ... suppressed=N`
  summary line.
- Near-null runtime faults go to `Logs\renovice_fault.log`, with a minidump at
  `Diagnostics\renovice_fault.dmp`.

Close the game before you replace `wtsapi32.dll`. You can stage script and
config changes while the game is running and apply them with F9, within the
module and event lifetime limits described above.
