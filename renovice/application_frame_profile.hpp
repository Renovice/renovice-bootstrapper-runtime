#pragma once
#include <cstddef>

namespace renovice::application_frame
{
// Legacy source pattern retained for older certified clients. Current U43
// CCA46D... has an intervening near jump after the short conditional branch.
// Resolve by unique instructions, never an unchecked RVA fallback.
inline constexpr const char* legacy_pattern =
    "48 8B 0D ? ? ? ? 48 8B 01 FF 50 10 84 C0 75 ? 48 8B 0D ? ? ? ? EB";
inline constexpr const char* current_u43_pattern =
    "48 8B 0D ? ? ? ? 48 8B 01 FF 50 10 84 C0 75 ? E9 ? ? ? ? 48 8B 01 FF 50 10 84 C0 0F 84 ? ? ? ? 48 8B 0D ? ? ? ? EB";
enum class Profile { rejected, legacy, current_u43 };
inline constexpr Profile select_unique_profile(std::size_t legacy_count,
    std::size_t current_count, bool certified_current) noexcept
{
    if (!certified_current) return legacy_count == 1 ? Profile::legacy : Profile::rejected;
    if (legacy_count == 1 && current_count == 0) return Profile::legacy;
    if (legacy_count == 0 && current_count == 1) return Profile::current_u43;
    return Profile::rejected;
}
}
