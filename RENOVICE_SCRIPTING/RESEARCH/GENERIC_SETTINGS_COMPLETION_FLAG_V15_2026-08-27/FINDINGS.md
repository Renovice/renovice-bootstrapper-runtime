# Generic Settings Completion Flag V15

Date: 2026-08-27

## Live V14 evidence

The native UI and movie-wide value callback both worked:

```text
RENOVICE Scripts settings stage PASS id=target-addon:08faf07b504d058f.malletoverguardandcard.target.addon.lua_b requested=enabled
RENOVICE Scripts settings close PASS action=cancel staged-cleared
```

The player clicked the visible Confirm button. The callback was nevertheless
classified as Cancel, the staged map was cleared, and
`OpenWF/CustomScripts/ScriptStates.json` retained its old modification time
and false value for the target addon.

## Hypothesis: persistence failed inside the JSON writer

**Result: FALSE.**

There was no `commit PASS` or `commit FAIL` line. The code never attempted a
policy write because completion was classified as Cancel. The unchanged file
is downstream evidence, not the cause.

## Hypothesis: the value callback is still unwired

**Result: FALSE.**

Every player switch produced `stage PASS` with the exact stable script ID and
requested boolean. The `SetValueChangedCallBack(mValue, mSetting)` contract is
live-proven.

## Hypothesis: the second SetCallBack argument means confirmed

**Result: FALSE.**

The exact Generic Settings export map shows:

- the Confirm button invokes `FinishSelection`;
- `FinishSelection` calls the internal close path that invokes
  `callback(allElements, nil)`;
- the Cancel button invokes `ExitScreen`;
- `ExitScreen` calls the internal close path that invokes
  `callback(allElements, true)`.

The argument is therefore a cancellation flag. The earlier V14 name and
interpretation were inverted.

## V15 contract

V15 classifies completion with a fail-closed three-way decision:

| Callback shape | Decision | Policy action |
|---|---|---|
| `(allElements, nil)` | Confirm | Atomically persist the staged map and queue one reload. |
| `(allElements, true)` | Cancel | Discard the staged map. |
| Any other arity/type/value | Reject | Discard staged state and log `close FAIL`. |

V15 also logs `completion ENTER` with argument count, flag TValue tag, and the
chosen decision, so future client drift is directly observable.

## Verification

- Focused Scripts UI tests: **PASS, 51 checks**.
- Exact nil-confirm decision: **PASS**.
- Exact true-cancel decision: **PASS**.
- Malformed completion shapes: **PASS, fail closed**.
- Bridge DE byte-exact roundtrip: **PASS**.
- Bridge ownership plan: **PASS**.
- Bridge Semantic IR: **PASS**.
- Focused API checker: **PASS, zero violations**. The catalog still does not
  model `PushChildMovie`, `Execute`, and `Close`; those three known coverage
  gaps are retained and documented.
- Private x64 build: **PASS, zero warnings and zero errors**.

Live V15 persistence acceptance remains required after deployment.
