# V37 and V104 exact crash-family comparison

## Hypothesis

V104's exact-`Limbo` crash is the same old Luau null-continuation failure seen
when V37 restored Pluto to `UpdateFlashMarkers`, rather than a new fault caused
by an unrelated V104 feature.

## Evidence

| Field | V37 | V104 |
| --- | --- | --- |
| Exception | `c0000005` | `c0000005` |
| Operation | execute | execute |
| Target | `0x0` | `0x0` |
| First game return | `Warframe_x64+0x19815c9` | `Warframe_x64+0x19815c9` |
| Failure bucket | `SOFTWARE_NX_FAULT_NULL_INVALID_POINTER_EXECUTE_c0000005_Warframe.x64.exe!Unknown` | same |
| Failure hash | `{b2e2f003-f1a9-53a7-3fe6-e89cb3ca4935}` | same |

Both stacks contain the same game-module offsets in the same order:

```text
0x19815c9
0x4e54a4
0x8f3a49
0x18b08c3
0x698ada
0x5922f4
0xf8aae6
0x16b8e54
0x187eae4
0x10a8494
0xed7436
0x18fcc28
0xe6eaf9
0x1c3ec5a
```

The V104 call-site dump records:

```text
Warframe_x64+0x19815c1  mov rax,qword ptr [rax+20h]
Warframe_x64+0x19815c5  xor edx,edx
Warframe_x64+0x19815c7  call rax
Warframe_x64+0x19815c9  ...
```

The exception context has `rax=0`. V21/V22's runtime decoder independently
identified this resume path's active generic SWIG/namecall C closure and
reported `c.cont=0`.

## Result

**True.** V104 reproduced the same crash family as V37. The matching failure
hash and complete module-relative stack eliminate ASLR as an explanation and
make a coincidental unrelated crash implausible.

The live result also rejects the V104-specific hypothesis that bypassing
RENOVICE only during nested Pluto bridge calls was the missing correction.
V104 still ran Pluto inside the live `UpdateFlashMarkers` C/namecall frame, and
the containing DE interpreter execution had already entered RENOVICE before
the Pluto activity scope existed.

## Primary evidence files

- V104: `live-failure-2026-09-17-132205/cdb-analyze-v104.txt`
- V104 call site:
  `live-failure-2026-09-17-132205/cdb-callsite-v104.txt`
- V104 trigger/identity:
  `live-failure-2026-09-17-132205/capture-manifest.json`
- V37:
  `../SEARCH_UI_INTERACTION_FREEZE_2026-09-06/captures/20260906-231404-566Z/cdb-analyze-v37.txt`
