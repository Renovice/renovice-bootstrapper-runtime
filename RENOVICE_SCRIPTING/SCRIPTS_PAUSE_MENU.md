# RENOVICE native Scripts pause menu

## Result and scope

The runtime adds one `SCRIPTS` row to the authoritative array produced by the
stock TopMenu row builder. It does not replace `TopMenu`, remove a stock row,
reorder stock rows, or introduce an independently drawn overlay.
The row uses the same native `Name`, `Description`, `Menu`, and `CallBack`
fields as DE's existing pause-menu entries.

Selecting `SCRIPTS` opens a native submenu containing every recognized
`*.lua_B` file from:

- `OpenWF/CustomScripts/Inject` (one-shots, addons, target addons);
- `OpenWF/CustomScripts` (whole-module replacements).

Each recognized script receives one native DE checkbox row. The X/check state
is the effective disabled/enabled policy, while the visible label is a
presentation-only canonical name. Files, target keys, stable IDs, and script
bytecode are never renamed or edited by the menu.

## Persistent state

The menu owns one generated file:

`OpenWF/CustomScripts/ScriptStates.json`

Its schema is deliberately small:

```json
{
  "schema": 1,
  "scripts": {
    "addon:example.addon.lua_b": false,
    "replacement:0123456789abcdef example.lua_b": true
  }
}
```

Missing entries default to enabled, preserving the pre-menu behavior. IDs are
case-normalized and include the script type, so an addon and replacement with
the same visible annotation cannot collide. Writes use a temporary sibling
and an atomic `MoveFileEx(..., REPLACE_EXISTING | WRITE_THROUGH)` commit.
Malformed, oversized, duplicate, or non-boolean state fails the reload closed;
the active generation remains unchanged.

## Apply semantics

Clicking a row changes only the Generic Settings movie's staged value. It does
not mutate the DE VM and does not immediately write `ScriptStates.json`.

- **Confirm** reaches the completion callback with a nil cancellation flag.
- A second stock close path reaches the same callback with boolean true. Live
  testing proved that Generic Settings can use this path even after a real
  checkbox edit, which made valid changes appear to flick themselves back.
- Either recognized close path atomically applies a nonempty staged batch and
  queues the same safe-boundary transaction used by F9. A close with no staged
  changes is a no-op.
- Malformed completion shapes still fail closed and clear the staging table.

The next live DE script tick after a successful Confirm performs:

1. config and `ScriptStates.json` prepare;
2. SWF, replacement, Riven, and Inject snapshot prepare;
3. managed-addon lifecycle staging;
4. atomic commit, or discard and rollback;
5. loaded replacement refresh/stock restoration where the existing exact-VM
   refresh evidence permits it.

Consequences by script type:

- managed addon: disabling invokes its cleanup before releasing the lifecycle
  root; enabling stages and activates a new generation;
- target addon: its exact target body key remains observable while disabled,
  but its bytecode does not execute. This lets a later live enable attach to a
  target module that loaded while the policy was OFF;
- target addon: the desired generation is changed at its base-module/VM
  association, never by scanning gameplay instances;
- replacement: disabling removes the replacement-map entry and requests stock
  restoration for captured loaded contexts; unresolved contexts use stock at
  their next natural load;
- one-shot: disabling prevents future execution but cannot generically undo a
  side effect the script did not expose through an addon cleanup contract.

## Pause-module association

The loader does not depend on menu timing or a guessed object instance. At the
natural base-module load it requires six independent stock bytecode markers:

- `GetMenuEntries`
- `MenuSelectionDone`
- `ResumeGameUpperCase`
- `MenuAbilities`
- `MeleeCombos`
- `MenuOptions`

The first live build falsified the assumption that `GetMenuEntries` is a
TopMenu export. Disassembly and the live `GetMenuEntries-not-function` trace
show that name belongs to a nested generic-popup routine and is not the ESC
row builder. That rejected implementation made no mutation and the stock menu
remained intact.

