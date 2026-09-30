-- RENOVICE_NAME_HASH_SEED: 768e5ed0
-- REPLACEMENT_SETTINGS_V1 recommended pattern for generated replacements.
-- Every former literal site calls setting(id, stock); the stock literal stays
-- the fallback. One accessor call per use: while the committed serial is
-- unchanged the host returns no table (no allocation), so this is cheap
-- enough for hot functions; the table is rebuilt once per committed F9.
local settingsCache = nil
local settingsSerial = nil
local function setting(id, stock)
  local accessor = RENOVICE_SCRIPT_SETTINGS
  if accessor == nil then
    return stock
  end
  local fresh, serial = accessor(settingsSerial)
  if serial ~= settingsSerial then
    settingsCache = fresh
    settingsSerial = serial
  end
  local entry = settingsCache ~= nil and settingsCache[id] or nil
  if entry ~= nil and entry.enabled == true and entry.stock == stock and entry.value ~= nil then
    return entry.value
  end
  return stock
end
local function terminalTime(alternate)
  if alternate then
    return setting("pattern.terminal_time_alt", 240)
  end
  return setting("pattern.terminal_time", 180)
end
local function holdTime()
  return setting("pattern.hold_time", 90.5)
end
return { terminalTime = terminalTime, holdTime = holdTime }
