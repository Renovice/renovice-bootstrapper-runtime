// Offline ENGINE_DAMAGE codec gate (2026-09-30). Read-only.
//
// For each executable image given on the command line: SHA-256 -> registration
// (renovice/engine_damage_builds.hpp), then against the section-mapped image:
//   1. the production install-time admission (admit_codec) passes: an exact
//      integer accessor with the registered codec exists and the UpgradedValue
//      evaluator at the registered RVA matches the registered codec and layout;
//   2. registered key constants occur; integer accessors built with any other
//      registered integer codec do not (stale-key negative evidence);
//   3. every DamageControl vtable holding handler0 at +0xf8 has a
//      registered-codec accessor at the shield and Overguard slots;
//   4. at least one vtable has a registered-codec accessor at the health slot.
// Every registration must be covered by at least one image, or the gate fails.
#include "../../renovice/engine_damage_builds.hpp"
#include <windows.h>
#include <bcrypt.h>
#include <algorithm>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <map>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>
#pragma comment(lib, "bcrypt.lib")

using namespace renovice::engine_damage;
namespace {
constexpr std::uint32_t damagecontrol_handler0_slot = 0xf8;

std::string sha256(const std::vector<std::uint8_t>& data) {
    BCRYPT_ALG_HANDLE algorithm = nullptr;
    BCRYPT_HASH_HANDLE hash = nullptr;
    std::uint8_t digest[32]{};
    if (BCryptOpenAlgorithmProvider(&algorithm, BCRYPT_SHA256_ALGORITHM, nullptr, 0) != 0
        || BCryptCreateHash(algorithm, &hash, nullptr, 0, nullptr, 0, 0) != 0
        || BCryptHashData(hash, const_cast<PUCHAR>(data.data()), static_cast<ULONG>(data.size()), 0) != 0
        || BCryptFinishHash(hash, digest, sizeof(digest), 0) != 0) {
        throw std::runtime_error("sha256");
    }
    BCryptDestroyHash(hash);
    BCryptCloseAlgorithmProvider(algorithm, 0);
    std::ostringstream out;
    for (const auto byte : digest) out << std::hex << std::setw(2) << std::setfill('0') << unsigned(byte);
    return out.str();
}

struct Mapped {
    std::vector<std::uint8_t> image;
    std::uint64_t image_base = 0;
    std::uint32_t text_begin = 0, text_end = 0, rdata_begin = 0, rdata_end = 0;
    std::uint64_t q(std::uint32_t rva) const { std::uint64_t v; std::memcpy(&v, image.data() + rva, 8); return v; }
    bool code(std::uint64_t va) const { return va >= image_base + text_begin && va < image_base + text_end; }
};

Mapped map_image(const std::vector<std::uint8_t>& file) {
    Mapped m;
    const auto dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(file.data());
    if (file.size() < sizeof(IMAGE_DOS_HEADER) || dos->e_magic != IMAGE_DOS_SIGNATURE) throw std::runtime_error("not a PE image");
    const auto nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(file.data() + dos->e_lfanew);
    if (nt->Signature != IMAGE_NT_SIGNATURE || nt->OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR64_MAGIC)
        throw std::runtime_error("not a PE32+ image");
    m.image_base = nt->OptionalHeader.ImageBase;
    m.image.assign(nt->OptionalHeader.SizeOfImage, 0);
    std::memcpy(m.image.data(), file.data(), nt->OptionalHeader.SizeOfHeaders);
    const auto* section = IMAGE_FIRST_SECTION(nt);
    for (unsigned i = 0; i < nt->FileHeader.NumberOfSections; ++i, ++section) {
        const auto raw = (std::min)(section->SizeOfRawData, section->Misc.VirtualSize);
        if (section->PointerToRawData + raw > file.size() || section->VirtualAddress + raw > m.image.size())
            throw std::runtime_error("section outside image");
        std::memcpy(m.image.data() + section->VirtualAddress, file.data() + section->PointerToRawData, raw);
        const std::string name(reinterpret_cast<const char*>(section->Name), strnlen(reinterpret_cast<const char*>(section->Name), 8));
        if (name == ".text") { m.text_begin = section->VirtualAddress; m.text_end = section->VirtualAddress + section->Misc.VirtualSize; }
        if (name == ".rdata") { m.rdata_begin = section->VirtualAddress; m.rdata_end = section->VirtualAddress + section->Misc.VirtualSize; }
    }
    if (!m.text_end || !m.rdata_end) throw std::runtime_error("missing .text or .rdata");
    return m;
}

bool accessor_at(const Mapped& m, std::uint64_t va, FieldCodec codec, std::uint32_t& field) {
    if (!m.code(va)) return false;
    const auto rva = static_cast<std::size_t>(va - m.image_base);
    return rva + integer_accessor_size <= m.image.size() && match_integer_accessor(m.image.data() + rva, codec, field);
}

std::size_t occurrences(const Mapped& m, std::uint32_t key) {
    std::uint8_t bytes[4];
    std::memcpy(bytes, &key, 4);
    std::size_t count = 0;
    for (std::size_t i = 0; i + 4 <= m.image.size(); ++i)
        if (std::memcmp(m.image.data() + i, bytes, 4) == 0) ++count;
    return count;
}

bool verify(const std::string& path, const BuildRegistration& build, const Mapped& m) {
    bool ok = true;
    const auto fail = [&](const std::string& what) { ok = false; std::cout << "  FAIL " << what << '\n'; };
    const auto admission = admit_codec(build, m.image.data(), m.image.size());
    if (admission.pool_reason) fail(admission.pool_reason);
    if (admission.raw_reason) fail(admission.raw_reason);
    const auto text = m.image.data() + m.text_begin;
    const std::size_t text_size = m.text_end - m.text_begin;
    const auto own = count_integer_accessors(text, text_size, build.integer_codec);
    std::cout << "  integer accessors rol" << unsigned(build.integer_codec.rotate) << "/0x" << std::hex
              << build.integer_codec.key << std::dec << " = " << own << '\n';
    std::set<std::uint32_t> foreign;
    for (const auto& other : registered_builds)
        if (other.integer_codec != build.integer_codec && foreign.insert(other.integer_codec.key).second) {
            const auto stale = count_integer_accessors(text, text_size, other.integer_codec);
            std::cout << "  stale integer accessors rol" << unsigned(other.integer_codec.rotate) << "/0x" << std::hex
                      << other.integer_codec.key << std::dec << " = " << stale << '\n';
            if (stale) fail("stale integer codec present in image");
        }
    for (const auto key : {build.integer_codec.key, build.float_codec.key}) {
        const auto count = occurrences(m, key);
        std::cout << "  key 0x" << std::hex << key << std::dec << " occurrences " << count << '\n';
        if (!count) fail("registered key absent");
    }
    // DamageControl vtables: handler0 at +0xf8, accessors at the shield/Overguard slots.
    const auto handler0 = m.image_base + build.handler_rvas[0];
    std::size_t tables = 0, good = 0;
    std::map<std::uint32_t, std::size_t> shield_fields, overguard_fields;
    for (std::uint32_t rva = m.rdata_begin; rva + 8 <= m.rdata_end; rva += 8) {
        if (m.q(rva) != handler0 || rva < m.rdata_begin + damagecontrol_handler0_slot) continue;
        const auto table = rva - damagecontrol_handler0_slot;
        ++tables;
        std::uint32_t shield = 0, overguard = 0;
        if (accessor_at(m, m.q(table + build.layout.control_shield_slot), build.integer_codec, shield)
            && accessor_at(m, m.q(table + build.layout.control_overguard_slot), build.integer_codec, overguard)) {
            ++good; ++shield_fields[shield]; ++overguard_fields[overguard];
        }
    }
    std::cout << "  DamageControl vtables with handler0 " << tables << ", registered-codec accessors at shield 0x"
              << std::hex << build.layout.control_shield_slot << " and Overguard 0x" << build.layout.control_overguard_slot
              << std::dec << ": " << good;
    for (const auto& [field, count] : shield_fields) std::cout << " shield-field=0x" << std::hex << field << std::dec << 'x' << count;
    for (const auto& [field, count] : overguard_fields) std::cout << " overguard-field=0x" << std::hex << field << std::dec << 'x' << count;
    std::cout << '\n';
    if (!tables || good != tables) fail("DamageControl shield/Overguard slots do not all hold registered-codec accessors");
    // Health slot: vtable runs (contiguous code pointers) with a registered-codec accessor at the slot.
    std::size_t health = 0;
    for (std::uint32_t rva = m.rdata_begin; rva + 8 <= m.rdata_end; rva += 8) {
        std::uint32_t field = 0;
        if (!accessor_at(m, m.q(rva), build.integer_codec, field)) continue;
        auto start = rva;
        while (start >= m.rdata_begin + 8 && m.code(m.q(start - 8))) start -= 8;
        if (rva - start == build.layout.target_health_slot) ++health;
    }
    std::cout << "  vtables with a registered-codec accessor at health slot 0x" << std::hex
              << build.layout.target_health_slot << std::dec << ": " << health << '\n';
    if (!health) fail("no registered-codec accessor at the health slot");
    std::cout << (ok ? "PASS " : "FAIL ") << build.label << ' ' << path << '\n';
    return ok;
}
}

