# Installed scripts snapshot — 2026-10-26

A copy of what is actually installed in the Documents game folder's `OpenWF/LuaScripts/`
(Addons, Config, Packages, Replacements only — `Logs/` is runtime output, not source, and is
excluded). This is a point-in-time backup, not a live mirror: it is not regenerated automatically
when the installed folder changes, and nothing in the loader reads from here.

Why this exists: before this snapshot, none of these built/authored scripts were tracked in any
git repo. Most can be regenerated from source elsewhere in this workspace (the mission registry
and ability-editor build pipeline for the `Missions` package; `RESEARCH/TESHIN_WEEKLY_PATCH_2026-10-26/`
in `de-luau-toolchain` for the Teshin replacement), but the exact installed bytes, and a couple of
one-off hand patches, were not backed up anywhere until now.

Re-snapshot by copying the four folders again and committing; there is no tooling for this yet.
