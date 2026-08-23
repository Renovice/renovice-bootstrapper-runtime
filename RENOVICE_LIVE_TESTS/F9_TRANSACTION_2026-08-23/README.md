# Live F9 transaction fixtures

These fixtures test the source-built bootstrapper's ordinary Inject and managed
addon paths without touching any ability replacement.

## 2026-08-23 crash boundary

The original live run reached generation one, but pressing F9 with generation
two staged crashed the DE VM before a new generation commit. The exact dump is
documented in `RENOVICE_MIGRATION/F9_LIFECYCLE_CRASH_2026-08-23.md`. It proved
that lifecycle calls were incorrectly executed on `manager+0x20`, which may be
a suspended coroutine, instead of the current DE callback state. Generation
two from that run is preserved under `crash_live_payload` and is not a passing
artifact. The sequence below restarts at generation one with the corrected DLL.

Sequence:

1. Deploy `managed_gen1` plus `verify_gen1`; F9 must emit `RENOVICE_F9_GEN1_OK`.
2. Replace with `managed_gen2` plus `verify_gen2`; the addon requires the old
   managed token to have been cleaned, and the ordinary verifier writes `2002`.
3. Replace only the addon with `managed_invalid`; F9 must reject the candidate.
4. Replace with `managed_gen3_after_rollback` plus `verify_gen3`; activation
   requires both generation-two cleanup and its ordinary verifier token, proving
   generation two survived the rejected candidate. The verifier writes `3003`.
5. Delete the addon and deploy `verify_deleted`; it requires generation-three
   cleanup and the `3003` ordinary token, then writes `4004`.
6. Deploy `managed_final_check`; it requires the deletion/ordinary evidence and
   establishes one final managed generation.
7. Remove every fixture and press F9 once more. A committed empty generation
   proves final cleanup and leaves Inject empty.

Generation one used an error sentinel, but this protected-call path does not
copy that string into EE.log. Later ordinary verifiers therefore write tokens
that the following managed generation must consume. A missing commit, unexpected
commit on the invalid generation, RENOVICE native fault, or crash fails the test.
