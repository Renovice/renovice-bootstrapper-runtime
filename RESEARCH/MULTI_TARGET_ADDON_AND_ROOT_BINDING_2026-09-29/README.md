# Multi-target addons, target-root instance binding, luaCalls attribution (2026-09-29)

- Branch: `feat/multi-target-addon` in the bootstrapper-runtime repository,
  starting from `bcad39e` (`fix/44.0.2-de-vm-authority-lock-identity`, deployed
  DLL `15daf981…`).
- Target client: 44.0.2 (`2026.09.28.13.06`). The executable allowlist and all
  signatures are unchanged.
- Scope: repository only. Nothing was deployed, and no game or OpenWF server
  folder was written.
- Status: offline gates and the zero-warning build **PASS**. **All live
  checks are pending.**

## Why

The user chose option B: one generic primitive that lets one target-addon file
attach to several exact module content keys. The goal is a single **Missions**
row in the Scripts menu instead of one file and one row per mission module.
Later, the same script should be editable in game through an F12 overlay
(that overlay is not part of this change).

While this work was in progress, two parallel investigations found that the
same runtime boundary caused two live failures:

- **Survival:** the generated Survival addon attached but did nothing.
- **Circuit Progress Preview:** its `activate` was always rejected.

Both fixes went into this branch at the coordinator's request.

## Hypotheses and results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| H1 | One file can declare several targets without a sidecar manifest, because a `targets` table's constant keys are plaintext in the DE `09 03` string pool. | A fixture compiled with `derecomp recompile-u44` has the three keys in its pool. `discover_multi_target_keys` returns exactly those three. The uppercase note text is ignored. | **TRUE (offline)** |
| H2 | Expanding a file into one ordinary TargetManagedAddon binding per key keeps VM/generation ownership, F9, and retirement unchanged. | Every consumer keys state by `(target_key, VM, thread)` and a unique registry root per candidate. The Scripts inventory is per file, not per chunk. Source gates pass. | **TRUE (source)**, live pending |
| H3 | luaCalls never dispatched after V107 because `published_target_closure_is_live` requires `closure->env` to equal the environment recorded at load, while the module root runs in a different runtime environment. | TopMenu in the same 44.0.2 session: load env `…D8C0`, runtime env `…2660`. There are no `luaCalls`/`target-execution.enter` log events since V107 (2026-09-19); they exist before V107. The Survival addon logged TARGET ADDON PASS but had no effect. V110 needed the same fallback for damage. | **TRUE (static + log)**, live pending |
| H4 | Circuit `activate` fails because DuviriUtil's root publishes `EndlessGetXpForStage` in its runtime environment, and the addon ran in the load environment. | Parallel note `CIRCUIT_PROGRESS_PREVIEW_ACTIVATION_2026-09-29.md`. The addon bytes and the stock module are unchanged. | **TRUE (static + log)**, live pending |
| H5 | The Lua error for lifecycle failures cannot be observed. | `lifecycle_operation_protected_leaf` restored the stack and discarded the error value. | **TRUE**, now fixed |

## Implementation (generic; no module-, mission-, or ability-specific C++)

### 1. Multi-target addon

This is the new file format; its contract is in `OpenWF/CustomScripts/HOW_TO_ADD_SCRIPTS.md`.

- **Filename.** `Inject\<Name>.targets.addon.lua_B`. It is classified as
  TargetManagedAddon. `target_addon_key` rejects it, so it never binds through
  a filename prefix. A file with a key prefix is rejected with
  `multi-target-filename-has-key-prefix`.
- **Scanner** (`scan_snapshot`). The scanner reads the bytes even when the file
  is disabled (inventory only, no execution) and discovers the declared keys.
  They are added to the observed target keys before the enable policy is
  applied, then expanded into one `Chunk{kind=TargetManagedAddon,
  target_key=K, multi_target=true}` per key. File-level faults log
  `MULTI-TARGET ADDON REJECT file=… reason=… scope=file-local generation=continues`
  and skip only that file:
  - no keys, a zero key, or more than 1,024 keys;
  - a container that is not `09 03`, or a truncated string pool;
  - an unreadable file or a key prefix.
