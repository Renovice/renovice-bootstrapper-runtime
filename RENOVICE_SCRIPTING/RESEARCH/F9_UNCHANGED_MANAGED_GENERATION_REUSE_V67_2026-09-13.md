# V67 repeated F9 managed-generation repair

The live V66 process accepted and committed one F9 transaction. A second F9
was queued and drained on the same DE VM boundary, then the unchanged internal
SCRIPTS bridge returned no lifecycle table (`pcall=-1 result_tag=8`). The
managed generation rolled back before target-addon staging. This separates the
failure from the Ice Wave addon and from F9 key detection.

V67 retains the full F9 snapshot and atomic commit model. It reuses a managed
generation only when sorted filenames, complete bytes, and active lifecycle
root names all match exactly. Every managed membership, name, byte, or root
change continues through the existing lifecycle transaction. The reload log
states `managed_generation=reused` or `managed_generation=replaced`.

The exact reason V66's redundant loader execution failed on that particular
second call remains unproven. V67 removes the call only where it has no work to
perform. Offline decision tests, the seven-file live Inject inventory, all
runtime/UI/dependency/manifest gates, and a zero-warning x64 build pass. Live
acceptance required two separate F9 commits in one restarted process.

Live acceptance passed on 2026-09-13. The restarted V67 process recorded nine
separate F9 transactions, generations 2 through 10. Every transaction reported
`managed_generation=reused`, `one_shot_failures=0`, and `target_pending=0`,
then reached `RENOVICE F9 COMMITTED module_refresh=PASS`. The same session
contains zero F9 rollbacks and zero addon-fatal records, while PID 2968 remained
alive and responsive. This proves repeated unchanged-input F9 reload acceptance
for the tested live inventory. It does not claim live acceptance of a managed
file byte change, rename, addition, or removal; those mutation branches retain
their offline decision-test coverage.

Live evidence:
`RENOVICE_DEPLOYMENTS/F9_UNCHANGED_MANAGED_GENERATION_REUSE_V67_2026-09-13/evidence/v67-live-accepted-20260913-150117/renovice_f9_events.txt`.

Package:
`RENOVICE_DEPLOYMENTS/F9_UNCHANGED_MANAGED_GENERATION_REUSE_V67_2026-09-13`.
