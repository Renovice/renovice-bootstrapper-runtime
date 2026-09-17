# F9 Lua mutation boundary, V72

Date: 2026-09-14

## Scope

V72 corrects the generic F9 transaction boundary. It changes no addon,
replacement, Pluto script, server file, game bytecode, or gameplay rule. The
installed V71 Ice Wave addon remains byte-identical.

## Reproduced failure

The V69 runtime accepted an F9 request at an outer `vm_execute` return after
checking only the owner thread and shared Luau `global_state`. It then rebound
the unchanged ESO target generation and attempted to stage the changed Frost
target generation. The process faulted at `Warframe.x64.exe+0x80E044` before a
Frost target-generation PASS or rollback record was emitted.

The exact fault state was not a legal protected-call host:

- state `0x14F172B8D40`;
- `outtop=0x14EE20161A8` and `intop=0x14EE20161B8`, so the exposed output top was
  below the current frame base;
- the two current `CallInfo` entries pointed at tag-zero function slots;
- a lower C frame and Lua frame remained in the chain;
- access violation `0xC0000005`, null read at `0x10`.

F9 consumed the request before proving these properties. Changed generations
exercise loader execution and lifecycle staging, so they expose this defect
while byte-identical root reuse can appear to succeed.

## Hypotheses and results

| Hypothesis | Result | Evidence |
|---|---|---|
| F9 input detection missed the key. | **FALSE** | The log contains `F9 QUEUED` and `F9 DRAIN entered same-VM script boundary`. |
| The request reached a different Luau VM or OS thread. | **FALSE** | The existing VM and owner-thread gates accepted it, and the fault stack contains the configured Frost target key. |
| Sharing `global_state` makes coroutine stacks interchangeable. | **FALSE** | The accepted callback state had `outtop < intop` and invalid current function slots. Registry ownership is VM-wide; call stacks are per coroutine. |
| Always using `manager+0x20` is the universal fix. | **FALSE** | The preserved 2026-08-23 failure proved that manager state can itself be a suspended coroutine. |
| A protected Lua call may start on a yielded or active Lua frame after `vm_execute` returns. | **FALSE** | V61 already proved that post-return does not imply coroutine completion; the V72 crash state supplies direct stack evidence for F9. |
| Waiting for an idle base frame or a validated native host frame prevents this exact class of mutation. | **TRUE offline / pending live** | The production gate rejects nonzero status, missing or inverted stacks, invalid `CallInfo`, invalid current functions, and active Lua frames before consuming F9 or mutating the stack. Unit and source-order gates pass. |

## Generic correction

F9 remains a queued transaction. Every outer VM return still checks the pending
request, but Lua mutation begins only when all of these conditions hold:

1. exact captured VM and owner thread;
2. no active RENOVICE or nested VM execution;
3. thread status zero;
4. `stack <= intop <= outtop <= stack_last`;
5. aligned `CallInfo` within `[base_ci, end_ci)`;
6. either the idle base frame or a readable C/native host closure whose stack
   slots belong to the current state.

A yielded thread, active Lua frame, malformed frame, or inverted stack writes a
single reasoned `reload DEFERRED boundary=lua-mutation-host` record for that F9
sequence. The request remains latched. A later valid native host return performs
the complete transaction. The previous managed and target-addon generations
remain published until staging, lifecycle activation, cleanup, and commit pass.

The same gate is enforced again in `drain`, `apply_generation`, `run_chunk`,
`activate_target_addons`, `drain_pending_target_addons_for_vm`, and
`lifecycle_operation`. This makes the safety property local to every mutating
entry instead of relying on one caller.

## Verification

- Exact crash log and 67,697,156-byte minidump preserved in the V72 deployment
  package.
- Injection core: **PASS**, including the reproduced suspended, inverted-stack,
  invalid-frame, and active-Lua cases.
- Runtime source-order verifier: **PASS**. It proves the mutation gate precedes
  F9 latch consumption, runtime callback entry, loader allocation, and lifecycle
  stack mutation.
- Config, replacement, SWF, and Riven core suites: **PASS**.
- Private x64 build: **PASS**, zero warnings and zero errors, 4,598,784 bytes,
  SHA-256 `AE1E26EABB988EA166C5519AA382236C4C48444EEEAB30C033EED45BD19E7CB6`.
- Live F9 acceptance: **PENDING** after the V72 DLL is deployed and the game is
  restarted. Offline checks do not claim live process stability.

## Package

`RENOVICE_DEPLOYMENTS/F9_LUA_MUTATION_BOUNDARY_V72_2026-09-14`

The package contains the V72 binary and source, the exact installed V69 rollback
DLL, the crash logs and dump, pre/post deployment inventories, and a hash
verifier.
