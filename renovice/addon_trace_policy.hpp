#pragma once
#include "config_core.hpp"

#include <cctype>
#include <cstdint>
#include <string>
#include <string_view>
#include <algorithm>
#include <vector>

namespace renovice::injection {
enum class DiagnosticBridgeAction : std::uint8_t
{
	leave_absent,
	install,
	keep_owned,
	remove_owned,
	leave_foreign_disabled,
	reject_collision,
	reject_prerequisite,
};

inline bool diagnostic_bridge_may_format(config::DiagnosticsMode mode) noexcept
{
	return mode == config::DiagnosticsMode::battle
		|| mode == config::DiagnosticsMode::trace;
}

// Output admission must precede inserted Lua snapshots, not just the final
// formatter. Completing an already-started observation remains unconditional.
inline bool diagnostic_snapshot_work_allowed(config::DiagnosticsMode mode,
    std::uint64_t emitted_or_attempted, std::uint64_t maximum_events) noexcept
{
    return diagnostic_bridge_may_format(mode) && emitted_or_attempted < maximum_events;
}

inline bool automatic_scripted_damage_requested(
	const config::Flags& flags) noexcept
{
	return diagnostic_bridge_may_format(flags.diagnostics_mode)
		&& flags.diagnostics_damage_capture
			!= config::DamageCaptureMode::off
		&& flags.diagnostics_damage_type_filter_valid;
}

// The observer also serves native HUD buff reads without enabling damage capture.
inline bool universal_buffs_requested(const config::Flags& flags) noexcept
{
    return flags.diagnostics_buffs && diagnostic_bridge_may_format(flags.diagnostics_mode);
}

inline bool universal_observer_requested(const config::Flags& flags) noexcept
{
    return automatic_scripted_damage_requested(flags) || universal_buffs_requested(flags);
}

// The hook list is one contract shared by startup/F9 and natural addon loads.
// A target activation must not drop the observer's native methods. Off removes
// optional requests while preserving methods explicitly requested by addons.
inline std::vector<std::string> native_calls_with_diagnostics(
    const config::Flags& flags, std::vector<std::string> names)
{
    if (automatic_scripted_damage_requested(flags)) {
        names.emplace_back("DamageDD");
        if (flags.diagnostics_caster_stats) {
            names.emplace_back("SetSource");
            names.emplace_back("ModifyValue");
            names.emplace_back("GetUpgradeModifiedValue");
        }
        if (flags.diagnostics_damage_capture == config::DamageCaptureMode::engine)
            names.emplace_back("RadialDamage");
    }
    if (universal_buffs_requested(flags)) {
        names.emplace_back("GetBuffNotifications");
        names.emplace_back("GetHudStatus");
    }
    std::sort(names.begin(), names.end());
    names.erase(std::unique(names.begin(), names.end()), names.end());
	return names;
}

inline bool diagnostics_claims_native_method(
	const config::Flags& flags, std::string_view method) noexcept
{
	if (automatic_scripted_damage_requested(flags))
	{
		if (method == "DamageDD") return true;
		if (flags.diagnostics_caster_stats
			&& (method == "SetSource" || method == "ModifyValue"
				|| method == "GetUpgradeModifiedValue"))
		{
			return true;
		}
		if (flags.diagnostics_damage_capture == config::DamageCaptureMode::engine
			&& method == "RadialDamage")
		{
			return true;
		}
	}
	return universal_buffs_requested(flags)
		&& (method == "GetBuffNotifications" || method == "GetHudStatus");
}

inline bool automatic_scripted_damage_selected(
	const config::Flags& flags,
	std::string_view method,
	std::uint64_t source_body,
	std::string_view source_path,
	std::string_view source_name,
	std::string_view target_type)
{
	if (!automatic_scripted_damage_requested(flags)
		|| !flags.diagnostics_addon.empty())
	{
		return false;
	}
	if (!flags.diagnostics_method.empty()
		&& config::ascii_lower(method) != flags.diagnostics_method)
	{
		return false;
	}
	if (config::ascii_lower(method) != "damagedd") return false;
	if (flags.diagnostics_target_filter_set
		&& (!flags.diagnostics_target_filter_valid
			|| source_body == 0
			|| source_body != flags.diagnostics_target_key))
	{
		return false;
	}
	if (!flags.diagnostics_damage_source.empty()
		&& config::ascii_lower(source_path) != flags.diagnostics_damage_source
		&& config::ascii_lower(source_name) != flags.diagnostics_damage_source)
	{
		return false;
	}
	return flags.diagnostics_damage_target_type.empty()
		|| config::ascii_lower(target_type)
			== flags.diagnostics_damage_target_type;
}

inline bool preserve_owned_diagnostic_bridge_for_other_target(
	const config::Flags& flags,
	bool bridge_allowed,
	bool selected_for_this_target,
	bool global_bridge_reconciliation) noexcept
{
	// `_T.RENOVICE_TRACE` is VM-wide. Loading another target addon in the same
	// VM must not remove a bridge owned by the configured diagnostic target.
	// Only the explicit VM reconciliation path may remove an owned bridge while
	// diagnostics are otherwise enabled.
	return !global_bridge_reconciliation
		&& bridge_allowed
		&& !selected_for_this_target
		&& diagnostic_bridge_may_format(flags.diagnostics_mode)
		&& flags.diagnostics_method.empty()
		&& flags.diagnostics_addon.empty()
		&& (!flags.diagnostics_target_filter_set
			|| flags.diagnostics_target_filter_valid);
}

inline bool diagnostic_bridge_registry_root_required(
	bool diagnostics_enabled,
	bool preserve_owned_bridge,
	bool automatic_capture_requested = false) noexcept
{
	// The C++ TValue cache is not a Luau GC root. The trace closure must remain
	// rooted in the VM registry when the selected target owns diagnostics, and
	// while an unrelated target activation preserves that selected session.
	return diagnostics_enabled || preserve_owned_bridge || automatic_capture_requested;
}

inline DiagnosticBridgeAction classify_diagnostic_bridge_action(
	bool requested,
	bool field_present,
	bool field_owned,
	bool can_mutate) noexcept
{
	if (requested)
	{
		if (!field_present)
			return can_mutate
				? DiagnosticBridgeAction::install
				: DiagnosticBridgeAction::reject_prerequisite;
		return field_owned
			? DiagnosticBridgeAction::keep_owned
			: DiagnosticBridgeAction::reject_collision;
	}
	if (!field_present) return DiagnosticBridgeAction::leave_absent;
	if (!field_owned) return DiagnosticBridgeAction::leave_foreign_disabled;
	return can_mutate
		? DiagnosticBridgeAction::remove_owned
		: DiagnosticBridgeAction::reject_prerequisite;
}

inline bool diagnostic_error_event(std::string_view event) noexcept
{
	return event.find("error") != std::string_view::npos
		|| event.find("reject") != std::string_view::npos
		|| event.find("failed") != std::string_view::npos;
}

inline bool diagnostic_runtime_event_allowed(
	config::DiagnosticsMode mode,
	std::string_view event) noexcept
{
	if (mode == config::DiagnosticsMode::off) return false;
	if (mode == config::DiagnosticsMode::trace) return true;
	return diagnostic_error_event(event);
}

inline bool exact_diagnostic_field_match(
	std::string_view detail,
	std::string_view field,
	std::string_view expected)
{
	if (expected.empty()) return true;
	const auto lowered = config::ascii_lower(detail);
	std::string needle(field);
	needle += '=';
	needle += expected;
	for (auto at = lowered.find(needle); at != std::string::npos;
		at = lowered.find(needle, at + 1))
	{
		if (at != 0
			&& !std::isspace(static_cast<unsigned char>(lowered[at - 1])))
		{
			continue;
		}
		const auto end = at + needle.size();
		if (end == lowered.size()
			|| std::isspace(static_cast<unsigned char>(lowered[end])))
		{
			return true;
		}
	}
	return false;
}

inline bool diagnostic_trace_selected(
	const config::Flags& flags,
	std::uint64_t key,
	std::string_view event,
	std::string_view detail)
{
	if (flags.diagnostics_target_filter_set
		&& (!flags.diagnostics_target_filter_valid
			|| flags.diagnostics_target_key != key))
	{
		return false;
	}
	if (!flags.diagnostics_method.empty())
	{
		const auto lowered_event = config::ascii_lower(event);
		const std::string native_event = "nativecalls." + flags.diagnostics_method;
		const bool exact_event_method = lowered_event == native_event
			|| (lowered_event.size() > native_event.size()
				&& lowered_event.compare(0, native_event.size(), native_event) == 0
				&& lowered_event[native_event.size()] == '.');
		if (!exact_event_method
			&& !exact_diagnostic_field_match(
				detail, "method", flags.diagnostics_method))
		{
			return false;
		}
	}
	return flags.diagnostics_addon.empty()
		|| exact_diagnostic_field_match(detail, "addon", flags.diagnostics_addon);
}

inline bool diagnostic_native_ingress_selected(
	const config::Flags& flags,
	std::string_view method)
{
	// Native ingress runs before target/callsite ownership is known. Keep the
	// configured target as a required, valid diagnostic intent, then select only
	// the exact requested method. An addon filter cannot be proven here.
	if (flags.diagnostics_mode != config::DiagnosticsMode::trace
		|| (flags.diagnostics_target_filter_set
			&& !flags.diagnostics_target_filter_valid)
		|| !flags.diagnostics_addon.empty())
	{
		return false;
	}
	return flags.diagnostics_method.empty()
		|| config::ascii_lower(method) == flags.diagnostics_method;
}

inline bool sample_native_ingress(
	std::uint64_t count,
	std::uint64_t configured_maximum) noexcept
{
	// Native methods can be extremely hot. The normal diagnostics budget still
	// applies, with a smaller hard ceiling for pre-dispatch stack observations.
	constexpr std::uint64_t ingress_hard_limit = 128;
	const auto limit = configured_maximum < ingress_hard_limit
		? configured_maximum : ingress_hard_limit;
	return count != 0 && count <= limit;
}

inline bool sample_repeated_skip_trace(std::uint64_t count) noexcept
{
	// Yielded Luau calls can report the same preserved-stock-result condition
	// thousands of times. Retain the first exact examples and sparse recurrence
	// proof without consuming the shared diagnostic event budget.
	return count != 0 && (count <= 8 || count % 256 == 0);
}

inline bool sample_damage_trace(std::uint64_t count, std::uint64_t positive_count,
    bool positive) noexcept
{
    return count <= 3 || (positive && positive_count <= 3) || count % 512 == 0;
}
// ---------------------------------------------------------------------------
// Diagnostics hot path (2026-09-29, Mallet lag audit).
// ---------------------------------------------------------------------------

// 64-bit FNV-1a identity of (event text, target key, VM) for the once-only
// operational "native hook PASS" line. Checked before any formatting.
inline std::uint64_t native_hook_event_identity(
	const char* event, std::uint64_t target_key, const void* vm) noexcept
{
	std::uint64_t hash = 1469598103934665603ull;
	const auto mix = [&](unsigned char byte) noexcept
	{
		hash ^= byte;
		hash *= 1099511628211ull;
	};
	if (event != nullptr)
		for (const char* at = event; *at != '\0'; ++at) mix(static_cast<unsigned char>(*at));
	mix(0xff);
	for (int shift = 0; shift != 64; shift += 8)
		mix(static_cast<unsigned char>((target_key >> shift) & 0xffu));
	const auto address = reinterpret_cast<std::uintptr_t>(vm);
	for (int shift = 0; shift != 64; shift += 8)
		mix(static_cast<unsigned char>((static_cast<std::uint64_t>(address) >> shift) & 0xffu));
	return hash;
}

// Per-hit trace lanes (one line per damage hit, hook dispatch, native call or
// Lua call). They are rate limited per event name in trace mode; load-time
// structural events (module.prototype, install, attach, ...) are not.
inline bool diagnostic_per_hit_event(std::string_view event) noexcept
{
	for (const std::string_view prefix : {
		std::string_view{"damage."}, std::string_view{"dispatch."},
		std::string_view{"native."}, std::string_view{"lua.call."},
		std::string_view{"luaCalls."}})
	{
		if (event.size() >= prefix.size() && event.compare(0, prefix.size(), prefix) == 0)
			return true;
	}
	return false;
}

inline constexpr std::uint64_t diagnostic_rate_window_ms = 1000;
inline constexpr std::uint32_t diagnostic_rate_lines_per_window = 32;
inline constexpr std::size_t diagnostic_rate_event_slots = 64;

struct DiagnosticRateReport
{
	bool pending = false;
	char event[48]{};
	std::uint64_t window_ms = 0;
	std::uint32_t admitted = 0;
	std::uint64_t suppressed = 0;
	std::uint64_t untracked_dropped = 0;
};

struct DiagnosticRateDecision
{
	bool admit = false;
	DiagnosticRateReport report; // emit before the admitted line, if pending
};

// Bounded, deterministic per-event-name limiter: at most N lines per event per
// window. A window that ended with suppressed lines yields exactly one summary
// (dedup/suppression count). Events beyond the slot table are dropped and
// counted. No allocation; the caller serializes access.
class DiagnosticEventRateLimiter
{
public:
	DiagnosticRateDecision admit(std::string_view event, std::uint64_t now_ms) noexcept
	{
		DiagnosticRateDecision decision;
		collect_expired(now_ms, decision.report);
		Slot* slot = find(event);
		if (slot == nullptr) slot = claim(event, now_ms);
		if (slot == nullptr)
		{
			++untracked_dropped_;
			return decision;
		}
		if (now_ms < slot->window_start || now_ms - slot->window_start >= diagnostic_rate_window_ms)
		{
			if (slot->suppressed != 0 && !decision.report.pending)
				report(*slot, now_ms, decision.report);
			slot->window_start = now_ms;
			slot->admitted = 0;
			slot->suppressed = 0;
		}
		if (slot->admitted < diagnostic_rate_lines_per_window)
		{
			++slot->admitted;
			decision.admit = true;
		}
		else ++slot->suppressed;
		return decision;
	}

