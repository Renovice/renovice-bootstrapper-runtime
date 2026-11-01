# OBJECT_REFLECTION_V1: RENOVICE.object (engine field reflection), 2026-10-31

Build: client 44.1.3 `Warframe.x64.exe` sha256 `c1ae12fb5257e29df41ab0cc11d3a7f8dc027051d21e0b6e96ede3139d020584`
(installed Steam + Documents copy, identical). Resolver also run on the 7 native-update reference
images (2026.09.24 ... 2026.10.22 stock). Source + build + offline gates only; not deployed, no live run.

## Hypotheses and results

| # | Hypothesis | Result |
|---|---|---|
| H1 | Every engine object exposes its fields through vtable +0x50 (field visit) to an archive object; name slot +0x138, typed slots follow. | TRUE (static): NpcAiDirector visit `0x1410f2f10` decoded, 52 fields; `ApplyArchive` calls `[rax+0x50]`. |
| H2 | The metadata text-apply chain (reader ctor, text load, ApplyArchive, reader dtor) can be re-found per build from the Metadata Patches signature without RVAs. | TRUE on 8 images (6 distinct layouts; every function moved). |
| H3 | The engine text writer used by engine dump sites can be located per build from ApplyArchive call sites. | TRUE: ctor/begin/end agreed by 6 sites on 44.1.3; dtor by majority vote; >=2 sites on every image. |
| H4 | Metadata text keys drop the `m` prefix. | TRUE (disassembly of normaliser `0x1413dbd90`): drop everything through the last `.` or `>`, then drop a leading `m`, `s` or `g` when the next char is `A`..`Z`. The record is normalised in place on first use (`{0xa000.., char*}` -> `{len, char*}`). `mHardMaxAICap` -> `HardMaxAICap`; `mbFoo` unchanged. Comparison is case-sensitive (length + memcmp). |
| H5 | Archive slot 0x120 is an enum. | FALSE: it is an interned symbol/name id (writer quotes it, `mov r9b,0x22`; reader strips quotes; both call the same id lookup `0x140aeaa80` ApplyArchive uses for type ids). Exposed as type `symbol`. |
| H6 | Slot 0x110 is a plain int. | PARTIALLY: it widens through the int32 slot 0x108 (`call [r8+0x108]` on a stack temp) into an 8-byte field (value zero-extended, -1 as all ones). Low dword = value. Slot 0x108 = int32. |
| H7 | Partial reader text leaves other fields untouched. | PARTIALLY verified: float slot writes only when the current name node exists; array helper `0x1415d3250` in reading mode (`archive+0xa == 1`) checks node presence (`vt+0x48`) and skips. Other custom composites not verified. |
| H8 | A fake visitor (own 49-slot vtable) is the safer enumeration route. | FALSE / rejected: composite helpers branch on archive state (`+0xa` reading byte, `vt+0x48` presence, `vt+0x148` begin, array sizes) and resize arrays in reading mode; emulating 49 slots safely is not evidence-backed. Chosen: engine text writer + recording copy of its vtable (6 wrapped slots forward to the originals). |

## Engine contract used (44.1.3 addresses for orientation only; nothing is hardcoded)

- Reader: ctor `0x140526f70(r)` (vt `0x1420163a8`, touches up to +0x148c), load `0x1414b20b0(r, GameString*, 0, 3)`,
  then `byte [r+0xe] = 0` (both engine sites), `ApplyArchive 0x140354aa0(obj, r, 1)`, dtor `0x1402076e0(r)`,
  status `byte [r+9] == 4` -> the engine's error-report branch.
- Writer: ctor `0x1415a1e50(w, 3)` (flags bit0 required, bit2 forbidden; `flags` at +0x4ac), begin `0x1412f1900`,
  `ApplyArchive(obj, w, 1)`, end `0x140e6b500`, text = GameString at `w+0x498`, error byte `w+0x4a8` must be 0,
  dtor `0x14059bfd0`. Current container node `w+0x420` (name slot) distinguishes top-level fields from nested ones.
- `ApplyArchive` reads object+0x08 (type record, parent chain via +0x18 with flag 0x10), object+0x10 (self pointer,
  dereferenced when lock=1), object+0x1c, writes object+0x24 (archive version) - the runtime validates these first.

## Resolver (renovice/object_reflection_core.hpp `resolve`)

Byte-structural, per build: unique Metadata Patches signature -> D = reader frame displacement; text load = E8 at +17;
reader ctor = last call before the site preceded by `lea rcx,[rbp+D]` and whose body stores a vtable; ApplyArchive =
call after `mov r8b,1` with `lea rdx,[rbp+D]`, body must contain `call [rax+0x50]` and `mov word [rbx+0x24],ax`;
post-load flag and status offsets from the stores/reads around it; normaliser from the reader name slot (must hold the
`0xa000000000000000` tag constant). Writer: vote over every E8 caller of ApplyArchive for
`lea rcx,[W]; call C; lea rcx,[W]; call B` ... `call ApplyArchive` ... `lea rcx,[W]; call E`; C must store a vtable,
flags and an empty GameString; its name slot must call the same normaliser; the five scalar slots must load the
current node and contain their value access. Any mismatch -> `RENOVICE OBJECT_REFLECTION FAIL reason=<exact>`;
only RENOVICE.object is unavailable.

## Runtime (renovice/object_reflection.cpp, injection.cpp OBJECT_REFLECTION_LUA_API)

- `initialise()` in `create_all_hooks` before the Metadata Patches CallsiteHook rewrites the text-load call.
- Lua: `_T.RENOVICE = { version = 1, object = { fields, get, apply, set, dump } }`, published in the committing DE VM
  at each generation before any member runs, rooted at registry key `RENOVICE.object-api.v1`; a foreign
  `_T.RENOVICE` is never overwritten (`shared-field-collision`). DE VM only; Pluto untouched.
- Each call: provider available -> owner thread (`captured_owner_thread`) -> `readable_engine_object` userdata ->
  object structure validation -> engine run. Native work completes in one C++ scope; the push phase is
  destructor-free. No new `__builtin_setjmp` site: an Inject script or addon activate already runs under the
  existing guarded leaves; a hook callback does not (validation is the protection there).
- Diagnostics: startup PASS/FAIL (Logging / console), per-generation publish (Verbose / error), per call
  Verbose PASS (64 lines max) and Logging FAIL (32 max). No Diagnostics-mode observers.

## Gates

`RENOVICE_TOOLCHAIN/object_reflection/verify_object_reflection.ps1` (wired into build_private.ps1): core checker
(36 rule checks + resolver on every client image), independent capstone gate per image (chain equality, writer
sites, normaliser rule, NpcAiDirector found from the string `mHardMaxAICap` without an address: HardMaxAICap int,
SpawnTimer float, EventTimer float, 52 fields), source pins.

## Limitations / pending

- No live evidence yet (startup PASS line, publish line, test script results). Live test:
  `RENOVICE_LIVE_TESTS/OBJECT_REFLECTION_V1_2026-10-31/`.
- Lua numbers are float32 in the DE VM: integers above 2^24 lose precision.
- Derived/cached values are not recomputed by ApplyArchive (whether a changed director value takes gameplay effect
  is unverified). obj+0x24 is stamped by ApplyArchive as on every engine apply.
- A hardware fault inside engine code during a call from a hook callback (no guarded leaf) would not be caught.
- `_T.RENOVICE` is republished at generation commits only; a `_T` replaced later in the session lacks the field until
  the next F9 (scripts should keep `local R = _T.RENOVICE` from load time; the table itself stays rooted).
- Second unrelated live target (AGENTS rule for universality) still required.
