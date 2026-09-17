#pragma once
#include <atomic>
#include <cstdint>

// Legacy enum values remain the canonical diagnostic representation. Only the
// OpenWF/game bridge translates them, after the existing U43 build/hash gate.
// Current certified DE values are string6/table7/function8/userdata9; legacy
// string5/table6/function7/userdata8 must never be used to write that VM.
inline std::atomic_bool owf_current_luau_type_layout{false};
inline void owf_select_current_luau_type_layout(bool certified_current) noexcept
{
    owf_current_luau_type_layout.store(certified_current, std::memory_order_release);
}
inline std::uint32_t owf_game_tag(std::uint32_t legacy_tag) noexcept
{
    return legacy_tag >= 5 && owf_current_luau_type_layout.load(std::memory_order_acquire)
        ? legacy_tag + 1 : legacy_tag;
}
