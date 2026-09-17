# V44 gameplay regression: Lua-only damage callback ABI

Evidence: deployment PROTO_FAMILY_TRACE_V44_2026-09-07, capture
captures/20260907-024024-726Z, process 4520. User reported abnormal Mallet
damage/animation and zero Overguard; card remained functional.

| Hypothesis | Result and evidence |
|---|---|
| Exact descendant matching reaches the stock gameplay caller. | TRUE live. Attempt 1 matches frame 1, prototype 0000028A32D8C8A0, present in the recorded 22-node target family. |
| Stock SetSourceObject completes. | TRUE live. source.native-return results=0. |
| The engine accepts the injected C callback. | FALSE live. EE.log line 9086: `Error (arg 2): expected lua function (not c) but got function`, BardMusic.lua::BoxLoop(634). |
| Attachment failure is isolated from stock execution. | FALSE. Trace stops at damage.install.native-enter; the direct native call has no protected Lua frame. BoxLoop reports a script error. |
| The Overguard/threat body caused this run's regression. | FALSE for this attempt: neither damage.callback.enter nor dispatch.enter occurred. |
| Fixing the ABI proves Overguard or universal addon support. | UNPROVEN. Requires subsequent callback and gameplay evidence, and another independent target. |

The old fault dump in this capture predates this process. It is not V44 crash
evidence. The same incorrect C closure construction exists in the stock
SetDamageCallback decorator and must be repaired there too.

Correction: embed a content-independent Lua callback constructor in the DLL,
load it through the existing DE loader, and hand the engine only a verified Lua
closure. Authored addons remain unchanged standalone files. This internal ABI
adapter has no ability behavior and does not replace or regenerate stock code.
Call addon-installed setters through protected Lua frames. Associate source
and stock callbacks through weak receiver keys; never infer source from an
arbitrary stock upvalue. Record missing association, factory errors, callback
kind, native status, and subsequent dispatch separately.
