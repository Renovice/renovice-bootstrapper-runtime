# TopMenu full UI architecture map — 2026-08-27

## Outcome

The Orbiter `Esc` menu shown in the live screenshots is owned by the captured
`TopMenu` Luau module. It is **not** a hardcoded C++ list.

The module builds a 62-record option tree in Luau, filters it, materializes the
currently selected submenu into row DTOs, and hands those DTOs to DE's native
Flash/List component for rendering.

The failed RENOVICE V4 hook targeted the wrong captured closure:

- configured path: `Initialize.U17 -> Builder.U58`
- actual meaning of `Initialize.U17`: `CreateList`, global prototype 328,
  12 upvalues, max stack 10
- actual builder path: `Initialize.U14 -> BuildMenuOptions.U58`, global
  prototype 295, 59 upvalues, max stack 48

That mistake exactly explains the live failure:

```text
attach FAIL reason=builder-closure-contract ... upvalues=12 stacksize=10
```

The loader reached the correct runtime module and the published `Initialize`
closure. It then rejected `U17` because the code correctly required the
59-upvalue builder contract, while `U17` was the 12-upvalue list constructor.

## Authoritative inputs

| Artifact | Fact |
|---|---|
| `TopMenu.current.lua_B` | Exact runtime-captured current TopMenu; 159,749 bytes |
| Captured SHA-256 | `D3279EE9A715B90BD078D9F614ACC691FD050E957212723541E5C92DD6639D94` |
| `TopMenu.current.decompiled.luau` | Full production-decompiler source; 13,484 lines |
| `TopMenu.current.ir.txt` | DE-aware IR for all 384 prototypes |
| `TopMenu.current.closure-map.tsv` | Generic decompiler closure map: 381 sites, 880 captures, zero failures |
| `TopMenu.current.semantic-verify.txt` | 384/384 prototypes `VERIFIED` |
| `verification.txt` | Machine gate for the map and exact captured hash |

The map is reproducible with:

```powershell
& .\tools\verify_topmenu_map.ps1
```

The verifier requires:

- the exact pinned captured SHA-256;
- 384 parsed prototypes;
- 384 semantic-verifier successes and zero non-`VERIFIED` statuses;
- 62 final menu options;
- 23 `Initialize` upvalues;
- `Initialize.U14 = BuildMenuOptions`;
- `Initialize.U17 = CreateList`;
- module-root `child[132] -> proto[349]` with exactly 23 captures;
- Initialize capture 14 is `VAL:R144` and capture 17 is `VAL:R150`;
- DE parse/re-emit with 384/384 constant pools exact and the full body
  byte-identical.

## End-to-end visible row path

```text
engine/movie loader
  -> module root (global proto 383)
  -> published Initialize (global proto 349)
  -> Initialize.U14 / vT[144]
  -> BuildMenuOptions (global proto 295)
  -> constructs 62 records
  -> assigns mMenuOptions
  -> BuildMenuOptions.U58(mMenuOptions)
  -> state-dependent recursive filter
  -> Initialize.U17 / vT[150]
  -> CreateList (global proto 328)
  -> EE.Interface.Components.List.CreateList(mMovie, "MenuItem")
  -> transition/timer
  -> PopulateVisibleRows / vT[29] (global proto 313)
  -> follows _T.MenuSelectedIndex through the option tree
  -> creates {Name, Icon, Description, CallBack, ...} row DTO
  -> List:AddElement(row, true)
  -> native Flash MenuItem renderer
  -> visible Orbiter Esc row
```

The same sequence is machine-readable in `execution_flow.tsv`.

## Layer ownership

