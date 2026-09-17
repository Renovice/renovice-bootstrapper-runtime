#pragma once
#include <cstdint>

namespace renovice::injection {
// U43's native callback increments thread+0x88 and errors above800000.
// Both exact signatures must resolve before the existing field can be used.
inline constexpr char signature_interrupt_increment_u43[] =
    "FF 81 88 00 00 00 8B 81 88 00 00 00 C3";
inline constexpr char signature_interrupt_guard_u43[] =
    "85 D2 79 19 53 48 83 EC 20 48 8B D9 E8 ? ? ? ? 3D 00 35 0C 00 7F 06";

class ScopedInjectedInterruptBudget {
    std::uint32_t& counter_;
    const std::uint32_t saved_;
public:
    explicit ScopedInjectedInterruptBudget(std::uint32_t& counter) noexcept
        : counter_(counter), saved_(counter) { counter_ = 0; }
    ~ScopedInjectedInterruptBudget() noexcept { counter_ = saved_; }
    ScopedInjectedInterruptBudget(const ScopedInjectedInterruptBudget&) = delete;
    ScopedInjectedInterruptBudget& operator=(const ScopedInjectedInterruptBudget&) = delete;
};
}
