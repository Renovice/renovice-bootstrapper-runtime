#include "riven.hpp"

#include "config.hpp"
#include <base.hpp>
#include "../owf_structs.hpp"
#include "riven_core.hpp"

#include <atomic>
#include <cstring>
#include <exception>
#include <filesystem>
#include <mutex>
#include <optional>
#include <string>
#include <string_view>
#include <thread>

#include <winsock2.h>
#include <windows.h>
#include "diagnostic_read_probe.hpp"

#include <DetourHook.hpp>
#include <HttpRequest.hpp>
#include <Module.hpp>
#include <Pattern.hpp>
#include <Pointer.hpp>

#include "../owf_config.hpp"
#include "../owf_console.hpp"

namespace renovice::riven
{
namespace
{
using GfxDispatch = void(*)(void*, void*);
using SetStringVariable = unsigned long long(*)(void*);
using MovieArgument = void*(*)(void*);
using StringArgument = char*(*)(void*, int);
using TypeArgument = int(*)(void*, int, const char*);
using SetVariable = void(*)(void*, const char*, int, const char*);

constexpr std::size_t set_variable_vtable_offset = 0x6c8;

soup::DetourHook gfx_hook;
soup::DetourHook set_string_hook;
MovieArgument movie_argument = nullptr;
StringArgument string_argument = nullptr;
TypeArgument type_argument = nullptr;

std::atomic<std::uint32_t> locked_mask = 0;
std::atomic_bool gate_enabled = false;
std::optional<bool> prepared_gate;
// Hooks are installed only when riven_lock.cfg is present at startup (the
// behaviour of every build since the port; an absent file installs none).
std::atomic_bool hooks_installed = false;
std::atomic_bool restart_note_logged = false;
std::atomic_bool redraw_pending = false;
std::atomic_bool reroll_active = false;
std::mutex context_mutex;
void* cached_movie = nullptr;
SetVariable cached_set_variable = nullptr;
std::string cached_path;
std::string cached_description;

bool gate()
{
	return gate_enabled.load(std::memory_order_acquire);
}

bool readable(const void* pointer, std::size_t size) noexcept
{
	return pointer != nullptr && !diagnostics::bad_read_ptr(pointer, size);
}

bool writable(void* pointer, std::size_t size) noexcept
{
	return pointer != nullptr && !IsBadWritePtr(pointer, size);
}

bool read_gstring(const unsigned char* value, std::string& output)
{
	if (!readable(value, 16)) return false;
	const auto flag = static_cast<signed char>(value[15]);
	const char* data = nullptr;
	std::uint32_t length = 0;
	if (flag == -1)
	{
		data = *reinterpret_cast<const char* const*>(value);
		length = *reinterpret_cast<const std::uint32_t*>(value + 8) & 0x0fffffffu;
	}
	else
	{
		if (flag < 0 || flag > 15) return false;
		data = reinterpret_cast<const char*>(value);
		length = 15u - static_cast<unsigned>(flag);
	}
	if (length == 0 || length > 4000 || !readable(data, length)) return false;
	output.assign(data, length);
	return true;
}

void post_mask(std::uint32_t mask)
{
	const auto body = locked_indices_json(mask);
	const auto host = server_host + ":" + std::to_string(secure_connections ? https_port : http_port);
	const bool tls = secure_connections;
	std::thread([body, host, tls]
	{
		try
		{
			soup::HttpRequest request("POST", host, "/custom/rivenLockIndices");
			request.use_tls = tls;
			request.setHeader("Content-Type", "application/json");
			request.setPayload(body);
			const auto response = request.execute();
			if (!response.has_value() || response->status_code < 200 || response->status_code >= 300)
			{
				config::log("Riven lock POST failed or returned a non-2xx response");
			}
			else config::verbose_log("Riven lock POST accepted");
		}
		catch (const std::exception& exception)
		{
			config::log(std::string("Riven lock POST exception: ") + exception.what());
		}
	}).detach();
}

void invalidate_context()
{
	std::lock_guard lock(context_mutex);
	cached_movie = nullptr;
	cached_set_variable = nullptr;
	cached_path.clear();
	cached_description.clear();
}

void redraw()
{
	void* movie = nullptr;
	SetVariable set_variable = nullptr;
	std::string path;
	std::string description;
	{
		std::lock_guard lock(context_mutex);
		movie = cached_movie;
		set_variable = cached_set_variable;
		path = cached_path;
		description = cached_description;
	}
	if (!readable(movie, 8) || !readable(reinterpret_cast<void*>(set_variable), 1)
		|| path.empty() || description.empty())
	{
		invalidate_context();
		return;
	}
	const auto wrapped = build_wrap(description, locked_mask.load(std::memory_order_acquire));
	set_variable(movie, path.c_str(), 36, wrapped.c_str());
	config::verbose_log("Riven card redraw applied on safe Lua boundary");
}

void gfx_dispatch_detour(void* field, void* event)
{
	bool toggled = false;
	if (gate() && readable(event, 1) && readable(field, 0x180)
		&& *static_cast<const unsigned char*>(event) == 2)
	{
		const auto span_bytes = *reinterpret_cast<const std::uint32_t*>(
			static_cast<const unsigned char*>(field) + 0x178);
		const auto span_count = span_bytes >> 6;
		auto* span_base = *reinterpret_cast<unsigned char* const*>(
			static_cast<const unsigned char*>(field) + 0x170);
		if (span_count != 0 && span_count < 256
			&& readable(span_base, static_cast<std::size_t>(span_count) * 0x40))
		{
			for (unsigned i = 0; i != span_count; ++i)
			{
				auto* span = span_base + static_cast<std::size_t>(i) * 0x40;
				if (span[0x38] == 0) continue;
				std::string href;
				unsigned index = 0;
				if (!read_gstring(span, href) || !parse_lock_href(href, index)) continue;
				const auto bit = std::uint32_t{1} << index;
				const auto previous = locked_mask.fetch_xor(bit, std::memory_order_acq_rel);
				const bool now_locked = (previous & bit) == 0;
				if (writable(span + 0x20, 8))
				{
					span[0x24] = now_locked ? 0xff : 0xa7;
					span[0x25] = now_locked ? 0x00 : 0x85;
					span[0x26] = now_locked ? 0x00 : 0xc9;
					span[0x20] = 0xff;
					span[0x21] = now_locked ? 0x55 : 0xff;
					span[0x22] = now_locked ? 0x55 : 0xff;
				}

				const auto glyph_indices = *reinterpret_cast<const std::uint32_t* const*>(span + 0x28);
				const auto glyph_count = *reinterpret_cast<const std::uint32_t*>(span + 0x30) >> 2;
				auto* glyphs = *reinterpret_cast<unsigned char**>(static_cast<unsigned char*>(field) + 0x138);
				if (glyph_count != 0 && glyph_count < 8192 && readable(glyph_indices, glyph_count * 4ull)
					&& glyphs != nullptr)
				{
					std::uint32_t colour = 0;
					std::memcpy(&colour, span + 0x20, sizeof(colour));
					for (unsigned glyph = 0; glyph != glyph_count; ++glyph)
					{
						auto* slot = glyphs + static_cast<std::size_t>(glyph_indices[glyph]) * 0x50 + 0x18;
						if (writable(slot, sizeof(colour))) std::memcpy(slot, &colour, sizeof(colour));
					}
				}
				post_mask(locked_mask.load(std::memory_order_acquire));
				toggled = true;
			}
		}
	}
	reinterpret_cast<GfxDispatch>(gfx_hook.original)(field, event);
	if (toggled) redraw_pending.store(true, std::memory_order_release);
}

bool contains(std::string_view text, std::string_view needle) noexcept
{
	return text.find(needle) != std::string_view::npos;
}

unsigned long long set_string_detour(void* state)
{
	const auto original = reinterpret_cast<SetStringVariable>(set_string_hook.original);
	if (!gate())
	{
		return original(state);
	}
	const auto path_pointer = string_argument(state, 2);
	if (!readable(path_pointer, 1))
	{
		redraw_pending.store(false, std::memory_order_release);
		invalidate_context();
		return original(state);
	}
	const std::string_view path(path_pointer);
	if (redraw_pending.exchange(false, std::memory_order_acq_rel))
	{
		if (contains(path, "Available.Cards") || contains(path, "Choice") || contains(path, "Reroll")) redraw();
		else invalidate_context();
	}

	const auto html_pointer = string_argument(state, 4);
	const bool html_valid = readable(html_pointer, 1);
	const std::string_view html = html_valid ? std::string_view(html_pointer) : std::string_view{};
	if (contains(path, "Reroll") || contains(path, "OmegaReroll")
		|| (html_valid && (contains(html, "CYCLE FOR") || contains(html, "Remaining Kuva"))))
	{
		reroll_active.store(true, std::memory_order_release);
	}
	if (!contains(path, ".Card.Description")) return original(state);

	const auto type = type_argument(state, 3, "as_standard_member");
	if (type == 36 && html_valid && is_definite_non_riven(html))
	{
		reroll_active.store(false, std::memory_order_release);
		invalidate_context();
	}
	const bool riven_card = contains(path, "Available.Cards") || contains(path, "Choice");
	if (!reroll_active.load(std::memory_order_acquire) || !riven_card || type != 36
		|| !html_valid || !looks_like_riven_stats(html) || contains(html, "<a "))
	{
		return original(state);
	}

	locked_mask.store(0, std::memory_order_release);
	const auto wrapped = build_wrap(html, 0);
	void* movie = movie_argument(state);
	if (!readable(movie, 8)) return original(state);
	void* vtable = *static_cast<void**>(movie);
	if (!readable(static_cast<unsigned char*>(vtable) + set_variable_vtable_offset, sizeof(void*))) return original(state);
	const auto set_variable = *reinterpret_cast<SetVariable*>(
		static_cast<unsigned char*>(vtable) + set_variable_vtable_offset);
	if (!readable(reinterpret_cast<void*>(set_variable), 1)) return original(state);
	{
		std::lock_guard lock(context_mutex);
		cached_movie = movie;
		cached_set_variable = set_variable;
		cached_path.assign(path);
		cached_description.assign(html);
	}
	set_variable(movie, path_pointer, type, wrapped.c_str());
	config::verbose_log("Riven stat links wrapped");
	return 0;
}

template <typename Function>
Function resolve_unique(const char* signature, const char* label)
{
	const soup::Module game(nullptr);
	soup::Pointer matches[2]{};
	const auto count = game.range.scanWithMultipleResults(soup::Pattern(signature), matches);
	if (count != 1)
	{
		conout << "RENOVICE Riven failed closed: " << label << " matches=" << count << std::endl;
		return nullptr;
	}
	return matches[0].as<Function>();
}

bool create_hook(soup::DetourHook& hook, void* target, void* detour, const char* label)
{
	hook.target = target;
	hook.detour = detour;
	try { hook.create(); }
	catch (const std::exception& exception)
	{
		conout << "RENOVICE Riven " << label << " hook failed: " << exception.what() << std::endl;
		return false;
	}
	if (!hook.isCreated()) return false;
	hook.enable();
	return true;
}
}

namespace
{
std::filesystem::path gate_file_path()
{
	return config::custom_scripts_directory() / L"riven_lock.cfg";
}
}

bool initialise()
{
	std::error_code error;
	const auto gate_file = classify_gate_file(gate_file_path(), error);
	if (gate_file == GateFile::Unreadable)
	{
		conout << "RENOVICE Riven gate read failed: " << error.message() << std::endl;
		return false;
	}
	if (gate_file == GateFile::Absent)
	{
		// Riven lock off: no hook is installed (unchanged behaviour); the stock
		// Riven UI is untouched. Creating the file needs a game restart.
		gate_enabled.store(false, std::memory_order_release);
		conout << "RENOVICE Riven lock off: riven_lock.cfg absent; hooks not installed" << std::endl;
		return true;
	}
	gate_enabled.store(true, std::memory_order_release);
	const auto dispatch = resolve_unique<GfxDispatch>(signature_gfx_dispatch, "GFx hyperlink dispatcher");
	const auto set_string = resolve_unique<SetStringVariable>(signature_set_string_variable, "SetStringVariable");
	movie_argument = resolve_unique<MovieArgument>(signature_movie_argument, "movie argument reader");
	string_argument = resolve_unique<StringArgument>(signature_string_argument, "string argument reader");
	type_argument = resolve_unique<TypeArgument>(game_version >= GV(44, 0, 0) ? signature_type_argument_u44 : signature_type_argument, "type argument reader");
	if (dispatch == nullptr || set_string == nullptr || movie_argument == nullptr
		|| string_argument == nullptr || type_argument == nullptr) return false;
	if (!create_hook(gfx_hook, reinterpret_cast<void*>(dispatch), reinterpret_cast<void*>(&gfx_dispatch_detour), "GFx")
		|| !create_hook(set_string_hook, reinterpret_cast<void*>(set_string), reinterpret_cast<void*>(&set_string_detour), "SetStringVariable"))
	{
		if (set_string_hook.isCreated()) { set_string_hook.disable(); set_string_hook.destroy(); }
		if (gfx_hook.isCreated()) { gfx_hook.disable(); gfx_hook.destroy(); }
		return false;
	}
	hooks_installed.store(true, std::memory_order_release);
	conout << "RENOVICE Riven lock enabled: gate=" << gate()
		<< " endpoint=" << server_host << ':' << (secure_connections ? https_port : http_port) << std::endl;
	return true;
}

// F9 stage. The Riven lock is an optional capability: its gate file can never
// reject the F9 transaction. Absent means off; an unreadable path keeps the
// current gate and is reported capability-locally.
void prepare_gate_reload()
{
	std::error_code error;
	const auto gate_file = classify_gate_file(gate_file_path(), error);
	if (gate_file == GateFile::Unreadable)
	{
		prepared_gate.reset();
		const std::string line = "RENOVICE Riven gate read FAIL reason=" + error.message()
			+ " scope=capability-local gate=retained";
		conout << line << std::endl;
		config::log(line);
		return;
	}
	prepared_gate = gate_file == GateFile::Present;
}

void commit_prepared_gate()
{
	if (!prepared_gate) return;
	const bool present = *prepared_gate;
	prepared_gate.reset();
	gate_enabled.store(present, std::memory_order_release);
	if (!present)
	{
		redraw_pending.store(false, std::memory_order_release);
		invalidate_context();
	}
	else if (!hooks_installed.load(std::memory_order_acquire)
		&& !restart_note_logged.exchange(true, std::memory_order_acq_rel))
	{
		const char* line = "RENOVICE Riven gate on but hooks not installed (riven_lock.cfg was absent at startup); restart the game to enable the Riven lock";
		conout << line << std::endl;
		config::log(line);
	}
}

void discard_prepared_gate()
{
	prepared_gate.reset();
}
}
