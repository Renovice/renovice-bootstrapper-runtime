# Current RENOVICE bootstrapper state

## 2026-09-30 ENGINE_DAMAGE per-build codec for 44.0.2 + per-hit result lane staged (not deployed)

Branch `fix/engine-damage-codec-44.0.2-2026-09-30` (from `fb9655e`, the R2 settings editor). Diagnostics only. Stock damage, gameplay, Pluto and the addon lanes are unchanged.

- **Defect.** On 44.0.2 every `ENGINE_DAMAGE` record had null pools and a garbage `ObservedRaw`, because the lane kept the U43 codec and slots (Mallet note, 8,069/8,069 records). 44.0.0 had the same stale values.
- **Registration.** `renovice/engine_damage_builds.hpp` holds, per exact build, the digests, handler RVAs, UpgradedValue evaluator RVA, integer and float codecs (rotate + key) and every layout offset. There is no fallback.
  - 44.0.x: integer rol19 / `0xAC7E8740`; float **rol17** / `0x8637D1B6` (U43 was rol30, so the rotate changed too); slots health `0x350`, shield `0x2c8`, Overguard `0x338`.
  - The other offsets are unchanged: `control+0x28`, packet `+0x60` UpgradedValue (`+0x0c/+0x14/+0x24/+0x30`, cached `0x20`), fractions `+0`. The newly registered override flag is `0x10` → `+0x20`.
  - All values were derived from the exact 43, 44.0.0 and 44.0.2 images (Lua binding vtable calls, the accessors at the slots, handler0 and the evaluator).
- **Fail closed.** Every read checks the registered accessor bytes. At install, `admit_codec()` checks the loaded image; on failure it logs one `event=degraded` line, and every decoded field is null with an exact `…Reason`. Records keep correlation, target and source. New record fields: `Layout`, `RawReason`, `HealthReason`, `ShieldReason`, `OverguardReason` (the analyzer passes them through).
- **Per-hit addon results.** `dispatch.results` (afterDamage) has its own lane: 1,024 lines per second, its own `DiagnosticsMaxEvents` budget and summaries, reset at the same 3 boundaries. It is emitted in **battle** mode too. Traced callback results go from 8 to 12.
- **Gates.** New `verify_engine_damage_codec.ps1` (key presence, evaluator and slot accessors per registered image, 3/3 covered; the pre-fix negative control fails). `verify_native_damage.ps1` is extended (known-answer vectors and a decoded sample per build) and is now in `build_private.ps1`. Injection core and unified diagnostics gates are extended. 31/31 gates PASS.
- **Build.** Main DLL `9e44f885ab891eb76273cc4162129ab69ab481b20dbc6d081d8dc3df23cf3aab` (5,601,280 B), 0 warnings, 0 errors. Bridge `2e337a43…` unchanged. Staged in `work/staging/editor-phase2-3/`; the R2 set is in `older/r2-7594fbf2/`.

**Deployment and the live check are pending.** Live acceptance: for one hit on a surviving enemy, the native end record's `HealthLoss + ShieldLoss + OverguardLoss` equals the addon's `dispatch.results` `result3` for the same target, with `Layout:"44.0.2 2026.09.28.13.06"` and no `event=degraded`. Rollback is `7594fbf2…`. [Record](../RESEARCH/ENGINE_DAMAGE_CODEC_2026-09-30/README.md).

## 2026-09-30 In-game settings editor: Phase 0 probe, ADDON_SETTINGS_V1 and SCRIPT SETTINGS staged (not deployed)

Branch `feat/ingame-settings-editor-2026-09-30` (from `3ca9564`). Generic changes only; no target-specific code.

- **Reserved `_RENOVICE_INTERNAL_` names.** V10 is unchanged. Optional bridges (`ScriptSettingsBridgeV1`, and the Phase 0 probe only in a probe build) load after the managed-addon commit; a failure removes only their row. Any other reserved name is ignored (`internal chunk IGNORED`).
- **Phase 0 probe** (`build_private.ps1 -SettingsProbeP0`, commit `3230368`): `SETTINGS PROBE` row + F12 open at the pending-only safe tick; static pages; writes nothing. DLL `1a40ecaa…` in `work/staging/editor-phase0-probe/` with `PROBE_CHECKLIST.md`.
- **ADDON_SETTINGS_V1:** strict `package.json` declarations (bad declaration → settings off, compiled defaults), `CustomScripts\Settings\<package>.json` (bad file → that package stock), per-value/section/master switches, fresh `activate(context)` table per generation, settings identity in the reuse identity, literal members gated by their value switch, `member:<folder>/<file>` states. Manifest bound 512 KiB.
- **SCRIPT SETTINGS** row after SCRIPTS (only with the bridge and declared settings). Flat stock-row list by default; `SettingsMenuNested=true` enables nested pages once the probe proves N-1. Clicks stage; the root close writes the files and queues F9.
- Main DLL `d2f2265071ea18caeccdde53a66aa4c6d16c387121d541bad20e23305b724372` (5,562,368 B), 0 warnings, all gates PASS (new `verify_addon_settings.ps1`, `verify_script_settings_bridges.ps1`). Staged with the V1 bridge and the phase2i live-test package in `work/staging/editor-phase2-3/`.
- **Follow-up R1** (after `7028479`): optional per-value `stock_check: "live" | "none"` (addon lane; absent = `live`) derives the "applies only where the live value equals stock" tooltip sentence from the declaration; `verify_addon_settings.ps1 -Package <dir> -Settings <file>` verifies real packages (Missions phase2i, Octavia, Frost: PASS); gates run native tools on short copies in `%TEMP%\rnvg\…` (`RENOVICE_TOOLCHAIN/gate_paths.ps1`), so they pass at a 213-character repository path. Main DLL `ed2a996d92b4b73ef2567945ecb0d709241e0d7746902079ad982a270e6eddb5` (5,562,880 B), 0 warnings, 29/29 gates; bridge unchanged. It replaces `d2f22650` in `work/staging/editor-phase2-3/` (old files in `older/`). A pre-R1 DLL rejects `stock_check` (settings off for that package only).
- **Follow-up R2** (live feedback on `ed2a996d`): the stock GenericSettings list scrolls only when every row has the same height and none is an INPUTBOX (`Update`, 44.0.2 render L4705-4880). The V1 bridge now gives TITLE and SPACER `mHeight=44`; float and negative-int values are a BUTTON (current value as sub-label) that opens a one-value INPUTBOX page `val:<Folder>/<id>`; the flat page has no SPACER. Member switches cut long labels at a word without dangling punctuation, and the tooltip adds the file and the declared sections. Main DLL `7594fbf2ad2b29bea6cd1b828c76c80573185914208afa725a263e7d6114c439` (5,581,824 B), bridge `2e337a43…` (5,441 B), 0 warnings, 29/29 gates. Staged in `work/staging/editor-phase2-3/` (the R1 files are in `older/`).

**Deployment and every live check are pending.** Rollback `6f100ebc…`; on rollback also delete the reserved bridge files (older DLLs would run them as one-shots). [Record](../RESEARCH/INGAME_SETTINGS_EDITOR_2026-09-30/README.md).

## 2026-09-29 Optional script packages + fix 3 (Circuit env, buffered diagnostics) staged (not deployed)

Branch `feat/script-packages-2026-09-29` (from `8946bfd`). Generic changes only.

