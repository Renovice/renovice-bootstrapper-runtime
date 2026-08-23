# RENOVICE bootstrapper repository instructions

This folder is the authoritative edited bootstrapper source. Do not modify the
untouched source snapshot, `DLL_builder`, the installed `Warframe` folder, or
deployed DLLs unless the user explicitly authorizes that separate action.

Before changing custom behavior:

1. Run `RENOVICE_MIGRATION/verify_manifest.ps1`.
2. Identify the applicable `feature_id` in
   `RENOVICE_MIGRATION/custom_feature_manifest.tsv`.
3. Preserve its runtime gate and stated negative findings.
4. Add or update a deterministic offline test where possible.
5. Do not mark the feature migrated until its stated parity test passes.

Never delete or simplify custom code merely because it appears experimental.
Scheduler enrollment, Lua registry restoration, VM stack recovery, Scaleform
context invalidation, and cache-size handling have delayed failure modes.

Mandatory game hooks fail closed. Store build-specific signatures, offsets, and
seeds in versioned data. Do not activate an unresolved subsystem through a raw
RVA fallback on an unknown game build.

The OpenWF Pluto VM and the DE gameplay Lua VM are distinct. OpenWF may request
a reload, but DE bytecode registration and generation commit must run through
the captured DE VM at a proven safe point.

F9 reload semantics are intentionally simple: when pressed, read the complete
current Hot directory, stage the complete generation, and atomically commit it
only if every script succeeds. Do not add continuous directory monitoring or
filesystem work to the idle gameplay path.

Do not populate empty submodule directories from unpinned latest branches.
Recover compatible commits or deliberately pin and certify replacements first.
Never commit `OpenWF/cert/key.pem` or other private/local credentials.

The known-good two-DLL deployment remains the recovery baseline until every
required manifest parity row and `TG-001` through `TG-012` pass.
