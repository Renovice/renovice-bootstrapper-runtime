#pragma once

#include <cstdint>

struct luau_State;

namespace renovice::de_vm_authority
{
// The process Application hook is only a clock. Every operation which borrows
// DE's Luau state must execute through this owner-matched transaction.
using TransactionBody = int(*)(luau_State* state, void* context);
using CurrentVmProtectedBody = void(*)(luau_State* state, void* context);

struct TransactionResult
{
	bool executed = false;
	int value = 0;
	std::uint64_t generation = 0;
};

struct CurrentVmProtectedResult
{
	bool admitted = false;
	bool restored = false;
	int status = -1;
};

// A stock DE call which can raise a Luau error sometimes has to propagate that
// exact error to the stock caller after Renovice's C++ ownership has unwound.
// On success this has the same relocation-safe frame restoration contract as
// run_current_vm_protected. On non-zero status it deliberately leaves DE's
// error stack/CallInfo untouched so the exact error TValue remains rooted for
// rethrow_current_vm_error. After a non-zero status the caller must not perform
// another VM operation; it may only release non-VM C++ ownership and rethrow.
CurrentVmProtectedResult run_current_vm_rethrowable(
	luau_State* state,
	CurrentVmProtectedBody body,
	void* context) noexcept;

// Re-raises an unchanged DE Luau status through the exact pinned luaD_throw
// primitive. The caller must own no C++ object whose destructor would have to
// run after this call. This function never returns.
[[noreturn]] void rethrow_current_vm_error(
	luau_State* state,
	int status) noexcept;

// This build-specific subsystem fails closed unless every authoritative engine
// primitive resolves uniquely and the FlashMgr shutdown hook is installed.
bool initialise(bool exact_supported_build) noexcept;
bool ready() noexcept;

// Called only after the stock hashed/named global setter has completed. A
// non-null publication roots exactly one process-owned host closure and opens
// a fresh Flash/DE-VM generation; nil closes it. The closure is reused for
// every frame in that generation, so the process clock does not allocate in
// the borrowed game VM.
bool commit_flash_publication(
	luau_State* state,
	void* flash_object,
	int(*host_callback)(luau_State*)) noexcept;

// Acquires DE's ScriptMgr critical section, leases the current Flash
// generation, and invokes body on its exact owner thread/state. require_idle is
// used by the Application scheduler; native DE callbacks pass false because a
// valid game-owned CallInfo is intentionally active.
TransactionResult transact(
	luau_State* required_state,
	bool require_idle,
	TransactionBody body,
	void* context) noexcept;

// Runs a destructor-free leaf through DE's exact luaD_rawrunprotected-shaped
// primitive on a VM which DE is already executing on the calling thread. This
// does not acquire ScriptMgr ownership and must never be used as a scheduler;
// its caller must already be an exact native VM hook or an admitted transaction.
// All C++ ownership must remain in the caller, outside body. The wrapper saves
// and relocation-safely restores ci, ci->top, intop, and outtop because the raw
// engine primitive itself restores only its error-jump chain and returns status.
CurrentVmProtectedResult run_current_vm_protected(
	luau_State* state,
	CurrentVmProtectedBody body,
	void* context) noexcept;

// Public protected-call boundary resolved from the same exact executable. It
// is available only while the calling thread owns an admitted transaction.
int protected_call(
	luau_State* state,
	int arguments,
	int results,
	int error_function) noexcept;

// Publishes the one rooted host closure for the active transaction onto the
// game stack. It fails closed for a stale Flash generation.
bool push_host_closure(luau_State* state) noexcept;

bool transaction_active_for(const luau_State* state) noexcept;
bool transaction_generation_alive() noexcept;
std::uint64_t transaction_generation_id() noexcept;
std::uint64_t active_generation() noexcept;
}
