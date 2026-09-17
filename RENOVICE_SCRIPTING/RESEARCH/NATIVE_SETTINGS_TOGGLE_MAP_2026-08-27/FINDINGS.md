# Native settings toggle map — 2026-08-27

Scope: exact current client bytecode copied into `corpus/`, decompiled into
`decompiled/`, and read-only comparison with the bootstrapper's TopMenu hook.

## Hypotheses and results

### H1 — TopMenu child rows can become native settings controls through label markup

**FALSE.** The V6 live screenshot rendered the complete `TEXTFORMAT` payload as
literal text. Exact TopMenu decompilation shows that submenu children are plain
localized action rows. They do not expose the settings row `mType` contract and
cannot instantiate `ThemedToggle`.

Consequence: all selector markup was removed. The V7 DLL contains no
`TEXTFORMAT TABSTOPS` string.

### H2 — the pause-menu `SCRIPTS` entry can open Warframe's stock settings movie

**TRUE.** The exact Settings caller opens `genericSettingsMovie` with
`mMovie:PushChildMovie(...)`, configures it with `SetTitle`, installs functions
in `_T`, and passes their names through `SetCallBack` and
`SetElementsFunction`. V7 follows that same ownership and callback sequence from
the TopMenu row's `CallBack`.

Evidence:

- `decompiled/Lotus_Interface_Settings.lua_B.luau`, around lines 8571–8582:
  `PushChildMovie` followed by `SetTitle`.
- The same file, around lines 8707–8712: `_T.GetSettings` followed by
  `SetElementsFunction`.
- `_G.UIMovie_GenericSettings` is the common UI resource used by V7 so the
  bootstrapper does not invent or hard-code a package path.

### H3 — `ThemedGenericSettings` has a real native toggle row contract

**TRUE.** Its current decompilation imports
`Lotus.Interface.Components.ThemedToggle`. For `mType == TOGGLE`, it changes the
row clip to `Toggle`, constructs `ThemedToggle.Create(...)` from
`mToggleValues`, and applies `mValue` with `SetIndexByValue`.

The accepted row shape is:

```text
{
  mLabel = string,
  mRawName = string,
  mType = settingsMovie.TOGGLE,
  mValue = boolean,
  mToggleValues = {
    { Label = "OFF", Value = false },
    { Label = "ON",  Value = true  }
  },
  mWrapAround = true,
  mLocked = boolean,
  mCallback = function(newBoolean) ... end
}
```

Evidence:

- `decompiled/Lotus_Interface_ThemedGenericSettings.lua_B.luau`, lines 18–22:
  the component import.
- The same file, around lines 2415–2465: TOGGLE branch, Toggle clip,
  `ThemedToggle.Create`, and `SetIndexByValue`.
- The same file, lines 1171–1178: the selected value is written to `mValue`
  and delivered to `mCallback(newValue)`.
- `decompiled/Lotus_Interface_Settings.lua_B.luau`, around lines 8638–8654:
  stock boolean `Label`/`Value` records and a row using the child movie's
  `TOGGLE` enum.

### H4 — the old text submenu can remain as a fallback

**FALSE.** Keeping it would preserve a proven-broken UI path and could make a
native settings failure look superficially successful. V7 fails closed and
logs the exact failed stage instead: parent movie, GenericSettings resource,
PushChildMovie method, TOGGLE enum, `_T`, movie configuration, or callback.

### H5 — a new C callback can resolve TopMenu's module-local `mMovie` as a global

**FALSE.** V7's row was visible and focusable, and every click reached the C
callback, but the runtime log repeatedly recorded
`RENOVICE Scripts settings open FAIL reason=parent-mMovie`. Therefore the
failure occurred before GenericSettings lookup or `PushChildMovie`.

V8 obtains the original Lua dispatch closure from the already-pinned U58
wrapper, validates its environment, reads `mMovie` from that exact environment,
validates the value as userdata, and captures the movie as a strong callback
upvalue. The click callback consumes the upvalue instead of repeating a global
lookup. If any ownership/type check fails, the SCRIPTS row is not published.

## V7 implementation

The pause list still receives exactly one additional action row named
`SCRIPTS`; no stock rows are removed or replaced. Activating it opens
`UIMovie_GenericSettings`. The element provider creates one native `TOGGLE` row
per valid addon/replacement snapshot. A row callback persists the requested
state using the existing script-control policy and queues the established
reload path.

V8 additionally captures the exact TopMenu `mMovie` userdata at row-construction
time so the later C callback has the same effective ownership as a lexical Luau
closure.

The earlier per-instance TopMenu repair remains active: every exact TopMenu
runtime root is revalidated, so reopening Esc is not suppressed by a stale
process-lifetime `pause_attached` flag.

## Verification boundary

- Static/unit verification: **PASS**, 44/44 checks.
- Private x64 build: **PASS**, 0 warnings and 0 errors.
- Built artifact marker:
  `TOPMENU_CAPTURED_MOVIE_TO_GENERIC_SETTINGS_TOGGLES_U14_BUILDER_U58_V8`.
- Built artifact SHA-256:
  `c61a37fc55d3e160849638b03c0557dd91f9933b0f87bbe81a941290e41cf56c`.
- Live visual toggle acceptance: pending the next in-game test.

## V8 live result and V9 handoff

The V8 visual test did **not** open the settings child. It did, however, prove
the new ownership boundary: the row remained present after reopening Esc, the
click reached the native callback, and the captured parent movie passed its
userdata check. The exact terminal record was
`FAIL reason=PushChildMovie-method`.

Fresh current-bytecode mapping established that vanilla uses Luau `NAMECALL`
for `PushChildMovie` and `Execute`, while V8 used ordinary string `getfield`.
That equivalence hypothesis is false. The replacement hashed native-member
bridge and its evidence are documented in
`../GENERIC_SETTINGS_NATIVE_DISPATCH_MAP_2026-08-27/FINDINGS.md`.

## V9 rejection and V10 handoff

The subsequent V9 hashed-member hypothesis is also **FALSE LIVE**. Hashed
`luau_gettable` successfully models DE's table/global key convention, but it
still did not resolve `PushChildMovie` on the engine movie userdata. V10 now
uses a compiled internal Luau closure so the VM itself executes the stock
NAMECALL/Execute/TOGGLE sequence. Full negative evidence and the V10 contract
are recorded in
`../GENERIC_SETTINGS_NATIVE_DISPATCH_MAP_2026-08-27/FINDINGS.md`.