- **Script packages (opt-in).** `CustomScripts\Packages\<Name>\` bundles exact replacements and single-key/multi-target addons behind one `[PACKAGE] <Name>` row and one state `package:<name>`.
  - Loose files are untouched: same discovery, keys, IDs and behaviour; the loose scanners never descend into subfolders.
  - Optional strict `package.json`: name, description, member labels, reserved `settings`.
  - One package snapshot per startup/F9 transaction feeds both the replacement lane and the Inject scanner, so a package commits all or nothing.
  - A bad member, a manifest mismatch or a conflict rejects only that package: `RENOVICE PACKAGE REJECT … reason=… scope=package-local`.
  - Conflicts: the same replacement or target key held by a package and another enabled source. The later-sorted source (loose files sort first) fails closed.
  - Untargeted managed addons and one-shot chunks are not admissible members.
- **Circuit (fix 3).** Live pid 23260: DuviriUtil's root closure kept its entry environment across `module(...)` (`entry_env == runtime_env`), and the retry failed again. At the root's return, the runtime now binds in the environment of the root's own child closures (from its dead register window; all must agree), else in the root closure environment. The log shows `env_source=… child_closures=N`.
- **Diagnostics.** The source log keeps one open handle; diagnostic lines are buffered (64 KiB, 250 ms, flushed before operational lines, on exit and on a recorded fault). Per-hit trace lanes are limited to 32 lines per event per second, with suppression summaries.
- **Diagnostics=false** now formats nothing: dispatch labels, the performance line, the float-transform details and the hook-PASS identity (64-bit hash, checked first).
- **Docs.** The hooks doc now states that `instruction` is the `NAMECALL` index (Mallet p16: 596).

Gates and build:

- All gates PASS, including new `verify_script_packages.ps1` and the injection/config core gates (both now in the build).
- Private build PASS, 0 warnings, 0 errors.
- DLL `6f100ebcb087cebf977781217897356a9ab208f9c5f273b62358f64462c79248` (5,081,088 B), staged at `work/staging/bootstrapper-packages/`.

**Deployment and live checks are pending.** Rollback: `420e10a4…`. The Missions package (generator Phase 2h) replaces `Inject\Missions.targets.addon.lua_B` and the root `fc711ff621a75552 (missions_exact-replacement).lua_B`; remove both. [Record, migration and checklist](../RESEARCH/SCRIPT_PACKAGES_AND_FIX3_2026-09-29/README.md).

## 2026-09-29 Fix 2 after the first live run of `83e74faf…` staged (not deployed)

Branch `fix/multi-target-live-run-2026-09-29` (from `67cd256`). Live run: 44.0.2, pid 32336, Diagnostics on.

- **Survival worked.** Reward tier 1 came at 150.33 s and tier 2 at 300.02 s. The apparent "missing" second reward was a 730 s pause menu.
- **Survival hook errors had a runtime cause.** The luaCalls.before read-back reused the upvalue view table's stack slot as scratch space while it read the arguments. Every hook called with one or more arguments failed at copy-back:
  - protos 67/68/69: `stage=read-upvalue index=0 raw_status=2`;
  - proto 61: `mutation rejected upvalue=1 candidate_tag=0`.
  - The callbacks themselves ran, so the table writes survived.
  - Fix: the read-back leaves both view tables untouched.
- **Bind once.** `IceSpike.lua` ran 3,470 root instances in the session (SurvivalMission ran 8), and each one did a clean/load/activate cycle and wrote 3 log lines. Now:
  - Only a module whose addons hold **no** binding is watched.
  - Such a module gets **one** root-return retry per generation.
  - Bound modules do zero per-instance work. Prototype-matched hooks still reach every instance.
- **Circuit.** DuviriUtil's root calls `module(...)`, which re-points the root closure's environment to the module table. `67cd256` captured the environment at root entry, so it rebound in the wrong one. The retry now reads the environment at the root's return.
- **`lua.call.before.reject`.** Now gated by the diagnostics check before any work, sampled, and carries prototype and occurrence. It previously wrote 28,576 identical lines and used up the trace budget.
- **F9 errors.** F9 member rejections and Inject-scan rejections now reach the file log.
- **`WRONG NUM REWARDS`.** Stock EndOfMatch prints this. It is pre-existing (it appears in the 2026-09-06 logs, before any mission addon existed) and is not ours.

Gates and build:

- All gates PASS, including new checks in `verify_injection_core`, `verify_target_root_binding`, `verify_lua_call_raw_protection` and `verify_unified_diagnostics_master`.
- Private build PASS, 0 warnings, 0 errors.
- DLL `420e10a400d9b7f6fc934639732a5365b0925fa969e91ef0b73612bf1e98f4da` (4,927,488 B), staged at `work/staging/bootstrapper-multitarget-fix2/`.

**Deployment and live checks are pending.** Rollbacks: `83e74faf…`, then `15daf981…`. [Record and checklist](../RESEARCH/MULTI_TARGET_LIVE_RUN_FIX2_2026-09-29/README.md).

## 2026-09-29 Multi-target addons, target-root instance binding and luaCalls attribution staged (not deployed)

Branch `feat/multi-target-addon` (from `bcad39e`). Three generic runtime changes; none is specific to a module, mission or ability.

- **Multi-target addons.** `Inject\<Name>.targets.addon.lua_B` returns `{activate?, cleanup?, targets = {["<16-hex key>"] = {hooks, activate?, cleanup?}}}`.
  - Declared keys are the lowercase 16-hex constants in the bytecode string pool. They are inventoried even while the file is disabled.
  - The file expands to one ordinary target binding per key. Each binding selects `targets[key]` in the protected load leaf.
  - The file gets one Scripts row and one policy. A bad file or entry fails locally.
  - Single-key `<key>.<Name>.target.addon.lua_B` files are unchanged.
- **Target-root instance binding.** The runtime watches the root prototypes of target modules and records the runtime environment each root actually ran in. At the next exact idle return it rebinds the addons there (`TARGET ROOT RETURN ... action=rebind-queued`).
  - This fixes Circuit's `activate`, which never saw root-published globals.
  - Lifecycle binding follows the most recent root instance, with one binding per VM x module x generation.
- **luaCalls attribution.** Calls are now attributed by exact live prototype identity instead of the load environment. The strict environment check had silently rejected every luaCalls dispatch since V107; this was the Survival root cause.
- **Error text.** Lifecycle, chunk and `luaCalls.before` failures now log a bounded, sanitized copy of the Lua error.

Build and gates:

- New gates `verify_multi_target_addon.ps1` and `verify_target_root_binding.ps1` are added to the build. All existing gates pass.
- Private `-O3` build: PASS, 0 warnings, 0 errors.
- DLL `83e74faf399bccb33306fa19d225b5cfb59a935496e7bced9bdd30723efd51a9` (4,921,344 B), staged at `work/staging/bootstrapper-multitarget-addon/`, with an opt-in hook-free probe `opt-in-live-probe/Inject/MultiTargetProbe.targets.addon.lua_B` (`76857273...056a`).

**Deployment and every live check are pending.** Run these by hand with the game closed for the DLL swap. Keep `15daf981...` as the rollback.

1. Log: `DE_VM_AUTHORITY PASS` and `RELOAD PASS`.
2. Scripts menu: row count unchanged with the current files. With the probe added, exactly one extra row, `[ADDON] Multi Target Probe`, tooltip `target 3 modules`.
3. Survival: `native hook PASS key=f10a043e7f825db2 event=luaCalls.<P>.before`, with no `luaCalls.before protected leaf FAIL`. In EE.log, `Host - first reward` about 150 s after `ENDLESS`.
4. Circuit: `TARGET ROOT RETURN key=95ef5b82a8400944`, then `TARGET ADDON PASS`. The stage preview shows 500/550/625/725/850.
5. Mallet and Ice Wave: effects work. Also watch for repeated `TARGET ROOT RETURN` lines per cast.
6. Elite Sanctuary: still works.
7. F9 with no changes, then F9 after disabling and re-enabling the probe row.
8. F10/Pluto hotkeys and the Arsenal/Simulacrum search (`Limbo`, `00`, `codha`).
9. Riven replacement: reroll locks still work.

[Record and mission-generator contract](../RESEARCH/MULTI_TARGET_ADDON_AND_ROOT_BINDING_2026-09-29/README.md). Script format: `OpenWF/CustomScripts/HOW_TO_ADD_SCRIPTS.md` (repository copy).

## 2026-09-29 44.0.2 DE_VM_AUTHORITY lock-identity fix staged (not deployed)

Live 44.0.2 log with installed DLL `a5508dae…`: `DE_VM_AUTHORITY resolve FAIL primitive=lock-enter/lock-leave matches=0`, so no VM capture, Scripts menu, Inject or addons (Replacement unaffected). Cause: the `_u44` lock signatures appended the prologue of the unrelated function the linker placed after each `mov rcx,[rcx]; mov rcx,[rcx]; jmp [IAT]` thunk; 44.0.2 relocated the thunks. Lock thunks now resolve by exact identity (thunk body + named `KERNEL32!Enter/LeaveCriticalSection` IAT slot from the import-name table), cross-checked against the locked dispatcher's +40 enter call and epilogue leave tail-jump; build allowlist and fail-closed uniqueness unchanged. Verified offline on U43, U44.0.0, U44.0.2; full 147-pattern census shows no other 44.0.0->44.0.2 change. `verify_client_44` now covers the lock chain. Private build PASS 0/0, DLL `15daf981af6ad7a358500f36084c9c23a94f4e9ac0881184bd29a118a7b73cea` (4,890,112 B) staged at `work/staging/bootstrapper-44.0.2-vmauthority/`; `Hotfix.owf` unchanged in content. **Deployment and live acceptance pending.** [Record](../RESEARCH/DE_VM_AUTHORITY_LOCK_IDENTITY_44_0_2_2026-09-29/README.md).

## 2026-09-29 Hotfix 44.0.2 certified and installed in the Steam folder

Client `2026.09.28.13.06` (Steam `00cf8761…`, sideloadified `0124f0b9…`) added to the exact U44 allowlist; engine-damage exact RVAs added. All version44 signatures resolve uniquely, the Luau VM body is unchanged and all 14 bound stock modules are byte-identical, so no addon/replacement re-port was needed. DLL `a5508daebb21b89739102266775c3db94a676c4aea818e75fb66eccc34f88bbf` installed in `C:\Program Files (x86)\Steam\steamapps\common\Warframe`; OpenWF files unchanged. In-game acceptance pending. [Receipt](../RENOVICE_DEPLOYMENTS/HOTFIX_44_0_2_2026-09-29/README.md).

## 2026-09-27 Mallet reserved-hook declaration repaired

User reports U44 scripts/cards work and Ice Wave +10 works when starting as Frost, but Octavia -> Frost fails to apply the bonus. The recent Mallet nativeCalls.PushFloatArg declaration conflicts with the installed runtime reserved-method gate and can block later native-hook installation. Deployed Mallet now uses the existing transformFloatArgument contract at p16/i597. Addon SHA256 `0acbfea23262dc6d1f0103e469cca1ff94cf5d4757cb567326d1b344013baae5`. DLL and Ice Wave unchanged; diagnostics off. Offline gates passed; fresh-process loadout-switch gameplay acceptance pending. [Evidence](../RESEARCH/LOADOUT_NATIVE_HOOK_CONFLICT_2026-09-27/findings.md).

## 2026-09-27 U44 Lua compatibility candidate installed

DLL `86f0efc943b60785b8edecf5e3f921abdf5ee560fe925a203e60469e96b902db` (4,884,480 bytes) is installed in `Warframe 23.09.2026` with all 7 Inject and 9 root replacement files ported to the current stock targets. Shared compiler/runtime build profiles cover U44 native names/opcodes, embedded helpers, verified prototype layout and exact callsite bindings. Universal API and existing ownership/Pluto architecture remain intact. Diagnostics remains false. Build, package, current-client/TopMenu and installed admission checks pass; **fresh-process Scripts menu/cards/effects/F9 gameplay acceptance remains pending**. Original DLL/scripts/state file are retained in rollback.

[Concise evidence, limitations and future update procedure](../../../../work/research/U44-2026-09-27/lua-port/findings.md).

## 2026-09-27 U44 private-client candidate

Exact 2026.09.24.13.29 port was initially installed in `work/staging/warframe-u44-client`, then promoted at the user's request to `C:/Users/Bartek/OneDrive/Dokumenter/Warframe 23.09.2026` with matching executable/DLL/Hotfix hashes. Startup reaches main menu with metadata patches enabled. Native string borrowed ownership changed in U44; the new conditional marker fixes the reproduced startup allocator crash. DLL SHA256 `0eeaa5d9e416a6f9d248e76d8130c85d50a44d9163279143bbf853674b3b4674`. Existing injector/Pluto architecture retained; mission/addon/F9/F10 and long-session acceptance are pending. The usual installed client now runs U44; mods/settings were preserved. [Evidence and remaining gates](../../../../work/research/U44-2026-09-27/findings.md).

The V110 and earlier records below describe the prior installation.

**V110 INSTALLED; OFFLINE BUILD/PACKAGE/INSTALLATION PASS; fresh-process
gameplay acceptance pending.** V109 live evidence falsified the claim that
Mallet or its stock damage body was absent: the target addon loaded, and the
battle observer recorded 1,528 Mallet-body damage records. The actual break was
earlier in the additive transport. `SetSourceObject` ran, strict
closure/environment ownership returned no target, and there were zero target
matches, callback installations, callback entries, or `afterDamage` dispatches.
V110 preserves strict closure ownership when it matches and adds the same exact
current-generation prototype plus saved-instruction identity already used by
the generic native-call bus. Ambiguity, stale prototypes, cross-VM ownership,
and non-exact saved PCs still reject. There is no Mallet key or ability-specific
C++ branch. The unified diagnostics master switch is `false`, so ordinary play
performs no battle-observer callback, JSON, snapshot, or formatting work.

The installed 4,857,856-byte DLL SHA-256 is
`3319C7372C9756B599F624BA3794B39FEC79AD3FB2A1BDE409E49E2C7365B85C`.
The finalized package preserves exact V109 rollback
`45B8BDA11BEF71F2873A1DE1E90837A6AAFE7FE4C157ED16CBEE4D6A719F1C69`.
Independent installation audit covers 92 files and proves only
`WTSAPI32.dll` changed; all 41 CustomScripts files are byte-identical. See the
[V110 evidence record](../RESEARCH/MALLET_EXACT_TARGET_V110_2026-09-20/README.md).

**V109 INSTALLED; OFFLINE BUILD/PACKAGE/INSTALLATION PASS; live acceptance
pending.** The universal Inject/Replacement loader remains intact and has no
script-count cutoff; the former 4,096-row SCRIPTS presentation cap is removed.
V109 routes the existing loader, target-addon, ability-card, SCRIPTS UI,
callback-runtime, native observer, and F9 refresh operations through DE-owned
protected VM boundaries so a Lua error cannot strand C++ ownership or a
half-created UI transaction. The private x64 build passed with zero warnings
and zero errors. The installed 4,857,344-byte DLL SHA-256 is
`45B8BDA11BEF71F2873A1DE1E90837A6AAFE7FE4C157ED16CBEE4D6A719F1C69`.
The finalized package preserves exact V108 rollback
`82D34D2321667909E11327535A33B1D4E71130F6C9AB31A9C9DB255CAA676227`;
the post-install audit covers 90 files and proves only `WTSAPI32.dll` changed,
with all 39 CustomScripts files preserved. Diagnostics, Logging, and Verbose are
enabled for the fresh-process acceptance run. Read the [V109 authority and UI
stability record](../RESEARCH/DE_VM_AUTHORITY_V109_2026-09-19/README.md).

**V108 INSTALLED-BYTES AND OFFLINE GATES PASS; live acceptance pending.** V107
failed before generation 1: its mandatory ordinary detour targeted DE callback
RVA `0x197EC80`, whose relative `JNS`/`CALL` prologue cannot be copied by Soup's
trampoline builder. The resulting exception removed the valid base loader and
VM-execute hooks, so the hidden bridge, `SCRIPTS` row and every Inject target
addon were absent together. V108 observes the same stock event at the unique
interrupt-counter leaf RVA `0x1AB150`, executes stock exactly once and preserves
its result. Counts above the stock `800000` limit bypass addon observation so
DE's unchanged parent guard raises first; C++ observer failures return the
stock count through a `noexcept` boundary and scoped VM-stack restoration. Base
hooks are enabled before this observer; observer detour
creation/enable failure is capability-local and cannot tear down ordinary
Inject, replacements or the Scripts bridge. The exact installed 4,790,784-byte
DLL SHA-256 is
`82D34D2321667909E11327535A33B1D4E71130F6C9AB31A9C9DB255CAA676227`.
Pre/post audits cover 89 files and prove only `WTSAPI32.dll` changed; all seven
Inject and nine root replacement files remain byte-identical and pass their
focused live-directory admission gates. Read the [V108 root-cause and repair
record](../RESEARCH/UNIVERSAL_LUA_LOADER_REPAIR_V108_2026-09-19/README.md).

**V107 INSTALLED-BYTES PASS; LIVE REJECTED.** The
old interpreter-entry `luaCalls` implementation was not universal: DE CALL
creates and enters nested Lua frames inside one invocation of VM execute. V107
was intended to observe raw CALL `0x54` at DE's natural interrupt callback
`0x197EC80`, call the stock interrupt first and exactly once, validate the exact
Lua frame and prototype code interval, decode the caller's A/B argument window
and dispatch the existing protected host frame. Its trampoline never installed,
so none of that path ran live. Before-only callbacks retain no CallInfo
pointer, argument registry root or after token. Every `luaCalls.after`
declaration now rejects at staging because exact RETURN/yield/error/cleanup
retirement is not implemented. The full x64 private build passes with zero
warnings/errors; this verification build produced candidate DLL
`C0AA443D4858A205959C57C5CBDD469606A459F4F7E59882EAD0D5ADEC31D2C8`,
whose hash is build-instance-specific because the normal archive is
time-versioned, 4,787,712 bytes. The exact previous V106 DLL is preserved as
rollback. Pre/post installation audits cover 89 files and prove that only
`WTSAPI32.dll` changed; `OpenWF/Hotfix.owf` and every Pluto script, addon,
configuration, replacement and metadata file remained byte-identical. Stable
decompilation of the seven installed Inject bytecode
files confirms the only Lua-call users are Mallet 18, Survival 64 and
Interception 35, all before-only. Native after hooks used by Elite Sanctuary
and Ice Wave are a separate supported bus. Read the
[exact implementation and acceptance boundary](../../toolchains/native-analysis/RESEARCH/2026-09-19_RUNTIME_SCRIPT_PIPELINE/V107_BEFORE_OBSERVER_IMPLEMENTATION.md).

**V106 INSTALLED-BYTES PASS; fresh F10 acceptance pending.** The V105 session
successfully requested and connected to the standard Simulacrum once, proving
that its Pluto script, `Engine.OpenLevelArgs`, level and game-rules paths were
functional. The remaining source flaw was universal: configured key edges were
sampled only inside the cached UI VM's owner/thread/idle eligibility gate. A
press and release during a non-idle interval could disappear. V106 samples
physical state at the process-owned Application frame, performs no Lua/game-VM
work there, queues at most 64 configured scripts, and dispatches at most eight
per safe Pluto tick. Focus, input-filter, modifier and server prohibition rules
remain enforced. `/status` now distinguishes captured, pending, dispatched and
dropped edges. All runtime/VM/ownership/diagnostics/hotkey invariants and the
full private x64 build pass with zero warnings/errors. Pre/post audits pass
33/33; only the DLL changed. Installed SHA-256
`2BDF0B9AD026562C1E1EDC369C825CA5209AC5F97C64C2A82F3DC18656D8325D`,
4,795,392 bytes. Exact V105 rollback retained. Read the [V106
report](../../../../Documentation/04-Runtime-and-UI/V106-Process-Owned-Hotkey-Latch-2026-09-17.md).

**V105 INSTALLED-BYTES PASS at `2026-09-17T18:56:13.1458780Z`; live
acceptance is pending.** The latest Arsenal/modding-UI log ends at the same
`Warframe.x64+0x1834116` assertion as the previously dump-mapped V103
Railjack-to-hangar crash. Diagnostics were false and the engine heap was not
exhausted. The mapped path is Pluto GC -> `owfUserdata.__gc` ->
`ivkr_push_string` -> game `luau_pushstring`: registry cleanup was allocating
against a cached UI state from the native Application-frame scheduler, outside
a current game-owned Lua API invocation. V105 preserves the exact cleanup and
all Pluto features. Root constructors capture their DE global-state owner; the
finalizer queues only key+owner; a bounded queue drains only from an
owner-matched real game set-global call with checked stack capacity and stack
restoration. There is no drain in the Application-frame scheduler, and V104's
rejected `UpdateFlashMarkers` hook remains absent. Full private x64 build passes
with zero warnings/errors. Independent installation audit passes 33/33 files:
only `WTSAPI32.dll` changed. Installed SHA-256
`F7BB73C6A53718A98E9D7AF87116818D51F57503F0CF65FE0D1954E88D5E60BC`,
4,791,808 bytes. Exact V103 DLL/config rollback is retained. Read the [V105
report](../../../../Documentation/04-Runtime-and-UI/V105-Deferred-Registry-Release-2026-09-17.md).

**V103 RESTORED at `2026-09-17T11:26:14.8840390Z`; V104 is LIVE REJECTED.**
The installed game DLL and the repository root artifact are the exact V103
bytes, SHA-256
`738112A1FDE93685B0EBD982243EBBBBBC09E8C29E952FF542CED56BB6EA26BC`.
The rollback audit passes all 33 baseline files; only `WTSAPI32.dll` changed
back and the other 32 files remained byte-identical. No Pluto payload, Lua
addon, replacement, ability card, configuration, metadata patch, server or
account file changed.

V104 restored Pluto to the `UpdateFlashMarkers` method-table entry and added a
thread-local ownership scope intended to make RENOVICE dormant during nested
Pluto bridge calls. F10 worked, proving that Pluto was clocked. Exact `Limbo`
search then crashed. CDB proves this is the **same null-continuation family as
V21/V22/V37**: exception `c0000005`, execute address zero, first game return
`Warframe_x64+0x19815c9`, failure bucket
`SOFTWARE_NX_FAULT_NULL_INVALID_POINTER_EXECUTE_c0000005_Warframe.x64.exe!Unknown`,
failure hash `{b2e2f003-f1a9-53a7-3fe6-e89cb3ca4935}`, and the same fourteen
game-module stack offsets. At `Warframe_x64+0x19815c7`, the VM executes
`call rax` after loading the callable target from `closure+0x20`; `rax` is
zero. The activity scope therefore did not make this scheduler boundary safe.

The failed hypothesis was that nested RENOVICE observation was the missing
difference in V37. V104 bypassed those nested observer calls and rejected the
outer return as a later RENOVICE safe point, yet it still ran Pluto from inside
the live DE C/namecall frame. It also could not identify the Pluto-containing
outer interpreter execution until that execution had already entered the
RENOVICE VM observer. Direct `UpdateFlashMarkers` scheduling must remain absent
from the combined runtime. The preserved V104 source, binary, dump, debugger
reports, deployment receipts and V103 rollback are recorded in the
[V104 rejected-candidate report](../../../../Documentation/04-Runtime-and-UI/Pluto-RENOVICE-Decoupling-V104-2026-09-17.md).

The V102 and older sections below are dated evidence. They do not override the
current V103 installed-byte result or the V104 live rejection.

**V102 universal target binding repair INSTALLED
2026-09-17T07:48:32.1939818Z; fresh live acceptance is pending.** V101 live evidence proves
exact Ice Wave target `f62b70b45fc7fdf9` and Mallet target
`8faf07b504d058f` discovery, followed by the same
`generation-borrow-timeout` rollback. V101 held a dispatch lease across the
owning VM callback, then incorrectly required the first additive target binding
to acquire an exclusive mutation lease from that same thread. V102 permits
only a first binding with no existing context roots to publish inside its owned
immutable generation. Rebind/removal stays queued until outer return releases
the lease; F9 still drains the old generation; native hooks stay process-owned
and Lua providers stay generation-owned. The rule is generic for every exact
target key/VM/thread. No Lua addon, replacement, card, metadata, config, hotkey,
Pluto payload or server file changed. Final x64 private build passes with zero
warnings/errors; exact candidate SHA-256 is
`F5E55711E311D5B7134F05971211DB2A3AEAA212D033009A93CCB88EE08C408F`,
4,786,176 bytes. Package:
`RENOVICE_DEPLOYMENTS/TARGET_BINDING_GENERATION_OWNERSHIP_V102_2026-09-17`.
Transactional installation and the independent 33/33 audit pass; only
`WTSAPI32.dll` changed and V101 rollback is retained.
Fresh-process Ice Wave/Mallet cards, gameplay callbacks and F9 remain separate
live acceptance gates. Read the [V102 evidence and protocol](../../../../Documentation/04-Runtime-and-UI/V102-Universal-Target-Binding-Generation-Ownership-Repair-2026-09-17.md).

The V96 and older status sections below are dated history retained for their
evidence; they do not override the current V101 failure or V102 installed state.

**V96 persistent memory evidence INSTALLED2026-09-16T02:05:27.0898534Z;
first fresh capture LIVE PENDING.** Basic logging and the independent
`DiagnosticsMemory=true` setting are on; battle/engine/caster/buff observers
remain off. Future launches append physical per-session memory records at
natural owning-VM returns, no more than one per five seconds. No Lua object/log
queue, collector control, gameplay polling or external worker was added.
Generic host errors now preserve decoded target/prototype/phase context.
Private build has zero warnings/errors; exact U43/native field, core/policy,
native observer/analyzer, archive and installation checks pass. All33 baseline
files verify; only DLL/config changed. All68 embedded assets, including Pluto,
and gameplay/addon/replacement/card/metadata/server bytes are preserved.
V95 rollback pair retained. **The underlying OOM remains unresolved**; inventory,
build and Archon Shard menus are leads rather than proven causes. Read the
[V96 operational/evidence guide](../../../../Documentation/04-Runtime-and-UI/Persistent-Memory-Evidence-V96-2026-09-16.md).
The V95 statements below retain their earlier investigation/deployment scope.

**Update2026-09-16: V95 live long-soak acceptance FAILED twice with Internal OOM,
including fresh PID15532 with battle diagnostics off.** Combat Lua samples stay
approximately25–31MB; steep engine heap growth follows extraction/Orbiter return.
The crash-time native Lua allocation sample is1.14GB with millions of userdata
in a partial census. A pre-crash collector stall is UNPROVEN because the last
static cycle sample was already inside crash handling. No production source,
DLL, addon, replacement, metadata, server or configuration changed in this
investigation. An external read-only observer is prepared and controlled-reader
tests pass; no complete OOM repair or latest-dump attribution is claimed.
Read [latest hypotheses, fingerprints and capture gate](../../../../Documentation/04-Runtime-and-UI/V95-Long-Soak-OOM-and-External-Memory-Capture-2026-09-16.md).
The V95 installed/pending paragraph below retains deployment-time history.

**V95 universal native Lua API frame repair INSTALLED 2026-09-16T00:44:27.5055845Z; live acceptance PENDING.**
Diagnostics are OFF. DLL C5F8171D... / 4,754,432 bytes. The three Survival source
sessions end at checked reservation failure; the first saved dump proves
7,998+12 exceeds native 8,000. A shared temporary CallInfo.top leak is reproduced
by real Luau: old rejection on boundary665, production restoration passes10000.
All48 reservation scopes are guarded. Generic luaCalls work now uses a real
protected native C frame, with consistent base/CallInfo and unchanged native
limits/GC schedule. Original argument snapshots remain registry-rooted through
stock execution/after dispatch, then release before transactions;1000 native
GC lifetime cycles pass. Invalid capture cannot dispatch a fabricated empty list.
The newest login EE assertion is in a free routine with diagnostics off; fresh
dump/registers unavailable, precise invariant/caller and association UNPROVEN.
Do not claim all crashes fixed or blame diagnostics/AlternativeLoading alone.
Private x64 build zero warnings/errors, core/native/analyzer/exact U43 checks
PASS. All68 embedded assets matchV92, including Pluto. All33 installation
baseline files verify; DLL-only change, gameplay/addon/replacement/card scripts,
metadata and server preserved. V94 rollback retained. Fresh login, Survival
keypad/abilities/extraction and repeated menu/region loading are the next live
tests; F9/F10 and diagnostics-on soak remain separate.
Read [V95 hypotheses, repairs and exact evidence](../../../../Documentation/04-Runtime-and-UI/Universal-Lua-API-Frame-Repair-V95-2026-09-16.md).
Earlier installed/pending and failure statements below are dated history,
including the earlier unproven large-frame writer and V94 runtime unchanged
statement; they are not the current V95 status.

**V94 output admission and bounded callback memory evidence INSTALLED
23:50:11.3904913Z on 2026-09-15 (September 16 local time); fresh live PENDING.**
DLL 243CC91E... / 4,733,952 bytes. V93 startup and 110 Ice Wave formula/native
checks passed, but its live soak FAILED with another 4.29 GB game-heap OOM;
Lua totalbytes grew 45 MB → 1.22 GB → 2.16 GB during Arsenal/menu activity.
V94 admits inserted automatic/caster/HUD snapshot work using the existing trace
output capacity before Lua allocations. Gameplay callbacks still execute, with
nil diagnostic trace after exhaustion; in-flight observations always finish.
Bounded read-only callback net-memory records share battle/trace mode; no GC
scheduling or threshold changes. Native manager GC step/stop is independently
verified. V93 native GC barrier/checked stack/offset restoration and V92 bounded
interrupt isolation are preserved. Core/admission, native observer/analyzer,
exact U43 compatibility and full zero-warning/error x64 build PASS. All 33
baseline files verify; only DLL changed. All 68 embedded assets match V92,
including Pluto; gameplay/card/addon/replacement scripts, metadata knobs,
F9/F10, enabled diagnostics and server remain unchanged. V93 rollback retained.
The reviewed V92 primary91 + follow-up113 + V93initial110 =314 Ice Wave hits
have zero formula/packet/restore discrepancy. Complete crash, menu/region memory
soak, F9 and diagnostics-off acceptance remain live gates. Read
[V93 failure, V94 repair and exact evidence](../../../../Documentation/04-Runtime-and-UI/Diagnostic-Output-Admission-and-V93-OOM-2026-09-16.md).
Earlier installation/pending statements below are dated history; they do not
override this current live failure or promote V94 to gameplay acceptance.

**V92 callback allowance isolation INSTALLED22:40:10.9243239Z on2026-09-15
(2026-09-16 local time); fresh live PENDING.** DLL968563.../4726272bytes.
Avalanche then Ice Wave caused an engine OOM assert; captured source tail records
10520casterStats.before interrupt-limit errors. Exact U43 native guard/increment
signatures prove thread counter0x88/limit800000. Six typed inserted protected
callback adapters now scope/reset/restore their own allowance, preserving the
stock counter across nested calls and C++ unwind. Existing watchdog, loader
protected calls, callbacks, diagnostics collectors and native scheduler remain.
Production scope/core/full private build gates PASS, zero warnings/errors;
exact signed embedded Pluto runtime6A2908...unchanged. All33baseline game files
verify; onlyDLLchanged, current Ice Wave/Mallet/other scripts, metadata, F9/F10
and enabled diagnostics configuration preserved; V90_R2 rollback retained.
Source-log baseline253365998. Native allocation leak/cleanup causality and full
crash fix remain unproven until a fresh game reproduces Avalanche into Ice Wave.
Read [native evidence and reusable callback rule](../../../../Documentation/04-Runtime-and-UI/Inserted-Callback-Interrupt-Isolation-2026-09-16.md).
The following V91_R1/V91 runtime statements are dated installation history.

**V91_R1 Ice Wave wording INSTALLED22:25:34.9204966Z on2026-09-15
(2026-09-16 local time).** LI-013 native row renamed Cold Damage Multiplier;
added CAT sentence is "Deals additional damage to foes afflicted with Cold."
Only the Lua label literal and CAT sentence change; shared Strength helper and
damage formula are unchanged. Deterministic compile,37/37roundtrip/plan/IR,
43APIcalls0unknowns/violations and23gameplay/card fixture transactions PASS.
Addon1A51C4.../10449bytes andCATF5185D...installed;33baseline game files verify,
V90_R2 DLL17414E...unchanged, immediate V91 rollback pair retained. Source-log
baseline249069208; process count3, disk files only. User screenshot confirms
V91 native rendering at base1/modded2.83x; revised wording/live regression
remain separate checks. Restart to reload cached CAT description. Read
[current native card recipe](../../../../Documentation/02-API-and-Addons/Native-Ability-Card-Extensions-2026-09-16.md).
The following V91 installation paragraph is preserved as dated history.

**V91 Ice Wave native-card addon INSTALLED22:12:48.7291563Z on2026-09-15
(2026-09-16 local time); runtime V90_R2 unchanged.** Existing LI-013
matchesAbility/afterAbilityCard bus adds ordinary Additional Damage Multiplier
row, extra per Cold stack: base1x/300%Strength3x. One BONUS_PER_COLD_STACK and
shared unit/operation10 Strength helper feed the card and unchanged V81 damage
formula. Exact tags IceWaveAbilityName/Desc confirmed, native UNIT_MULTIPLIER
from stock BardMusic. Existing CAT description keeps DE's English sentence and
adds Cold-stack wording. Deterministic compile/reparse,37/37roundtrip/plan/IR,
43APIcalls0unknowns/violations,23logged gameplay fixtures/card isolation PASS.
AddonD24673.../10455bytes andCAT EAA27C... installed;33baseline files verify,
DLL17414E...unchanged and original V81addon/CAT rollback retained. Log baseline
233227406; game process count2 at installation, file delivery only, no runtime
restart triggered. Restart for cached CAT map; fresh card/base-modded comparison
and post-card-change gameplay regression remain live gates. Read
[current native card recipe](../../../../Documentation/02-API-and-Addons/Native-Ability-Card-Extensions-2026-09-16.md).

**V90_R2 fresh review2026-09-16 local time: background/target math ACCEPTED
for captured conditions.** PID4916 started21:52:36.5413730Z; fixed capture
21:54:28.737Z on2026-09-15, bytes213916040..219466911, SHA577C3B...;
installed DLL17414E...matches receipt. Zero stack warnings and nil-avatar errors,
F10 entry/request/return, native frame=current-u43/1match/installed/first-pass.
684/684 complete non-additive observations,0duplicates/incomplete,205knowncaster
snapshots,256stock calculations,1545available complete native buff lists,
234exact native caster/list joins; IceStorm/MoltAugmented/Brightbonnet types
recorded. Strength253–356.159806%,Range220%,Duration127.5–167.5%,Efficiency45%.
IceWave67/67 per-target math/install/stock restore and67/67 enclosed native
pipeline cross-checks PASS;7mixed batches, including two3/10Cold hostile batches.
ZeroCold targets are5Sentinels with no pool loss; fresh hostile0/6not claimed.
Two sequential stock handler observations per target are not extra addon damage.
Only startup reload appears; F9/off/all-transition/full contributor gates remain
separate. No gameplay/runtime code changed during this review. Read
[fresh central review](../../../../Documentation/03-Abilities-and-Combat/V90-Live-Combat-and-Buffs-2026-09-16.md).
Earlier deployment pending statements below retain their dated snapshot meaning.

**V90_R2 DEPLOYED21:45:12.5322948Z; fresh live pending, baseline213916040.**
Shared optional userdata reader consumes native nil exactly once at existing
Player.GetAvatar/GetHudStatus and Region.GetLocalPlayer/GetGameCamera wrappers;
GetLocalPlayerAvatar always invokes the already nil-consuming entity reader.
Production replay reproduces old92residual nil values/avatar constructor failure,
then passes29cases/1,000absent calls and full Pluto syntax, including zero native
results without consuming prior stack values and extra-result rejection. Pinned bgscript,
original stack-warning check, native frame owner/idle/panic/stack guards and raw
DE observer/gameplay addons remain. Existing Hotfix targets another title, so
does not shadow runtime. Clean x64 DLL4724736bytes SHA
17414E41548819C7378257D1CCA97DE5B20CCC2472A9F38112055E4215A1DED8;
actual DLL archive contains exact repaired runtime6A2908.../98713bytes.
Final23artifact package/20gameplay-config/32metadata-hotkey-utility preservation PASS;
V89 rollback retained. Initial CRLF build warnings rejected, LF source/manifest
normalization preserves logical manifest contents; rejected logs retained.
User requested repair and a separate fresh combat test. Game closure independently
verified before installation; dated receipt records installed hashes. Pending test must verify no residual warnings/nil errors,
F10/return/menu behavior and per-target Ice Wave formula/buffs/stats separately.
Read [central repair](../../../../Documentation/04-Runtime-and-UI/Optional-Player-Bridge-Repair-2026-09-15.md).

**V89 frame/F10 LIVE ACCEPTED 2026-09-15, PID5880.** Fresh process started
21:17:19.653942Z; review21:24:24.853Z records RESOLVED unique=1, INSTALLED and
FIRST_PASS. Live status=current-u43/matches1/installedtrue/first_passtrue.
F10 entered/requested/returned in order; the user confirms actual Simulacrum
entry. DLL/script/hotkeys/config hashes match their deployment. Fixed source
capture171843055..189216132/SHAB6E97C... and status/traceback retained in
[the new live case](../../../../work/diagnostics/f10-v89-live-2026-09-15/README.md).
The script log also contains92 stack warnings and Background Script:407 nil
LotusAvatar constructor failure, separate open findings. This review changes
documentation only; no new combat, F9 or diagnostics-off acceptance is claimed.
Earlier frame/F10 pending statements below are dated history, superseded only
for those specific gates by this fresh result.

**V89 DEPLOYED20:45:11.4386289Z.** Clean private
x64 build0warnings/errors,4724736bytes SHA
395D11265117C019A14A6237F199C2470D640E66E61588468B77E45C240C2C65.
Installed package41artifacts/all20prior script/config entries PASS; log baseline
171843055. F10 Lua phase scriptCBE98.../numeric121/O/config480DC...unchanged.
V88 live PID12728 captures UI userdata9 but native-frame-installed/firstPass false.
Old pattern0disk matches in current CCA46D...exe; corrected1matchRVA0xE6EADD,
live bytes identical, real Application storage/vtable[2] game frame validated.
Patterns versioned in application_frame_profile.hpp; select exactly1eligible
match, rejectmissing/conflicting/duplicate/uncertified. NoRVAfallback or rejected
Lua UI method clock. Native original-first owner/idle/stack guards unchanged.
Status now includes profile/matchCount; centralized toggled one-off RESOLVED,
REJECTED,INSTALLED,FIRST_PASS/INSTALL_TIMEOUT. Source/productionprofile/guard20
and clean private build PASS; user game-closed/install instruction applied to
exact old PID12728 before paired DLL/script installation. Rollback V88pair saved.
Raw observer20825/SHAED98...andMallet/IceWave/replacements/metadata unchanged.

**V88 live logger reviewed20:40:38Z:**602/602complete,0incomplete/duplicates,
520engine+61script+21IceWave modifier separate nonadditive observations.
153/153knowncaster stats after separate256operation203limit;153each effective
Strength2.53–2.978,Range2.2,Duration1.275–1.675,Efficiency0.45.
1599parsed/availableHUDowners,2454lists/855populated/eight actualAbilityTypepaths.
Probe128suppression independent of full list lane. Faultfile0bytes; F9/off
pending. Captured/UIstate or running-autostart list alone is NOT executionproof.
DirectNameTag/base/loadout/fullmod-shard-buffdecomposition stillunavailable.
Research NATIVE_FRAME_F10_REPAIR_V89_2026-09-15 and central frame guide contain
actualcapture/fingerprints. The original server reward audit captured Archon Hunt
×3 and calendar ×1. Later on 2026-09-15 the user requested the separate server
setting `privateServerTuning.calendar1999RewardMultiplier=3`. Thirteen production
controller/real-acquisition fixtures, server verification, formatting and lint
passed; calendar preview/live acceptance remains separate. No bootstrapper/DLL
change is involved. Read the central
[calendar guide](../../../../Documentation/05-Missions-and-Rewards/Calendar-1999-Reward-Multiplier-2026-09-15.md).
Older pending/Pluto startup statements
below are dated history, superseded by this specific live result.

**V88 DEPLOYED20:11:15.6381609Z, fresh live pending.** User requested logger/F10
repair. Private x64 build0warnings/0errors,4722176bytes SHA
6628199831653EB028F81B75EC7AC4B76AC406050CE777E7C458BB2005C9E175.
Numeric121 alone failed live in V87; print-only local API probe stays queued.
Legacy public OpenWF userdata8 rejects current9, clearing UI-state capture;
public string/table/function reads/writes also stale. All39 public bridge tag
references now translate after existing certified U43 build/hash gate; canonical
enum/raw injector/legacy versions/scheduler owner-idle-native-frame guards stay.
Status exposes actual tag/capture/owner/frame/input state. F10 source has bounded
entry/request/returned messages. Separate calc256/combat1024 budgets at32768;
scalar overload retains calculation but omits nil-caster stat/buff snapshots.
F9 resets both budgets. Analyzer exact generic TRACE JSON recovers345owners.
Observer20825bytes/96prototypes SHA
ED98D24840C50B07FF2625AB6B3F3B5E108D39D64959DBB9967C05EDC63F541E.
Installed DLL/script hashes verified; source-log baseline164973905. Initial
installer refused an open PID1932 before any write. User repeated game-closed/
install instruction; exact old game process was stopped, then paired install
passed all43 artifacts/20prior entries. No rejected binary installed.
Production type/budget, actual scalar-flood observer, DE semantics/roundtrip/SIR,
analyzer/generic identity/345owner replay, F10 source, guard20 PASS. Package43
pinned artifacts/all20 prior scripts/config/Hotkeys/O preserved; paired V87
DLL/oldF10 rollback. Do not alter metadata test values/Efficiency0.45/gameplay.
Fresh startup/native F10/combat caster/F9/off pending; direct NameTag/full
contributors still unverified. Read RESEARCH/LOGGER_AND_F10_REPAIR_V88_2026-09-15
and central Documentation/04-Runtime-and-UI/Logger-and-F10-Bridge-Repair-2026-09-15.md.
Older V87/F10 claims below are dated history, not current acceptance.

**V87 DEPLOYED 2026-09-15T19:16:28.7832345Z.** User authorized installation.
Installed package verification PASS:92 artifacts and20 prior scripts/config.
Config SHA480DC2E6F02F251D879F1798B1B202174E7F1A250E23A344CDAC772CB5EB808B
unchanged. Log baseline131384902; STARTUP/native asset-type capture PASS in PID1932.
F9/off/direct NameTag/complete contributors remain PENDING or unavailable.
Private x64 build0 warnings/errors,4720128 bytes SHA
4BC3F2FF9E04ADD5B9626911DA356810C448B5B4AD06CC54DE6A2D51FC383AF5.
Three shared causes proven/repaired: compiler hash_set omitted literal uses
(6 invalid V86 LOADK hashes); InventoryControl was the wrong stock HUD-owner
receiver; natural addon activation dropped diagnostic native method requests.
Compiler classifies literal/name contexts independently; actual stock
GetHudStatus return yields BUFF_OWNER and separately originated queue records;
both activation paths merge one optional diagnostics/addon native contract.
Contextual SDK HudMovieInstigator is not an asserted native class. Intentional
Win32 read probes retain original behavior while suppressing only their own
internally handled fault dumps; outside faults retained in real API test.
Observer20817bytes/96prototypes SHA
D4EAFB5639AA7A8D8CEAD28AD3FB3F6D7F484C34A1ECEBE444DE60C990EC6066.
321 LOADK audit0 bad hashes, strict API45 calls0unknowns/violations, producer
32records/17complete lists/4owner fixtures, guard20, production native/contract,
real Windows probe, analyzer legacy/new, injection/config/replacement, manifest
50features/46required and5submodules PASS. Compiler build/literal fixtures and
release300/150 gates PASS; not renewed360/original-byte/full5386certification.
SDK258symbols/64deep/41evidence/29negatives/0guessed links PASS. V86 was preserved
before installation; V87 DLL installed with all20 prior scripts/config unchanged.
Mallet/IceWave formulas, replacement policy, Pluto, metadata, Efficiency0.45
and support-script architecture unchanged. Native names/timers/F9/off and V87
gameplay PENDING LIVE after this deployment. Read central
Shared-Buff-Pipeline-Repair-2026-09-15.md and V87 research/package evidence.
Older V86 InventoryControl receiver statements below are rejected history,
not current API truth; preserve observed failed session and original outputs.

**F10 SIMULACRUM SHORTCUT DEPLOYED 2026-09-15T19:20:56.126Z.** Existing OpenWF
hotkey handler calls owf_start_script for Scripts/RENOVICE Simulacrum F10.pluto.
It uses original sample Engine.OpenLevelArgs/SetLevel/SetGameRules/OpenLevel,
standard SimulacrumEnemySpawnerC.level and LotusDangerRoomGameRules. No new DLL,
DE injector branch, per-frame state enforcement or sample-file modification.
Logged-out invocation returns without a waiting loop. Exact ordinary Lua body
replay3 cases/binding syntax PASS; JSON5 validates commented Hotkeys.json and
preserves O. Live Soup/Pluto/Engine entry PENDING. Unmodified F10 while game is
foreground and original input filter allows hotkeys; normal loading still applies.
Script SHA20B322C90FE03FDB3068485C57DEFDA15E9FE0CD6CD4F6E87FB9837F5EDFC950,
Initial Hotkeys SHAB74EB92B49AEC1E44709DF3A04CD97B517B5A368A01E4F228F75BA651C39222B.
LIVE FAILURE: pinned Soup string F10 maps to F11. Numeric121 repair19:47:48Z,
current config SHA1173D21E6969AB0D934C158225AB482D2434D51216215561F5EF6906D74EF4B8,
existing reload_hotkeys command completed; actual corrected F10 entry PENDING.
Rollback/receipt/source/test in RESEARCH/SIMULACRUM_F10_2026-09-15; central guide
Documentation/04-Runtime-and-UI/Simulacrum-F10-2026-09-15.md in workspace.

**V87 FIRST LIVE REVIEW19:46:07Z, PID1932:**626/626 complete transactions,
zero duplicates, IceWave21/21 formula/restore PASS (cold0/10,Strength3.436–3.4816).
345 actual HUD owners and valid empty queues;1495 populated/accepted native
notification lists,4154 repeated record observations/seven asset types. Local
export identity/localization joins identify Ice Storm,Molt Augmented,Brightbonnet;
direct native NameTag0/full contributor semantics unverified. Caster stats FAIL
for this sample:1024 unknown-caster operation203 AvatarPickupBonus calculations
exhaust shared1024 budget before combat. Parser owner count0 vs345 raw TRACE
owner records: typed CASTER_STATS-only parser misses live generic transport.
Fault file90-byte arming header,0AV records. No F9/off test. Read workspace
work/diagnostics/V87-live-review-2026-09-15/README.md and review.json before
another logger change; split calculation/combat budgets upstream, preserve native
type identities and unsupported fields. No gameplay/DLL/config tuning changes.

**V86 FIRST LIVE REVIEW 2026-09-15T18:16:26.3162795Z: startup/damage/aggregate
stats PASS; named buff capture FAIL; F9/off NOT_OBSERVED.** PID15012,
VM00000244046F8C80, fixed source bytes92581431–98961248 SHA
F53ABD987B0599A92073AC47C8F3D5A257DE2A2FD58F48E318C689167F002734.
1734 complete transactions/zero incomplete/duplicates,525 caster snapshots,
143/143 Ice Wave formula/restore matches at six-significant-digit transport
precision. Strength2.53–3.512319803, Duration1.275–1.675, Range2.2, Efficiency
raw0.45 unchanged. Avatar getter525 reads succeed/ReturnType=table, yet all
rejected unsupported-return-type; HUD queue525 chains fail attempt to call nil
method. Two native bindings install, zero BUFF_NATIVE probes. No direct buff
names/timers/contributors captured; blackboard Data empty, stock calculations0.
59 first-chance kernel32!IsBadReadPtr+0x26 faults while process remains alive
and responding; repeated dump writes are diagnostic noise, not59 proven crashes.
All42 package artifacts and20 prior scripts/config verify. Read-only review,
no runtime/config/gameplay changes. Shared type-selection comparison/HUD stage/
adapter reachability are next investigation; no fabricated per-Arcane evidence.
Central live guide and work/diagnostics/V86-live-review-2026-09-15 preserve
positive/negative hypotheses, captured log/fault/dump, analyzer and review tool.

**V86 DEPLOYED 2026-09-15T18:06:15.7434135Z:** DLL
2F46F4B2F4AB92D407E1B10E00FF7429953F263F85A5AFA66F685A7918EF66E1,
4707328 bytes, zero warnings/errors. Source-log baseline92581431. Corrects
GetBuffNotifications nil-empty classification using exact current executable
native getter/helper proof; preserves actual GetterSucceeded/ReturnType/Error.
Reads separate InventoryControl.GetHudStatus notifications at existing caster
boundaries, preserves queue origin/add/remove fields, never clears a queue or
maintains buffs. Native getter probes distinguish ingress/selection/return and
pending callback staging, stock/self lanes independently capped128/configbudget,
one suppression each, reset at existing F9 commit. No polling/resource loading/
gameplay setter/per-ability branch. Observer20334 bytes/97 prototypes hash
A1E263EA715430D8210EE3779A52F79BED729B9FAB1EA0FDD58C577E4F2E3DB6;
API46 calls/0 unknowns/violations, production guard20, analyzer23, actual producer
38records/23complete lists, native production probe/off/reset, injection and SDK
258symbols/64deep/40evidence/26negatives/zero guessed native links PASS. Package42
artifacts and all20 prior scripts/config verified; config480DC2E6F02F251D879F1798B1B202174E7F1A250E23A344CDAC772CB5EB808B unchanged,
not rewritten. V85 and V83 last-live-accepted DLL/config rollback pairs preserved.
User confirms raw Efficiency0.45 for mod loadout; final aggregate stats include
mods but complete mod/rank/shard attribution is not implemented or invented.
STARTUP/ACTUAL RETURN TYPES/NATIVE HUD NAMES+FIELDS/F9/OFF PENDING LIVE. Read central
Universal-Buff-Capture-Repair-2026-09-15.md and V86 research/package receipt;
earlier V85 failure and deployment paragraphs below are retained history.

**V85 first live review, 2026-09-15, PID 14332:** installed hash remains
928E837BE9B9B19D39A120FD53F970F17F06168DAD865E1D7C0F0CF21F06CC8E.
Startup/two native GetBuffNotifications bindings PASS; native buff capture
**NOT ACCEPTED**: all 134 combat lists unavailable, zero getter-return lists,
zero named buffs, all blackboard Data empty. Current error combines failed
getter and non-table return; actual type/error and adapter ingress decisions
are not captured, so do not invent the cause. Effective stats/damage work:
134 caster snapshots, 750 complete observations, 26/26 observed Ice Wave calls
formula/restoration consistent within printed precision. Raw efficiency factor
0.45 is measured; logged efficiencyPercent=45 is not accepted as Arsenal
Efficiency without display-conversion evidence. No runtime errors/fault entries
observed in the pinned run; F9/off still pending. Live capture authority:
workspace work/diagnostics/V85-live-review-2026-09-15/README.md; source bytes
90586583–92581431, SHA256
4ECB211F80B729B98703EF038B502CC0D5617A087830BF3D8FD320E9E1A37996.
Central Universal-Buff-Logging-2026-09-15.md contains positive/negative results.
No runtime, config or gameplay changes were made during this review. Earlier
deployment and offline PASS paragraphs below retain their original boundaries.

Last updated: 2026-09-15
V85 DEPLOYED: DLL 928E837BE9B9B19D39A120FD53F970F17F06168DAD865E1D7C0F0CF21F06CC8E (4702720 bytes), zero warnings/errors. Shared native GetBuffNotifications returns and Avatar lists at existing caster combat/calculation boundaries capture native name tags/raw notification fields/verified HUD units for any resource, no ability-specific runtime branches. DiagnosticsBuffs defaults false, works in battle/trace independently of damage capture; installed config only appends DiagnosticsBuffs=true, SHA256 480DC2E6F02F251D879F1798B1B202174E7F1A250E23A344CDAC772CB5EB808B. No queue clear/resource loading/gameplay mutation/polling/buff ledger. Pending receiver is rooted in the existing managed Lua table before stock can overwrite arguments, released after observation or existing F9 reset. Two records/chunk, cap32 notifications, explicit unknowns/truncation/missing-chunk state. Observer 19550 bytes /94 prototypes SHA256 F6C65D5E7BC3736FE6F346525CE7C901F507574687546925DBC42D971B5DA55A; DE parser/re-emission/IR, strict API44 calls zero unknowns/violations, unrelated-resource fixtures, 20 production guard GC/relocation cases, config/injection and 20 analyzer cases PASS. SDK257 symbols/63 deep/39 evidence/25 negatives/zero guessed native links. Package40 artifacts and every prior gameplay script preserved; V84 rollback plus V83 last-live-accepted DLL included. Install 2026-09-15T09:24:25.5384718Z baseline90586583; STARTUP/NATIVE BUFF NAMES AND FIELDS/F9/OFF PENDING LIVE. StackCount and complete hidden ContributorBreakdown/rank-aware Base/permanent Loadout remain unavailable/unverified. Older V83 total-stat pattern inferences are not named native records. See central Universal-Buff-Logging-2026-09-15.md, RESEARCH/UNIVERSAL_BUFF_CAPTURE_V85_2026-09-15 and deployment manifest/receipt. F9 cannot replace DLL. Mallet/Ice Wave/replacements/Pluto/server/metadata user tests preserved.
V84 DEPLOYED: DLL 2571C77EC3B3A0BD31AABA9F9C47FD5CDBF2DBAD0597ECA2DB59007AA7C05DDC, 4696576 bytes, zero warnings/errors. Stock AlchemistDistill prototype 12 NAMECALL 45 verifies InventoryControl.GetUpgradeModifiedValue(1,4,suitType,suit); both enum indices identify operation 4 as Efficiency. The logger records the raw factor and unclamped unit percentage. Generic bounded GetScriptBlackboard observations copy script-owned numeric/boolean fields (32-entry tree budget, depth two, cycles/unsupported values omitted) without per-ability host branches or gameplay mutation. 71 observer prototypes DE parser/re-emission/Semantic IR PASS; strict API 38 calls, zero violations/unknowns; 20 actual production guard cases and 15 analyzer fixtures PASS. Semantic SDK now 251 symbols, 57 deep contracts, 38 evidence, 23 negatives, zero guessed native links. Package 27 artifacts and all 20 prior nonvolatile script/config entries PASS; live-accepted V83 rollback preserved. Config hash 9CAD4B843E5D915B777729A84FB83A2B44E1EAB70FE70741F57EE925763939AD unchanged. Installed at log baseline byte 90586583; V84 STARTUP/EFFICIENCY/BLACKBOARD PENDING. V83 stated-loadout review: 40 Ice-Storm-compatible paired +0.02 steps, 52 Molt-compatible +0.0024 steps, Brightbonnet-compatible +52.136 to +60.136 Strength-point bonus. Named native contributor IDs remain unqueried, complete Base/Loadout/ContributorBreakdown unverified. See centralized Caster-Efficiency-and-Buffs-2026-09-15.md and RESEARCH/CASTER_EFFICIENCY_AND_BUFFS_V84_2026-09-15. Game mechanics, Ice Wave/Mallet/replacement scripts, Pluto, metadata tests and server remain preserved. DLL update requires a fresh game process; F9 is not DLL replacement.
V83 LIVE REVIEW: PID 24708 startup/embedded module PASS; snapshot bytes 76311475..81239834 SHA256 2411BA6316212887DFF5A9CD3A7CE864406E28A1D8D955565BAF29773B7CF83E. 438/438 known caster snapshots, readable HP/shield/OG/armor/energy/Strength/Range/Duration/velocity; effective Strength 2.53..3.6561594, Duration 1.275..1.675, 592 exact native joins. Efficiency 0/438 available; zero stock calculation records, so that interception is not live certified. 179/179 V81 Ice Wave target calls pass formula/count/install/restore with Cold 0/3/6/9/10 and 16 mixed-stack batches. 1710 complete non-additive observations, zero incomplete/duplicates. Four native fault entries resolve to kernel32 IsBadReadPtr readability probes; game still running, not an unhandled-crash finding. No gameplay/code changes. See centralized Caster-Stats-Live-Review-2026-09-15.md and work/diagnostics/V83-live-review-2026-09-15. F9/filter/off/base/loadout/efficiency/named contributor gates remain separate.
V83 DEPLOYMENT HISTORY: guarded loader repair BUILT/PACKAGED/DEPLOYED PASS; STARTUP/CASTER READINGS PENDING after log byte 76311475. DLL F99A5D11F818A9A40A71B9C72D101ECFE382C569DABCED323847CBE8E82E5028, 4695552 bytes, zero warnings/errors. V82 startup REJECTED: failed managed module return, 593 retries, invalid closure TValue at diagnostic registry insertion in crash dump. Shared guard now uses relocation-safe offsets for loader/lifecycle/refresh recovery and temporarily roots the displaced original in the existing registry. Preserved V82 production code fails independent forced GC and relocation; V83 passes 20 success/rejection/fault cases. Failed observer load is latched once per VM until explicit F9 commit. Config 9CAD4B843E5D915B777729A84FB83A2B44E1EAB70FE70741F57EE925763939AD remains unchanged with caster diagnostics enabled; V81 Ice Wave and every prior gameplay script preserved. All V82 stat/query/base-loadout attribution limits remain unchanged. Read RESEARCH/CASTER_STATS_STARTUP_REPAIR_V83_2026-09-15/README.md and RENOVICE_DEPLOYMENTS/CASTER_STATS_GUARDED_LOADER_REPAIR_V83_2026-09-15/README.md. V82 preserved as rejected rollback, V80 last live-accepted recovery. Restart required; F9 cannot replace a DLL. Older V82/V80/V79 paragraphs below are historical.
V82 HISTORICAL (STARTUP REJECTED): universal caster-stat diagnostics are BUILT/PACKAGED/DEPLOYED PASS; STARTUP AND LIVE READINGS PENDING. Installed DLL SHA256 8E3797124EBBF951499892A61CDC86E03604235C6E9C47344858A4454E24CF91 (4692992 bytes, zero warnings/errors); config SHA256 9CAD4B843E5D915B777729A84FB83A2B44E1EAB70FE70741F57EE925763939AD adds only DiagnosticsCasterStats=true. All existing gameplay scripts, including V81 Ice Wave, are preserved by hash. Source-assignment, DamageDD, RadialDamage and stock upgrade-calculation events use the existing managed observer; no support addon or gameplay mutation. Effective stat readings are individually availability-tagged; base, permanent-only loadout and contributor separation remain UNVERIFIED/UNAVAILABLE, not inferred. Snapshot IDs are process-monotonic and exact native joins require process+VM+ID; weak packet associations reset at F9. No dispatch/source assignment is mislabeled cast-start. Restricted-environment/source/change/shared-packet/scalar+alias/off/reset tests, 66/66 authored DE parse/re-emission and Semantic IR, config/injection/native and 15 analyzer fixtures pass. V80 exact DLL/config rollback is in RENOVICE_DEPLOYMENTS/WARFRAME_STAT_DIAGNOSTICS_V82_2026-09-15. Log baseline 76242984. Restart and verify live known caster/suit/Strength before continuing V81 Ice Wave math. Read the centralized Caster-Stats-2026-09-15.md guide; V80/V79 results below are historical evidence.
V80 new work: ENGINE DAMAGE CAPTURE OFFLINE PASS / PACKAGE AND EXACT-CLIENT PASS / DEPLOYMENT AND STARTUP PASS / BRIGHTBONNET CAPTURE USER-CONFIRMED LIVE PASS / UNRELATED SOURCE ACCEPTANCE PENDING. The V79 logger missed the user's approximately 133-point Brightbonnet hit because it observed Luau DamageDD, while stock NokkoPowerShroom dispatches gRegion:RadialDamage. DiagnosticsDamageCapture=engine adds observation at three native DamageControl handlers, validated by the exact CCA46D60 executable hash and unique signatures. The production observer harness records two targets sharing one packet with 133 HP loss each; no packet mutation, one stock call per ingress, source filters, nested-boundary suppression, and off behavior pass. Analyzer native begin/end pairing, incomplete records, Lua/native counter separation, and F9 generation separation pass. The zero-warning x64 candidate hash is 100789034378ED902D1A6D6553DF6610680C90CF7BF9F0C1AF04EC1F490364DB. Native and Lua observations are separate, non-additive layers. Unknown native life/status/armor readings remain unavailable. Native trampolines stay owned for the process lifetime across F9; DLL updates require restart. Read RESEARCH/NATIVE_DAMAGE_BOUNDARY_2026-09-15/README.md and RENOVICE_DEPLOYMENTS/ENGINE_DAMAGE_CAPTURE_V80_2026-09-15/README.md before this lane's live test. V80 is installed with verified DLL/config hashes. Startup PID 19148 confirms loaded V80 hash and all three native handlers. The initial snapshot records 134/134 complete native transactions, 57 positive HP losses and zero logged failures; Lua caller identities remain unknown in the raw snapshot. The user confirms the tested damage was Brightbonnet: its native damage/pool-loss capture is live accepted with user test attribution; automatic source naming and unrelated-source acceptance remain pending. Read Documentation/03-Abilities-and-Combat/Native-Logger-Startup-2026-09-15.md in the workspace for evidence. V79 remains the preserved gameplay rollback; its live results below are historical.
V78 live result: STARTUP PASS / AUTOMATIC CAPTURE REJECTED. The test at bytes 16348164..16556337 contains 91 automatic-before errors from `-math.huge` with a nil restricted-library export, zero automatic transactions, and 45 complete explicit Ice Wave transactions with zero multiplier/restoration failures. The exact failure is reproduced offline. V79 replaces the optional math export with a finite-number arithmetic check; restricted-environment tests, 34/34 DE roundtrip and Semantic IR, and the zero-warning x64 build pass. V79 DLL SHA-256 `C55253FF351B914958E6D8F4207F318A5134FFD1B6A7985FF85FFD3C067327F9`. V79 package verification passes; deployment and installed hashes pass with a pre-restart log baseline of 17477213 bytes and live automatic capture passes: 64 automatic transactions across two independent sources, together with 36 explicit Ice Wave transactions, 100/100 complete, zero runtime failures. See RESEARCH/AUTOMATIC_DAMAGE_LIVE_ACCEPTANCE_V79_2026-09-15.md. See `RESEARCH/AUTOMATIC_DAMAGE_RESTRICTED_MATH_FIX_V79_2026-09-15.md`.
Current deployed state: V80 runtime plus V81 Strength-scaled Ice Wave (installed file, F9 activation/gameplay pending) and all existing replacement/target-addon files. DiagnosticsMode=battle, DiagnosticsDamageCapture=engine; no source/target/damage-type filters. Installed DLL SHA-256 100789034378ED902D1A6D6553DF6610680C90CF7BF9F0C1AF04EC1F490364DB; config SHA-256 88B6B6032159503254929036AA5530E5CE3EAE883198F9373F26C1E354725965. Package and installed hashes PASS. Startup/native pool-change capture PASS; Brightbonnet test source user-confirmed. Unrelated-source and F9/filter/off acceptance remain pending. V79 automatic scripted capture remains historically live accepted; it is not a V80 gameplay result.
V77 automatic capture: one configuration switch installs the existing exact `DamageDD` native adapter even when no target addon requests it, catalogs loaded Luau module prototypes, wraps each selected per-target call in embedded Battle Log V5, and adds exact source-body/path/name, target-type, and numeric damage-type filters. Exact target-addon providers win to prevent duplicate records. The package preserves the exact live-accepted V76 DLL/config rollback. That previous run produced 990 battle records and 110 complete target-local transactions with zero incomplete transactions; modifiers were exactly 0, 6, and 10 with zero arithmetic failures.
Next live gates: Automatic multi-source startup/capture and saved-log isolation are live accepted. Remaining gates: isolate one discovered body/path via config plus F9, then disable diagnostics after testing. Native-only source capture is a separate feature. The rejected V77 capture starts after byte `15779659` of `Logs/renovice_source.log`. Fully native weapon/projectile damage that never enters Luau `DamageDD` remains an explicit unproven coverage lane.
Previous live result: V62 reproduced the Baro-to-Navigation hang. The full dump proves `BuildMissionForLocation` still jumped to an owned compact code cave after a native-hook contract rebuild, and that reused cave contained `E9 FB FF FF FF`, a self-jump. The main UI thread spun there indefinitely. Baro is the reliable trigger path; the server and 744-offer catalog are not the blocking execution owner.
Current acceptance gate: V72 runtime is **OFFLINE PASS / PACKAGE PASS / DEPLOYMENT PASS / CHANGED-GENERATION F9 LIVE PASS ONCE**. Ice Wave V73 is **OFFLINE PASS / DEPLOYMENT PASS / USER-REPORTED GAMEPLAY PASS** and remains the gameplay rollback. V74 and V75 trace transports were rejected with their exact negative evidence preserved. V76 is **OFFLINE BUILD PASS / PACKAGE PASS / DEPLOYMENT PASS / STARTUP PASS / 110 OF 110 COMPLETE BATTLE TRANSACTIONS LIVE PASS**. V77 automatic scripted capture is **LIVE REJECTED FOR MISSING MANAGED LIFECYCLE**. V78 is **STARTUP PASS / LIVE AUTOMATIC CAPTURE REJECTED FOR RESTRICTED MATH**. V79 is **RESTRICTED-ENVIRONMENT TEST PASS / ZERO-WARNING BUILD PASS / STARTUP PASS / 64 AUTOMATIC PLUS 36 EXPLICIT TRANSACTIONS LIVE PASS / SAVED-LOG FILTER PASS / F9 FILTER LIVE UNTESTED**. No automatic-capture result is yet claimed for native-only damage.
Previous V74 addon deployment: corrected ESO addon SHA-256 `19D8B54AF74F5D8ADF7250359FBDF2740503B72D9FBD269EB70D825C1BE1FF59`; current Frost V74 addon SHA-256 `BE8414C6C2309528E644FA5BC9DD701AD7BD966F90C5BC6190E1FACAAA49E64B`; `ScriptStates.json` SHA-256 `74FED6FF3933A0D61BD2B5CAED450E2DF6E2FEBB1F245A8F736C7885568FBA0B`. V74 preserves V73's numeric stock value, installs `stockRaw * max(1, currentTargetColdStacks)` for every target, restores a newly constructed stock `UpgradedValue` immediately after the native call, and embeds Battle Log V5. The exact V73 addon rollback hash is `8000A06CD5E842721316D8669EA9F49C244BC32982A2A70762F32321FC40E7A2`.
Rejected addon baselines: V39 execution scope, V40 native handoff, V41 card-resource gameplay match and borrowed `type` guards
Rejected regression: V37 upstream `UpdateFlashMarkers` integration
Earlier recovery baseline: V35

V81 Ice Wave addon: source-compiled and installed SHA256 47BE0645CE804BA565DE4B0021CFD46BE452B22908B5C0092C900C62CA6E3E02. Formula stockRaw*(1+coldStacks*abilityStrength), one bonus per stack at unit Strength; 300% with 10 stacks yields x31 of stock damage. Stock Strength remains in stockRaw. Source is captured at prototype 7 NAMECALL 52, queried once per packet through stock InventoryControl ModifyValue operation 10 and active suit context. Native hooks retain SetBaseAmount 41 and DamageDD 64, numeric restore and target-local stacks. Harness/compile/roundtrip/Plan/IR/API/analyzer PASS; addon-only deployment hashes PASS; F9 and live math PENDING. Runtime V80, config, server, metadata and all other scripts unchanged. Read Documentation/03-Abilities-and-Combat/Ice-Wave-Strength-Scaling-2026-09-15.md and package RENOVICE_DEPLOYMENTS/ICE_WAVE_STRENGTH_PER_STACK_V81_2026-09-15.

This is the short operational handoff for future agents. Read it before
changing script loading, F9, the SCRIPTS menu, target addons, replacement
refresh, or runtime scheduling. Detailed proof remains in the linked research
records; this file states what must be preserved.

V44 failure evidence: `RESEARCH/V44_CALLBACK_ABI_FAILURE_2026-09-07.md` and
`RENOVICE_DEPLOYMENTS/PROTO_FAMILY_TRACE_V44_2026-09-07/captures/20260907-024024-726Z`.
Exact target matching and source assignment passed. The direct native setter
then rejected a C closure and aborted BardMusic::BoxLoop(634). No afterDamage
body ran in that attempt. This is a confirmed injector regression.

Historical V45 introduced a generic 702-byte DE Lua callback constructor embedded in the DLL.
It loads once per DE VM through the existing loader, under its own registry
root. Addon files and stock modules remain byte-identical. SetDamageCallback
receives only a validated Lua closure; optional installation uses protected
calls. Existing stock callbacks execute directly in Lua before addon dispatch,
preserving varargs, nil return values and yielding. Weak receiver associations
replace the rejected assumption that stock upvalue zero is an ability object.
No source association means the stock callback stays installed and the trace
reports the missing association. Different userdata wrappers for one native
receiver are not assumed identical; that case remains a live coverage limit.
The currently deployed runtime is V79, whose restricted-math correction and installed hashes pass; startup and automatic multi-source capture are live accepted; runtime F9 filter isolation remains untested. It preserves the live-accepted V76 behavior and V72's idle-frame F9 mutation boundary, V63's captured-target
compact-hook teardown, V62's Lua-entry threat argument hook, V61's accepted
coroutine guard and Survival addon, and the V57 Mallet Overguard/card behavior.
V68 added target-root reactivation; V69 added the host-owned trace closure;
V64 added exact-callsite multi-binding; V65 exposed the exact unresolved frame;
V66 fixes its `CallInfo`, identity-publication, and raw-word/decoded-instruction
boundaries. V67 prevents byte-identical managed roots from being staged a
second time on F9. V72 additionally defers every Lua mutation until an idle
base frame or validated native/C host frame. See
`RENOVICE_DEPLOYMENTS/F9_LUA_MUTATION_BOUNDARY_V72_2026-09-14`.
V58 remains the earlier live-accepted runtime behavior baseline. Its startup, F9
`trace -> errors -> off` mode cycle, SCRIPTS menu, and ordinary Mallet gameplay
are live accepted as of 2026-09-09.

## Authoritative locations

- Edited source:
  `C:/Users/Bartek/OneDrive/Dokumenter/Warframe RE PROJECT RENOVICE/repos/runtime/bootstrapper-runtime`
- Correct live game:
  `C:/Users/Bartek/OneDrive/Dokumenter/Warframe`
- Live custom scripts:
  `C:/Users/Bartek/OneDrive/Dokumenter/Warframe/OpenWF/CustomScripts`
- Current V57 addon package with its exact V56-addon rollback:
  `RENOVICE_DEPLOYMENTS/MALLET_PROTECTED_NAMECALL_STATE_FILTER_V57_2026-09-08`
- V58 staged DLL-only package with the exact accepted V56 DLL rollback:
  `RENOVICE_DEPLOYMENTS/REUSABLE_DIAGNOSTICS_AND_API_CATALOG_V58_2026-09-08`
- V59 output-layout package with the exact accepted V58 DLL rollback:
  `RENOVICE_DEPLOYMENTS/LOG_DIRECTORY_LAYOUT_V59_2026-09-09`
- Rejected V60 Lua-call/Survival package with exact V59 DLL and rejected
  replacement rollback:
  `RENOVICE_DEPLOYMENTS/SURVIVAL_TIMER_TARGET_ADDON_V60_2026-09-09`
- Current V61 coroutine-resume repair with exact V60 DLL/addon rollback:
  `RENOVICE_DEPLOYMENTS/SURVIVAL_COROUTINE_RESUME_FIX_V61_2026-09-09`
- Historical V62 Lua-entry argument-copyback and Mallet package with exact V61 DLL,
  failed-wrapper, and accepted V57-addon rollbacks:
  `RENOVICE_DEPLOYMENTS/MALLET_LUA_ENTRY_THREAT_ARGUMENT_V62_2026-09-11`
- Current V63 generic compact-hook repair with exact V62 DLL and complete
  active `CustomScripts` rollback:
  `RENOVICE_DEPLOYMENTS/NATIVE_COMPACT_HOOK_CAPTURED_RESTORE_V63_2026-09-12`
- Rejected V64 exact native-call multi-binding with exact V63 DLL and complete
  nonvolatile active `CustomScripts` rollback:
  `RENOVICE_DEPLOYMENTS/EXACT_NATIVE_CALL_MULTI_BINDING_V64_2026-09-13`
- Rejected V65 native-ingress diagnostic package with exact V64 DLL and complete
  nonvolatile active `CustomScripts` rollback:
  `RENOVICE_DEPLOYMENTS/NATIVE_INGRESS_CALLSITE_DIAGNOSTICS_V65_2026-09-13`
- Current V66 CallInfo/native-identity repair package with exact V65 DLL and
  complete nonvolatile active `CustomScripts` rollback:
  `RENOVICE_DEPLOYMENTS/EXACT_CALLINFO_AND_NATIVE_IDENTITY_V66_2026-09-13`
- Current V67 repeated-F9 repair with exact V66 DLL and complete nonvolatile
  active `CustomScripts` rollback:
  `RENOVICE_DEPLOYMENTS/F9_UNCHANGED_MANAGED_GENERATION_REUSE_V67_2026-09-13`
- Current V68 target-root F9 repair and Ice Wave shared-packet package with
  exact V67 DLL and V2 Ice Wave addon rollbacks:
  `RENOVICE_DEPLOYMENTS/F9_ROOT_REACTIVATION_AND_ICE_WAVE_PACKET_BASELINE_V68_2026-09-13`
- Current V72 F9 Lua-mutation boundary package with the exact installed V69 DLL
  rollback, crash dump, full source, and pre/post Inject inventories:
  `RENOVICE_DEPLOYMENTS/F9_LUA_MUTATION_BOUNDARY_V72_2026-09-14`
- Current V73 Ice Wave numeric-baseline addon with the exact rejected V72 addon
  rollback, live alias trace, live-alias regression harness, and pre/post
  CustomScripts inventories:
  `RENOVICE_DEPLOYMENTS/ICE_WAVE_NUMERIC_BASELINE_RESTORE_V73_2026-09-14`
- Current V74 battle-log runtime and Ice Wave addon with exact V72 runtime,
  V73 addon, and V73 configuration rollback:
  `RENOVICE_DEPLOYMENTS/COMBAT_BATTLE_LOG_V74_2026-09-14`
- Current V75 runtime-only shared-VM trace-ownership fix with the exact previous
  V74 runtime rollback and hash-pinned unchanged Ice Wave addon/configuration:
  `RENOVICE_DEPLOYMENTS/BATTLE_TRACE_SHARED_VM_OWNERSHIP_V75_2026-09-14`
- Previous installed V75 DLL SHA-256:
  `712887EF80BB739B3ABADEF06E758A7B942A3227A8513771762B9ED6A8D75C8F`
- Current V76 runtime-only VM-registry trace-root fix with exact V75 rollback
  and hash-pinned unchanged Ice Wave addon/configuration:
  `RENOVICE_DEPLOYMENTS/BATTLE_TRACE_REGISTRY_ROOT_V76_2026-09-14`
- Installed V76 DLL SHA-256:
  `A703E0E96523679FC5A3B597AA538E11C50BF2817A761A1CC629688FCF10220D`
- Exact V74 rollback DLL SHA-256:
  `87D6D6B5DEC81221C8107D152BDC6F9D7FD7EB81EA8781794A7E63A47D34E138`
- Exact V72 rollback DLL SHA-256:
  `AE1E26EABB988EA166C5519AA382236C4C48444EEEAB30C033EED45BD19E7CB6`
- Exact V69 rollback DLL SHA-256:
  `53370FED9AA6843BB01CF80ECBEB57266CF71AFF39D6344383C1F39B99DD7451`
- Historical V68 DLL SHA-256:
  `EDA79C8B2DFA87BDD326C18DBAB720C6E21ACDFF5A90B5A87F7CB4A3CEF238FA`
- Exact V67 rollback DLL SHA-256:
  `32DB4771F2693197BD46B3CF160071904F09CF7AEEE49D4EE4CA25ED35FCEAD1`
- Exact V66 rollback DLL SHA-256:
  `54A7D36644401C9CDF871B6BEA064400994962EB2614F79324A8171496F0943B`
- Exact V65 rollback DLL SHA-256:
  `0989E64EB330BEBC6BF37A43D3331DC1B0BD44E65279A4C3F232AD36F733F06A`
- Exact V64 rollback DLL SHA-256:
  `6AD53FC39C58956AD1D20404640C32C327046884F0C35CBA195C7C83286B1A08`
- Exact V63 rollback DLL SHA-256:
  `C1F675D328329074EF5AB7FA687EE2F21C67904591B03A986A32A7DA4D49BE0F`
- Exact V62 rollback DLL SHA-256:
  `C6F59B901CE21840FBCF2753472593DC304600125133471381C09C7B607FF867`
- Current standalone Survival target-addon SHA-256:
  `25CD05FC50C5350630F0360829B7DC8E4A4DF84EE359187FBCF248F8302763DD`
- Current standalone Mallet target-addon SHA-256:
  `75BB4231C6A2748C7C79A69DBFE781644A1EE63B4D26B5FEDB34DE3064757EB7`
- Exact working V61/V57 rollback DLL/addon SHA-256:
  `5CB029981628A41B8C2D92BA2E2A4B986F8546188897BC53A983AE5C09204E45` /
  `36D2E3EC21E5879FBC0129A82139CF35E53D5FC95C8A82443D106EFF6FBDF049`
- Exact V54 rollback DLL/addon SHA-256:
  `8CDBB6ADFAA8299350495AFDB1491B9A3F167CF4B3F17391C1753B8058DA3C08` /
  `75657872EABEFA5F50818F81E0BB1ACCD1B2F20436D365FF15B944F80EA20514`
- Current script policy SHA-256 with eight explicit entries, including the
  corrected ESO and Frost Ice Wave target addons enabled:
  `74FED6FF3933A0D61BD2B5CAED450E2DF6E2FEBB1F245A8F736C7885568FBA0B`
- Internal SCRIPTS bridge SHA-256:
  `153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82`

The game folder and old backups are not source workspaces. Inspect them
read-only unless the user explicitly authorizes a deployment. Deploy only while
the exact game-folder process is stopped, and preserve the previous DLL plus
internal bridge as one rollback pair.

## Runtime architecture

```text
replacement files + Inject files + ScriptStates.json
                         |
                  prepare full snapshot
                         |
            validate bytecode and addon contracts
                         |
                 atomic generation commit
                         |
  exact captured DE VM + owner-thread pending transaction boundary
            |                                |
   replacement refresh              addon cleanup/activate
   or stock restore                  target-addon rebind
