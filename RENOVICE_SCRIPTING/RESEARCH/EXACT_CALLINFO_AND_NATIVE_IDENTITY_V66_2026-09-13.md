# V66 exact CallInfo and native-call identity repair
The deployment record and complete hypothesis/results analysis are in
`RENOVICE_DEPLOYMENTS/EXACT_CALLINFO_AND_NATIVE_IDENTITY_V66_2026-09-13`.

V65 live evidence rejected three runtime assumptions: a `nativeCalls`-only
addon did not publish its target graph; `luau_CallInfo.savedpc` was declared at
+0x20 rather than the live-proven +0x18; and raw VM word 82 was compared
directly with decoded API-catalog instruction 64. The exact live width walk
proves word 82 is logical `CALL` 65 following `NAMECALL DamageDD` 64.

V66 corrects those generic boundaries without changing the Ice Wave addon,
any replacement body, Pluto, or server code. Offline/package verification is
required before deployment. Gameplay remains a separate live gate.
