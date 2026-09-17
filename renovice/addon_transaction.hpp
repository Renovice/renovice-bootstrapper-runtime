#pragma once

#include <cstddef>
#include <utility>
#include <vector>

namespace renovice::injection
{
enum class TransactionResult
{
	Committed,
	CleanupRejected,
	ActivationRejected,
	ReleaseRejected,
	RollbackFailed,
};

template <typename Record, typename Cleanup, typename Activate, typename Release>
TransactionResult commit_addon_generation(
	std::vector<Record>& active,
	std::vector<Record>& staged,
	Cleanup&& cleanup,
	Activate&& activate,
	Release&& release)
{
	for (std::size_t i = 0; i != active.size(); ++i)
	{
		if (!cleanup(active[i]))
		{
			bool rollback_ok = true;
			for (const auto& old : active) rollback_ok = activate(old) && rollback_ok;
			for (const auto& candidate : staged) rollback_ok = release(candidate) && rollback_ok;
			staged.clear();
			return rollback_ok ? TransactionResult::CleanupRejected : TransactionResult::RollbackFailed;
		}
	}

	std::size_t activated = 0;
	for (; activated != staged.size(); ++activated)
	{
		if (!activate(staged[activated]))
		{
			bool rollback_ok = true;
			for (std::size_t i = 0; i <= activated; ++i)
			{
				rollback_ok = cleanup(staged[i]) && rollback_ok;
			}
			for (const auto& old : active) rollback_ok = activate(old) && rollback_ok;
			for (const auto& candidate : staged) rollback_ok = release(candidate) && rollback_ok;
			staged.clear();
			return rollback_ok ? TransactionResult::ActivationRejected : TransactionResult::RollbackFailed;
		}
	}

	bool released = true;
	for (const auto& old : active) released = release(old) && released;
	active = std::move(staged);
	staged.clear();
	return released ? TransactionResult::Committed : TransactionResult::ReleaseRejected;
}

// Rebind an already rooted generation without asking the DE loader to execute
// unchanged top-level bytecode again. This is the correct transaction when the
// VM registry roots and addon bytes are unchanged but DE replaced the shared
// `_T` table: cleanup unregisters state from the old table, activate registers
// against the current table, and no registry root is released.
template <typename Record, typename Cleanup, typename Activate>
TransactionResult reactivate_addon_generation(
	std::vector<Record>& active,
	Cleanup&& cleanup,
	Activate&& activate)
{
	for (std::size_t i = 0; i != active.size(); ++i)
	{
		if (!cleanup(active[i]))
		{
			bool rollback_ok = true;
			for (const auto& old : active) rollback_ok = activate(old) && rollback_ok;
			return rollback_ok ? TransactionResult::CleanupRejected : TransactionResult::RollbackFailed;
		}
	}

	for (std::size_t activated = 0; activated != active.size(); ++activated)
	{
		if (!activate(active[activated]))
		{
			bool rollback_ok = true;
			for (std::size_t i = 0; i <= activated; ++i)
			{
				rollback_ok = cleanup(active[i]) && rollback_ok;
			}
			for (const auto& old : active) rollback_ok = activate(old) && rollback_ok;
			return rollback_ok ? TransactionResult::ActivationRejected : TransactionResult::RollbackFailed;
		}
	}
	return TransactionResult::Committed;
}
}
