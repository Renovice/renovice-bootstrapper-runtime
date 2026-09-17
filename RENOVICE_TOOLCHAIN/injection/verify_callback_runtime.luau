local runtime = require("./callback_runtime")
local events = {}
local function emit(event) table.insert(events, event) end
local receiver = {}
local function dispatch(target, damage)
    assert(target == "target" and damage == 27)
    emit("addon")
end
local callback = runtime.prepareSource(receiver, dispatch)
runtime.commitSource(receiver, dispatch)
callback("target", 27)
assert(table.concat(events, ",") == "addon")
events = {}
local function original(target, damage, third, fourth)
    assert(target == "target" and damage == 27 and third == nil and fourth == 9)
    emit("stock")
    return 5, nil, "result", nil
end
callback = runtime.prepareOriginal(receiver, original)
runtime.commitOriginal(receiver, original)
local results = table.pack(callback("target", 27, nil, 9))
assert(results.n == 4 and results[1] == 5 and results[2] == nil and results[3] == "result" and results[4] == nil)
assert(table.concat(events, ",") == "stock,addon")
-- Source reassignment replaces one dispatcher; it must not stack wrappers.
events = {}
callback = runtime.prepareSource(receiver, dispatch)
runtime.commitSource(receiver, dispatch)
callback("target", 27, nil, 9)
assert(table.concat(events, ",") == "stock,addon")
-- A stock callback may precede the source call; never guess its upvalues.
local second = {}
assert(runtime.prepareOriginal(second, original) == original)
runtime.commitOriginal(second, original)
events = {}
runtime.prepareSource(second, dispatch)("target", 27, nil, 9)
assert(table.concat(events, ",") == "stock,addon")
-- A failed setter does not commit a prepared callback.
local third = {}
runtime.prepareSource(third, dispatch)
assert(runtime.prepareOriginal(third, original) == original)
-- Unrelated receivers cannot inherit another source.
assert(runtime.prepareOriginal({}, original) == original)
-- Original Lua coroutine execution must remain yieldable.
events = {}
local yielding = runtime.prepareOriginal(receiver, function(...)
    emit("stock.begin")
    coroutine.yield("pause")
    emit("stock.end")
    return ...
end)
local co = coroutine.create(yielding)
local ok, marker = coroutine.resume(co, "target", 27, nil, 9)
assert(ok and marker == "pause" and table.concat(events, ",") == "stock.begin")
local resumed = table.pack(coroutine.resume(co))
assert(resumed.n == 5 and resumed[1] == true and resumed[2] == "target" and resumed[3] == 27 and resumed[4] == nil and resumed[5] == 9)
assert(table.concat(events, ",") == "stock.begin,stock.end,addon")
-- Stock errors retain their normal failure and skip the after-event.
events = {}
local failing = runtime.prepareOriginal(receiver, function() error("stock failure") end)
assert(not pcall(failing, "target", 27))
assert(#events == 0)
print("CALLBACK RUNTIME PASS source-only, stock composition, varargs/nil returns, reassignment, reversed order, failed prepare, isolation, yield, stock error")
