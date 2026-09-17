# GenericSettings native-dispatch map — 2026-08-27

Scope: determine why the persistent TopMenu `SCRIPTS` row reaches its callback
but does not open `UIMovie_GenericSettings`, then replace only that failed
boundary. The already live-proven per-instance TopMenu row attachment remains
unchanged.

## Observed live boundary

V8 repeatedly logged this exact sequence after the user selected `SCRIPTS`:

```text
RENOVICE Scripts UI row append PASS owner=Initialize.U14.Builder.U58 parent_movie=captured
RENOVICE Scripts settings parent movie PASS source=captured-upvalue
RENOVICE Scripts settings open FAIL reason=PushChildMovie-method
```

This proves the visible row, click callback, owning TopMenu Lua closure, and
captured `mMovie` userdata all succeeded. Failure occurs while resolving the
first engine-object method.

## Hypotheses and results

### H1 — ordinary string `getfield` is equivalent to Luau `NAMECALL`

**FALSE.** V8 called the C-side string-field helper for
`mMovie.PushChildMovie`; it returned no function. The exact current TopMenu
bytecode uses `NAMECALL PushChildMovie` followed by `CALL`, not `GETFIELD`.

The same distinction applies to the child movie's `Execute` method. Treating
the two mechanisms as interchangeable was the direct cause of the dead menu.

### H2 — the current runtime exposes DE's native-name lookup convention

**TRUE.** `push_vm_global` and `push_hashed_table_field` already encode
`wf_hash(name)` in a `LUAU_BOOL`-tagged `TValue` and pass it to
`luau_gettable`. That convention is previously live-proven for current DE
globals by the RunScript observer; the older string-global lookup failed while
the hashed lookup recovered `_T`.

For engine userdata, this hashed key is the native member name expected by the
VM/SWIG dispatch path. V9 therefore resolves `PushChildMovie`, `TOGGLE`, and
`Execute` through one `native_member_value` helper and still supplies the
userdata receiver explicitly to the protected call.

### H3 — a second pause-menu attachment rewrite is required

**FALSE.** The user confirmed the `SCRIPTS` row now survives closing and
reopening Esc, and V8 logs the per-instance U14/Builder/U58 append as PASS.
Changing row ownership again would disturb a solved boundary and would not
address the observed method-resolution failure.

### H4 — the native settings movie provides a stock toggle renderer

**TRUE.** The exact current `ThemedGenericSettings` decompile imports
`Lotus.Interface.Components.ThemedToggle`. When `mType == TOGGLE`, it selects
the `Toggle` clip, creates the themed toggle from `mToggleValues`, applies
`mValue`, and delivers the new boolean to `mCallback`.

The exact Settings caller proves the launch/configuration chain:

```text
mMovie:PushChildMovie(genericSettingsMovie)
child:Execute("SetTitle", ...)
_T.GetSettings = function() ... end
child:Execute("SetElementsFunction", "GetSettings")
```

V9 follows that contract with one row per managed addon/replacement and OFF/ON
boolean options. It does not draw or emulate a toggle itself.

## V9 implementation boundary

- Retained: exact current TopMenu fingerprint, root ownership, per-instance
  revalidation, `Initialize` U14 builder, Builder U58 final dispatch, captured
  TopMenu `mMovie`, and the additive `SCRIPTS` row.
- Replaced: string `getfield` lookups for engine movie members.
- Added: hashed native-member resolution for `PushChildMovie`, child `TOGGLE`,
  and child `Execute`.
- Retained: protected calls, stock `_T` callback-name protocol, exact script
  state policy, and fail-closed stage logging.
- Marker:
  `TOPMENU_HASHED_NATIVE_MEMBER_GENERIC_SETTINGS_TOGGLES_U14_BUILDER_U58_V9`.

## Verification

