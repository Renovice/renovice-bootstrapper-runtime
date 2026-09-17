# Generic Settings Confirm and Script-State Persistence (V14)

Date: 2026-08-27

## Scope

This record explains the two defects observed after the V13 native checkbox
rows became visually correct:

1. Confirm was absent until the first checkbox change.
2. A changed checkbox returned to its prior value after Confirm and reopening
   the SCRIPTS screen.

The authoritative UI body used for this map is:

`RENOVICE_SCRIPTING/RESEARCH/NATIVE_SETTINGS_TOGGLE_MAP_2026-08-27/decompiled/Lotus_Interface_ThemedGenericSettings.lua_B.luau`

## Hypothesis 1: checkbox rows dispatch their per-row `mCallback`

**Result: FALSE for the stock CHECKBOX branch.**

The CHECKBOX renderer assigns `Checkbox.ValueChanged` at decompiled lines
2370-2379. It copies `mChecked` into the row's `mValue`, then invokes the
Generic Settings change handler. It does not call the row's `mCallback` there.

V13 supplied only `mCallback`. Live behavior matched the decompile:

- the X/check visual changed;
- no `RENOVICE Scripts settings toggle PASS/FAIL` line was emitted;
- Confirm closed the form;
- reopening reconstructed the row from the unchanged persisted policy.

This negative result is important: native checkbox rendering and native value
persistence are separate contracts.

## Hypothesis 2: checkbox changes use `SetValueChangedCallBack`

**Result: TRUE.**

The Generic Settings change handler at decompiled lines 1112-1164:

- marks the row `mChanged`;
- activates Confirm;
- resolves the `_T` function name installed by
  `SetValueChangedCallBack`;
- calls that function as `callback(row.mValue, row.mSetting)`.

V14 therefore gives every row an `mSetting` containing its stable RENOVICE
script ID and installs one native `_T` value-change callback. That callback
validates the exact `(boolean, string)` contract and stages the requested
state. It deliberately does not write `ScriptStates.json` or reload at this
point.

## Hypothesis 3: the completion callback distinguishes Confirm from Cancel

**Result: TRUE.**

The close path at decompiled lines 148-239 invokes the function installed by
`SetCallBack` as `callback(allElements, confirmationFlag)`.

- The Confirm path collects the final elements and passes `true`.
- The Cancel/ordinary exit path collects the elements and passes nil/false.

V14 commits only when the second argument is an explicit boolean `true`.
Cancel and malformed callbacks clear the staged map without touching the
policy file.

## Hypothesis 4: `SetConfirmButtonVisibleWhenInactive` is the native API for a
stable Confirm layout

**Result: TRUE.**

The exported function at decompiled lines 5175-5185 parses the string
`"true"` into the flag used by the button redraw path. The redraw logic at
lines 638-653 creates the button when either the form is dirty or the
visible-when-inactive flag is true. It separately calls `SetActive(v33)`, so a
clean form displays an inactive Confirm button and a changed form activates
the same button.

V14 calls:

`child:Execute("SetConfirmButtonVisibleWhenInactive", "true")`

This preserves the native behavior while preventing the layout from gaining a
new button only after the first flip.

## Persistence design

V14 uses a two-phase transaction:

1. `SetValueChangedCallBack` stages `stable script ID -> requested boolean`.
2. `SetCallBack(..., true)` atomically writes all staged requests with one
   `ScriptStates.json` replacement, updates the pending-reload policy, and
   queues exactly one reload.

Flipping a row back to its original value removes it from the staged map.
Multiple changed rows are validated before any file is replaced. This avoids
partial multi-row commits.

## Expected live evidence

On a checkbox flip:

`RENOVICE Scripts settings stage PASS id=<stable-id> requested=<enabled|disabled>`

On Confirm with changes:

`RENOVICE Scripts settings commit PASS changes=<count>`

On Cancel:

`RENOVICE Scripts settings close PASS action=cancel staged-cleared`

On Confirm without changes:

`RENOVICE Scripts settings close PASS action=confirm-no-changes staged-cleared`

Any `stage FAIL` or `commit FAIL` line is a real contract or persistence error
and must not be ignored.

## Verification boundary

Static/private-build verification proves:

- bridge byte-exact de-roundtrip;
- ownership-plan and Semantic IR verification;
- no focused API contract violations (the checker still reports `Close`,
  `Execute`, and `PushChildMovie` as unverified catalog methods; those are an
  already-documented checker coverage limitation, not a runtime warning);
- exact callback argument fail-closed tests;
- 0 compiler warnings and 0 compiler errors.

Only a live game test can prove the engine invokes the callbacks with the
mapped contract and that the reopened checkbox reflects the newly persisted
policy.

## Live correction after V14

**The completion-flag interpretation above was FALSE live and is superseded by
V15.** The value-change path was correct: live logs emitted `stage PASS` for
each flipped checkbox. However, clicking the visible Confirm button produced
the callback shape V14 labeled `cancel`, and `ScriptStates.json` retained its
old timestamp and values.

Re-reading the exported function ownership resolves the ambiguity:

- the button created with callback `FinishSelection` calls the internal close
  path that supplies `(allElements, nil)`;
- the Cancel button created with callback `ExitScreen` calls the internal close
  path that supplies `(allElements, true)`.

Therefore the second argument is a **cancellation flag**, not a confirmation
flag. V15 treats explicit nil as Confirm, explicit boolean true as Cancel, and
rejects every other shape.
