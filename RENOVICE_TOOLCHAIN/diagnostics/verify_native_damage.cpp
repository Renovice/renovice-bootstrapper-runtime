#define RENOVICE_ENGINE_DAMAGE_TEST 1
#include "../../renovice/engine_damage.cpp"
#include <fstream>
#include <iostream>
#include <cstdlib>
#include <vector>

std::vector<std::string> captured;
namespace renovice::config {
void diagnostic_log(std::string_view record, DiagnosticsMode) noexcept {
    captured.emplace_back(record);
}
}
namespace {
using namespace renovice::engine_damage;
std::uint32_t calls = 0;
bool nested = false, simulate_nested = false;
int failures = 0;
void check(bool ok, const char* what) {
    if (!ok) { ++failures; std::cerr << "FAIL " << what << '\n'; }
}
bool has(std::size_t index, std::string_view needle) {
    return index < captured.size() && captured[index].find(needle) != std::string::npos;
}
const BuildRegistration& build_named(std::string_view prefix) {
    for (const auto& build : registered_builds)
        if (build.label.substr(0, prefix.size()) == prefix) return build;
    std::cerr << "missing registration " << prefix << '\n';
    std::exit(90);
}

// Fixture image: the same accessor bytes and field offsets the real image of
// `image_build` carries (RESEARCH/ENGINE_DAMAGE_CODEC_2026-09-30 derivation).
const BuildRegistration* image_build = nullptr;
struct Fields { std::uint32_t health, shield, overguard; };
Fields fields_for(const BuildRegistration& build) {
    return build.integer_codec.key == 0xc55198a3u ? Fields{0x50c, 0x1e34, 0x1e84} : Fields{0x50c, 0x1e54, 0x1ea4};
}
void set_integer(std::uintptr_t address, std::int32_t value) {
    const auto encoded = encode_bits(std::bit_cast<std::uint32_t>(value), address, image_build->integer_codec);
    std::memcpy(reinterpret_cast<void*>(address), &encoded, sizeof(encoded));
}
std::int32_t get_integer(std::uintptr_t address) {
    std::uint32_t encoded;
    std::memcpy(&encoded, reinterpret_cast<void*>(address), 4);
    return decode_integer(encoded, address, image_build->integer_codec);
}
// Stock damage: 40 Overguard, then 133 health (fixture numbers, not game rules).
void mock_stock(void* control, void* packet) {
    ++calls;
    const auto f = fields_for(*image_build);
    std::uintptr_t target = 0;
    std::memcpy(&target, static_cast<char*>(control) + 0x28, sizeof(target));
    set_integer(target + f.health, get_integer(target + f.health) - 133);
    const auto og = reinterpret_cast<std::uintptr_t>(control) + f.overguard;
    set_integer(og, get_integer(og) - 40);
    if (simulate_nested && !nested) {
        nested = true;
        bridge<1>(control, packet);
        nested = false;
    }
}
struct Target {
    std::array<unsigned char, 0x600> object{};
    std::array<unsigned char, 0x2000> control{};
    std::array<std::uintptr_t, 0x400 / 8> target_table{}, control_table{};
    std::array<std::uint8_t, integer_accessor_size> health_code{}, shield_code{}, overguard_code{};
    Target() {
        const auto& b = *image_build;
        const auto f = fields_for(b);
        auto table = reinterpret_cast<std::uintptr_t>(target_table.data());
        std::memcpy(object.data(), &table, 8);
        table = reinterpret_cast<std::uintptr_t>(control_table.data());
        std::memcpy(control.data(), &table, 8);
        auto target = reinterpret_cast<std::uintptr_t>(object.data());
        std::memcpy(control.data() + b.layout.control_target, &target, 8);
        health_code = integer_accessor_bytes(b.integer_codec, f.health);
        shield_code = integer_accessor_bytes(b.integer_codec, f.shield);
        overguard_code = integer_accessor_bytes(b.integer_codec, f.overguard);
        target_table[b.layout.target_health_slot / 8] = reinterpret_cast<std::uintptr_t>(health_code.data());
        control_table[b.layout.control_shield_slot / 8] = reinterpret_cast<std::uintptr_t>(shield_code.data());
        control_table[b.layout.control_overguard_slot / 8] = reinterpret_cast<std::uintptr_t>(overguard_code.data());
        // The stale U43 slots hold this image's accessors too, so a stale
        // registration meets a real accessor with a foreign key (shape mismatch).
        for (const auto slot : {0x340u, 0x2b8u, 0x328u}) {
            if (slot / 8 < target_table.size() && !target_table[slot / 8])
                target_table[slot / 8] = reinterpret_cast<std::uintptr_t>(health_code.data());
            if (!control_table[slot / 8])
                control_table[slot / 8] = reinterpret_cast<std::uintptr_t>(shield_code.data());
        }
        set_integer(target + f.health, 1000);
        set_integer(reinterpret_cast<std::uintptr_t>(control.data()) + f.shield, 250);
        set_integer(reinterpret_cast<std::uintptr_t>(control.data()) + f.overguard, 36816);
    }
};
struct Packet {
    std::array<unsigned char, 0x280> bytes{};
    // Encoded (non-cached) UpgradedValue base 500 + addition 2.5 = 502.5.
    explicit Packet(const BuildRegistration& b) {
        const float viral = 1, addition = 2.5f;
        std::memcpy(bytes.data() + b.layout.packet_fractions + 11 * 4, &viral, 4);
        const auto value = reinterpret_cast<std::uintptr_t>(bytes.data()) + b.layout.packet_value;
        const auto encoded = encode_bits(std::bit_cast<std::uint32_t>(500.0f), value + b.layout.value_encoded, b.float_codec);
        std::memcpy(reinterpret_cast<void*>(value + b.layout.value_encoded), &encoded, 4);
        std::memcpy(reinterpret_cast<void*>(value + b.layout.value_addition), &addition, 4);
    }
};
void use_build(const BuildRegistration& observer, const BuildRegistration& image, CodecAdmission admission) {
    registration.store(&observer);
    image_build = &image;
    test_admission = admission;
    installed = false;
    configuration.store(nullptr);
}
}

