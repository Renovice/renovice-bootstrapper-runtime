// Unit checks for the R10 callee-environment argument rule
// (renovice/lua_call_environment_core.hpp). Built with MSVC /W4 /WX by
// verify_lua_call_environment.ps1. Offline only.
#include "../../renovice/lua_call_environment_core.hpp"

#include <cstdio>
#include <string_view>

namespace env = renovice::lua_call_environment;

namespace
{
    int failures = 0;

    void check(bool condition, const char* label)
    {
        std::printf("%s\t%s\n", condition ? "PASS" : "FAIL", label);
        if (!condition) ++failures;
    }
}

int main()
{
    check(env::before_callback_argument_count == 5,
        "the before callback receives five arguments (prototype, arguments, upvalues, trace, environment)");
    check(env::environment_argument_index == 4,
        "the environment is the fifth argument (appended; four-parameter callbacks ignore it)");

    // Exhaustive truth table of the three inputs.
    int table_decisions = 0;
    for (int present = 0; present != 2; ++present)
        for (int readable = 0; readable != 2; ++readable)
            for (int header = 0; header != 2; ++header)
            {
                const auto decision = env::classify(present != 0, readable != 0, header != 0);
                const bool is_table = decision == env::Decision::table;
                if (is_table) ++table_decisions;
                if (is_table && !(present && readable && header))
                    check(false, "a table is passed only for a present, readable, table-tagged environment");
            }
    check(table_decisions == 1, "exactly one input combination passes the table (all three conditions)");
    check(env::classify(false, false, false) == env::Decision::nil_absent, "no environment pointer: nil (absent)");
    check(env::classify(false, true, true) == env::Decision::nil_absent, "absence wins over the other inputs");
    check(env::classify(true, false, true) == env::Decision::nil_unreadable,
        "unreadable pointer: nil; the header byte is never trusted");
    check(env::classify(true, true, false) == env::Decision::nil_not_table, "non-table header tag: nil");
    check(env::classify(true, true, true) == env::Decision::table, "readable table environment: passed");

    check(std::string_view(env::label(env::Decision::table)) == "table" &&
          std::string_view(env::label(env::Decision::nil_absent)) == "nil-absent" &&
          std::string_view(env::label(env::Decision::nil_unreadable)) == "nil-unreadable" &&
          std::string_view(env::label(env::Decision::nil_not_table)) == "nil-not-table",
        "decision labels are stable");

    if (failures != 0)
    {
        std::printf("LUA CALL ENVIRONMENT CORE FAIL failures=%d\n", failures);
        return 1;
    }
    std::printf("LUA CALL ENVIRONMENT CORE PASS\n");
    return 0;
}
