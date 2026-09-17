# Target-environment hook infrastructure V27 — 2026-09-03

## Live evidence that rejected V26

The V26 process successfully loaded the target add-on and repeatedly published
Mallet ability-card rows. It never logged `afterMalletDamage`, a Mallet base
callback trace, or an Overguard mutation. The global-only native dispatcher was
therefore not reachable from the actual target module's global lookup.

The same process persisted a disabled Metronome replacement and queued a
reload, but emitted no `F9 DRAIN` or `F9 COMMITTED`. Reopening SCRIPTS showed the
persisted false value, proving the defect was live application rather than UI
state storage.

## Correction

The bootstrapper now installs its generic keyed hook dispatcher directly into
the exact target module environment already captured by the loader. This makes
module-to-add-on attachment bootstrapper-owned and reusable without depending
on volatile `_T` identity or assuming that `_G` is the module's lookup table.

Content-keyed hook shims are recognized by a generic
`.internal-hook-shim.` filename convention. The historical `explicit hook shim`
name is recognized for migration. Such files are always loaded and excluded
from the SCRIPTS inventory. Only the add-on/replacement behavior remains a user
toggle.

F9/Confirm now has a fallback boundary on the native function behind
`UpdateFlashMarkers`, not a replacement of its Lua/SWIG method-table entry. The
stock function runs first. The detour then polls F9 and checks one atomic flag.
No Lua is executed on idle frames; only an explicitly queued transaction drains.
This does not restore the disproven always-on background scheduler.

## Current conclusion

- **True live:** V26 card publication was independent of gameplay attachment.
- **True live:** V26 persisted toggle state but did not apply its queued reload.
- **True offline:** V27 hides and force-loads target hook infrastructure.
- **True offline:** V27 installs/readbacks the dispatcher in the exact target
  module environment.
- **True offline:** V27 leaves the method-table pointer stock and avoids idle Lua
  execution.
- **Pending live:** gameplay Overguard, true disable/re-enable, F9 completion,
  and exact Arsenal-search stability.
