#pragma once
#include "config_core.hpp"
#include <cstdint>
#include <string>

namespace renovice::engine_damage {
struct Source {
    std::uint64_t body = 0;
    std::uint64_t caster_snapshot = 0;
    std::int32_t prototype = -1;
    std::uint32_t instruction = 0;
    void* vm = nullptr;
    std::string path, name, method;
};
// An ingress is context only; stock still owns area selection and damage.
class SourceScope {
    const Source* previous;
public:
    explicit SourceScope(const Source* source) noexcept;
    ~SourceScope() noexcept;
};
// Call only at the existing accepted startup/F9 transaction boundary.
// Installed trampolines stay owned for the process lifetime: F9 publishes
// configuration and resets budgets, never retires an active damage trampoline.
bool reconcile(const config::Flags& flags);
void reset_budget() noexcept;
using TypeResolver = std::string(*)(std::uintptr_t);
void set_type_resolver(TypeResolver resolver) noexcept;
}