- **Protected module-load leaf** (`MULTI_TARGET_SELECTION`, destructor-free,
  slots +1..+4 inside `check_stack(8)`). The container returned by the chunk is
  replaced by `container.targets["<key>"]` *before* the unchanged lifecycle-root
  storage and hook-contract validation.
  - Entry `activate`/`cleanup` wins. A field absent from the entry inherits the
    top-level function; a present non-function is rejected. Hooks never inherit.
  - Top-level `hooks` is rejected.
  - Failures reject only that key's binding and log
    `Inject FAIL … target=<key> multi_target_reason=<label>`, where label is one
    of: `returned-value-not-table`, `top-level-hooks-not-allowed-use-targets[key].hooks`,
    `targets-not-table`, `targets[key]-missing`, `targets[key]-not-table`,
    `activate-…`, `cleanup-…`.
- **Scripts menu.** One row, `[ADDON] <Name>`, tooltip `target N modules`. One
  policy ID, `target-addon:<file lowercased>`.

### 2. Target-root instance binding

- **Watch set.** `publish_target_execution_snapshot_locked` publishes the
  loader-recorded root prototypes of modules that have enabled target addons
  (`roots`), and sets the lock-free gate `target_root_watch_enabled`.
- **At VM execute entry.** `inspect_target_root_entry` matches the exact VM and
  the loaded root proto, then captures a POD `{key, vm, proto, env}`. The lease
  is released before the naked stock call.
- **At normal return only.** `queue_target_root_return` records the entry under
  its own bounded mutex. It never touches the VM or generation locks, and it
  holds at most 64 entries, deduplicated per VM×proto.
- **At the next exact idle return, with `lua_execution_depth == 0`.**
  `apply_target_root_returns` runs `record_target_root_return`, which is
  unit-tested:
  - Same environment as the latest identity: no-op.
  - Otherwise: it adds one runtime identity (a copy of the load identity with
    the runtime env), replaces any previous runtime identity of that load, and
    queues one refresh per `(key, VM, thread)`.
  - It then republishes the snapshot and logs
    `TARGET ROOT RETURN key=… load_env=… runtime_env=… action=rebind-queued`.
- **Activation.** `activate_target_addons_locked` executes chunks in the latest
  identity's environment (`run_chunk` → guarded leaf `exact_environment`).
  `TargetAddonRecord.bound_environment` is part of the exact-reuse test, so a
  new instance environment forces clean-then-activate instead of root reuse.
- **Load-time binding is kept.** It still runs, so the first ability-card query
  is still served synchronously, and modules whose root runs in the load
  environment behave exactly as before.

### 3. luaCalls attribution

`target_lua_call_for_published_closure` now uses `select_target_prototype_owner`
(unit-tested):

- Match by the same VM and a recorded, registry-pinned, live prototype (code
  pointer, instruction count, bytecode ID, and a root with no parent).
- A strict environment match is preferred and reported.
- A closure claimed by different keys is ambiguous and rejected.

Hooks keyed by prototype therefore dispatch for **every** instance of a module.
Damage attribution keeps its existing strict-then-V110 path.

### 4. Bounded error text

`capture_lua_error_text` is noexcept, uses a fixed buffer and no destructors,
and sanitizes the text (192 bytes). It is called before stack restoration in:

- the lifecycle leaf (`addon lifecycle FAIL … error_tag=… error="…"`);
- the guarded chunk run (`Inject FAIL … error=`);
- the luaCalls.before leaf, in the existing sampled
  `luaCalls.before protected leaf FAIL` line.

This is operational reporting, not diagnostics.

## Instance and ownership model

