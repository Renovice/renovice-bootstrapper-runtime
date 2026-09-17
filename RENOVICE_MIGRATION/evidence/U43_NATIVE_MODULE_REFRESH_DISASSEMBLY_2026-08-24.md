# U43 native module refresh disassembly evidence

Date: 2026-08-24

Client: `Warframe.x64.exe`, build `2026.07.11.15.28`, SHA-256
`87D3C0F946D6FFF8B95567B2FCE396D407721BC86CAFABDAFC44EE8F60FB92B0`.

The exact-client verifier locates the module loader once at raw file offset
`0x9bf110`. The `.text` section has raw offset `0x400`, RVA `0x1000`, and image
base `0x140000000`, so the live virtual entry is `0x1409bfd10`.

Relevant observations from LLVM 20 `llvm-objdump`:

- `0x1409bfd36` reads bytecode size from descriptor `+0x40`.
- `0x1409bfd39` reads the bytecode pointer from descriptor `+0x38`.
- `0x1409bfd4c` and `0x1409bfd53` clear those two descriptor fields, proving
  that the loader takes ownership of the supplied bytecode buffer.
- `0x1409bfd7b` reads the manager's Luau state from manager `+0x20`.
- The success path iterates the manager's loaded-object list rooted at manager
  `+0x38`.
- `0x1409c0000` through `0x1409c0007` compares the descriptor stored by an
  existing script object with the exact descriptor argument supplied to the
  loader.
- Matching objects are rebuilt/refreshed through the native update path ending
  in the manager/object call at `0x1409c0089`.
- `0x1409c0165` sets success and `0x1409c0184` returns it in `AL`; the loader's
  correct ABI return type is therefore `bool`, not `void`.
- No instruction in the loader reads descriptor `+0x58`. Treating that field
  as a persistent module environment was an unsupported carry-over from the
  old companion injector.

## Hypotheses

| Hypothesis | Evidence | Result |
|---|---|---|
| Descriptor `+0x58` identifies the cached module environment. | The exact current loader never reads it; live logs showed it null before and after every configured replacement load. | **FALSE** |
| Fabricating a new descriptor can refresh existing script/UI objects. | Native matching uses pointer identity against the descriptor retained by existing objects. A fabricated pointer cannot match. | **FALSE** |
| Reusing the captured original descriptor with new owned bytecode reaches the game's native refresh machinery. | The loader consumes `+0x38/+0x40`, finds existing objects by exact descriptor identity, and invokes its object-update path. | **TRUE OFFLINE; LIVE TEST REQUIRED** |
| The loader detour may use a `void` ABI. | The function explicitly returns a success byte in `AL`. | **FALSE; corrected to `bool`** |

Reproduction commands:

```powershell
llvm-readobj.exe --sections Warframe.x64.exe
llvm-objdump.exe -d --start-address=0x1409bfc80 --stop-address=0x1409c0200 Warframe.x64.exe
```

This evidence changes the hot-reload architecture. F9 now queues the original
`(manager, descriptor, global_state, owner_thread)` identity and asks the
native loader to reload that descriptor. It no longer fabricates a descriptor
and no longer requires the disproven `+0x58` environment.
