# Arsenal null-callback crash investigation

Date: 2026-08-24

Crash evidence:

- dump: `C:/Users/Bartek/AppData/Local/Warframe/Crashes/2026.08.24.00.41.52/EE.dmp`;
- process uptime: 88 seconds;
- exception: access violation `0xC0000005`, instruction pointer `0x0`;
- immediate engine instruction: `Warframe.x64+0x197f7e7: call rax`, with
  `RAX=0`;
- every native stack frame below the null target belongs to
  `Warframe.x64.exe`; the custom `wtsapi32.dll` is loaded but is not present on
  the faulting stack;
- EE.log reports the UI chain `ContextAction.lua Update -> ContextAction.lua
  Update -> LoadOutRedux.lua Update -> PostCameraUpdateHud.lua Update`;
- immediately beforehand, the client was leaving an ability preview while
  several untouched ability scripts failed to start for `TennoShipAvatar0`;
  Dagath was merely the last card displayed and is not identified as the
  cause;
- the current RENOVICE session contains startup/region reloads only: no F9
  request, module refresh, or RENOVICE fault at the crash time;
- the installed DLL at the time was the older 4,029,952-byte build, SHA-256
  `B4B2AD2D9817DAFBB539E065029FDFA15B18D256D087E2078C14244695A2A4A9`.

## Hypotheses and results

| Hypothesis | Result | Evidence |
|---|---|---|
| The newly built multi-VM F9 code caused this crash. | **FALSE** | That DLL had not been deployed. |
| An F9 transaction caused this crash. | **FALSE for this session** | No F9/reload entry occurs in the current RENOVICE session. |
| The fault is a null indirect callback in the game engine's Arsenal/UI update path. | **TRUE** | Dump registers and disassembly prove `call rax` with `RAX=0`; EE.log supplies the UI update chain. |
| This is specific to Dagath. | **UNPROVEN and currently disfavored** | Dagath was only the last visible preview. Similar script-start failures appeared across other stock and replacement ability previews, while the faulting chain is shared Arsenal/UI infrastructure. |
| The new Mallet native stat row is the proven source. | **UNPROVEN** | The dump contains no Mallet or custom-DLL frame, and the failure occurs in shared UI update infrastructure. |
| The repeated preview-script errors are harmless. | **UNPROVEN** | They occur across stock scripts, but immediately precede the UI null callback and therefore require a controlled reproduction. |

## Next live gate

Treat this as a shared Arsenal/ability-preview lifecycle defect first. After
deploying the new DLL, exercise a small matrix of untouched and replacement
Warframes: enter the ability view, cycle all four cards, then leave the view,
without pressing F9. Preserve EE.log and the RENOVICE log for each run. Compare
whether the crash follows a particular ability, any preview script-start
failure, repeated card switching, or the common screen-exit transition. Trace
the shared `ContextAction` lifecycle and preview script-start failures before
changing any individual ability, the decompiler, or card-row data.

Debugger outputs are preserved beside the crash dump as `CDB_STACK.txt` and
`CDB_ANALYSIS.txt`.

## Controlled baseline result

After the verified multi-VM DLL and shortened Mallet row were deployed, the
user completed the no-F9 control sequence across Mag, Dagath, and Octavia:
all four ability cards were exercised, each ability screen was exited, and the
Arsenal was closed. The client remained stable.

| Hypothesis | Result | Evidence |
|---|---|---|
| The crash deterministically reproduces from ordinary ability-card navigation. | **FALSE in the controlled run** | The complete untouched/replacement matrix passed without a crash. |
| The original crash was a one-time stale UI/callback state. | **POSSIBLE, not proven** | The original dump proves a null callback, but one failure plus one clean run cannot establish its producer. |
| More speculative code changes are justified now. | **FALSE** | There is no reproducible failing sequence to validate a fix against. |

Status: **monitor only**. Do not add a per-ability workaround or modify the
decompiler for this incident. If it recurs, preserve the new EE.log/dump and
the exact last UI action, then compare both crashes for a shared caller,
object state, timing, and RENOVICE generation history.
