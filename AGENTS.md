# RENOVICE bootstrapper repository instructions

## Universal-loader invariant

No normal addon may require an ability-specific C++ branch, generated base
script, shim, enabler, or manual bootstrapper edit. Target-specific logic lives
in the addon and its declarative target data. Shared runtime code supplies only
generic VM capture, generation ownership, module/prototype/callsite matching,
native/Lua callback dispatch, lifecycle management, Replacement staging, card
publication, diagnostics, and retirement.

A new capability is accepted only when the base loader survives its failure,
an unsupported provider fails locally with a precise reason, all existing
ordinary-Inject/managed-addon/target-addon/Replacement lanes still pass, and a
second unrelated fixture proves the primitive is reusable. Mallet and Ice Wave
are regression fixtures, never loader architecture.

An optional observer or provider hook must be installed after the mandatory
base path and cleaned up independently. Its create, enable, or runtime failure
must never destroy the module-loader hook, VM capture, Scripts bridge, Inject,
or Replacement. V107 is the canonical rejected counterexample; preserve V108's
capability-local failure boundary.

## User requirements for the addon API (2026-09-07)

- Build a universal raw DE Luau addon API. An authored standalone addon in
  `CustomScripts/Inject` must declare its target and hooks without adding
  ability-specific C++ branches, generated base-script shims, or extra enabler
  scripts. Mallet is a regression fixture, not the runtime architecture.
- The injector loads DE bytecode into the game's DE Luau VM. Pluto is a
  separate subsystem; do not describe it as the injector or conflate its
  scheduler with addon attachment.
- VM internals, closure/prototype ownership, and native call interception are
  explicitly within scope. Investigate and fix them when needed. Generic
  labels such as 'dangerous' or 'unsafe' are not reasons to avoid that work.
  State concrete invariants, evidence, and actual failures instead.
- Add correlated runtime diagnostics before requesting another gameplay test:
  session/build, target, module/prototype registration, matching decision and
  reason, callback installation, callback entry, arguments, dispatch, return,
  and decoded errors. A missing event or early return must be distinguishable
  from successful execution. Bound repeated logging and report suppression.
- Card publication proves only card publication. Addon load proves only load.
  Require callback and in-game effect evidence for gameplay acceptance, and
  another unrelated target before claiming universal runtime validation.
- Preserve the working replacement pipeline and existing usability. Read the
  previous negative findings before proposing another attachment mechanism.

Details: `RENOVICE_SCRIPTING/RESEARCH/UNIVERSAL_ADDON_API_REQUIREMENTS_2026-09-07.md`.

This folder is the authoritative edited bootstrapper source. Do not modify the
untouched source snapshot, the recovery source at
`archive/legacy-runtime/companion-dll-builder`, the installed `Warframe`
folder, or deployed DLLs unless the user explicitly authorizes that separate
action.

Before investigating or changing the current script loader, F9 scheduler,
SCRIPTS menu, replacement refresh, target addons, or search-crash boundary,
read `RENOVICE_SCRIPTING/CURRENT_BOOTSTRAPPER_STATE.md`. It is the dated
operational handoff for the deployed architecture; older V-numbered research
records are evidence, not permission to restore a superseded design.

Before changing custom behavior:

1. Run `RENOVICE_MIGRATION/verify_manifest.ps1`.
2. Run `RENOVICE_MIGRATION/verify_dependencies.ps1`.
3. Identify the applicable `feature_id` in
   `RENOVICE_MIGRATION/custom_feature_manifest.tsv`.
4. Preserve its runtime gate and stated negative findings.
5. Add or update a deterministic offline test where possible.
6. Do not mark the feature migrated until its stated parity test passes.

Never delete or simplify custom code merely because it appears experimental.
Scheduler enrollment, Lua registry restoration, VM stack recovery, Scaleform
context invalidation, and cache-size handling have delayed failure modes.

Mandatory game hooks fail closed. Store build-specific signatures, offsets, and
seeds in versioned data. Do not activate an unresolved subsystem through a raw
RVA fallback on an unknown game build.

The OpenWF Pluto VM and the DE gameplay Lua VM are distinct. OpenWF may request
a reload, but DE bytecode registration and generation commit must run through
the captured DE VM at a proven safe point.

F9 reload semantics are intentionally simple: when pressed, snapshot the
complete current root Replacement files, `Inject` files, and
`ScriptStates.json`; stage one complete generation; validate every member; and
commit atomically only if the entire transaction succeeds. Deletion is part of
the snapshot. Do not add continuous directory monitoring or filesystem work to
the idle gameplay path.

Do not update submodules from branch tips. Their certified pins are in
`RENOVICE_MIGRATION/upstream_submodules.tsv`; any change requires a new
dependency and build certification. Never commit `OpenWF/cert/key.pem` or other
private/local credentials.

The known-good two-DLL deployment remains the recovery baseline until every
required manifest parity row and `TG-001` through `TG-012` pass.
