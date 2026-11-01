# OBJECT_REFLECTION_V1 live test (RENOVICE.object), 2026-10-31

Not deployed. Use only after the user has installed a DLL built with OBJECT_REFLECTION_V1.

Files:

- `ObjectReflectionDirectorTest.luau`: source (U44 raw-hash source, seed `768e5ed0`).
- `ObjectReflectionDirectorTest.lua_B`: compiled with `derecomp recompile-u44` (toolchain
  `5cf8847`, derecomp `14c22656...`), `de-roundtrip` FULL BODY identical. 2,132 bytes,
  sha256 `6a5cde5ea7c3659331829ff6be946930924ac64771c5785a24c389080cf8f262`.

Steps (user):

1. Logs.cfg: `Logging=true`, `Verbose=true` (the per-call `RENOVICE OBJECT_REFLECTION CALL` lines are Verbose).
2. Copy `ObjectReflectionDirectorTest.lua_B` into the Inject lane (`OpenWF/LuaScripts/Addons/`, or
   `OpenWF/CustomScripts/Inject/` on layout V1) of the game folder you play from. If the SCRIPTS
   menu lists it as disabled, enable it there.
3. Start the game. The RENOVICE log must contain `RENOVICE OBJECT_REFLECTION PASS version=1 ...`
   and, at each generation, `RENOVICE OBJECT_API PUBLISH PASS field=_T.RENOVICE ...`.
4. Enter any normal mission (enemies spawning). Press F9 once. The script runs at the commit.
5. Collect: the EE.log lines with `RENOVICE_OBJECT_TEST`, and the RENOVICE log lines with
   `OBJECT_REFLECTION` / `OBJECT_API`.
6. Remove the `.lua_B` and press F9 (or restart).

Expected:

- `api=present version=1`; `fields count=` about 50; first rows such as
  `ActiveAreaAhead type=float`, `ActiveZoneAhead type=bool`, `BreachInfluence type=symbol`.
- `get HardMaxAICap=<n>` (a number) and `get mSpawnTimer=<float>` (engine spelling accepted).
- `dump bytes=<n> first=...` in `Key=Value` form.
- `set HardMaxAICap=<n-1> changed={HardMaxAICap} ... readback=<n-1>`, then
  `restore ... changed={HardMaxAICap} ... readback=<n>`.
- negatives: `field-not-found`, `value-type-mismatch expected=number`, `argument-1-not-engine-object`.

What each result proves (and not more): PUBLISH PASS proves publication; the test lines prove the
calls reached the engine archive path and read back the field memory. They do not prove gameplay
effect of a changed director value (watch enemy count only as an additional, separate observation).
A crash or `CALL FAIL` line is the result to report.