int main(int argc, char** argv) {
    if (argc < 2) { std::cerr << "usage: verify_engine_damage_codec IMAGE...\n"; return 2; }
    std::set<std::string_view> covered;
    bool ok = true;
    for (int i = 1; i < argc; ++i) {
        std::ifstream in(argv[i], std::ios::binary);
        if (!in) { std::cout << "FAIL unreadable image " << argv[i] << '\n'; ok = false; continue; }
        const std::vector<std::uint8_t> file((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
        const auto digest = sha256(file);
        const auto build = registration_for_digest(digest);
        std::cout << "image " << argv[i] << " sha256 " << digest << '\n';
        if (!build) { std::cout << "FAIL unregistered digest\n"; ok = false; continue; }
        try {
            if (verify(argv[i], *build, map_image(file))) covered.insert(build->label);
            else ok = false;
        } catch (const std::exception& error) {
            std::cout << "FAIL " << error.what() << '\n'; ok = false;
        }
    }
    for (const auto& build : registered_builds)
        if (!covered.count(build.label)) { std::cout << "FAIL uncovered registration " << build.label << '\n'; ok = false; }
    std::cout << "ENGINE_DAMAGE CODEC GATE " << (ok ? "PASS" : "FAIL") << " registered=" << registered_builds.size()
              << " covered=" << covered.size() << '\n';
    return ok ? 0 : 1;
}
