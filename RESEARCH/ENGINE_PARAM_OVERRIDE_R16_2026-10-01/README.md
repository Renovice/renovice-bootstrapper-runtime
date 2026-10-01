# ENGINE_PARAM_OVERRIDE (contract R16, 2026-10-01): level parameters owned at the engine's writer

- **Build:** client 44.0.2 (`2026.09.28.13.06`), `Warframe.x64.exe` `0124f0b9…7d33` (Steam image `00cf8761…` registered
  with the same code), U44 name-hash seed `768e5ed0`.
- **Branch:** `feat/r16-engine-param-override-2026-10-01` from R13 `827027c` (installed DLL `e5d9b61b…`).
- **Research:** `work/research/engine-param-override-2026-10-01/README.md` (writer contract W1-W8, 32 asserted read-only
  checks of the installed executable); R15 classification `work/research/defense-reward-interval-2026-10-01/README.md`.
- **Status:** every build-listed gate PASS, zero-warning private build. **Nothing is live.** Staged
  `work/staging/combined-r16/`. Nothing deployed, nothing pushed.

## Problem

A level ScriptTrigger or encounter parameter (`_scoreGoal=1450`) is written into the script instance's environment by the
engine's parameter writer (apply_param `0x181CAE0`: `getfenv(fn)[hash(name)] = value`), and the engine writes it again on
existing instances (R15). The R10 lane writes the configured value once, at the entry, from the addon; a reader that runs
after a yield of the same instance can see the level value again (EXPOSED rows). Live evidence of the failure shape:
R15 Defense session pid 20920.

## Hypotheses and results

| # | Hypothesis | Result | Evidence |
|---|---|---|---|
| E1 | A native hook on the writer's value push sees every engine write of every parameter, and nothing else. | **TRUE (static)** | push_value `0x191A010` is referenced only by the two CALLs inside apply_param (`0x181CB8C`, `0x181CBBA`), which has four callers (every engine path). Research W1. |
| E2 | The value can be replaced exactly: same call, same arguments, one call, void return, only the pushed number changes. | **TRUE (static + model)** | Signature and void return (W2), float32 number types 0/1 (W3), fixed stack shape (W4). Gate B1/B2/B4: the stock push runs exactly once on every path; one write, to the slot the push created, only if it is a number. |
| E3 | The owning module can be identified without Lua and without retaining Lua objects. | **TRUE (model)** | closure (function slot) `env` == env slot; prototype → stock content key from identities recorded at the natural load / F9 refresh, re-verified per match (GC tag, code pointer, instruction count, bytecode id, FNV-64 of the code). Gate B2: reused address, other bytecode id, other VM, ambiguity, C function, env mismatch all stay stock. |
| E4 | Native + addon on the same value must not both apply. | **TRUE** | Generator harness negative control (scale rows compound). The plan is resolved from the member's delivery and those values are withheld from `context.settings` while the hook is installed (gate C2); without the hook nothing is withheld (C1). |
| E5 | The capability is local: a refused hook, a broken recipe or an overlap affects only the recipe. | **TRUE** | Unregistered digest / byte mismatch → no hook, nothing withheld (D1-D3, C1); broken recipe or wrong hash → recipe REJECT, addon keeps values, package accepted (C4, C5); overlapping (module, parameter) → first package owns, second keeps its value on its addon (C6). |
| E6 | Older DLLs ignore `engine_params.json`. | **TRUE** | R13 (`827027c`) `verify_addon_settings -Package` with the R16 package and the installed values: `ADDON SETTINGS GATES PASS`, no recipe line (staging evidence); the ability editor's `6227cc0` check admits the package too. |

## Design

- `renovice/engine_params_builds.hpp`: per-build registration (digests, detour RVA, seed, layout, 8 exact byte ranges).
  `admit_image` refuses with the exact range's reason.
- `renovice/engine_params_core.hpp` (pure, gate-tested): recipe parser and validation, `override_number` (R10/R11
  arithmetic in float32), plan resolution from the delivery, `withhold`, plan snapshot, identity records, `classify`,
  `module_of`, `apply_pushed`.
- `renovice/engine_params.cpp`: install (startup, only if a package folder holds `engine_params.json`; digest from the
  main.cpp build gate), detour (`armed` fast gate → POD `decide` → one stock push → `apply_pushed`), plan
  publish/prepare/commit/discard, identity recording, bounded diagnostics.
- Integration: `main.cpp` (digest, `initialise()` before `packages::initialise()`); `packages.cpp` (attach, resolve after
  the delivery, conflicts, snapshot lifecycle); `injection.cpp` (`inspect_target_load` hashes the stock key when observing;
  `remember_engine_param_module` after the stock Loader returns and in the F9 refresh, read-only registry lookup).

Rejected: (b) a post-write notification that re-runs the addon's Lua write. It needs a Lua dispatch at an engine-internal
point and still races later writes; (a) is exact and needs no Lua.

## Gates

| Gate | Result |
|---|---|
| `RENOVICE_TOOLCHAIN/engine_params/verify_engine_params.ps1` (new, in the build list) | PASS: 89 checker checks (A pure rules, B hook decision incl. engine re-write order for all R16 rows, C package scan end to end, D the 8 byte ranges against the installed image) + 33 source pins (stock push once, POD across the push, no Lua API/logging in the detour, Diagnostics=false formats nothing, startup/F9/natural-load integration, no target names) |
| `verify_script_packages`, `verify_addon_settings`, `verify_replacement_settings`, `verify_live_literals` (now also build `engine_params.cpp`) | PASS |
| Every other build-listed gate | PASS |
| `build_private.ps1` | PASS, warnings=0 errors=0, DLL `2758b1abf05abb8068d160dd35a5714daaa4fead3b454dd23476448a2a870655` (6,041,088 B) |
| Installed-state replay (R16 package + installed Frost/Octavia + read-only copies of the installed values and ScriptStates) | ADDON SETTINGS GATES PASS, Missions `declarations=495 rejected=0 members_staged=1/1`, `ENGINE PARAMS RECIPE ACCEPT … overrides=7 modules=3 values=6` |

## Limits (exact)

- **Nothing is live.** Pending: `RENOVICE ENGINE PARAMS hook=PASS` at startup, `ENGINE_PARAM MODULE` at the natural load,
  `ENGINE_PARAM APPLY` lines and the gameplay effect (Exterminate x0.1, Interception score x0.5).
- The hook is modelled offline on a byte-exact frame; the DE VM does not run in the gate.
- One build registered (44.0.2). Another build installs nothing.
- A value changed by F9 mid-mission applies at the engine's next write of that parameter (declarations keep
  `applies: next_mission`).
