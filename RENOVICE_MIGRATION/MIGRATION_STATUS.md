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

## Current hard boundary

The first production slice, U43 compatibility, is ported and offline-verified.
No loader, injection, riven, F9, or addon implementation has been ported yet.
The new DLL has not been deployed or live-tested, so the known-good two-DLL game
installation remains the runtime recovery baseline.

## Next job

- [ ] Run an isolated live load/login/mission smoke test before treating the
  new source-built baseline as runtime-compatible.
- [ ] Port the existing replacement loader (`LR-001` through `LR-012`) behind
  source feature gates, beginning with lookup/read/validation and leaving F9
  transaction work until baseline replacement parity is proven.
- [ ] Then port additive injection (`LI-001` through `LI-012`) without changing
  its existing runtime behavior.

The future Hot/addon transaction starts after the existing loader and additive
injector pass source parity; it is not mixed into the first port.
