# Video Project 4: V54 Mallet timing analysis

## Evidence identity

- video: `C:\Users\Bartek\OneDrive\Skrivebord\Video Project 4.mp4`
- SHA-256: `A743F35EE217EF18D1107CE473ED397E54BB4F15DC6C14539FAC559B515026F5`
- video properties: H.264, 852x480, 30 fps, duration 22.2 seconds
- matching runtime: V54, process 14172
- post-boundary log capture SHA-256:
  `DEF39E62D1102CB353D3949344DCAB1EFE34C82E5F97DD64910133C56ACCAEA8`

Frame and contact-sheet evidence is stored under
`RENOVICE_DEPLOYMENTS\MALLET_CALLBACK_TARGET_STATE_TRACE_V54_2026-09-08\evidence`.

## Hypothesis: the reported post-death Overguard gain is only perception

Result: **false**.

At approximately 14.0 seconds the Frontier Lancer name and health bar are no
longer rendered. Overguard is 3223. It rises to 3313 at approximately 14.2
seconds and to 3397 at approximately 14.6 seconds, then remains 3397. The clip
therefore contains two post-death-looking increments separated by the normal
roughly 500 ms Mallet cadence.

The old `3.6K` damage number remains visible through this interval but is
fading. Its continued presence cannot establish a fresh damage event.

## Hypothesis: the addon dispatcher queues the grants

Result: **false for the observed native dispatch path**.

The V54 log records no `dispatch.error` or `pcall.error`. Sampled positive
callbacks pass from `damage.timing.receive` through `dispatch.return` at the
same millisecond. Performance windows contain four positive callbacks per two
seconds while the target is active, followed by one final positive callback
and then zero positives. Maximum measured wrapper time is 1468.4 microseconds.
There is no multi-tick injector queue or delayed provider scan in this path.

## Hypothesis: V54 recorded target death and health state

Result: **false**.

The direct target-environment field installation logged PASS, and the addon
loaded and granted Overguard, but the addon emitted zero `RENOVICE TRACE`
records. The compiled addon did not resolve the injected field as a callable
global. V54 therefore cannot classify the callback target state.

## Next discriminating test

V55 returns the event, correlation, exact target, reported damage, `IsKilled`
availability/result, and `GetHealth` availability/result directly from the
`afterDamage` hook. The generic dispatcher records those eight returned values
in Diagnostics mode and then discards them. This avoids the failed global-field
lookup and does not change Mallet's grant decision.

Possible results:

- `grant`, `IsKilled=false`, `health<=0`: the engine is issuing a positive
  resolved-damage callback for a zero-health target; filtering that exact
  upstream callback state is the narrow fix.
- `skip-killed-target`: the existing killed check is already rejecting the
  callback, so the visible gain came from an earlier accepted state change.
- `grant`, `health>0`: the target is still live at the callback boundary, so
  later visual disappearance and Overguard presentation are downstream of the
  addon decision.
