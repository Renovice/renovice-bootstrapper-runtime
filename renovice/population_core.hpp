#pragma once

// Population diagnostics channel core (2026-10-30). Pure and game-free so the
// offline gate can pin deduplication, mission summaries, bounds and the
// sample cadence. The runtime owns one Tracker on the owning DE VM thread.

#include <algorithm>
#include <charconv>
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace renovice::population
{
inline constexpr std::uint64_t default_interval_ms = 5000;
inline constexpr std::uint64_t minimum_interval_ms = 1000;
inline constexpr std::uint64_t maximum_interval_ms = 60000;
inline constexpr std::size_t maximum_probe_text = 512;
// After a failed load or call the channel backs off this long before retrying.
inline constexpr std::uint64_t failure_backoff_ms = 60000;

inline std::uint64_t clamp_interval(std::uint64_t value) noexcept
{
	return (std::min)((std::max)(value, minimum_interval_ms), maximum_interval_ms);
}

inline std::uint64_t interval_value(std::string_view value) noexcept
{
	std::uint64_t parsed = 0;
	const auto conversion = std::from_chars(value.data(), value.data() + value.size(), parsed);
	if (value.empty() || conversion.ec != std::errc{}
		|| conversion.ptr != value.data() + value.size())
	{
		return default_interval_ms;
	}
	return clamp_interval(parsed);
}

// Rate limit against a monotonic tick. A tick that moves backwards admits.
inline bool sample_due(bool sampled_before, std::uint64_t now_ms,
	std::uint64_t last_ms, std::uint64_t interval_ms) noexcept
{
	return !sampled_before || now_ms < last_ms || now_ms - last_ms >= interval_ms;
}

// Value of "<key>=<integer>" in a probe string; false when absent or non-numeric.
inline bool field_value(std::string_view probe, std::string_view key, std::int64_t& out) noexcept
{
	std::size_t at = 0;
	while (at <= probe.size())
	{
		const auto found = probe.find(key, at);
		if (found == std::string_view::npos) return false;
		const bool starts = found == 0 || probe[found - 1] == ' ';
		const auto value_at = found + key.size();
		if (starts && value_at < probe.size() && probe[value_at] == '=')
		{
			auto end = probe.find(' ', value_at + 1);
			if (end == std::string_view::npos) end = probe.size();
			const auto text = probe.substr(value_at + 1, end - value_at - 1);
			std::int64_t parsed = 0;
			const auto conversion = std::from_chars(text.data(), text.data() + text.size(), parsed);
			if (text.empty() || conversion.ec != std::errc{}
				|| conversion.ptr != text.data() + text.size()) return false;
			out = parsed;
			return true;
		}
		at = found + 1;
	}
	return false;
}

inline bool director_present(std::string_view probe) noexcept
{
	return probe.rfind("director=", 0) != 0;
}

// Collapses identical consecutive probes, emits a summary when a director
// disappears (mission end) or at flush, and bounds every emitted line.
class Tracker
{
public:
	explicit Tracker(std::uint64_t max_lines) noexcept : max_lines_(max_lines) {}

	// One sample. Returns the lines to emit (already prefixed, bounded).
	std::vector<std::string> sample(std::string_view probe, std::uint64_t now_ms)
	{
		std::vector<std::string> out;
		if (probe.size() > maximum_probe_text) probe = probe.substr(0, maximum_probe_text);
		if (!started_)
		{
			started_ = true;
			first_ms_ = now_ms;
		}
		const bool present = director_present(probe);
		if (present && !mission_active_)
		{
			mission_active_ = true;
			mission_ = Mission{};
			mission_.first_ms = now_ms;
		}
		if (present)
		{
			++mission_.samples;
			mission_.last_ms = now_ms;
			std::int64_t value = 0;
			if (field_value(probe, "alive", value))
			{
				++mission_.alive_samples;
				mission_.alive_sum += value;
				mission_.peak_alive = (std::max)(mission_.peak_alive, value);
			}
			if (field_value(probe, "hardcap", value))
				mission_.peak_hardcap = (std::max)(mission_.peak_hardcap, value);
		}
		if (has_last_ && probe == last_)
		{
			++repeats_;
		}
		else
		{
			flush_repeats(out, now_ms);
			emit(out, "RENOVICE POPULATION t=" + seconds(now_ms) + ' ' + std::string(probe));
			last_.assign(probe.data(), probe.size());
			has_last_ = true;
		}
		if (!present && mission_active_) emit_summary(out);
		return out;
	}

	// Shutdown/flush: pending repeat counter and an open mission summary.
	std::vector<std::string> flush(std::uint64_t now_ms)
	{
		std::vector<std::string> out;
		flush_repeats(out, now_ms);
		if (mission_active_) emit_summary(out);
		return out;
	}

	std::uint64_t emitted() const noexcept { return emitted_; }
	bool mission_active() const noexcept { return mission_active_; }

private:
	struct Mission
	{
		std::uint64_t first_ms = 0;
		std::uint64_t last_ms = 0;
		std::uint64_t samples = 0;
		std::uint64_t alive_samples = 0;
		std::int64_t alive_sum = 0;
		std::int64_t peak_alive = 0;
		std::int64_t peak_hardcap = 0;
	};

	std::string seconds(std::uint64_t now_ms) const
	{
		return std::to_string((now_ms - first_ms_) / 1000);
	}

	void emit(std::vector<std::string>& out, std::string line)
	{
		if (emitted_ > max_lines_) return;
		if (emitted_ == max_lines_)
		{
			++emitted_;
			out.emplace_back("RENOVICE POPULATION limit reached max_events="
				+ std::to_string(max_lines_) + "; further lines suppressed");
			return;
		}
		++emitted_;
		out.push_back(std::move(line));
	}

	void flush_repeats(std::vector<std::string>& out, std::uint64_t now_ms)
	{
		if (repeats_ == 0) return;
		emit(out, "RENOVICE POPULATION t=" + seconds(now_ms) + " repeat="
			+ std::to_string(repeats_));
		repeats_ = 0;
	}

	void emit_summary(std::vector<std::string>& out)
	{
		const auto average = mission_.alive_samples == 0 ? 0
			: mission_.alive_sum / static_cast<std::int64_t>(mission_.alive_samples);
		emit(out, "RENOVICE POPULATION SUMMARY samples=" + std::to_string(mission_.samples)
			+ " peak_alive=" + std::to_string(mission_.peak_alive)
			+ " avg_alive=" + std::to_string(average)
			+ " peak_hardcap=" + std::to_string(mission_.peak_hardcap)
			+ " duration_s=" + std::to_string((mission_.last_ms - mission_.first_ms) / 1000));
		mission_active_ = false;
		mission_ = Mission{};
	}

	std::uint64_t max_lines_ = 0;
	std::uint64_t emitted_ = 0;
	std::uint64_t first_ms_ = 0;
	std::uint64_t repeats_ = 0;
	bool started_ = false;
	bool has_last_ = false;
	bool mission_active_ = false;
	std::string last_;
	Mission mission_;
};
}
