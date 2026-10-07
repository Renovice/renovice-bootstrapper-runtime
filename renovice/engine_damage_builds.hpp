#pragma once
// Per-build ENGINE_DAMAGE registration: addresses, field codecs and layout.
//
// Everything the native damage observer decodes is keyed to one exact
// executable here. There is no default entry and no fallback: an unregistered
// digest installs nothing, and a registered build whose codec cannot be found
// in the loaded image records null values with an exact reason.
//
// Evidence (2026-09-30, RESEARCH/ENGINE_DAMAGE_CODEC_2026-09-30):
//   tools/derive_engine_damage_layout.py disassembles each image read-only and
//   derives every value below from game code: the Lua GetHealth/GetShield/
//   GetOverguardAmount bindings (vtable slots), the accessors at those slots
//   (integer codec), DamageControl vtables holding the registered handler,
//   handler0 (control->target and packet->UpgradedValue offsets, damage
//   fractions) and the UpgradedValue evaluator handler0 calls (float codec,
//   flag and field offsets). RENOVICE_TOOLCHAIN/diagnostics/
//   verify_engine_damage_codec.ps1 re-checks the codec bytes per build.
//
// The parser in the research tool reads this file; keep one field per line.
#include <array>
#include <cstddef>
#include <cstdint>
#include <string_view>

