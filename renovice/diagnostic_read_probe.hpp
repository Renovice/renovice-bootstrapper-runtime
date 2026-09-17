#pragma once
#include <cstddef>
#include <windows.h>

namespace renovice::diagnostics {
// IsBadReadPtr handles its own first-chance probe exceptions. Mark only our
// explicit call scope so fault diagnostics do not write dumps for those probes.
// The scope does not intercept exceptions or change the Windows API result.
inline thread_local unsigned intentional_read_probe_depth = 0;

inline bool intentional_read_probe_active() noexcept
{
    return intentional_read_probe_depth != 0;
}

struct IntentionalReadProbeScope
{
    IntentionalReadProbeScope() noexcept { ++intentional_read_probe_depth; }
    ~IntentionalReadProbeScope() noexcept { --intentional_read_probe_depth; }
    IntentionalReadProbeScope(const IntentionalReadProbeScope&) = delete;
    IntentionalReadProbeScope& operator=(const IntentionalReadProbeScope&) = delete;
};

inline BOOL bad_read_ptr(const void* address, std::size_t size) noexcept
{
    IntentionalReadProbeScope scope;
    return IsBadReadPtr(address, size);
}
}
