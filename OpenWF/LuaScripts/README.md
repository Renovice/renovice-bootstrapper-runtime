# LuaScripts — where your DE Lua scripts go

RENOVICE loads DE Lua scripts (`.lua_B`, precompiled DE-Luau bytecode) from this folder. Pluto scripts are separate:
they stay in `OpenWF\Scripts` (OpenWF's own folder).

| Folder / file | What goes there | What it does |
|---|---|---|
| `Addons\` | `<name>.lua_B`, `<name>.addon.lua_B`, `<key>.<name>.target.addon.lua_B` | Scripts that run **next to** the game's scripts: one-shot scripts, managed addons, target addons that hook one game script (by its 16-hex key). Also holds the two loader-owned `_RENOVICE_INTERNAL_...Bridge` files that draw the Scripts menu and SCRIPT SETTINGS page; leave those alone. |
| `Replacements\` | `<16-hex key> (description).lua_B` (also `.swf`, `.swf.toc`) | Scripts that **replace** a game script completely. The first 16 characters name the game script. Delete the file to get the game's own script back. |
| `Packages\<Name>\` | any mix of addons and replacements | One folder per feature or Warframe. **Drop a script in and it is part of the package** on the next game start or F9. One row in the Scripts menu turns the whole package on or off. `package.json` is optional (see below). |
| `Config\Logs.cfg` | loader settings | `Logging=` (the small loader log, keep it on), `Diagnostics=` / `Verbose=` (heavy debug capture, off for normal play). |
| `Config\ScriptStates.json` | written by the game | Your Scripts-menu switches (`scripts`) **and** your SCRIPT SETTINGS values per package (`values`), in one file. You never have to edit it by hand. |
| `Logs\` | written by the game | `renovice_source.log` (what loaded, errors), fault and memory logs. `Logs\Dumps\` holds captured evidence files the loader never runs. |

## Packages and package.json

A package folder works without `package.json`: its name is the folder name and every script in it is a member.
Add a `package.json` only for extras:

- a display name and description for the Scripts menu;
- nicer member names (`members` → `"label"`);
- **SCRIPT SETTINGS definitions**: which adjustable values exist (name, page, min/max, the game's default). Your
  chosen numbers are then stored in `Config\ScriptStates.json`, not in the package.

A member listed in `package.json` but missing from the folder makes that one package fail (a half-copied package
never loads half-way). A script in the folder that `package.json` does not list simply joins.

## Turning things off

- Loose addons and replacements: their own row in the Scripts menu.
- A package: its row in the Scripts menu (on/off for the whole package).
- One script inside a package: move it out of the package folder (there are no per-member switches).

Details for script authors (hooks, target addons, settings declarations): `HOW_TO_ADD_SCRIPTS.md`.
