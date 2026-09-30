#include "engine_damage.hpp"
#include "engine_damage_core.hpp"
#include "config.hpp"
#include <array>
#include <algorithm>
#include <atomic>
#include <cstring>
#include <iomanip>
#include <filesystem>
#include <memory>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <vector>
#include <winsock2.h>
#include <windows.h>
#if !defined(RENOVICE_ENGINE_DAMAGE_TEST)
#include <DetourHook.hpp>
#include <CompactDetourHook.hpp>
#include <memGuard.hpp>
#include <Module.hpp>
#include <Pattern.hpp>
#include <FileReader.hpp>
#include <sha256.hpp>
#include <string.hpp>
#endif

namespace renovice::engine_damage {
namespace {
using DamageFunction = void(*)(void*, void*);
struct Hook {
#if !defined(RENOVICE_ENGINE_DAMAGE_TEST)
    soup::DetourHook detour;
#endif
    DamageFunction original = nullptr;
};
std::array<Hook, 3> hooks;
#if !defined(RENOVICE_ENGINE_DAMAGE_TEST)
soup::CompactDetourHook compact_hook;
#endif
std::atomic<std::shared_ptr<const config::Flags>> configuration;
std::atomic_bool enabled = false;
std::atomic<std::uint64_t> sequence = 0, generation = 0;
std::atomic_bool budget_reported = false, failure_reported = false;
bool installed = false;
// Exact running build (engine_damage_builds.hpp) and its install-time codec
// admission. Process-owned: set once by install(), before `enabled`.
std::atomic<const BuildRegistration*> registration = nullptr;
std::atomic<const char*> pool_degraded_reason = nullptr, raw_degraded_reason = nullptr;
std::atomic<TypeResolver> type_resolver = nullptr;
thread_local Source active_source;
thread_local bool active_source_present = false;
struct Frame { void* control; void* packet; std::uint64_t id; Frame* previous; };
thread_local Frame* active_frame = nullptr;

template<class T> bool read(std::uintptr_t address, T& output) noexcept {
    SIZE_T copied = 0;
    return address != 0 && ReadProcessMemory(GetCurrentProcess(),
        reinterpret_cast<const void*>(address), &output, sizeof(output), &copied)
        && copied == sizeof(output);
}
// A decoded value or the exact reason it is unavailable (never a guess).
struct Reading { std::optional<double> value; const char* reason = nullptr; };
Reading integer_getter(std::uintptr_t object, std::size_t slot, FieldCodec codec) noexcept {
    // The observed getter is an integer decode, NOT a float reinterpretation.
    // Accept only the registered build's exact accessor shape at this actual
    // vtable slot; never call an unknown virtual method or assume that an
    // arbitrary subtype shares its fields.
    std::uintptr_t table = 0, function = 0;
    std::array<std::uint8_t, integer_accessor_size> code{};
    if (!read(object, table) || !read(table + slot, function) || !read(function, code))
        return {{}, "accessor-unreadable"};
    std::uint32_t offset = 0, encoded = 0;
    if (!match_integer_accessor(code.data(), codec, offset)) return {{}, "accessor-shape-mismatch"};
    if (offset > 0x10000) return {{}, "accessor-offset-out-of-range"};
    if (!read(object + offset, encoded)) return {{}, "field-unreadable"};
    return {decode_integer(encoded, object + offset, codec), nullptr};
}
struct Pools { Reading health, shield, overguard; };
Pools pools(const BuildRegistration& build, std::uintptr_t control, std::uintptr_t target) noexcept {
    if (const auto reason = pool_degraded_reason.load(std::memory_order_acquire))
        return {{{}, reason}, {{}, reason}, {{}, reason}};
    const auto& layout = build.layout;
    return {target ? integer_getter(target, layout.target_health_slot, build.integer_codec)
                   : Reading{{}, "target-unreadable"},
        integer_getter(control, layout.control_shield_slot, build.integer_codec),
        integer_getter(control, layout.control_overguard_slot, build.integer_codec)};
}
Reading base_amount(const BuildRegistration& build, std::uintptr_t packet) noexcept {
    // Mirrors the registered UpgradedValue evaluator's base term: the override
    // flag returns a separate value (not a base), the cached flag uses the plain
    // float, otherwise the float codec; the addition field is added to either.
    if (const auto reason = raw_degraded_reason.load(std::memory_order_acquire)) return {{}, reason};
    const auto& layout = build.layout;
    std::uint8_t flags = 0;
    float addition = 0, cached = 0;
    std::uint32_t encoded = 0;
    const auto value = packet + layout.packet_value;
    if (!read(value + layout.value_flags, flags) || !read(value + layout.value_addition, addition))
        return {{}, "value-unreadable"};
    if (flags & layout.value_override_flag) return {{}, "value-override-flag-set"};
    if (flags & layout.value_cached_flag) {
        if (!read(value + layout.value_cached, cached)) return {{}, "value-unreadable"};
    } else {
        if (!read(value + layout.value_encoded, encoded)) return {{}, "value-unreadable"};
        cached = decode_float(encoded, value + layout.value_encoded, build.float_codec);
    }
    const double result = static_cast<double>(cached) + addition;
    return std::isfinite(result) ? Reading{result, nullptr} : Reading{{}, "value-non-finite"};
}
std::string quote(std::string_view text) {
    std::ostringstream out; out << '"';
    for (const unsigned char c : text) {
        if (c == '"' || c == '\\') out << '\\' << c;
        else if (c < 32) out << "\\u" << std::hex << std::setw(4) << std::setfill('0') << unsigned(c) << std::dec;
        else out << c;
    }
    out << '"'; return out.str();
}
std::string pointer(std::uintptr_t value) {
    std::ostringstream out; out << "0x" << std::hex << value; return out.str();
}
void number(std::ostream& out, const std::optional<double>& value) {
    if (value && std::isfinite(*value)) out << std::setprecision(17) << *value;
    else out << "null";
}
void reason(std::ostream& out, const char* before, const char* after = nullptr) {
    const char* value = before ? before : after;
    if (value) out << '"' << value << '"';
    else out << "null";
}
std::optional<double> loss(const std::optional<double>& before, const std::optional<double>& after) {
    if (!before || !after) return {};
    return (std::max)(0.0, *before - *after);
}
void emit(const char* phase, std::uint64_t id, std::uint64_t parent,
    std::uint64_t capture_generation, std::size_t slot,
    std::uintptr_t control, std::uintptr_t target, std::uintptr_t packet,
    const Source& source, std::string_view target_type, const Pools& before, const Pools* after,
    const Reading& raw, const std::array<float, damage_fraction_count>& fractions,
    bool fractions_known, std::uint64_t begin_tick, std::string_view layout) {
    std::ostringstream out;
    out << "RENOVICE ENGINE_DAMAGE json={\"Schema\":1,\"Build\":\"V82-codec\",\"Layout\":" << quote(layout)
        << ",\"Phase\":" << quote(phase)
        << ",\"Pid\":" << GetCurrentProcessId() << ",\"Thread\":" << GetCurrentThreadId()
        << ",\"Generation\":" << capture_generation << ",\"Correlation\":" << id
        << ",\"ParentCorrelation\":" << parent << ",\"HandlerSlot\":" << slot
        << ",\"Vm\":" << quote(pointer(reinterpret_cast<std::uintptr_t>(source.vm)))
        << ",\"SourceBody\":" << quote(pointer(source.body))
        << ",\"CasterSnapshot\":" << source.caster_snapshot
        << ",\"SourcePrototype\":" << source.prototype << ",\"SourceInstruction\":" << source.instruction
        << ",\"SourcePath\":" << quote(source.path) << ",\"SourceName\":" << quote(source.name)
        << ",\"Method\":" << quote(source.method) << ",\"Target\":" << quote(pointer(target))
        << ",\"TargetType\":" << quote(target_type)
        << ",\"DamageControl\":" << quote(pointer(control)) << ",\"Packet\":" << quote(pointer(packet))
        << ",\"BeginTickMs\":" << begin_tick << ",\"TickMs\":" << GetTickCount64()
        << ",\"ObservedRaw\":"; number(out, raw.value);
    out << ",\"RawReason\":"; reason(out, raw.reason);
    out << ",\"HealthBefore\":"; number(out, before.health.value);
    out << ",\"ShieldBefore\":"; number(out, before.shield.value);
    out << ",\"OverguardBefore\":"; number(out, before.overguard.value);
    out << ",\"HealthReason\":"; reason(out, before.health.reason, after ? after->health.reason : nullptr);
    out << ",\"ShieldReason\":"; reason(out, before.shield.reason, after ? after->shield.reason : nullptr);
    out << ",\"OverguardReason\":"; reason(out, before.overguard.reason, after ? after->overguard.reason : nullptr);
    if (after) {
        const auto hp_loss = loss(before.health.value, after->health.value);
        const auto shield_loss = loss(before.shield.value, after->shield.value);
        const auto og_loss = loss(before.overguard.value, after->overguard.value);
        out << ",\"HealthAfter\":"; number(out, after->health.value);
        out << ",\"ShieldAfter\":"; number(out, after->shield.value);
        out << ",\"OverguardAfter\":"; number(out, after->overguard.value);
        out << ",\"HealthLoss\":"; number(out, hp_loss);
        out << ",\"ShieldLoss\":"; number(out, shield_loss);
        out << ",\"OverguardLoss\":"; number(out, og_loss);
        out << ",\"VisiblePoolLoss\":";
        number(out, hp_loss && shield_loss && og_loss
            ? std::optional<double>{*hp_loss + *shield_loss + *og_loss} : std::nullopt);
        out << ",\"VisiblePoolLossComplete\":" << (hp_loss && shield_loss && og_loss ? "true" : "false");
    }
    out << ",\"DamageFractions\":";
    if (!fractions_known) out << "null";
    else {
        out << '[';
        for (std::size_t i = 0; i < fractions.size(); ++i) {
            if (i) out << ',';
            number(out, std::isfinite(fractions[i]) ? std::optional<double>{fractions[i]} : std::nullopt);
        }
        out << ']';
    }
    out << ",\"LifeStateAvailable\":false,\"StatusProfileAvailable\":false}";
    config::diagnostic_log(out.str(), config::DiagnosticsMode::battle);
}
void adapter(std::size_t slot, void* control_pointer, void* packet_pointer, bool& stock_called) {
    auto original = hooks[slot].original;
    const auto stock = [&] { stock_called = true; original(control_pointer, packet_pointer); };
    if (!enabled.load(std::memory_order_acquire)) { stock(); return; }
    const auto flags = configuration.load(std::memory_order_acquire);
    const auto build = registration.load(std::memory_order_acquire);
    if (!flags || !build || !requested(*flags)) { stock(); return; }
    for (auto* frame = active_frame; frame; frame = frame->previous) {
        if (frame->control == control_pointer && frame->packet == packet_pointer) {
            stock(); return;
        }
    }
    const auto control = reinterpret_cast<std::uintptr_t>(control_pointer);
    const auto packet = reinterpret_cast<std::uintptr_t>(packet_pointer);
    const Source empty_source{};
    const Source& source = active_source_present ? active_source : empty_source;
    std::uintptr_t target = 0;
    if (!read(control + build->layout.control_target, target)) target = 0;
    std::string target_type;
    if (const auto resolver = type_resolver.load(std::memory_order_acquire)) target_type = resolver(target);
    if (!selected(*flags, source.body, source.path, source.name, source.method, target_type)) {
        stock(); return;
    }
    std::array<float, damage_fraction_count> fractions{};
    const bool fractions_known = read(packet + build->layout.packet_fractions, fractions);
    if (flags->diagnostics_damage_type_filter_set && (!fractions_known
        || !std::isfinite(fractions[flags->diagnostics_damage_type])
        || fractions[flags->diagnostics_damage_type] == 0)) {
        stock(); return;
    }
    const auto id = sequence.fetch_add(1, std::memory_order_relaxed) + 1;
    // Separate native budget: busy zero-damage Lua status traffic cannot consume it.
    const auto limit = (std::max)(std::uint64_t{1}, flags->diagnostics_max_events / 2);
    if (id > limit) {
        if (!budget_reported.exchange(true)) config::diagnostic_log(
            "RENOVICE ENGINE_DAMAGE build=V80 event=suppressed reason=native-budget-exhausted limit="
            + std::to_string(limit), config::DiagnosticsMode::battle);
        stock(); return;
    }
    const auto before = pools(*build, control, target);
    const auto raw = base_amount(*build, packet);
    const auto capture_generation = generation.load(std::memory_order_acquire);
    const auto begin_tick = GetTickCount64();
    const auto parent = active_frame ? active_frame->id : 0;
    Frame frame{control_pointer, packet_pointer, id, active_frame};
    struct Scope {
        Frame* previous;
        explicit Scope(Frame* frame) : previous(active_frame) { active_frame = frame; }
        ~Scope() { active_frame = previous; }
    } scope(&frame);
    auto report = [&](const char* phase, const Pools* after) noexcept {
        try { emit(phase, id, parent, capture_generation, slot, control, target,
            packet, source, target_type, before, after, raw, fractions, fractions_known, begin_tick,
            build->label); }
        catch (...) {
            if (!failure_reported.exchange(true)) config::diagnostic_log(
                "RENOVICE ENGINE_DAMAGE build=V80 event=failed reason=record-formatting",
                config::DiagnosticsMode::errors);
        }
    };
    report("begin", nullptr);
    stock();
    const auto after = pools(*build, control, target);
    report("end", &after);
}
template<std::size_t Slot> void bridge(void* control, void* packet) {
    bool stock_called = false;
    try { adapter(Slot, control, packet, stock_called); }
    catch (...) {
        // Observer failures cannot suppress or repeat a stock damage call.
        // An exception raised by stock itself retains its original propagation.
        if (stock_called) throw;
        if (!failure_reported.exchange(true)) config::diagnostic_log(
            "RENOVICE ENGINE_DAMAGE build=V80 event=failed reason=observer-preflight",
            config::DiagnosticsMode::errors);
        hooks[Slot].original(control, packet);
    }
}
#if !defined(RENOVICE_ENGINE_DAMAGE_TEST)
constexpr std::array<DamageFunction, 3> bridges{bridge<0>, bridge<1>, bridge<2>};
constexpr std::array<const char*, 3> patterns{
    "40 55 41 54 41 56 48 8D AC 24 B0 FC FF FF 48 81 EC 50 04 00 00 48 8B 05 ? ? ? ? 48 33 C4",
    "40 55 56 57 48 8D AC 24 90 FC FF FF 48 81 EC 70 04 00 00 48 8B 05 ? ? ? ? 48 33 C4",
    "40 53 48 81 EC E0 02 00 00 48 8B 05 ? ? ? ? 48 33 C4 48 89 84 24 D0 02 00 00 48 8B D9 48 8D 4C 24 20 E8 ? ? ? ? 48 8B 03"};
#endif
#if defined(RENOVICE_ENGINE_DAMAGE_TEST)
CodecAdmission test_admission;
#endif
// One operational line per process when the registered codec is not in the
// loaded image. Correlation, target, source and fractions keep recording; only
// the decoded fields are null, each with this exact reason.
void report_codec_admission(const BuildRegistration& build, const CodecAdmission& admission) {
    pool_degraded_reason.store(admission.pool_reason, std::memory_order_release);
    raw_degraded_reason.store(admission.raw_reason, std::memory_order_release);
    if (!admission.pool_reason && !admission.raw_reason) return;
    std::string reasons;
    for (const char* reason : {admission.pool_reason, admission.raw_reason}) {
        if (!reason) continue;
        if (!reasons.empty()) reasons += ',';
        reasons += reason;
    }
    config::diagnostic_log("RENOVICE ENGINE_DAMAGE build=V80 event=degraded reason=" + reasons
        + " layout=\"" + std::string(build.label) + "\" decoded-fields=null records=kept",
        config::DiagnosticsMode::errors);
}
bool install() {
#if defined(RENOVICE_ENGINE_DAMAGE_TEST)
    // The standalone harness exercises the production observer and ABI with
    // deterministic fake stock functions and selects `registration` itself;
    // image detours and codec presence are verified by separate gates. The
    // harness supplies the admission its fixture image would produce.
    const auto build = registration.load(std::memory_order_acquire);
    if (!build) return false;
    report_codec_admission(*build, test_admission);
    installed = true;
    return true;
#else
    wchar_t image_path[32768]{};
    if (!GetModuleFileNameW(nullptr, image_path, 32768)) return false;
    soup::FileReader image{std::filesystem::path(image_path)};
    if (!image.s) return false;
    const auto digest = soup::string::bin2hexLower(soup::sha256::hash(image));
    // Exact executable -> exact RVAs, codecs and layout (engine_damage_builds.hpp).
    // Sideloadify 1.1.0 leaves executable code identical, so each build lists its
    // Steam and sideloadified digest with the same entry. Unknown builds fail closed.
    const auto build = registration_for_digest(digest);
    if (!build) return false;
    const auto& registered_rvas = build->handler_rvas;
    const auto range = soup::Module(nullptr).range;
    std::array<void*, 3> targets{};
    const auto base = reinterpret_cast<std::uintptr_t>(GetModuleHandleW(nullptr));
    for (std::size_t i = 0; i < patterns.size(); ++i) {
        soup::Pointer hits[2]{};
        if (range.scanWithMultipleResults(soup::Pattern(patterns[i]), hits) != 1) return false;
        targets[i] = hits[0].as<void*>();
        if (reinterpret_cast<std::uintptr_t>(targets[i]) - base != registered_rvas[i]) return false;
    }
    // Codec admission reads the mapped image once; a missing key degrades the
    // decoded fields only and never blocks the hooks or the other records.
    const auto admission = admit_codec(*build, range.base.as<const std::uint8_t*>(), range.size);
    // Whole bundle validation/creation precedes publication. There is no RVA fallback.
    try {
        for (std::size_t i = 0; i < 2; ++i) {
            hooks[i].detour.target = targets[i];
            hooks[i].detour.detour = reinterpret_cast<void*>(bridges[i]);
            hooks[i].detour.create();
            if (!hooks[i].detour.isCreated() || !hooks[i].detour.original) throw std::runtime_error("trampoline-creation");
            hooks[i].original = reinterpret_cast<DamageFunction>(hooks[i].detour.original);
        }
        // The third prologue reaches a RIP-relative load within 13 bytes. A
        // five-byte entry jump preserves its complete nine-byte prologue.
        // Its captured entry and cave remain owned across all F9 generations.
        compact_hook.target = targets[2];
        compact_hook.detour = reinterpret_cast<void*>(bridges[2]);
        compact_hook.code_cave = range.scan(soup::HookBase::getCodeCavePattern()).as<void*>();
        if (!compact_hook.code_cave) throw std::runtime_error("missing-code-cave");
        compact_hook.create();
        if (!compact_hook.isCreated()) throw std::runtime_error("compact-trampoline-creation");
        hooks[2].original = reinterpret_cast<DamageFunction>(compact_hook.original);
        for (std::size_t i = 0; i < 2; ++i) hooks[i].detour.enable();
        compact_hook.enable();
    } catch (...) {
        for (std::size_t i = 0; i < 2; ++i) if (hooks[i].detour.isCreated()) {
            hooks[i].detour.disable(); hooks[i].detour.destroy();
        }
        if (compact_hook.isCreated()) {
            // Restore the captured entry directly: upstream disable follows an
            // installed E9 and would restore the code cave instead of the entry.
            soup::memGuard::setAllowedAccess(targets[2], 5, soup::memGuard::ACC_RWX);
            std::memcpy(targets[2], compact_hook.original, 5);
            compact_hook.destroy();
        }
        return false;
    }
    report_codec_admission(*build, admission);
    registration.store(build, std::memory_order_release);
    installed = true;
    config::diagnostic_log("RENOVICE ENGINE_DAMAGE build=V80 event=installed handlers=3 build-hash-and-unique-signatures=PASS layout=\""
        + std::string(build->label) + "\" codec=" + (admission.pool_reason || admission.raw_reason ? "degraded" : "registered-and-present")
        + " lifecycle=process-owned", config::DiagnosticsMode::battle);
    return true;
#endif
}
}
namespace {
void clear_source_storage() noexcept {
    active_source.body = 0;
    active_source.caster_snapshot = 0;
    active_source.prototype = -1;
    active_source.instruction = 0;
    active_source.vm = nullptr;
    active_source.path.clear();
    active_source.name.clear();
    active_source.method.clear();
    active_source_present = false;
}
}

bool publish_source(const Source* source) noexcept {
    if (source == nullptr) {
        clear_source_storage();
        return true;
    }
    try {
        active_source = *source;
        active_source_present = true;
        return true;
    } catch (...) {
        clear_source_storage();
        return false;
    }
}

void clear_source() noexcept { clear_source_storage(); }

SourceScope::SourceScope(const Source* source) noexcept {
    if (active_source_present) {
        try {
            previous = active_source;
            previous_active = true;
        } catch (...) {
            previous_active = false;
        }
    }
    publish_source(source);
}
SourceScope::~SourceScope() noexcept {
    if (previous_active) publish_source(&previous);
    else clear_source_storage();
}
void reset_budget() noexcept { sequence.store(0); generation.fetch_add(1); budget_reported.store(false); failure_reported.store(false); }
bool reconcile(const config::Flags& flags) {
    const auto current = configuration.load(std::memory_order_acquire);
    if (current && *current == flags) return !requested(flags) || installed;
    enabled.store(false, std::memory_order_release);
    if (!requested(flags)) {
        configuration.store(std::make_shared<const config::Flags>(flags), std::memory_order_release);
        return true;
    }
    if (!installed && !install()) {
        config::diagnostic_log("RENOVICE ENGINE_DAMAGE build=V80 event=failed reason=unregistered-image-or-native-signature-or-hook-bundle",
            config::DiagnosticsMode::errors);
        return false;
    }
    configuration.store(std::make_shared<const config::Flags>(flags), std::memory_order_release);
    enabled.store(true, std::memory_order_release);
    return true;
}
void set_type_resolver(TypeResolver resolver) noexcept { type_resolver.store(resolver, std::memory_order_release); }
}
