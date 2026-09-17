# GenericSettings TOGGLE ownership and timing — 2026-08-27

## Live observation

V11 called its row provider immediately after `PushChildMovie`. All five live
attempts supplied one argument whose TValue tag was zero (nil), then failed the
V11 non-nil guard. The child did not open. This proves immediate availability
of `child.TOGGLE` is false.

## Exact-current static comparison

- Current Settings bytecode captures the child and reads `child.TOGGLE` inside
  the named `_T.GetSettings` provider, after the provider is installed.
- Current ThemedGenericSettings invokes the named provider during its delayed
  initialization path.
- `EE.Interface.Components.List.lua_B` was independently plan-verified and
  Semantic-IR verified: 87/87 prototypes passed with no adapter or verifier
  failures. Its rendered source is preserved beside this file.

The current ThemedGenericSettings module renderer failed closed with
`RENDER_NAME_METADATA_MIXED_NAME`. That failure is documented here; the
existing exact-current decompile under `NATIVE_SETTINGS_TOGGLE_MAP_2026-08-27`
remains the readable source used for the comparison.

## V12 live result

The deferred provider was invoked and returned all five rows, but its argument
was still nil (`argc=1`, `toggle_tag=0`). The client alternated between white
fallback `OPTION` rows and incomplete black labels/duplicate clips. Therefore:

- provider timing was **not** the remaining defect;
- `child.TOGGLE` becoming valid later was **FALSE LIVE**;
- the five-row C table/array delivery path was **TRUE LIVE**;
- the malformed display was GenericSettings' fallback behavior for an invalid
  `mType`, not evidence that the menu or provider failed to open.

## Exact current enum recovery

The exact current `Lotus_Interface_LotusUtilities.lua_B` was copied from the
shared stock corpus and checked through independent toolchain paths:

- ownership plan: **PASS**, 570/570 prototypes;
- Semantic IR verification: **PASS**, 570/570 prototypes;
- full Semantic-IR module rendering: **FAIL CLOSED** with
  `RENDER_LOOP_PREDICATE_AS_BRANCH` and `RENDER_BLOCK_COVERAGE`;
- native batch module source pass: **PASS**, one file, 570 prototypes, zero
  failures.

The successful batch output preserves the current enum initialization:

```text
SLIDER = 1
CHECKBOX = 2
TOGGLE = 3
BUTTON = 4
TITLE = 5
INPUTBOX = 6
SPACER = 7
INPUTCOUNT = 8
ICONBUTTON = 9
CHOICE = 10
COLOR = 11
IMAGE = 12
CHECKMARK = 13
```

Current `ThemedGenericSettings` independently compares binary rows with
`LotusUtilities.CHECKBOX`, switches the clip to `Checkbox`, and creates
`ThemedCheckbox` directly from `mValue`. Its separate `TOGGLE` branch creates
the arrow-based multi-choice component from `mToggleValues`.

## Corrected conclusion

The decompiled `vT[1].TOGGLE` expression in Settings was an ambiguous alias,
not reliable proof that the pushed child userdata owns the enum. The native
component constants belong to `Lotus.Interface.LotusUtilities`.

V13 resolves `LotusUtilities.CHECKBOX` in compiled Luau, validates that it is a
number, and supplies it to the native row provider. The native boundary also
rejects missing/nonnumeric control types. Rows now match the binary X/check
component shown by stock settings and no longer contain an irrelevant
`mToggleValues` payload.

This is a **specific readability/rendering gap**, not a general failure of the
decompiler: it correctly recovered the menu control flow, provider timing, row
count, enum values through the batch pass, and component branches. The failed
full-module render and the misleading register alias are both retained here as
negative evidence.
