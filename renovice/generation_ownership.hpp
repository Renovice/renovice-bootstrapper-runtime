#pragma once

#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <mutex>

namespace renovice::injection
{
// Host callbacks borrow the currently published Lua generation.  A reload
// closes admission, waits for existing borrowers, swaps/releases Lua roots,
// then reopens admission.  Nested callbacks on an already admitted thread are
// part of the same borrow and may finish while admission is closed.
class GenerationDispatchGate
{
public:
	class Lease
	{
	public:
		Lease() noexcept = default;
		explicit Lease(GenerationDispatchGate* owner) noexcept : owner_(owner) {}
		Lease(const Lease&) = delete;
		Lease& operator=(const Lease&) = delete;
		Lease(Lease&& other) noexcept : owner_(other.owner_)
		{
			other.owner_ = nullptr;
		}
		Lease& operator=(Lease&& other) noexcept
		{
			if (this != &other)
			{
				release();
				owner_ = other.owner_;
				other.owner_ = nullptr;
			}
			return *this;
		}
		~Lease() noexcept { release(); }
		explicit operator bool() const noexcept { return owner_ != nullptr; }

	private:
		void release() noexcept
		{
			if (owner_ != nullptr)
			{
				owner_->release_dispatch();
				owner_ = nullptr;
			}
		}
		GenerationDispatchGate* owner_ = nullptr;
	};

	class Mutation
	{
	public:
		Mutation() noexcept = default;
		Mutation(GenerationDispatchGate* owner, bool admitted,
			std::unique_lock<std::mutex>&& serial = {}) noexcept
			: owner_(owner), admitted_(admitted), serial_(std::move(serial)) {}
		Mutation(const Mutation&) = delete;
		Mutation& operator=(const Mutation&) = delete;
		Mutation(Mutation&& other) noexcept
			: owner_(other.owner_), admitted_(other.admitted_),
			  serial_(std::move(other.serial_))
		{
			other.owner_ = nullptr;
			other.admitted_ = false;
		}
		Mutation& operator=(Mutation&& other) noexcept
		{
			if (this != &other)
			{
				release();
				owner_ = other.owner_;
				admitted_ = other.admitted_;
				serial_ = std::move(other.serial_);
				other.owner_ = nullptr;
				other.admitted_ = false;
			}
			return *this;
		}
		~Mutation() noexcept { release(); }
		explicit operator bool() const noexcept { return admitted_; }

	private:
		void release() noexcept
		{
			if (owner_ != nullptr)
			{
				owner_->end_mutation();
				owner_ = nullptr;
				admitted_ = false;
			}
		}
		GenerationDispatchGate* owner_ = nullptr;
		bool admitted_ = false;
		std::unique_lock<std::mutex> serial_;
	};

	[[nodiscard]] Lease try_dispatch() noexcept
	{
		if (dispatch_depth_ != 0)
		{
			++dispatch_depth_;
			return Lease(this);
		}
		if (!accepting_.load(std::memory_order_acquire)) return {};
		in_flight_.fetch_add(1, std::memory_order_acq_rel);
		if (!accepting_.load(std::memory_order_acquire))
		{
			if (in_flight_.fetch_sub(1, std::memory_order_acq_rel) == 1)
				waiters_.notify_all();
			return {};
		}
		dispatch_depth_ = 1;
		return Lease(this);
	}

	template <class Rep, class Period>
	[[nodiscard]] Mutation begin_mutation(
		const std::chrono::duration<Rep, Period>& timeout) noexcept
	{
		if (mutation_depth_ != 0)
		{
			++mutation_depth_;
			return Mutation(this, true);
		}
		if (dispatch_depth_ != 0) return Mutation(this, false);
		std::unique_lock serial(mutation_mutex_);
		std::unique_lock lock(wait_mutex_);
		accepting_.store(false, std::memory_order_release);
		const bool drained = waiters_.wait_for(lock, timeout, [this]
		{
			return in_flight_.load(std::memory_order_acquire) == 0;
		});
		if (!drained)
		{
			accepting_.store(true, std::memory_order_release);
			return Mutation(this, false, std::move(serial));
		}
		mutation_depth_ = 1;
		return Mutation(this, true, std::move(serial));
	}

	[[nodiscard]] std::uint64_t in_flight() const noexcept
	{
		return in_flight_.load(std::memory_order_acquire);
	}
	[[nodiscard]] bool accepting() const noexcept
	{
		return accepting_.load(std::memory_order_acquire);
	}
	[[nodiscard]] bool current_thread_dispatching() const noexcept
	{
		return dispatch_depth_ != 0;
	}

private:
	void release_dispatch() noexcept
	{
		if (dispatch_depth_ == 0) return;
		if (--dispatch_depth_ != 0) return;
		if (in_flight_.fetch_sub(1, std::memory_order_acq_rel) == 1)
			waiters_.notify_all();
	}
	void end_mutation() noexcept
	{
		if (mutation_depth_ == 0) return;
		if (--mutation_depth_ != 0) return;
		accepting_.store(true, std::memory_order_release);
	}

	std::atomic_bool accepting_{true};
	std::atomic<std::uint64_t> in_flight_{0};
	std::mutex wait_mutex_;
	std::mutex mutation_mutex_;
	std::condition_variable waiters_;
	static thread_local inline std::uint32_t dispatch_depth_ = 0;
	static thread_local inline std::uint32_t mutation_depth_ = 0;
};
}
