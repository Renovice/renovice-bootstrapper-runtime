# F9 input and shared `_T` bridge correction

Date: 2026-08-23

## Goal

Make one F9 press reload the current `CustomScripts` snapshots only when asked,
and make managed addons able to register callbacks in the same Warframe `_T`
table used by full-module replacements. The folder is not watched or rescanned
per frame. A scan is performed only when the queued F9 transaction reaches a
same-VM DE script boundary.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| A quick F9 tap can be missed by the old high-bit-only sampler. | The old path used only `GetAsyncKeyState(VK_F9) & 0x8000`. A new verifier proves that the low latched bit converts a press-and-release between two DE ticks into exactly one request. | **TRUE** |
| F9 should obey the ordinary gameplay/UI input filter. | That filter can be false in menus even though F9 is a developer transaction control. F9 now requires foreground ownership and no server script prohibition, but is independent of the ordinary script-hotkey filter. | **FALSE** |
| The lack of a new `renovice_source.log` configuration line proves the key was never detected. | The deployed DLL logged only successful configuration commits. It did not persist queue, same-VM drain, addon rollback, or activation failure stages. | **FALSE** |
| `global._T` is guaranteed to be the same lookup as the module-global `_T`. | This was assumed by the Mallet addon but not established by the loader ABI. The full Mallet replacement looks up `_T.RENOVICE_AFTER_MALLET_CAST`, while the addon was given only `_G`. | **NOT PROVEN; REMOVED AS AN ASSUMPTION** |
| Passing `_G` and VM-resolved `_T` explicitly breaks older Inject chunks. | Existing chunks that use `local global = ...` consume the first vararg and ignore the second. The managed lifecycle ABI and ordinary one-shot classification remain unchanged. | **FALSE** |
| The previously observed long launch was caused by Inject folder scanning. | `EE.log` showed about 18.49 seconds between input-manager initialization and controller enumeration. The custom hook work was about 0.17 seconds. | **FALSE** |
| Holding F9 repaired the deployed behavior. | The old DLL produced no new reload commit and the client later exited without a GPF, access violation, or crash-dump signature. | **FALSE** |

## Source changes

- F9 consumes both the latched low bit and the current-down high bit from
  `GetAsyncKeyState` and reduces them to one pending transaction.
- A press outside the foreground/policy gate is consumed and cannot trigger
  later after focus transfer.
- F9 is no longer silently suppressed by ordinary menu/gameplay hotkey filters.
- Managed addons and ordinary Inject chunks receive `_G` as vararg 1 and the
  current VM's `_T` as vararg 2.
- The persistent source log now distinguishes:
  - `F9 QUEUED`;
  - `F9 DRAIN` at a same-VM script boundary;
  - addon load/lifecycle failure with addon and operation;
  - transaction rollback;
  - transaction commit and loaded-module refresh result;
  - successful startup/F9 addon generation and failure count.

## Offline acceptance

- Private x64 build: PASS, 0 warnings, 0 errors, no companion import.
- Built DLL SHA-256: `b4b2ad2d9817dafbb539e065029fdfa15b18d256d087e2078c14244695a2a4a9`.
- Injection verifier: PASS, including latched-tap exactly-once and blocked-tap
  non-replay cases.
- Config, replacement, Riven, SWF, and exact installed-U43 client gates: PASS.
- Mallet addon recompiled to 625-byte DE bytecode, reparsed successfully, and
  passed a full-body decompile/recompile identity check.

The earlier combined verifier invocation emitted a Windows `input line is too
long` error because Visual Studio environment initialization was repeated in a
single PowerShell process. The affected SWF and U43 gates were rerun in clean
processes and passed without that runner error. It is not counted as a clean
gate result.

## Live acceptance still required

1. Start with the revised Mallet addon present and verify the persistent
   `RELOAD PASS trigger=startup` line.
2. Cast Mallet and verify the temporary flat 30,000 Overguard callback.
3. Remove the addon, press F9 once, and require `QUEUED`, `DRAIN`, and
   `COMMITTED`; the next Mallet cast must not grant the flat amount.
4. Restore the addon, press F9 once, require the same markers, and verify the
   flat amount returns on the next cast.
5. Remove the temporary addon after the test and F9 once more. The permanent
   damage-derived Mallet replacement remains installed.

This document does not mark runtime parity from offline evidence.