- Focused Scripts UI suite: **PASS, 46/46**.
- Final clean private x64 build: **PASS, 0 warnings, 0 errors**.
- Final build/source/staging/live SHA-256:
  `284381BB00B51C52650BDA5D2CDE81982B8112183FC44F237D80C12D67DA7C9C`.
- Previous live V8 was preserved as an exact rollback artifact before deploy.
- Live visual acceptance remains required: `SCRIPTS` must open the stock
  GenericSettings child, show native toggle rows, preserve the pause row after
  close/reopen, and persist one OFF/ON change through the established reload.

## Source evidence

- `../TOPMENU_FULL_UI_MAP_2026-08-27/TopMenu.current.decompiled.luau`, lines
  13119–13130: exported `OpenChildMovie` and native `PushChildMovie` namecall.
- `../TOPMENU_FULL_UI_MAP_2026-08-27/TopMenu.current.ir.txt`: current bytecode
  contains `NAMECALL ... :PushChildMovie` and `NAMECALL ... :Execute`.
- `../NATIVE_SETTINGS_TOGGLE_MAP_2026-08-27/decompiled/Lotus_Interface_Settings.lua_B.luau`,
  around 4885–5026: stock GenericSettings launch and callback protocol.
- `../NATIVE_SETTINGS_TOGGLE_MAP_2026-08-27/decompiled/Lotus_Interface_ThemedGenericSettings.lua_B.luau`,
  around 2415–2465: stock `ThemedToggle` row construction.
- `../../../renovice/injection.cpp`: runtime global hashing, hashed field lookup,
  V9 native member bridge, and settings callbacks.

## V9 live result — 2026-08-27

### H5 — a hashed C-side `luau_gettable` reproduces userdata `NAMECALL`

**FALSE.** The user's V9 test still did not open the submenu. The decisive log
sequence was repeated for every click:

```text
RENOVICE Scripts settings parent movie PASS source=captured-upvalue
RENOVICE Scripts settings open FAIL reason=PushChildMovie-native-member
```

The parent movie and common GenericSettings resource were present, but the
hashed lookup still did not produce the userdata method. Therefore a native
name hash is necessary for DE table/global access but is not sufficient to
emulate the VM's engine-userdata NAMECALL instruction. The V9
`native_member_value` route is retired and must not be used as a fallback.

### H6 — actual compiled Luau can cross the movie boundary

**TRUE OFFLINE / PENDING LIVE ACCEPTANCE.** The current Settings and TopMenu
modules prove the native contract is expressed by ordinary DE-Luau bytecode.
V10 compiles a 567-byte internal bridge whose verified Semantic IR contains:

```text
parentMovie:PushChildMovie(settingsResource)
child.TOGGLE
child:Execute("SetTitle", "SCRIPTS")
child:Execute("SetNoElementsMessage", "NO SCRIPTS FOUND")
child:Execute("SetCallBack", doneFunctionName)
child:Execute("SetElementsFunction", elementsFunctionName)
```

The bridge publishes only the Lua closure that must execute NAMECALL. C++
continues to own filesystem policy, row construction, state persistence, and
reload requests. The internal bytecode filename is pinned as
`_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B`; it is always staged by
the injector and deliberately excluded from the player-visible script list.

## V10 verification boundary

- Focused API check: **PASS**, zero contract violations. `PushChildMovie`,
  `Execute`, and `Close` remain unverified by the authoring catalog but are
  exact-stock UI calls in the mapped current modules above.
- DE recompile/reparse: **PASS**, 567 bytes, 3 prototypes.
- DE roundtrip: **PASS**, 3/3 constants and full bodies byte-identical.
- Semantic IR: **PASS**, 3/3 prototypes verified with zero adapter/verifier
  failures.
- Focused Scripts UI suite after the V10 bridge/visibility assertions:
  **PASS, 46/46**.
- Final private V10 DLL: **PASS**, 0 warnings, 0 errors, x64, no legacy
  companion import; SHA-256
  `F5C6DBA4E5AABFC464597F144A508C0ECEFDAA0F29FFAE915C7B65DA448A77E3`.
