# Migration status

Updated: 2026-08-23

## Completed

- [x] Copied the normal bootstrapper source into this dedicated edited tree.
- [x] Verified all 93 copied files and 3,455,331 bytes against the untouched
  source with zero SHA-256 differences.
- [x] Recorded per-file and aggregate baseline hashes.
- [x] Identified 43 custom, experimental, disabled, and patched-companion
  features in a machine-checkable manifest.
- [x] Assigned a migration target, risk, runtime gate, and parity test to every
  feature.
- [x] Defined twelve single-DLL acceptance requirements.
- [x] Added a manifest verifier and project-specific preservation rules.
- [x] Identified the authoritative source as `Sainan/warframe-dll` commit
  `756bdc17aa9edf61df8204f901cdfff37b47db57`.
- [x] Proved all 93 copied non-submodule files match that commit after only
  CRLF/LF normalization.
- [x] Restored the five exact upstream submodule gitlinks and verified them
  through a fresh recursive clone.
- [x] Established a pinned local toolchain and warning/error-gated build script.
- [x] Built the unedited private source successfully as an x64 `wtsapi32.dll`
  with zero warning/error lines and no companion-DLL import.
- [x] Added the certified U43 native-name seed `0x7e5af8e9`, July manifest
  mapping, and exact U43 build allowlist.
- [x] Root-caused both old mandatory-scan bypasses as seed-dependent native
  lookups (`UpdateFlashMarkers` and `GetStringVariable`); both resolve uniquely
  on the certified July executable without bypassing any failure path.
- [x] Verified the July executable's core HTTP, encryption, TLS, worldstate,
  Lua, pause, and profile signatures offline. The profile capture remains
  `match + 0x27 == 0x2c8`.
- [x] Rebuilt the edited private source with zero warning/error lines as an x64
  DLL with no companion-DLL import.
- [x] Ported the boot-time DE-Luau replacement path (`LR-001` through `LR-004`)
  into `renovice/replacements.*` using the source tree's native detour system.
- [x] Preserved the deployed non-standard body-key basis, annotated filename
  convention, replacement-owned length, immutable byte lifetime, masked U43
  signature, and exact-build June/July RVA fallbacks.
- [x] Validated all four active replacement filenames and rebuilt with zero
  warning/error lines. Live replacement execution is still pending.
- [x] Ported ordinary one-shot additive injection (`LI-001` through `LI-007`)
  with unique U43 signatures, captured manager state, true global environment,
  registry restoration, VM-top restoration, and native fault containment.
- [x] Reused OpenWF's existing script-thread tick for F9 and injection draining;
  no additional polling thread or `SetStringVariable` hook was introduced.
- [x] Made Inject folder reload transactional and explicitly rejected the old
  experimental `.persist`/`.spawn` routes until their lifecycle is redesigned.
- [x] Ported the shared `CustomScripts` configuration resolver with a real
  writable-primary probe, LocalAppData fallback, exact flag parsing, cached
  runtime state, and F9-only reread.
- [x] Ported content-keyed SWF replacement with strict FWS validation,
  replacement-owned lifetime, optional size-changing TOC metadata, unique U43
  signatures, and an empty-folder disabled fast path.
- [x] Ported the `riven_lock.cfg`-gated Riven UI behavior with cached startup/F9
  gating, exact URL parsing, asynchronous configured-server requests, and
  deferred UI refresh on the script boundary.
- [x] Replaced the unsafe fabricated `.persist`/`.spawn` scheduler experiment
  with generation-owned `.addon.lua_B` lifecycle tables rooted in the real DE
  registry and explicit idempotent `activate`/`cleanup` operations.
- [x] Made F9 stage configuration, SWF, full Lua replacements, Riven gating,
  and the complete Inject folder before publication; addon activation failure
  cleans the candidate and attempts to reactivate the previous generation.
- [x] Added atomic F9 refresh of the full-module replacement snapshot plus
  same-VM re-execution of changed loaded modules in their captured environment.
  Future calls use the refreshed exports; already-running closures finish on
  their old generation. Removal re-executes the captured stock body.

## Current hard boundary

