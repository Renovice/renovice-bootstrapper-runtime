# V78 automatic battle observer lifecycle repair

## V77 live rejection

The first V77 test begins after byte `15779659` of the live diagnostic log.
The preserved snapshot contains 1,121 failed embedded-runtime loads and zero
canonical battle transactions. Each load reached a returned table (`result_tag=7`)
and then the host reported `pcall=-2`. This is a host-defined contract failure,
not an exception reported by the Lua VM.

Hypothesis: the observer's bytecode did not load or execute. **FALSE for this
recorded failure.** The returned table is present; `run_guarded` sets `-2` only
after a returned managed table lacks valid lifecycle or hook fields. The V77
observer returned `before`, `after`, and `reset`, but omitted required `activate`
and `cleanup` functions. The predeployment harness tested observation semantics
but did not assert this injector lifecycle requirement. That verification gap
is corrected.

Hypothesis: V77 successfully captured the user's Avalanche damage. **FALSE.**
The analyzer found zero battle records and zero transactions in the test. No
Avalanche damage formula or lack of leakage can be concluded from those logs.

## Repair and verification

V78 supplies one `automaticDamageReset` function as `activate`, `cleanup`, and
`reset`. It releases diagnostic correlations and pending transaction state only;
it does not write a gameplay packet or target property. The deterministic
runtime harness now asserts all managed lifecycle functions and confirms that
cleanup abandons a pending observation without changing health or shields.

Automatic capture also owns the registry trace root independently of a target
addon's optional `_T.RENOVICE_TRACE` field. An unrelated target reconciliation
or exact method filter may remove that shared field, but cannot clear the
automatic observer's root while automatic capture remains requested. The policy
test covers this third root owner. The broad test profile leaves the optional
method filter empty so explicit target loggers remain available too.

- Managed lifecycle and observation-only harness: **PASS**.
- DE compile/reparse: **PASS**, 7,545 bytes.
- DE self-roundtrip: **PASS**, 34/34 prototypes.
- Semantic IR: **PASS**, 34/34 prototypes.
- Embedded observer SHA-256:
  `E1C160DB372B3BDB3011837381557579ECBFFE1AFFC65B586F6A7B1BB73BD7CB`.
- Private x64 build: **PASS**, zero warnings/errors, 4,644,352 bytes.
- Candidate DLL SHA-256:
  `187E70B2744DD47BA0F7B0052085B7DE0B49D593A204B9FEFA25491A79BF3738`.
- Deployment and installed runtime/config/addon hashes: **PASS**.
- Live log baseline before restart: byte 16348164.
- Startup: **PASS**, observer `pcall=0`. Automatic battle capture: **REJECTED**, 91 raw-value guard errors and zero automatic transactions. Explicit Ice Wave: **45/45 COMPLETE**, zero arithmetic/restoration failures. See the V79 restricted-math research record.

## Avalanche question

Hypothesis: the gameplay addon intentionally multiplies all damage by Cold
stacks. **FALSE by source scope.** The unchanged, hash-pinned Ice Wave addon
requires the exact target module body `f62b70b45fc7fdf9`, prototype `7`, stock
base-write instruction `41`, and damage instruction `64`. It changes that
packet for one synchronous hit and restores a numeric stock amount afterward.
The runtime contains no ability-specific Cold-stack gameplay branch.

Hypothesis: no incidental state leakage can affect Avalanche in this live run.
**UNRESOLVED.** Missing battle evidence prevents that stronger claim. The
recovered stock Avalanche source separately applies an armor-reduction upgrade
before its damage phase and queries Cold stacks while calculating additional
proc count; the displayed damage alone does not identify the cause of a change.
V78 must capture target-local raw amounts and armor/status pre/post state for
both abilities before concluding whether the user's observation is vanilla or
a regression. No gameplay addon was changed for this diagnostic repair.
