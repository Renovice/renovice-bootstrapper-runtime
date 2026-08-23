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

## Current hard boundary

No production custom implementation has been ported yet. Dependency recovery
and the offline normal-source build are complete. The new DLL has not been
deployed or live-tested, so the known-good two-DLL game installation remains the
runtime recovery baseline.

## Next job

- [ ] Compare the normal source against the custom proxy by feature family and
  port the version-43 compatibility data first.
- [ ] Root-cause the two
  formerly bypassed mandatory scans.
- [ ] Run an isolated live load/login/mission smoke test before treating the
  new source-built baseline as runtime-compatible.
- [ ] After normal source parity, extract `LR-001` through `LI-012` behind
  source feature gates without changing behavior.

The future Hot/addon transaction starts after the existing loader and additive
injector pass source parity; it is not mixed into the first port.