int main(int argc, char** argv) {
    namespace config = renovice::config;
    for (auto& hook : hooks) hook.original = &mock_stock;
    config::Flags flags;
    flags.diagnostics_mode = config::DiagnosticsMode::battle;
    flags.diagnostics_damage_capture = config::DamageCaptureMode::engine;
    Source source; source.body = 0x1234; source.name = "AreaTest.lua"; source.method = "RadialDamage";
    source.caster_snapshot = 42;
    SourceScope scope(&source);

    // 1. Known-answer vectors computed independently (Python, 2026-09-30):
    //    rotl(stored, R) ^ (address >> 3) ^ KEY at address 0x21cf2593d5c.
    {
        constexpr std::uintptr_t address = 0x21cf2593d5cull;
        const auto& u44 = build_named("44.0.2");
        const auto& u43 = build_named("43 ");
        check(decode_integer(0xa5e76646u, address, u44.integer_codec) == 36816,
            "44.0.2 integer codec rol19/0xAC7E8740 decodes the known sample to 36816");
        check(decode_float(0x530eae73u, address, u44.float_codec) == 1234.5f,
            "44.0.2 float codec rol17/0x8637D1B6 decodes the known sample to 1234.5");
        check(decode_bits(0x12345678u, address, u43.integer_codec) == 0xe8da2eaau
                && decode_bits(0x12345678u, address, u43.float_codec) == 0xf99dc066u
                && decode_bits(0x12345678u, address, u44.integer_codec) == 0x81f53149u
                && decode_bits(0x12345678u, address, u44.float_codec) == 0xb48cd275u,
            "registered codecs reproduce the independent known-answer bits");
        check(decode_float(0x530eae73u, address, u43.float_codec) != 1234.5f,
            "the stale U43 float codec does not decode a 44.0.2 value (the reported garbage)");
    }

    // 2. Every registered build: real pre/post capture with that build's codec and layout.
    std::vector<std::string> accepted;
    for (const auto& build : registered_builds) {
        use_build(build, build, {});
        captured.clear();
        const auto before_calls = calls;
        if (!reconcile(flags)) return 1;
        Packet packet(build);
        const auto immutable_packet = packet.bytes;
        Target first, second;
        bridge<0>(first.control.data(), packet.bytes.data());
        bridge<0>(second.control.data(), packet.bytes.data());
        const std::string layout = "\"Layout\":\"" + std::string(build.label) + "\"";
        check(calls - before_calls == 2 && captured.size() == 4 && packet.bytes == immutable_packet,
            "two targets sharing one packet: stock once each, four records, packet unchanged");
        for (const std::size_t end : {std::size_t{1}, std::size_t{3}}) {
            check(has(end, layout) && has(end, "\"HealthBefore\":1000") && has(end, "\"HealthAfter\":867")
                    && has(end, "\"HealthLoss\":133") && has(end, "\"ShieldBefore\":250")
                    && has(end, "\"ShieldLoss\":0") && has(end, "\"OverguardBefore\":36816")
                    && has(end, "\"OverguardAfter\":36776") && has(end, "\"OverguardLoss\":40")
                    && has(end, "\"VisiblePoolLoss\":173") && has(end, "\"VisiblePoolLossComplete\":true")
                    && has(end, "\"ObservedRaw\":502.5") && has(end, "\"RawReason\":null")
                    && has(end, "\"HealthReason\":null") && has(end, "\"ShieldReason\":null")
                    && has(end, "\"OverguardReason\":null") && has(end, "\"CasterSnapshot\":42"),
                "decoded sample matches expected health/shield/Overguard/raw values for the registered build");
        }
        if (build.label.substr(0, 6) == "44.0.2") accepted = captured;
    }

    // 3. Same-boundary nesting, exact filtering and the off fast path (44.0.2).
    const auto& current = build_named("44.0.2");
    use_build(current, current, {});
    if (!reconcile(flags)) return 3;
    {
        Packet packet(current);
        Target first;
        captured.clear(); simulate_nested = true;
        const auto before_calls = calls;
        bridge<0>(first.control.data(), packet.bytes.data());
        simulate_nested = false;
        check(calls - before_calls == 2 && captured.size() == 2 && has(1, "\"HealthLoss\":266"),
            "same-boundary nesting records one transaction and calls stock twice");
        captured.clear();
        auto filtered = flags; filtered.diagnostics_damage_source = "other.lua";
        reconcile(filtered); bridge<0>(first.control.data(), packet.bytes.data());
        check(captured.empty(), "exact source filter excludes other sources");
        auto off = flags; off.diagnostics_mode = config::DiagnosticsMode::off;
        reconcile(off); bridge<0>(first.control.data(), packet.bytes.data());
        check(captured.empty(), "off fast path records nothing");
    }

    // 4. Override flag: the evaluator returns another field; no base is reported.
    use_build(current, current, {});
    if (!reconcile(flags)) return 4;
    {
        Packet packet(current);
        packet.bytes[current.layout.packet_value + current.layout.value_flags] = current.layout.value_override_flag;
        Target first;
        captured.clear();
        bridge<0>(first.control.data(), packet.bytes.data());
        check(has(1, "\"ObservedRaw\":null") && has(1, "\"RawReason\":\"value-override-flag-set\"")
                && has(1, "\"HealthLoss\":133"),
            "override flag gives null raw with its exact reason; pools still decode");
    }

    // 5. Install-time admission on a synthetic 44.0.2 image, and the stale-codec case.
    {
        std::vector<std::uint8_t> image(current.value_evaluator_rva + 0x100, 0xcc);
        const auto evaluator = value_evaluator_bytes(current.float_codec, current.layout);
        std::memcpy(image.data() + current.value_evaluator_rva, evaluator.data(), evaluator.size());
        const auto accessor = integer_accessor_bytes(current.integer_codec, 0x1e54);
        std::memcpy(image.data() + 0x1000, accessor.data(), accessor.size());
        const auto good = admit_codec(current, image.data(), image.size());
        check(!good.pool_reason && !good.raw_reason, "44.0.2 image admits the 44.0.2 codec");
        const auto& stale = build_named("43 ");
        const auto bad = admit_codec(stale, image.data(), image.size());
        check(bad.pool_reason && std::string_view(bad.pool_reason) == "integer-codec-not-present-in-image"
                && bad.raw_reason && std::string_view(bad.raw_reason) == "value-evaluator-codec-mismatch",
            "U43 codec against a 44.0.2 image is refused with exact reasons");
        auto wrong_key = current; wrong_key.float_codec.key ^= 1;
        check(admit_codec(wrong_key, image.data(), image.size()).raw_reason != nullptr,
            "a one-bit key change fails the evaluator byte check");

        // Stale observer (U43 codec and slots) on a 44.0.2 fixture = the reported defect,
        // now null with reasons instead of null pools plus a garbage ObservedRaw.
        use_build(stale, current, bad);
        captured.clear();
        if (!reconcile(flags)) return 5;
        check(captured.size() == 1 && has(0, "event=degraded")
                && has(0, "reason=integer-codec-not-present-in-image,value-evaluator-codec-mismatch"),
            "one degraded line at install");
        Packet packet(current);
        Target first;
        captured.clear();
        bridge<0>(first.control.data(), packet.bytes.data());
        check(captured.size() == 2 && has(1, "\"ObservedRaw\":null")
                && has(1, "\"RawReason\":\"value-evaluator-codec-mismatch\"")
                && has(1, "\"HealthBefore\":null") && has(1, "\"HealthReason\":\"integer-codec-not-present-in-image\"")
                && has(1, "\"OverguardReason\":\"integer-codec-not-present-in-image\"")
                && has(1, "\"VisiblePoolLossComplete\":false") && has(1, "\"Target\":\"0x")
                && has(1, "\"CasterSnapshot\":42"),
            "degraded records keep correlation/target/source and null every decoded field with its reason");
        // Without the admission, the per-read accessor shape check still refuses the foreign key.
        use_build(stale, current, {});
        if (!reconcile(flags)) return 6;
        captured.clear();
        bridge<0>(first.control.data(), packet.bytes.data());
        check(has(1, "\"HealthBefore\":null") && has(1, "\"HealthReason\":\"accessor-shape-mismatch\"")
                && has(1, "\"ShieldReason\":\"accessor-shape-mismatch\""),
            "per-read accessor check refuses a foreign codec at the slot");
    }

    if (failures) return 10;
    if (argc > 1) { std::ofstream log(argv[1]); for (const auto& line : accepted) log << line << '\n'; }
    std::cout << "NATIVE DAMAGE OBSERVER PASS registered builds=" << registered_builds.size()
              << " known-answer codecs, decoded health/shield/Overguard/raw sample per build,"
                 " two targets sharing one packet, 133 HP + 40 OG loss, nesting, filter, off,"
                 " override flag, install admission, stale-codec degraded records\n";
}
