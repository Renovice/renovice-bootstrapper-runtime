#pragma once
#include <cstdint>
namespace renovice::injection {
// Certified U43 native disassembly. Resolution is read-only; none is called.
inline constexpr char signature_memory_gc_counter_u43[] =
    "8B 83 00 40 00 00 4C 2B 8B 18 40 00 00 83 E0 1F F2 0F 5C 93 20 40 00 00 F2 0F 5E C1 49 C1 E9 0A";
inline constexpr char signature_memory_gc_roots_u43[] =
    "40 53 48 83 EC 20 48 8B 59 18 45 33 D2 4C 8B D9 48 8B 93 F8 02 00 00 4C 89 53 28 4C 89 53 30 4C 89 53 38 F6 42 01 03 74 08 48 8B CB E8";
inline constexpr char signature_memory_gc_thread_link_u43[] =
    "48 8B 43 68 48 89 47 28 80 7B 05 00 75 1E";
inline constexpr char signature_memory_gc_table_link_u43[] =
    "48 8B 43 28 48 8B D3 48 8B CF 48 89 47 28 E8 B1 03 00 00 85 C0 74 04 80 63 01 FB 0F B6 4B 06";
inline constexpr char signature_memory_gc_total_u43[] =
    "48 8B 59 18 B8 1F 85 EB 51 48 8B E9 8B 53 58 0F AF 53 54 48 8B 73 48 48 2B 73 40";
// Observation only; never controls gameplay or the collector.
struct VmMemorySampleGate {
    bool emitted = false;
    std::uint64_t last_ms = 0, sequence = 0;
    bool admit(bool enabled, bool owning_boundary, std::uint64_t now_ms) noexcept {
        if (!enabled) return false;
        if (!owning_boundary) return false;
        if (emitted && now_ms >= last_ms && now_ms - last_ms < 5000) return false;
        emitted = true; last_ms = now_ms; ++sequence;
        return true;
    }
};
inline bool sample_vm_host_error(std::uint64_t sequence) noexcept {
    return sequence != 0 && (sequence <= 8 || (sequence & (sequence - 1)) == 0);
}
inline int native_gray_link_offset_u43(std::uint8_t tag) noexcept {
    return tag == 7 ? 0x28 : tag == 8 ? 8 : tag == 10 ? 0x68 : tag == 12 ? 0x80 : -1;
}
}
