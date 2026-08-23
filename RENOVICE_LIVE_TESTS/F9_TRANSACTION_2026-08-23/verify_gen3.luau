local global = ...
if global.RENOVICE_MANAGED_TEST_TOKEN == 303 then
    global.RENOVICE_ORDINARY_TEST_TOKEN = 3003
    return 3003
end
error("RENOVICE_F9_GEN3_BAD")