The loader-return experiment and the later protected-call observer are both
retained as negative evidence. Loader return was too early to retrieve a
published `Initialize` export, while the exact TopMenu identity was recorded
without a later matching protected-call event. The current evidence is that
TopMenu's root executes inside the original loader path rather than through
the separately hooked protected-call path. Neither export polling nor a delay
can repair that ownership mismatch.

The native set-global diagnostic then kept a thread-local TopMenu load boundary
active only around DE's original loader call. The live trace recorded
`Initialize_assignments=0` even though the exact TopMenu identity passed and
the loader completed successfully. This falsified the assumption that Luau's
`SETGLOBAL` opcode crosses either of the two public/native set-global helper
APIs: the VM interpreter performs the bytecode operation internally.

Static current-client disassembly identified the execution chain from DE's
protected call through its precall machinery into the Luau VM interpreter.
The runtime records the exact TopMenu body, root prototype, environment, and
global VM at the semantic loader boundary. It may inspect that recorded
environment only after a normal interpreter return in the same global VM; it
never derives ownership from `CallInfo`, scans menu objects, or crosses into a
different VM. A bounded 32-attempt fail-closed allowance covers publication of
`Initialize`; successful wrapper readback permanently closes that identity.
There is no timer, sleep, frame polling, or object-instance search.

The first interpreter-boundary live run still produced no root-match event.
Its diagnostic `CallInfo` walk also reported impossible frame counts such as
`6148914691236517207`. That makes the private `CallInfo` layout assumption
false; none of those frame records may be used as ownership evidence. The
captured body at
`OpenWF/CustomScripts/Diagnostics/TopMenu.current.lua_B` remains valid because
it came directly from the independently verified loader descriptor.

Static disassembly of that exact 159,749-byte body established the corrected
contract. The root creates `Initialize` with 23 captures. `Initialize` zero-
based upvalue 14 owns the stock row builder; upvalue 17 owns `CreateList`.
The builder has 59 captures and,
after producing every stock row and applying DE's normal filters, invokes its
upvalue 58 with the completed `_ENV.mMenuOptions` array as the normal Lua
argument. The runtime therefore wraps only that final dispatch callback,
appends `SCRIPTS` to the supplied table, and then calls DE's original callback.
It does not guess an internal table-owning upvalue and does not walk VM frames.

The rejected contract required 25 `Initialize` upvalues, 55 builder upvalues,
and treated builder upvalue 7 as the authoritative array. All three assertions
are false for the captured client. They explain why the earlier implementation
could never reach row insertion even if its environment lookup had succeeded.
Any future change to the corrected 23/59 counts, U14 builder ownership, U58
dispatch ownership, value types, or wrapper readback fails closed and is
written to the diagnostic log.

The generated wrapper is strongly rooted in the module environment before its
upvalue is installed. This avoids depending on an unverified internal garbage
collector barrier address. The matched original-body key and the exact
`Initialize.U14 -> Builder.U58` ownership result is written to
`renovice_source.log` as update evidence. Earlier rejected builds attempted to
inspect exports at loader return, observe the root through a separate
protected-call hook, intercept native set-global helpers, or identify the root
through a guessed `CallInfo` layout. Live V3 evidence then separated the valid
and invalid parts of that diagnostic: the current-frame function slot at
`CallInfo + 0x08` was coherent, but adjacent live frame addresses proved the
private client stride is `0x28`, not the stale `0x30` declaration. V4 uses only
the current frame—never an unbounded walk—to match the exact loader-pinned root
prototype and obtain the executing instance's environment.

The wrapper always forwards the original U58 dispatch callback, including
when the supplied argument is not a table or the additive row cannot be
constructed. That is the actual fail-closed boundary: an ABI change may omit
`SCRIPTS`, but cannot suppress DE's stock pause menu. Startup also writes
`TOPMENU_RUNTIME_ROOT_PROTO_ENV_INITIALIZE_U14_BUILDER_U58_V5` to the source
log. The exact TopMenu identity is no longer retired after a fixed retry count.
These markers distinguish the current architecture from every earlier
diagnostic DLL without relying on file timestamps.