- Internal bridge SHA-256:
  `C3327AC15CEF19901F52CF627532E6C9ED0481E3BC87188B4DAE6266B78DCA92`.
- Source/staged/live hashes match for both deployed artifacts; V9 rollback was
  preserved and hash-verified.
- Live acceptance requires the child to open, show native OFF/ON rows, apply a
  toggle, and preserve the persistent `SCRIPTS` parent row after closing and
  reopening Esc.

## V10 live result and V11 row-provider repair

### H7 — V10 reaches the stock GenericSettings movie

**TRUE LIVE.** The child opens, the background transition runs, and the screen
renders `SCRIPTS` plus the native Cancel action. The log records
`Scripts settings open PASS`. This excludes TopMenu ownership, parent-movie
capture, `UIMovie_GenericSettings`, and `PushChildMovie` as causes of the empty
screen.

### H8 — the child is empty because script discovery found zero scripts

**FALSE.** The live control inventory contains four replacement scripts and one
target addon. `ScriptStates.json` contains the same five stable IDs. The exact
internal bridge filename is separately excluded by policy.

### H9 — V10's native row provider completed

**FALSE LIVE.** There is no `Scripts settings elements PASS` line between the
opening and closing records. V10 returned silently when its callback boundary
did not meet an assumed exact `LUAU_NUMBER` argument contract. Because the
callback had no entry diagnostics, the precise live tag was not observable.

### V11 repair

V11 makes two coordinated changes without replacing the proven movie path:

1. The compiled bridge invokes the native provider immediately with
   `child.TOGGLE`, verifies that a table was returned, captures that table in a
   Lua closure, and gives GenericSettings the closure name. This removes the
   provider-lifetime/timing ambiguity during the opening transition.
2. C++ accepts the movie's exact non-nil TValue as `mType` instead of inventing
   a numeric ABI requirement. It logs callback entry, argument tag, discovered
   inventory count, every construction failure boundary, and final row count.

The short V10 panel is classified as a consequence of zero rows, not as an
independent scaling defect. GenericSettings computes its body height from the
returned elements; that conclusion must be rechecked only if V11 logs five
rows while the panel remains short.

## V11 live result and V12 exact stock timing

### H10 — `child.TOGGLE` is populated immediately after `PushChildMovie`

**FALSE LIVE.** Five independent V11 clicks produced the same terminal chain:

```text
Scripts settings elements ENTER argc=1 toggle_tag=0
Scripts settings elements FAIL reason=TOGGLE-nil
Scripts settings open FAIL reason=lua-namecall-bridge
```

The parent movie still passed. V11 therefore regressed only because its eager
provider call happened before child initialization.

### H11 — stock Settings reads `child.TOGGLE` eagerly

**FALSE.** Exact current Settings bytecode pushes the child, installs a named
`_T.GetSettings` closure, and reads the captured child's `TOGGLE` field inside
that closure when GenericSettings invokes it later. V12 mirrors that order.

### V12 repair

- Restore the proven deferred Lua provider from V10.
- Retain V11 callback-entry, tag, inventory, and construction-failure logs.
- Distinguish a missing argument (`argc == 0`) from one present argument whose
  TValue tag is nil (`argc == 1`, tag zero). Lua nil is a real argument in this
  stock call shape and is passed through to the row's `mType` field rather than
  rejected by an invented C++ contract.
- Preserve every later non-nil representation unchanged if the initialized
  child exposes one.

Additional exact-current component analysis was stored in
`../GENERIC_SETTINGS_TOGGLE_OWNER_V12_2026-08-27/`. The 87-prototype
`EE.Interface.Components.List` artifact passed plan and Semantic-IR
verification. Rendering the current ThemedGenericSettings module through the
module renderer failed closed with `RENDER_NAME_METADATA_MIXED_NAME`; the
existing verified decompile was therefore used for this timing comparison and
the renderer failure is retained as negative toolchain evidence, not ignored.
