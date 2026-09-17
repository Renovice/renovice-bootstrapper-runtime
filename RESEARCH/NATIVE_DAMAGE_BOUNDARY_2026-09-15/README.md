# Native damage capture V80, 2026-09-15

User trigger: approximately 133 damage was visible and health changed, while
Brightbonnet had no battle record. Fix scope is reusable diagnostics; ability
gameplay, replacement scripts, the server, metadata tuning, and Pluto are unchanged.

| Hypothesis | Evidence and result |
| --- | --- |
| All health-changing damage necessarily reaches Luau DamageDD. | **FALSE.** NokkoPowerShroom stock source creates RadialDamageData, sets Viral index 11, then calls gRegion:RadialDamage. The V79 lane observes Lua per-target DamageDD. Earlier fresh-generation captures had no Nokko source, so budget exhaustion alone does not explain the omission. |
| A lower per-target native boundary can be observed without an ability logger. | **TRUE offline; live acceptance pending.** The SWIG DamageDD bindings in the exact installed image call native converters, then avatar virtual slots 0x330/0x338; the sampled live avatar delegates through DamageControl at +0x8d0. Native DamageControl slots 0xf8, 0x100, and 0x108 reach the registered handlers below. |
| Native GetHealth/GetShield bits are ordinary floating-point fields. | **FALSE.** Their observed accessor instructions decode integers using rotate 19, the field address shifted by 3, and 0xc55198a3. Float reinterpretation would corrupt these values. The observer accepts only that exact accessor shape at each actual vtable slot. Unknown accessor shapes produce null. |
| BaseAmount is an ordinary scalar field. | **FALSE.** The native packet embeds UpgradedValue at +0x60. It uses the cached value when flag 0x20 is set, otherwise rotate-30/address/0x635bf253 decoding, plus its addition field. Reads are observational and non-finite values yield null. |
| One short prologue fingerprint identifies the third handler uniquely. | **FALSE initially.** It also matched 0xcfda80, whose next instructions construct a different operation. The extended production signature includes the packet-constructor/next-load boundary and matches exactly once. |
| All three prologues can use a 13-byte stock detour trampoline. | **FALSE.** Handler 0xa255b0 reaches a RIP-relative load within that window. Its five-byte compact entry jump preserves the complete nine-byte push/sub prologue. Its entry/cave stay process-owned across F9; rollback restores the captured entry directly rather than following E9. |
| The fix records two enemies sharing the same packet independently. | **TRUE in the production observer harness.** Two distinct fake engine targets each go 1000 -> 867, with input 500 and health loss 133, four real native begin/end records, and unchanged packet bytes. Their analyzer roundtrip gives two complete transactions. This is offline proof, not a user gameplay result. |
| Native/Lua observations are independent damage grants. | **FALSE.** They are observation layers and can describe the same hit. The analyzer explicitly marks ObservationLayersAreAdditive=false. Parent native correlations preserve nesting. |
| A missing native return can silently pass. | **FALSE.** Analyzer regressions reject missing begin/return and pair by process/thread/generation/correlation; F9 resets cannot merge separate generations. |

Current executable SHA-256:
`CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93`.
The read-only native-analysis input and live game executable matched this hash.
Every installed native hook requires that hash, one unique signature match,
and its registered RVA. There is no unknown-build RVA fallback.

| Registered handler RVA | Observed lane | Entry jump / complete preserved prologue |
| --- | --- | --- |
| 0x1ee140 | DamageControl normal ingress, sampled virtual slot 0xf8 | 13 / 14 bytes |
| 0xc60240 | Shared function reached from sampled slot 0x100 | 13 / 19 bytes |
| 0xa255b0 | Copied-packet branch reached from sampled slot 0x108 | 5 / 9 bytes |

The exact native source boundaries and snapshot layout are specific to this
registered executable. Complete capture of every possible native subtype,
direct field write, future engine version, or deferred worker path is **not**
certified. An unknown Lua caller remains unknown; no guessed ability ownership.
Native life/dead/ragdoll/status/armor readers are not fabricated. Existing Lua
transactions retain their richer protected API readings.

Production: renovice/engine_damage.cpp, engine_damage_core.hpp, engine_damage.hpp.
The existing injection adapter supplies optional exact Lua caller context for
DamageDD and RadialDamage. It never enters Lua from the native observer.
DiagnosticsMode=off has the direct-stock fast path. An observer formatting or
preflight exception cannot suppress or repeat the stock call. Stock-raised
exceptions preserve their propagation. There is no polling, corpse retention,
queued damage, gameplay replacement, setter enforcement, or per-frame refresh.

Verification:

- verify_native_damage.ps1: actual production reader/observer with deterministic
  fake stock engine functions; separate enemies/shared packet, 133 loss,
  same-boundary nesting, filters, off, unchanged packet, analyzer roundtrip PASS.
- verify_injection_core.ps1 and verify_config_core.ps1: native decode/selection,
  explicit engine mode, existing injector/UI/F9 policy regressions PASS.
- verify_battle_log_analyzer.ps1: 12 native/Lua producer/reset/filter/completeness
  cases PASS.
- inspect_damage_boundary.py --verify-contract renovice/engine_damage.cpp:
  exact image hash, all three unique signatures and relocatable prologues PASS.
- Private x64 build PASS, zero warnings/errors. First build was rejected solely
  for a Git CRLF-to-LF warning on the manifest addition; its log is retained,
  the manifest was normalized to its declared eol=lf, and the new build passed.
- First standalone MSVC harness rejected warnings from unnecessary upstream
  headers. The harness now omits its unused image-detour dependencies; production
  code and packet observation are shared, and its /W4 /WX compilation passes.

Package: RENOVICE_DEPLOYMENTS/ENGINE_DAMAGE_CAPTURE_V80_2026-09-15.
Candidate DLL SHA-256:
`100789034378ED902D1A6D6553DF6610680C90CF7BF9F0C1AF04EC1F490364DB`.
V79 DLL/config and all nonvolatile CustomScripts hashes are preserved.

Live acceptance still required: restart into V80, damage two or more enemies
with Brightbonnet, then use an unrelated native weapon/projectile source. Review
native target identities, health deltas, exact source context where present,
incomplete/failed/suppressed events, and gameplay responsiveness. Only those
observed paths may be labeled live accepted. Toggle/F9/off acceptance is separate.