Live candidates V1 and V2 proved only that their 32 startup probes occur before
the later visible-menu publication state; V2's hashed VM-global path remained
nil throughout that window. V3 then performed more than 4,900 throttled probes
after 313,000 same-VM returns, yet the loader-recorded environment never exposed
`mMenuOptions`. That falsified the assumption that the loader's template
closure environment is the executing UI instance environment. V4 matches the
exact global VM and exact root prototype, captures the runtime closure's actual
environment, and validates its published `mMenuOptions` and 23-upvalue
`Initialize` immediately after that root returns. V4 then proved its own U17
assumption false: the live closure at U17 had 12 upvalues and stack size 10,
which the pinned static map independently identifies as `CreateList`.
The exact current map establishes `Initialize.U14` as the 59-upvalue
`BuildMenuOptions` closure and keeps its final U58 dispatch association.

The focused native audit is recorded in
`RESEARCH/TOPMENU_NATIVE_BOUNDARY_AUDIT_2026-08-27.md`. The loader,
protected-call, `getfield`, and `setfield` functions decompile coherently at
the exact signature-resolved RVAs. Ghidra explicitly reports bad instruction
data and non-settling type propagation for the monolithic VM interpreter, so
that pseudocode is retained as negative evidence and is not used to infer a
private `CallInfo` layout.

## Verification and shipped live acceptance

Offline verifier:

```powershell
RENOVICE_TOOLCHAIN\scripts_ui\verify_scripts_ui_core.ps1
```

The private build gate runs that verifier automatically, then treats compiler
warnings and errors as failures.

The main use path is **live accepted and shipped** on 2026-08-27:

- the additive `SCRIPTS` entry persists across repeated Esc-menu opens;
- the native checkbox submenu opens and renders all five recognized scripts;
- closing the panel persists a changed switch across reopening the menu,
  regardless of which recognized stock close route Generic Settings uses;
- canonical V16 display names render without changing filenames or state IDs;
- the user reports that scripts otherwise work correctly in gameplay;
- no unsupported experimental Inject chunks are present in the live folder.

Known operational boundary: an already-created mission object or already-
executing closure can retain its old script generation. The queued transaction
cannot generically rewrite an engine object that already captured the previous
closure. Starting or restarting the mission forces the normal module/object
construction path and is sometimes required before the new behavior is
observable. Recasting or respawning the affected object is sufficient when the
game creates a new instance without a full mission transition. This is a
lifecycle boundary, not evidence that the policy failed to save; the reopened
checkbox and `native module refresh PASS` log are the persistence/delivery
checks.

The following destructive/edge recovery cases remain gates rather than claims
of repeated live exercise:

- disabling a loaded replacement restores stock immediately when the captured
  VM context is refreshable, or is explicitly logged as pending next load;
- malformed `ScriptStates.json` rolls back without changing the active scripts;

Those cases continue to fail closed offline. They do not downgrade the accepted
menu and persistence path; manifest features `SC-001` and `UI-001` are shipped
as `DEPLOYED_CUSTOM`, not claimed as stock DE parity.

## Performance boundary

The menu implementation has no idle folder watcher and performs no per-frame
script refresh. Inventory discovery happens when the submenu is built, and a
reload is queued only after Confirm or F9. Therefore the closed SCRIPTS menu is
not expected to create continuous Mallet work.

The user has observed an occasional small Mallet hitch, but no controlled
baseline, frame-time capture, callback count, or A/B script-state comparison
has been collected yet. Attribution to repeated refresh is **NOT PROVEN** and
performance work is intentionally deferred to a separate investigation. The
future test must distinguish menu/runtime reload cost from Mallet's own
per-damage callback frequency and gameplay particle/enemy-load cost.