namespace renovice::engine_damage {
// stored = encoded 32-bit field; value bits = rotl(stored, rotate) ^ (address >> 3) ^ key.
struct FieldCodec {
    std::uint8_t rotate = 0;
    std::uint32_t key = 0;
    constexpr bool operator==(const FieldCodec&) const = default;
};

struct Layout {
    std::uint32_t control_target = 0;          // DamageControl -> owning avatar pointer
    std::uint32_t target_health_slot = 0;      // avatar vtable: GetHealth accessor
    std::uint32_t control_shield_slot = 0;     // DamageControl vtable: GetShield accessor
    std::uint32_t control_overguard_slot = 0;  // DamageControl vtable: GetOverguardAmount accessor
    std::uint32_t packet_fractions = 0;        // 20 damage-type fractions (float)
    std::uint32_t packet_value = 0;            // embedded UpgradedValue (base amount)
    std::uint32_t value_encoded = 0;           // encoded base (float codec)
    std::uint32_t value_addition = 0;          // float added to the base
    std::uint32_t value_override = 0;          // float returned whole when the override flag is set
    std::uint32_t value_cached = 0;            // plain float base used when the cached flag is set
    std::uint32_t value_flags = 0;             // flag byte
    std::uint8_t value_override_flag = 0;
    std::uint8_t value_cached_flag = 0;
};

struct BuildRegistration {
    std::string_view label;
    std::array<std::string_view, 2> digests;   // Steam and sideloadified image (identical code); empty = none
    std::array<std::uintptr_t, 3> handler_rvas;
    std::uintptr_t value_evaluator_rva = 0;     // UpgradedValue evaluator called by handler0 on packet+value
    FieldCodec integer_codec;                   // health, shield, Overguard accessors
    FieldCodec float_codec;                     // UpgradedValue encoded base
    Layout layout;
};

inline constexpr std::array<BuildRegistration, 6> registered_builds{{
    {
        "43 2026.08.19.11.06",
        {"cca46d604a498cd95f0d28e3e8f3eee8833f5d362666a8e5c820c535f7c2af93", ""},
        {0x1ee140, 0xc60240, 0xa255b0},
        0x1876bb0,
        {19, 0xc55198a3},
        {30, 0x635bf253},
        {
            0x28,
            0x340,
            0x2b8,
            0x328,
            0x00,
            0x60,
            0x0c,
            0x14,
            0x20,
            0x24,
            0x30,
            0x10,
            0x20,
        },
    },
    {
        "44.0.0 2026.09.24.13.29",
        {"45fa6ad0769cc8ca7fa7e0ffdee65c0c0932e11744146781ad18c45b16e4a81c",
         "87fc60ce65e015c6c8d4be5ac353538c37392efb6793dd17f0a17cf126d3fb5c"},
        {0xd2cb0, 0xa10cf0, 0x7088a0},
        0xb6f850,
        {19, 0xac7e8740},
        {17, 0x8637d1b6},
        {
            0x28,
            0x350,
            0x2c8,
            0x338,
            0x00,
            0x60,
            0x0c,
            0x14,
            0x20,
            0x24,
            0x30,
            0x10,
            0x20,
        },
    },
    {
        "44.0.2 2026.09.28.13.06",
        {"00cf876132443b8e2bcb7450d05c89d0f8695ec51c5881976f784233dbc94374",
         "0124f0b93516e60ae362c59090809de24a42551143a6adf84963bd2120ab7d33"},
        {0x7267c0, 0xfb24b0, 0x1f5d80},
        0xaab090,
        {19, 0xac7e8740},
        {17, 0x8637d1b6},
        {
            0x28,
            0x350,
            0x2c8,
            0x338,
            0x00,
            0x60,
            0x0c,
            0x14,
            0x20,
            0x24,
            0x30,
            0x10,
            0x20,
        },
    },
    {
        "44.x 2026.09.30.14.45",
        {"e546599b62d0574db955fc93a6434728625be72ca1a0731e475d1ffa350ccf05", ""},
        {0x78f260, 0x1620000, 0x129500},
        0x10b2ef0,
        {19, 0xac7e8740},
        {17, 0x8637d1b6},
        {
            0x28,
            0x350,
            0x2c8,
            0x338,
            0x00,
            0x60,
            0x0c,
            0x14,
            0x20,
            0x24,
            0x30,
            0x10,
            0x20,
        },
    },
    {
        "44.x 2026.09.30.14.45",
        {"ab759d955ee56d08be6f27e2a4272914d64f216196ece8e994393f4a5c92db4d", ""},
        {0x78f260, 0x1620000, 0x129500},
        0x10b2ef0,
        {19, 0xac7e8740},
        {17, 0x8637d1b6},
        {
            0x28,
            0x350,
            0x2c8,
            0x338,
            0x00,
            0x60,
            0x0c,
            0x14,
            0x20,
            0x24,
            0x30,
            0x10,
            0x20,
        },
    },
    {
        "44.x 2026.10.06.16.12",
        {"5802cf434999cdc563baab562e74999ebe55396d93f8f98d7d77c4b19e11cf77", ""},
        {0x8e7890, 0x855d20, 0xde7090},
        0x171e3b0,
        {19, 0xac7e8740},
        {17, 0x8637d1b6},
        {
            0x28,
            0x350,
            0x2c8,
            0x338,
            0x00,
            0x60,
            0x0c,
            0x14,
            0x20,
            0x24,
            0x30,
            0x10,
            0x20,
        },
    },
}};

inline const BuildRegistration* registration_for_digest(std::string_view digest) noexcept {
    if (digest.empty()) return nullptr;
    for (const auto& build : registered_builds)
        for (const auto& known : build.digests)
            if (!known.empty() && known == digest) return &build;
    return nullptr;
}

inline constexpr std::size_t damage_fraction_count = 20;

// Exact accessor instruction shape:
//   add rcx, imm32 ; mov eax,[rcx] ; rol eax,R ; sar rcx,3 ; xor eax,ecx ; xor eax,KEY ; ret
// The imm32 (field offset) is bytes 3..6; everything else is fixed by the codec.
inline constexpr std::size_t integer_accessor_size = 24;
inline constexpr std::array<std::uint8_t, integer_accessor_size> integer_accessor_bytes(
    FieldCodec codec, std::uint32_t field_offset) noexcept {
    return {0x48, 0x81, 0xc1,
        static_cast<std::uint8_t>(field_offset), static_cast<std::uint8_t>(field_offset >> 8),
        static_cast<std::uint8_t>(field_offset >> 16), static_cast<std::uint8_t>(field_offset >> 24),
        0x8b, 0x01, 0xc1, 0xc0, codec.rotate, 0x48, 0xc1, 0xf9, 0x03, 0x33, 0xc1, 0x35,
        static_cast<std::uint8_t>(codec.key), static_cast<std::uint8_t>(codec.key >> 8),
        static_cast<std::uint8_t>(codec.key >> 16), static_cast<std::uint8_t>(codec.key >> 24), 0xc3};
}
// Accessor match ignoring the field-offset immediate. Returns the offset on match.
inline bool match_integer_accessor(const std::uint8_t* code, FieldCodec codec,
    std::uint32_t& field_offset) noexcept {
    const auto expected = integer_accessor_bytes(codec, 0);
    for (std::size_t i = 0; i < integer_accessor_size; ++i) {
        if (i >= 3 && i < 7) continue;
        if (code[i] != expected[i]) return false;
    }
    field_offset = static_cast<std::uint32_t>(code[3]) | (static_cast<std::uint32_t>(code[4]) << 8)
        | (static_cast<std::uint32_t>(code[5]) << 16) | (static_cast<std::uint32_t>(code[6]) << 24);
    return true;
}

// Exact prefix of the UpgradedValue evaluator (identical shape in 43, 44.0.0, 44.0.2):
//   movzx r8d,byte[rcx+flags] ; mov rdx,rcx ; test r8b,OVR ; je +6 ; movss xmm0,[rcx+override] ; ret
//   movss xmm1,[rcx+0x1c] ; test r8b,CACHED ; je +0x0c ; movss xmm0,[rcx+cached] ; addss xmm0,[rcx+add]
//   jmp +0x1f ; lea rax,[rcx+enc] ; mov ecx,[rcx+enc] ; rol ecx,R ; sar rax,3 ; xor ecx,eax ; xor ecx,KEY
//   movd xmm0,ecx ; addss xmm0,[rdx+add]
// Every displacement comes from the registered layout (disp8), every constant from the codec.
inline constexpr std::size_t value_evaluator_size = 74;
inline constexpr std::array<std::uint8_t, value_evaluator_size> value_evaluator_bytes(
    FieldCodec codec, const Layout& l) noexcept {
    const auto b = [](std::uint32_t v) { return static_cast<std::uint8_t>(v); };
    return {0x44, 0x0f, 0xb6, 0x41, b(l.value_flags), 0x48, 0x8b, 0xd1,
        0x41, 0xf6, 0xc0, l.value_override_flag, 0x74, 0x06,
        0xf3, 0x0f, 0x10, 0x41, b(l.value_override), 0xc3,
        0xf3, 0x0f, 0x10, 0x49, 0x1c,
        0x41, 0xf6, 0xc0, l.value_cached_flag, 0x74, 0x0c,
        0xf3, 0x0f, 0x10, 0x41, b(l.value_cached),
        0xf3, 0x0f, 0x58, 0x41, b(l.value_addition),
        0xeb, 0x1f,
        0x48, 0x8d, 0x41, b(l.value_encoded),
        0x8b, 0x49, b(l.value_encoded),
        0xc1, 0xc1, codec.rotate,
        0x48, 0xc1, 0xf8, 0x03,
        0x33, 0xc8,
        0x81, 0xf1, b(codec.key), b(codec.key >> 8), b(codec.key >> 16), b(codec.key >> 24),
        0x66, 0x0f, 0x6e, 0xc1,
        0xf3, 0x0f, 0x58, 0x42, b(l.value_addition)};
}
inline bool value_evaluator_matches(const std::uint8_t* code, FieldCodec codec, const Layout& layout) noexcept {
    const auto expected = value_evaluator_bytes(codec, layout);
    for (std::size_t i = 0; i < value_evaluator_size; ++i)
        if (code[i] != expected[i]) return false;
    return true;
}
// Number of exact integer accessors for `codec` in [image, image+size) (capped at `limit`).
inline std::size_t count_integer_accessors(const std::uint8_t* image, std::size_t size,
    FieldCodec codec, std::size_t limit = SIZE_MAX) noexcept {
    std::size_t count = 0;
    std::uint32_t ignored = 0;
    for (std::size_t i = 0; i + integer_accessor_size <= size && count < limit; ++i)
        if (image[i] == 0x48 && image[i + 1] == 0x81 && image[i + 2] == 0xc1
            && match_integer_accessor(image + i, codec, ignored)) ++count;
    return count;
}

// Install-time codec admission. nullptr = the image carries the registered
// codec; otherwise the exact reason the decoded fields must stay null.
struct CodecAdmission {
    const char* pool_reason = nullptr;   // health, shield, Overguard
    const char* raw_reason = nullptr;    // ObservedRaw (UpgradedValue base)
};
inline CodecAdmission admit_codec(const BuildRegistration& build, const std::uint8_t* image,
    std::size_t size) noexcept {
    CodecAdmission admission;
    if (count_integer_accessors(image, size, build.integer_codec, 1) == 0)
        admission.pool_reason = "integer-codec-not-present-in-image";
    if (build.value_evaluator_rva + value_evaluator_size > size
        || !value_evaluator_matches(image + build.value_evaluator_rva, build.float_codec, build.layout))
        admission.raw_reason = "value-evaluator-codec-mismatch";
    return admission;
}
}
