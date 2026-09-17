#pragma once
#include <algorithm>
#include <cstdint>
#include <string_view>

namespace renovice::injection {
enum class CasterDiagnosticLane { combat, calculation, hud };
inline CasterDiagnosticLane caster_diagnostic_lane(std::string_view method) noexcept
{
    if (method == "GetHudStatus" || method == "GetBuffNotifications") return CasterDiagnosticLane::hud;
    if (method == "ModifyValue" || method == "GetUpgradeModifiedValue") return CasterDiagnosticLane::calculation;
    return CasterDiagnosticLane::combat;
}
inline std::uint64_t caster_diagnostic_limit(CasterDiagnosticLane lane, std::uint64_t events) noexcept
{
    // HUD work has its own generation budget. Exhausting formatting capacity
    // must also stop inserted Lua allocations, without spending combat slots.
    if (lane == CasterDiagnosticLane::hud) return (std::max)(std::uint64_t{1}, events);
    return lane == CasterDiagnosticLane::calculation
        ? (std::min)(std::uint64_t{512}, (std::max)(std::uint64_t{1}, events / 128))
        : (std::min)(std::uint64_t{2048}, (std::max)(std::uint64_t{1}, events / 32));
}
}
