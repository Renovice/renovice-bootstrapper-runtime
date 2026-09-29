#pragma once

// Build-independent identity data for the DE_VM_AUTHORITY primitives. Shared by
// renovice/de_vm_authority.cpp (in-process resolution) and the offline
// certified-client verifier (RENOVICE_TOOLCHAIN/version44/verify_client_44.cpp),
// so the executable scan proves exactly what the runtime will resolve.
//
// No <windows.h>: the PE import walk below operates on any image mapped at its
// section RVAs (the live module, or a verifier's file-to-RVA mapped copy).

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <string_view>

namespace renovice::de_vm_authority
{
// ScriptMgr lock primitives. In every certified build (U43 2026.08.19.11.06,
// U44 2026.09.24.13.29, U44.0.2 2026.09.28.13.06) they are two identical-code
// folded MSVC thunks
//     mov rcx,[rcx] ; mov rcx,[rcx] ; jmp qword ptr [rip+IAT]
// that differ only in the IAT slot: KERNEL32!EnterCriticalSection and
// KERNEL32!LeaveCriticalSection. The earlier per-build signatures appended the
// prologue of whatever unrelated function the linker placed after each thunk;
// 44.0.2 relocated both thunks, so those neighbour bytes (not the primitives)
// changed and resolution failed with matches=0. Identity is now the thunk body
// plus the exact import it jumps through, resolved by name from the image's own
// import directory. Exactly one thunk must match each import (fail closed).
inline constexpr char signature_lock_thunk[] =
	"48 8B 09 48 8B 09 48 FF 25 ? ? ? ?";
inline constexpr std::size_t lock_thunk_slot_displacement = 9;
inline constexpr std::size_t lock_thunk_scan_capacity = 16;
inline constexpr char lock_import_module[] = "KERNEL32.dll";
inline constexpr char signature_lock_enter_import[] = "EnterCriticalSection";
inline constexpr char signature_lock_leave_import[] = "LeaveCriticalSection";

// Locked dispatcher: acquires the ScriptMgr lock through the enter thunk at +40
// (holder lea at +26) and tail-jumps to the leave thunk from its epilogue
// (+0x133 in all three certified builds). Both thunk identities are
// cross-checked against it; the epilogue is located inside a bounded window.
inline constexpr char signature_locked_dispatcher[] =
	"48 89 5C 24 10 48 89 74 24 18 57 48 83 EC 50 48 8B F9 0F 29 74 24 40 48 8D 0D ? ? ? ? 0F 28 F3 41 8B F0 48 8B DA E8 ? ? ? ?";
inline constexpr std::size_t locked_dispatcher_holder_displacement = 26;
inline constexpr std::size_t locked_dispatcher_enter_displacement = 40;
inline constexpr char signature_locked_dispatcher_epilogue[] =
	"48 83 C4 50 5F E9 ? ? ? ?";
inline constexpr std::size_t locked_dispatcher_epilogue_window = 0x200;
inline constexpr std::size_t locked_dispatcher_leave_displacement = 6;

namespace pe_detail
{
inline bool read_u16(const std::uint8_t* image, std::size_t size,
	std::size_t offset, std::uint16_t& out) noexcept
{
	if (offset > size || size - offset < sizeof(out)) return false;
	std::memcpy(&out, image + offset, sizeof(out));
	return true;
}

inline bool read_u32(const std::uint8_t* image, std::size_t size,
	std::size_t offset, std::uint32_t& out) noexcept
{
	if (offset > size || size - offset < sizeof(out)) return false;
	std::memcpy(&out, image + offset, sizeof(out));
	return true;
}

inline bool read_u64(const std::uint8_t* image, std::size_t size,
	std::size_t offset, std::uint64_t& out) noexcept
{
	if (offset > size || size - offset < sizeof(out)) return false;
	std::memcpy(&out, image + offset, sizeof(out));
	return true;
}

// Bounded, NUL-terminated ASCII comparison inside the mapped image.
inline bool image_string_equals(const std::uint8_t* image, std::size_t size,
	std::size_t offset, std::string_view expected, bool ignore_case) noexcept
{
	if (offset > size || size - offset <= expected.size()) return false;
	for (std::size_t i = 0; i != expected.size(); ++i)
	{
		auto a = static_cast<unsigned char>(image[offset + i]);
		auto b = static_cast<unsigned char>(expected[i]);
		if (ignore_case)
		{
			if (a >= 'A' && a <= 'Z') a = static_cast<unsigned char>(a - 'A' + 'a');
			if (b >= 'A' && b <= 'Z') b = static_cast<unsigned char>(b - 'A' + 'a');
		}
		if (a != b) return false;
	}
	return image[offset + expected.size()] == 0;
}
}

// Returns the RVA of the image's IAT slot bound by name to module!function, or
// 0 when the import is absent, ordinal-only, ambiguous, or the headers are not
// a well-formed PE32+ image. `image` must be mapped at section RVAs.
inline std::uint32_t find_import_slot_rva(
	const std::uint8_t* image,
	std::size_t size,
	std::string_view module,
	std::string_view function) noexcept
{
	using namespace pe_detail;
	constexpr std::size_t descriptor_size = 20;
	constexpr std::size_t thunk_size = 8;
	constexpr std::uint64_t ordinal_flag = 0x8000000000000000ull;
	constexpr std::size_t max_descriptors = 4096;
	constexpr std::size_t max_thunks = 65536;

	if (image == nullptr || size < 0x40) return 0;
	std::uint16_t mz = 0;
	std::uint32_t nt = 0;
	std::uint32_t signature = 0;
	std::uint16_t magic = 0;
	if (!read_u16(image, size, 0, mz) || mz != 0x5A4D
		|| !read_u32(image, size, 0x3C, nt)
		|| !read_u32(image, size, nt, signature) || signature != 0x00004550)
	{
		return 0;
	}
	const std::size_t optional = static_cast<std::size_t>(nt) + 24;
	std::uint32_t directory_count = 0;
	std::uint32_t import_rva = 0;
	std::uint32_t import_size = 0;
	if (!read_u16(image, size, optional, magic) || magic != 0x20B
		|| !read_u32(image, size, optional + 108, directory_count)
		|| directory_count < 2
		|| !read_u32(image, size, optional + 112 + 8, import_rva)
		|| !read_u32(image, size, optional + 112 + 12, import_size)
		|| import_rva == 0 || import_size < descriptor_size)
	{
		return 0;
	}

	std::uint32_t found = 0;
	std::size_t matches = 0;
	for (std::size_t d = 0; d != max_descriptors; ++d)
	{
		const std::size_t descriptor = import_rva + d * descriptor_size;
		std::uint32_t names = 0;
		std::uint32_t name = 0;
		std::uint32_t slots = 0;
		if (!read_u32(image, size, descriptor + 0, names)
			|| !read_u32(image, size, descriptor + 12, name)
			|| !read_u32(image, size, descriptor + 16, slots))
		{
			return 0;
		}
		if (name == 0) break;
		if (!image_string_equals(image, size, name, module, true)) continue;
		// The bound IAT no longer holds names at runtime; require the
		// separate import-name table so identity never depends on slot values.
		if (names == 0 || slots == 0) return 0;
		for (std::size_t t = 0; t != max_thunks; ++t)
		{
			std::uint64_t entry = 0;
			if (!read_u64(image, size, names + t * thunk_size, entry)) return 0;
			if (entry == 0) break;
			if ((entry & ordinal_flag) != 0) continue;
			if (entry > size) return 0;
			if (image_string_equals(image, size,
				static_cast<std::size_t>(entry) + 2, function, false))
			{
				found = static_cast<std::uint32_t>(slots + t * thunk_size);
				++matches;
			}
		}
	}
	return matches == 1 ? found : 0;
}
}
