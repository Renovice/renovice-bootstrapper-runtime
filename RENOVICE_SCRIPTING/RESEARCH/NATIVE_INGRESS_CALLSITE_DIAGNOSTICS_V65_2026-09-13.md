# V65 native-ingress callsite diagnostics

## Hypothesis

V64 solved the first proven Ice Wave failure by installing all four distinct
`DamageDD` implementations. The live test still dealt stock damage, all four
owned E9 detours remained installed, and the existing exact-callsite trace
contained zero callback events. One of two boundaries is therefore failing:

1. Ice Wave reaches a `DamageDD` implementation that was not present in V64's
   installed binding set; or
2. an installed implementation is entered, but exact target callsite ownership
   fails before the existing trace begins.

## Change

V65 adds `RENOVICE NATIVE_INGRESS` observations before the exact-callsite gate
inside the generic `hooks.nativeCalls` adapter. Selection uses the exact
`DiagnosticsMethod`, requires a valid configured target intent, rejects an addon
filter because provider ownership is not yet known, captures at most eight Luau
frames, and stops after 128 events even if the normal diagnostic budget is
larger. The event records the installed target, trampoline, re-entry state,
resolved callsite, and any published target prototype found in each frame.

This is diagnostics only. It does not change the Frost addon, multiplier, stock
arguments, native results, target ownership rules, replacement path, Pluto, or
the OpenWF server.

## Offline result

All focused injection, configuration, replacement, callback-runtime, Scripts UI,
safe-runtime, dependency, and feature-manifest gates passed. The x64 private
build completed with zero warnings and zero errors.

- V65 candidate: `staging/wtsapi32.v65.dll`
- V65 SHA-256: `0989E64EB330BEBC6BF37A43D3331DC1B0BD44E65279A4C3F232AD36F733F06A`
- V64 rollback: `rollback/wtsapi32.v64.dll`
- V64 SHA-256: `6AD53FC39C58956AD1D20404640C32C327046884F0C35CBA195C7C83286B1A08`
- V64 rejected live evidence: `evidence/v64-live-rejected`

## Live interpretation

After restart, cast Ice Wave through an enemy with ten pre-existing Cold stacks.

- No `NATIVE_INGRESS` line: the live call uses an implementation outside the
  installed registry snapshot.
- `NATIVE_INGRESS` with `resolved_exact=0`: the detour is correct and the frame
  details identify why exact target ownership failed.
- `NATIVE_INGRESS` with target `f62b70b45fc7fdf9`, prototype 7, instruction 64:
  the exact callback path is reached and the later provider/argument trace
  identifies the next boundary.

## Live result

V65 gameplay is **REJECTED**: the user again observed stock Ice Wave damage.
The diagnostic itself succeeded and established the exact failure boundary:

- all observed calls entered installed `DamageDD` slot 2;
- the target module and addon loaded successfully;
- the Lua caller prototype was live-proven child prototype 7 of the exact Ice
  Wave root;
- every entry reported `resolved_target=0`, `resolved_exact=0`, and
  `_identity=missing`;
- the declared `CallInfo` +0x18 `proto` value was actually a program counter
  inside prototype 7, while the declared +0x20 `savedpc` contained the packed
  `nresults`/`flags` tail;
- a width-aware walk maps raw calling word 82 to logical `CALL` 65 immediately
  after catalog `NAMECALL DamageDD` 64.

V66 repairs those three generic runtime boundaries. Evidence is preserved in
`RENOVICE_DEPLOYMENTS/EXACT_CALLINFO_AND_NATIVE_IDENTITY_V66_2026-09-13`.