| Layer | Owner | Proven responsibility |
|---|---|---|
| Option definitions | Luau `BuildMenuOptions` | Creates the complete 62-entry tree and each option's conditions/callbacks |
| State filtering | Luau builder U58 and related closures | Removes or nests entries based on UI mode, mission state, platform and feature state |
| Current submenu | Luau `PopulateVisibleRows` | Follows `_T.MenuSelectedIndex` and selects the currently visible records |
| Row DTO | Luau `PopulateVisibleRows` | Copies `Name`, `Description`, `Icon`, callback, enabled state and submenu state |
| List behavior | Luau plus imported List module | Configures focus, press, release and refresh callbacks |
| Final drawing | Native Flash/List/movie implementation | Draws the DTO supplied by Luau |
| Module loading/native calls | C++ engine/bootstrapper boundary | Loads bytecode, exposes VM objects and native movie/List methods |

Conclusion: C++ is part of the rendering and VM boundary, but the missing
`SCRIPTS` definition is not caused by a hidden C++-owned menu array. A row that
never enters `mMenuOptions` cannot be rendered by the native list.

## Key global prototypes

| Role | Global proto | Params | Upvalues | Max stack | Evidence |
|---|---:|---:|---:|---:|---|
| `BuildMenuOptions` / `vT[144]` | 295 | 0 | 59 | 48 | source lines 4923–9134; final IR calls U58 with `mMenuOptions` |
| `PopulateVisibleRows` / `vT[29]` | 313 | 0 | 18 | 20 | source lines 9630–9740; calls `List:AddElement` |
| `CreateList` / `vT[150]` | 328 | 0 | 12 | 10 | source lines 10043–10124; imports List and creates `MenuItem` list |
| `FinishInitialize` | 347 | — | — | — | published at source line 11735 |
| `Initialize` | 349 | 0 | 23 | 18 | source lines 11736–12464 |
| module root | 383 | — | — | — | publishes module globals/callbacks |

All 384 prototype contracts are in `prototypes.tsv`. The full list of 76 root
bindings published by the module is in `published_globals.tsv`, including
`Initialize`, `Update`, `MenuItemFocused`, `MenuItemUnfocused`,
`MenuItemPressed`, `Close`, and raw-input callbacks.

## Exact `Initialize` capture map

Upvalue indexes are zero-based, matching the bootstrapper's closure layout.

| Initialize U | Root closure slot | Known role |
|---:|---:|---|
| 0 | 73 | — |
| 1 | 49 | — |
| 2 | 24 | — |
| 3 | 15 | — |
| 4 | 0 | — |
| 5 | 51 | — |
| 6 | 5 | — |
| 7 | 27 | — |
| 8 | 28 | — |
| 9 | 23 | — |
| 10 | 1 | — |
| 11 | 31 | — |
| 12 | 20 | — |
| 13 | 21 | — |
| **14** | **144** | **BuildMenuOptions, global proto 295** |
| 15 | 55 | — |
| 16 | 65 | — |
| **17** | **150** | **CreateList, global proto 328** |
| 18 | 155 | Transition setup |
| 19 | 33 | — |
| 20 | 40 | — |
| 21 | 77 | — |
| 22 | 18 | — |

The authoritative machine-readable version is `initialize_upvalues.tsv`.

## The 62-option tree

`menu_options.tsv` contains every final record with:

- final one-based array index;
- compiler variable holding the record at insertion time;
- exact name expression;
- exact description expression;
- definition source line;
- insertion source line.

The compiler seeds indexes 1–16 in one literal at source line 6392 and assigns
indexes 17–62 explicitly near the end of the builder. The map snapshots each
record at insertion time because the compiler aggressively reuses `c293v*`
variables.

Important stock positions include:

| Index | Name expression / meaning |
|---:|---|
| 1 | dynamic Mastery Rank Up label |
| 3 | `ResumeGameUpperCase` |
| 5 | Challenges |
| 6 | Abilities |
| 7 | Melee Combos |
| 8 | Navigation / Star Chart |
| 17 | Equipment / Loadout |
| 18 | Operator |
| 23 | Market |
| 24 | Communication |
| 25 | Quests |
| 26 | Railjack |
| 29 | Profile |
| 30 | Options |
| 38 | Abort Mission |
| 45–46 | Simulacrum exit variants |
| 52–55 | Quit Game variants |
| 56 | `SIMULACRUM [TEST]` |
| 57 | `UI Tools [TEST]` |
| 60 | `SQUAD LINK DEBUG MENU` |
| 61 | `TERMINATE SQUAD LINK` |
| 62 | `CHEAT MENU [DEV MODE]` |

