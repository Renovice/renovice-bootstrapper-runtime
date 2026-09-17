# Event-driven script runtime V18 — 2026-09-02

## Scope

This change removes the unbounded/fabricated discovery paths implicated by the
September 2 crash investigation without removing practical replacement, addon,
startup, F9, or native SCRIPTS-menu behavior.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The injector must search every frame to make scripts work. | Replacement bytecode is selected at the natural DE undump boundary. Target addons are bound to their declared original module and activate after that exact module loads. Explicit F9 requests are drained at an existing script-thread boundary. | **FALSE** |
| A quiet gap between arbitrary bytecode loads identifies a mission/region transition. | The retired implementation observed only `GetTickCount64()` and treated a gap over 1,500 ms as a region. It had no region, mission, level, session, or VM identity. | **FALSE** |
| The process-wide protected-call detour is required for the SCRIPTS menu. | RENOVICE needs the resolved protected-call function only for calls it owns. Exact TopMenu root publication supplies the UI attachment boundary. | **FALSE** |
| Startup plus explicit F9 and exact natural module events preserve practical behavior. | Startup queues one enabled-script generation, F9 rescans/reapplies, replacements still intercept exact original bodies, and target addons still attach when their exact target module loads. | **TRUE, offline verified** |

## Architecture after V18

- `startup_pending` queues one initial generation after initialization.
- F9 remains the explicit whole-folder refresh path.
- The bytecode undump hook still performs exact hash-keyed replacements and
  exact target-module association; it no longer emits timing-based region
  events.
- The VM execute hook publishes the exact TopMenu `(global_state, root_proto)`
  identity. Unrelated returns reject through two atomic pointer comparisons;
  they do not lock the generation table or probe stale environments.
- The process-wide protected-call detour is gone. The resolved function pointer
  remains available only for RENOVICE-owned protected calls.
- Shared `_T` identity needed by target addons is resolved independently of
  diagnostics. The native trace bridge installs only when `Diagnostics=true`.
- `AutoSpawn` remains accepted so old configuration files parse, but it is
  compatibility-only and cannot fabricate a region transition.

## Validation

- SCRIPTS UI core: **62/62 PASS**.
- Injection core: **PASS**.
- API contract and internal bridge compilation: **PASS**.
- Dependency and feature manifests: **PASS** before deployment.
- Private x64 build: **0 warnings, 0 errors**.
- Built/deployed DLL: 4,331,520 bytes,
  SHA-256 `0ea4c125cb34ce8c53d96143a96b1d375b944c4f84960593f6560bc5a25fce8d`.
- Independent deployed PE audit: x64 and no `wtsapi32_owf.dll` import.

## Reversible deployment

The previous live runtime is preserved under
`RENOVICE_DEPLOYMENTS/RUNTIME_EVENT_DRIVEN_V18_2026-09-02`:

- previous DLL SHA-256:
  `797374bbefd0e41a55cbd487c3c0fb521a9ffc1756b5467b25df8cb018362e84`;
- previous config SHA-256:
  `3db70fa9eab8b7d6508602865c7578a6b73ec180b2599ca0f0c867998e1a5b8b`.

The deployed config uses `Logging=true`, `Verbose=false`, `AutoSpawn=false`, and
`Diagnostics=false`.

## Remaining proof boundary

Build, unit, contract, manifest, hash, and PE checks are complete. A fresh game
run must still prove login, opening/closing SCRIPTS, exact addon behavior, F9,
and the former crash searches under the real client.
