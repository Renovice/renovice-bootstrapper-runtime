# TopMenu native-boundary audit — 2026-08-27

## Scope

This audit asks whether the missing `SCRIPTS` pause row is evidence that the
menu is owned by C++, evidence that the Lua decompile/recompile pipeline is
wrong, or evidence that the runtime attached at the wrong Lua lifecycle
boundary. It uses the exact certified client:

- Product version: `2026.08.19.11.06`
- `Warframe.x64.exe` SHA-256:
  `CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93`
- Captured TopMenu body SHA-256:
  `D3279EE9A715B90BD078D9F614ACC691FD050E957212723541E5C92DD6639D94`

Focused pseudocode exports are under
`work/native-analysis/exports/wf-2026.08.19.11.06-cca46d60/pseudocode` in the
workspace root.

## Hypotheses and verdicts

### H1 — The visible pause-menu row list is fundamentally C++-owned

**FALSE.** The exact captured `Lotus/Interface/TopMenu` bytecode contains the
stock row names and row-building flow. Static disassembly identifies the
completed menu array being passed through `Initialize` U17's builder to its
U58 dispatch callback. Native code loads and executes the module and exposes
table APIs, but the row composition contract being extended is Lua.

### H2 — The current Lua decompiler/recompiler cannot represent this menu

**FALSE for the evidence tested.** The exact 159,749-byte body is recognized by
the six-marker semantic fingerprint, and its closure graph yields a stable
23-upvalue `Initialize`, 59-upvalue builder, zero-based U17 owner, and U58
dispatch. Existing replacement and addon scripts also execute on this client.
This does not prove every private UI ABI, but it rejects a blanket
decompiler/recompiler failure as the cause of the absent row.

### H3 — The earlier live tests exercised the corrected U17/U58 hook

**FALSE.** The live DLL is SHA-256
`5A928FA0D38BDD8CB3567A29F6198083BDF9776792EC1CB9A896BC3EE166C847`.
Its log contains the rejected `VM FRAME` diagnostic with impossible frame
counts. The previous corrected candidate
`CF625318A388E44A1C2E38202A8E54490626A73129756BC76FEFB9E5090BC5A0`
was built after the live DLL and was never copied into the game directory.

### H4 — The loader and public Luau table-call boundaries used by the host have
coherent native contracts on this exact executable

**TRUE at the inspected boundary level.** Exact signature scans find one match
for every required symbol. Focused decompilation is coherent for:

- module loader RVA `0x16E0530`;
- protected call RVA `0x13C58E0`;
- `getfield` RVA `0x16CC470`;
- `setfield` RVA `0x17BEA30`.

The observed functions manipulate the expected state/top/table/key shapes.
This supports the host's declared entry-point signatures; it does not by
itself prove higher-level TopMenu ownership.

### H5 — Ghidra's monolithic VM-interpreter pseudocode proves a private frame
layout that can be walked safely

**FALSE.** The RVA `0x198F250` export is accompanied by Ghidra warnings:
`Control flow encountered bad instruction data` and
`Type propagation algorithm not settling`. Its roughly 1.6-million-character
pseudocode is not accepted as type/layout evidence. The live frame walker also
reported the impossible count `6148914691236517207`. `CallInfo` walking remains
rejected.

### H6 — The corrected hook is safe to deploy without forwarding DE's dispatch
after an additive failure

**FALSE; fixed before deployment.** The pre-fix wrapper returned early when
the menu argument was unexpected or row construction failed. The current
wrapper always calls the original U58 callback and logs whether the additive
append succeeded. This preserves the stock menu on ABI drift.

### H7 — `Initialize` is an ordinary field on the recorded root closure's
environment table

**NOT TESTED AFTER PUBLICATION.** DLL `790B16CC...13D0E` loaded the exact TopMenu body,
recorded the expected VM/environment/root identity, and attempted the bounded
post-execution attachment 32 times. Every attempt returned nil for both the
hashed ordinary-table key and friendly string key, ending in `EXHAUSTED`.
V2 proved those 32 attempts all occur before the later visible-menu state. The
earlier conclusion that this disproved the environment table was too strong;
the test retired its identity before the root's publication state existed.

### H8 — `Initialize` must be read through DE's hashed VM-global namespace

**FALSE for TopMenu `Initialize` in the tested window.** The
working addon trace bridge already resolves `_T` by placing `wf_hash(name)` in
a BOOL-tagged TValue and calling `gettable` against VM pseudo-index `-10002`.
The exact TopMenu root disassembly publishes exports with `SETGLOBAL`.
However, V2 returned nil through that path on all 32 startup probes. This
proves `_T`'s working global mechanism cannot be generalized to TopMenu's
per-closure `_ENV` publication at that lifecycle point.

### H9 — Publication state, not a fixed retry count, is the valid attach gate

**TRUE as a gating principle, but V3's chosen owner was FALSE.** Exact current bytecode proves the
root writes `_ENV.mMenuOptions` at instruction 49 and `_ENV.Initialize` at
instruction 687. V3 retained the loader identity for more than 4,900 probes
and 313,000 same-VM interpreter returns, but its recorded environment never
contained `mMenuOptions`. The visible menu existing at the same time proves
that loader environment was a template, not the executing UI instance owner.

### H10 — A runtime TopMenu closure may share the pinned root prototype while
owning a different per-instance environment

**SUPPORTED BY THE V3 FAILURE; V4 LIVE ACCEPTANCE PENDING.** Earlier frame logs
showed coherent current Lua closures but impossible frame counts. Their raw
addresses prove adjacent `CallInfo` records are `0x28` bytes apart, while the
local header declared `0x30`. V4 corrects that declaration, reads only the
current frame, requires exact global VM plus exact loader-pinned root prototype,
and then consumes that runtime closure's own environment. Wrong VM, wrong
prototype, and missing-environment cases are unit-tested negative paths.

## Current candidate

- Staged DLL:
  `RENOVICE_DEPLOYMENTS/NATIVE_SCRIPTS_MENU_2026-08-27/staging/wtsapi32.dll`
- SHA-256:
  `22AE540DC5C67E038584A7735320952C043D61D341DC90A1634AEDB16BD5CFE6`
- Bytes: `4,312,576`
- Architecture marker:
  `TOPMENU_RUNTIME_ROOT_PROTO_ENV_INITIALIZE_U17_BUILDER_U58_V4`
- Private build: warnings `0`, errors `0`
- Scripts UI core: `34/34 PASS`
- Current-client scan: all `33` signatures PASS; `13/13` version/hash checks
  PASS

## Remaining live proof

The candidate is staged and live-hash verified, but must not be described as
working until a fresh launch records all of the following:

1. the architecture marker;
2. TopMenu identity PASS;
3. exact runtime root ENTER with the loader-pinned root prototype and a runtime
   environment;
4. runtime-root RESULT PASS, or a precise runtime publication/owner-shape
   failure;
5. row append PASS;
6. exactly one visible `SCRIPTS` row while every stock row remains usable.

This is one controlled test of one architecture. A missing row without those
log markers is not a test of this candidate.

The V4 pre-launch source-log boundary is 1,855,720 bytes, UTC last-write
`2026-08-27T10:45:35.0168698Z`, SHA-256
`2E9599F176893739AC459AC5D9A095BB739ED947CE612A4D1456E196BAC0CC5E`.
Only bytes after that boundary belong to V4.
