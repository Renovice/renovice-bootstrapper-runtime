# Script settings for full replacements: REPLACEMENT_SETTINGS_V1 (2026-09-30)

- Branch: `feat/replacement-settings-2026-09-30`, rebased onto `0afb9cd` (Settings R5,
  `fix/settings-r5-apply-riven-nested-2026-09-30`, itself on `1a67d99`). The DLL below contains R5.
- Client: 44.0.2 (`2026.09.28.13.06`), native-name seed `768e5ed0`.
- Scope: repository only. Nothing was deployed or pushed; no game, OpenWF server or `renovice.cfg`
  file was written. Installed logs were read (read-only) for evidence.
- Status: offline gates and the zero-warning private build **PASS**. **Every live check is pending.**

## Requirement

SCRIPT SETTINGS should be a universal in-game config framework for every script kind, like
"Risk of Options". ADDON_SETTINGS_V1 only delivered values to addon members (`activate(context)`).
A full content-key replacement has no lifecycle, so it could not read its package's values.

## Hypotheses and results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| H1 | A replacement member can reuse the ADDON_SETTINGS_V1 declaration parser, evaluation, deliveries and page model unchanged. | The parser already accepts `settings.values` on any member; the page model already renders addon-lane rows of any member (`value_editor` locks only non-addon lanes). Only `packages.cpp` withheld the delivery (`else if` after the replacement branch). | **TRUE (source + gate).** One rule change: a replacement member that declares an addon-lane value gets the same `MemberDelivery`. |
| H2 | A value installed in the VM global table (`-10002`) is visible to module code. | V26 live (2026-09-03): a hashed native dispatcher installed in the VM global namespace was never reached from the target module (`TARGET_ENV_HOOK_INFRASTRUCTURE_V27_2026-09-03.md`). The 2026-07-23 injector notes: seeding main-L globals under a new name did not resolve (`RENOVICE_RAN`). | **FALSE (live, twice).** Rejected. |
| H3 | A hashed value installed in the module's **load environment** (the env of the undumped root closure in the module registry) is visible to the module's code, including code running in per-instance environments. | V27 moved the dispatcher into the exact target module environment captured by the loader; V49/V54 call it "the proven generic target dispatcher", reached from BardMusic hook-shim code (a content-keyed **replacement**) during live Mallet damage. U43 require decompile: the instance sandbox is built from `getfenv(module closure)` with an `__index` chain, and GETIMPORT's resolver walks `__index`. Live logs: each module load has its own load env (`load_env=…` differs per key). | **TRUE (static + indirect live evidence).** A read by a replacement **root** is not yet observed live (pending check 2). |
| H4 | The accessor can be in place before the replacement root runs. | DE's Loader only undumps and stores the closure in the module registry; the root runs later: `run_chunk` calls the stock Loader and then executes the registry closure itself; target-root binding observes root execution separately, after load. The loader detour already activates target addons at this point, before the root. | **TRUE (source).** |
| H5 | The compiler emits the accessor global with the same key the host writes. | `derecomp recompile-u44` of the fixture: `GETIMPORT` root `H:04ace428`; `native_name_hash("RENOVICE_SCRIPT_SETTINGS", 768e5ed0) = 04ace428` (the `wf_fnv_2` algorithm; the same code reproduces the toolchain self-test `GetConfigBool` = `4aec2dac` with the U43 seed). | **TRUE (gate).** |
| H6 | The name cannot shadow or overwrite a stock global. | No name in the verified namebase (922,276 names) hashes to `04ace428` with the U44 seed. At run time a non-RENOVICE value under that key is never overwritten (`REJECT … rejected-foreign-value`). | **TRUE (gate + fail-closed rule).** |
| H7 | Entry fields are read with string keys, as the host writes them. | CONST-ID of the fixture: `FIELD S:enabled`, `S:stock`, `S:value`, `S:hijack.payload_health` (string class); the host uses `setfield` (strings), exactly like `context.settings`. | **TRUE (gate).** |
| H8 | The U44 full-module recompile is faithful for the fixture module. | RetrievalMission (`fb346b59e2b7687a`): stock decompile → recompile passes CONST-ID and CFG-ID against stock (21/21 prototypes). Of the 50-module authoring corpus, 13 pass both gates; ZarimanCorruption (Void Flood) fails CFG-ID in 3 prototypes, so it was not used. | **TRUE for this module (offline).** In-game behavior of a full U44 recompile is not yet proven (toolchain record: "No live in-game load or behavior was tested"). |
| H9 | Many values can be read inside hot functions at a reasonable cost. | With `knownSerial` the host skips the table when the caller holds the current serial (no protected leaf, no allocation); gate model about 8 ns per call for 256 entries x 64 values; plain-Luau harness: 20,000 reads, 0 table builds; one build per new serial. | **TRUE (offline model).** In-game cost not measured. |

