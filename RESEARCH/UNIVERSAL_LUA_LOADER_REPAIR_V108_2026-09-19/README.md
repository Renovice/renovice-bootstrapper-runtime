# V108 universal Lua loader repair

Date: 2026-09-19
Status: **installed-bytes and offline gates pass; live gameplay acceptance pending**

## Scope

V108 repairs the global Inject outage introduced by V107. The observed V107
session had all three root symptoms at once:

- the pause-menu `SCRIPTS` row was absent;
- the Mallet target addon and native ability-card projection were absent;
- the Ice Wave target addon and native ability-card projection were absent.

This was a shared loader startup failure. It was not a Mallet-specific, Frost-
specific, Pluto-specific, script-policy or bytecode-format problem. The repair
remains in the common loader and generation architecture; it does not add an
ability-specific activation path or support script.

## Pinned build and installation evidence

The V108 private x64 build completed with exit code 0 and reported:

```text
PRIVATE BUILD PASS warnings=0 errors=0 x64=yes companion_import=no bytes=4790784 sha256=82d34d2321667909e11327535a33b1d4e71130f6c9ab31a9c9db255caa676227
```

Pinned V108 DLL:

- bytes: `4,790,784`;
- SHA-256:
  `82D34D2321667909E11327535A33B1D4E71130F6C9AB31A9C9DB255CAA676227`;
- package:
  `RENOVICE_DEPLOYMENTS/UNIVERSAL_LUA_LOADER_REPAIR_V108_2026-09-19`;
- installation receipt time: `2026-09-19T15:13:55.4087911Z`;
- previous installed V107 SHA-256:
  `C0AA443D4858A205959C57C5CBDD469606A459F4F7E59882EAD0D5ADEC31D2C8`.

The native RVAs in this report are scoped to `Warframe.x64.exe` version
`2026.08.19.11.06`, 45,606,520 bytes, SHA-256
`CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93`.

The V108 pre/post installation audits each cover 89 files. Their exact
path-and-hash comparison has one changed file: `WTSAPI32.dll`. The other 88
files are byte-identical. In particular, `OpenWF/Hotfix.owf`, every Pluto
script, `renovice.cfg`, `ScriptStates.json`, all Inject bytecode, all root
replacement bytecode and metadata files are unchanged.

The repository build output, packaged artifact and installed game DLL were
rehash-checked after the final rebuild; all three have the pinned V108 SHA-256
above.

The V107 DLL and configuration remain in the package's `rollback` directory.
This is installation evidence, not proof of startup or gameplay behavior.

## Hypotheses and results

| Hypothesis | Evidence | Result |
| --- | --- | --- |
| The live `.lua_B` files were corrupt or used the wrong DE header. | Every one of the 16 runtime candidates begins with `09 03`. All seven Inject files pass the injection verifier. All 16 pass `derecomp de-roundtrip` with `FULL BODY identical: True`. | **FALSE** |
| `ScriptStates.json` disabled the providers. | The JSON parses. Explicit entries are enabled; absent entries default to enabled in `script_control::state_enabled`. The internal bridge is force-enabled independently of player policy. | **FALSE** |
| The Scripts bridge was missing or had drifted. | The installed 1,111-byte bridge SHA-256 is `153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82`, identical to the canonical repository bytecode. | **FALSE** |
| One malformed target addon rejected all target keys and the menu. | Target-addon staging and rollback are scoped to one target key and VM. A target failure does not remove the independent bridge or unrelated target keys. The seven installed Inject files pass admission. | **FALSE** |
| Pluto changes caused the all-script outage. | The V107 and V108 audits prove that no Pluto file changed. The missing `SCRIPTS` row belongs to the RENOVICE Inject startup chain. | **FALSE for this outage** |
| The V107 nested-call observer prevented the base Inject system from starting. | V107 tried to install an ordinary Soup detour at callback RVA `0x197EC80`. Its prologue contains relative control flow before the trampoline's required stolen-byte length. Soup rejects IP-relative instructions; V107 then destroyed the already-created loader and VM-execute hooks and returned failure before publishing generation 1. | **TRUE** |
| Moving observation to the exact counter leaf and separating observer installation from the base hooks repairs the architectural failure. | V108 hooks the unique counter leaf at RVA `0x1AB150`, runs stock exactly once, preserves its return, bypasses observation above the stock 800,000 limit, and installs the observer only after the base hooks are enabled. A detour creation/enable failure no longer tears down the base loader. All offline gates pass. | **TRUE offline; live acceptance pending** |

