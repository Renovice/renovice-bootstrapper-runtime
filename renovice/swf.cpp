#include "swf.hpp"

#include "config.hpp"
#include "swf_core.hpp"

#include <algorithm>
#include <atomic>
#include <charconv>
#include <exception>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <mutex>
#include <optional>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#include <winsock2.h>
#include <windows.h>
#include <winternl.h>

#include <DetourHook.hpp>
#include <Module.hpp>
#include <Pattern.hpp>
#include <Pointer.hpp>

#include "../owf_console.hpp"

namespace renovice::swf
{
namespace
{
using Oodle = int(*)(
	const char*, std::size_t, void*, std::size_t, int, int, int,
	std::size_t, std::size_t, std::size_t, std::size_t, std::size_t,
	std::size_t, int);
using Parser = long long(*)(void*, void*, void*, void*, void*, void*, void*, void*);
using NtRead = NTSTATUS(NTAPI*)(
	HANDLE, HANDLE, PIO_APC_ROUTINE, void*, PIO_STATUS_BLOCK, void*, ULONG,
	PLARGE_INTEGER, PULONG);

struct Replacement
{
	std::uint64_t body_key = 0;
	std::shared_ptr<const std::vector<unsigned char>> bytes;
	std::optional<TocRule> toc;
};

struct Snapshot
{
	std::unordered_map<std::uint64_t, Replacement> replacements;
	std::vector<TocRule> toc_rules;
};

struct Armed
{
	std::uint32_t stock_file_length = 0;
	DWORD thread_id = 0;
	std::shared_ptr<const std::vector<unsigned char>> bytes;
};

constexpr std::uintmax_t maximum_swf_size = 16ull * 1024ull * 1024ull;

soup::DetourHook oodle_hook;
soup::DetourHook parser_hook;
soup::DetourHook ntread_hook;
std::atomic<std::shared_ptr<const Snapshot>> active_snapshot{std::make_shared<Snapshot>()};
std::shared_ptr<const Snapshot> prepared_snapshot;
std::mutex armed_mutex;
std::vector<Armed> armed;
std::atomic_bool enabled = false;

bool ascii_iequals(std::string_view lhs, std::string_view rhs) noexcept
{
	if (lhs.size() != rhs.size()) return false;
	for (std::size_t i = 0; i != lhs.size(); ++i)
	{
		if (std::tolower(static_cast<unsigned char>(lhs[i]))
			!= std::tolower(static_cast<unsigned char>(rhs[i]))) return false;
	}
	return true;
}

bool read_binary(const std::filesystem::path& path, std::vector<unsigned char>& bytes)
{
	std::error_code ec;
	const auto size = std::filesystem::file_size(path, ec);
	if (ec || size < 8 || size > maximum_swf_size
		|| size > static_cast<std::uintmax_t>((std::numeric_limits<std::streamsize>::max)())) return false;
	bytes.resize(static_cast<std::size_t>(size));
	std::ifstream input(path, std::ios::binary);
	return input && static_cast<bool>(input.read(
		reinterpret_cast<char*>(bytes.data()), static_cast<std::streamsize>(bytes.size())));
}

bool parse_unsigned(std::string_view text, int base, std::uint64_t& value)
{
	auto begin = text.data();
	auto end = text.data() + text.size();
	const auto result = std::from_chars(begin, end, value, base);
	return result.ec == std::errc{} && result.ptr == end;
}

bool load_toc_rule(
	const std::filesystem::path& path,
	std::uint32_t replacement_size,
	std::optional<TocRule>& result)
{
	const auto sidecar = std::filesystem::path(path.wstring() + L".toc");
	std::error_code ec;
	if (!std::filesystem::exists(sidecar, ec)) return !ec;
	std::ifstream input(sidecar);
	if (!input) return false;
	TocRule rule;
	std::string line;
	while (std::getline(input, line))
	{
		const auto equals = line.find('=');
		if (equals == std::string::npos) continue;
		const auto key = config::ascii_lower(config::trim_ascii(
			std::string_view(line).substr(0, equals)));
		auto value_text = config::trim_ascii(std::string_view(line).substr(equals + 1));
		int base = 10;
		if (value_text.starts_with("0x") || value_text.starts_with("0X"))
		{
			base = 16;
			value_text.erase(0, 2);
		}
		std::uint64_t value = 0;
		if (!parse_unsigned(value_text, base, value)) return false;
		if (key == "cache_offset") rule.cache_offset = value;
		else if (key == "compressed_size" && value <= UINT32_MAX) rule.compressed_size = static_cast<std::uint32_t>(value);
		else if (key == "decompressed_size" && value <= UINT32_MAX) rule.stock_decompressed_size = static_cast<std::uint32_t>(value);
	}
	if (rule.cache_offset == 0 || rule.compressed_size == 0 || rule.stock_decompressed_size == 0)
	{
		return false;
	}
	rule.replacement_capacity = (std::max)(rule.stock_decompressed_size, replacement_size);
	result = rule;
	return true;
}

bool scan_snapshot(std::shared_ptr<const Snapshot>& output)
{
	auto candidate = std::make_shared<Snapshot>();
	std::error_code ec;
	const auto& directory = config::custom_scripts_directory();
	for (std::filesystem::directory_iterator it(directory, ec), end; !ec && it != end; it.increment(ec))
	{
		if (!it->is_regular_file(ec))
		{
			if (ec) break;
			continue;
		}
		const auto path = it->path();
		if (!ascii_iequals(path.extension().string(), ".swf")) continue;
		std::uint64_t key = 0;
		if (!parse_key(path.stem().string(), key))
		{
			conout << "RENOVICE SWF transaction rejected: invalid content key " << path.filename().string() << std::endl;
			return false;
		}
		std::vector<unsigned char> bytes;
		if (!read_binary(path, bytes) || !valid_replacement(bytes))
		{
			conout << "RENOVICE SWF transaction rejected: replacement must be a bounded FWS with exact FileLength " << path.filename().string() << std::endl;
			return false;
		}
		Replacement replacement;
		replacement.body_key = key;
		replacement.bytes = std::make_shared<const std::vector<unsigned char>>(std::move(bytes));
		if (!load_toc_rule(path, static_cast<std::uint32_t>(replacement.bytes->size()), replacement.toc))
		{
			conout << "RENOVICE SWF transaction rejected: malformed TOC sidecar for " << path.filename().string() << std::endl;
			return false;
		}
		if (replacement.toc && replacement.toc->replacement_capacity > replacement.toc->stock_decompressed_size)
		{
			candidate->toc_rules.push_back(*replacement.toc);
		}
		if (!candidate->replacements.emplace(key, std::move(replacement)).second)
		{
			conout << "RENOVICE SWF transaction rejected: duplicate content key " << path.filename().string() << std::endl;
			return false;
		}
	}
	if (ec)
	{
		conout << "RENOVICE SWF transaction rejected: directory scan failed: " << ec.message() << std::endl;
		return false;
	}
	output = std::move(candidate);
	return true;
}

template <typename Function>
Function resolve_unique(const char* signature, const char* label)
{
	const soup::Module game(nullptr);
	soup::Pointer hits[2]{};
	const auto count = game.range.scanWithMultipleResults(soup::Pattern(signature), hits);
	if (count != 1)
	{
		conout << "RENOVICE SWF failed closed: " << label << " matches=" << count << std::endl;
		return nullptr;
	}
	return hits[0].as<Function>();
}

int oodle_detour(
	const char* input, std::size_t input_size, void* output, std::size_t output_size,
	int a5, int a6, int a7, std::size_t a8, std::size_t a9, std::size_t a10,
	std::size_t a11, std::size_t a12, std::size_t a13, int a14)
{
	const auto original = reinterpret_cast<Oodle>(oodle_hook.original);
	const auto result = original(input, input_size, output, output_size, a5, a6, a7,
		a8, a9, a10, a11, a12, a13, a14);
	if (result < 8 || output == nullptr || static_cast<std::size_t>(result) > output_size
		|| IsBadReadPtr(output, static_cast<std::size_t>(result))) return result;

	const auto snapshot = active_snapshot.load(std::memory_order_acquire);
	const auto key = replacements::body_key(std::string_view(
		reinterpret_cast<const char*>(output), static_cast<std::size_t>(result)));
	const auto found = snapshot->replacements.find(key);
	if (found == snapshot->replacements.end()) return result;
	const auto* bytes = static_cast<const unsigned char*>(output);
	if (!is_fws(std::span(bytes, static_cast<std::size_t>(result))))
	{
		conout << "RENOVICE SWF matched a non-FWS decompression body; overlay rejected key=" << key << std::endl;
		return result;
	}
	Armed entry;
	entry.stock_file_length = little_u32(bytes + 4);
	entry.thread_id = GetCurrentThreadId();
	entry.bytes = found->second.bytes;
	{
		std::lock_guard lock(armed_mutex);
		armed.erase(std::remove_if(armed.begin(), armed.end(), [&](const Armed& existing)
		{
			return existing.stock_file_length == entry.stock_file_length
				&& existing.thread_id == entry.thread_id;
		}), armed.end());
		armed.push_back(std::move(entry));
		if (armed.size() > 64) armed.erase(armed.begin(), armed.begin() + (armed.size() - 64));
	}
	config::verbose_log("SWF replacement armed after content-key match");
	return result;
}

long long parser_detour(void* a1, void* a2, void* a3, void* a4, void* a5, void* a6, void* a7, void* a8)
{
	if (a2 != nullptr && !IsBadReadPtr(a2, 16))
	{
		auto* sub = *reinterpret_cast<unsigned char**>(static_cast<unsigned char*>(a2) + 8);
		if (sub != nullptr && !IsBadReadPtr(sub, 0x28))
		{
			auto* begin = *reinterpret_cast<unsigned char**>(sub + 0x08);
			const auto capacity = *reinterpret_cast<std::uint32_t*>(sub + 4);
			if (begin != nullptr && capacity >= 8 && !IsBadReadPtr(begin, 8)
				&& begin[0] == 'F' && begin[1] == 'W' && begin[2] == 'S')
			{
				const auto stock_length = little_u32(begin + 4);
				std::shared_ptr<const std::vector<unsigned char>> replacement;
				{
					std::lock_guard lock(armed_mutex);
					const auto same_thread = std::find_if(armed.rbegin(), armed.rend(), [&](const Armed& item)
					{
						return item.stock_file_length == stock_length && item.thread_id == GetCurrentThreadId();
					});
					if (same_thread != armed.rend()) replacement = same_thread->bytes;
					else
					{
						std::size_t matches = 0;
						for (const auto& item : armed)
						{
							if (item.stock_file_length == stock_length)
							{
								replacement = item.bytes;
								++matches;
							}
						}
						if (matches != 1) replacement.reset();
					}
				}
				if (replacement)
				{
					const auto size = replacement->size();
					if (size <= capacity && !IsBadWritePtr(begin, size)
						&& !IsBadWritePtr(sub, 0x28))
					{
						std::memcpy(begin, replacement->data(), size);
						*reinterpret_cast<std::uint32_t*>(sub) = static_cast<std::uint32_t>(size);
						*reinterpret_cast<unsigned char**>(sub + 0x18) = begin;
						*reinterpret_cast<unsigned char**>(sub + 0x20) = begin + size;
						config::log("SWF replacement overlay committed at parser boundary");
					}
					else
					{
						conout << "RENOVICE SWF overlay rejected: replacement bytes=" << size
							<< " capacity=" << capacity << " (add or correct .swf.toc sidecar)" << std::endl;
					}
				}
			}
		}
	}
	return reinterpret_cast<Parser>(parser_hook.original)(a1, a2, a3, a4, a5, a6, a7, a8);
}

NTSTATUS NTAPI ntread_detour(
	HANDLE file, HANDLE event, PIO_APC_ROUTINE apc, void* context,
	PIO_STATUS_BLOCK status, void* buffer, ULONG length,
	PLARGE_INTEGER offset, PULONG key)
{
	const auto result = reinterpret_cast<NtRead>(ntread_hook.original)(
		file, event, apc, context, status, buffer, length, offset, key);
	if (buffer != nullptr && length >= 24 && !IsBadReadPtr(buffer, length)
		&& !IsBadWritePtr(buffer, length))
	{
		const auto snapshot = active_snapshot.load(std::memory_order_acquire);
		for (const auto& rule : snapshot->toc_rules)
		{
			if (patch_toc_buffer(std::span(static_cast<unsigned char*>(buffer), length), rule))
			{
				config::log("SWF cache TOC decompressed capacity patched");
			}
		}
	}
	return result;
}

bool create_hook(soup::DetourHook& hook, void* target, void* detour, const char* label)
{
	hook.target = target;
	hook.detour = detour;
	try
	{
		hook.create();
	}
	catch (const std::exception& exception)
	{
		conout << "RENOVICE SWF " << label << " hook failed: " << exception.what() << std::endl;
		return false;
	}
	if (!hook.isCreated()) return false;
	hook.enable();
	return true;
}
}

InitialiseResult initialise()
{
	std::shared_ptr<const Snapshot> snapshot;
	if (!scan_snapshot(snapshot)) return InitialiseResult::Failed;
	active_snapshot.store(snapshot, std::memory_order_release);
	if (snapshot->replacements.empty())
	{
		conout << "RENOVICE SWF replacement disabled: no .swf files found" << std::endl;
		return InitialiseResult::Disabled;
	}

	const auto oodle = resolve_unique<Oodle>(signature_oodle_decompress, "OodleLZ_Decompress");
	const auto parser = resolve_unique<Parser>(signature_parser, "SWF parser");
	if (oodle == nullptr || parser == nullptr) return InitialiseResult::Failed;
	if (!create_hook(oodle_hook, reinterpret_cast<void*>(oodle), reinterpret_cast<void*>(&oodle_detour), "Oodle")
		|| !create_hook(parser_hook, reinterpret_cast<void*>(parser), reinterpret_cast<void*>(&parser_detour), "parser"))
	{
		if (parser_hook.isCreated()) { parser_hook.disable(); parser_hook.destroy(); }
		if (oodle_hook.isCreated()) { oodle_hook.disable(); oodle_hook.destroy(); }
		return InitialiseResult::Failed;
	}

	if (!snapshot->toc_rules.empty())
	{
		const auto ntdll = GetModuleHandleW(L"ntdll.dll");
		const auto ntread = ntdll == nullptr ? nullptr : GetProcAddress(ntdll, "NtReadFile");
		if (ntread == nullptr || !create_hook(ntread_hook, reinterpret_cast<void*>(ntread),
			reinterpret_cast<void*>(&ntread_detour), "NtReadFile"))
		{
			if (ntread_hook.isCreated()) { ntread_hook.disable(); ntread_hook.destroy(); }
			parser_hook.disable();
			parser_hook.destroy();
			oodle_hook.disable();
			oodle_hook.destroy();
			return InitialiseResult::Failed;
		}
	}
	enabled.store(true, std::memory_order_release);
	conout << "RENOVICE SWF replacement enabled: replacements=" << snapshot->replacements.size()
		<< " toc_rules=" << snapshot->toc_rules.size() << std::endl;
	return InitialiseResult::Enabled;
}

bool reload()
{
	if (!prepare_reload()) return false;
	commit_prepared_reload();
	return true;
}

bool prepare_reload()
{
	std::shared_ptr<const Snapshot> candidate;
	if (!scan_snapshot(candidate)) return false;
	if (!enabled.load(std::memory_order_acquire))
	{
		if (candidate->replacements.empty())
		{
			prepared_snapshot = std::move(candidate);
			return true;
		}
		conout << "RENOVICE SWF reload rejected: enabling SWF hooks requires restart" << std::endl;
		return false;
	}
	const auto previous = active_snapshot.load(std::memory_order_acquire);
	if (previous->toc_rules.empty() && !candidate->toc_rules.empty() && !ntread_hook.isCreated())
	{
		conout << "RENOVICE SWF reload rejected: enabling a new any-size TOC rule requires restart" << std::endl;
		return false;
	}
	prepared_snapshot = std::move(candidate);
	return true;
}

void commit_prepared_reload()
{
	if (!prepared_snapshot) return;
	active_snapshot.store(std::move(prepared_snapshot), std::memory_order_release);
}

void discard_prepared_reload()
{
	prepared_snapshot.reset();
}
}
