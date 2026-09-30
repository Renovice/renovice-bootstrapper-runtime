#pragma once
#include <bit>
#include <cmath>
#include <cstdint>
#include <string_view>
#include "config_core.hpp"
#include "engine_damage_builds.hpp"

namespace renovice::engine_damage {
// Codecs are per build (engine_damage_builds.hpp); there is no default key.
inline std::uint32_t decode_bits(std::uint32_t encoded, std::uintptr_t address, FieldCodec codec) noexcept {
    return std::rotl(encoded, codec.rotate) ^ static_cast<std::uint32_t>(address >> 3) ^ codec.key;
}
inline std::int32_t decode_integer(std::uint32_t encoded, std::uintptr_t address, FieldCodec codec) noexcept {
    return std::bit_cast<std::int32_t>(decode_bits(encoded, address, codec));
}
inline float decode_float(std::uint32_t encoded, std::uintptr_t address, FieldCodec codec) noexcept {
    return std::bit_cast<float>(decode_bits(encoded, address, codec));
}
// Inverse, for regression fixtures only.
inline std::uint32_t encode_bits(std::uint32_t value, std::uintptr_t address, FieldCodec codec) noexcept {
    return std::rotr(value ^ static_cast<std::uint32_t>(address >> 3) ^ codec.key, codec.rotate);
}
inline bool requested(const config::Flags& flags) noexcept {
    return flags.diagnostics_damage_capture == config::DamageCaptureMode::engine
        && flags.diagnostics_mode >= config::DiagnosticsMode::battle
        && flags.diagnostics_damage_type_filter_valid;
}
inline bool selected(const config::Flags& flags, std::uint64_t body,
    std::string_view path, std::string_view name, std::string_view method,
    std::string_view target_type) {
    if (!requested(flags) || !flags.diagnostics_addon.empty()) return false;
    if (flags.diagnostics_target_filter_set
        && (!flags.diagnostics_target_filter_valid || body == 0
            || body != flags.diagnostics_target_key)) return false;
    if (!flags.diagnostics_damage_source.empty()
        && config::ascii_lower(path) != flags.diagnostics_damage_source
        && config::ascii_lower(name) != flags.diagnostics_damage_source) return false;
    if (!flags.diagnostics_method.empty()
        && config::ascii_lower(method) != flags.diagnostics_method) return false;
    return flags.diagnostics_damage_target_type.empty()
        || config::ascii_lower(target_type) == flags.diagnostics_damage_target_type;
}
}
