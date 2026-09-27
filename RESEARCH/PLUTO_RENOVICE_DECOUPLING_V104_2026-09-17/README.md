# V104 Pluto and RENOVICE decoupling research — rejected live

This folder preserves the V104 candidate, its exact live failure and the V103
rollback. The central report is:

`Documentation/04-Runtime-and-UI/Pluto-RENOVICE-Decoupling-V104-2026-09-17.md`

## Final result

**V104 is live rejected. V103 was restored at
`2026-09-17T11:26:14.8840390Z`.** Exact `Limbo` search reproduced the previous
null-continuation crash after F10 had already proved that Pluto was running.
CDB shows the same `c0000005` execute-at-zero failure, first game return
`Warframe_x64+0x19815c9`, bucket, failure hash and fourteen game-module stack
offsets as V37. See `same-crash-family-v37-v104.md`.

## What the offline candidate proved

- The latest saved assertion reaches game `luau_pushstring` from Pluto GC and
  `owfUserdata.__gc`; diagnostics were off.
- The finalizer matches upstream u43, so it is not removed.
- Pluto is restored to the live `UpdateFlashMarkers` owner.
- The cached UI state and native Application-frame scheduler are inactive and
  absent from `main.cpp`.
- Pluto-originated nested game-VM executions bypass RENOVICE observation.
- A VM return that contained Pluto cannot become a RENOVICE F9, diagnostic,
  cleanup or target-rebind safe point.
- All focused gates and a zero-warning private x64 build pass.
- Transactional installation and the 33/33 post-install audit passed. Only
  `WTSAPI32.dll` changed.

## What live testing disproved

- The nested RENOVICE-observer bypass was not sufficient to make
  `UpdateFlashMarkers` a valid combined-runtime scheduler.
- Rejecting the containing outer return after Pluto ran could not protect a C
  frame that failed before that return completed.
- F10 success was scheduler-function proof, not UI-continuation acceptance.
- Exact-search acceptance failed, so later gameplay/F9/soak gates were not
  claimed.

Candidate SHA-256:
`E1CDC5BD2D36DBFA0DF30ED377B0853604008BC17933BE1DE34F41A21F53EC77`.

Installed at `2026-09-17T11:17:22.3298159Z`.

Rollback V103 SHA-256:
`738112A1FDE93685B0EBD982243EBBBBBC09E8C29E952FF542CED56BB6EA26BC`.

The installed game DLL and repository root artifact now both match that V103
hash. The rollback audit passed 33/33; all 32 non-DLL files were preserved.
