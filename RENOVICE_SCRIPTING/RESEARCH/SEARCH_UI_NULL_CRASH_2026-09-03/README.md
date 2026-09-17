# Search UI null-continuation crash — 2026-09-03

## Reproduction

- Exact or narrow searches can briefly show a black modal tint.
- The latest fatal reproduction occurred in the Simulacrum enemy picker after
  entering `00`.
- Similar brief tints were observed while searching for Warframes such as
  `Limbo` without every occurrence becoming fatal.

## Evidence

- `EE.log` completed the enemy grid and resource loads normally.
- Immediately before the fault, stock `ThemedContextMenu.lua` and
  `PlayerScript.lua` opened four `ThemedGenericSettings` movies. The black image
  is consistent with their modal backdrop.
- The hard logger captured `0xC0000005`, operation `8`, at address zero.
- The immediate Luau return address was
  `Warframe.x64.exe+0x19815C9`, identical to the earlier Arsenal search crash
  family.
- The active C closure was `Warframe.x64.exe+0x197DCC0` with `c.cont=0`.
- The current add-on source log records no RENOVICE callback at the fatal point.

## Hypotheses and results

### Bad enemy or Warframe data

**Result: false at the observed boundary.** Resource loading completed, and the
same symptom spans unrelated selectors and search strings.

### An individual injected/replacement Lua script

**Result: false for the captured reproduction.** The runtime source log ends
without any add-on/replacement execution at the crash.

### The SCRIPTS settings callback remained open

**Result: false for the direct callback path.** Its last source-side lifecycle
completed and cleared normally. The four fatal opens came later from stock
`ThemedContextMenu` and `PlayerScript` callers.

### Reintroduced `UpdateFlashMarkers` detour

**Result: supported strongly; live V30 confirmation pending.** The previous V23
isolation proved the same null-continuation crash stopped when
`UpdateFlashMarkers` remained completely stock. V27 later added a narrower code
detour to that same native function for F9/Confirm draining. The current crash
sessions log that detour as enabled; earlier safe-boundary sessions do not.

## V30 correction

- Remove the `UpdateFlashMarkers` code detour completely.
- Keep its method-table entry and native body stock.
- Keep the existing outer-VM-return scheduler, F9 poll, SCRIPTS UI, RunScript
  observer, arbitrary script loader, replacements, target add-ons, and Mallet
  behavior unchanged.
- Let an explicit pending F9/Confirm request bypass only the ordinary 8 ms safe
  scheduler throttle. This addresses the V26 quiet-UI starvation without using
  a HUD/gameplay method as a clock.

Offline validation and deployment details are in
`RENOVICE_DEPLOYMENTS/SEARCH_UI_STOCK_HUD_BOUNDARY_V30_2026-09-03/`.

## V30 live result and V31 follow-up

- **Search-crash hypothesis result: true.** The user reported that the V30
  build no longer crashes in the reproduced search flow. The stock-HUD boundary
  must remain preserved.
- **Live enable result: pass.** An OFF replacement could be enabled and its F9
  transaction drained and committed in the same session.
- **Live disable result: fail in V30.** The OFF policy persisted, but the log
  stopped after `reload QUEUED` and never entered `F9 DRAIN`; restart then
  applied the already-saved policy.
- **Scheduling cause:** a settings completion can queue work during an active
  general runtime tick. Nested VM returns must stay non-reentrant, so V31 adds
  one bounded follow-up pass after that callback unwinds. It does not add a new
  UI/HUD hook or special-case any script.

Offline validation and deployment details for that correction are in
`RENOVICE_DEPLOYMENTS/LIVE_DISABLE_FOLLOWUP_V31_2026-09-03/`.
