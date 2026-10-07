#pragma once
// Per-build ENGINE_PARAM_OVERRIDE registration (contract R16, 2026-10-01).
//
// Everything the native parameter-override hook relies on is keyed to one
// exact executable here. There is no default entry and no fallback: an
// unregistered digest installs nothing, and a registered build whose loaded
// image does not carry every byte below installs nothing either (the R10 Lua
// entry lane then keeps the values; nothing is withheld from it).
//
// Evidence (read-only, 44.0.2 `Warframe.x64.exe` 0124f0b9...):
//   work/research/engine-param-override-2026-10-01/tools/native_param_writer.py
//   (32 asserted checks, output outputs/native_param_writer.txt):
//   - push_value (RVA 0x191A010) is `void (lua_State* L, Instance* instance,
//     const ParamRecord* record, intptr_t index)`: rcx = L, rdx = instance,
//     r8 = record, r9 = index (-1 = the scalar value, >= 0 = array element).
//     It pushes exactly one value. Its only references in the image are the
//     two rel32 CALLs at 0x181CB8C (array element) and 0x181CBBA (scalar),
//     both inside apply_param (0x181CAE0, `env[hash(name)] = value`); no JMP,
//     LEA or absolute pointer reaches it. Neither call site reads RAX after
//     the call (void for its callers).
//   - The record's type byte is [record+4] (0..14 through the jump table at
//     0x191A3C8). Types 0 and 1 share one handler that pushes the float32 at
//     [record+0x10] (scalar) or [[record+0x30] + index*0x20] (array element)
//     through lua_pushnumber (0x1817420: float at L->top, tag 3, top += 16).
//     Every other type (bool, string, enum, vectors, objects, ...) is
//     untouched by the override.
//   - apply_param pushes the key with 0x5FE2E0 (dword = U44 name hash, tag 1)
//     immediately before the value; for an array it creates the table first
//     and rawsets each element after its push. So at push_value entry the key
//     is at top-1 (scalar) or top-2 (array; the table at top-1).
//   - Every apply_param caller (0xC6DE79, 0x1280FCA, 0x14ADFE1, 0x175C799)
//     pushed lua_getfenv(thread, -1) of the instance thread first:
//     [.., function, env, key, (table)]. getfenv of a function (tag 8) pushes
//     closure->env (+0x10) with tag 7 (0x17B3C16..0x17B3C57).
//   - The U44 name hash at 0x131C120 has seed 0x768e5ed0 (FNV-1a 32, not,
//     rol 17); the override recipe's hashes are re-checked with it.
// RENOVICE_TOOLCHAIN/engine_params/verify_engine_params.ps1 re-checks every
// byte range below against the installed executable (read-only) and unit-tests
// the rules in engine_params_core.hpp.
#include <array>
#include <cstddef>
#include <cstdint>
#include <string_view>

