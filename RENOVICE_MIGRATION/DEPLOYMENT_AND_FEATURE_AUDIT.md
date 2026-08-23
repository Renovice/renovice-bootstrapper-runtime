# Single-DLL deployment and feature audit

Date: 2026-08-23

## Deployment result

Warframe was not running. Both old root DLLs were absent before deployment.
The final source-built artifact was copied to:

`C:\Users\Bartek\OneDrive\Dokumenter\Warframe\wtsapi32.dll`

Source and destination are byte-identical:

- bytes: `3,998,208`;
- SHA-256: `2bcb2b12d2daf8c307878196bb3f8f4037f265b2b3ce89c69dba5cf9ce8b1c03`;
- PE architecture: x86-64;
- companion import: absent;
- root `wtsapi32_owf.dll`: absent.

The game was subsequently launched. A live process-module inspection found
exactly one game-local custom DLL with the recorded hash, one normal Windows
`System32\wtsapi32.dll` forwarding target, and zero `wtsapi32_owf.dll` modules.

## Recovery result

The deleted game-root pair is still recoverable from the preserved backup:

`C:\Users\Bartek\OneDrive\Dokumenter\Backusp warframe\Warframe 23.08.2026`

- old custom `wtsapi32.dll`: 761,084 bytes,
  SHA-256 `e2148018c863ccac91956e44a45b0b66056e8be6199614f4016d61d89900ca35`;
- old OpenWF `wtsapi32_owf.dll`: 3,866,112 bytes,
  SHA-256 `b8c72cf93d9c84ea58d7595f7ccd93f40c2802086e6bb512f7ef05c5f594acd0`.

No backup file was moved, deleted, or overwritten.

## Installed CustomScripts census

- 4 full DE-Luau replacement `.lua_B` files: validated;
- `riven_lock.cfg`: present;
- `renovice.cfg`: present, with Logging/Verbose/AutoSpawn enabled;
- `Inject` directory: present and empty;
- managed `.addon.lua_B`: 0;
- rejected legacy `.persist`: 0;
- rejected legacy `.spawn`: 0;
- SWF replacements: 0;
- SWF TOC sidecars: 0.

The four replacement bytecode files were not modified. The stale comment in
`renovice.cfg` and the obsolete companion-era `HOW_TO_ADD_SCRIPTS.md` were
updated to describe the new managed-addon and F9 behavior.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| An old custom gameplay subsystem was forgotten. | The 43-row manifest was reconciled against the source port: all 40 parity-required rows are implemented, source-equivalent, or explicitly replaced by a safer mechanism. | **FALSE offline** |
| The old companion-forwarding mechanism is missing. | The OpenWF source and custom systems now coexist in one DLL; imports contain no `wtsapi32_owf.dll`. | **FALSE; intentionally eliminated** |
| Existing hash replacements require renaming. | All four current annotated filenames validate with the deployed custom FNV basis. | **FALSE** |
| Existing Riven lock placement changed. | `riven_lock.cfg` is found at the old path and the feature gate remains presence-based. | **FALSE** |
| Old `.persist`/`.spawn` scheduler behavior is still required. | No active file uses it; its ownership and cleanup were unproven; managed lifecycle records replace it. | **FALSE for current parity** |
| Every feature is proven to work in the running game. | The active replacements and Riven path now have live evidence, but Inject is empty and no SWF fixture exists. | **FALSE; scoped live tests remain** |

## Live smoke result

- The user tested the existing replacement scripts and reported that they work.
- The running process loaded the exact deployed DLL hash and no companion DLL.
- `renovice_source.log` records configuration initialization/reload.
- The log records `Riven stat links wrapped`.
- Four `Riven lock POST accepted` entries confirm live click/request/accepted
  endpoint behavior during this session.
- No RENOVICE `FAULT`, `ROLLBACK`, or `FATAL` entry is present in the source log.

Result: the single-DLL load path, current replacement corpus, configuration,
and exercised Riven path receive a **LIVE SMOKE PASS**. This is not yet a soak
or a pass for systems without installed fixtures.

## Intentional exclusions, not missing gameplay features

- companion DLL forwarding and chain-loading: eliminated by the single-DLL build;
- `.persist` and `.spawn` fabricated scheduler paths: retired and fail-closed;
- scheduler-state polling: debug evidence only;
- one-shot SWF call-stack diagnostics: debug evidence only;
- direct field-memory Riven HTML hook: disproven and deliberately disabled;
- historical `wf_lua_redirect.log` and `wf_swf_probe.log`: retained as old logs,
  while the source port writes `renovice_source.log`.

## Genuine remaining boundaries

- Ordinary injection needs a live fixture because the installed `Inject` folder
  is empty.
- Managed addon activation, cleanup, rollback, F9 replacement, and region
  reapplication need a live fixture.
- SWF hooks are intentionally not installed when there are zero SWF files; a
  live SWF test requires adding a controlled fixture before startup.
- The DE runtime table/function tag discrepancy (`6/7` in restored headers
  versus `7/8` observed by the old injector) remains deliberately tolerant
  until a live diagnostic settles it.
- Stable in-place export-table hot modules (`TG-006`) are a future enhancement,
  not an old custom feature. Full replacements still apply on their next module
  load, while managed addons update on activation/next event.
- Source Lua is not compiled inside the game. Files must still be compiled to
  valid DE-Luau `.lua_B` bytecode before placement.

Conclusion: no active old gameplay feature is statically missing. The loaded
single-DLL path, current replacements, and exercised Riven behavior have passed
a live smoke test. Full runtime parity remains open only for unexercised and
long-duration lifecycle cases listed above.
