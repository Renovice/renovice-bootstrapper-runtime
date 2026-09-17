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
| `_T` should be fetched through the current callback state's global pseudo-index and passed as vararg two. | The first revised live addon immediately produced `pcall=2`, `result_tag=6`, matching its explicit missing-`_T` error. The callback state and loader-assigned addon environment are not interchangeable. | **FALSE, LIVE REFUTED** |
| Bare `_T` in the addon resolves the same shared table used by BardMusic. | With no restart, the revised addon loaded through F9, installed `_T.RENOVICE_AFTER_MALLET_CAST`, and the next Mallet cast granted Octavia exactly 30,000 Overguard. | **TRUE, LIVE PROVEN** |
| The previously observed long launch was caused by Inject folder scanning. | `EE.log` showed about 18.49 seconds between input-manager initialization and controller enumeration. The custom hook work was about 0.17 seconds. | **FALSE** |
| Holding F9 repaired the deployed behavior. | The old DLL produced no new reload commit and the client later exited without a GPF, access violation, or crash-dump signature. | **FALSE** |

## Source changes

- F9 consumes both the latched low bit and the current-down high bit from
  `GetAsyncKeyState` and reduces them to one pending transaction.
- A press outside the foreground/policy gate is consumed and cannot trigger
  later after focus transfer.
- F9 is no longer silently suppressed by ordinary menu/gameplay hotkey filters.
- Managed addons and ordinary Inject chunks receive `_G` as vararg 1 for
  compatibility. Addons resolve bare `_T` normally from their loader-assigned
  Warframe closure environment. `_G._T` and a callback-state `_T` are not used
  as substitutes.
- The persistent source log now distinguishes:
  - `F9 QUEUED`;
  - `F9 DRAIN` at a same-VM script boundary;
  - addon load/lifecycle failure with addon and operation;
  - transaction rollback;
  - transaction commit and loaded-module refresh result;
  - successful startup/F9 addon generation and failure count.

## Offline acceptance

- Private x64 build: PASS, 0 warnings, 0 errors, no companion import.
- First diagnostic DLL SHA-256:
  `b4b2ad2d9817dafbb539e065029fdfa15b18d256d087e2078c14244695a2a4a9`.
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

## Live evidence

The first startup attempts failed safely and repeatedly with:

```text
RENOVICE Inject FAIL MalletFlat30000Overguard.addon.lua_B ... pcall=2 result_tag=6 ...
```

After changing only the addon to resolve bare `_T`, the same running client
produced:

```text
RENOVICE F9 QUEUED source=GetAsyncKeyState
RENOVICE F9 DRAIN entered same-VM script boundary
RENOVICE RELOAD PASS trigger=F9 generation=8 addons=1 one_shots=0 one_shot_failures=0
RENOVICE F9 COMMITTED module_refresh=PASS
```

The client remained responsive, the addon callback executed on the next Mallet
cast, and the user observed Octavia receive exactly 30,000 Overguard. This
proves quick F9 delivery, same-VM transaction drain, managed activation, shared
`_T` callback registration, BardMusic dispatch, and the cast callback arguments
for this event. It does not certify unrelated native callback signatures.

## Live cleanup result

The temporary addon was renamed out of the active `.lua_B` set. The same
running client then recorded:

```text
RENOVICE F9 QUEUED source=GetAsyncKeyState
RENOVICE F9 DRAIN entered same-VM script boundary
RENOVICE RELOAD PASS trigger=F9 generation=14 addons=0 one_shots=0 one_shot_failures=0
RENOVICE F9 COMMITTED module_refresh=PASS
```

The user confirmed that the flat 30,000-on-cast behavior disappeared while the
permanent damage-derived Mallet replacement continued to work. Therefore the
complete add, activation, dispatch, cleanup, root release, and empty-generation
publication sequence is a live PASS. Inject was left with zero active
`.lua_B` chunks; the two test files are retained only as `.disabled` recovery
artifacts.

Runtime claims above are limited to the recorded live sequence.

## 2026-09-13 V67 repeated-F9 correction

V66 later reproduced a distinct failure: the first F9 committed, while the
second F9 re-executed the byte-identical internal SCRIPTS bridge and received no
lifecycle table (`pcall=-1 result_tag=8`). F9 detection and same-VM drain both
worked. V67 keeps the complete snapshot and reuses existing managed lifecycle
roots only when managed filenames, bytes, and root ownership all match exactly.
Every managed change still uses the cleanup/activate/release transaction. See
`RENOVICE_SCRIPTING/RESEARCH/F9_UNCHANGED_MANAGED_GENERATION_REUSE_V67_2026-09-13.md`.
