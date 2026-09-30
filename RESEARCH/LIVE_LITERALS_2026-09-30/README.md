# Typeable script-literal values: host-side replacement synthesis (LIVE_LITERALS_V1, 2026-09-30)

- Branch: `feat/live-literals-2026-09-30`, from `feat/replacement-settings-2026-09-30` at `b5a120b` (contains Settings R5 and
  REPLACEMENT_SETTINGS_V1).
- Client: 44.0.2 (`2026.09.28.13.06`). Contract: `work/research/universal-mission-editor-2026-09-29/CONTRACT_PHASE1.md`
  Revision R8 (R5-L and R5-C).
- Producer: ability-editor `feat/live-literals-recipes-2026-09-30` (from `4511059`), record
  `RESEARCH/MISSION_LIVE_LITERALS_R8_2026-09-30.md`.
- Scope: repository only. Nothing was deployed or pushed; no game, OpenWF server or `renovice.cfg` file was written.
- Status: offline gates and the zero-warning private build **PASS**. **Every live check is pending.**

## Requirement

The headline mission values that are fixed numbers in script code (Mobile Defense terminal time, Excavation dig time, Control
Area hold time, Void Flood fractures, Defense intermission, Disruption round timers, Mirror Defense phase timer, Lantern timers,
Purgatory start time, Capture downed timers, Defection squads, Hijack payload, Hack-station timers, Netracell power, Archimedea
values, ...) could only be baked into an exact replacement at build time, so SCRIPT SETTINGS showed them read-only. They must be
typeable in game, for every mission module, without a decompile/recompile (REPLACEMENT_SETTINGS_V1 needs a faithful full
recompile, which only 13 of 50 mission modules pass today).

## Hypotheses and results

| # | Hypothesis | Evidence | Result |
|---|---|---|---|
| L1 | The replacement bytes of a literal edit are a pure function of the stock bytes, the registrar's per-site preimages and the value, so the host can build them at apply time. | The generator's exact-literal builder only rewrites LOADN operands / f64 constants at registered offsets after verifying the preimages, then checks that no other byte changed. Moved into the shared core `renovice/live_literal_patch_core.hpp` (byte-identical in the generator, SHA-256 `b933c7c7…`); the generator's baked package rebuilt through the core is byte-identical to the staged `missions-full-package` (7 files and the values file). | **TRUE (gate).** |
| L2 | Host synthesis from the recipe reproduces the generator's baked output exactly. | `verify_live_literals` synthesizes Mobile Defense 20 s, Void Flood 4, Excavation 50 s, Control Area 30 s (Plains and Cambion) from the real U44 stock corpus + the generated recipe: all five equal the staged baked replacements byte for byte (SHA-256 pinned: `fff653e0…`, `e979f5e7…`, `66b4f934…`, `e2e8bb2f…`, `f0436757…`). | **TRUE (gate).** |
| L3 | The stock bytes the host needs are available at every apply point. | At the natural load the undump detour receives the stock body of exactly the module being loaded (`body_key` = content key); `begin_module_load` already captures stock bytes and loader context for every "available" key, and recipe keys are made available at startup and every F9. A loaded module is refreshed on F9 from the captured stock; an unloaded one is synthesized at its next natural load. | **TRUE (source).** Live pending. |
| L4 | An older DLL keeps the package valid and the recipe values inert. | Packages ignore every non-`lua_B` file except `package.json`; the recipe values are declared only in `literals.json`. The base bootstrapper `b5a120b` (git archive) admits the generated recipe package: `PACKAGE ACCEPT … members=1 replacements=0 target_addons=1 target_keys=23` and `ADDON SETTINGS GATES PASS` with its values file (recipe ids are unknown entries: ignored). | **TRUE (gate, old revision).** |
| L5 | R5-C: an addon bound to a module keeps working when the module is synthesized. | `inspect_target_load` hashes the descriptor (stock) body before `begin_module_load` and before the stock Loader undumps, so the target key stays the stock key; `remember_target_module_identity` records the prototype graph of the closure actually loaded (post-load). A literal patch changes only operand/constant bytes, never prototype count, order, code size or upvalues, so the addon's `luaCalls[P]` indices and root-table hook plans stay valid. A VM-local F9 refresh called the stock Loader directly and never re-registered the identity: fixed (`remember_refreshed_target_module`). | **TRUE (source + gate pins).** Live pending: no composed module has run in game yet. |

