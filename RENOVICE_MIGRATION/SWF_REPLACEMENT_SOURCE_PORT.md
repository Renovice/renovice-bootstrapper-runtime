# RENOVICE SWF replacement source port

## Scope

This slice ports `SW-001` through `SW-004` into the authoritative source. The
installed `CustomScripts` directory currently contains zero `.swf` files, so
the subsystem builds but remains behaviorally disabled until a replacement is
present. No DLL was deployed and no live game test was run.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| The old `RIVEN_DEC_BUMP` enabled larger replacements. | Its value was exactly the stock decompressed size (`28704`), so the TOC write was a no-op. | **FALSE** |
| The exact Oodle and parser hooks can be recovered without raw-RVA fallback. | Both source signatures match exactly once in the installed `2026.07.11.15.28` executable. | **TRUE (offline)** |
| Content-keyed matching can remain inert for unrelated Oodle traffic. | Only a full original decompressed-body FNV match arms an overlay; the parser additionally requires an `FWS` header and matching stock `FileLength`. | **TRUE (offline)** |
| Multiple replacements can coexist without a global 16-slot pointer array. | Armed entries own shared immutable bytes, prefer the originating thread, and reject ambiguous cross-thread equal-length matches. | **TRUE (offline)** |
| Arbitrary-size replacement is safe without cache metadata. | The decompression hash alone does not identify the cache TOC entry before decompression. | **FALSE** |
| Arbitrary-size replacement is deterministic with explicit metadata. | An optional `.swf.toc` sidecar supplies the exact cache offset, compressed size, and stock decompressed size; the hook changes only a triple match and only grows capacity. | **TRUE (offline)** |

## Replacement contract

Place an uncompressed SWF at:

`<original-body-fnv16> (optional annotation).swf`

The file must begin with `FWS`, be at most 16 MiB, and its little-endian
`FileLength` field at byte 4 must equal the actual file size. Invalid or
duplicate entries reject the complete SWF transaction and retain the previous
snapshot.

For a replacement larger than the stock decompressed allocation, add:

`<same filename>.swf.toc`

with exact values:

```text
cache_offset=0x87fbe03
compressed_size=5545
decompressed_size=28704
```

The capacity written is `max(stock size, replacement size)`. Plain replacements
that fit the stock allocation do not install the `NtReadFile` hook. Adding the
first any-size rule or enabling the whole SWF system after startup requires a
restart; F9 reports a rejected transaction instead of silently leaving a
partially active configuration.

## Safety properties

- exact installed-build signatures; no raw-RVA fallback;
- no hooks at all when the SWF set is empty;
- immutable generation snapshots retain byte lifetime through concurrent hooks;
- parser overlay validates source, destination, stream object, capacity, and
  `FWS` header before writing;
- the parser receives `datasize=N`, `cursor=begin`, and `end=begin+N`;
- partial hook installation is rolled back;
- old experimental call-stack diagnostics were not ported to production.

## Offline gates

- SWF core: 9 checks, 0 failures;
- exact-client Oodle signature: 1 match;
- exact-client parser signature: 1 match;
- private x64 build: warnings 0, errors 0, no companion import;
- built SHA-256: `463faccc31bd80448a3c2a590275f96b38b7c9488b96821b6cfab12085de8937`.

The final live test needs at least one known stock/replacement pair. The active
directory has none, so live parity is deliberately not claimed.
