# V75 shared-VM trace bridge ownership

## Hypothesis 1

V74 preserves the selected target's `_T.RENOVICE_TRACE` bridge when another target addon activates in the same VM.

**Result: FALSE live.**

The user completed the requested Ice Wave battle-log test. The live log interval from byte `12,866,605` through byte `12,879,212` proves Ice Wave target-addon activation, later Mallet target-addon activation in the same VM, and later Ice Wave `nativeCalls.SetBaseAmount` plus `nativeCalls.DamageDD` callbacks. The interval contains zero `BATTLE_*` and zero `ICE_WAVE_BASE_CAPTURE` records.

V74 called target-shared-table reconciliation for each target addon. Because Mallet did not match `DiagnosticsTarget=f62b70b45fc7fdf9`, its activation classified the trace bridge as unwanted and removed the VM-wide field that Ice Wave required. The callback therefore received nil `hostTrace`. This is a shared-VM ownership defect, not an Ice Wave damage failure and not an invalid user test.

## Hypothesis 2

An unrelated target activation may preserve a RENOVICE-owned bridge while explicit global reconciliation remains the sole removal owner.

**Result: TRUE offline.**

V75 adds a policy that preserves only when all conditions hold: the call is target activation rather than global reconciliation, bridge installation is allowed, this target is not selected, diagnostics mode is `battle` or `trace`, method/addon filters are empty, and any configured target filter is valid. Explicit reconciliation can still remove the bridge. Diagnostics off and invalid target filters never preserve it.

The deterministic verifier passes these positive and negative boundaries. The runtime adds a one-time direct `RENOVICE target trace callback FAIL` record if a selected callback cannot recover the bridge, so this failure mode cannot silently yield another empty capture.

## Verification

- Migration manifest: PASS, 47 features.
- Dependency pins: PASS, 5 submodules, source commit `756bdc17aa9edf61df8204f901cdfff37b47db57`.
- Full injection core: PASS, including all shared-VM ownership cases.
- Safe runtime tick: PASS.
- Private x64 build: PASS, zero warnings and zero errors.
- Candidate format: x64 PE32+.
- Candidate SHA-256: `712887EF80BB739B3ABADEF06E758A7B942A3227A8513771762B9ED6A8D75C8F`.
- Production policy contains no Ice Wave or Mallet key.
- Package: `RENOVICE_DEPLOYMENTS/BATTLE_TRACE_SHARED_VM_OWNERSHIP_V75_2026-09-14`.
- Runtime-only deployment: PASS at `2026-09-14T20:22:09Z`; installed runtime, unchanged Ice Wave addon, and unchanged battle configuration hashes pass.
- Startup and live battle records: pending restart; next capture begins at byte `12,879,212`.