	std::uint64_t untracked_dropped() const noexcept { return untracked_dropped_; }

	void reset() noexcept
	{
		for (auto& slot : slots_) slot = Slot{};
		untracked_dropped_ = 0;
	}

private:
	struct Slot
	{
		bool used = false;
		char event[48]{};
		std::size_t length = 0;
		std::uint64_t window_start = 0;
		std::uint32_t admitted = 0;
		std::uint64_t suppressed = 0;
	};

	Slot* find(std::string_view event) noexcept
	{
		const auto length = event.size() < sizeof(Slot::event) - 1 ? event.size() : sizeof(Slot::event) - 1;
		for (auto& slot : slots_)
		{
			if (slot.used && slot.length == length
				&& std::string_view(slot.event, slot.length) == event.substr(0, length))
			{
				return &slot;
			}
		}
		return nullptr;
	}

	Slot* claim(std::string_view event, std::uint64_t now_ms) noexcept
	{
		for (auto& slot : slots_)
		{
			if (slot.used) continue;
			slot.used = true;
			slot.length = event.size() < sizeof(Slot::event) - 1 ? event.size() : sizeof(Slot::event) - 1;
			for (std::size_t i = 0; i != slot.length; ++i) slot.event[i] = event[i];
			slot.event[slot.length] = '\0';
			slot.window_start = now_ms;
			return &slot;
		}
		return nullptr;
	}