U43 compatibility, full-module replacement, ordinary additive injection,
managed addon generations, transactional F9 staging, shared configuration,
SWF replacement, and Riven UI behavior are source-ported and offline-verified.
The generic generation layer manages lifecycle; event-specific wrappers such
as `AfterMalletDamage` still require a proven native event/callback contract.
Stable in-place export-table hot modules (`TG-006`) are also a separate future
facility. The new single DLL was deployed byte-for-byte to the game root on
2026-08-23. The running process then proved the exact game-local hash loaded
with no companion module; the user reported the four existing replacements
working, and the source log proved Riven wrapping plus accepted lock POSTs.
Exact copies of the known-good two-DLL runtime remain in
`Backusp warframe/Warframe 23.08.2026` as the recovery baseline.

The 2026-08-23 managed-addon live sequence now proves successful replacement,
cleanup, registry-root release, invalid-generation rollback with the previous
generation preserved, post-rollback replacement, deletion, and a final empty
generation. A dump-proven wrong-state crash was corrected by executing calls on
the current same-global-VM boundary. A separate focus-change key latch was also
fixed and live-proven. Inject was left empty. Region-transition stress, one
hundred reloads, activation-failure recovery, and native-fault containment
remain open rather than being inferred from this pass.

The later Mallet cast-addon experiment exposed two unproven assumptions in the
deployed reload path: F9 sampled only the current key-down bit and could be
suppressed by the ordinary UI hotkey filter, while the addon assumed `_G._T`
was the module-global shared table. The source now latches quick F9 taps, keeps
the transaction foreground/policy gated without the UI filter, and
persistently logs queue, same-VM drain, lifecycle failure, rollback, and commit
stages. A first attempt to synthesize `_T` from the callback-state global
pseudo-index was live-refuted. Resolving bare `_T` from the loader-assigned
addon environment then passed live: F9 committed the addon and the next Mallet
cast granted exactly 30,000 Overguard. The addon was then removed, F9 committed
generation 14 with `addons=0`, and the user confirmed the flat-on-cast behavior
disappeared while the permanent Mallet replacement remained functional.

The later ability-card pass live-proved the description override but refuted
the proposed managed-addon row registry. F9 repeatedly reported `addons=1` and
`module_refresh=PASS`, yet the screenshot still contained only the four stock
bottom rows. The corrected editor contract is to generate more instances of
Warframe's existing native row tables directly inside each ability's
`GetAbilityUpgradeLevelInfo`, using the same source-of-truth formulas as
gameplay. This correction is recorded under `RENOVICE_SCRIPTING/CARD_UI`.

The first clean stock-BardMusic target-addon test then proved a common routing
failure: target identity, addon activation, and both native method adapters
loaded, but neither the card attachment nor damage attachment executed. This
was not an addon formula failure. The card path incorrectly treated the native
`SETGLOBAL` helper frame as the owner, and the damage path performed `ci - 1`
with a 24-byte partial CallInfo declaration against the VM's 48-byte record.
The source now identifies card ownership from the assigned Lua export closure,
declares and statically asserts the complete CallInfo ABI, exposes
`base_ci`/`end_ci`, and walks only bounded active Lua frames and live stack
function slots. The corrected DLL and separate addon are deployed with zero
BardMusic root replacements; corrected live card/gameplay acceptance is open.

The next clean launch still produced no addon card rows. Its log proved the
corrected ABI, target identity, addon generation, and native adapters loaded,
but `GetAbilityUpgradeLevelInfo.attach` remained absent. The remaining issue
was lifecycle order: the export is assigned inside the loader, before post-load
identity recording and addon activation. The hook now carries the immediate
target body key only across the real loader's dynamic extent, masks it across
nested non-target loads, and decorates the initial export before post-load
activation. Assigned-closure identity remains the later-refresh fallback. The
new build is deployed with its predecessor preserved; live acceptance remains
open rather than inferred from offline gates.

