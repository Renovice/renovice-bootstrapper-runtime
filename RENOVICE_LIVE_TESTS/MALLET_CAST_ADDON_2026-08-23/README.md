# Mallet flat-30,000 Overguard additive test

This is a removable managed-addon test, not another Mallet behavior rewrite.
The BardMusic replacement contains one inert dispatch point after a successful
Mallet cast. This addon owns the handler in Warframe's shared `_T` table through
`activate`/`cleanup`; it does not rely on module-local `_G` identity.

On cast, it raises the caster's current Overguard pool to at least 30,000 and
emits the proven positive-delta notification. It does not inspect Mallet damage,
change threat, alter the projectile, or participate in Mallet's pulse loop.

Removing the `.addon.lua_B` file and committing F9 restores the previous global
handler (normally nil). The inert dispatch point remains safe for future
additive Mallet addons.