Many definitions do not appear simultaneously. Their `DisplayIn`,
`ShouldDisplay`, platform and state predicates determine which stock rows
survive the builder's filtering pass.

## Why the previous hook produced no row

### Expected V4 logic

The V4 implementation:

1. captured the exact TopMenu body key;
2. observed its runtime root execution;
3. obtained the exact module environment;
4. found the published Lua `Initialize` closure;
5. read `Initialize.U17` as the presumed builder;
6. required that closure to have the builder's 59-upvalue contract;
7. failed closed when it actually found a 12-upvalue closure.

### Live evidence

The log recorded:

```text
RENOVICE Scripts UI architecture=TOPMENU_RUNTIME_ROOT_PROTO_ENV_INITIALIZE_U17_BUILDER_U58_V4
RENOVICE Scripts UI VM runtime root ENTER ...
RENOVICE Scripts UI attach FAIL reason=builder-closure-contract ... upvalues=12 stacksize=10 ...
RENOVICE Scripts UI VM runtime root RESULT FAIL ...
```

The static map independently identifies global proto 328 as exactly
`upvalues=12 stacksize=10`, and `Initialize.U17` captures root slot 150, which
is `CreateList`. Static and live evidence therefore agree.

The original index error came from reading a raw `NEWCLOSURE` operand as a
global prototype index. In DE Luau, that operand indexes the current
prototype's **child list**. It is not the flat global-prototype number printed
by the IR inventory. Closure fingerprints and the parent/child capture stream
must be resolved together. Treating child slot 132 as global proto 132 pointed
at an unrelated confirmation helper and corrupted the ownership map. The V5
map keeps child slots, root closure slots, Initialize upvalues, and global
prototype indexes as separate columns.

### Verdict

The failure is **not** evidence that TopMenu is C++-owned and **not** evidence
that the updated game ignores all custom Lua. It is a deterministic closure
indexing bug in our V4 hook.

## Hypothesis ledger

| Hypothesis | Evidence | Result |
|---|---|---|
| The visible Orbiter Esc entries are a hardcoded C++ array | 62 records are constructed in Luau and passed to `List:AddElement` | **FALSE** |
| Native code participates in final rendering | Luau imports `EE.Interface.Components.List`, creates `MenuItem`, and calls native movie/list methods | **TRUE** |
| The runtime loader never reached the current TopMenu | exact body dump, root `ENTER`, exact VM/environment and subsequent closure-contract failure | **FALSE** |
| Published `Initialize` was not a Lua function | V4 passed the `Initialize` shape and 23-upvalue checks before reaching its child closure | **FALSE for V4** |
| `Initialize.U17` is `BuildMenuOptions` | U17 captures `vT[150]`; live shape is 12/10; source identifies it as `CreateList` | **FALSE** |
| `Initialize.U14` is `BuildMenuOptions` | U14 captures `vT[144]`; global proto 295 has the exact 59-upvalue builder contract and 62-row body | **TRUE** |
| Builder U58 receives the completed menu table | final builder IR loads U58, loads `mMenuOptions`, and calls it with one argument | **TRUE** |
| A wrapper at builder U58 can add a top-level record before stock filtering | U58 is called immediately after final array publication; wrapper can append then forward stock call | **TRUE at the Luau contract level; live patch not yet rerun** |
| Our general Luau decompiler cannot represent this module | production `decompile-mod` emitted full readable source and it recompiles/reparses | **FALSE** |
| The decompiled source is automatically byte-identical after source rebuild | source rebuild has 381 reachable prototypes while capture has 384 including 3 orphan prototypes | **FALSE** |

## Decompiler and tool-boundary findings

Positive findings:

- `de-roundtrip` parses and re-emits the exact DE format byte-for-byte:
  384/384 constant pools exact and full body identical.
