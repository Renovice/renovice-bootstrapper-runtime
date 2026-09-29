# Optional folder script packages, and fix 3 from live session pid 23260 (2026-09-29)

- Branch: `feat/script-packages-2026-09-29`, from `8946bfd` (`fix/multi-target-live-run-2026-09-29`, deployed DLL `420e10a4…98f4da`).
- Commits: `8ed3d6e` (packages), `dc15d9c` (fix 3: Circuit root environment, buffered diagnostics, Diagnostics=false formatting, hooks doc), plus the docs/gate commit that adds this note.
- Client: 44.0.2 (`2026.09.28.13.06`). Executable allowlist and signatures unchanged.
- Scope: repository only. Nothing was deployed; no game, OpenWF server or `renovice.cfg` file was written. Installed files were read (hash checks and log reads) only.
- Status: offline gates and the zero-warning private build **PASS**. **Every live check is pending.**

## Part 1: optional folder script packages

### Requirement

A folder may bundle several scripts into one Scripts-menu entry, only when the author chooses to. Loose files (single replacements in `CustomScripts\`, single-key and multi-target addons in `CustomScripts\Inject\`) keep the same discovery, state keys and behaviour.

### Hypotheses

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| P1 | A subfolder `CustomScripts\Packages\<Name>\` cannot be picked up by the loose scanners. | The replacement loader (`replacements.cpp load_snapshot`), the Inject scanner (`scan_snapshot`), the SWF scanner and the Scripts inventory (`script_control.cpp discover_directory`) all use a non-recursive `directory_iterator` and skip non-regular entries. The gate reproduces that enumeration on a temp tree and pins "no `recursive_directory_iterator`" in every scanner. | **TRUE (source + gate)** |
| P2 | One package snapshot per transaction, consumed by both lanes, makes a package all-or-nothing at commit. | `packages::prepare_reload()` runs once in F9 after the prepared policy and before `replacements::prepare_reload()` and `scan_snapshot()`; both read `packages::candidate()`. Startup: `packages::initialise()` after `script_control::initialise()`, before `injection::initialise()` and `replacements::initialise()`. Commit and discard follow the transaction. | **TRUE (source + gate)** |
| P3 | Package members can reuse the existing lanes unchanged. | Replacement members are merged into the same `key → bytes` map after the loose loop. Target members become ordinary `Chunk{TargetManagedAddon}` entries (multi-target: one per declared key, `multi_target=true`) named `Packages/<folder>/<file>`, which cannot collide with loose names. | **TRUE (source + gate)** |
| P4 | Untargeted managed addons (`*.addon.lua_B`) can be package members with package-local failure. | `apply_generation` stages every managed addon in one loop and returns false on the first staging failure; `commit_addon_generation` activates them as one transaction. A package member failure would roll back every loose managed addon. | **FALSE.** Rejected as a member (`managed-addon-member-unsupported-generation-wide-transaction`). A package-scoped managed transaction is future work. |
| P5 | One-shot Inject chunks can be members. | Their side effects cannot be undone, so an all-or-nothing package cannot contain them. | **FALSE by design.** Rejected (`one-shot-inject-not-allowed-in-package`). |

### Design (as implemented)

- **Layout.** `CustomScripts\Packages\<Name>\`. Folder names: 1–64 of `[A-Za-z0-9 _.-()]`, no leading/trailing dot or space. At most 256 packages and 256 members per package.
- **Members.** Every `.lua_B` directly in the folder: `<16-hex> (label).lua_B` replacement, `<16-hex>.<Name>.target.addon.lua_B`, `<Name>.targets.addon.lua_B`. Other files are ignored; subfolders are ignored.
- **`package.json`** (optional, strict, ≤ 64 KiB, UTF-8 BOM allowed): `schema` (1), `name` (1–64 printable), `description` (≤ 1,024; line breaks allowed), `members` (`{file: {label?, settings?}}`), `settings` (reserved, any JSON). Unknown or duplicate fields, trailing data and nesting deeper than 32 reject. A per-member `enabled` is reserved and rejected today. If `members` is present, the on-disk `.lua_B` set must match exactly (case-insensitive).
- **Scripts menu.** One row `[PACKAGE] <name or folder>`, one state `package:<folder lowercased>`, tooltip `PACKAGE | <description> | N members: <label> (<file>), … | <status>` (bounded). `INVALID: <reason>` = static failure (not toggleable); `BLOCKED: <reason>` = enabled but conflicting (toggleable, so the player can resolve it). `Kind::Package` is appended to the enum, so every loose kind keeps its ordinal, sort position and ID prefix.
- **Conflicts.** Two sources claiming the same replacement key, or the same target key, conflict when at least one is a package. Loose files sort first, then packages by lowercase folder name. The later-sorted source fails closed as a whole; a rejected package's claims are not recorded, so it never blocks a third source. Only enabled sources claim. Loose-vs-loose is untouched (the loose replacement loader still rejects duplicate loose keys exactly as before).
- **Inventory.** A structurally valid package inventories its replacement and target keys even while disabled or conflicted (available replacement keys; observed target keys), exactly like a disabled loose file, so enabling it later works without restart.
- **Operational log** (not diagnostics; bounded by the package count): `RENOVICE PACKAGE ACCEPT|DISABLED|REJECT trigger=startup|F9 package=… id=… … reason=… scope=package-local generation=continues` and `RENOVICE PACKAGES scan PASS … accepted=… disabled=… rejected=…`. Nothing is logged when there is no `Packages` folder.
- **Failure scope.** Static validation failures (member classification, sizes, readability, multi-target pool, manifest, reconciliation, duplicates, conflicts) reject only that package. Only an unreadable `Packages` root rejects the F9 transaction (previous generation retained, exact reason logged); at startup it disables packages only.

### Exact limitations

- **Runtime binding stays per module.** All-or-nothing covers the static commit. A target member that later fails to bind at a module load fails for that key only (`Inject FAIL … target=<key>`), like any target addon; it does not unload the package's replacements.
- **Race window.** The package scan and the loose scans of one transaction read the disk separately (as the loose lanes already did). A loose replacement that appears between them with a package's key makes the replacement loader reject the whole F9 (duplicate key), so nothing is applied twice.
- **Menu inventory** re-reads addon member bytes (for the declared-key count) on every Scripts-menu open, like multi-target files already did. Replacement bytes are never read for the menu.
- No per-member toggles yet (the manifest reserves the shape).

## Part 2: fix 3 from live session pid 23260 (fix2 DLL `420e10a4…`)

Evidence: the ability-editor note `RESEARCH/MALLET_THREAT_CALLSITE_FIX_2026-09-29/README.md` (worktree `work/temp/ability-editor-mallet-threat-fix`, `d0d8c41`) and read-only greps of the installed `renovice_source.log*`.

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| C1 | DE's `module(..., package.seeall)` re-points the root closure environment, so reading `closure->env` at the root's return finds the module globals (fix 2's assumption). | `renovice_source.log.1:19834`: `TARGET ROOT RETURN key=95ef5b82a8400944 … entry_env=0000020FD2D7B910 runtime_env=0000020FD2D7B910`, then `Inject PASS … env=0000020FD2D7B910` and `addon lifecycle FAIL … RENOVICE_CIRCUIT_STAGE_XP_GETTER_NOT_FUNCTION`. The executable contains no Lua 5.1 `ll_module` strings (`not called from a Lua function`, `_LOADED`, `_PACKAGE` absent), so `module` is DE's own. | **FALSE (log).** The root closure keeps its entry environment. |
| C2 | The module's own functions resolve `EndlessGetXpForStage` through an environment other than the root closure's. | Stock DuviriUtil functions read it as a global (`c30v21 = EndlessGetXpForStage`, canonical decompile line 1172) and the stock UI works, while an addon bound in the root closure environment reads nil. Luau NEWCLOSURE/DUPCLOSURE give a new closure the environment in force at creation. | **TRUE (static + log, by elimination).** Live confirmation pending. |
| C3 | The root's child closures are still reachable at its return without VM calls. | The root ends with `…; SpawnTarotCard = v22; return` (decompile lines 4244–4421): registers v19–v22 hold the last functions it created. At the naked stock return no allocation (so no GC step) has run, and the stack slots are unchanged. | **TRUE (static).** |

**Fix (generic).** `inspect_target_root_entry` records the root register window as a stack offset (`luau_savestack(intop)`, `closure->stacksize`). `settle_target_root_return(state, entry)` re-bases it on the current stack, bounds-checks it, reads the root prototype's direct child array (`+0x18`, count `+0x8c`, same verified U43/U44 layout as `collect_target_proto_graph_u43`), and feeds the environment of every Lua closure in the window whose prototype is a direct child into `RootEnvironmentAccumulator`: none → root closure environment; all agree → that environment; disagreement → ambiguous, keep the root closure environment (fail closed). Read-only, no lock, no allocation, no VM call. The log line adds `root_closure_env=… env_source=child-closure|root-closure|ambiguous-kept-root-closure child_closures=N`. Bind-once and the once-per-generation retry are unchanged.

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| L1 | The per-line open/append/close is the diagnostics frame-time multiplier. | `config::write_log_unlocked` ran `std::filesystem::file_size` + `CreateFileW` + 2×`WriteFile` + `CloseHandle` per line under the config mutex on the game thread; a traced Mallet fight wrote thousands of lines in 20 s. | **TRUE (source + log volume, per the Mallet note).** No frame profile was captured. |
| L2 | With Diagnostics=false nothing is formatted. | (a) `dispatch_target_hook` built label strings (thread-local detail flag defaults to true) and copied the whole `Flags` struct per provider via `config::flags().diagnostics`; (b) `damage.performance` formatted every 2 s; (c) the float-transform `details` stream and `log_native_hook_once`'s `ostringstream` identity ran on every transformed push (and the identity on every dispatch/root entry); (d) sampled damage detail and damage-install traces built strings. | **FALSE before; fixed.** |

**Fix.**
- Source log: one persistent append handle (share read/write/delete, reopened after rotation, open retried at most once per second); size tracked in memory; diagnostic lines buffered in a 64 KiB buffer flushed when full, at ≥ 250 ms, before every operational line (order preserved), on DLL detach and from the near-null fault recorder (`flush_log_for_fault`, try-lock). Operational `config::log` lines are write-through. Pure policy in `config_core.hpp` (`source_log_*`).
- Trace mode: per-hit lanes (`damage.`, `dispatch.`, `native.`, `lua.call.`, `luaCalls.`) limited to 32 lines per event name per 1 s window by `DiagnosticEventRateLimiter` (64 bounded slots, no allocation). Each limited window yields one `RENOVICE ADDON_TRACE build=V79 event=trace.rate-limited suppressed_event=… window_ms=… admitted=… suppressed=… untracked_dropped=… limit_per_window=32` line. Suppressed lines do not consume `DiagnosticsMaxEvents`. Reset with the trace budget. Load-time structural events (`module.prototype`, installs, attaches) are not rate limited.
- Diagnostics=false: (a) `detailed_trace = mode != off && (…)`, results trace uses the atomic mode; (b) performance line gated; (c) `details` gated, `log_native_hook_once` checks a 64-bit FNV identity of (event, key, VM) on its own mutex before any formatting; (d) sampled damage detail and install traces gated. The operational `native hook PASS` line is still logged once per identity in every mode.
- `NATIVE_TARGET_ADDON_HOOKS.md`: the `instruction` of `transformFloatArgument` and `nativeCalls` is the logical `NAMECALL` index when a `NAMECALL` precedes the `CALL` (44.0.2 `BardMusic` p16: 596, not 597), else the `CALL`.

**Remaining diagnostics cost (not changed).** `trace_addon` still copies `config::flags()` once per admitted or rate-checked trace call when Diagnostics is on. `ENGINE_DAMAGE` per-hit JSON is bounded by count (max/2 per generation), not rate.

## Gates (all PASS)

| Gate | Coverage |
|---|---|
| `RENOVICE_TOOLCHAIN/injection/verify_script_packages.ps1` (new, in the build; 122 checks, 125 with `-AdmitPackage`) | Pure rules (member classification, folder names, manifest parser incl. BOM/escapes/surrogates/depth/size, reconciliation, conflicts, tooltip bounds); the real `packages.cpp` scanner end to end on a temp tree with loose files and 18 packages (accept, disabled, 13 exact rejection reasons, conflict holders, ordering, byte ownership, F9 prepare/discard/commit, deletion, quiet inventory); loose identity pins (kind ordinals, stable IDs, menu labels); source invariants (no recursive scan, lane wiring, F9 order, commit/discard, startup order). `-AdmitPackage <folder>` admits a real package through the scanner. |
| `verify_injection_core.ps1` (now in the build) | Adds the root-environment rule, `proto_is_direct_child`, the rate limiter and the hook identity. |
| `verify_config_core.ps1` (now in the build) | Adds the buffering, flush and rotation policy. |
| `verify_target_root_binding.ps1` | Adds: register window captured as a stack offset; re-based and bounds-checked; accumulator + direct-child check; log names `env_source`; settle still lock-, allocation- and VM-free. |
| `verify_unified_diagnostics_master.ps1` | Adds: no open/close in the per-line writer; buffered diagnostics, fault flush, detach flush; rate limiter before the budget with summary; identity before formatting; dispatch/performance/float-transform/damage detail gated. |
| Existing | Manifest (feature row `SC-002`), dependencies, Scripts UI core (77), multi-target, lua-call raw protection, replacement core, legacy UI VM boundaries, target export hook, and every other build-listed gate. |

Build: `RENOVICE_TOOLCHAIN/build_private.ps1` → `PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no bytes=5081088 sha256=6f100ebcb087cebf977781217897356a9ab208f9c5f273b62358f64462c79248`. Build shell: `NoDefaultCurrentDirectoryInExePath` removed for that session only (see the fix-2 note). `main.cpp` and `NATIVE_TARGET_ADDON_HOOKS.md` had CRLF worktree copies although `.gitattributes` pins `eol=lf`; once modified, git printed an EOL notice that the archive step treats as a failure, so their worktree copies were normalized to LF (no content change).

Staged: `work/staging/bootstrapper-packages/wtsapi32.dll`, 5,081,088 B, SHA-256 `6f100ebcb087cebf977781217897356a9ab208f9c5f273b62358f64462c79248` (`SHA256SUMS.txt` beside it). The archive is time-versioned, so the hash is specific to this build instance.

## Generator output (ability-editor `feat/universal-mission-registry`)

`output_layout: "package"` emits `Packages\Missions\` (see the ability-editor research note, Phase 2h). The Phase 2h sample package was admitted by this scanner (`verify_script_packages.ps1 -AdmitPackage …\phase2h-sample\Packages\Missions`): `RENOVICE PACKAGE ACCEPT … package=Missions id=package:missions members=2 replacements=1 target_addons=1 target_keys=3`.

## Migration from the installed loose Missions files

Installed today (read-only hash check): `Inject\Missions.targets.addon.lua_B` `00DA193D…773E` and `fc711ff621a75552 (missions_exact-replacement).lua_B` `E979F5E7…F6D2`; DLL `420e10a4…`. The package members are byte-identical to both. If both the loose files and the package are present and enabled, the package is rejected (`conflict kind=replacement key=fc711ff621a75552 holder=loose:…`) and the loose files keep working. Steps: with the game closed, replace the DLL with the staged one (keep `420e10a4…` as rollback); remove the two loose files; copy the sample's `Packages\` folder into `OpenWF\CustomScripts\`. The old state ID `target-addon:missions.targets.addon.lua_b` becomes a harmless orphan.

## Live checks (pending; the user runs them)

1. Startup: `DE_VM_AUTHORITY PASS`, `RELOAD PASS`, `RENOVICE PACKAGE ACCEPT trigger=startup package=Missions … target_keys=3`, `PACKAGES scan PASS … accepted=1`.
2. Scripts menu: exactly one `[PACKAGE] Missions` row (no `[ADDON] Missions`, no Void Flood replacement row); tooltip lists both members. Toggle OFF → F9 → `RENOVICE PACKAGE DISABLED trigger=F9 package=Missions`; ON → F9 → ACCEPT.
3. Survival (150 s rewards), Purgatory, Lantern, Void Flood (4 fractures): as in the Phase 2g checks.
4. Circuit: `TARGET ROOT RETURN key=95ef5b82a8400944 … env_source=child-closure child_closures=N` with `runtime_env ≠ root_closure_env`, then `TARGET ADDON PASS key=95ef5b82a8400944`; stage preview 500/550/625/725/850. If `env_source=root-closure` or `ambiguous…` appears instead, C2/C3 are falsified for 44.0.2.
5. Mallet fight with Diagnostics=true: no stutter from logging; `event=trace.rate-limited` summaries appear; `renovice_source.log` still ends with the latest lines within ~250 ms. With Diagnostics=false: no ADDON_TRACE lines.
6. Regression: Ice Wave, Mallet (with the p16/i596 addon), Elite Sanctuary, F9, F10/Pluto, Arsenal/Simulacrum search (`Limbo`, `00`, `codha`), Riven locks.
