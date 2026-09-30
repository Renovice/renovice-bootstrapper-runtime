#pragma once

// Contract R10 (2026-09-30): the callee environment argument of
// luaCalls[P].before. Pure rule, unit-tested by
// RENOVICE_TOOLCHAIN/injection/verify_lua_call_environment.ps1. No module-,
// mission- or ability-specific rule lives here.
//
// A before callback is called as
//   before(prototype, arguments, upvalues, trace, environment)
// where `environment` is the environment table of the called closure
// (luau_Closure::env). DE runs a module root once per instance, and every
// closure the root creates carries the environment the root published into,
// so this table is the per-instance identity the R3 retirement ledger already
// uses (note_lua_call_instance_entry). Level ScriptTrigger and encounter
// parameters (`_scoreGoal=...`) are globals of that environment, which a
// callback running in its own addon environment cannot otherwise reach.
//
// Compatibility. The argument is appended: a callback declared with four (or
// fewer) parameters ignores it, so every existing addon is unchanged. An
// older runtime passes four arguments, so a callback that reads the fifth
// sees nil there and must fail closed (keep stock).
//
// Ownership. The table is borrowed for the duration of the callback. It is
// reachable from the closure being called and from the callback argument
// slot while the callback runs. An addon may keep it only as a weak key; it
// must never assume the table outlives the module instance.
//
// Fail closed. The argument is nil unless the closure has an environment
// pointer that is readable and whose GC header tag is a table tag; the
// dispatch never guesses a type and never fails a hook because the argument
// is unavailable.

#include <cstdint>

namespace renovice::lua_call_environment
{
    // prototype, arguments, upvalues, trace, environment
    inline constexpr int before_callback_argument_count = 5;
    // Zero-based position of the environment in the callback arguments.
    inline constexpr int environment_argument_index = 4;

    enum class Decision : std::uint8_t
    {
        nil_absent,     // the closure has no environment pointer
        nil_unreadable, // the pointer cannot be read (fail closed)
        nil_not_table,  // the GC header does not carry a table tag
        table,          // pass the environment table
    };

    [[nodiscard]] constexpr Decision classify(
        bool present, bool readable, bool header_is_table) noexcept
    {
        if (!present) return Decision::nil_absent;
        if (!readable) return Decision::nil_unreadable;
        if (!header_is_table) return Decision::nil_not_table;
        return Decision::table;
    }

    [[nodiscard]] constexpr const char* label(Decision decision) noexcept
    {
        switch (decision)
        {
        case Decision::nil_absent: return "nil-absent";
        case Decision::nil_unreadable: return "nil-unreadable";
        case Decision::nil_not_table: return "nil-not-table";
        case Decision::table: return "table";
        }
        return "unknown";
    }

    static_assert(environment_argument_index == before_callback_argument_count - 1,
        "the environment is the last (appended) callback argument");
    static_assert(classify(false, true, true) == Decision::nil_absent);
    static_assert(classify(true, false, true) == Decision::nil_unreadable);
    static_assert(classify(true, true, false) == Decision::nil_not_table);
    static_assert(classify(true, true, true) == Decision::table);
}
