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

## Current hard boundary

No production custom implementation has been ported yet. The source snapshot's
five submodule directories are empty and the snapshot has no git metadata, so a
reproducible normal-source build is not yet established. Using arbitrary latest
submodules would invalidate the baseline.

## Next job

- [ ] Recover or deliberately establish compatible pinned commits for Pluto,
  Soup, Translations, ee-notation-parser, and warframe-cache-tools.
- [ ] Produce an unedited source build and record compiler, flags, warnings,
  artifact hash, and whether it loads against an isolated test copy.
- [ ] Implement the version-43 compatibility data and root-cause the two
  formerly bypassed mandatory scans.
- [ ] Only after normal source parity, extract `LR-001` through `LI-012` behind
  source feature gates without changing behavior.

The future Hot/addon transaction starts after the existing loader and additive
injector pass source parity; it is not mixed into the first port.
