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

A `luaCalls[P].before` callback may return the exact string
`"RENOVICE_RETIRE"` to stop being dispatched for the current module instance,
or `"RENOVICE_RETIRE_ALL"` (optional, R4) to retire every hook of the addon for
that instance. See "Retire after use" below. Any other return value, including
none, is ignored, as before.

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
- SCRIPT SETTINGS shows each member `label` on one row of **40 characters**.
  Keep member labels within 40 and human-readable (for example
  `Void Flood (script replacement)`); a longer label is cut at a word there.
  The row tooltip adds the full label, the file and the member's declared
  values per section.
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

**SCRIPT SETTINGS** (pause menu, directly under SCRIPTS). Like Risk of
Options, the top page only lists the packages that declare settings. A package
opens its own page: the package switch, `Use stock values`, member switches
(only with more than one member) and one button per section. A section page
holds `Custom <section> values` and, per value, `Custom <label>` plus a button
showing the current value; every number opens its own one-value page (an
INPUTCOUNT stepper for an `int` with `min >= 0`, a text box otherwise), an
`enum` stays a TOGGLE on the section page. Editing a value on its page turns
its `Custom` switch on; untick the switch to go back to stock (the value is
remembered). A value outside its range is refused with the row's own stock
message, on Confirm and on Back. Clicks only stage; closing the top page writes
the file(s) and runs the normal F9 transaction. `SettingsMenuNested=false` in
`renovice.cfg` selects the older single flat list.

## Reserved internal names

Files named `_RENOVICE_INTERNAL_*` in `Inject` are bootstrapper infrastructure:
the SCRIPTS bridge (`…ScriptsSettingsBridgeV10.lua_B`) and the optional SCRIPT
SETTINGS bridge (`…ScriptSettingsBridgeV1.lua_B`). They never appear in SCRIPTS
and never run as one-shots; unknown reserved names are ignored.

## Script settings in a full replacement (REPLACEMENT_SETTINGS_V1)

Since bootstrapper `feat/replacement-settings-2026-09-30` (2026-09-30), a
**replacement member of a package** can read SCRIPT SETTINGS values too. Loose
replacement files get no settings.

**Declare** the values exactly as for an addon member: same `settings.values`
schema, validation, labels, stock values, SCRIPT SETTINGS rows and values file.
Use `"lane": "addon"` (the default); that lane means "read at run time by the
script". A replacement that declares only `literal` values is unchanged (it is
still switched by the literal-lane gate and reads nothing).

**Read** them with the global function `RENOVICE_SCRIPT_SETTINGS`:

```lua
local COMPILED = 10000          -- the value compiled into the replacement
local value = COMPILED
local accessor = RENOVICE_SCRIPT_SETTINGS          -- nil on older DLLs
if accessor ~= nil then
    local settings = accessor()                    -- nil: no settings for this module
    local entry = settings ~= nil and settings["hijack.payload_health"] or nil
    if entry ~= nil and entry.enabled == true and entry.stock == COMPILED
        and entry.value ~= nil then
        value = entry.value
    end
end
```

