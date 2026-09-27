# U44_BUILD_PROFILE_2026-09-27

## Result
U44 repair candidate installed into `Warframe 23.09.2026`. DLL SHA256 `86f0efc943b60785b8edecf5e3f921abdf5ee560fe925a203e60469e96b902db` (4,884,480 bytes). All seven Inject files and nine root replacements updated; Scripts state IDs migrated without changing enabled values. Original 18 files preserved in `before/deployed`. Hotfix.owf and renovice.cfg are byte-identical; Diagnostics remains false. Live menu/gameplay/F9 acceptance is pending; no game process was running during deployment.

## Hypothesis -> evidence -> conclusion
- **SUPPORTED:** U43 bytecode/native names and stock target IDs prevented U44 compatibility. Bridge PushChildMovie/Execute/Close hashes differed; prototype graph gate excluded U44; callback decoders/helpers used U43 instruction numbers. Fixed through shared opcode/build profiles and generic existing runtime paths.
- **SUPPORTED:** this also required declarative binding updates. Frost proto 7 callsites 41/52/64 become 42/53/65 (logical instructions, not word offsets). Survival proto 64 becomes 67; pickup config U22, elapsed U19 and reward config U70 retain their roles. Mallet proto18, Interception proto35 and ESO proto25 instruction10 retain their roles. Current stock hashes are in `artifacts/targets.json`.
- **SUPPORTED:** native undump retains code +0x10, children +0x18, code count +0x88, child count +0x8c, bytecode ID +0xa8. Correct old executable is the pinned cca46d60 U43 input, not `client-before`, which is already U44. Interpreter dispatch correspondence covers 86 handlers and agrees with all 75 independently paired corpus opcodes. All 71 opcodes actually used by the deployed scripts and embedded helpers fall within that independently paired set.
- **SUPPORTED:** U44 TopMenu retains Initialize's 23 captures, builder at U14, builder's 59 captures and final dispatcher U58. No ownership relaxation or parallel scheduler was needed.
- **INCONCLUSIVE until live test:** cards/effects, native callbacks, F9 and long-session stability. Static gates cannot prove gameplay.

## Changes and validation
- Toolchain: `recompile-u44` plus explicit source alias map; reversible structured profile conversion. Existing U43 modes preserved. Unknown/ambiguous aliases reject.
- Runtime: version-selected embedded callback/battle helper bytecode, CALL/NAMECALL/AUX decoding, and the verified U44 prototype layout. Universal API, ownership, protected-call and capability-local failure boundaries retained. No ability-specific C++ branch, polling, Pluto rewrite or diagnostics activation.
- Eight replacements rebase only their original numeric/boolean edits onto current stock instructions using unique surrounding anchors. Riven replacement preserves all 77 current UI prototypes and adds only the prior seven-instruction hyperlink callback registration (nine words), with updated constants and retained line metadata. Native locking/splicing UI is retained; no new client Riven integration claimed.
- Full private runtime build PASS, zero warnings/errors; toolchain build/selftests PASS. Injection core includes new U44 CALL/RETURN/AUX-boundary and opcode bijection tests and retains U43 checks.
- Client hash/signature gates PASS; current TopMenu gates 74/74 PASS. All 16 script container roundtrips and closure maps PASS. Five unchanged addons invert to exact prior bytes; two source-rebound addons match their U43 compilation after inverse lowering. Installed admission: 7 supported, 0 unsupported.
- Initial strict code matching missed cache-byte changes; only known inline-cache operands were normalized for correspondence. Conflicting hash matches were excluded, not guessed. Old replacement anchors that drifted were reviewed rather than accepted blindly.
- Deployment's initial delete-based transaction was blocked by automatic approval review. A no-delete deployment moved each original into the rollback folder and passed installed hashes.

## Future updates
The authoring/modding API is universal; native layouts and compiled bindings are build-specific. Use `repos/toolchains/de-luau-toolchain/profiles/u44/README.md` and `profile.json`. Rebuild named source for the selected profile, bind exact stock modules by logical path, and audit prototype/upvalue/callsite changes. Never rename an old body key or widen a VM gate alone. Do not feed U44 bytecode to the U43 decompiler without profile normalization. The alias map is an evidence-backed subset, not a claim of a complete recovered API.

Evidence: `artifacts/deployment-result.json`, `deployment-plan.json`, `package-validation.json`, `opcode-coverage.json`, `native-dispatch-map.json`, `addon-callsite-rebase.json`, `replacement-rebase.json`, `riven-ui-rebase.json`, `topmenu-ownership.json`, and build/verification logs. `scripts/` contains the bounded rebase/research procedures.
