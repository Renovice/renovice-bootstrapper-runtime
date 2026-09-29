# Loadout-order native-hook conflict — 2026-09-27

## Hypothesis / evidence / conclusion
User reproduction: start as Octavia, switch to Frost -> Ice Wave card works but bonus absent; restart initially as Frost -> bonus works.
SUPPORTED static cause capable of producing that order: the preceding Mallet edit declared hooks.nativeCalls.PushFloatArg.before. Current injection.cpp ensure_native_hook_adapters explicitly rejects PushFloatArg in the generic list (reserved-native-adapter-conflict). read_native_call_requests admits the declaration; activation publishes provider roots before adapter commit. native_call_hook_names_requested_locked then unions all active providers, retaining the rejected name. When Frost arrives later, its DamageDD/SetBaseAmount/SetSource plans are rejected with the same union. If Frost arrived first, its process-owned hooks are already installed and remain intact after a later Mallet rejection. Cards use the separate RunScript hook and therefore can still work.
This is a concrete source-level conflict introduced by our Mallet edit, consistent with the user reproduction. No failing-order runtime trace proves it is the only cause. Live switch acceptance remains pending.

## Narrow correction
Use existing hooks.transformFloatArgument(prototype,instruction,stockValue) for Mallet p16/i597: return5 there, stockValue elsewhere. This routes through the dedicated process-owned PushFloatArg adapter. No new runtime system, polling, ability-specific native branch, DLL change, or bytecode swap. Overguard/card source is unchanged. Ice Wave +10 artifact remains unchanged.
Historical V49 documentation advertised nativeCalls.PushFloatArg; the current installed source explicitly forbids it. Current source takes precedence. Earlier U44_AUTHORING claim that the generic declaration is supported is superseded.

## Validation and deployment
Manifest 50 features / 12 targets PASS; pinned dependency check PASS.
Actual authored addon declaration and callback test passes with only AbilitiesLib require stubbed (its gameplay methods are not executed): all six threat values0..5 become5 at p16/i597, four unrelated sites preserve2.5, nativeCalls absent, card/damage callbacks retained. Initial host test could not resolve the game-only require; explicit fixture stub fixes the test environment, not production source.
Canonical source compilation and all14 semantic plans pass. U44 compile reparses; container serialization roundtrip14/14 identical. These do not prove gameplay.
Installed addon hash and rollback: artifacts/deployment.json. Only Mallet file replaced. DLL86f0ef... and IceWave78fe041... verified unchanged. Diagnostics-off config retained.
Restart then test Octavia -> Frost -> Octavia and Frost -> Octavia -> Frost. Verify IceWave cold-stack damage and Mallet Overguard/card/threat separately. Do not claim all loadout lifecycle bugs fixed from compilation.

## Remaining architecture finding
Unsupported reserved declarations are currently rejected after provider publication, allowing one bad request to block later hook-set extension. Correcting the live declaration removes this trigger. Earlier provider-local validation/commit isolation would be a distinct generic hardening change; not implemented or required for this narrow addon repair.
