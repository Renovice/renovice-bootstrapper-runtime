# PowerShell entry point of the native update tool (update resilience, native side).
# Same arguments as renovice_native_update.py; the exit code is passed through:
#   0 OK, 1 REVIEW, 2 BUILD FAILED, 3 TOOL ERROR.
# Example (after a Steam update; the game folder is only read):
#   .\renovice_native_update.ps1 --game "C:\Program Files (x86)\Steam\steamapps\common\Warframe" `
#       --out ..\..\..\..\..\work\native-update\runs\<build> --apply --build
# Contract: work\research\update-resilience\NATIVE_INTERFACE.md (workspace).
$ErrorActionPreference = 'Stop'
$python = (Get-Command python -ErrorAction SilentlyContinue)
if (-not $python) { $python = (Get-Command py -ErrorAction Stop) }
& $python.Source (Join-Path $PSScriptRoot 'renovice_native_update.py') @args
exit $LASTEXITCODE