## Exact V107 failure

The supported game executable's callback at RVA `0x197EC80` begins:

```text
0x197EC80  TEST EDX, EDX
0x197EC82  JNS  0x14197EC9D
0x197EC84  PUSH RBX
0x197EC85  SUB  RSP, 0x20
0x197EC89  MOV  RBX, RCX
0x197EC8C  CALL 0x1401AB150
0x197EC91  CMP  EAX, 0xC3500
0x197EC96  JG   0x14197EC9E
```

This evidence is preserved under the project-native analysis export at
`work/native-analysis/exports/wf-2026.08.19.11.06-cca46d60/address-evidence/197EC80.tsv`.

Soup's ordinary `DetourHook` builds an original trampoline by decoding and
copying complete instructions until its minimum size is reached. It explicitly
throws `Instruction interacts with instruction pointer` if a copied operand
uses the instruction pointer. The relative `JNS` at `0x197EC82` therefore makes
the callback entry invalid for that ordinary trampoline. The later relative
`CALL` is another reason not to relocate this prologue as raw bytes.

In V107 this observer hook was part of the same mandatory creation transaction
as the base module-loader and VM-execute hooks. When observer trampoline
creation threw, the catch path destroyed the two valid base hooks and returned
false. `injection::initialise()` returned `Failed` before it could publish:

- `active_chunks`;
- `subsystem_enabled = true`;
- `scripts_ui_enabled = true`;
- `startup_pending = true`.

Consequently generation 1 never ran, the bridge never published
`_T._RENOVICEScriptsOpenBridgeV10`, TopMenu could not append `SCRIPTS`, and no
target addon could activate. This explains all observed symptoms with one
failure and does not require assuming independent corruption of every script.

## V108 universal repair

V108 preserves the existing universal pipeline:

1. scan the direct files under `CustomScripts/Inject`;
2. resolve and create the base module-loader and VM-execute hooks;
3. enable those base hooks;
4. publish the startup generation;
5. execute ordinary/managed providers and the hidden bridge in the real DE VM;
6. bind target addons when their keyed stock module naturally loads;
7. route declared hook capabilities through the shared handler snapshot.

The nested `luaCalls.before` observer now uses the relocation-safe, unique
interrupt-counter leaf at RVA `0x1AB150`. The observer detour:

- calls the exact stock counter function first and exactly once;
- preserves and returns the stock count;
- immediately returns counts greater than `800000`, allowing the unchanged
  parent callback to raise DE's stock infinite-loop error before addon work;
- reads the exact current instruction only after the stock operation;
- requires an exact target key, VM and prototype claim;
- decodes the existing DE CALL A/B argument window;
- dispatches only a provider that declared that exact `luaCalls.before`;
- retains no after token, CallInfo pointer or argument registry root;
- contains optional observation inside a `noexcept` fail-closed boundary that
  returns the preserved stock count after any C++ exception;
- restores the VM's `intop` and `outtop` through scoped ownership if optional
  dispatch or allocation exits exceptionally;
- leaves `luaCalls.after` rejected until exact call retirement is implemented.

Base-hook installation and observer installation are separate transactions.
If observer detour creation or enablement fails, V108 logs the capability
failure and retains ordinary Inject, replacements, target addons that do not
request `luaCalls.before`, and the Scripts bridge. A provider that explicitly
requests `luaCalls.before` rejects during staging when the observer capability
is unavailable.