- `RENOVICE_SCRIPT_SETTINGS()` returns a **fresh** table
  `{ [id] = { enabled = true, value = <number>, stock = <declared stock> } }`
  (the same shape as an addon's `context.settings`), or nothing (`nil`).
- It returns `nil` when the member has no readable declarations, the package's
  declarations were rejected, or the module is not a staged package member. An
  empty table means the values file is missing or malformed, `use_stock` is on,
  or every value is off: keep your compiled values.
- Optional argument: `RENOVICE_SCRIPT_SETTINGS("<16-hex content key>")` names
  the replacement explicitly. Without it the accessor uses the key it was bound
  to. It exists for the case where two replacements share one module
  environment (the accessor is then unbound and needs the key).
- The table is yours; changing it changes nothing else. Treat values as
  read-only input.

**Where the accessor comes from.** At the natural load of a replacement whose
member has settings, right after DE's Loader has undumped the replacement and
before its root can run, the bootstrapper stores a C function under the DE
native-name hash of `RENOVICE_SCRIPT_SETTINGS` in the module's **load
environment** (the environment of the loaded root closure). That is where the
live-proven generic target dispatcher lives, and module code resolves globals
through it; a VM-global install is not visible to module code (V26/V27
records). The first live read by a replacement root is still pending. The same happens after an F9 refresh to
replacement bytes, and at every F9 commit for replacement modules this VM has
already loaded. It never overwrites a value it does not own under that name
(`RENOVICE REPLACEMENT SETTINGS ACCESSOR REJECT … action=rejected-foreign-value`).
A replacement without declarations: no entry, no VM write, byte-for-byte as
before.

**Lifetime.**

| Where your code reads | When a changed value applies |
|---|---|
| In a function, on each call (`RENOVICE_SCRIPT_SETTINGS()` inside the function) | **Live**: from the next call after the F9 / SCRIPT SETTINGS apply that committed it. |
| In the root chunk, stored in a local | At the **next root execution** of the module (for mission scripts: the next mission). The running instance keeps the values it read. |

- Every call reads the **committed** generation (startup scan, or the last
  successful F9). A prepared F9 that rolls back is never visible.
- Replacement bytes are unchanged by a settings apply, so no module refresh is
  triggered; there is no `activate`/`cleanup` for a replacement.
- Each call builds a new table (a few microseconds). Do not call it every
  frame; read it where the value is used once, or once per instance.
- Declare `applies` to match: `live_next_read` for per-call reads,
  `next_mission` for root-time reads.

**Fail closed.** Every failure keeps the compiled values: no declarations,
rejected declarations, malformed values file, disabled package or member, loose
file, a load before `DE_VM_AUTHORITY PASS` (the accessor appears at that
module's next load), or a load nested inside RENOVICE's own chunk execution
(`… ACCESSOR DEFER … reason=nested-renovice-execution`).

**Log lines** (operational): `RENOVICE REPLACEMENT SETTINGS ENTRY|COMMIT`
(startup and F9, only when some package has such a member),
`RENOVICE REPLACEMENT SETTINGS ACCESSOR PASS|REJECT|FAIL|DEFER trigger=load|F9-refresh|F9-commit …`
(once per install, never for an accessor that is already correct), and at most
16 `RENOVICE REPLACEMENT SETTINGS CALL FAIL` lines. With Diagnostics on, one
`RENOVICE REPLACEMENT SETTINGS READ key=… serial=… values=N` line per key and
committed generation proves the replacement called the accessor.

**Example and gate.** `RENOVICE_TOOLCHAIN/replacements/fixtures/replacement_settings/`
(Hijack payload health, content key `fb346b59e2b7687a`) and
`RENOVICE_TOOLCHAIN/replacements/verify_replacement_settings.ps1`.

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

## Retire after use (`luaCalls.before`)

A hook on a frequently called prototype often has a one-time job, for example
writing a value into the module's root table the first time it sees that table.
After that job is done, every further call would still pay the full dispatch
cost. The hook can retire itself instead.

**Signal.** Return the exact string `"RENOVICE_RETIRE"` (case-sensitive, 15
characters) from a `luaCalls[P].before` callback:

```lua
local RETIRE = "RENOVICE_RETIRE"
local bound = setmetatable({}, { __mode = "k" })

hooks = { luaCalls = { [67] = { before = function(prototype, args, upvalues)
    local root = upvalues[70]
    if type(root) ~= "table" then return end        -- not bound yet: stay armed
    if not bound[root] then
        bound[root] = true
        if root.interval == 300 then root.interval = 150 end
    end
    return RETIRE                                    -- this instance is done
end } } }
```

- Only a callback that **completes without error** can retire. The call that
  returns the sentinel is itself fully processed first (its argument and
  upvalue copy-back is applied as usual).
- Several addons can hook the same prototype of the same module. The prototype
  retires only when **every** callback that ran in the same dispatch returned
  the sentinel. An addon that returns nothing keeps the hook armed for all of
  them.
- `nativeCalls`, `afterDamage`, `matchesAbility`, `afterAbilityCard`,
  `transformFloatArgument` and lifecycle functions do not interpret the value.
  Retirement never affects them, other prototypes, other modules or other VMs.

**Scope: one module instance.** A module instance is one execution of the
module's root in one VM (for a mission script: one mission). The runtime
learns instances at the natural VM-execute entry of the module's recorded root
prototype and identifies each instance by the environment its closures were
created in (the environment the root published into, read at the root's normal
return). A prototype stays retired while every instance the runtime knows
about has returned the sentinel for it. Concretely, it is per
(committed generation, module key, VM, set of bound addons, prototype,
instance).

**Re-arm.** The hook is dispatched again, and must signal again, when:

- the module's root runs again in that VM (a new instance, for example the
  next mission). This re-arm happens at the root's entry, before any of its
  functions exist;
- F9 commits a generation (even with no file changes), or the module's addons
  are rebound, enabled or disabled;
- the set of declared hooks changes.

Re-arming is always safe: your callback sees the new instance's table, binds
it, and returns the sentinel again.

**Re-arm after F9 or SCRIPT SETTINGS (R4, dormant until the module runs).**
Module identities are kept for the whole session, so a module that ran in an
earlier mission is still known after the next F9 or settings apply. Its hooks
therefore do not re-arm immediately. When the new generation replaces an
earlier one for the same module and VM, every retirable hook declared only by
addons that have already returned a sentinel for that module starts
**dormant**. A dormant hook holds no claim and does not keep the interrupt
observer open. It is armed again, before any of its code runs, by the first
natural VM-execute entry whose Lua call chain (the entered function and up to
seven callers) contains one of the module's functions other than its root.
For a mission this is the next engine callback or coroutine resume of the
running mission. Mid-mission F9 therefore still re-applies newly ticked values
within one tick. A module that is not running never wakes up and costs nothing.

- An addon that has never returned a sentinel keeps the R3 behaviour: its hooks
  start armed after every F9. A hook that is shared with such an addon also
  starts armed.
- Limit: a module whose functions run only from other modules' frames (a
  library called Lua-to-Lua, never entered from C) is woken at its next root
  entry instead. Do not retire from such hooks if a mid-mission F9 must apply
  immediately.

