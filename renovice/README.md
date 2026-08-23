# RENOVICE source modules

This directory is reserved for the parity-preserving port described in
`../RENOVICE_MIGRATION/SINGLE_DLL_ARCHITECTURE.md`.

Do not reimplement behavior from memory. Each source move must reference a
`feature_id` from `custom_feature_manifest.tsv`, retain its runtime gate, pass
its stated test, and keep the known-good external source and binaries until the
single-DLL recovery gate passes.

The first code milestone is the host interface and DE-Luau replacement/injector
extraction. SWF and Riven code remain in the working proxy until that core has
source-build and live parity.
