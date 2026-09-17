# Survival coroutine resume crash: V60 rejection and V61 repair

Date: 2026-09-09

## Observed result

The V60 Survival target addon loaded into exact body `1e3647332a578b78` and
prototype 64. Stock mission initialization reached `WAIT_FOR_HACK`; the alarm
panel hack was accepted; EE.log printed `Survival: Starting survival`. The game
then raised a native access violation about 4.4 seconds later.

The last RENOVICE events were `luaCalls.64.before` and
`luaCalls.64.after`. There was no preceding Lua assertion. The fault record is
`0xC0000005`, reading address `0x8` at `Warframe.x64.exe+0x198F374`; the stack
returns through the V60 `vm_execute_detour`. The failing instruction follows a
null VM/prototype pointer. This makes a bad timer literal and the stock keypad
path false as causes.

## Root cause

**Hypothesis:** returning from the interpreter means the observed prototype has
completed.

**Result: FALSE.** Luau returns from its interpreter when a coroutine yields or
breaks as well as when the invocation completes. The exact thread prefix stores
`status` at offset `0x03`; nonzero status identifies a suspended or failed
boundary. V60 unconditionally called the addon `after` callback on that same
state. A new protected Lua call at that point changed the state expected by the
later stock resume. The dump then captured a resume with an invalid call frame.

## V61 correction

The generic runtime now exposes the existing `status` byte in `luau_State` and
allows `luaCalls.after` only when the exact target call exists, status is zero,
the active CallInfo bounds validate, and the exact target closure is absent from
the active frame chain. This final frame check matters because the interpreter
may return to native/JIT execution with status zero while the target call is
still active. All rejected boundaries log `luaCalls.<prototype>.after.skipped`
with `thread-status`, `callinfo-scan`, or `target-frame-active`, then return
without invoking Lua. There is no mission or ability name in this rule.

The Survival addon no longer declares `after`. Its three edits all occur in
`beforeSurvivalUpdate`: bind the two verified stock configuration tables and
add the pickup delta to elapsed reward time before stock consumes the pickup
counter. A later `before` invocation observes the stock reset and resets the
addon-local delta counter.

## Verification boundary

- Injection core: PASS, including terminal accept plus non-exact, status 1/2,
  invalid CallInfo scan, and still-active-target rejection cases.
- Private x64 build: PASS, zero warnings/errors.
- Ability Studio: 78/78 self-tests PASS.
- Survival artifact: compile/reparse PASS; exact DE container roundtrip PASS;
  semantic plan PASS; strict API PASS with zero unknown calls.
- Package and deployed hashes: PASS.
- Existing Mallet addon, SCRIPTS bridge, script policy, configuration, Pluto,
  and replacement files: unchanged by deployment and hash-guarded where part of
  the package baseline.
- Live V61 Survival acceptance: pending a complete client restart and mission
  test. Build/package/deployment proof does not establish gameplay acceptance.

Exact artifacts and rollback are under
`RENOVICE_DEPLOYMENTS/SURVIVAL_COROUTINE_RESUME_FIX_V61_2026-09-09`.