| Object | Owner | Lifetime |
|---|---|---|
| Native detours | process | never retired by F9 (unchanged) |
| Load identity (key, VM, load env, root proto, pinned proto graph) | VM | kept for the session (unchanged) |
| Runtime identity (the same, with the runtime env) | VM × load | replaced by the next root instance of that load |
| Target binding (registry root, `bound_environment`, generation) | VM × key × generation | cleaned on rebind, disable, removal, or F9 replace; in-flight calls finish on the retained generation |
| luaCalls/nativeCalls dispatch | exact prototype + VM | every live instance of the module |

Multiple instances of the same module, across missions or transitions:

- Dispatch works for all of them.
- The lifecycle (`activate`/`cleanup`) follows the most recent root instance,
  with one binding per VM×module×generation.
- Addons must derive the instance from each call's arguments and upvalues, and
  must not assume one owner. The current generated mission addons assert
  "owner changed" on a second instance; the generator contract below changes
  that.

## Contract for the mission generator (ability-editor `feat/universal-mission-registry`)

This is the exact output the generator must produce so it can be integrated
later. It is not implemented in this repo.

1. **One file.** Emit `CustomScripts\Inject\Missions.targets.addon.lua_B`: no
   key prefix, DE bytecode compiled with the same U44 pipeline as today
   (`derecomp recompile-u44`), smaller than 1 MiB. The Scripts row is
   `[ADDON] Missions`. The policy ID is
   `target-addon:missions.targets.addon.lua_b`.
2. **Returned value.**
   ```lua
   return {
     activate = function() end,   -- optional shared default
     cleanup = function() end,    -- optional shared default
     targets = {
       ["<key>"] = {              -- one entry per mission module
         -- activate/cleanup: optional per-module overrides
         hooks = { luaCalls = { [P] = { before = function(prototype, args, upvalues, trace) ... end } } },
         -- label = "Survival",   -- reserved for the F12 overlay; ignored today
         -- settings = { ... },   -- reserved for the F12 overlay; ignored today
       },
     },
   }
   ```
3. **Keys.** Each key is the exact lowercase 16-hex FNV-1a-64 of the current
   build's stock module body (for example `f10a043e7f825db2`,
   `6fa60841c9e0f207`, `caec63d8e739b693`). Every lowercase 16-hex string
   constant in the file **is** a declared key and needs a `targets` entry. Do
   not put module keys in lowercase in messages or asserts; uppercase is
   ignored. There is no top-level `hooks`.
4. **Hooks.**
   - Prototype IDs must exist exactly once in their module. Otherwise that
     key's binding is rejected (`luaCalls prototype rejected … matches=N`),
     and only that key is affected.
   - `before` only; `after` is rejected.
   - Scalar copy-back only with the same tag and a finite value (unchanged
     rules).
5. **Instances.**
   - Do not cache a single owner table across calls, and do not assert
     "owner changed".
   - Resolve the table or values from each call's `upvalues`/`args`. If
     per-instance state is needed, key it by that table's identity; a weak-keyed
     table is acceptable.
   - The chunk runs once per binding, in that module's environment, so
     top-level locals are per module and not shared across targets.
6. **Lifecycle.** `activate`/`cleanup` take no arguments, do not yield, are
   idempotent and repeatable, and tolerate a rollback. They can run once at
   module load and again after the root returns.
7. **Migration.**
   - Stop emitting the per-module `<key>.missions.target.addon.lua_B` files.
     Otherwise both files bind and the hooks run twice.
   - Old `ScriptStates.json` IDs become orphans. That is harmless; they can be
     removed.
   - Keep `renovice.target.lua_call` as not live-confirmed (`HOOK_UNPROVEN`)
     until the user's live check below passes.
8. **Replacements** (for example the Void Flood fracture count) stay in the
   separate root-replacement lane. They are not part of this file.

## Offline gates (all PASS)