namespace renovice::engine_params {
// DE Luau and parameter-record layout the hook reads (byte offsets).
struct Layout {
    // lua_State
    std::uint32_t state_top = 0;        // L->top (the next free slot)
    std::uint32_t state_global = 0;     // L->global (VM identity)
    std::uint32_t state_stack = 0;      // L->stack (slot 0)
    // TValue
    std::uint32_t value_size = 0;
    std::uint32_t value_tag = 0;
    // Type tags of this build
    std::uint32_t tag_hash_key = 0;
    std::uint32_t tag_number = 0;
    std::uint32_t tag_table = 0;
    std::uint32_t tag_function = 0;
    // Closure / Proto
    std::uint32_t closure_is_c = 0;
    std::uint32_t closure_env = 0;
    std::uint32_t closure_proto = 0;
    std::uint8_t proto_gc_tag = 0;
    std::uint32_t proto_code = 0;
    std::uint32_t proto_instructions = 0;
    std::uint32_t proto_bytecode_id = 0;
    // Parameter record
    std::uint32_t record_type = 0;
    std::uint32_t record_array = 0;
    std::uint32_t record_scalar = 0;
    std::uint32_t record_elements = 0;
    std::uint32_t record_element_bytes = 0;
    std::uint32_t element_stride = 0;
    std::array<std::uint8_t, 2> number_types{};
};

// One exact byte range of the loaded image (lower-case hex).
struct ByteCheck {
    std::uintptr_t rva = 0;
    std::string_view hex;
    std::string_view reason;   // the exact refusal when it differs
};

struct BuildRegistration {
    std::string_view label;
    std::array<std::string_view, 2> digests;   // Steam and sideloadified image (identical code)
    std::uintptr_t push_value_rva = 0;         // the detour target
    std::uint32_t name_hash_seed = 0;
    Layout layout;
    std::array<ByteCheck, 8> checks;
};

inline constexpr std::array<BuildRegistration, 4> registered_builds{{
    {
        "44.0.2 2026.09.28.13.06",
        {"00cf876132443b8e2bcb7450d05c89d0f8695ec51c5881976f784233dbc94374",
         "0124f0b93516e60ae362c59090809de24a42551143a6adf84963bd2120ab7d33"},
        0x191a010,
        0x768e5ed0,
        {
            0x08, 0x18, 0x30,
            0x10, 0x0c,
            1, 3, 7, 8,
            0x03, 0x10, 0x18,
            12, 0x10, 0x88, 0xa8,
            0x04, 0x06, 0x10, 0x30, 0x38, 0x20,
            {0, 1},
        },
        {{
            {0x191a010,
             "48895c240848896c24104889742418574883ec30410fb64004498bd9498bf0488bea488bf983f80e0f87c3020000",
             "push-value-prologue-or-type-dispatch-mismatch"},
            {0x191a3c8, "53a0910153a09101", "push-value-number-types-not-shared"},
            {0x191a053,
             "4883fbff741948c1e305488bcf49035830f30f100be8b3d3efffe93e030000f3410f104810498d5810488bcfe89cd3efffe927030000",
             "push-value-number-handler-mismatch"},
            {0x1817420, "488b4108f30f1108c7400c030000004883410810c3", "lua-pushnumber-mismatch"},
            {0x5fe2e0, "488b41088910c7400c010000004883410810c3", "hash-key-push-mismatch"},
            {0x131c120,
             "b8d05e8e764885d2741e660f1f440000440fb601488d49014433c04169c0930100014883ea0175e8f7d0c1c011c3",
             "name-hash-seed-or-algorithm-mismatch"},
            {0x181cb3d,
             "e8def5afff8bd0488bcbe89417defe807e06007458488bcee8e63bf5fe4533c08bd0488bcb488be8e8a6468cff488bcbe86e89c8ff"
             "33ff448bf84885ed74430f1f40004c8bcf4c8bc6498bd6488bcbe87fd40f00448d4701418bd7488bcbe84037b1fe48ffc7483bfd72"
             "d8eb1549c7c1ffffffff4c8bc6498bd6488bcbe851d40f00",
             "apply-param-key-then-value-contract-mismatch"},
            {0x17b3c10,
             "8b480c4c8b0283f908742583f90a741741c7400c0000000048830210488b5c24304883c4205fc3488b00488b4858eb07488b00488b48"
             "10488b5c243041c7400c0700000049890848",
             "getfenv-function-env-contract-mismatch"},
        }},
    },
    {
        "44.x 2026.09.30.14.45",
        {"e546599b62d0574db955fc93a6434728625be72ca1a0731e475d1ffa350ccf05", ""},
        0x1919c90,
        0x768e5ed0,
        {
            0x08, 0x18, 0x30,
            0x10, 0x0c,
            1, 3, 7, 8,
            0x03, 0x10, 0x18,
            12, 0x10, 0x88, 0xa8,
            0x04, 0x06, 0x10, 0x30, 0x38, 0x20,
            {0, 1},
        },  // DE Luau / parameter-record layout: carried over from 44.0.2 2026.09.28.13.06 (2026.09.30.14.45 (native update tool 2026-10-04))
        {{
            {0x1919c90,
             "48895c240848896c24104889742418574883ec30410fb64004498bd9498bf0488bea488bf983f80e0f87c3020000",
             "push-value-prologue-or-type-dispatch-mismatch"},
            {0x191a048,
             "d39c9101d39c9101",
             "push-value-number-types-not-shared"},
            {0x1919cd3,
             "4883fbff741948c1e305488bcf49035830f30f100be8d3fab5ffe93e030000f3410f104810498d5810488bcfe8bcfab5ffe927030000",
             "push-value-number-handler-mismatch"},
            {0x14797c0,
             "488b4108f30f1108c7400c030000004883410810c3",
             "lua-pushnumber-mismatch"},
            {0x5177c0,
             "488b41088910c7400c010000004883410810c3",
             "hash-key-push-mismatch"},
            {0x4bc3a0,
             "b8d05e8e764885d2741e660f1f440000440fb601488d49014433c04169c0930100014883ea0175e8f7d0c1c011c3",
             "name-hash-seed-or-algorithm-mismatch"},
            {0x12e707d,
             "e81e531dff8bd0488bcbe8340723ff807e06007458488bcee83691cbff4533c08bd0488bcb488be8e886a561ff488bcbe87eba130033"
             "ff448bf84885ed74430f1f40004c8bcf4c8bc6498bd6488bcbe8bf2b6300448d4701418bd7488bcbe8c0b1f7fe48ffc7483bfd72d8eb"
             "1549c7c1ffffffff4c8bc6498bd6488bcbe8912b6300",
             "apply-param-key-then-value-contract-mismatch"},
            {0x1437650,
             "8b480c4c8b0283f908742583f90a741741c7400c0000000048830210488b5c24304883c4205fc3488b00488b4858eb07488b00488b48"
             "10488b5c243041c7400c0700000049890848",
             "getfenv-function-env-contract-mismatch"},
        }},
    },
    {
        "44.x 2026.09.30.14.45",
        {"ab759d955ee56d08be6f27e2a4272914d64f216196ece8e994393f4a5c92db4d", ""},
        0x1919c90,
        0x768e5ed0,
        {
            0x08, 0x18, 0x30,
            0x10, 0x0c,
            1, 3, 7, 8,
            0x03, 0x10, 0x18,
            12, 0x10, 0x88, 0xa8,
            0x04, 0x06, 0x10, 0x30, 0x38, 0x20,
            {0, 1},
        },  // DE Luau / parameter-record layout: carried over from 44.x 2026.09.30.14.45 (2026.09.30.14.45 (native update tool 2026-10-04))
        {{
            {0x1919c90,
             "48895c240848896c24104889742418574883ec30410fb64004498bd9498bf0488bea488bf983f80e0f87c3020000",
             "push-value-prologue-or-type-dispatch-mismatch"},
            {0x191a048,
             "d39c9101d39c9101",
             "push-value-number-types-not-shared"},
            {0x1919cd3,
             "4883fbff741948c1e305488bcf49035830f30f100be8d3fab5ffe93e030000f3410f104810498d5810488bcfe8bcfab5ffe927030000",
             "push-value-number-handler-mismatch"},
            {0x14797c0,
             "488b4108f30f1108c7400c030000004883410810c3",
             "lua-pushnumber-mismatch"},
            {0x5177c0,
             "488b41088910c7400c010000004883410810c3",
             "hash-key-push-mismatch"},
            {0x4bc3a0,
             "b8d05e8e764885d2741e660f1f440000440fb601488d49014433c04169c0930100014883ea0175e8f7d0c1c011c3",
             "name-hash-seed-or-algorithm-mismatch"},
            {0x12e707d,
             "e81e531dff8bd0488bcbe8340723ff807e06007458488bcee83691cbff4533c08bd0488bcb488be8e886a561ff488bcbe87eba130033"
             "ff448bf84885ed74430f1f40004c8bcf4c8bc6498bd6488bcbe8bf2b6300448d4701418bd7488bcbe8c0b1f7fe48ffc7483bfd72d8eb"
             "1549c7c1ffffffff4c8bc6498bd6488bcbe8912b6300",
             "apply-param-key-then-value-contract-mismatch"},
            {0x1437650,
             "8b480c4c8b0283f908742583f90a741741c7400c0000000048830210488b5c24304883c4205fc3488b00488b4858eb07488b00488b48"
             "10488b5c243041c7400c0700000049890848",
             "getfenv-function-env-contract-mismatch"},
        }},
    },
    {
        "44.x 2026.10.06.16.12",
        {"5802cf434999cdc563baab562e74999ebe55396d93f8f98d7d77c4b19e11cf77", ""},
        0x1919cb0,
        0x768e5ed0,
        {
            0x08, 0x18, 0x30,
            0x10, 0x0c,
            1, 3, 7, 8,
            0x03, 0x10, 0x18,
            12, 0x10, 0x88, 0xa8,
            0x04, 0x06, 0x10, 0x30, 0x38, 0x20,
            {0, 1},
        },  // DE Luau / parameter-record layout: carried over from 44.x 2026.09.30.14.45 (2026.10.06.16.12 (native update tool 2026-10-08))
        {{
            {0x1919cb0,
             "48895c240848896c24104889742418574883ec30410fb64004498bd9498bf0488bea488bf983f80e0f87c3020000",
             "push-value-prologue-or-type-dispatch-mismatch"},
            {0x191a068,
             "f39c9101f39c9101",
             "push-value-number-types-not-shared"},
            {0x1919cf3,
             "4883fbff741948c1e305488bcf49035830f30f100be8932cbffee93e030000f3410f104810498d5810488bcfe87c2cbffee927030000",
             "push-value-number-handler-mismatch"},
            {0x50c9a0,
             "488b4108f30f1108c7400c030000004883410810c3",
             "lua-pushnumber-mismatch"},
            {0xc99ce0,
             "488b41088910c7400c010000004883410810c3",
             "hash-key-push-mismatch"},
            {0xd6b460,
             "b8d05e8e764885d2741e660f1f440000440fb601488d49014433c04169c0930100014883ea0175e8f7d0c1c011c3",
             "name-hash-seed-or-algorithm-mismatch"},
            {0x174354d,
             "e80e7f62ff8bd0488bcbe8846755ff807e06007458488bcee8f6910bff4533c08bd0488bcb488be8e856ea13ff488bcbe80e1b00ff33"
             "ff448bf84885ed74430f1f40004c8bcf4c8bc6498bd6488bcbe80f671d00448d4701418bd7488bcbe8e0c723ff48ffc7483bfd72d8eb"
             "1549c7c1ffffffff4c8bc6498bd6488bcbe8e1661d00",
             "apply-param-key-then-value-contract-mismatch"},
            {0x11328d0,
             "8b480c4c8b0283f908742583f90a741741c7400c0000000048830210488b5c24304883c4205fc3488b00488b4858eb07488b00488b48"
             "10488b5c243041c7400c0700000049890848",
             "getfenv-function-env-contract-mismatch"},
        }},
    },
}};

inline const BuildRegistration* registration_for_digest(std::string_view digest) noexcept {
    if (digest.empty()) return nullptr;
    for (const auto& build : registered_builds)
        for (const auto& known : build.digests)
            if (!known.empty() && known == digest) return &build;
    return nullptr;
}

namespace detail {
inline int hex_digit(char c) noexcept {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    return -1;
}
}

// nullptr when every registered byte range is present in [image, image+size);
// otherwise the exact reason of the first mismatch.
inline const char* admit_image(const BuildRegistration& build, const std::uint8_t* image, std::size_t size) noexcept {
    if (image == nullptr) return "image-unavailable";
    for (const auto& check : build.checks) {
        if (check.hex.size() % 2 != 0) return "registration-hex-invalid";
        const std::size_t count = check.hex.size() / 2;
        if (check.rva > size || count > size - check.rva) return "registered-range-outside-image";
        for (std::size_t i = 0; i != count; ++i) {
            const int high = detail::hex_digit(check.hex[2 * i]);
            const int low = detail::hex_digit(check.hex[2 * i + 1]);
            if (high < 0 || low < 0) return "registration-hex-invalid";
            if (image[check.rva + i] != static_cast<std::uint8_t>(high * 16 + low)) return check.reason.data();
        }
    }
    return nullptr;
}
}
