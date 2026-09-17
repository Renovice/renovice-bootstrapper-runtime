#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <type_traits>

namespace renovice::injection {

// lua_checkstack expands the current CallInfo.top as well as physical storage.
// Temporary host API work must not leave that limit expanded in a Lua frame:
// stock CALL/RETURN instructions subsequently use it as their register window.
// Use stack/CallInfo offsets because nested calls can relocate both arrays.
template <typename State>
class ScopedVmApiFrame {
    State* state_ = nullptr;
    std::ptrdiff_t frame_offset_ = 0;
    std::ptrdiff_t limit_offset_ = 0;
    bool active_ = false;

public:
    explicit ScopedVmApiFrame(State* state) noexcept
        : state_(state)
    {
        if (!state || !state->stack || !state->ci || !state->base_ci
            || !state->end_ci || !state->ci->top || !state->intop || !state->outtop)
            return;
        frame_offset_ = reinterpret_cast<char*>(state->ci)
            - reinterpret_cast<char*>(state->base_ci);
        limit_offset_ = reinterpret_cast<char*>(state->ci->top)
            - reinterpret_cast<char*>(state->stack);
        active_ = true;
    }

    void restore() noexcept
    {
        if (!active_) return;
        active_ = false;
        const auto capacity = reinterpret_cast<char*>(state_->end_ci)
            - reinterpret_cast<char*>(state_->base_ci);
        if (frame_offset_ < 0 || frame_offset_ > capacity) return;
        auto* frame = reinterpret_cast<std::remove_reference_t<decltype(state_->ci)>>(
            reinterpret_cast<char*>(state_->base_ci) + frame_offset_);
        auto* limit = reinterpret_cast<std::remove_reference_t<decltype(state_->outtop)>>(
            reinterpret_cast<char*>(state_->stack) + limit_offset_);
        // Helpers that intentionally return pushed values must retain them.
        // An active child has its own window; its top is not the owner's output.
        if (frame == state_->ci) limit = (std::max)(limit, state_->outtop);
        frame->top = limit;
    }

    ~ScopedVmApiFrame() noexcept { restore(); }
    ScopedVmApiFrame(const ScopedVmApiFrame&) = delete;
    ScopedVmApiFrame& operator=(const ScopedVmApiFrame&) = delete;
};
}
