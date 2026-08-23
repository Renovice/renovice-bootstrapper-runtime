# RENOVICE Riven-lock source port

## Scope

This slice ports `RV-001` through `RV-006` into the authoritative source. It
keeps the working SetStringVariable route and leaves the disproven direct field
hook (`RV-007`) retired. No DLL was deployed and no live game/server test was
run.

## Hypotheses and results

| Hypothesis | Evidence | Result |
|---|---|---|
| `riven_lock.cfg` is unused and can be deleted. | The deployed companion checked it before both wrapping and click behavior. The active file is present. | **FALSE** |
| Existing raw U43 RVAs are required. | All five native functions have signatures matching exactly once in the installed executable. | **FALSE** |
| The old click classifier consumed only RENOVICE links. | It accepted any clicked href containing the substring `lock` and parsed with `atoi`. | **FALSE** |
| Exact href parsing can preserve behavior without catching unrelated GFx links. | The source accepts only `#onHyperlinkPressed:lock0` through `lock31`; boundary tests pass. | **TRUE (offline)** |
| The gate requires filesystem polling on every UI call. | The source caches the gate and rereads it only at startup or F9. | **FALSE** |
| Immediate `SetStringVariable` redraw inside a GFx click is safe. | Earlier live work recorded re-entrant access violations. | **FALSE** |
| Glyph recolor now plus deferred safe-boundary redraw preserves the intended UX. | The source keeps the proven immediate glyph-memory recolor and defers full redraw to the next SetStringVariable call after validating the current path/context. | **TRUE (offline structure; live pending)** |

## Runtime flow

```text
startup/F9
  -> cache existence of CustomScripts/riven_lock.cfg

SetStringVariable
  -> gate off: stock function only
  -> detect reroll-only context and exact card path
  -> reject definite Warframe mods/arcanes/challenge text
  -> wrap each stat segment with an exact lock hyperlink
  -> cache copied path/description plus validated movie/setter context

GFx hyperlink press
  -> exact RENOVICE href only
  -> toggle a validated 0..31 bit
  -> recolor the clicked live glyphs without GFx re-entry
  -> asynchronously POST deterministic JSON to configured OpenWF host/port
  -> queue deferred full redraw

next safe SetStringVariable boundary
  -> redraw only on a current reroll/choice path
  -> otherwise invalidate the cached Scaleform context
```

The POST body remains `{"indices":[...]}`, but the destination now follows
OpenWF's configured `server_host`, HTTP/HTTPS port, and TLS setting instead of
being permanently hard-coded to `127.0.0.1:80`.

## Safety properties

- exact installed-build signatures; no raw-RVA fallbacks;
- a missing gate makes hook behavior inert with zero per-call filesystem work;
- precise href namespace and index bounds;
- atomic lock mask and deferred-redraw latch;
- copied path/description strings, mutex-protected render context;
- pointer and size checks before span/glyph writes;
- no synchronous network request on the UI thread;
- partial hook installation is rolled back;
- navigation away invalidates the cached Scaleform context;
- the retired field-memory HTML hook is not installed.

## Offline gates

- Riven core: 9 checks, 0 failures;
- GFx dispatcher signature: exactly 1 match;
- SetStringVariable signature: exactly 1 match;
- movie/string/type argument helpers: exactly 1 match each;
- private x64 build: warnings 0, errors 0, no companion import;
- built SHA-256: `16b14e8793155d1873dd7360587ae4bd8d73bfcdc129147ee14a01c6dc3e3afd`.

The combined final gate and definitive DLL hash are recorded in
`FOUR_SYSTEMS_OFFLINE_ACCEPTANCE.md`. Live checks must cover gate off/on, wrap
scope, lock/unlock color,
server persistence, reroll, navigation away, and repeated clicks.
