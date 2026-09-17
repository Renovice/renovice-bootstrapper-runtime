#pragma once
#include <cstdint>
#include <utility>

namespace renovice::injection {
// U43: getfield/createtable call this barrier with (L, L, &L->gclist).
// Unique native bytes, not an RVA fallback. The caller owns stack reservation.
inline constexpr char signature_gc_barrierback_u43[] =
    "4C 8B 49 18 80 62 01 FB 49 8B 41 30 49 89 00 49 89 51 30 C3";
// U43 native lua_pushvalue. This is the game-owned stack-copy operation: it
// performs the thread barrier, resolves positive/negative/pseudo indices and
// publishes the copied TValue at L->top. The caller reserves one slot first.
inline constexpr char signature_lua_pushvalue_u43[] =
    "48 89 5C 24 08 57 48 83 EC 20 F6 41 01 04 48 8B D9 48 63 FA 74 0C 4C 8D 41 68 48 8B D1 E8 ? ? ? ? 85 FF 7E 24 48 8B 53 10 48 8D 43 08";
inline constexpr std::uint8_t native_gc_black_mask_u43 = 4;

// Value is copied before reservation: reservation may relocate its source slot.
// No allocation/collector step may run between the barrier and the stack write.
template <typename Stack, typename Value, typename Reserve, typename Barrier>
bool checked_stack_append(Stack& stack, Value value, Reserve&& reserve, Barrier&& barrier)
{
    if (!std::forward<Reserve>(reserve)(1)) return false;
    if ((stack.marked & native_gc_black_mask_u43) != 0)
        std::forward<Barrier>(barrier)();
    *stack.outtop++ = value;
    return true;
}
}
