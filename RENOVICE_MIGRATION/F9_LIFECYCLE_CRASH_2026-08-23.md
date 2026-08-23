# F9 managed-addon crash: exact dump diagnosis

## Scope and evidence

The first live managed-addon generation loaded, activated, cleaned, and
reactivated. After generation-two files were staged and F9 was pressed, the
client crashed before a new `RENOVICE RELOAD PASS` was recorded. The two test
files were moved out of the live `Inject` directory immediately; the existing
ability replacements were not changed.

Exact crash artifact:

`%LOCALAPPDATA%\Warframe\Crashes\2026.08.23.18.47.21\EE.dmp`

CDB reports `c0000005` executing address zero. The failing object at
`rbx=0000020bf6ea0f50` has the deployed `luau_State` layout: `outtop` at +0x08,
`intop` at +0x10, `global_state` at +0x18, `ci` at +0x20, `stack_last` at +0x28,
and `stack` at +0x30. Warframe reached `Warframe_x64+0x197f7e7` and called the
current C closure continuation at +0x20; that continuation was null. The caller
is the DE coroutine resume/protected boundary, not the RENOVICE DLL.

## Hypotheses

| Hypothesis | Evidence | Result |
| --- | --- | --- |
| A stock ability replacement caused this crash. | Only the reversible Inject fixtures changed. The exact dump fails while resuming a DE Lua state, and no ability replacement was deployed during the generation swap. | **FALSE** |
| The source executes managed lifecycle calls on the live DE callback state. | `drain` receives the current callback state, but `run_chunk` explicitly ignored it and executed `protected_call` on `manager+0x20`; transaction lifecycle operations used that same captured manager state. | **FALSE before this fix** |
| A captured manager state is always safe to call. | The dump shows a DE state later resumed with status/call-frame state incompatible with a null C continuation. A manager-owned state may be suspended even while another state in the same global VM is the active callback boundary. | **FALSE** |
| The current callback state can own calls while the engine loader still uses its manager. | Registry and globals are shared by states with the same `global_state`. The fix keeps loader ownership unchanged, requires exact global-state identity, and performs all stack, pcall, lifecycle, and registry operations on the current callback state. | **TRUE structurally; live retest required** |

## Source correction

The engine module loader still receives the captured manager and descriptor.
Injected closure execution no longer touches the possibly suspended
`manager+0x20` state. It uses the `luau_State*` supplied by the live
`UpdateFlashMarkers` callback after proving both states share the same
`global_state`. Cross-VM or unreadable states fail closed before staging.

The quarantined generation-two payload remains under
`RENOVICE_LIVE_TESTS/F9_TRANSACTION_2026-08-23/crash_live_payload`; it must not
be restored to the game until the rebuilt DLL passes offline gates and a fresh
generation-one live test.