- DE-aware Semantic IR verifies all 384 prototypes.
- `decompile-mod` resolves the live closure tree and produces a full readable
  source module.
- `closure-map` emits all 381 closure edges and 880 capture descriptors with
  zero unresolved or invalid contracts. This is now the machine authority for
  child/constant/global prototype namespaces and runtime upvalue ownership.
- the readable source recompiles to DE bytecode and reparses.

Negative findings that must not be hidden:

- the source-level module renderer fails closed on the three orphan prototypes
  with `RENDER_ORPHAN_PROTOTYPE_PENDING`; it does not silently discard them.
- the capture contains 384 prototypes, of which 381 are reachable from the
  module root and 3 are orphans: 115, 116 and 117.
- generic Lua `dump`/`lbc-cmp` paths reject DE's extended constant tag 19.
  Those are the wrong parsers for a DE `09 03` file and cannot be used as
  evidence against the DE-aware pipeline.
- a source recompile is therefore not claimed to be byte-identical to the
  captured module. Runtime replacement acceptance still requires the full
  DE-specific semantic/gate suite.

## Correct implementation target

The minimum additive hook is now precisely defined:

```text
published TopMenu Initialize
  -> validate Initialize: Lua, 23 upvalues
  -> take Initialize.U14
  -> validate BuildMenuOptions: Lua, 59 upvalues, max stack 48
  -> take BuildMenuOptions.U58
  -> wrap U58 with one native upvalue containing the original dispatch/filter
  -> on call(menuOptions): append one top-level SCRIPTS record
  -> always forward original U58(menuOptions)
```

The wrapper must fail closed: inability to append must still forward the stock
U58 call so the vanilla pause menu remains intact.

Before another live test, the build/staging gates must prove:

1. architecture marker says `INITIALIZE_U14_BUILDER_U58`;
2. source and verifier both require U14, not U17;
3. attach log reports builder `upvalues=59 stacksize=48`;
4. `row append PASS` occurs exactly once for the TopMenu instance;
5. stock U58 forwarding succeeds;
6. opening and closing the pause menu repeatedly does not duplicate `SCRIPTS`;
7. a deliberately forced append failure preserves every stock row;
8. clicking `SCRIPTS` opens its native submenu and Back returns safely.

## Post-map implementation status

After the map and its verifier passed, the source ownership constant was
changed from U17 to U14 and the architecture marker was advanced to:

```text
TOPMENU_RUNTIME_ROOT_PROTO_ENV_INITIALIZE_U14_BUILDER_U58_V5
```

The current Scripts UI verifier now runs against this exact captured TopMenu,
not the older shared-corpus copy. Results:

- TopMenu map gate: PASS;
- Scripts UI core: 34/34 PASS;
- private DLL build: warnings 0, errors 0, x64 yes;
- current Amir Shockwave client compatibility scan: PASS;
- staged DLL SHA-256:
  `759186fe0f30f0a4a404861b9f20f35c340011df39a8311b1783f96c5ab8c737`.

The staged V5 artifact is in
`RENOVICE_DEPLOYMENTS/NATIVE_SCRIPTS_MENU_U14_V5_2026-08-27/`.

No DLL was deployed while producing this map and corrected staged build.

## Live closeout

The corrected build was subsequently deployed and accepted in game. The live
Orbiter pause menu retained its stock entries and displayed one `SCRIPTS` row
after `EXIT GAME`. The accepted V5 log session recorded:

- exact architecture marker;
- exact TopMenu identity PASS;
- runtime root ENTER and RESULT PASS;
- `Initialize.U14.Builder.U58` attach PASS;
- row append PASS;
- six toggle PASS events spanning target addons and replacements;
- zero Scripts UI failures.

This changes the hypothesis “a wrapper at builder U58 can add a top-level
record before stock filtering” from contract-level proof to **live TRUE**.
Evidence is preserved in
`RENOVICE_DEPLOYMENTS/NATIVE_SCRIPTS_MENU_U14_V5_2026-08-27/evidence/`.
