# RENOVICE single-DLL migration architecture

Current deployed implementation and regression boundaries are recorded in
`../RENOVICE_SCRIPTING/CURRENT_BOOTSTRAPPER_STATE.md`. Read that handoff before
using this older migration plan to change runtime behavior.

## Outcome

The final artifact is one source-built `wtsapi32.dll` containing normal OpenWF
behavior and the preserved custom DE-Luau, SWF, Riven, compatibility, and future
Hot-reload subsystems. `wtsapi32_owf.dll` is not loaded or required.

## Separation of responsibilities

```text
OpenWF host/control plane
  - process lifecycle
  - supported-build gate and version data
  - configuration and console
  - hotkey detection
  - server routing and Pluto VM
            |
            | small typed host interface / reload request queue
            v
RENOVICE DE execution plane
  - DE bytecode loader hook
  - replacement map
  - captured DE VM context
  - addon and hot-module generations
  - scheduler integration
  - fault containment
  - DE-thread transaction commit
```

The OpenWF Pluto VM never executes DE ability bytecode. F9 detection may belong
to the OpenWF host, but activation occurs only through the captured DE VM at a
proven safe point.

## Planned source modules

```text
renovice/
  host/
    host_api.hpp
    bootstrap_lifecycle.cpp
  config/
    renovice_config.cpp
  versioning/
    game_symbols.cpp
    game_symbols.hpp
  de_luau/
    loader_hook.cpp
    vm_context.cpp
    fault_guard.c
    module_loader.cpp
    replacements.cpp
    generation.cpp
    addons.cpp
    hot_modules.cpp
    scheduler.cpp
    safe_point.cpp
  reload/
    control.cpp
    transaction.cpp
    status.cpp
  swf/
    decompress_redirect.cpp
    cache_toc.cpp
    parser_overlay.cpp
  riven/
    config.cpp
    click_hook.cpp
    text_wrap.cpp
    redraw.cpp
    server_bridge.cpp
  diagnostics/
    scheduler.cpp
    swf.cpp
```

## Migration order

1. Recover compatible submodule commits and prove the unedited copied source can
   build. Do not use unpinned latest dependencies.
2. Express the old companion compatibility patches as verified source/version
   data and prove the source-built companion against the certified game build.
3. Extract the custom DE-Luau fault guard, loader hook, replacement map, and VM
   capture without changing behavior. Compare logs and live results against the
   known-good proxy.
4. Port SWF and Riven features one manifest row at a time behind reversible
   feature gates.
5. Implement whole-Hot-directory staged generations and rollback on top of the
   parity-proven additive loader.
6. Implement the stable addon dispatcher, hot-module export tables, lifecycle
   cleanup, and replacement-map refresh.
7. Build the unified DLL and run every required parity test.
8. Retire the companion only after packaging, version, server, Lua, Riven, SWF,
   DX11/DX12, reload, rollback, and recovery gates all pass.

## Non-negotiable transaction rule

The active generation is never deactivated before every script in the staging
generation has loaded and initialized successfully. A failed staging generation
is discarded. The old active generation is the rollback; it does not need to be
recreated from disk.

## Replacement limitation

F9 can atomically replace the in-memory hash-to-bytecode map, but it cannot
rewrite arbitrary closures already retained by the game. Addons and managed hot
modules switch immediately through stable dispatch/export tables. Raw stock
module replacements report their truthful boundary: next module load, cast,
spawn, region, or restart depending on DE ownership.