```

The OpenWF Pluto VM and DE gameplay Luau VM are separate. V38 preserves the
Pluto background coroutine, ordinary running Pluto scripts, hotkeys, and UI-VM
API access, but clocks them after the pinned native Application frame method
returns. It captures the UI state through the existing `gFlashMgr` publication
and requires the exact owner thread plus idle `ci == base_ci`. The stock
`UpdateFlashMarkers` Lua method entry must remain untouched. RENOVICE bytecode
registration, lifecycle calls, and generation commits execute through the
captured DE VM only while startup or an explicit reload transaction is pending.
A return from the DE interpreter does not prove that the native caller which
entered it has returned.

The deployed DLL is the source-built single `wtsapi32.dll`; it does not import
the legacy `wtsapi32_owf.dll`. The older two-DLL installation remains recovery
evidence, not the active architecture.

## Supported script types

| Type | Location and name | Current contract |
|---|---|---|
| Full replacement | `CustomScripts/<16-hex-key> ... .lua_B` | Replaces the stock module body identified by the original FNV-1a-64 content key. Removal/disable requests stock restoration for captured refreshable contexts. |
| Managed addon | `CustomScripts/Inject/*.addon.lua_B` | Returns idempotent `activate()` and `cleanup()` lifecycle functions. Its behavior and undo path remain owned by the addon. |
| Target addon | `CustomScripts/Inject/<16-hex-key>.*.target.addon.lua_B` | Raw DE bytecode loaded in the target module context. It may own a proven reachable exported-function wrapper through lifecycle `activate`/`cleanup`; optional host hooks are `matchesAbility`, `afterAbilityCard`, immediate `afterDamage(sourceAbility, reportedDamage)`, `nativeCalls[method].before/after` with exact prototype/instruction identity, and V107 `luaCalls[prototype].before` with one-based arguments/upvalues and finite same-tag scalar copyback. `luaCalls.after` is rejected until complete RETURN/yield/error/cleanup retirement exists. No support script or target-specific C++ is required. |
| Ordinary Inject script | `CustomScripts/Inject/*.lua_B` | One-shot execution in the staged generation. It has no automatic undo unless authored as a managed addon. |
| Internal bridge | `Inject/_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B` | Mandatory hidden infrastructure for the pause-menu UI. It must never appear as a player-toggleable script. |

The loader support is universal: a correctly named replacement or addon can be
added without adding Mallet-, Limbo-, or other ability-specific C++ code. That
does **not** mean merely executing a chunk automatically intercepts any
arbitrary existing function. The addon must use an actual reachable module
edit, exported dispatcher, or verified native host event. Do not add one-off
ability logic to the bootstrapper to compensate for a missing call edge.

Historical V42 removed Mallet's full BardMusic hook-shim replacement. Its one target addon
owns card rows and damage-to-Overguard. The card path is accepted
live. The gameplay association is rejected: at the stock native
`SetSourceObject` call, both ordinary and hashed reads of `mOwner` from the
loader-owned borrowed addon environment return nil. The active instance owner
does not exist there. This is the same structural failure already captured in
the 2026-08-25 module-environment owner-bus experiment.

V41 proved the target addon loaded and its card matcher accepted six queries,
but it produced neither addon row nor Overguard. Its ordinary `type(rows)` and
`type(query)` guards are rejected because earlier live evidence proved borrowed
DE tables can be misclassified. Its gameplay route also reused the card matcher
against a distinct runtime source object and never matched. V42 removes both
causes. V42 restores the card rows but not gameplay. The V43 successor removes
the rejected module-owner and card-resource gameplay associations. It resolves
ownership only from an exact target-module Lua caller present on the bounded
active `SetSourceObject` call stack, rejects ambiguous target keys, and retains
`matchesDamageSource` solely as an explicit optional fallback.

V43 was tested and rejected: the active Lua frame uses a descendant prototype
and a per-instance environment. V44 collects and roots the complete prototype
graph at load, then matches exact same-VM membership on the active call stack.
Startup has confirmed 22 graph nodes and native adapter installation. Gameplay
is still pending. The host trace records PID/build, attempt, target, arguments,
installation, dispatch, returns, and decoded errors. Capture with
`RENOVICE_DEPLOYMENTS/PROTO_FAMILY_TRACE_V44_2026-09-07/capture_test_logs.ps1`.
The trace summary distinguishes attachment failure from addon execution; a
callback return still does not prove Overguard or universal live coverage.

Universal standalone addons, direct DE VM work, no shims, no ability-specific
native branches, and proper diagnostic evidence are explicit user requirements
in `AGENTS.md`. Read the dated requirements research before continuing.

The former E059 Mallet addon was not standalone: it exported
`afterMalletDamage`, which only the removed 33,750-byte BardMusic replacement
called through shared state. Its successful card rows proved target-addon
loading but did not prove a gameplay event path. The V28 runtime-object matcher
also remains rejected live because `GetUniquePowerIdentifier():c_str()` threw.

Target body keys are inventoried before enabled-policy filtering. Therefore a
target addon that starts disabled can retain the target module identity and be
enabled later without restarting or adding a bootstrapper-specific enabler.
Disabled addon bytecode is not executed.

## F9 and SCRIPTS menu semantics

F9 reads the complete current script inputs, stages one generation, validates
every member, and commits atomically only if the entire transaction succeeds.
Deletion is part of the snapshot. There is no continuous folder watcher and no
idle per-frame filesystem scan.

The pause-menu SCRIPTS panel is another front end to the same reload
transaction:

1. checkbox clicks stage values only;
2. closing the child panel applies one nonempty valid batch;
3. both recognized Generic Settings close routes apply the batch because live
   evidence proved a real edit can be reported through either nil/Confirm or
   true/ExitScreen;
4. an empty close does nothing;
5. a malformed callback shape fails closed and clears staging;
6. reload runs after the panel closes at the safe DE boundary, never inside an
   individual checkbox click.

`ScriptStates.json` stores stable IDs based on script type and normalized
filename. Renaming a file can orphan its saved policy and must not be treated
as presentation-only cleanup.

## Scheduler boundary: preserve upstream Pluto and isolate RENOVICE work

The earlier Arsenal/Simulacrum exact-search crash involved the then-current
RENOVICE/OpenWF `UpdateFlashMarkers` integration. V23 removed that entire hook
and V30/V32 live testing then accepted terms such as `Limbo` and `00`. That
isolation proved the combined implementation participated in the failure. It
did not prove that the original OpenWF hook must be permanently removed.

Current upstream OpenWF `0.13.6-hotfix-2` still uses `UpdateFlashMarkers` as
the UI-VM Pluto clock. That source is historical behavior evidence, but the
pinned U43 client cannot retain that method-table replacement: V23 removed it
and stopped the exact-search crash; V37 restored it and reproduced the same
execute-at-zero failure after typing `Limbo`.

The separate RENOVICE callback checks the exact captured DE VM, owner thread,
interpreter depth, and RENOVICE recursion. It is authorized only while startup
or an explicit F9/SCRIPTS transaction is pending. A `RunScript` native call can
invoke the interpreter and receive control while it still owns live arguments
and results, so periodic Pluto work cannot run from that DE-return callback.

V35 made only `injection::drain()` idle. The enclosing callback still replaced
DE error handlers, changed `luau_L`, and ticked background/ordinary Pluto
scripts. The freeze recurred and CDB caught the primary game thread returning
from `bgscript->tick()` at exact V35 address `WTSAPI32+0x2C3FE`. V36 removed
that scheduler from the DE return callback, and the user reported a clean UI
isolation result, but it also paused required Pluto behavior. V38 keeps V36's
pending-only RENOVICE callback and moves full Pluto work to the native
Application frame return. The executable pattern is unique in the exact
hash-pinned U43 build, the callback runs on the captured UI owner thread, and
the UI state must be idle at `base_ci`.

The native fault logger is diagnostic only. It records near-null access
violations to `OpenWF/CustomScripts/Logs/renovice_fault.log`, may write a
minidump at `OpenWF/CustomScripts/Diagnostics/renovice_fault.dmp`,
and returns `EXCEPTION_CONTINUE_SEARCH`. It must not swallow or reinterpret the
game exception.

## Known intermittent UI update/input-ownership freeze

A marked V34 live reproduction on 2026-09-06 confirmed a nonfatal UI failure
that is distinct from the corrected exact-search crash. While `LoadOutRedux`
was open, five different UI producers failed through
`Background.lua:5698` with nil, boolean, and string-call type errors. The
visible loadout movie then closed normally enough to save and return to the
ship, but menu-style pointer navigation remained active against an invisible or
stale UI owner. The game process remained responsive.

Do not describe this as a resource-loading stall: the relevant loadout resource
operations completed before the first shared `Background` failure. Do not
globally coerce the `Background` helper arguments with `tostring`; the captured
failures contain different operations and types, so coercion would hide the
contract violation.

The marked generation never attached the SCRIPTS row and never opened the
SCRIPTS settings child. Therefore the custom settings form is false as the
direct trigger for that reproduction. The always-active VM observer, internal
bridge registration/maintenance, and target-addon observer are not yet isolated
from one another.

The bridge-absent A/B under
`RENOVICE_DEPLOYMENTS/SCRIPTS_UI_BRIDGE_DISABLED_AB_2026-09-06`. It preserves
the V34 DLL, replacements, target addon, and bridge bytes. It reproduced the
freeze while the current generation explicitly reported the bridge absent and
stock TopMenu preserved. Therefore the V10 bridge/SCRIPTS attachment feature is
false as a required cause. At the failed transition, `DiegeticUpgradeCards.swf`
finished loading, but no movie creation followed `GoToScreen(UpgradeCards)`;
the HUD and input had already switched away from LoadOutRedux. The exact bridge
bytes were restored afterward, and the live state is again `ACTIVE`.

A third reproduction after bridge restoration directly tied the exact-match
hitch to `LoadOutRedux::LeftPanelInventorySelectorSearchTextInput`: at 69.404
seconds a table reached the shared `Background.lua:5698` string packer. The
generation contains no F9 request or post-startup reload. V34 nevertheless ran
`_T`/bridge/target generation maintenance every 100 ms, including returns that
were not proven outside native Lua C callers. Source audit also found raw stack
pointers captured before the potentially relocating `check_stack()` call.

The V35 test is false. After repeated frame, weapon, upgrade, and menu
transitions, typing `codha` reproduced the visible but noninteractive search
menu while the game continued. The same-run EE snapshot contains nil/table
concatenation and string-call failures through `Background.lua:5698` from six
unrelated UI producers. The live CDB stack and exact V35 disassembly identify
the periodic background Pluto tick described above.

The scheduler base retained through current V49 is V38 under
`RENOVICE_DEPLOYMENTS/NATIVE_FRAME_PLUTO_V38_2026-09-07`. It contains the full
background/ordinary `.pluto` scheduler and Pluto hotkeys, leaves the stock Lua
method table alone, and keeps RENOVICE `.lua_B` work on the pending-only DE
transaction route. Private build, source, executable-boundary, package, core,
bridge, semantic/API, x64, and import gates pass with zero final warnings or
errors. V49 retains those boundaries in its exact pinned DLL. In the accepted V38 run, the
dashboard returns HTTP 200 and reports `OpenWF/Scripts/samples/Chat
Commands.pluto` as a running configured autostart script; the process remained
responsive and the native fault log remained unchanged during the initial
watch. Exact `Limbo`, `00`, `codha`, and repeated transition interaction remain
the live acceptance gates.

## Current lifecycle limitations

A successful replacement-map commit and `native module refresh PASS` prove
delivery to the registered module context. They do not rewrite a Lua closure
or secondary loop that was already executing.

The current Octavia Amp no-distance replacement demonstrates this exact
boundary: it differs from stock by one byte at file offset `0x21E8`, changing a
branch operand inside `AmplifierLoop`. A currently running Amp entity retains
the old prototype. Let it expire and cast a new instance; if the game retains
the owning ability object, a respawn or mission transition may still be needed.
A future solution must be a reusable active-instance lifecycle/event contract,
not Amp-specific bootstrapper code.

Managed callback dispatch can switch generations immediately because new
events consult the current rooted handler generation. A callback already in
progress is allowed to finish on its retained old generation; cleanup occurs
through the lifecycle contract.

## Accepted evidence versus pending evidence

- **Accepted live causal evidence:** removing the `UpdateFlashMarkers`
  replacement removed the reproduced exact-search crash family; restoring the
  upstream-only version in V37 reproduced the same execute-at-zero crash.
- **Accepted live:** F9 and accepted SCRIPTS transactions can commit add-on and
  replacement generations in the same process.
- **Accepted live:** Mallet target-addon generations reached both `addons=0`
  and `addons=1`; Amp and Metronome produced stock/replacement native refresh
  passes.
- **Accepted live:** disabled-at-start target discovery was the V32/V33 missing
  Mallet enable cause; V33 separated discovery from execution policy.
- **Built, verified, and deployed but awaiting a new live run:** V34 applies a
  staged switch batch through either recognized Generic Settings close route.
- **Rejected live:** V35 fixed idle work inside `drain()` and stack relocation
  hazards, but the searchable-menu/input freeze recurred.
- **Accepted live diagnostic evidence:** during the V35 freeze, the primary
  game thread was inside Pluto and returned through the exact
  `bgscript->tick()` call site in the DE VM return callback.
- **Accepted live isolation evidence:** V36's pending-only DE callback produced
  a user-reported clean menu run, but paused original Pluto behavior.
- **Rejected live:** V37 restored Pluto functionality and then crashed on exact
  `Limbo` with the V21/V22 null-continuation signature.
- **Deployed live with Pluto startup proved:** V38 leaves the Lua method table
  stock, restores complete Pluto scheduling after the native Application frame
  returns, and retains the pending-only DE callback. The dashboard, script
  inventory, configured autostart entry, and running `Chat Commands.pluto`
  coroutine are present in PID 7388. Exact-search and repeated clean menu
  cycles remain required as regression checks in V49.
- **Rejected live:** V39 did not reach the native packet call within its exact
  execution scope; V40's native handoff route also produced no Overguard.
- **Rejected live:** V41 loaded and matched six card queries but produced no
  custom card rows or Overguard. Borrowed `type` guards and the card-resource
  gameplay match are removed.
- **Partially accepted and gameplay rejected live:** V42's guardless card
  callback restored the Mallet addon rows. Its module-environment `mOwner`
  lookup returned nil at `SetSourceObject`, so no damage callback was installed
  and no Overguard was granted.
- **Historical V43 successor:** resolve the target from exact Lua CallInfo
  caller identities already active at the native packet call. The walk is
  aligned, bounded to the verified U43 `0x28` CallInfo stride, inspects at most
  32 frames, and rejects multiple target keys.
- **Not implied by any offline pass:** immediate mutation of already-running
  replacement closures, every mission transition, or all future game builds.

## Logs that answer different questions

- `OpenWF/CustomScripts/Logs/renovice_source.log`: generation preparation, policy,
  completion route, VM deferral, commit/rollback, replacement refresh, target
  addon activation, and F9 evidence.
- `OpenWF/CustomScripts/ScriptStates.json`: persisted switch policy only. A
  correct boolean does not prove the DE generation drained.
- `OpenWF/CustomScripts/Logs/renovice_fault.log`: near-null native/Luau crash frames.
- `OpenWF/CustomScripts/Logs/Legacy/wf_lua_redirect.log`: older loader diagnostics; do not
  substitute it for current generation evidence.
- `EE.log`: game/resource/script errors and the surrounding stock call path.

For a toggle report, correlate these stages instead of guessing:

```text
stage PASS
  -> settings completion decision
  -> policy commit PASS
  -> reload QUEUED
  -> safe-boundary drain
  -> generation COMMITTED or ROLLBACK
  -> replacement refresh / TARGET ADDON PASS
  -> actual gameplay observation
```

## Required workflow for the next agent

1. Verify the exact project and live paths; do not test against another
   Warframe installation.
2. Read this file, `SCRIPTS_PAUSE_MENU.md`, and the applicable rows in
   `RENOVICE_MIGRATION/custom_feature_manifest.tsv`.
3. Run `RENOVICE_MIGRATION/verify_manifest.ps1` and
   `RENOVICE_MIGRATION/verify_dependencies.ps1` before behavior edits.
4. State one hypothesis, identify the exact log/source evidence that would
   make it true or false, and change only the failing boundary.
5. Preserve all working loader, F9, search, add-on, replacement, and UI paths.
6. Add a deterministic test, then run
   `RENOVICE_TOOLCHAIN/build_private.ps1`; warnings and errors are failures.
7. Before deployment, confirm the exact game-folder process is stopped. Save
   the previous DLL and internal bridge together, deploy the matching pair,
   and verify hashes.
8. Call offline/build/deployment success exactly that. Require a separate live
   test before claiming gameplay parity.

## Evidence index

- V34 toggle root cause and Amp byte comparison:
  `../RESEARCH/SCRIPT_SWITCH_APPLY_ON_CLOSE_V34_2026-09-04/README.md`
- V33 disabled-target inventory:
  `../RESEARCH/LIVE_SCRIPT_TOGGLE_TARGET_INVENTORY_V33_2026-09-03/README.md`
- V32 transaction starvation diagnostics:
  `../RESEARCH/LIVE_SCRIPT_TOGGLE_FIRST_TRANSACTION_STARVATION_2026-09-03/README.md`
- Search crash isolation and correction:
  `RESEARCH/SEARCH_UI_NULL_CRASH_2026-09-03/README.md`
- Marked intermittent UI update/input-ownership freeze:
  `../RESEARCH/SEARCH_UI_INTERACTION_FREEZE_2026-09-06/README.md`
- Detailed menu/UI contract: `SCRIPTS_PAUSE_MENU.md`
- Addon and target-hook boundaries: `NATIVE_TARGET_ADDON_HOOKS.md`
- General API architecture: `MODDING_API_ARCHITECTURE_REVIEW_2026-08-24.md`

V45 launch evidence: PID 14856, local 04:55:16. Embedded constructor loaded with pcall=0; damage.runtime.ready and the 22-node exact target graph are present. All 16 CustomScripts files were preserved by hash. Gameplay pending.

V46: see RESEARCH/V45_OVERGUARD_LAG_2026-09-07.md. Sampled detail plus all-callback performance counters replace per-event disk writes. Immutable provider lists are published at generation changes. afterDamage now optionally receives a third opaque batch token. The standalone addon uses the verified Mallet ability type for threat dispatch once per batch/source; Overguard formula unchanged. DLL and addon deployed, 15 other CustomScripts files preserved, PID 36316 launched local 05:09:32.

V47 candidate: see
`RESEARCH/V47_EXACT_DAMAGE_BATCH_AND_THREAT_CALLSITE_2026-09-07.md`. The third
opaque token is retired. The generic native bus sums per-target actual damage
inside the exact synchronous `RadialDamage` call and dispatches one
`afterDamage(source, total)` immediately at native return. The addon performs
one setter/notification/integration sequence per pulse. Threat no longer runs
from damage; `transformFloatArgument` changes only BardMusic prototype 16,
instruction 596, the exact stock `PushFloatArg` callsite from the schema-2 map.
Zero-warning build and offline gates pass; deployment and live gameplay remain
separate acceptance gates.

V48 deployed successor: see
`RESEARCH/V48_COMPACT_NATIVE_HOOK_RECOVERY_2026-09-07.md`. V47 exited during
the four-adapter installation boundary after addon acceptance; its uncontained
ordinary-detour constructor was rolled back to V46. V48 keeps the two proven
callback detours, uses distinct compact hooks for `RadialDamage` and
`PushFloatArg`, contains detour construction exceptions, rejects partial
bundles, and restores target bytes before freeing trampolines on a capability
change. The full package passes offline. Deployment changed only the DLL and
standalone addon and preserved 15 other custom files. PID 26948 passed startup:
22 target prototypes, addon accepted, and all four adapter counts equal one.
Live gameplay then proved that the addon grants Overguard, while rejecting the
batch timing: actual frame Overguard increments continued for roughly 1.5
seconds after the enemy died. The user explicitly ruled out HUD-only delay.
Keep the engine-reported calculated damage value, including overkill; do not
replace it with target HP, shields, or effective-health loss. The next build
must dispatch each positive resolved Mallet damage callback immediately and
remove `RadialDamage` as the effect-timing boundary. Threat 5 remains a
separate unverified live gate. PID 26948 is closed; exact V48 DLL/addon hashes
are retained in the V49 rollback directory.

V49 installed successor: see
`RESEARCH/V49_LOW_LEVEL_NATIVE_CALLS_AND_IMMEDIATE_MALLET_2026-09-07.md`.
The runtime now accepts reusable `hooks.nativeCalls[method].before/after`
declarations from any exact content-keyed target addon. Native methods resolve
through the SWIG catalog and run only for the addon's exact target body, DE VM,
prototype, and instruction. Arguments and results use mutable one-based tables;
the receiver is argument 1. Invalid, ambiguous, conflicting, or partial hook
sets fail closed, and no Mallet-specific behavior exists in the runtime.

The V49 Mallet addon removes the radial batch entirely. Every positive
engine-reported damage callback immediately invokes
`afterDamage(sourceAbility, reportedDamage)`, preserving calculated damage and
overkill. `PushFloatArg` at prototype 16, instruction 596 changes the stock
threat argument from 1 to 5 through the generic low-level hook. Both the 1%
conversion and 15,000 Overguard cap use stock upgrade operation 10; only the
conversion retains the 5% ceiling. Gameplay and the modded card call the same
functions. Deployment changed only `wtsapi32.dll` and the Mallet target addon,
preserved 15 other custom files by hash, and retained the bridge and script
policy. Package, compiler, semantic, API, runtime, UI, x64, and import gates
pass offline with zero build warnings. PID 23868 then passed live startup with
the corrected `build=V49` trace marker, 22 target prototypes, exact-environment
addon load, `TARGET ADDON PASS`, both damage transport hooks, and
`nativeCalls=1`. Gameplay now has a user-observed functional PASS for Mallet
damage producing Overguard. A smaller intermittent timing defect remains: one
or two real Overguard increments can become observable a fraction of a second
after the watched enemy dies. The injector does not queue these callbacks; 73
V49 performance windows recorded zero dispatch errors and at most 1.5542 ms
inside the complete host/provider path. The remaining boundary is upstream
engine callback delivery, post-setter state publication, or a later callback
from another target/damage instance. See
`RESEARCH/V49_POST_CALLBACK_TIMING_ANALYSIS_2026-09-08.md`.

V50 diagnostic candidate: see
`../RENOVICE_DEPLOYMENTS/MALLET_CALLBACK_TIMING_TRACE_V50_2026-09-08/README.md`.
It preserves the V49 formula and hooks while adding positive-damage-only
correlation records around native callback receipt, the existing
`SetOverguardAmount` call and immediate readback, and addon return. The exact
damage-packet receiver is retained as an opaque identity; callback argument 1
is recorded without assigning it an invented semantic name. The zero-warning
build and complete offline package gates pass. Deployment changed only the DLL,
Mallet addon, and diagnostics config; 14 other custom files, the exact Scripts
bridge, and the script policy were preserved by hash. The game remained stopped
after deployment. Startup and the timing conclusion remain separate until the
diagnostic run is captured.

V50 live timing result: PID 27616 reproduced the user's real post-death
Overguard increment. Twenty-one positive callbacks arrived at exact 500 ms
intervals, and the complete native/provider dispatch returned in 0-16 ms with
a measured high-resolution maximum of 2.1521 ms and zero errors. Subsequent
windows contained only zero results. This rejects an injector backlog: later
Mallet beats supplied fresh positive engine callback values. Both captured
opaque identities changed every beat, while the API registry still leaves
callback argument 1's type unresolved. Do not treat it as a victim or add a
dead-target predicate until its native contract is proved. The optional
Lua-side setter trace was absent and is recorded as a diagnostic gap; the
native brackets still cover the complete synchronous addon call. See
`RESEARCH/V49_POST_CALLBACK_TIMING_ANALYSIS_2026-09-08.md`.

V51 callback-identity diagnostic is deployed with DLL SHA-256
`978FC0302698C4A8612EAE6E5D4CF3E3625A63C827965AA1921E712472F4BC2B`.
It unwraps and records engine object/type identity for the source ability,
callback argument 1, and outgoing damage packet at every positive diagnostic
callback. Deployment changed only `wtsapi32.dll`; the working V50 Mallet addon,
Strength-scaled cap, 1%-to-5% conversion, threat-5 callsite edit, card rows,
config, Scripts bridge, policy, replacement path, Pluto files, and the other
CustomScripts files remain hash-identical. Live callback-type evidence is the
next gate; V51 does not claim the late gain fixed.

V51 live callback identity result: the saved post-boundary capture contains 45
positive callbacks. Every callback argument 1 unwrapped to a
RifleLancerAvatar engine object. Correlations 1-22 retained one engine object
despite changing Lua userdata wrappers; the later target sequence retained a
second object. The source remained one OctaviaPrime ability object. This proves
the value is the callback-local damaged `AvatarOrEntity` for the reproduced
Mallet path. RadialDamageData packet userdata did not use the engine
`Object` wrapper layout, which is recorded as a negative layout result rather
than treated as a missing identity field.

V52 staged successor:
`../RENOVICE_DEPLOYMENTS/MALLET_DEAD_VICTIM_FILTER_V52_2026-09-08/`.
The addon adds one synchronous predicate:
`not IsNull(callbackTarget) and callbackTarget:IsDead()`. A dead target
returns before any Overguard read/write; every living positive result keeps the
V50 formula. The V51 runtime DLL, universal addon architecture, damage value,
Strength-scaled conversion/cap, threat-5 instruction edit, card rows,
replacement path, UI bridge, Pluto, config, policy, and other scripts are
unchanged. Focused behavior, deterministic compile, 11/11 full-body
roundtrip, 11/11 semantic plan/IR, strict API, injection, runtime, Scripts UI,
and package gates pass offline. Deployment then changed only the Mallet addon,
preserved the V51 DLL and 15 other CustomScripts files by hash, and passed the
deployed-state gate. V52 addon SHA-256 is
`95A13EDE7B48CBEFD47550D69F34E47DC2E7AF7DC9611BFC17425DE2C650DD64`.
The pretest log boundary is 8,777,576 bytes at
`2026-09-08T04:17:43.8925174Z`. Gameplay remains pending.

V52 live result is **FAIL** and has been rolled back. The addon attached and
received 16 positive callbacks, but every `callbackTarget:IsDead()` call
failed with `attempt to call nil method`; 16/16 afterDamage dispatches ended
in error and produced no Overguard. The callback's underlying native object is
an Avatar, but its Lua wrapper does not expose the complete ordinary Avatar
method table. This negative result is now in the API registry and regenerated
Semantic SDK.

V53 is deployed with addon SHA-256
`87498DF37AC94DFFF9A8AE1ABB26537672B1CE15D49991034D6A914C4032EE14`.
It checks the much more widely observed stock `IsKilled()` method only when
that field exists. A missing method therefore preserves the working Overguard
path instead of aborting it. Offline tests cover living, killed, and methodless
targets. Deployment changed only the addon, preserved the V51 DLL and 15 other
CustomScripts files by hash, and passed deployed verification. The V53 pretest
log boundary is 8,875,409 bytes at `2026-09-08T07:48:50.1644173Z`.

V53 live result: Overguard, card publication, and successful addon dispatch
remain functional, but the intermittent post-death gain is **not fixed**. PID
27052 produced 104 complete positive callbacks across six stable
RifleLancerAvatar engine objects with zero dispatch errors. The latest object
received 18 new positive results over 8.734 seconds at the native callback's
normal 500 ms cadence. No callback was rejected by the V53 killed-target
predicate. This continues to disprove an injector queue: the late grants are
driven by new engine callback results. The capture is pinned in the V54
deployment package with SHA-256
`99F68B4005FFCFDF01B3C1257F2D482BC4F6E96270E91B54D70091C876B19151`.

The V51 identity diagnostic itself caused two observer stalls: 437 ms and
344 ms total callback delay, both before addon dispatch while resolving and
writing per-hit type identity. That observer is no longer appropriate for
timing acceptance.

V54 live diagnostic:
`../RENOVICE_DEPLOYMENTS/MALLET_CALLBACK_TARGET_STATE_TRACE_V54_2026-09-08/`.
The working addon and native path passed, but the direct `RENOVICE_TRACE`
target-environment field produced zero addon state records even though runtime
installation logged PASS. The diagnostic transport is therefore rejected.
The user's 30 fps video proves the visual symptom: the enemy name and health
bar disappear by about 14.0 seconds, while Overguard rises at about 14.2 and
14.6 seconds. The matching runtime log has no callback-dispatch errors and no
multi-tick dispatcher backlog. See
`../RESEARCH/MALLET DAMAGE CALLBACK RE/VIDEO_PROJECT_4_V54_FRAME_ANALYSIS_2026-09-08.md`.

V55 deployed successor:
`../RENOVICE_DEPLOYMENTS/MALLET_CALLBACK_RETURN_STATE_TRACE_V55_2026-09-08/`.
The addon returns event, correlation, callback target, reported damage,
`IsKilled` capability/result, and `GetHealth` capability/result directly to
the generic dispatcher after every `afterDamage` decision. Diagnostics mode
records those eight return values and discards them. No timer, queue, poll,
support script, health filter, or ability-specific runtime behavior is added.
All focused behavior, deterministic compile, 12/12 bytecode roundtrip,
semantic plan/IR, strict API, injection, safe-runtime, Scripts UI, analyzer,
x64, import, and zero-warning build gates pass. Deployment changed only the
DLL and Mallet addon and preserved the other 15 CustomScripts files by hash.
The pretest boundary is 9,333,364 bytes at
`2026-09-08T09:01:08.2027334Z`.

V55 reproduced result: 20/20 callback decisions were grants, with positive
reported damage arriving at the native callback's roughly 500 ms cadence.
There were zero dispatcher errors and maximum observed wrapper time was
1,570.4 microseconds. The first three sampled Lua userdata addresses differed,
but all unwrapped to the same native `RifleLancerAvatar` object. All 20 wrapper
values reported `IsKilled` unavailable and `GetHealth` unavailable. The V55
analyzer was corrected: this evidence is
`UNRESOLVED_METHOD_UNAVAILABLE`; it does not disprove a zero-health callback.
The capture SHA-256 is
`5D26CB95EC12F4D8DFC28C04F4DC320234B4FB12D4513B4584C6080B735FC028`.

V56 staged successor:
`../RENOVICE_DEPLOYMENTS/MALLET_CANONICAL_TARGET_STATE_FILTER_V56_2026-09-08/`.
The generic damage callback unwraps the exact callback userdata to its native
game Object and passes that same Object through the game's `luau_pushobject`
routine. The canonical result stays rooted on the active Lua stack across
addon dispatch. The standalone addon then reads stock `IsKilled()` and
`GetHealth()` synchronously and rejects only an exact callback whose killed
flag is true or health is zero or lower. Failure to canonicalize or find those
methods preserves the V55 grant path and remains trace-visible. There is no
timer, queue, polling, health offset, target type, Mallet branch, or Overguard
operation in the runtime. The immediate reported-damage formula, Strength
scaling and cap, card rows, threat-5 instruction edit, notification calls,
replacement pipeline, Scripts UI, and Pluto subsystem remain unchanged.

V56 offline result: focused behavior, deterministic compile/reparse, 12/12
full-body DE roundtrip, 12/12 semantic plan, 12/12 Semantic IR, strict API,
injection core, safe runtime, Scripts UI, analyzer fixture, x64/import, package,
and zero-warning build gates pass. Staged DLL SHA-256 is
`E1F71420CE8D9FBBC5AA75641D77B629D95D8E8E6B41999CF4A6544B200C4904`;
staged addon SHA-256 is
`45560BCFA715FC6AC31305B3C792838EAD9B9407B73179FFFA63B0C4FEE252F6`.
V56 deployment changed only the DLL and Mallet target addon and preserved all
15 unrelated CustomScripts files by hash. Deployed verification confirms the
certified executable, V56 DLL/addon, config, policy, and internal Scripts bridge.
The pretest boundary is 9,379,426 bytes at
`2026-09-08T15:40:33.329011Z`. Restart and gameplay reproduction remain the
live acceptance gate.

V56 live result: the delayed-looking Overguard gain still occurred. The
post-boundary capture contains 42 complete positive decisions, all grants, at
roughly 500 ms cadence with zero callback/provider errors. Three bounded
samples report `status=game-pushobject` and zero report canonicalization
fallback, so the native-object rewrap itself worked. All 42 decisions still
reported both methods unavailable because the addon first used ordinary
`GETFIELD` checks. Exact bytecode inspection shows those checks as `GETFIELD`,
while actual stock engine method calls compile as `NAMECALL`. Since both field
checks returned nil, V56 never attempted `IsKilled()` or `GetHealth()` and
followed its explicit fail-open V55 grant path. Capture SHA-256 is
`67ECC57EDAFE11BCCF43DE5462D125729D4ECFC3B8287F37DF8CCFBECD0D81A0`.

V57 deployed addon-only successor:
`../RENOVICE_DEPLOYMENTS/MALLET_PROTECTED_NAMECALL_STATE_FILTER_V57_2026-09-08/`.
It keeps the V56 DLL unchanged and replaces field-visibility guards with
protected direct native NAMECALL helpers. A successful boolean `IsKilled()` or
numeric `GetHealth()` result drives the exact synchronous filter; a failed call
or wrong type remains trace-visible and fail-open. No C++ path, timer, queue,
poll, damage formula, Strength scaling, cap, card, notification, or threat edit
changes. Focused behavior, deterministic compile/reparse, 14/14 exact DE
self-roundtrip, 14/14 semantic plan, 14/14 Semantic IR, strict API, injection
core, safe runtime, Scripts UI, analyzer, x64/import, and package gates pass.
Staged addon SHA-256 is
`36D2E3EC21E5879FBC0129A82139CF35E53D5FC95C8A82443D106EFF6FBDF049`.

V57 live result: **TRUE LIVE for the reported timing regression.** The user
restarted, repeated the same Mallet enemy-death reproduction, and reported that
the result worked perfectly. The accepted live pair is the unchanged V56 DLL
`E1F71420CE8D9FBBC5AA75641D77B629D95D8E8E6B41999CF4A6544B200C4904`
plus the V57 addon
`36D2E3EC21E5879FBC0129A82139CF35E53D5FC95C8A82443D106EFF6FBDF049`.
This is gameplay acceptance from the user's observed reproduction; it is not a
claim that every target type or ability has been exhaustively tested.

V58 deployed runtime successor: reusable diagnostics are now controlled by
`DiagnosticsMode=off|errors|trace` with a bounded event count and exact target,
method, and addon filters. The legacy `Diagnostics=true` setting maps to
`trace`. `off` exits before event formatting. `errors` records only explicit
error/reject/failed events. `trace` records exact target/prototype/instruction,
argument and result vectors, provider identity, callback return, and failure
paths. The optional `_T.RENOVICE_TRACE` bridge installs only for eligible
unfiltered trace sessions, removes only the exact RENOVICE-owned closure when
disabled, preserves foreign fields, and reconciles after F9 commits the new
configuration. See `DIAGNOSTICS_CONFIG.md`.

V58 offline result: config and injection core verifiers pass; the DE callback
runtime and internal Scripts bridge remain byte-stable; the full private build
passes with zero warnings and errors, x64 output, and no companion import. The
staged DLL is 4,567,040 bytes with SHA-256
`8DB276C181D24A23423877570EE7DF4E364A7B77B7C9CF070C3337FE4AE40DF9`.
It is deployed to the game folder with the accepted V57 Mallet addon, internal
Scripts bridge, script policy, and unrelated custom scripts preserved by exact
hash. The updated package and deployed-state verifiers pass with the current
225-row API catalog and 241-symbol Semantic SDK.

V58 live result: **TRUE LIVE for the active configuration and tested paths.**
PID 2932 started with the exact V58 DLL, captured the 22-prototype Mallet graph,
installed the trace bridge, and attached the V57 target addon. F9 commits in
trace, errors, and off modes each produced `RELOAD PASS`, zero reload failures,
and a complete SCRIPTS open/close path. The trace capture contains 2,700 detail
records, 20 Mallet grants, 5 killed-target rejections, 21 performance windows,
zero provider errors, and a maximum complete host/provider duration of 1,705.1
microseconds. Errors mode emitted zero normal addon traces after its commit;
off mode emitted zero addon traces and zero explicit errors. The user confirmed
the card, Overguard, threat behavior, death filter, menu interaction, and
performance remained correct. The accepted final configuration is
`DiagnosticsMode=off`, SHA-256
`4FBB8F24B0C0677DEAB3670283DF0109906BB4546F650CBD15521E2564CCBF70`.

The exact target/method/addon filters, maximum-event suppression record, and an
`off -> trace` bridge-install transition remain offline-verified rather than
live-exercised. They are not required for the dormant accepted configuration
and must not be described as live evidence.

V59 deployed successor: generated runtime output now lives under dedicated
directories. `Logs/renovice_source.log` and `Logs/renovice_fault.log` own
current text output; `Diagnostics/renovice_fault.dmp` owns the crash dump;
historical `wf_lua_redirect.log`, `wf_swf_probe.log`, and unreferenced empty
`DEBUG_LOG` are preserved under `Logs/Legacy`. Six existing generated files
were moved with their exact hashes. No replacement, addon, Scripts bridge,
config, or Pluto file was changed by the layout migration. The installed V59
DLL is 4,568,064 bytes with SHA-256
`30C00226BA1041AA177D9AAEDF18BBCC78D7EBC495B46DDE8AA244DCC22AA045`.
All offline, package, and deployed-state checks pass. Startup and gameplay are
not yet observed for V59, so V58 remains the live-accepted behavior baseline.

The exported-function addon template at
`RENOVICE_SCRIPTING/TEMPLATES/TargetActivateAbilityHook.target.addon.luau`
proves offline that a content-keyed target addon can wrap a reachable module
export such as `ActivateAbility` in its exact captured environment, preserve
yields, varargs, nil results and stock errors, and restore only its own wrapper
through managed lifecycle cleanup. Its deterministic 1,264-byte build has
SHA-256
`8ACEA576731655C59414D2B3735D0E0EFCA26F4832934D1F25C8DF48D7A3D96D`;
9/9 prototypes pass exact DE round-trip, semantic plan, and Semantic IR, and
the generated lifecycle execution fixture passes. This does not prove a live
export fixture, interception of a native caller that cached the old closure,
or addressability of unnamed local closures. The current outer `vm_execute`
detour also does not prove nested Lua prototype entry/return interception.

The preceding paragraph records the V59 boundary. V60/V61 are historical:
they attempted closure/prototype dispatch at VM-entry/outer-return boundaries.
Survival proved one entry case and rejected unconditional post-return, but the
2026-09-19 exact interpreter analysis proves that boundary misses nested CALLs.
V107 supersedes current Lua-call admission with the instruction-level CALL
observer and disables Lua after dispatch entirely.

## V60 exact Lua-call target addon

V60 adds the general low-level contract
`hooks.luaCalls[prototype].before/after`. It is target-body scoped, resolves the
prototype exactly once in the target closure graph, calls Lua under the existing
generation/mutex/depth guards, and fails closed on malformed declarations,
ambiguous prototypes, callback errors, or unsupported upvalue replacement.
There is no Survival-specific behavior in the DLL.

The installed Survival addon owns only three verified stock values in update
prototype 64: elapsed reward time at one-based capture 19, the pickup config
table at capture 22, and the reward config table at capture 70. It keeps the
stock mission module and keypad/start control flow. The previously generated
full replacement is removed from the active root and retained in the V60
rollback package as rejected evidence.

- Installed V60 DLL: 4,564,992 bytes, SHA-256
  `FE86BB140EC1B1FFD30AEDC7D25AC940538FAD0C3E2384913DF9F18DC6D6CC56`
- Installed Survival addon: 2,884 bytes, SHA-256
  `ADEF761299CD0B466F84C42E2626B3AA61FC187504C63119BB13E6336071B1B7`
- Installed script-state manifest: SHA-256
  `B596E46E0E4252F109E745C70D3345A41F07014A95A6CAD52E8CFBC6D07F9B1D`
- Package verifier: all recorded hashes, injection/runtime tests, exact DE
  roundtrip, semantic plan, strict API check, x64 architecture, and absence of
  companion imports PASS.
- Live status: **REJECTED**. The keypad and stock start path worked, but the game
  crashed about four seconds later. V60 dispatched `luaCalls.64.after` while
  the stock update coroutine was suspended; its next resume reached a native
  null-pointer read. F9 cannot correct this because the defect is in the DLL.

## V61 coroutine-aware Lua-call hooks

V61 corrects the generic host rather than adding a Survival branch. The exact
Luau state prefix now names `status` at offset `0x03`, matching both the observed
U43 state bytes and the upstream Luau layout. `before` still runs on every entry
or resume of an exact target prototype. `after` runs only when `vm_execute`
returns with status zero, the active CallInfo bounds validate, and the exact
target closure is absent from the active frame chain. This also rejects a
status-zero native/JIT handoff that has not completed the target call. Yield,
break, error, invalid-frame, and still-active-frame returns skip `after`, preserve
the stock resume state, and log the exact rejection reason under
`luaCalls.<prototype>.after.skipped`.

The current Survival addon declares only `luaCalls[64].before`; all three edits
occur before the stock update and require no post-return work. Ability Studio
now generates this same before-only source. The previous V60 DLL and addon are
preserved as one exact rollback pair.

- Installed V61 DLL: 4,572,672 bytes, SHA-256
  `5CB029981628A41B8C2D92BA2E2A4B986F8546188897BC53A983AE5C09204E45`
- Installed Survival addon: 2,616 bytes, SHA-256
  `25CD05FC50C5350630F0360829B7DC8E4A4DF84EE359187FBCF248F8302763DD`
- Script-state manifest is unchanged: SHA-256
  `B596E46E0E4252F109E745C70D3345A41F07014A95A6CAD52E8CFBC6D07F9B1D`
- Package, source, injection, runtime, x64/import, exact DE roundtrip, semantic
  plan, strict API, and deployed-hash gates pass. Live gameplay remains open.

## 2026-09-09 Mallet cover bypass addon

> **Superseded 2026-09-11:** live testing falsified the native
> `RadialDamage.before` delivery claim in this section. The addon loaded, but
> the target trace recorded zero Mallet `RadialDamage` callbacks and cover still
> blocked damage. The current correction restores the V57 Overguard/card/threat
> target addon and changes only BardMusic prototype 16 instructions 567 and 569
> from boolean true to false. The paired replacement is 17,805 bytes, SHA-256
> `554F847CAD45ADB4AA46B2615EF0E1E68FBCC5BA3864F57A5DF087F363325CE5`.

The stock BardMusic body explicitly opts Mallet into cover handling by setting
both `RadialDamageData.checkForCover` and `staticCoverOnly` to true. Its sole
verified `Region:RadialDamage` call is prototype 16, instruction 576. The
Mallet target addon now uses the existing generic
`hooks.nativeCalls.RadialDamage.before` boundary to set those two fields to
false on the original packet at that exact callsite.

This is an addon-only change. The V61 DLL, Survival addon, Scripts bridge,
configuration, script-state policy, stock BardMusic body, and replacement path
remain unchanged. V57 Overguard behavior, Strength scaling, card rows, target
state filter, and the prototype 16 instruction 596 threat edit are preserved.
The no-cover addon is 2,942 bytes with SHA-256
`C25583684E59C7AB8B1185703ED09701B3B3374A392E4DB416FC458BDE5ED822`.
Exact compile/roundtrip, semantic plan/IR, strict API, instruction-addressed
callsite, stock-evidence, injection/runtime/UI, x64/import, package, and
deployment gates pass offline. Behind-cover damage remains pending direct
gameplay observation.
## 2026-09-11 Interception scoring addon correction

The Ability Studio two-times Interception target addon reached the exact
Territory prototype-35 callback live, but its
`type(scoreRatePerSecond) == "number"` assertion failed on every invocation.
The callback therefore failed closed and left stock scoring active. This
falsifies the old artifact's live behavior without falsifying target lookup or
Lua-call dispatch.

The corrected generated addon removes only that rejected type guard. It retains
the exact `scoreRatePerSecond == 1` ownership assertion, assigns the configured
multiplier once, and preserves the stock times-four mission and times-2.25 alert
branches. The DLL remains the current V61 binary. Offline package, decode,
roundtrip, semantic-plan, native-test, and managed-test gates pass. The
corrected script is deployed; F9 transaction and gameplay scoring remain the
live acceptance boundary.

## 2026-09-13 reusable combat transaction diagnostics

The runtime owns the central, bounded diagnostic trace bridge, so combat-state
measurement does not require a logging support addon. V3 originally resolved
it through `_T.RENOVICE_TRACE`; V69 now passes the same owned closure directly
to hook callbacks. The current canonical embedded component is
`RENOVICE_SCRIPTING/DIAGNOSTICS/CombatTransactionMeterV4.luau`; its paired
analyzer is `AnalyzeCombatTransactionMeter.ps1` in the same directory.

For one exact synchronous combat call, the component correlates target and
packet identity with current/max health, current/max shield, Overguard, stock
raw damage, multiplier, requested raw damage, all nonzero numeric damage
fractions and status counts over indices 0-19, post-call pool deltas, packet
ordinal, observed and canonical inputs, installed damage, and the restored raw
packet value. It checks for the trace bridge before those reads.
With diagnostics off, the offline harness proves zero meter records, zero
health reads, and zero damage-profile reads.

The first staged use is the Ice Wave `DamageDD` call at body key
`f62b70b45fc7fdf9`, prototype 7, instruction 64. The user's repeated test after
the per-call restoration still produced an occasional oversized hit, so the
restoration is accepted as a necessary shared-packet correction but rejected
as the complete spike explanation. Package
`RENOVICE_DEPLOYMENTS/UNIVERSAL_COMBAT_METER_ICE_WAVE_2026-09-13` passes its
behavior harness, analyzer fixture, deterministic compile/reparse, 22/22 exact
self-roundtrip, 22/22 Semantic Plan, 22/22 Semantic IR, and strict API check
with zero unknown calls. At package creation, deployment and live
getter/capture acceptance were pending.

The V1 deployment changed exactly the Ice Wave addon and `renovice.cfg`; the
V67 DLL, `ScriptStates.json`, every unrelated addon, and every replacement
remained hash-identical. The user then reproduced an approximately two-million
hit. The bounded log proves the bridge installed, the addon activated, and the
exact native provider entered and returned in both phases with no provider
error or reject, but it contains zero `COMBAT_*` records. The V1 gate based on
`type(_T) == "table"` and `type(trace) == "function"` is therefore rejected for
the live DE VM. The capture cannot distinguish which label failed because both
branches returned silently, and it provides no numeric explanation of the hit.

V2 reads `_T.RENOVICE_TRACE` directly inside `pcall` and only treats an absent
or inaccessible field as disabled. Its harness explicitly assigns nonstandard
`userdata` and `cfunction` labels while preserving working field access. The
new package is
`RENOVICE_DEPLOYMENTS/UNIVERSAL_COMBAT_METER_LIVE_BRIDGE_FIX_2026-09-13`.
It passes deterministic compile/reparse, 23/23 exact self-roundtrip, 23/23
Semantic Plan, 23/23 Semantic IR, and strict API 20/20 with zero unknown calls.
The deployed artifact is 4,668 bytes, SHA-256
`75E70E9E015D6448248AC3AD727C479A6D5776956AF201AC0BCBB1A53815D063`.
Deployment while PID 25108 was running changed only that addon; the selected
config remains
`6984FC78D14FE6FB4E8149C2E31484E589C9A75996C27CEBFA6606CB9013C42A`.
The V2 pretest log boundary is byte 5,577,510. F9 installation, complete live
transactions, getter availability, and the oversized-hit cause remain pending.

V68 follows two later observations. First, the V67 crash record ends immediately
after an unchanged ESO target-addon loader returned `pcall=-1 result_tag=8`;
that failed execution stored no lifecycle table, yet the generic failure path
still attempted a registry release. V68 gates release on the execution's own
`lifecycle_stored` result. For byte-identical target addons after a new `_T`
table appears, it invokes `cleanup()` and `activate()` through the already rooted
lifecycle table, rolls the active generation back if either step rejects, and
never reruns or replaces the loader root. Changed bytes still use the full staged
transaction. Repeated skip traces now retain the first eight occurrences and
every 256th recurrence, preventing a yielded-call skip storm from consuming the
complete diagnostic budget.

Second, the user established that isolated Ice Wave targets scale correctly but
multi-target casts can produce extreme damage. The stock Frost body creates one
`DamageData` before the target loop and passes the same object to each target's
prototype 7 instruction 64 `DamageDD` call. V68's addon captures the first
stock numeric value and exact `UpgradedValue` object as the canonical packet
baseline. Every target uses `canonical × that target's pre-hit Cold stacks`, and
the exact canonical object is restored after each depth-one call. A nested call
still restores its immediate caller's object. Combat Meter V3 exposes packet
identity, ordinal, observed input, canonical input, Cold stacks, pending depth,
installed value, restored value, health, shield, Overguard, damage fractions,
and status counts through the existing toggleable trace bridge.

The V68 package passes the private x64 build with zero warnings and errors,
generic injection tests, deterministic addon compilation, 25/25 exact
self-roundtrip, 25/25 Semantic Plan, 25/25 Semantic IR, and strict API analysis
with zero unknown calls. Its offline shared-packet fixture presents `70000` as
the second target's contaminated observed value while proving the requested
value remains `700 × 6 = 4200` and the packet restores to `700`. Deployment at
2026-09-13T16:54:47+02:00 changed only `WTSAPI32.dll` and the Ice Wave target
addon. The runtime, F9, and multi-target gameplay results remain live gates.

V68 F9 is now live-accepted. In one clean runtime session, six consecutive F9
transactions, generations 2 through 7, committed with the managed generation
reused, zero one-shot failures, and zero pending targets. The user also reported
that F9 did not crash. Later successful generations do not weaken that result.

The V68 Ice Wave shared-packet premise is false. Exact stock raw source shows
prototype 7 creates `Engine.DamageData()` inside its target loop and assigns the
same authoritative helper argument 3 with `SetBaseAmount` for each target. Live
traces then show the native allocator reuse one packet address for consecutive
logical target packets. A Lua userdata/address comparison can consequently
carry one target's cached baseline into another. The user's V68 test removed
million-scale hits but still shuffled 1-10x values between targets, matching
that failure mode.

V69 captures prototype 7 argument 3 in a `luaCalls[7].before` hook and keeps it
for the matching synchronous helper invocation. Each exact prototype 7,
instruction 64 `DamageDD` call calculates that authoritative value times only
its own target's pre-hit Cold stacks, clamped to the game's 0-10 stack range;
zero and one stack both remain 1x. It restores the exact `DamageData` base object
received by that native call. It never groups calls by a pointer or userdata.

The generic hook ABI now appends the runtime-owned trace closure to every
`luaCalls` and `nativeCalls` callback. This crosses borrowed module-environment
boundaries without asking addon source to resolve `_T`: Lua receives it as
argument 4; native-before receives it as argument 4; native-after receives it
as argument 5. Existing callbacks ignore the added final argument. Combat Meter
V4 uses this direct transport, retains a protected `_T` fallback for older
runtimes, and emits batch ID, target ordinal, observed packet input,
authoritative input, stacks, installed damage, restoration, and target pool
deltas. With diagnostics off, the closure is nil and the meter performs no
health or damage-profile reads.

V69 passes the target-local behavior harness, including deliberately reused
packet identity and observed inputs of 70,000 and 140,000 while authoritative
700-damage calls install only 7,000 and 4,200. The private x64 build passes with
zero warnings and errors, as do injection, safe-runtime, deterministic compile,
29/29 self-roundtrip, 29/29 Semantic Plan, 29/29 Semantic IR, and strict API
checks with zero unknown calls. Deployment is complete: the installed runtime
hash is `53370FED9AA6843BB01CF80ECBEB57266CF71AFF39D6344383C1F39B99DD7451`
and the installed addon hash is
`4939AEF25C10FAC7C187EF475518D2AAC3D76091CA1709556739FCE3FAE34A6B`.
The full non-log CustomScripts comparison changed exactly the Ice Wave addon
and preserved 26 other files plus the configuration and ScriptStates. The
subsequent live test rejected V69: exact native `DamageDD` callbacks and the
host trace bridge ran, but `luaCalls[7].before` ran zero times. No batch existed,
so the fail-closed native callback applied no multiplier. This proves the
native stack can identify the nested prototype while the Lua-entry hook does
not necessarily observe that nested helper invocation.

V70 removes that failed Lua-entry dependency. Exact callsite evidence identifies
prototype 7 instruction 41 as stock `DamageData:SetBaseAmount(c8v2)` and
instruction 64 as the corresponding target `DamageDD(c8v6)`. The addon hooks
both native calls. The setter callback captures the actual stock value and its
exact `DamageData`; the damage callback consumes the newest capture once,
requires exact object equality, reads only that target's Cold stacks, installs
`stock value × max(1, stacks)` for the synchronous native hit, and restores the
stock object afterward. Missing or mismatched captures are consumed and
rejected so they cannot leak into another target.

The V70 harness deliberately applies adjacent 10-stack, zero-stack, and
six-stack targets through the same logical damage object and verifies exactly
7,000, 700, and 4,200 from stock 700. It also verifies the ten-stack cap,
mismatch discard, no-capture behavior, exact restoration, host diagnostics,
and dormant diagnostics. Deterministic compilation produced a 6,181-byte
artifact with SHA-256
`8B602693D395B1E6EAB782D6EE5D0FF8667B156174CCCD7FABDB57775232776E`.
All 28 prototypes pass exact self-roundtrip, Semantic Plan, and Semantic IR;
the strict API audit reports 22 calls, zero violations, and zero unknown calls.
Deployment stopped PID 29076 and changed only the Ice Wave addon. The V69 DLL
hash remained
`53370FED9AA6843BB01CF80ECBEB57266CF71AFF39D6344383C1F39B99DD7451`;
26 non-log CustomScripts files, configuration, and ScriptStates remain
preserved. Fresh-process binding of both methods and gameplay remain pending.

The fresh-process V70 test bound both methods but rejected every setter
transaction. PID 17332 logged 150 `nativeCalls.SetBaseAmount.before` failures,
150 corresponding provider errors, zero `ICE_WAVE_BASE_CAPTURE` events, and
zero `COMBAT_BEGIN_STATE` events. The exact Lua error was `attempt to compare
number < nil`. The only comparison on that path was the addon's finite guard
against `math.huge`; the DE VM does not expose that standard-library field.
Consequently the runtime restored stock arguments and every rejected call
remained at stock damage.

V71 replaces `math.huge` with the compile-time ceiling `1e30`. Its test
environment deliberately shadows `math` with a table that retains `min` but
omits `huge`, and the full target-isolation harness passes in that environment.
The 6,171-byte artifact SHA-256 is
`886142C10441E81139DCE55F12D4A48083CA5828DA712C7B08D5DDC1B16A1791`.
Deterministic compilation, 28/28 exact self-roundtrip, 28/28 Semantic Plan,
28/28 Semantic IR, and strict API analysis with 22 calls and zero unknowns all
pass. Live deployment changed only the addon while PID 17332 remained running;
one F9 activation and gameplay verification were pending. That F9 reached the
V69 host but crashed before the changed V71 target generation committed.

## V72 F9 Lua-mutation boundary

The V69 F9 crash is pinned to the transaction host state. The source log records
`F9 QUEUED`, `F9 DRAIN entered same-VM script boundary`, and one unchanged ESO
root rebind. It contains no Frost target-generation PASS or rollback. The native
fault record then shows state `0x14F172B8D40` with
`outtop=0x14EE20161A8 < intop=0x14EE20161B8`, two tag-zero current function
slots, and lower C and Lua frames. A shared `global_state` proved VM ownership
but did not prove that this coroutine stack could host a new protected call.

V72 adds an explicit mutation-boundary classifier. It accepts an idle base frame
or a validated C/native host frame only. Nonzero thread status, unavailable or
inverted stacks, out-of-range or misaligned `CallInfo`, invalid current
functions, and active Lua frames defer the transaction without consuming its F9
latch. The same rule is rechecked in the transaction drain, generation apply,
chunk loader, target activation, pending-target drain, and lifecycle operation.
No per-frame enforcement or gameplay polling was added.

The injection suite includes the exact inverted-stack and invalid-frame shapes
from the crash plus suspended and active-Lua cases. The source-order verifier
proves that rejection occurs before F9 latch consumption, runtime callback
entry, loader allocation, and lifecycle stack mutation. Injection, config,
replacement, SWF, Riven, safe-runtime, dependency, manifest, callback-runtime,
and private x64 build gates pass with zero build warnings and errors. The
installed 4,598,784-byte DLL has SHA-256
`AE1E26EABB988EA166C5519AA382236C4C48444EEEAB30C033EED45BD19E7CB6`.
Every Inject file remained byte-identical across deployment. Live unchanged and
changed-generation F9 acceptance remains pending after a full process restart.

## V74 reusable battle log

V74 adds a `battle` diagnostics mode and cached runtime-owned trace-closure transport. `battle` accepts explicit addon combat records and runtime failures while suppressing routine successful loader and hook chatter. It does not add a support addon, timer, poll, alternate damage path, or ability-specific C++ branch.

Battle Log V5 creates one transaction per exact target `DamageDD` call. A complete transaction has nine records covering identity, current pools, current armor, numeric statuses, numeric damage fractions, killed/dead/ragdoll probes, raw calculation values, packet restoration, and immediate visible pool loss. Optional engine methods are separately protected and expose availability flags. Maximum armor, semantic status names, and Ice Wave caster/ability identity remain unproven and are not guessed.

The private x64 build passes with zero warnings and zero errors. The addon passes its live-alias/target-local harness, deterministic compile, 33/33 exact self-roundtrip, 33/33 Semantic Plan, 33/33 Semantic IR, and strict API checks for all 30 calls with zero unknowns. The analyzer passes a nine-record Windows PowerShell 5.1 fixture. Package: `RENOVICE_DEPLOYMENTS/COMBAT_BATTLE_LOG_V74_2026-09-14`. The DLL, addon, and battle configuration are deployed and hash-verified. Installed DLL SHA-256: `87D6D6B5DEC81221C8107D152BDC6F9D7FD7EB81EA8781794A7E63A47D34E138`. Startup and Ice Wave `SetBaseAmount`/`DamageDD` native callbacks passed live. Complete battle records failed because an unrelated target addon removed the VM-wide bridge before those callbacks ran.

## V75 shared-VM diagnostic bridge ownership

The V74 Ice Wave test started at byte `12,866,605` and ended at byte `12,879,212` of the live diagnostics log. It contained Ice Wave target-addon activation, later Mallet target-addon activation in the same VM, and subsequent Ice Wave `SetBaseAmount` plus `DamageDD` callback passes. It contained zero `BATTLE_*` and zero `ICE_WAVE_BASE_CAPTURE` records. This makes the V74 hypothesis that a target-local reconciliation could own `_T.RENOVICE_TRACE` **FALSE**.

V75 treats the trace field according to its actual VM-wide lifetime. An unrelated target activation preserves an existing RENOVICE-owned bridge while a valid target-filtered `battle` or `trace` session is active. The explicit VM reconciliation path still removes the bridge when diagnostics are off, the filter is invalid, or the selected addon is no longer eligible. A selected callback that cannot recover the bridge emits one direct `RENOVICE target trace callback FAIL` record, preventing another silent zero-record capture.

The new policy passes deterministic positive and negative tests: unrelated activation preserves; explicit global reconciliation removes; diagnostics off does not preserve; an invalid target filter does not preserve. Migration manifest, dependency, full injection-core, and safe-runtime-tick verifiers pass. The private x64 PE32+ build completed with zero warnings and zero errors. No Ice Wave or Mallet production key appears in the changed runtime policy. Installed DLL SHA-256: `712887EF80BB739B3ABADEF06E758A7B942A3227A8513771762B9ED6A8D75C8F`. Package: `RENOVICE_DEPLOYMENTS/BATTLE_TRACE_SHARED_VM_OWNERSHIP_V75_2026-09-14`. Runtime-only deployment and startup passed, but the first Ice Wave callback reported `trace-field-absent`; the analyzer found zero battle records and zero transactions.

## V76 VM-registry trace root

V75 copied its diagnostic closure into a C++ `TValue` map. That cache is outside Luau's garbage collector and does not root the closure. The live callback failed both cache validation and current `_T.RENOVICE_TRACE` lookup. The capture does not name the exact stock operation that removed or replaced the field, so that operation remains unknown; the lifetime contract itself is conclusively insufficient.

V76 stores the diagnostic C closure under the reserved DE VM registry key `RENOVICE.diagnostic-trace-bridge.v76`, using the same rooting class already used for addon lifecycle tables and published prototype closures. Selected diagnostics create or verify the root, unrelated target activation preserves it, and diagnostics removal clears it. The raw C++ `TValue` cache is deleted. The public `_T.RENOVICE_TRACE` field remains collision checked and foreign values are never overwritten.

Migration/dependency, configuration, full injection core, target-export deterministic compile/roundtrip/semantic/lifecycle, replacement, Scripts UI, and safe-runtime-tick gates pass. The private x64 PE32+ build completed with no warnings or errors. Installed SHA-256: `A703E0E96523679FC5A3B597AA538E11C50BF2817A761A1CC629688FCF10220D`. Package: `RENOVICE_DEPLOYMENTS/BATTLE_TRACE_REGISTRY_ROOT_V76_2026-09-14`. The live V76 capture produced 990 records, 110 complete transactions, and zero incomplete transactions; this closes the registry-root transport gate.

## V77 automatic scripted-damage capture

Hypothesis: the runtime can record every Luau-visible per-target damage call without adding a logger to each ability. **Offline result: TRUE for exact `DamageDD` transactions.** V77 catalogs each loaded module's complete U43 prototype graph at the natural loader return, installs the generic `DamageDD` adapter from configuration alone, and resolves the closest cataloged Luau caller to a body key, module path/name, prototype, and instruction. The embedded observer contains the exact canonical Battle Log V5 prefix and reads target pools, armor, statuses, packet fractions, raw packet amount, death state, and ragdoll state immediately before and after stock `DamageDD`. It performs no setter, replay, polling, or gameplay mutation.

Hypothesis: this proves every engine damage source. **FALSE.** Weapon, projectile, or other damage completed wholly inside native code may never invoke the Luau `DamageDD` wrapper. `RadialDamage` is an area request and does not expose one resolved per-target result at the script boundary. Those lanes remain explicit coverage gaps pending a separately proven native damage-control ingress.

`DiagnosticsDamageCapture=scripted` enables broad discovery. Exact source body/path/name, target type, and numeric damage-type filters isolate a later run. The existing exact target addon wins when it owns the same `DamageDD` call, preventing duplicate battle transactions. F9 reconciles the runtime and native-hook contract; a restart remains the complete source-catalog path for modules loaded before capture was enabled. The embedded Luau observer passes behavior tests, 34/34 DE self-roundtrip, 34/34 Semantic IR, and byte-header identity. Configuration and injection-core tests pass. The zero-warning x64 build, package, deployment, and installed hash checks pass. Startup and multi-source capture were rejected in the first live run; see the V78 lifecycle repair research. Historical package: `RENOVICE_DEPLOYMENTS/AUTOMATIC_SCRIPTED_DAMAGE_CAPTURE_V77_2026-09-15`.