## Design (as implemented)

### Recipe (`CustomScripts\Packages\<Name>\literals.json`, format `RENOVICE_LIVE_LITERALS_V1`)

- `package` (state id, must equal the folder's), `build` (must equal `package.json` `settings.build`), `modules`
  `{ <16-hex key>: { file, stock_size, stock_sha256 } }`, optional `groups` (groups used only by recipe values, so an older
  DLL never shows an empty section), `values`.
- A value: `declaration` (an unchanged ADDON_SETTINGS_V1 value declaration with `"lane": "literal"`, parsed by the same
  `parse_value_decl`), `module`, optional `insert_before` (display order next to the package.json values), `drives`
  `[{ row, scale, integer, stock, sites: [...] }]`.
- A site: `kind` `loadn` (4-byte U44 LOADN: `register`, optional `rewrites_instruction`) or `number_constant` (8-byte f64
  after tag byte 2; requires `"constant_gate": "K_CONSTANT_EXCLUSIVE_V1"`: shared-constant safety, the registrar's exclusivity
  proof is bound to the pinned stock SHA-256), `offset`, `expected` (hex preimage), `numerator`, `denominator`, optional
  `inverse`.
- A value whose single drive names its own id is a DIRECT row value; any other value is a MASTER knob: row value =
  `llround(master x scale)` for integer rows, `master x scale` otherwise (CONTRACT R5-3).
- Parse-time rules (recipe-local rejection with an exact reason): strict fields; lower-case keys and hex; every site inside
  `stock_size`; the recorded row stock is exactly what the preimage encodes (`stock-value-disagrees-with-preimage`); one site
  set per row; no two rows of a module share a byte (`recipe-sites-overlap`); a row has at most one direct value and one master
  (`recipe-row-driven-twice`). Merge rules: build equal, no id or group already declared, lane literal, int or float, declared
  stock = row stock through the scale, the whole declared range encodes at every site
  (`recipe-declared-range-outside-operand-domain`).

### Resolution (every committing scan: startup, F9, SCRIPT SETTINGS apply)

- `packages.cpp` attaches the recipe in `scan_package` (after package.json declarations) and resolves plans in
  `apply_member_policy_and_settings` from the same evaluation as every other value.
- A value APPLIES when it is effective (on, valid, section on, package not on stock) and differs from its declared stock. Per
  row: the row's own value, when on, wins (at its stock the row stays stock); else an applied master gives master x scale; else
  the row is not patched. **A value at its default adds no patch; a module without patches has no plan and loads stock.**
- Per module: every site encoded through the shared core; an operand outside the domain holds the whole module at stock
  (`PLAN REJECT … scope=module-local module=stock`). Plan identity = digest of key, stock SHA-256 and every patch.

### Synthesis and publication (replacement lane)

- `replacements.cpp` builds a `PlanSnapshot` next to its byte snapshot (startup, F9 prepare), prepares/commits/discards it
  with the same transaction. Recipe keys join the available keys (stock capture at natural load). A module owned by a byte
  replacement (loose file or package member) keeps that owner; a later package's plan for the same key is held.
- **Natural load:** the undump detour first checks the byte snapshot (unchanged), then a committed plan for the key: it
  synthesizes from exactly the stock body being undumped (stock size, SHA-256, every preimage and the permitted-diff check;
  any failure passes the stock body through) and marks the load as a replacement undump (REPLACEMENT_SETTINGS and F9
  bookkeeping unchanged). Synthesized bytes are cached per committed plan and reused only for a byte-identical stock body.
- **F9 / settings apply:** a changed plan identity is a changed replacement key. Loaded modules are refreshed exactly like a
  changed replacement file (VM-local, from the captured stock body; restore-to-stock when the plan disappears); unloaded modules
  take the new plan at their next natural load (`module_refresh=INCOMPLETE`, as for a replacement file).
- **R5-C:** after every successful VM-local refresh, `injection::remember_refreshed_target_module` registers the refreshed
  closure's prototype graph under the same stock key (no-op unless a target addon declares the key), so luaCalls hooks match the
  replaced module; old identities stay for the running instance's closures.

### SCRIPT SETTINGS

- `ValueDecl::live_literal` (set only by the recipe merge) and `settings::editable_in_game()` (addon lane or live literal). A
  live literal value page is a normal validated editor; its tooltip ends `Applies: at the next mission.` (no live-stock
  sentence: the host patches, there is no live comparison). Baked literal values keep the read-only "Edited in Ability Studio"
  text and `read-only-row` staging. The values file, sections, Restore, "Use stock values" and delivery are unchanged.

### Logging (operational, bounded)

`RENOVICE LIVE LITERALS RECIPE ACCEPT|REJECT` (per committing scan and package with a recipe), `PLAN` / `PLAN REJECT` (at most
16 lines each, then a suppression line), `SNAPSHOT` (only when recipes exist), `SYNTHESIZE PASS|FAIL` (once per plan and stock
body, at most 256 per process), `RENOVICE TARGET MODULE REFRESH IDENTITY` (per refresh of an addon-targeted key). A setup
without `literals.json` logs exactly as before (gate-checked).

### Ownership and lifetime

| Object | Owner | Lifetime |
|---|---|---|
| Recipe, merged declarations, plans | package snapshot of one scan | per committed package snapshot |
| `PlanSnapshot` | process; prepared/active under one mutex | swapped with the replacement byte snapshot (startup, F9 commit); a prepared F9 is never visible |
| Synthesized bytes | `RuntimePlan` cache (process memory, no VM object) | as long as the committed plan; reused only for a byte-identical stock body |
| Target identity after refresh | injection target-module identities | as for a natural load (prototype roots pinned in the registry) |

## Gates

`RENOVICE_TOOLCHAIN/replacements/verify_live_literals.ps1` (in the build list): 124 checks.

- Shared core pin (and byte identity with the ability-editor copy when that checkout carries it).
- Core self-tests: LOADN/constant encoding, domain (0, 32768, fractions, non-finite), inverse operands, master row values,
  preimage/tag/register/extent verification, overlap and permitted-diff application (fail closed, no output).
- Real generated recipe (105 values, 12 masters, 28 modules, 239 sites incl. 7 constant and 2 rewritten-instruction sites):
  parse, merge, display order (`insert_before`), 14 negative cases (format, package, unknown fields, SHA, constant without the
  exclusivity proof, site kind, preimage length, row stock vs preimage, overlap, double drive, declared stock, declared range
  beyond LOADN, addon lane, other build, id clash).
- Byte-exact synthesis of the five staged baked replacements from the real stock corpus, plus fail closed for each (size, one
  changed stock byte, a forged preimage); default/off/use_stock/section-off/malformed-file cases produce no plan; row-wins-over-
  master precedence; a float constant (7.5); every value alone at its min and max synthesizes (205 module syntheses).
- The exact `packages.cpp` + `live_literals.cpp` end to end: recipe attach, merged declarations, plans per values file, log
  lines, byte-replacement ownership, changed keys, the synthesis cache and its one-line failure path, F9 value change, a broken
  recipe (package and package.json values intact, exact REJECT reason), no recipe (no line).
- Page model: live literal typeable and validated, out-of-range refused; baked literal still read-only.
- Source pins: a natural load whose plan failed closed queues no stock refresh; undump order (byte replacement first), plan build/prepare/commit/discard, changed keys, both refresh paths,
  R5-C refresh identity and the stock-key hashing order in the loader detour, package scan calls, UI editability, and no target
  names in the four primitive files.

The existing `verify_script_packages`, `verify_addon_settings` and `verify_replacement_settings` checkers now link
`live_literals.cpp` (packages.cpp attaches recipes); all their checks are unchanged and pass.

Build: `RENOVICE_TOOLCHAIN/build_private.ps1` -> `PRIVATE BUILD PASS flavor=main warnings=0 errors=0 x64=yes companion_import=no bytes=5886976 sha256=e19adfb553d6b12cdcbfbf52f38e2c0f7798c0ba5435de05f3f8876681c4e013`, 37 gate scripts (the 36 of R6 plus this one). Staged in `work/staging/live-literals/`.

## Limitations (exact)

- Every live point is pending: the SYNTHESIZE PASS line at a natural load, the value in game, an F9/settings apply on a loaded
  module, R5-C (addon hooks on a synthesized module, including after a refresh).
- `applies` is `next_mission`: the synthesized module takes effect when the module is (re)loaded. A module loaded before the
  edit is refreshed on apply (the existing replacement-lane behaviour); whether a running mission keeps its old closures until
  the next mission is not proven live for these modules.
- VMs other than the committing one get a changed plan at their next natural load (as for replacement files).
- A game update that changes a module's bytes changes its content key: the recipe no longer matches any load (stock). A
  same-key body with different bytes (not expected) fails the SHA-256 check (stock).
- A module that is also replaced by a loose file or another package keeps that owner; the live literal values for it do nothing
  (logged `module-owned-by`). Example: the `HijackSettingsExample` package owns `fb346b59e2b7687a`, so Hijack payload values in
  the Missions recipe are held while it is installed.

## Rejected designs

- Carrying the sites in `package.json` declarations: every older DLL rejects unknown declaration fields
  (`unknown-field=…`), which disables the whole package's settings capability.
- A new lane string (`"lane": "live_literal"`) in package.json: same rejection on older DLLs.
- Shipping stock bytes in the package: not needed (the natural load provides them) and not ours to redistribute.
- Patching instructions in memory after load: rejected by the user (2026-09-29, "no in-memory instruction-literal patching");
  synthesis happens before the undump, exactly where a replacement file would be substituted.
- A decompile/recompile per value (REPLACEMENT_SETTINGS_V1): needs a faithful recompile, which most mission modules fail today.

## Merge notes (shared files touched, against `b5a120b`)

- `renovice/packages.hpp`: one include, three `Package` fields.
- `renovice/packages.cpp`: one include; `recipe_path` captured in the folder loop (3 lines); `attach_recipes` after the
  declarations block (1 line); `resolve_package_plans` in `apply_member_policy_and_settings` (early-return branch and after the
  member loop).
- `renovice/replacements.cpp`: include; `build_literal_plans` / `effective_replacement` helpers before `read_name_handle`; undump
  detour (plan branch after the byte-snapshot branch); `initialise`, `prepare_reload`, `commit_prepared_reload`,
  `discard_prepared_reload`; `complete_module_load` and `reexecute_changed_loaded` use `effective_replacement`;
  `drain_pending_for_vm` calls `remember_refreshed_target_module`.
- `renovice/injection.hpp`: one declaration at the end. `renovice/injection.cpp`: one block at the end of the file
  (`BEGIN/END LIVE_LITERALS_TARGET_REFRESH`).
- `renovice/settings_core.hpp`: `ValueDecl::live_literal` and `editable_in_game()` (after `ValueDecl`).
- `renovice/settings_ui_core.hpp` (**overlaps the SCRIPT SETTINGS R7 redesign**): three lines - `value_tooltip` literal branch
  (`&& !declaration.live_literal`), `value_editor` `editor.locked = !settings::editable_in_game(declaration)`, `stage` value
  branch `!settings::editable_in_game(*declaration)`. Whatever R7 does with locking and tooltips, keep: a live literal value is
  editable and applies at the next mission; a baked literal stays read-only.
- `RENOVICE_TOOLCHAIN/build_private.ps1`: one line after `verify_replacement_settings.ps1`.
- `RENOVICE_TOOLCHAIN/injection/verify_script_packages.ps1`, `settings/verify_addon_settings.ps1`,
  `replacements/verify_replacement_settings.ps1`: link `live_literals.cpp` (2 lines each).
- New files: `renovice/live_literal_patch_core.hpp`, `renovice/live_literals_core.hpp`, `renovice/live_literals.{hpp,cpp}`,
  `RENOVICE_TOOLCHAIN/replacements/verify_live_literals.{ps1,cpp}`, `RENOVICE_TOOLCHAIN/replacements/fixtures/live_literals/*`,
  this note.
