# CustomScripts: current single-DLL layout

Repository copy (2026-09-29, branch `feat/multi-target-addon`). The copy in the
installed game folder is older. This folder is not packed into the DLL archive.

The source-built `wtsapi32.dll` reads this folder directly. The old
`wtsapi32_owf.dll` companion is not required.

| Kind | Location | Filename | Behavior |
|---|---|---|---|
| Full replacement | `CustomScripts\` | `<16-hex-content-key> (optional description).lua_B` | Replaces the whole matching stock DE Luau module the next time it loads. |
| Ordinary injection | `CustomScripts\Inject\` | `<name>.lua_B` | Runs once after a successfully committed startup or F9 generation. Its side effects cannot be undone automatically. |
| Managed addon | `CustomScripts\Inject\` | `<name>.addon.lua_B` | Returns `activate` and `cleanup` closures and takes part in transactional generation replacement. |
| Target addon (one module) | `CustomScripts\Inject\` | `<16-hex-content-key>.<Name>.target.addon.lua_B` | Bound to the module whose content key is in the filename. |
| Multi-target addon (several modules) | `CustomScripts\Inject\` | `<Name>.targets.addon.lua_B` (no key prefix) | One file, one Scripts row and one enable/disable state. The file binds to every module key it declares. |
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
  `settings`, is ignored by this runtime. These names are reserved for the
  future in-game (F12) settings overlay.

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
- **Lifecycle binding** follows the most recent root instance. There is one
  active binding per VM, module key and generation. When a target root returns
  in a new environment, the log shows `TARGET ROOT RETURN ... action=rebind-queued`.
  At the next exact idle return the previous binding is cleaned up and the addon
  runs and activates again in the runtime environment. That is where
  root-published module globals exist. As a result, an addon that reads module
  globals in `activate` can log one failed activation at load time, followed by
  a PASS after the root returns.

## Errors

Failures in lifecycle functions, chunk execution and `luaCalls.before` add a
bounded, sanitized copy of the Lua error, for example
`error_tag=5 error="...: RENOVICE_CIRCUIT_STAGE_XP_GETTER_NOT_FUNCTION"`. This
is operational error reporting and appears even with `Diagnostics=false`.

## F9 transaction

F9 does not poll the folder. When pressed, it reads the current `renovice.cfg`,
SWFs, full replacements, `riven_lock.cfg`, `ScriptStates.json` and the whole
`Inject` folder. It validates and stages them, cleans up the old managed
generation, activates the new one, and only then publishes the prepared
snapshots. If a managed generation fails, it tries to roll back to the
previous one. For multi-target files, the inventory of declared keys is part
of that same snapshot.

## Configuration and logs

- `renovice.cfg` supports `Logging`, `Verbose`, `Diagnostics` and `AutoSpawn`.
- If `riven_lock.cfg` exists, the Riven lock UI system is enabled.
- Source messages go to `CustomScripts\Logs\renovice_source.log` when logging
  is enabled.
- Near-null runtime faults go to `Logs\renovice_fault.log`, with a minidump at
  `Diagnostics\renovice_fault.dmp`.

Close the game before you replace `wtsapi32.dll`. You can stage script and
config changes while the game is running and apply them with F9, within the
module and event lifetime limits described above.
