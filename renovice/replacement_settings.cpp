#include "replacement_settings.hpp"

#include "config.hpp"

#include <atomic>
#include <iomanip>
#include <sstream>
#include <string>

namespace renovice::replacement_settings
{
namespace
{
std::atomic<std::shared_ptr<const Snapshot>> committed_snapshot{std::make_shared<const Snapshot>()};
std::atomic<std::uint64_t> next_serial{1};

std::string key_text(std::uint64_t key)
{
	std::ostringstream text;
	text << std::hex << std::setw(16) << std::setfill('0') << key;
	return text.str();
}

std::string short_identity(const std::string& identity)
{
	const auto colon = identity.find(':');
	const auto hex = colon == std::string::npos ? identity : identity.substr(colon + 1);
	return hex.substr(0, 16);
}
}

void commit(const std::shared_ptr<const packages::Snapshot>& committed_packages, const char* trigger)
{
	const auto serial = next_serial.fetch_add(1, std::memory_order_relaxed);
	auto snapshot = std::make_shared<const Snapshot>(build_snapshot(committed_packages.get(), serial));
	const auto previous = committed_snapshot.exchange(snapshot, std::memory_order_acq_rel);
	if (snapshot->entries.empty() && (previous == nullptr || previous->entries.empty())) return;
	const char* label = trigger != nullptr ? trigger : "unknown";
	for (const auto& entry : snapshot->entries)
	{
		config::log("RENOVICE REPLACEMENT SETTINGS ENTRY trigger=" + std::string(label)
			+ " key=" + key_text(entry.key)
			+ " package=" + entry.package
			+ " member=" + entry.member
			+ " values=" + std::to_string(entry.delivery->values.size())
			+ " identity=" + short_identity(entry.delivery->identity)
			+ " accessor=" + accessor_global_name);
	}
	config::log("RENOVICE REPLACEMENT SETTINGS COMMIT trigger=" + std::string(label)
		+ " serial=" + std::to_string(serial)
		+ " entries=" + std::to_string(snapshot->entries.size())
		+ " previous_entries=" + std::to_string(previous != nullptr ? previous->entries.size() : 0)
		+ " contract=" + std::string(contract_name));
}

std::shared_ptr<const Snapshot> committed() noexcept
{
	auto snapshot = committed_snapshot.load(std::memory_order_acquire);
	return snapshot;
}
}