The following clean launch disproved that loader-boundary refinement too. The
fundamental error was treating VM `SETGLOBAL` bytecode as though it called the
public Lua C API setter detoured by OpenWF. It does not, so the hook could never
observe a script export. That experiment is removed. The current staged design
decorates the actual exported field through the registry-root closure's proven
module environment after load, verifies the wrapper by immediate field
readback, and resolves `_T` from the original closure environment during card
dispatch. The third-test client subsequently closed; this corrected DLL is now
deployed with its setter-based predecessor preserved for rollback.

That environment-decorator build then produced
`card export attach FAIL reason=export-not-function`. Disassembly falsified a
hashed-export theory: BardMusic writes its public functions through ordinary
string-key `SETGLOBAL` constants. The real sequencing error was treating
module load/undump completion as module execution completion. The current
staged build hooks the resolved protected-call boundary, matches only the exact
target root closure identity, lets stock initialization finish, and then
decorates and readback-verifies the base export. Nested closures, unrelated
modules, and RENOVICE's own protected calls cannot trigger it. Offline gates
pass. The client was subsequently confirmed closed; the exact root-execution
DLL and unchanged addon were deployed and hash-verified with zero BardMusic
root replacements. Card and gameplay acceptance on the next launch remains
open.

The final live launch closed that acceptance as **FALSE**. The addon and exact
target loaded, but Mallet granted no Overguard and its card contained no addon
rows. An end-to-end audit of `ThemedAbilityProgression`, `AbilityList`,
`ItemInfoPopup`, `StatCompare`, stock BardMusic, the corpus, and the live logs
identified the architectural error: the card is a UI-owned synchronous
`RunScript` request/result transaction, not a cached module-export event.
`StatCompare` calls `GetAbilityUpgradeLevelInfo` twice (base and modded), then
immediately consumes `_T.AbilityUpgradeLevelInfo` in the same UI state. The
cached-environment/root-export and active-frame ownership models are retired.
The next implementation job is observation-first recovery of the native
`RunScript` boundary for card result composition, followed separately by an
evidence-backed Mallet damage boundary such as `SetSourceObject`. The audit is
under `DeNativeDecompiler (use this instead of native)/RESEARCH/ABILITY CARD
UI/PIPELINE_AUDIT_2026-08-24`.

## Next job

- [x] Deploy only the newly built single DLL, verify its hash in the game root,
  and identify the exact known-good two-DLL recovery pair.
- [x] Run a live load/login/script smoke test, confirm the exact game-local DLL
  module and absence of the companion, and observe the current replacement and
  Riven paths working.
- [ ] Finish the remaining managed-addon stress cases: activation-failure
  recovery, region transition, one hundred reloads, and native-fault
  containment. Startup, F9 edit, invalid-candidate rollback, recovery of the
  preserved generation, deletion/root release, ordinary one-shot execution,
  focus rearming, and final empty-generation commit are live passes.
- [ ] Live-test SWF replacement, Riven gate off/on, config fallback, and a
  changed loaded full-module replacement applying on its next cast without a
  process restart, including stock restoration when its hash file is removed.
- [x] Live-prove the F9/shared-`_T` addon path end to end: add and activate the
  temporary Mallet callback, observe exactly 30,000 Overguard on cast, remove
  it, commit `addons=0`, and prove the temporary behavior disappeared without
  disturbing the permanent replacement.
- [x] Live-confirmed that direct native Mallet rows appear in the stock bottom
  list after restart. The first custom localization paths rendered raw, so the
  clean candidate now uses literal native labels and a number-free paragraph.
- [ ] Deploy and live-prove the new per-VM F9 queue. Cross-VM contexts are now
  retained and delivered only at their own VM/owner-thread loader boundary;
  newer generations supersede stale pending work, nested loader re-entry is
  blocked, and incomplete cross-VM delivery cannot report a generic PASS.
  Offline replacement/injection/client/build gates pass; the staged DLL is
  documented in `F9_MULTI_VM_REFRESH_2026-08-24.md`.
- [ ] After the generic lifecycle is live-proven, add only evidence-backed
  convenience event APIs and decide whether `TG-006` in-place export tables are
  still needed.

The source implementation phase is complete for these four systems. Runtime
parity remains deliberately open until the user-authorized test phase.