	void report(Slot& slot, std::uint64_t now_ms, DiagnosticRateReport& out) noexcept
	{
		out.pending = true;
		for (std::size_t i = 0; i <= slot.length; ++i) out.event[i] = slot.event[i];
		out.window_ms = now_ms >= slot.window_start ? now_ms - slot.window_start : 0;
		out.admitted = slot.admitted;
		out.suppressed = slot.suppressed;
		out.untracked_dropped = untracked_dropped_;
		untracked_dropped_ = 0;
	}

	// One pending summary per call from any slot whose window has ended.
	void collect_expired(std::uint64_t now_ms, DiagnosticRateReport& out) noexcept
	{
		for (auto& slot : slots_)
		{
			if (!slot.used || slot.suppressed == 0) continue;
			if (now_ms >= slot.window_start && now_ms - slot.window_start < diagnostic_rate_window_ms)
				continue;
			report(slot, now_ms, out);
			slot.window_start = now_ms;
			slot.admitted = 0;
			slot.suppressed = 0;
			return;
		}
	}

	Slot slots_[diagnostic_rate_event_slots]{};
	std::uint64_t untracked_dropped_ = 0;
};

struct DamagePerformanceWindow
{
    std::uint64_t calls = 0, positive = 0, zero = 0, errors = 0;
    std::uint64_t ticks = 0, maximum_ticks = 0;
    void add(bool is_positive, bool is_zero, std::uint64_t duration, std::uint64_t failures) noexcept
    {
        ++calls;
        positive += is_positive;
        zero += is_zero;
        errors += failures;
        ticks += duration;
        if (duration > maximum_ticks) maximum_ticks = duration;
    }
};
}
