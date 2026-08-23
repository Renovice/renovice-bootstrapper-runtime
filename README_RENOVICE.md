# Boostrapper Source Edited

This directory is the authoritative development copy for merging the custom
RENOVICE client features into the available OpenWF bootstrapper source and
eventually shipping one source-built `wtsapi32.dll` without a companion DLL.

The untouched inputs remain outside this directory:

- normal source snapshot: `../Warframe bootstrapper source/warframe-dll-senpai`;
- custom proxy source: `../DLL_builder/wf_lua_redirect.cpp`;
- guarded DE-Luau runner: `../DLL_builder/inject_seh.c`;
- currently working binaries and game files: preserved in their existing
  locations and not modified by this repository setup.

## Baseline

The initial copy was made on 2026-08-23. At creation it contained 93 files and
3,455,331 bytes. A relative-path, length, and SHA-256 comparison against the
normal source snapshot found zero differences. The canonical aggregate hash is
recorded in `RENOVICE_MIGRATION/source_provenance.json`; per-file hashes are in
`RENOVICE_MIGRATION/baseline_files.tsv`.

The supplied snapshot has `.gitmodules` but no `.git` metadata and its five
submodule directories are empty. Therefore it is a source snapshot, not yet a
reproducible build checkout. Do not populate those directories from arbitrary
latest branches: recover or establish explicit compatible commits first.

## Preservation rule

No custom subsystem is removed from the working proxy until its row in
`RENOVICE_MIGRATION/custom_feature_manifest.tsv` has passed its stated parity
test in this source tree. Experimental and disabled code is recorded too so it
cannot disappear through an undocumented cleanup.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File RENOVICE_MIGRATION\verify_manifest.ps1
```

This checks manifest structure, unique feature IDs, valid states and risks,
source-file existence, line anchors, migration targets, and required parity
tests. It does not claim that the source tree currently builds or has completed
the migration.

## Target layout

New custom code will live under `renovice/` and use a small host interface so
the proven DE-Luau implementation can be migrated without coupling it to the
OpenWF Pluto VM. The intended modules and sequencing are defined in
`RENOVICE_MIGRATION/SINGLE_DLL_ARCHITECTURE.md`.
