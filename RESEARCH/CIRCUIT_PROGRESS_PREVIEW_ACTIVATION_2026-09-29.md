# Circuit Progress Preview X5: why `activate` fails (2026-09-29)

Build: client 44.0.2 (2026.09.28.13.06). Runtime at bootstrapper `bcad39e`.
Addon: `95ef5b82a8400944.CircuitProgressPreviewX5.target.addon.lua_B`, 1,279 B,
SHA-256 `f4e8a45a019cd8e7f99cc22b06ea6cef7dbeda009c257802dc4453c10389aab4`.
Nothing was deployed and nothing was written to the game folder.

## Symptom

`renovice_source.log`, last two sessions: `target module identity PASS
key=95ef5b82a8400944`, then `Inject PASS ... exact_env=1`, then `addon lifecycle
FAIL ... field=activate reason=protected-call-rejected`, `ROLLBACK`, and
`PENDING ABORT`. This happens three times per session: at the loader return, at
the startup RELOAD, and on a retry.

## Hypotheses

| Hypothesis | Evidence | Result |
|---|---|---|
| The U44 port broke the addon bytes (wrong native-name hash or opcode). | The installed file matches the 2026-09-27 staged U44 file exactly. `profile-from-u44` inverts it to the U43 bytes (`8f417dc7...`). `decompile-mod-u44` renders a clean source with only string-class globals and no `HASH_GLOBAL`. The globals it uses are string-keyed in stock on both U43 and U44: the U43 hashes `0x557b8b39` and `0x11d9dfeb` are absent, and the strings are present. | **FALSE** |
| The stock target changed in 44.0.2. | DuviriUtil extracted read-only from the current cache has SHA-256 `cae26c1e...a2e4`, byte-identical to the 2026-09-27 U44 input. It still assigns `ENDLESS_BONUS_STAGE_XP = 50` and `EndlessGetXpForStage` in the root chunk. The body key is still `95ef5b82a8400944`. | **FALSE** |
| The addon cannot see the module's globals because its environment is not the one the module root writes to. | (1) The target addon runs in `closure->env` of the registry closure, recorded at the loader return (`remember_target_module_identity`). (2) TopMenu does not call `module()`, yet in both 44.0.2 sessions its loader-recorded env differs from the env it runs in (`env=...C000` vs `runtime_env=...C0B0`, and `...D8C0` vs `...2660`). The code comment says the root publishes into its own closure environment after startup VM returns. (3) No target addon that passes reads or writes a module-root global in `activate`. The only two that do both fail the same way: this addon and the U43 Mallet `SetThreatLevel` wrapper from 2026-09-11. `SetThreatLevel` is also string-keyed on U43, so the "hashed export" explanation in `EXPORTED_LUA_FUNCTION_HOOKS.md` does not hold. | **TRUE (static and log evidence)** |
| This is a U44 regression. | No log, capture, or deployment record anywhere in the workspace has `TARGET ADDON PASS` for `5384d6f5377f7b27` (U43) or `95ef5b82a8400944`. The 2026-09-12 README left live acceptance PENDING. The same failure class occurred on U43 (Mallet). | **FALSE / UNRESOLVED.** There is no evidence the addon ever activated. |

## Exact error

It cannot be observed. `lifecycle_operation_protected_leaf` calls
`protected_call(state,0,0,0)`. On failure it restores the stack and discards the
error value. `lifecycle_operation` logs only `protected-call-rejected`, so
`Diagnostics=true` does not show the string either.

Inferred error: the first `assert` fails with
`RENOVICE_CIRCUIT_STAGE_XP_GETTER_NOT_FUNCTION`, because `EndlessGetXpForStage`
is nil in the addon environment. Before that assert, `activate` only does two
global reads plus `type`/`assert`, which resolve in target environments (the
passing `missions` addons use them).

## Why no addon-only fix was shipped

- Reading the module table through `require("Lotus.Interface.Libs.DuviriUtil")`
  inside `activate` is unsafe. The first activation runs inside DuviriUtil's
  own natural load, before its root has run. A re-entrant `require` there could
  run the stock root twice, and the second run would overwrite the wrapper. That
  breaks the rule that the stock operation runs the proven number of times.
- `package.loaded` or a global module path is not proven to exist in DE. The
  string `_LOADED` does not appear in the executable.
- Reading the module's root-published state from a target addon therefore needs
  a runtime primitive.

## Required runtime primitive (C++; not implemented here)

1. Generic target-root publication boundary. Activate (or re-activate) a target
   addon at the exact return of its target module's root prototype, in that
   root's runtime `closure->env`. Match by the same VM and root proto, and bind
   per env instance and generation, with cleanup when that instance retires.
   This generalises the existing TopMenu-only `vm-exact-root-return` boundary.
   It needs no Circuit-specific branch.
2. Bounded operational error text for lifecycle failures. Copy the Lua error
   string (truncated) before `restore_lua_top()` and log it with
   `protected-call-rejected`. This is error reporting, not diagnostics.

The existing addon source
(`RENOVICE_DEPLOYMENTS/CIRCUIT_PROGRESS_PREVIEW_X5_2026-09-12/source`) and the
U44 bytes need no change once (1) exists. Its asserts and readback are correct
fail-closed guards.

## Regression gates after the runtime change

- Offline: an injection-core fixture where the loader env differs from the root
  runtime env, and a root-published global is visible only after root return.
- Live: this addon plus one unrelated root-global target (for example a
  `SetThreatLevel`-style export wrapper), checking `TARGET ADDON PASS`.
  Circuit stage preview should read 500/550/625/725/850, with a +250 daily bonus.
