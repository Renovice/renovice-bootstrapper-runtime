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
- [x] Added atomic F9 refresh of the full-module replacement snapshot. Existing
  cached closures remain old until the next matching module load, which is a
  DE cache/lifetime boundary rather than a partial reload.

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
  changed full-module replacement applying on its next module load.
- [ ] After the generic lifecycle is live-proven, add only evidence-backed
  convenience event APIs and decide whether `TG-006` in-place export tables are
  still needed.

The source implementation phase is complete for these four systems. Runtime
parity remains deliberately open until the user-authorized test phase.
