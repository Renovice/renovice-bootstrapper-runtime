# Simulacrum F10 utility, 2026-09-15

**Later numeric121 test also FAILED in V87.** Print-only API probe stays queued,
script log empty. The old public bridge rejects current userdata9 and does not
capture the UI VM; V88 translates the certified current game's public type tags,
without changing the native owner/idle/frame boundary or raw injector. Utility
source now emits bounded entry/request/returned messages; old installed source
and receipts below are preserved history. Read
[V88 research](../LOGGER_AND_F10_REPAIR_V88_2026-09-15/README.md).
This helper accepts explicitly pinned V87/V88 DLLs and verifies current source
bytes; V88 DLL/script deployment belongs to its paired installer, not this
historical shortcut creator. Actual F10 entry remains pending live.

User authorized V87 deployment plus an F10 shortcut. V87 installed19:16:28Z;
shortcut installed19:20:56Z with game closed. No further DLL edits/build.

**Initial key binding FAILED live; key code corrected19:47:48Z without a restart.**
Pinned Soup string_to_virtual_key("F10") returns VK_F11=122, proved with the
exact extracted production function compiled against Windows constants.
Use numeric121 through the existing integer branch; do not change the pinned
dependency or DE injector. Existing `/reload_hotkeys` command completed in
the user's running session; actual corrected F10 press/entry remains pending.
Current config SHA1173D21E6969AB0D934C158225AB482D2434D51216215561F5EF6906D74EF4B8.
Source/script/DLL/renovice.cfg unchanged. Original failed receipt retained.
Read [key repair receipt](evidence/key-code-repair-receipt.json),
[production repro](evidence/production-key-parser.txt) and
[repair tool](tools/repair-key-code.cjs). Failed binding bytes retained as
[rollback/Hotkeys.string-F10.json](rollback/Hotkeys.string-F10.json).

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| A new native key dispatch or game movement system is necessary | False | Existing owf_hotkeys.cpp/owfHotkey edge detection, foreground/input gates and owf_start_script route already provide key dispatch and script execution. |
| F10 is already occupied in the inspected installed config | False | Original JSON5 parse has one active binding, O; all other entries are comments. Original bytes retained in rollback/Hotkeys.json. |
| The Simulacrum loader path is available without inventing an API | True for source | Existing OpenWF Enter Simulacrum and Chat Commands samples contain the same Engine calls and exact C.level/game-rules paths. Native entry on V87 is still pending. |
| Editing the installed sample is persistent | False | Original sample warns startup replaces it; custom source is installed outside samples. |
| The script requests more than one native load per execution | False in replay | Actual ordinary Lua body emits args/level/rules/open once; logged-out case emits none; error case propagates without retries. |
| Config/parser replay establishes gameplay acceptance | False | JSON5 and Luau CLI mocks do not exercise live Soup/Pluto/Engine. Startup/F10 native entry PENDING. |
| Shortcut installation changes existing gameplay addons or diagnostics | False | V87 installed package verifier passes92 artifacts/20 prior entries after installation; DLL and renovice.cfg hash checks pass unchanged. |

Authoritative source: [RENOVICE Simulacrum F10.pluto](../../RENOVICE_SCRIPTING/HOTKEYS/RENOVICE%20Simulacrum%20F10.pluto).
Reusable verifier/installer: [install-and-verify.cjs](tools/install-and-verify.cjs).
Run with Node from any directory; default validates/prepares, `--install` performs
the separately user-authorized installation with game-closed/hash/old-binding
guards. It needs the installed JSON5 module and this workspace's Luau CLI.
Revalidation checks installed bytes, does not overwrite a conflicting F10 binding
or script, and does not replace rollback snapshots.

Read [deployment receipt](evidence/deployment-receipt.json),
[prepared config](evidence/candidate-Hotkeys.json),
[actual source replay](evidence/script-replay.luau) and
[replay output](evidence/replay-output.txt).
The exact original config is [rollback/Hotkeys.json](rollback/Hotkeys.json).
Game script creation was exclusive; no previous custom file was overwritten.
Rollback requires restoring that config and removing only the new custom script
with the game closed; account/server/metadata/raw DE addon state is unaffected.

Script SHA20B322C90FE03FDB3068485C57DEFDA15E9FE0CD6CD4F6E87FB9837F5EDFC950;
Hotkeys SHAB74EB92B49AEC1E44709DF3A04CD97B517B5A368A01E4F228F75BA651C39222B;
V87 DLL4BC3F2FF9E04ADD5B9626911DA356810C448B5B4AD06CC54DE6A2D51FC383AF5;
renovice.cfg480DC2E6F02F251D879F1798B1B202174E7F1A250E23A344CDAC772CB5EB808B.
