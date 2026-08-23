local global = ...
if global.RENOVICE_MANAGED_TEST_TOKEN == 0
    and global.RENOVICE_ORDINARY_TEST_TOKEN == 3003 then
    global.RENOVICE_ORDINARY_TEST_TOKEN = 4004
    return 4004
end
error("RENOVICE_F9_DELETE_BAD")