Two native signatures remain part of the mandatory core contract: the exact
interrupt counter and the 800,000-count guard. That is intentional and predates
V108. Every RENOVICE protected callback uses the certified interrupt-budget
layout, so continuing without those symbols would discard a core safety
contract. V108 makes the **observer detour installation** capability-local; it
does not weaken the shared protected-callback contract.

## Installed script inventory

The direct runtime inventory is unchanged across V107 to V108:

- **7 Inject files**
  - internal ScriptsSettingsBridge V10;
  - Mallet Overguard/card target addon;
  - Survival timers target addon;
  - Circuit progress preview target addon;
  - Elite Sanctuary rank target addon;
  - Interception timers target addon;
  - Ice Wave Cold-stack damage target addon;
- **9 root replacement files**
  - Mallet cover flags;
  - Excavation timers;
  - Octavia Amp distance behavior;
  - Riven lock;
  - Mobile Defense timers;
  - Plains control-area timer;
  - Deimos control-area timer;
  - Nokko control-area timer;
  - Octavia Metronome behavior.

`CustomScripts/Diagnostics/TopMenu.current.lua_B` is a diagnostic evidence
artifact. Both runtime inventories use direct, nonrecursive directory scans, so
that nested file is not admitted as an Inject provider or root replacement.

Offline live-directory admission after V108 deployment reports:

```text
INFO supported_chunks=7 unsupported_chunks=0
INJECTION CORE PASS

INFO active replacement files=9 unique_keys=9
REPLACEMENT CORE PASS
```

## Offline gates

The complete `RENOVICE_TOOLCHAIN/build_private.ps1` transaction passed. It ran
these gates before the private x64 link:

- tool bootstrap;
- dependency verification;
- migration manifest verification;
- callback-runtime verification;
- automatic-damage-runtime verification;
- Scripts UI bridge verification;
- Scripts UI core verification;
- safe-runtime-tick verification;
- OpenWF game-VM bridge verification;
- unified diagnostics master-switch verification;
- generation-ownership verification;
- deferred game-registry release verification;
- process-owned hotkey-latch verification.

The injection verifier also exercises three failure boundaries that V107 did
not cover:

- a real Soup `DetourHook` builder fixture accepts the exact counter-leaf bytes
  and rejects the old branch-heavy callback prologue;
- count `800000` admits optional observation while `800001` bypasses it;
- a forced C++ observer exception preserves the stock count;
- the source contract gate verifies scoped restoration of both VM stack
  endpoints on every lambda exit, including exception unwinding.

The final artifact gate proved x64 architecture, zero warning/error patterns
and no legacy `wtsapi32_owf.dll` companion import. Focused verification against
the deployed directories then passed all seven Inject files and all nine unique
root replacement keys.

These gates prove build, source invariants, bytecode admission, package-artifact
identity and installed bytes. They do not prove that the current game process
reached the startup boundary or that each provider behaved correctly in
gameplay.

## Live acceptance checklist

V108 is accepted only after a fresh process passes all applicable items:

- [ ] game reaches login/Orbiter without an Inject startup failure;
- [ ] exactly one `SCRIPTS` row appears in the pause menu;
- [ ] `SCRIPTS` opens, closes and reopens while stock rows remain usable;
- [ ] Mallet ability-card projection appears;
- [ ] Mallet Overguard and threat behavior execute in mission;
- [ ] Ice Wave card projection appears;
- [ ] Ice Wave applies the verified per-target Cold-stack calculation;
- [ ] one root replacement is observed live, independently of target addons;
- [ ] Survival and Interception target providers still bind;
- [ ] F9 replaces a generation without losing the Scripts bridge or callbacks;
- [ ] F10 still enters Simulacrum through the existing Pluto hotkey path;
- [ ] exact `Limbo` and another full-name Arsenal search do not regress;
- [ ] Arsenal, mission and Orbiter transitions complete normally;
- [ ] diagnostics-off play performs no diagnostic callback/serialization work;
- [ ] an ordinary unrelated Inject fixture can execute without an ability-
  specific native branch.

Until those checks are observed, the precise status is **V108 installed-bytes
PASS, offline universal-loader gates PASS, live acceptance pending**.
