local global = ...
if global.RENOVICE_MANAGED_TEST_TOKEN == 202 then
    global.RENOVICE_ORDINARY_TEST_TOKEN = 2002
    return 2002
end
error("RENOVICE_F9_GEN2_BAD")
