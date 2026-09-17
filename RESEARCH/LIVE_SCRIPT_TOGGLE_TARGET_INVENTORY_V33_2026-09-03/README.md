# Live script toggle target inventory V33 - 2026-09-03

## Accepted V32 evidence

The correct live game target was
`C:/Users/Bartek/OneDrive/Dokumenter/Warframe`.

The user reported that search terms including `00` and `Limbo` no longer
crashed. The retired `UpdateFlashMarkers` path remains untouched.

## Hypothesis results

| Hypothesis | Evidence | Result |
|---|---|---|
| The V32 safe scheduler randomly loses Metronome reloads. | Every actual `decision=confirm` transaction immediately progressed from the expected `vm-execution-active` deferral to drain, module refresh, and commit. | **False live.** |
| Missed Metronome changes are never submitted. | Each missed attempt ended as `flag_tag=1 decision=cancel`; no reload was queued. The stock Generic Settings module renders Confirm while inactive unless explicitly activated. | **True at the observed boundary.** |
| Mallet target-addon bytecode fails during live enable. | Enabling committed a generation with one target addon, but logged `target_pending=0`; no target-addon staging was attempted. | **False at this boundary.** |
| A disabled-at-start target is not retained for later activation. | Startup loaded body key `08faf07b504d058f` while its target addon was disabled. The active-only target lookup recorded no module identity, so the later enabled generation had nothing to queue. | **True live.** |

## V33 correction

Target-addon discovery is now split from execution policy. A valid installed
target-addon filename contributes its exact body key to a sorted committed
inventory even when the script is disabled. Its bytecode is still excluded
from the active generation while disabled. The natural loader can therefore
retain the already-loaded module identity, and a later Confirm can queue the
normal target-addon lifecycle transaction without a bootstrapper-specific
script or a game restart.

The internal Scripts bridge now keeps the stock Generic Settings Confirm
control both visible and active. Confirm and Cancel still reach the existing
nil/true completion contract; no custom button and no auto-commit path were
introduced.

V33 remains pending live acceptance for target addon OFF -> ON -> OFF and
replacement OFF -> ON -> OFF in one process. Search stability remains a
separate required regression check.

## Built and deployed artifacts

The private x64 build passed with zero warnings and zero errors. V33 DLL hash:
`0165E482AA2469A136C8392FEB7F42CBE14E2C4F4D0B98EEA68B9780F3B8748E`.
The rebuilt bridge hash is
`153E5E580FB0D98DDD63C0DE92D46398F6B87B721E69B51885719B50EEF04C82`.
Both were deployed to the correct OneDrive game folder; the prior V32 DLL and
bridge were preserved together under the V33 deployment rollback directory.
