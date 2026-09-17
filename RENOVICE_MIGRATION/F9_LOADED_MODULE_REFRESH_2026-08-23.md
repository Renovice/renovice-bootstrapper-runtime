# F9 loaded-module refresh

Date: 2026-08-23

> 2026-08-24 update: the original same-VM implementation described below was
> insufficient for Arsenal/UI contexts. It has been superseded by the per-VM
> pending-delivery design in `F9_MULTI_VM_REFRESH_2026-08-24.md`. Historical
> live findings remain valid, but the old cross-VM deferral behavior is not the
> current source architecture.
>
> **2026-08-24 retraction:** the statement below that the old implementation
> captured a real module environment was false. Exact-loader disassembly and
> live counters proved descriptor `+0x58` is not consumed by the current U43
> loader. The native loader refreshes existing script objects by original
> descriptor identity. See
> `evidence/U43_NATIVE_MODULE_REFRESH_DISASSEMBLY_2026-08-24.md`.

## Outcome

The failed Mallet addon test separated two previously conflated mechanisms.
F9 successfully committed the managed addon generation, but the running
`BardMusic` module had been cached before its new dispatcher existed. The old
companion source explicitly described full replacements as boot-time/next-load
only, so neither the old nor initial source-built implementation provided DE-
style editing of an already loaded ability.

The source-built bootstrapper now captures the real environment, global-VM
identity, and stock bytecode for every configured replacement when that module
loads. When F9 changes that replacement, the new bytecode is loaded under a
fresh internal identity and its top-level chunk executes in the captured module
environment. Assignments such as `ActivateAbility = ...` therefore update the
function used by the next cast without mutating a closure that is already
running. Deleting the replacement re-executes the captured stock bytecode.

The Mallet dispatcher and its temporary addon now communicate through
Warframe's shared `_T` table rather than a module-local `_G` field. BardMusic
already uses `_T.bardMusic`, making `_T` the evidence-backed cross-module state
surface for this test.

## Hypotheses and results

1. **F9 did not fire. FALSE.** `renovice_source.log` gained a configuration
   reload at the user's keypress and again at subsequent safe boundaries.
2. **The old implementation already hot-swapped cached full replacements.
   FALSE.** `DLL_builder/wf_lua_redirect.cpp` states that Lua replacement is
   boot-time/next-module-load only; generation suffixes were used only for
   injected chunks.
3. **Blindly deleting `_MODULES` is required. FALSE.** Ability chunks assign
   their exported functions into a persistent module environment. Re-executing
   a changed chunk in that exact environment updates future lookups without
   corrupting arbitrary require-cache entries.
4. **A managed addon's `_G` is a proven ability-wide event bus. FALSE.** The
   lifecycle tests proved sharing only among injected chunks. `_T` is the
   game-established shared table used by BardMusic and is used instead.
5. **The add, dispatch, and removal path is live-proven. TRUE FOR THIS EVENT.**
   F9 committed the bare-`_T` addon in the existing process and the next Mallet
   cast granted exactly 30,000 Overguard. A later F9 committed `addons=0`, and
   the user confirmed the flat behavior disappeared while the permanent Mallet
   replacement remained functional. The separate full-replacement constant and
   stock-restoration sequence remains required.

## Safety boundary

- Only modules whose replacement key was configured when they loaded are
  captured, limiting retained stock bytes and environments.
- Execution is allowed only on the same DE `global_state` as the captured
  environment.
- Missing original bytes, null targets, and cross-VM targets fail closed.
- Active casts and yielded loops keep their old closures; refreshed functions
  apply to later engine lookups such as the next cast.
- If immediate execution cannot run, the atomically committed replacement map
  remains authoritative for the next natural module load.

## Offline evidence

- replacement planner tests: replacement update, stock restoration, missing-
  stock rejection, same-VM acceptance, cross-VM rejection, and null rejection
  all pass;
- injection/configuration/SWF/Riven core tests pass;
- Mallet candidate: 23/23 Semantic IR prototypes verified, zero failures, exact
  DE bytecode round-trip;
- addon: four prototypes, exact DE bytecode round-trip;
- private x64 DLL: 4,019,712 bytes, warnings 0, errors 0, no companion import;
- DLL SHA-256:
  `5491daa0216cfd5daf1ce9e89b9f75f07dfe38675b8f4f77657a797495cd840a`.

## Required live sequence

1. Close Warframe and deploy the new DLL, hook-bearing Mallet replacement, and
   `_T`-based temporary addon.
2. Start once, cast Mallet, and confirm immediate 30,000 Overguard plus normal
   Mallet behavior.
3. Remove only the addon and press F9; the next Mallet cast must not grant the
   flat 30,000 Overguard.
4. Restore the addon and press F9; the next cast must grant it again without a
   restart or duplicate callback.
5. Change an observable constant in the already loaded Mallet replacement,
   press F9, and confirm the next cast uses it.
6. Restore the replacement and press F9; confirm stock/certified behavior is
   restored without restarting.
