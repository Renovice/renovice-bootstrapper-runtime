-- REPLACEMENT_SETTINGS_V1 pattern harness (plain Luau). The gate appends the
-- pattern module as PATTERN_MODULE = function(...) <source> end before this
-- driver. The mock implements the host contract of the bound-key accessor
-- (renovice/replacement_settings_core.hpp plan_call / caller_is_current):
--   accessor([knownSerial]) -> table-or-nil, serial
--   known == serial -> nil, serial (no table built)
--   no entry        -> nil, serial
local failures = 0
local checks = 0
local function check(condition, message)
  checks += 1
  if condition then
    print("PASS\t" .. message)
  else
    failures += 1
    print("FAIL\t" .. message)
  end
end

local model = { serial = 1, entries = nil }
local builds = 0
local calls = 0
local function installAccessor()
  RENOVICE_SCRIPT_SETTINGS = function(first, second)
    calls += 1
    assert(second == nil, "the pattern never passes a second argument")
    assert(first == nil or type(first) == "number", "the pattern passes only its known serial")
    if first == model.serial then
      return nil, model.serial
    end
    if model.entries == nil then
      return nil, model.serial
    end
    builds += 1
    local fresh = {}
    for id, entry in pairs(model.entries) do
      fresh[id] = { enabled = true, value = entry.value, stock = entry.stock }
    end
    return fresh, model.serial
  end
end

-- 1. Older DLL / loose file: no accessor -> every site keeps its stock literal.
RENOVICE_SCRIPT_SETTINGS = nil
local module = PATTERN_MODULE()
check(module.terminalTime(false) == 180 and module.terminalTime(true) == 240 and module.holdTime() == 90.5,
  "no accessor: every site returns its compiled stock value")

-- 2. Accessor with settings: custom values apply, missing ids stay stock.
installAccessor()
model.entries = {
  ["pattern.terminal_time"] = { value = 60, stock = 180 },
  ["pattern.hold_time"] = { value = 30.25, stock = 90.5 },
}
module = PATTERN_MODULE()
check(module.terminalTime(false) == 60, "custom value applies at the site (180 -> 60)")
check(module.terminalTime(true) == 240, "an id without an entry keeps its stock (240)")
check(module.holdTime() == 30.25, "a decimal value applies (90.5 -> 30.25)")

-- 3. Hot path: many reads, one table per committed serial.
builds = 0
calls = 0
for _ = 1, 10000 do
  module.terminalTime(false)
  module.holdTime()
end
check(calls == 20000 and builds == 0, "20000 reads on an unchanged serial build no table (one C call each, cached)")

-- 4. An F9 commit (new serial) is picked up by the next read, once.
model.serial = 2
model.entries["pattern.terminal_time"].value = 90
check(module.terminalTime(false) == 90 and builds == 1, "a new committed serial rebuilds the cache once (60 -> 90)")
check(module.holdTime() == 30.25 and builds == 1, "other sites reuse the rebuilt cache")

-- 5. Guards: declared stock must equal the compiled stock; enabled must be true.
model.serial = 3
model.entries["pattern.terminal_time"] = { value = 75, stock = 999 }
check(module.terminalTime(false) == 180, "a recorded stock that differs from the compiled stock is ignored (stock applies)")

-- 6. Settings removed (use stock, package settings off): nil table, stock everywhere.
model.serial = 4
model.entries = nil
check(module.terminalTime(false) == 180 and module.holdTime() == 90.5, "no settings for this module: stock everywhere")

-- 7. Unbound or failed accessor call returns nothing: stock, no error.
RENOVICE_SCRIPT_SETTINGS = function() end
module = PATTERN_MODULE()
check(module.terminalTime(false) == 180 and module.holdTime() == 90.5, "an accessor call that returns nothing keeps stock")

print(string.format("PATTERN HARNESS %s checks=%d failures=%d", failures == 0 and "PASS" or "FAIL", checks, failures))
if failures ~= 0 then
  error("pattern harness failed")
end
