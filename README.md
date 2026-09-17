# RENOVICE OpenWF Bootstrapper Runtime

This private repository preserves the edited OpenWF bootstrapper source used by
the RENOVICE project. It contains the universal DE Luau addon runtime, native
hook and replacement paths, generation-owned F9 reload machinery, the unified
diagnostics switch, Scripts menu bridge, deterministic native/runtime tests,
and the research needed to understand why the current architecture exists.

The injector and Pluto are separate systems. `CustomScripts/Inject` addons run
as DE bytecode in captured game Lua VMs. Pluto remains the OpenWF control and
UI subsystem. The runtime must not add an ability-specific C++ branch for each
new addon: hooks are declared by standalone addon scripts and dispatched by
the shared target-addon machinery.

## Build and verification

From a PowerShell prompt in this repository:

```powershell
.\RENOVICE_MIGRATION\verify_manifest.ps1
.\RENOVICE_MIGRATION\verify_dependencies.ps1
.\RENOVICE_TOOLCHAIN\build_private.ps1
```

The private build runs the deterministic addon, callback, damage, diagnostics,
generation ownership, Scripts UI, configuration, replacement, and compatibility
checks before linking. A passing build proves source integration and offline
invariants. Live client behavior remains a separate acceptance level and is
recorded in the dated research documents.

## Start here

- `RENOVICE_SCRIPTING/CURRENT_BOOTSTRAPPER_STATE.md` is the current operational
  handoff and supersedes older V-numbered deployment notes.
- `RENOVICE_SCRIPTING/README.md` describes addon authoring and the scripting
  architecture.
- `RENOVICE_SCRIPTING/NATIVE_TARGET_ADDON_HOOKS.md` documents low-level target
  hooks and their evidence boundaries.
- `RENOVICE_SCRIPTING/DIAGNOSTICS_CONFIG.md` documents the master diagnostics
  switch and subordinate channels.
- `RENOVICE_MIGRATION/custom_feature_manifest.tsv` is the feature/gate ledger.
- `AGENTS.md` records the repository invariants future maintainers must keep.

## Repository boundary

The repository intentionally excludes installed game files, TLS private keys,
built DLLs, build caches, crash dumps, transient logs, and the local
`RENOVICE_DEPLOYMENTS` archive. Those deployment transactions remain local
rollback/evidence material and are not source dependencies. The build recreates
generated archive and bytecode artifacts from the checked-in sources and pinned
toolchain dependencies.

No result should be overstated: a card row proves card publication, an addon
load proves registration, a callback record proves dispatch, and only the
observed in-game effect proves live gameplay acceptance.
