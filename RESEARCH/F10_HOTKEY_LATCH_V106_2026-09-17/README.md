# V106 process-owned hotkey latch — 2026-09-17

## Reported result

After V105, the user accepted the repaired UI/modding, Mallet and Ice Wave
behavior but reported that F10 no longer loaded the Simulacrum.

## Evidence

V105's live runtime status showed:

- native Application-frame scheduler installed;
- current-U43 frame profile with one exact pattern match;
- first Pluto pass completed;
- UI state captured with a concrete owner thread;
- input filter allowed hotkeys;
- no server script prohibition.

The same session's `EE.log` proves that a Simulacrum request itself still
worked. At 67.470 seconds the game logged
`FrameworkCmd::OpenLevel - /Lotus/Levels/Tenno/SimulacrumEnemySpawnerC.level`,
and at 69.892 seconds it reported a successful connection to that level using
`LotusDangerRoomGameRules`.

Therefore the hypothesis that V105 broke `Engine.OpenLevel`,
`Engine.OpenLevelArgs`, or the Simulacrum paths is false.

## Proven architectural gap

V105 and earlier versions polled configured keys inside
`tick_openwf_scripts_at_native_frame`. The Application detour entered that
function only when all of these were simultaneously true:

1. a captured UI state existed;
2. the Application frame ran on the captured owner thread;
3. the cached UI state passed the idle/base-call-frame checks;
4. the input filter permitted hotkeys;
5. Warframe owned the foreground window.

If the UI VM was transiently non-idle during a valid keypress, the entire key
poll was skipped. A press and release between later safe ticks disappeared.
V105 had no edge/pending/dispatch counters, so the exact rejected predicate for
the user's individual failed press cannot be reconstructed. The source-level
loss window is nevertheless exact and is removed by V106.

## V106 repair

The process-owned Application frame now samples physical key state immediately
after the original game frame returns, before any cached-state or idle check.
It performs no Lua, Pluto, `ivkr_*`, or DE VM work. When focus, input-filter and
server policy permit the edge, it copies the configured script string into a
bounded 64-entry native queue.

The existing owner-thread/global-state/idle-checked Pluto boundary consumes at
most eight queued entries per frame and starts them through the unchanged
`start_script_from_string` path. Physical key state is still updated when
dispatch is blocked, preventing a pre-transition key from remaining logically
held and suppressing the next valid press.

This implementation is universal for every entry in `OpenWF/Hotkeys.json`.
There is no F10-specific native branch and the Simulacrum Pluto script is
unchanged.

The `/status` response now exposes:

- `openwf_hotkey_edges_captured`;
- `openwf_hotkey_scripts_pending`;
- `openwf_hotkey_scripts_dispatched`;
- `openwf_hotkey_edges_dropped`.

## Verification

- Hotkey-latch invariant verifier: PASS.
- Safe-runtime scheduler verifier: PASS.
- Deferred registry-release verifier: PASS.
- Generation ownership and diagnostics lifecycle: PASS.
- Full private x64 build: PASS, zero warnings/errors.
- Candidate SHA-256:
  `2BDF0B9AD026562C1E1EDC369C825CA5209AC5F97C64C2A82F3DC18656D8325D`.
- Candidate size: 4,795,392 bytes.
- Pre-install V105 audit: 33/33 PASS.
- Post-install V106 audit: 33/33 PASS.
- Installed changes: `WTSAPI32.dll` only.
- Exact V105 DLL/config rollback: retained.

## Live gate

From a fresh process, press F10 once in the Orbiter while Warframe is focused.
Success requires a captured edge, a dispatched script, zero dropped edges and
a successful connection to `SimulacrumEnemySpawnerC.level`. Repeated F10 after
returning to the Orbiter is a separate required check. V105's UI, Limbo search,
F9, Mallet and Ice Wave results remain regression gates.