| Gate | What it covers |
|---|---|
| `RENOVICE_TOOLCHAIN/injection/verify_injection_core.ps1` | Multi-target classification, legacy single-key addons (Mallet, Ice Wave, ESO, Circuit, missions), pool discovery (valid, zero, truncated, non-DE, unterminated, too many, uppercase ignored), selection model, root-return model, SurvivalMission prototypes 31/33/55/58/60/61/62/67/68/69 attributed from a runtime-env closure, an unrelated module, wrong VM, dead or unknown prototype, ambiguity, and error-text sanitizing. |
| `RENOVICE_TOOLCHAIN/scripts_ui/verify_scripts_ui_core.ps1` (77 checks) | One row `[ADDON] Missions`; one policy ID; unchanged single-key display names. |
| `RENOVICE_TOOLCHAIN/injection/verify_multi_target_addon.ps1` (new; in the build) | Real U44 DE fixture and the live probe run through the loader's discovery code; leaf, scanner, activation, and Scripts inventory source invariants. |
| `RENOVICE_TOOLCHAIN/runtime/verify_target_root_binding.ps1` (new; in the build) | Real 44.0.2 SurvivalMission (`f10a043e7f825db2`, 80 prototypes) and unrelated Arbitration (`2c6c686109fb50ec`) modules from `shared/corpus/de-luau-u44.0.2-authoring` (read-only); vm_execute ordering, the naked stock call, bounded POD queue, idle-only apply, env-forced rebind, prototype attribution, and error capture before restore. |
| Existing gates | Manifest, dependencies, all runtime raw-protection, longjmp, generation-ownership, diagnostics-master, loader, lifecycle, lua-call raw protection, legacy UI VM, and target export hook. |

Build: `RENOVICE_TOOLCHAIN/build_private.ps1`, the `-O3` private configuration
that produced the deployed DLLs. It printed `PRIVATE BUILD PASS warnings=0
errors=0 x64=yes companion_import=no`.

- DLL: `work/staging/bootstrapper-multitarget-addon/wtsapi32.dll`, 4,921,344 bytes.
- SHA-256: `83e74faf399bccb33306fa19d225b5cfb59a935496e7bced9bdd30723efd51a9`.
  The hash is specific to this build instance, because the archive is
  time-versioned.
- Opt-in live probe:
  `work/staging/bootstrapper-multitarget-addon/opt-in-live-probe/Inject/MultiTargetProbe.targets.addon.lua_B`,
  280 bytes, SHA-256
  `76857273f36a539b069b081b4fc0a194c29e3cf87a60047aced02f1fc2e8056a`. It has no
  hooks and no gameplay effect.

## Rejected designs

- **Sidecar manifest.** Two files to install, and the declared keys and the
  returned table could disagree.
- **Key list in the filename.** Runs into MAX_PATH with about 20 modules.
- **Running the chunk in a sandbox at scan time to read `targets`.** That would
  execute disabled addon bytecode, and it has no module environment.
- **Deferring all activation to root return.** It would break the synchronous
  first ability-card query that Mallet relies on.
- **Binding only the first runtime environment per load.** It goes stale when a
  cached module's root runs again for the next mission.
- **Moving activation to root return without changing luaCalls attribution.**
  The ability-editor investigation showed this does not fix Survival dispatch.

## Limitations (exact)

- **One lifecycle binding at a time.** Only the most recent root instance per
  VM×module holds a lifecycle binding; concurrent instances do not get separate
  `activate` calls. Dispatch still reaches every instance.
- **Rebind cost when a root runs per instance.** If a module's root runs once
  per instance (possibly ability modules), each new instance costs one rebind
  (clean, run chunk, activate) at an idle return. Watch the Mallet and Ice Wave
  logs for repeated `TARGET ROOT RETURN` lines.
- **Addons that read root-published globals** log one failed load-time
  activation (now with the error text) before the root-return PASS.
- **False-positive declarations.** A lowercase 16-hex constant that is not a
  `targets` key becomes a declared key and fails locally with
  `targets[key]-missing` when that module loads. Any other addon bound to the
  same key in that transaction rolls back with it; this is the existing
  per-key transaction rule.
- **Late additions.** A target key added by F9 after its module already loaded
  binds on that module's next natural load. This is unchanged behavior.

## Live checks (the user runs these by hand; none are done yet)

See the handoff entry in `RENOVICE_SCRIPTING/CURRENT_BOOTSTRAPPER_STATE.md`.