**Retire every hook of the addon at once (R4, optional).** A hook that finds
nothing to do for this instance (for example, no value enabled for this
mission type) can retire all of the addon's hooks for the instance, including
hooks that have not been called yet:

```lua
return "RENOVICE_RETIRE", "RENOVICE_RETIRE_ALL"   -- preferred: R3 runtimes read a plain retire
-- or
return "RENOVICE_RETIRE_ALL"                     -- R4 only; ignored (armed) by older runtimes
```

- It has the same scope and rules as `"RENOVICE_RETIRE"`: this generation,
  module, VM, addon set and instance. The calling prototype must itself be a
  retirable (top-level) prototype, otherwise the signal is ignored entirely.
  Every other retirable hook of the signalling addon is served for the instance.
  Nested prototypes and prototypes beyond the 64th stay armed.
- With several addons on the same module, a hook that is also declared by an
  addon that did not return retire-all in that dispatch stays armed. As for
  `"RENOVICE_RETIRE"`, nothing retires unless every callback that ran in that
  dispatch returned a sentinel.
- A new instance, F9 or rebind re-arms everything exactly as above.

**Requirements (fail closed).**

- Only a prototype whose closures the module **root** creates directly (a
  function defined at the top level of the module) can retire. A signal from a
  nested function's prototype is ignored and that hook stays armed.
- Retire only when the value you bound stays the one the instance uses. If the
  module can later replace the table your hook wrote into (for example by
  assigning a new table to the same top-level local from another function),
  do not retire from that hook.
- Instances that already existed before a generation's first dispatch (for
  example, F9 in the middle of a mission) are counted as one: the first signal
  for that prototype serves them. Instances that overlap in time (per-cast
  ability scripts) are tracked separately after that point.
- At most 16 instances are tracked per module and VM. Instances that have
  signalled every prototype that any instance has signalled are dropped first;
  if the ledger still overflows, retirement is disabled for that module until
  the next F9 (every hook stays armed).
- At most 64 declared prototypes per module can retire; later ones stay armed.

**Cost.** While every declared `luaCalls.before` prototype in the game is
retired or dormant, the interrupt observer returns after one atomic load (about
1 ns per Lua call in the gate micro-benchmark), exactly as if no hook were
declared. If another prototype still keeps the observer open, every Lua call
first passes the R4 armed-prototype prefilter: the callee's prototype is looked
up in a small lock-free set of armed prototypes, and a call that is not a
candidate returns before any `IsBadReadPtr` probe, snapshot lease or owner
search (about 3.5 ns in the gate benchmark, against 100 to 315 ns for the
pre-R4 path). Calls to an armed prototype, and any frame the prefilter cannot
prove, take the full validated path unchanged.

**Log.** With `Diagnostics` on, each state change writes one line:
`RENOVICE LUACALL_RETIRE event=retire key=... prototype=67 slot_dispatches=N dispatches_total=M instance=K ... outcome=retired`
(or `served-still-armed` when another instance still needs the hook), and one
`event=rearm ... outcome=root-entry-new-instance` line when a new instance
re-opens a retired prototype. R4 adds `event=retire-all` for the retire-all
signal, `event=wake ... outcome=execution-evidence-dormant-rearmed
evidence_proto=...` when a dormant module wakes, and `untracked_dormant=0x...`
on every line. An ignored signal (`ignored-prototype-not-root-child`,
`ignored-superseded-generation-or-binding`, `ignored-cross-vm`, ...) is reported
once per prototype. With `Diagnostics=false` nothing is formatted or written.

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
  `SettingsMenuNested` (default `true`; `false` selects the flat list).
- If `riven_lock.cfg` exists at game start, the Riven lock UI system is enabled.
  Without it the Riven lock is off and F9 works normally.
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