## Design (as implemented)

### Accessor

`RENOVICE_SCRIPT_SETTINGS([key] [, knownSerial])` → `settings-or-nil, serial` (nothing at all when
the call resolves to no key).

- `settings` = `{ [id] = { enabled = true, value = <number>, stock = <declared stock> } }`, the same
  entry shape as an addon's `context.settings`, so the same guard code works. `nil` when there is no
  entry (no readable declarations, declarations rejected, member not staged, loose file). An empty
  table when the values file is missing or malformed, `use_stock` is on, or every value is off.
- `serial` = the committed snapshot serial (a DE float, exact to 2^24 − 1 commits).
- `knownSerial` equal to the current serial: `nil, serial` without building a table. This is the
  hot path for generated replacements that read a value at every use (pattern below).
- No key argument: the key the accessor was bound to at install (the module's content key). A string
  argument of exactly 16 hex digits names the key; an invalid string, a non-number second argument
  or any other first argument returns nothing (never the bound key). Rules: `plan_call`,
  `caller_is_current` in `replacement_settings_core.hpp`.

### Installation (host)

- Where: the environment of the loaded root closure, found exactly as the target identity finds
  it (`key_builder(name_handle)` → `getfield(-10000, …)` → `closure->env`), under the DE native-name
  hash of `RENOVICE_SCRIPT_SETTINGS` (BOOL-tagged key, `wf_hash`).
- What: a C closure `replacement_settings_accessor` with one upvalue, the content key as plain bits
  (light userdata; not a pointer).
- When:
  1. `trigger=load`: in the loader detour, after the stock Loader returned **successfully**
     (never after a stock error, when no VM operation is allowed), only when that load's undump
     used replacement bytes (`replacements::completed_replacement_load`), inside the existing
     non-nested loader boundary block, before the root can run.
  2. `trigger=F9-refresh`: after a VM-local module refresh to replacement bytes (not a restore to
     stock).
  3. `trigger=F9-commit`: after every F9 commit, for replacement modules this VM (exact VM and owner
     thread) has already loaded, so declarations added without a byte change still get the accessor.
- Decision (`install_action`): empty → install; our accessor with the same key → keep (no VM write,
  no log line); our accessor with another key (two replacements share one environment) → rebind to
  an unbound accessor (explicit key needed); anything else → reject, never overwrite.
- No entry for the key → return before any VM access. Replacements without declarations therefore
  load byte for byte as before, with the same content-key matching.

### Ownership, generation, lifetime

| Object | Owner | Lifetime |
|---|---|---|
| Declarations, values file, evaluation, `MemberDelivery` | package scan (startup, F9) | per committed package snapshot, unchanged from ADDON_SETTINGS_V1 |
| `replacement_settings::Snapshot` | process; `std::atomic<std::shared_ptr<const Snapshot>>` | swapped at the startup scan (`main.cpp`, after `packages::initialise`) and at every F9 commit (right after `packages::commit_prepared_reload`); a prepared F9 is never visible; an accessor call holds its own `shared_ptr` for the call (in-flight rule) |
| Accessor C closure | the VM; rooted only by the module's load environment | as long as that environment lives; process-owned native function (the DLL is never unloaded by F9); no Lua pointer is retained natively |
| Returned table | the caller | fresh per call, garbage-collected; a temporary registry root (`RENOVICE.replacement-settings.return.v1`) exists only during the call and is always cleared |

**Cost.** Resolved calls reserve two result slots before any C++ owner exists. A call with the
current `knownSerial`, or for a key without an entry, does no protected leaf and no allocation: one
atomic snapshot load, a binary search over the replacement entries and a compare (gate model:
about 8 ns for 256 entries of 64 values each, 2,000,000 calls). A table is built at most once per
committed serial per caller cache (the plain-Luau pattern harness counts 0 builds over 20,000 reads
on an unchanged serial and 1 after a new commit).

**Live or next load (for authors):**

- Code that calls `RENOVICE_SCRIPT_SETTINGS()` on each use reads the newest committed values: a
  SCRIPT SETTINGS apply (an F9) takes effect from the next call. **Live in place.**
- Code that reads once in the root chunk keeps those values for that root instance; the next root
  execution (the next mission for mission scripts) reads the new values. **Next instance/load.**
- A settings-only change does not refresh the module (bytes unchanged), and a replacement has no
  `activate`/`cleanup`. Declare `applies` accordingly (`live_next_read` or `next_mission`).

### Fail closed

- Loose replacement files: never a package member → no entry → `nil`.
- Package or member disabled: not staged → stock module (no replacement) and no entry.
- Declarations rejected: replacement still staged (compiled values), no entry.
- Values file malformed / `use_stock` / values off: empty table.
- A load before `DE_VM_AUTHORITY PASS`: the loader detour forwards without ownership, so no accessor
  until that module's next load.
- A load nested in RENOVICE's own chunk execution: `ACCESSOR DEFER … reason=nested-renovice-execution`.
- A call failure: `nil`, at most 16 `CALL FAIL` lines, then one suppression line.

### Logging

Operational (bounded, no per-call cost): `RENOVICE REPLACEMENT SETTINGS ENTRY|COMMIT` (only when a
snapshot holds or held an entry, so setups without such packages log exactly as before),
`RENOVICE REPLACEMENT SETTINGS ACCESSOR PASS|REJECT|FAIL|DEFER` (never for a kept accessor), and the
existing `RENOVICE SETTINGS DELIVERY` line now also for replacement members. Diagnostics (formatted
only when Diagnostics is not off): `RENOVICE REPLACEMENT SETTINGS READ key=… source=bound|argument
serial=… values=N package=… vm=…`, once per key and committed serial (at most 256 pairs).

## Real U44 fixture and example package

- Module: `/Lotus/Scripts/Modes/RetrievalMission.lua` (Hijack), stock
  `Lotus_Scripts_Modes_RetrievalMission.lua_B` SHA-256
  `294eb28a72762e81c019ce6494b2aa71f8fcd16e2d4969d7efc7ba718f544b09`, content key
  `fb346b59e2b7687a`.
- Tunable: `hijack.payload_health` (registry: root proto 20, `v5 = 10000`, consumer proto 11
  `SetMaxHealth`).
- Source: `RENOVICE_TOOLCHAIN/replacements/fixtures/replacement_settings/RetrievalMission.settings.u44.luau`
  = `derecomp decompile-mod-u44` of the stock bytes plus one block after `v5 = 10000` that reads the
  setting (guarded by `enabled == true` and `stock == 10000`).
- Compiled with `derecomp recompile-u44` (raw-hash path, `repos/toolchains/de-luau-toolchain`,
  derecomp `65c46572…`): 29,462 bytes, SHA-256 `6a626ae42814f796457c44ad4889793bcbd7fd1527e96f01c21ffe6040eb5ee6`.
- Example package `HijackSettingsExample` (`package.json`: group `hijack`, int value stock 10000,
  min 1000, max 200000, `applies: next_mission`, `stock_check: none`) and values file (20000).

## Recommended pattern for generated replacements (second, unrelated fixture)

`RENOVICE_TOOLCHAIN/replacements/fixtures/replacement_settings/GeneratedReplacementPattern.u44.luau`:
one module-level helper `setting(id, stock)` that keeps `settingsCache` and `settingsSerial`, and every
former literal site becomes `setting("<id>", <stock literal>)`. The stock literal is the fallback
and the guard (`entry.stock == stock`). Compiled on the U44 raw-hash path; CONST-ID against the same
module with a settings-free helper shows exactly the accessor global `H:04ace428` and the string-class
fields `enabled`, `stock`, `value`. Executed in plain Luau (`pattern_harness.luau`) against a mock of
the host contract: stock without an accessor, custom values, stock for missing ids, 20,000 reads
without a table build, one rebuild after a new serial, the stock guard, removed settings, and an
accessor call that returns nothing (10/10).

Consequences for the mission editor (CONTRACT_PHASE1 Revision R6):

- **R5-L (live literal patching)** is not needed for modules whose full U44 recompile is faithful:
  the generated replacement reads the value itself. It remains useful only for modules whose
  unedited round trip fails CONST-ID/CFG-ID (on the 50-module authoring corpus, 13 pass both;
  MobileDefense, ExcavationMission, WaveDefend, ZarimanCorruptionMission and SurvivalMission do not),
  unless the toolchain CFG defects are fixed first.
- **R5-C (addon + replacement on one module)** is not needed for value editing: a settings-reading
  replacement can also read the module's root-table values, so one artifact carries all of that
  module's values. R5-C stays relevant only for combining a byte-exact literal patch on a
  CFG-failing module with addon hooks, or for hook-only behaviour. That composition was not tested.

## Gates

- New `RENOVICE_TOOLCHAIN/replacements/verify_replacement_settings.ps1` (in the build list; 149 checks plus the 10-check Luau pattern harness):
  - fixture: U44 raw-hash source, compile determinism, byte-exact container round trip; CONST-ID and
    CFG-ID between the stock-equivalent baseline and the fixture: the only change is one hashed
    global (`04ace428`) and four string field keys, all in the root prototype (20/21 prototypes
    identical control flow); with the shared corpus present: the baseline source equals the stock
    decompile exactly and passes CONST-ID and CFG-ID against the stock bytes;
  - page model: `verify_addon_settings.ps1 -Package` on the example (delivery 20000/10000, R5
    nested check) and its rows equal the pinned `HijackSettingsExample.rows.txt`;
  - MSVC `/W4 /WX` checker with the exact `packages.cpp` and `replacement_settings.cpp`: pure rules,
    name hash vs compiled fixture and namebase, 10 end-to-end scanner scenarios, the nested pages
    (top → package page with the replacement member switch and tooltip → section → value page), and
    a staged edit through the host model → values file → F9 scan → committed snapshot (15000), the
    `plan_call` matrix and the hot-path benchmark;
  - the pattern fixture: U44 compile, container round trip, CONST-ID classes, plain-Luau harness;
  - source pins for every integration point (no `-10002` in the accessor block, install before any
    write classified, loader call only after success and only for replacement undumps, snapshot
    commit order at startup and F9, no VM access without an entry, Diagnostics=false formats nothing,
    no target names in the primitive).
- `verify_script_settings_render.ps1` section 4b: the example's rows run through the real stock
  GenericSettings/List renders (open, scroll, value page, search, close routes).
- Existing: `verify_replacement_core.ps1` PASS (not in the build list; run separately),
  `verify_script_packages`, `verify_addon_settings` (incl. R5), render (incl. R5), and all other
  build-listed gates.

Build: `RENOVICE_TOOLCHAIN/build_private.ps1` → `PRIVATE BUILD PASS flavor=main warnings=0
errors=0 x64=yes companion_import=no bytes=5693440 sha256=29a9c6c8a9f357e20d258e13712a591c06bb43cee38bd41134ee14f650e8e934`, 36 gate scripts (the 35 of R5 plus this one).

Staged in `work/staging/replacement-settings/` (DLL, R5 bridge `299cac5e…` unchanged, example package,
values file, README with the live test, `SHA256SUMS.txt`, evidence). Superseded intermediate builds of this
branch, never deployed: `1539190d…` (before the rebase onto R5) and `ab7a5d29…` (before the serial cache).

## Limitations (exact)

- Live evidence is pending for every point: the install line, the READ line, the payload health
  in game, the F9 apply, and that the full U44 recompile of RetrievalMission behaves as stock.
- H3 for a replacement root read is inferred from the proven dispatcher path (callbacks), not yet
  observed for a root-time read.
- Modules loaded before `DE_VM_AUTHORITY PASS` get the accessor only at their next load.
- VMs other than the committing one get the accessor after an F9 only at their next load or refresh
  (the F9 commit pass is exact-VM, exact-thread).
- A call without `knownSerial` builds a table each time (a protected leaf plus one table per value); code that
  reads per use must pass its cached serial (the documented pattern). The 8 ns figure is a gate model of the
  host side only; the Lua call and table lookups are not measured in game.
- `SettingsMenuNested=false` (flat) and the nested default both show the rows; the render harness
  runs the example rows through the flat list and the R5 nested flows run on their built-in
  fixture; the nested page model for the replacement member is checked in C++ only.

## Rejected designs

- VM-global table or function (`-10002`): not visible to module code (H2, live negative twice).
- Writing into the per-instance root environment at VM-execute entry: allocation inside the execute
  detour is not an established safe point; no need, H3/H4 cover it.
- Byte-patching values into the replacement at load (the literal lane already covers fixed values;
  blind byte edits are not allowed for runtime values).
- A lifecycle (`activate`/`cleanup`) for replacements: would need module-specific binding logic;
  the stateless accessor needs none.
- Refreshing the module on a settings-only change: would re-run module loads for every apply and
  change the replacement lane's refresh contract.
- Keying by package or member name: folder names are user-editable; the content key is the lane's
  own identity and unique across accepted packages.

## Live checks (pending; the user runs them)

See `work/staging/replacement-settings/README.md`.

## Merge notes (shared files touched)

Against `0afb9cd`:

- `renovice/injection.cpp`: (1) `#include "replacement_settings.hpp"` beside `replacements.hpp`;
  (2) one new contiguous block `// BEGIN/END REPLACEMENT_SETTINGS_ACCESSOR` inserted directly before
  `enum class LoaderDetourDisposition` (closes and reopens the anonymous namespace around
  `publish_replacement_settings_accessor`); (3) 10 lines in `loader_detour_owned` directly after
  `replacements::drain_pending_for_vm(state);`; (4) 2 lines in the F9 `commit_prepared` lambda
  directly after `packages::commit_prepared_reload();`.
- `renovice/injection.hpp`: one declaration appended at the end of the namespace.
- `renovice/packages.cpp`: one include; the `else if (settings::member_declares_values(...))` in
  `apply_member_policy_and_settings` became `if (replacement_settings::member_receives_delivery(...))`.
- `renovice/replacements.cpp` / `.hpp`: load record, drain publish, F9-commit publish, accessor.
- `main.cpp`: one include, one call after `packages::initialise()`.
- `RENOVICE_TOOLCHAIN/build_private.ps1`: one line after `verify_addon_settings.ps1`.
- `RENOVICE_TOOLCHAIN/scripts_ui/verify_script_settings_render.ps1`: section 4b (10 lines) before
  section 5.
- `OpenWF/CustomScripts/HOW_TO_ADD_SCRIPTS.md`: new section before "Module instances and
  environments".
- New files: `renovice/replacement_settings{_core.hpp,.hpp,.cpp}`,
  `RENOVICE_TOOLCHAIN/replacements/verify_replacement_settings.{ps1,cpp}`,
  `RENOVICE_TOOLCHAIN/replacements/fixtures/replacement_settings/*`, this note.
