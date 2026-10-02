# Regression gate of the native update tool: synthetic builds made from a COPY of the certified
# client (shift, neighbour / lock stub, codec keys, changed instruction, process-scope change,
# unchanged), each processed with --apply on a scratch source copy, plus verify_client_44.ps1
# built from the applied headers. Offline; reads the certified image from the native-update
# reference store; writes only under <workspace>\work\temp\native-update-synthetic.
#   -Build <worktree>  also applies the shift case to that full worktree and rebuilds it with
#                      every build_private.ps1 gate checking the synthetic image (slow).
param([string]$Build)
$ErrorActionPreference = 'Stop'
$python = (Get-Command python -ErrorAction SilentlyContinue)
if (-not $python) { $python = (Get-Command py -ErrorAction Stop) }
$arguments = @((Join-Path $PSScriptRoot 'test_native_update.py'))
if ($Build) { $arguments += @('--build', $Build) }
& $python.Source @arguments
if ($LASTEXITCODE -ne 0) { throw "NATIVE UPDATE REGRESSION FAIL: exit $LASTEXITCODE" }
