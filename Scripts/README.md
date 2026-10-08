# Opt-in scripts

Every script in this folder is **opt-in**. Nothing here is installed by the bootstrapper, the build scripts or a
deployment. A script reaches a game only when you copy it into that game's `OpenWF\CustomScripts` folder yourself.

- Each subfolder is one script with its own `README.md`: what it changes, the exact client build it was made for, how
  to install and remove it, and how to test it.
- Scripts are made for one client build. A replacement matches its stock module by content key, so after a Warframe
  update it simply stops applying until it is rebuilt (the update tool `renovice_update.py` in the ability editor
  repository rebases registered scripts).
- Installed scripts follow the loader contract in `OpenWF/CustomScripts/HOW_TO_ADD_SCRIPTS.md`. A package folder is one
  row in the in-game **SCRIPTS** menu; install it switched off and turn it on there.

| Script | Kind | Client | What it does |
|---|---|---|---|
| [IcebindSolo](IcebindSolo/README.md) | package, 2 root replacements | 44.1.0 (`2026.10.06.16.12`) | The Icebind with 1 to 6 Tenno; complication scaling uses the real squad size. |
