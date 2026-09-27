#include "owf_hotkeys.hpp"

#include <atomic>
#include <deque>
#include <mutex>

#include <joaat.hpp>
#include <json.hpp>
#include <Key.hpp>
#include <ObfusString.hpp>

#include <lauxlib.h>

#include "owf_console.hpp"
#include "owf_repo.hpp"
#include "owf_scripting.hpp"

using namespace soup;

namespace
{
	constexpr std::size_t max_latched_hotkey_scripts = 64;
	std::mutex latched_hotkey_scripts_mtx;
	std::deque<std::string> latched_hotkey_scripts;
	std::atomic<std::uint64_t> latched_hotkey_edges_captured{ 0 };
	std::atomic<std::uint64_t> latched_hotkey_scripts_dispatched{ 0 };
	std::atomic<std::uint64_t> latched_hotkey_edges_dropped{ 0 };
}

void load_hotkeys()
{
	// Due to the way load_hotkeys is called, g_repo_mtx does not need to be locked.
	// Furthermore, g_repo_mtx cannot be locked during lua_pcall as it would make owf_repo_find fail because g_repo_mtx is not recursive.
	auto L = luaL_newstate();
	owfScript::openLibs(L);
	size_t size;
	auto data = g_repo.find(soup::joaat::compileTimeHash("OpenWF/helpers/pre_load_hotkeys.pluto"), size);
	if (luaL_loadbuffer(L, data, size, nullptr) != LUA_OK
		|| lua_pcall(L, 0, 0, 0) != LUA_OK
		)
	{
		owfScript::logNl(lua_type(L, -1) == LUA_TSTRING ? pluto_checkstring(L, -1) : ObfusString("Non-string script error").str());
	}
	lua_close(L);

	std::vector<owfHotkey> hks;
	try
	{
		auto jr = json::decodeFile(ObfusString("OpenWF/Hotkeys.json").str());
		SOUP_ASSERT(jr);
		for (const auto& jc : jr->asArr().children)
		{
			auto& jHk = jc->asObj();
			auto& hk = hks.emplace_back();
			auto& jKey = jHk.at(ObfusString("key"));
			if (jKey.isStr())
			{
				hk.vk = soup::string_to_virtual_key(jKey.reinterpretAsStr().value.data(), jKey.reinterpretAsStr().value.size());
				if (!hk.vk)
				{
					std::string msg = ObfusString("Invalid key: ").str();
					msg.append(jKey.asStr());
					soup::throwAssertionFailed(msg.c_str());
				}
			}
			else
			{
				hk.vk = jKey.asInt();
			}
			hk.has_ctrl = jHk.contains(ObfusString("ctrl"));
			hk.ctrl = hk.has_ctrl && jHk.at(ObfusString("ctrl")).asBool();
			hk.has_shift = jHk.contains(ObfusString("shift"));
			hk.shift = hk.has_shift && jHk.at(ObfusString("shift")).asBool();
			hk.has_alt = jHk.contains(ObfusString("alt"));
			hk.alt = hk.has_alt && jHk.at(ObfusString("alt")).asBool();
			hk.was_pressed = hk.isPressed();
			hk.script = jHk.at(ObfusString("script")).asStr();
		}
	}
	catch (std::exception& e)
	{
		conout << ObfusString("Failed to load Hotkeys.json: ").str() << e.what() << std::endl;
	}
	hotkeys_mtx.lock();
	hotkeys = std::move(hks);
	hotkeys_mtx.unlock();
}

void poll_openwf_hotkey_inputs(bool input_allowed) noexcept
{
	if (!hotkeys_mtx.tryLock()) return;
	try
	{
		for (auto& hk : hotkeys)
		{
			// Always track the physical release, including while focus/input policy
			// blocks dispatch. Otherwise a key captured before a menu transition
			// can remain logically held and suppress the next valid press.
			const bool pressed = hk.isPressed();
			const bool just_pressed = pressed && !hk.was_pressed;
			hk.was_pressed = pressed;
			if (!input_allowed || !just_pressed) continue;
			std::lock_guard lock(latched_hotkey_scripts_mtx);
			if (latched_hotkey_scripts.size() >= max_latched_hotkey_scripts)
			{
				latched_hotkey_edges_dropped.fetch_add(1, std::memory_order_relaxed);
				continue;
			}
			latched_hotkey_scripts.emplace_back(hk.script);
			latched_hotkey_edges_captured.fetch_add(1, std::memory_order_relaxed);
		}
	}
	catch (...)
	{
		latched_hotkey_edges_dropped.fetch_add(1, std::memory_order_relaxed);
	}
	hotkeys_mtx.unlock();
}

bool pop_latched_openwf_hotkey_script(std::string& script) noexcept
{
	try
	{
		std::lock_guard lock(latched_hotkey_scripts_mtx);
		if (latched_hotkey_scripts.empty()) return false;
		script = std::move(latched_hotkey_scripts.front());
		latched_hotkey_scripts.pop_front();
		return true;
	}
	catch (...)
	{
		latched_hotkey_edges_dropped.fetch_add(1, std::memory_order_relaxed);
		return false;
	}
}

void note_openwf_hotkey_script_dispatched() noexcept
{
	latched_hotkey_scripts_dispatched.fetch_add(1, std::memory_order_relaxed);
}

std::uint64_t openwf_hotkey_edges_captured() noexcept
{
	return latched_hotkey_edges_captured.load(std::memory_order_relaxed);
}

std::uint64_t openwf_hotkey_scripts_dispatched() noexcept
{
	return latched_hotkey_scripts_dispatched.load(std::memory_order_relaxed);
}

std::uint64_t openwf_hotkey_edges_dropped() noexcept
{
	return latched_hotkey_edges_dropped.load(std::memory_order_relaxed);
}

std::size_t openwf_hotkey_scripts_pending() noexcept
{
	std::lock_guard lock(latched_hotkey_scripts_mtx);
	return latched_hotkey_scripts.size();
}
