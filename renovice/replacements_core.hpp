#pragma once

#include <cstddef>
#include <cstdint>
#include <string>
#include <string_view>

namespace renovice::replacements
{
enum class HotReloadPayload
{
	None,
	Replacement,
	Original,
};

inline bool should_capture_module_load(
	bool available_replacement,
	bool active_replacement,
	bool previously_loaded,
	bool unresolved_refresh
) noexcept
{
	// Live enable/disable can only re-execute a module when its stock body and
	// loader context were captured during the natural load. Remember every
	// replacement file present on disk, including disabled files, without
	// retaining every unrelated game script.
	return available_replacement || active_replacement
		|| previously_loaded || unresolved_refresh;
}

inline HotReloadPayload select_hot_reload_payload(
	bool key_changed,
	bool replacement_present,
	bool original_present
) noexcept
{
	if (!key_changed) return HotReloadPayload::None;
	if (replacement_present) return HotReloadPayload::Replacement;
	if (original_present) return HotReloadPayload::Original;
	return HotReloadPayload::None;
}

inline bool compatible_hot_reload_vm(const void* current, const void* captured) noexcept
{
	return current != nullptr && current == captured;
}

inline bool hot_reload_complete(bool executions_passed, std::size_t deferred) noexcept
{
	// A deferred context is not an execution failure, but the generation is not
	// fully visible across every captured VM and must never be reported as PASS.
	return executions_passed && deferred == 0;
}

struct PendingRefreshIdentity
{
	std::uint64_t key = 0;
	const void* manager = nullptr;
	const void* descriptor = nullptr;
	const void* global_state = nullptr;
	std::uint32_t owner_thread = 0;
};

inline bool same_pending_refresh(
	const PendingRefreshIdentity& lhs,
	const PendingRefreshIdentity& rhs
) noexcept
{
	return lhs.key == rhs.key
		&& lhs.manager != nullptr
		&& lhs.manager == rhs.manager
		&& lhs.descriptor != nullptr
		&& lhs.descriptor == rhs.descriptor
		&& lhs.global_state != nullptr
		&& lhs.global_state == rhs.global_state;
}

inline bool pending_refresh_ready(
	const PendingRefreshIdentity& pending,
	const void* boundary_global_state,
	std::uint32_t boundary_thread
) noexcept
{
	return pending.global_state != nullptr
		&& pending.global_state == boundary_global_state
		&& pending.owner_thread != 0
		&& pending.owner_thread == boundary_thread;
}

inline bool natural_replacement_load_satisfies_pending(
	const PendingRefreshIdentity& pending,
	const PendingRefreshIdentity& loaded,
	bool replacement_was_undumped
) noexcept
{
	// Entering the loader is not evidence that a cached module executed. Only
	// the undump detour can prove that the replacement body was consumed during
	// this exact VM-local loader call.
	return replacement_was_undumped
		&& same_pending_refresh(pending, loaded)
		&& pending.owner_thread != 0
		&& pending.owner_thread == loaded.owner_thread;
}

inline constexpr std::uint64_t deployed_body_key_basis = 1469598103934665603ull;
inline constexpr std::uint64_t body_key_prime = 1099511628211ull;

// This deliberately uses the non-standard basis from the deployed custom
// loader. Existing replacement filenames depend on this exact value.
inline std::uint64_t body_key(std::string_view bytes) noexcept
{
	std::uint64_t hash = deployed_body_key_basis;
	for (const unsigned char byte : bytes)
	{
		hash ^= byte;
		hash *= body_key_prime;
	}
	return hash;
}

// The deployed convention permits a human-readable annotation after the first
// sixteen hex digits, e.g. "08fa...058f (Mallet edit).lua_B".
inline bool parse_filename_key(std::string_view stem, std::uint64_t& key) noexcept
{
	if (stem.size() < 16)
	{
		return false;
	}
	std::uint64_t value = 0;
	for (std::size_t i = 0; i != 16; ++i)
	{
		const char c = stem[i];
		std::uint8_t digit;
		if (c >= '0' && c <= '9') digit = static_cast<std::uint8_t>(c - '0');
		else if (c >= 'a' && c <= 'f') digit = static_cast<std::uint8_t>(c - 'a' + 10);
		else if (c >= 'A' && c <= 'F') digit = static_cast<std::uint8_t>(c - 'A' + 10);
		else return false;
		value = (value << 4) | digit;
	}
	if (value == 0)
	{
		return false;
	}
	key = value;
	return true;
}

// Fallback RVAs are keyed by the exact 16-byte executable ProductVersion,
// rather than the broader OpenWF game-version family. This prevents one U43
// hotfix from inheriting another U43 binary's address.
inline std::string fallback_tunable_name(std::string_view exact_build)
{
	std::string name = "renovice_undump_rva_";
	name.reserve(name.size() + exact_build.size());
	for (const char c : exact_build)
	{
		name.push_back(c == '.' ? '_' : c);
	}
	return name;
}
}
