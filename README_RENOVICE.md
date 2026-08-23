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

The source export was matched to `Sainan/warframe-dll` commit `756bdc17...`.
Its five exact gitlinks are restored as real submodules and a fresh recursive
clone reproduced every pin. The upstream and build proof is documented in
`RENOVICE_MIGRATION/UPSTREAM_AND_BUILD_BASELINE.md`.

The unedited private MSVC-target baseline and the first edited U43 compatibility
build both complete with zero warning/error lines and produce an x64
`wtsapi32.dll` with no legacy companion import. U43 compatibility is verified
offline against the exact July executable; this is not permission to deploy it
and not yet a live-game parity claim.

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
tests. Check dependency pins with:

```powershell
powershell -ExecutionPolicy Bypass -File RENOVICE_MIGRATION\verify_dependencies.ps1
```

Build the private baseline without deploying it with:

```powershell
powershell -ExecutionPolicy Bypass -File RENOVICE_TOOLCHAIN\build_private.ps1
```

Verify the exact supported U43 client, its native lookups, and all critical
compatibility signatures with:

```powershell
powershell -ExecutionPolicy Bypass -File RENOVICE_TOOLCHAIN\version43\verify_client_43.ps1 `
  -ExePath 'C:\path\to\Warframe.x64.exe'
```

These checks establish the normal-source baseline. They do not claim that the
custom migration or its live-game parity is complete.

## Target layout

New custom code will live under `renovice/` and use a small host interface so
the proven DE-Luau implementation can be migrated without coupling it to the
OpenWF Pluto VM. The intended modules and sequencing are defined in
`RENOVICE_MIGRATION/SINGLE_DLL_ARCHITECTURE.md`.
