#include "owf_scripting.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <deque>
#include <cstring>
#include <limits>
#include <mutex>
#include <type_traits>

#include <crc32c.hpp>
#include <filesystem.hpp>
#include <joaat.hpp>
#include <JsonArray.hpp>
#include <JsonString.hpp>
#include <JsonObject.hpp>
#include <Key.hpp> // char_to_virtual_key
#include <memGuard.hpp>
#include <Module.hpp>
#include <ObfusString.hpp>
#include <os.hpp>
#include <Pattern.hpp>
#include <SharedLibrary.hpp>
#include <unicode.hpp>
#include <WeakRef.hpp>

#include <lualib.h>
#include <lauxlib.h>
#include <lstate.h>
#include <lstring.h> // plutoS_prealloc, plutoS_commit
#include <windows.h>

#include "main.hpp"
#include "owf_cache.hpp"
#include "owf_config.hpp"
#include "owf_console.hpp"
#include "owf_luau.hpp"
#include "owf_repo.hpp"
#include "owf_structs.hpp"
#include "owf_tunables.hpp"
#include "renovice/config.hpp"
#include "renovice/de_vm_authority.hpp"
#include "renovice/injection.hpp"

using namespace soup;

namespace
{
struct DeferredGameRegistryRelease
{
	luau_GlobalState* global_state = nullptr;
	std::string key;
};

std::mutex deferred_game_registry_releases_mutex;
std::deque<DeferredGameRegistryRelease> deferred_game_registry_releases;
constexpr std::size_t maximum_deferred_registry_key_bytes = 256;
constexpr std::size_t maximum_registry_releases_per_drain = 256;
constexpr std::size_t maximum_deferred_registry_release_count = 32768;

enum class ProtectedGameVmOperationKind : std::uint8_t
{
	append_value,
	push_pseudo_index,
	push_string,
	push_pointer,
	push_object,
	push_closure,
	push_callback,
	next,
	gettable,
	newtable,
	settable,
	chat_redux,
	release_registry,
	stack_top,
	stack_base,
	set_stack_top,
	set_stack_base,
	pop_values,
	inspect_value,
	pop_value,
	get_upvalue,
	set_upvalue,
	registry_owner,
};

enum class ProtectedGameVmValueProjection : std::uint8_t
{
	none,
	userdata_payload,
	object_pointer,
	c_function,
};

// This descriptor is deliberately POD-like.  The operation dispatcher runs as
// a DE C closure and a Luau error can longjmp out of that frame.  It therefore
// must not own C++ objects whose destructors would be skipped.
struct ProtectedGameVmOperation
{
	ProtectedGameVmOperationKind kind =
		ProtectedGameVmOperationKind::append_value;
	luau_State* state = nullptr;
	luau_TValue value{};
	luau_TValue auxiliary_value{};
	const char* text = nullptr;
	void* pointer = nullptr;
	Object* object = nullptr;
	luau_CFunction function = nullptr;
	std::uintptr_t callback_instance = 0;
	std::uintptr_t callback_id = 0;
	std::uintptr_t callback_generation = 0;
	int index = 0;
	int expected_type = -1;
	ProtectedGameVmValueProjection projection =
		ProtectedGameVmValueProjection::none;
	std::ptrdiff_t target_intop_offset = -1;
	std::ptrdiff_t target_outtop_offset = -1;
	std::ptrdiff_t target_frame_offset = -1;
	std::ptrdiff_t target_frame_top_offset = -1;
	std::ptrdiff_t requested_stack_offset = -1;
	std::ptrdiff_t result_stack_offset = -1;
	int api_result = 0;
	bool executed = false;
	bool succeeded = false;
	char error[256]{};
};
static_assert(std::is_trivially_copyable_v<ProtectedGameVmOperation>);

thread_local ProtectedGameVmOperation* active_protected_game_vm_operation =
	nullptr;

void copy_protected_game_vm_error(
	ProtectedGameVmOperation& operation,
	luau_State* state,
	luau_TValue* call_base,
	const char* fallback) noexcept
{
	const char* message = fallback;
	if (state != nullptr && call_base != nullptr && state->stack != nullptr
		&& state->stack_last != nullptr && call_base >= state->stack
		&& call_base <= state->stack_last && state->outtop > call_base
		&& state->outtop <= state->stack_last)
	{
		auto& value = state->outtop[-1];
		if (value.type == owf_game_tag(LUAU_STRING))
		{
			const char* const candidate = value.getString();
			if (candidate != nullptr && *candidate != '\0') message = candidate;
		}
	}
	if (message == nullptr) message = "protected game VM operation failed";
	std::size_t length = 0;
	while (length + 1 < sizeof(operation.error)
		&& message[length] != '\0')
	{
		operation.error[length] = message[length];
		++length;
	}
	operation.error[length] = '\0';
}

bool readable_game_vm_memory(const void* address, std::size_t size) noexcept
{
	if (address == nullptr || size == 0) return false;
	auto cursor = reinterpret_cast<std::uintptr_t>(address);
	if (cursor > UINTPTR_MAX - size) return false;
	const auto end = cursor + size;
	while (cursor < end)
	{
		MEMORY_BASIC_INFORMATION memory{};
		if (VirtualQuery(reinterpret_cast<const void*>(cursor), &memory,
			sizeof(memory)) != sizeof(memory)
			|| memory.State != MEM_COMMIT
			|| (memory.Protect & (PAGE_GUARD | PAGE_NOACCESS)) != 0)
		{
			return false;
		}
		const auto region = reinterpret_cast<std::uintptr_t>(memory.BaseAddress);
		if (region > UINTPTR_MAX - memory.RegionSize) return false;
		const auto region_end = region + memory.RegionSize;
		if (region_end <= cursor) return false;
		cursor = (std::min)(region_end, end);
	}
	return true;
}

bool valid_game_vm_stack_window(const luau_State* state) noexcept
{
	if (state == nullptr
		|| !renovice::de_vm_authority::transaction_active_for(state)
		|| !readable_game_vm_memory(state, sizeof(*state))
		|| state->stack == nullptr || state->intop == nullptr
		|| state->outtop == nullptr || state->stack_last == nullptr
		|| state->ci == nullptr || state->base_ci == nullptr
		|| state->end_ci == nullptr)
	{
		return false;
	}
	const auto stack = reinterpret_cast<std::uintptr_t>(state->stack);
	const auto intop = reinterpret_cast<std::uintptr_t>(state->intop);
	const auto outtop = reinterpret_cast<std::uintptr_t>(state->outtop);
	const auto stack_last = reinterpret_cast<std::uintptr_t>(state->stack_last);
	const auto frame_begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto frame = reinterpret_cast<std::uintptr_t>(state->ci);
	const auto frame_end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	if (frame_begin > frame || frame >= frame_end
		|| (frame - frame_begin) % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > frame_end - frame
		|| !readable_game_vm_memory(state->ci, sizeof(luau_CallInfo))
		|| state->ci->top == nullptr)
	{
		return false;
	}
	const auto frame_top = reinterpret_cast<std::uintptr_t>(state->ci->top);
	return stack <= intop && intop <= outtop && outtop <= frame_top
		&& frame_top <= stack_last
		&& (intop - stack) % sizeof(luau_TValue) == 0
		&& (outtop - stack) % sizeof(luau_TValue) == 0
		&& (frame_top - stack) % sizeof(luau_TValue) == 0
		&& frame_begin <= frame && frame < frame_end;
}

bool game_vm_slot_index_to_offset(
	lua_Integer index,
	std::ptrdiff_t& offset) noexcept
{
	offset = -1;
	if (index < 0 || static_cast<std::uint64_t>(index)
		> static_cast<std::uint64_t>((std::numeric_limits<std::ptrdiff_t>::max)())
			/ sizeof(luau_TValue))
	{
		return false;
	}
	offset = static_cast<std::ptrdiff_t>(index) * sizeof(luau_TValue);
	return true;
}

bool resolve_game_vm_target_window(
	luau_State* state,
	const ProtectedGameVmOperation& operation,
	luau_TValue*& target_base,
	luau_TValue*& target_top,
	luau_CallInfo*& target_frame) noexcept
{
	target_base = nullptr;
	target_top = nullptr;
	target_frame = nullptr;
	if (!valid_game_vm_stack_window(state)
		|| operation.target_intop_offset < 0
		|| operation.target_outtop_offset < operation.target_intop_offset
		|| operation.target_frame_offset < 0
		|| operation.target_frame_top_offset < operation.target_outtop_offset)
	{
		return false;
	}
	const auto stack_begin = reinterpret_cast<std::uintptr_t>(state->stack);
	const auto stack_end = reinterpret_cast<std::uintptr_t>(state->stack_last);
	const auto frame_begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto frame_end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	if (stack_end < stack_begin || frame_end < frame_begin) return false;
	const auto stack_bytes = stack_end - stack_begin;
	const auto frame_bytes = frame_end - frame_begin;
	const auto base_offset = static_cast<std::uintptr_t>(
		operation.target_intop_offset);
	const auto top_offset = static_cast<std::uintptr_t>(
		operation.target_outtop_offset);
	const auto frame_offset = static_cast<std::uintptr_t>(
		operation.target_frame_offset);
	const auto frame_top_offset = static_cast<std::uintptr_t>(
		operation.target_frame_top_offset);
	if (base_offset > stack_bytes || top_offset > stack_bytes
		|| frame_top_offset > stack_bytes || frame_offset > frame_bytes
		|| base_offset % sizeof(luau_TValue) != 0
		|| top_offset % sizeof(luau_TValue) != 0
		|| frame_top_offset % sizeof(luau_TValue) != 0
		|| frame_offset % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > frame_bytes - frame_offset)
	{
		return false;
	}
	target_base = luau_restorestack(state, operation.target_intop_offset);
	target_top = luau_restorestack(state, operation.target_outtop_offset);
	target_frame = reinterpret_cast<luau_CallInfo*>(
		reinterpret_cast<char*>(state->base_ci) + frame_offset);
	if (!readable_game_vm_memory(target_frame, sizeof(*target_frame))
		|| target_frame->top != luau_restorestack(
			state, operation.target_frame_top_offset))
	{
		return false;
	}
	return state->stack <= target_base && target_base <= target_top
		&& target_top <= target_frame->top
		&& target_frame->top <= state->stack_last;
}

bool resolve_game_vm_target_value(
	luau_State* state,
	const ProtectedGameVmOperation& operation,
	int index,
	luau_TValue*& value) noexcept
{
	value = nullptr;
	luau_TValue* target_base = nullptr;
	luau_TValue* target_top = nullptr;
	luau_CallInfo* target_frame = nullptr;
	if (index == 0 || index <= -10000
		|| !resolve_game_vm_target_window(
			state, operation, target_base, target_top, target_frame))
	{
		return false;
	}
	if (index < 0)
	{
		const auto distance = -static_cast<std::int64_t>(index);
		if (distance > target_top - target_base) return false;
		value = target_top + index;
	}
	else
	{
		if (static_cast<std::ptrdiff_t>(index) > target_top - target_base)
			return false;
		value = target_base + index - 1;
	}
	return readable_game_vm_memory(value, sizeof(*value));
}

bool resolve_game_vm_upvalue(
	const luau_TValue& function,
	int index,
	luau_TValue*& value) noexcept
{
	value = nullptr;
	if (function.type != owf_game_tag(LUAU_FUNCTION) || index < 0
		|| function.value.as_uintptr == 0)
	{
		return false;
	}
	auto* const closure = reinterpret_cast<luau_Closure*>(
		function.value.as_uintptr);
	if (!readable_game_vm_memory(closure, offsetof(luau_Closure, c.upvals)))
		return false;
	if (index >= closure->nupvalues) return false;
	const auto offset = closure->isC
		? offsetof(luau_Closure, c.upvals)
		: offsetof(luau_Closure, l.uprefs);
	const auto bytes = offset + (static_cast<std::size_t>(index) + 1)
		* sizeof(luau_TValue);
	if (!readable_game_vm_memory(closure, bytes)) return false;
	value = reinterpret_cast<luau_TValue*>(
		reinterpret_cast<unsigned char*>(closure) + offset) + index;
	if (value->type == owf_game_tag(LUAU_TUPVAL))
	{
		auto* const upvalue = reinterpret_cast<luau_UpVal*>(value->value.gc);
		if (!readable_game_vm_memory(upvalue, sizeof(*upvalue))
			|| !readable_game_vm_memory(upvalue->v, sizeof(*upvalue->v)))
		{
			return false;
		}
		value = upvalue->v;
	}
	return readable_game_vm_memory(value, sizeof(*value));
}

bool project_game_vm_value(
	ProtectedGameVmOperation& operation,
	const luau_TValue& value) noexcept
{
	if (operation.expected_type >= 0 && value.type != operation.expected_type)
		return false;
	operation.value = value;
	operation.pointer = nullptr;
	if (value.type == owf_game_tag(LUAU_STRING))
	{
		if (value.value.as_uintptr > UINTPTR_MAX - 0x18
			|| !readable_game_vm_memory(reinterpret_cast<const void*>(
				value.value.as_uintptr + 0x18), 1))
		{
			return false;
		}
	}
	if (value.type == owf_game_tag(LUAU_USERDATA)
		&& !readable_game_vm_memory(reinterpret_cast<const void*>(
			value.value.as_uintptr), 0x20))
	{
		return false;
	}
	switch (operation.projection)
	{
	case ProtectedGameVmValueProjection::none:
		return true;

	case ProtectedGameVmValueProjection::userdata_payload:
		if (value.type != owf_game_tag(LUAU_USERDATA)) return false;
		std::memcpy(&operation.pointer, reinterpret_cast<const void*>(
			value.value.as_uintptr + 0x18), sizeof(operation.pointer));
		return true;

	case ProtectedGameVmValueProjection::object_pointer:
	{
		if (value.type != owf_game_tag(LUAU_USERDATA)) return false;
		void* first = nullptr;
		std::memcpy(&first, reinterpret_cast<const void*>(
			value.value.as_uintptr + 0x18), sizeof(first));
		if (!readable_game_vm_memory(first, sizeof(void*))) return false;
		void* second = nullptr;
		std::memcpy(&second, first, sizeof(second));
		if (game_version >= GV(38, 5, 0))
		{
			operation.pointer = second;
		}
		else
		{
			if (!readable_game_vm_memory(second, sizeof(void*))) return false;
			std::memcpy(&operation.pointer, second, sizeof(operation.pointer));
		}
		return operation.pointer != nullptr;
	}

	case ProtectedGameVmValueProjection::c_function:
	{
		if (value.type != owf_game_tag(LUAU_FUNCTION)
			|| !readable_game_vm_memory(reinterpret_cast<const void*>(
				value.value.as_uintptr), offsetof(luau_Closure, c.cont)))
		{
			return false;
		}
		auto* const closure = reinterpret_cast<const luau_Closure*>(
			value.value.as_uintptr);
		if (!closure->isC || closure->c.func == nullptr) return false;
		operation.pointer = reinterpret_cast<void*>(closure->c.func);
		return true;
	}
	}
	return false;
}

bool capture_game_vm_stack_value(
	luau_State* state,
	int index,
	luau_TValue& value) noexcept
{
	if (!valid_game_vm_stack_window(state) || index == 0)
	{
		return false;
	}
	if (index < 0)
	{
		const auto available = state->outtop - state->intop;
		if (index <= -10000
			|| static_cast<std::ptrdiff_t>(-static_cast<std::int64_t>(index))
				> available)
		{
			return false;
		}
		value = state->outtop[index];
		return true;
	}
	const auto available = state->outtop - state->intop;
	if (static_cast<std::ptrdiff_t>(index) > available) return false;
	value = state->intop[index - 1];
	return true;
}

bool capture_game_vm_table_argument(
	luau_State* state,
	int requested_index,
	ProtectedGameVmOperation& operation,
	luau_TValue& table,
	bool& pass_table) noexcept
{
	if (requested_index <= -10000)
	{
		operation.index = requested_index;
		pass_table = false;
		return true;
	}
	if (!capture_game_vm_stack_value(state, requested_index, table))
		return false;
	operation.index = 1;
	pass_table = true;
	return true;
}

bool run_protected_game_vm_operation(
	luau_State* state,
	ProtectedGameVmOperation& operation,
	int existing_operands,
	const luau_TValue* table_argument,
	int scratch_slots) noexcept
{
	operation.state = state;
	operation.executed = false;
	operation.succeeded = false;
	operation.api_result = 0;
	operation.error[0] = '\0';
	operation.target_intop_offset = -1;
	operation.target_outtop_offset = -1;
	operation.target_frame_offset = -1;
	operation.target_frame_top_offset = -1;
	operation.result_stack_offset = -1;

	if (state == nullptr
		|| !valid_game_vm_stack_window(state)
		|| active_protected_game_vm_operation != nullptr
		|| existing_operands < 0 || existing_operands > 2
		|| scratch_slots < 0 || scratch_slots > 256
		|| state->outtop - state->intop < existing_operands)
	{
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"game VM protected operation unavailable");
		return false;
	}
	const auto frame_begin = reinterpret_cast<std::uintptr_t>(state->base_ci);
	const auto frame_end = reinterpret_cast<std::uintptr_t>(state->end_ci);
	const auto current_frame = reinterpret_cast<std::uintptr_t>(state->ci);
	if (frame_end < frame_begin || current_frame < frame_begin
		|| current_frame >= frame_end
		|| (current_frame - frame_begin) % sizeof(luau_CallInfo) != 0
		|| sizeof(luau_CallInfo) > frame_end - current_frame)
	{
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"invalid current game VM CallInfo");
		return false;
	}
	operation.target_intop_offset = luau_savestack(state, state->intop);
	operation.target_outtop_offset = luau_savestack(state, state->outtop);
	operation.target_frame_offset = static_cast<std::ptrdiff_t>(
		current_frame - frame_begin);
	operation.target_frame_top_offset = luau_savestack(
		state, state->ci->top);

	const int copied_arguments = existing_operands
		+ (table_argument != nullptr ? 1 : 0);
	const auto required = static_cast<std::ptrdiff_t>(1 + copied_arguments
		+ scratch_slots);
	if (state->stack_last - state->outtop < required
		|| state->ci->top - state->outtop < required)
	{
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"insufficient current game VM CallInfo window");
		return false;
	}

	const auto original_top_offset = luau_savestack(state, state->outtop);
	const auto operands_offset = luau_savestack(
		state, state->outtop - existing_operands);

	// The rooted host closure is the only process-owned dispatcher. Physical and
	// current CallInfo capacity are both proven above, so the closure, copied
	// arguments, and declared scratch stay on the no-growth path.
	if (!renovice::de_vm_authority::push_host_closure(state))
	{
		state->outtop = luau_restorestack(state, original_top_offset);
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"protected host closure unavailable");
		return false;
	}

	auto* const call_base = luau_restorestack(state, original_top_offset);
	auto* const operands = luau_restorestack(state, operands_offset);
	if (table_argument != nullptr
		&& !renovice::injection::append_game_vm_stack_value_reserved(
			state, *table_argument))
	{
		state->outtop = luau_restorestack(state, original_top_offset);
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"protected table argument publication failed");
		return false;
	}
	for (int i = 0; i != existing_operands; ++i)
	{
		if (!renovice::injection::append_game_vm_stack_value_reserved(
			state, operands[i]))
		{
			state->outtop = luau_restorestack(state, original_top_offset);
			copy_protected_game_vm_error(operation, nullptr, nullptr,
				"protected operand publication failed");
			return false;
		}
	}

	active_protected_game_vm_operation = &operation;
	const int status = renovice::de_vm_authority::protected_call(
		state, copied_arguments, -1, 0);
	active_protected_game_vm_operation = nullptr;

	luau_TValue* target_base = nullptr;
	luau_TValue* target_top = nullptr;
	luau_CallInfo* target_frame = nullptr;
	const bool exact_target = resolve_game_vm_target_window(
		state, operation, target_base, target_top, target_frame)
		&& state->ci == target_frame && state->intop == target_base;
	if (!exact_target)
	{
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"game VM target frame changed during protected operation");
		return false;
	}
	auto* const restored_call_base = luau_restorestack(
		state, original_top_offset);
	auto* const restored_operands = luau_restorestack(state, operands_offset);
	if (status != 0 || !operation.executed || !operation.succeeded
		|| !renovice::de_vm_authority::transaction_generation_alive())
	{
		copy_protected_game_vm_error(operation, state, restored_call_base,
			status != 0 ? "protected game VM operation failed"
				: (!operation.executed
					? "protected game VM operation was not dispatched"
					: (!operation.succeeded
						? "protected game VM operation was rejected"
						: "game VM generation retired during operation")));
		state->outtop = luau_restorestack(state, original_top_offset);
		return false;
	}

	const auto result_count = state->outtop - restored_call_base;
	if (result_count < 0 || restored_call_base + result_count
		> state->stack_last || restored_call_base + result_count
		> state->ci->top)
	{
		state->outtop = luau_restorestack(state, original_top_offset);
		copy_protected_game_vm_error(operation, nullptr, nullptr,
			"invalid protected game VM result stack");
		return false;
	}
	if (existing_operands != 0 && result_count != 0)
	{
		std::memmove(restored_operands, restored_call_base,
			static_cast<std::size_t>(result_count) * sizeof(luau_TValue));
	}
	state->outtop = restored_operands + result_count;
	if (operation.kind == ProtectedGameVmOperationKind::set_stack_top
		|| operation.kind == ProtectedGameVmOperationKind::pop_values)
	{
		if (operation.requested_stack_offset < 0
			|| operation.requested_stack_offset > luau_savestack(
				state, state->stack_last))
		{
			copy_protected_game_vm_error(operation, nullptr, nullptr,
				"invalid committed game VM top offset");
			return false;
		}
		auto* const requested = luau_restorestack(
			state, operation.requested_stack_offset);
		if (requested < state->intop || requested > state->ci->top)
		{
			copy_protected_game_vm_error(operation, nullptr, nullptr,
				"invalid committed game VM top");
			return false;
		}
		while (state->outtop < requested)
		{
			state->outtop->value.as_uintptr = 0;
			state->outtop->type = owf_game_tag(LUAU_NIL);
			++state->outtop;
		}
		state->outtop = requested;
	}
	else if (operation.kind == ProtectedGameVmOperationKind::set_stack_base)
	{
		if (operation.requested_stack_offset < 0
			|| operation.requested_stack_offset > luau_savestack(
				state, state->stack_last))
		{
			copy_protected_game_vm_error(operation, nullptr, nullptr,
				"invalid committed game VM base offset");
			return false;
		}
		auto* const requested = luau_restorestack(
			state, operation.requested_stack_offset);
		if (requested < state->stack || requested > state->outtop)
		{
			copy_protected_game_vm_error(operation, nullptr, nullptr,
				"invalid committed game VM base");
			return false;
		}
		state->intop = requested;
	}
	return true;
}

std::string protected_game_vm_error(
	luau_State* state,
	luau_TValue* call_base,
	const char* fallback)
{
	if (state != nullptr && call_base != nullptr && state->outtop > call_base)
	{
		auto& value = state->outtop[-1];
		if (value.type == owf_game_tag(LUAU_STRING))
		{
			const char* const message = value.getString();
			if (message != nullptr && *message != '\0') return message;
		}
	}
	return fallback;
}

int invoke_openwf_callback_owned(luau_State* state, void*)
{
	if (state == nullptr || state->ci == nullptr || state->ci->func == nullptr
		|| state->ci->func->value.gc == nullptr)
	{
		return 0;
	}

	std::lock_guard owner_lock(running_scripts_mtx);
	const auto closure_generation =
		state->ci->func->value.gc->cl.c.upvals[2].value.as_uintptr;
	if (closure_generation == 0 || closure_generation
		!= renovice::de_vm_authority::transaction_generation_id())
	{
		return 0;
	}
	const auto instance_id =
		state->ci->func->value.gc->cl.c.upvals[0].value.as_uintptr;
	auto* const script = get_script_by_instance_id(instance_id);
	if (script == nullptr) return 0;
	const auto callback_id =
		state->ci->func->value.gc->cl.c.upvals[1].value.as_uintptr;

	struct CallbackContextRestore
	{
		owfScript* script;
		luau_State* previous_game_state;
		bool previous_callback_context;
		~CallbackContextRestore() noexcept
		{
			script->callback_context = previous_callback_context;
			luau_L = previous_game_state;
		}
	} restore{script, luau_L, script->callback_context};
	script->callback_context = true;
	luau_L = state;

	if (restore.previous_game_state != nullptr)
	{
		const auto original_top = lua_gettop(script->main);
		ObfusString callback("owf_internal_callback");
		lua_getglobal(script->main, callback.c_str());
		lua_pushinteger(script->main, callback_id);
		lua_pushinteger(script->main, luau_gettop(state));
		const auto status = lua_pcall(script->main, 2, 1, 0);
		const auto result = status == LUA_OK
			? static_cast<int>(lua_tonumber(script->main, -1)) : 0;
		if (status != LUA_OK)
		{
			renovice::config::diagnostic_log(
				"RENOVICE OPENWF_CALLBACK rejected reason=nested-pluto-error",
				renovice::config::DiagnosticsMode::errors);
		}
		lua_settop(script->main, original_top);
		return result;
	}

	lua_pushinteger(script->coro, callback_id);
	lua_pushinteger(script->coro, luau_gettop(state));
	const int results = script->tick(2);
	return results == 1
		? static_cast<int>(lua_tonumber(script->coro, -1)) : 0;
}

int invoke_openwf_callback(luau_State* state)
{
	const auto callback = renovice::de_vm_authority::transact(
		state, false, &invoke_openwf_callback_owned, nullptr);
	return callback.executed ? callback.value : 0;
}

bool queue_deferred_game_registry_release(
	luau_GlobalState* global_state,
	const char* key,
	std::size_t key_size) noexcept
{
	if (global_state == nullptr || key == nullptr || key_size == 0
		|| key_size > maximum_deferred_registry_key_bytes)
	{
		return false;
	}
	try
	{
		std::lock_guard lock(deferred_game_registry_releases_mutex);
		if (deferred_game_registry_releases.size()
			>= maximum_deferred_registry_release_count)
		{
			return false;
		}
		deferred_game_registry_releases.push_back({
			global_state, std::string(key, key_size)});
		return true;
	}
	catch (...)
	{
		return false;
	}
}
}

int dispatch_openwf_protected_game_vm_operation(luau_State* state) noexcept
{
	auto* const operation = active_protected_game_vm_operation;
	if (operation == nullptr) return -1;
	// While an operation is pending, no recursive entry may fall through to the
	// full Pluto scheduler.  A mismatch is a rejected local call, not a second
	// frame tick.
	if (state == nullptr || operation->state != state || operation->executed
		|| !renovice::de_vm_authority::transaction_active_for(state)
		|| !valid_game_vm_stack_window(state))
		return 0;
	operation->executed = true;

	switch (operation->kind)
	{
	case ProtectedGameVmOperationKind::append_value:
		if (renovice::injection::append_game_vm_stack_value(
			state, operation->value))
		{
			operation->succeeded = true;
			return 1;
		}
		return 0;

	case ProtectedGameVmOperationKind::push_pseudo_index:
		if (renovice::injection::push_game_vm_stack_index(
			state, operation->index))
		{
			operation->succeeded = true;
			return 1;
		}
		return 0;

	case ProtectedGameVmOperationKind::push_string:
		if (luau_pushstring == nullptr || operation->text == nullptr) return 0;
		luau_pushstring(state, operation->text);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::push_pointer:
		if (luau_pushpointer == nullptr) return 0;
		luau_pushpointer(state, operation->pointer);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::push_object:
		if (luau_pushobject == nullptr) return 0;
		luau_pushobject(state, operation->object);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::push_closure:
		if (luau_pushcclosurek == nullptr || operation->function == nullptr)
			return 0;
		luau_pushcclosurek(state, operation->function,
			"OpenWF protected ivkr_call", 0, nullptr);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::push_callback:
		if (luau_pushcclosurek == nullptr
			|| !luau_push_lightuserdata(state,
				reinterpret_cast<void*>(operation->callback_instance))
			|| !luau_push_lightuserdata(state,
				reinterpret_cast<void*>(operation->callback_id))
			|| !luau_push_lightuserdata(state,
				reinterpret_cast<void*>(operation->callback_generation)))
		{
			return 0;
		}
		luau_pushcclosurek(
			state, &invoke_openwf_callback, nullptr, 3, nullptr);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::next:
		if (luau_next == nullptr) return 0;
		operation->api_result = luau_next(state, operation->index);
		operation->succeeded = true;
		return operation->api_result != 0 ? 2 : 0;

	case ProtectedGameVmOperationKind::gettable:
		if (luau_gettable == nullptr) return 0;
		operation->api_result = luau_gettable(state, operation->index);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::newtable:
		if (luau_createtable == nullptr) return 0;
		luau_createtable(state, 0, 0);
		operation->succeeded = true;
		return 1;

	case ProtectedGameVmOperationKind::settable:
		if (luau_settable == nullptr) return 0;
		luau_settable(state, operation->index);
		operation->succeeded = true;
		return 0;

	case ProtectedGameVmOperationKind::chat_redux:
		if (operation->pointer == nullptr
			|| state->global_state != operation->pointer)
		{
			operation->api_result = -1;
			operation->succeeded = true;
			return 0;
		}
		if (luau_pushstring == nullptr || luau_gettable == nullptr) return 0;
		luau_pushstring(state, "OpenWF.ChatRedux.table.v97");
		operation->api_result = luau_gettable(state, -10002);
		operation->succeeded = true;
		if (operation->api_result == static_cast<int>(
			owf_game_tag(LUAU_TABLE)))
		{
			return 1;
		}
		if (state->outtop <= state->intop) return 0;
		--state->outtop;
		return 0;

	case ProtectedGameVmOperationKind::release_registry:
		if (luau_pushstring == nullptr || luau_settable == nullptr
			|| operation->text == nullptr)
		{
			return 0;
		}
		luau_pushstring(state, operation->text);
		state->outtop->type = owf_game_tag(LUAU_NIL);
		++state->outtop;
		luau_settable(state, -10002);
		operation->succeeded = true;
		return 0;

	case ProtectedGameVmOperationKind::stack_top:
	case ProtectedGameVmOperationKind::stack_base:
	case ProtectedGameVmOperationKind::set_stack_top:
	case ProtectedGameVmOperationKind::set_stack_base:
	case ProtectedGameVmOperationKind::pop_values:
	{
		luau_TValue* target_base = nullptr;
		luau_TValue* target_top = nullptr;
		luau_CallInfo* target_frame = nullptr;
		if (!resolve_game_vm_target_window(
			state, *operation, target_base, target_top, target_frame))
		{
			return 0;
		}
		if (operation->kind == ProtectedGameVmOperationKind::stack_top)
			operation->result_stack_offset = operation->target_outtop_offset;
		else if (operation->kind == ProtectedGameVmOperationKind::stack_base)
			operation->result_stack_offset = operation->target_intop_offset;
		else
		{
			if (operation->kind == ProtectedGameVmOperationKind::pop_values)
			{
				if (operation->index < 0
					|| operation->index > target_top - target_base)
				{
					return 0;
				}
				operation->requested_stack_offset = luau_savestack(
					state, target_top - operation->index);
			}
			if (operation->requested_stack_offset < 0
				|| operation->requested_stack_offset
					% sizeof(luau_TValue) != 0
				|| operation->requested_stack_offset > luau_savestack(
					state, state->stack_last))
			{
				return 0;
			}
			auto* const requested = luau_restorestack(
				state, operation->requested_stack_offset);
			if (operation->kind
				== ProtectedGameVmOperationKind::set_stack_top
				|| operation->kind
					== ProtectedGameVmOperationKind::pop_values)
			{
				if (requested < target_base || requested > target_frame->top)
					return 0;
			}
			else if (requested < state->stack || requested > target_top)
			{
				return 0;
			}
		}
		operation->succeeded = true;
		return 0;
	}

	case ProtectedGameVmOperationKind::inspect_value:
	case ProtectedGameVmOperationKind::pop_value:
	{
		luau_TValue* value = nullptr;
		if (!resolve_game_vm_target_value(
			state, *operation, operation->index, value)
			|| !project_game_vm_value(*operation, *value))
		{
			return 0;
		}
		operation->succeeded = true;
		return 0;
	}

	case ProtectedGameVmOperationKind::get_upvalue:
	{
		luau_TValue* function = nullptr;
		luau_TValue* upvalue = nullptr;
		if (!resolve_game_vm_target_value(state, *operation, -1, function)
			|| !resolve_game_vm_upvalue(
				*function, operation->index, upvalue)
			|| !renovice::injection::append_game_vm_stack_value(
				state, *upvalue))
		{
			return 0;
		}
		operation->succeeded = true;
		return 1;
	}

	case ProtectedGameVmOperationKind::set_upvalue:
	{
		luau_TValue* function = nullptr;
		luau_TValue* replacement = nullptr;
		luau_TValue* upvalue = nullptr;
		if (!resolve_game_vm_target_value(state, *operation, -2, function)
			|| !resolve_game_vm_target_value(state, *operation, -1, replacement)
			|| !resolve_game_vm_upvalue(
				*function, operation->index, upvalue)
			|| (replacement->type != owf_game_tag(LUAU_NIL)
				&& replacement->type != owf_game_tag(LUAU_BOOL)
				&& replacement->type != owf_game_tag(LUAU_LIGHTUSERDATA)
				&& replacement->type != owf_game_tag(LUAU_NUMBER)))
		{
			return 0;
		}
		*upvalue = *replacement;
		operation->succeeded = true;
		return 0;
	}

	case ProtectedGameVmOperationKind::registry_owner:
		if (state->global_state == nullptr
			|| !readable_game_vm_memory(state->global_state, sizeof(void*)))
		{
			return 0;
		}
		operation->pointer = state->global_state;
		operation->succeeded = true;
		return 0;
	}
	return 0;
}

std::size_t drain_deferred_game_registry_releases(luau_State* state) noexcept
{
	if (state == nullptr || state->global_state == nullptr
		|| state->stack == nullptr || state->outtop == nullptr
		|| luau_pushstring == nullptr || luau_settable == nullptr)
	{
		return 0;
	}

	std::size_t released = 0;
	while (released != maximum_registry_releases_per_drain)
	{
		DeferredGameRegistryRelease pending;
		try
		{
			std::lock_guard lock(deferred_game_registry_releases_mutex);
			auto iterator = deferred_game_registry_releases.begin();
			for (; iterator != deferred_game_registry_releases.end(); ++iterator)
			{
				if (iterator->global_state == state->global_state) break;
			}
			if (iterator == deferred_game_registry_releases.end()) break;
			pending = std::move(*iterator);
			deferred_game_registry_releases.erase(iterator);
		}
		catch (...)
		{
			break;
		}

		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::release_registry;
		operation.text = pending.key.c_str();
		if (!run_protected_game_vm_operation(
			state, operation, 0, nullptr, 2))
		{
			try
			{
				std::lock_guard lock(deferred_game_registry_releases_mutex);
				deferred_game_registry_releases.push_front(std::move(pending));
			}
			catch (...)
			{
				// Retaining one registry root is safer than mutating a cached VM
				// from Pluto's collector or overflowing the DE stack.
			}
			break;
		}
		++released;
	}
	return released;
}

static uint32_t wf_fnv_1(const char* str) noexcept
{
	uint32_t hash = 0xF42E1C3E;
	for (; *str; ++str)
	{
		hash ^= (uint8_t)*str;
		hash *= 16777619u;
	}
	return hash;
}

static uint32_t rol(const uint32_t value, const size_t bits) noexcept
{
	return (value << bits) | (value >> (32 - bits));
}

static uint32_t wf_fnv_2_initial;
static uint32_t wf_fnv_2(const char* str) noexcept
{
	uint32_t hash = wf_fnv_2_initial;
	for (; *str; ++str)
	{
		hash ^= (uint8_t)*str;
		hash *= 16777619u;
	}
	hash = ~hash;
	return rol(hash, 17);
}

static void lua_pushpointer(lua_State* L, void* ptr)
{
	if (ptr != nullptr)
	{
		lua_pushinteger(L, reinterpret_cast<intptr_t>(ptr));
	}
	else
	{
		lua_pushnil(L);
	}
}

template <typename T = void*, SOUP_RESTRICT(std::is_pointer_v<T>)>
static T lua_checkpointer(lua_State* L, int i)
{
	auto ptr = reinterpret_cast<T>(luaL_checkinteger(L, 1));
	if (!ptr)
	{
		ObfusString err("Unexpected nullptr");
		luaL_error(L, "%s", err.c_str());
	}
	return ptr;
}

void owfScript::init()
{
	wf_fnv_2_initial = static_cast<uint32_t>(static_cast<int32_t>(g_repo.getVersionedI64(soup::joaat::compileTimeHash("OpenWF/vv/wf_fnv_2_initial.json"), game_version)));
	if (wf_fnv_2_initial)
	{
		wf_hash = wf_fnv_2;
	}
	else
	{
		wf_hash = wf_fnv_1;
	}
	// Before this FNV-based hashing function, they used MurmurHash2 afaik.


	luau_GlobalState::error_longjump_data_offset = g_repo.getVersionedU64(soup::joaat::compileTimeHash("OpenWF/vv/off/luau_GlobalState_error_longjump_data.json"), game_version);
	luau_GlobalState::panic_func_offset = g_repo.getVersionedU64(soup::joaat::compileTimeHash("OpenWF/vv/off/luau_GlobalState_panic_func.json"), game_version);
}

static ObfusString runtime_script_name("Script Runtime");

static std::unordered_map<uint32_t, uintptr_t> lua_exe_scan_cache;

void owfScript::logNl(std::string msg)
{
	msg.push_back('\n');
	owfScript::log(std::move(msg));
}

void owfScript::log(std::string msg)
{
	conout << msg;

	size_t script_log_olen;
	size_t script_log_nlen;
	{
		std::lock_guard lock(script_log_mtx);
		script_log_olen = script_log.size();
		script_log.append(msg);
		script_log_nlen = script_log.size();
	}

	if (!bgscript)
	{
		JsonObject obj;
		obj.add(ObfusString("script_log_olen"), static_cast<int64_t>(script_log_olen));
		obj.add(ObfusString("script_log_nlen"), static_cast<int64_t>(script_log_nlen));
		obj.add(ObfusString("script_log_app"), std::move(msg));
		owf_broadcast_message(obj.encode());
	}
}

static std::string concat_arguments(lua_State* L)
{
	std::string msg;
	const int n = lua_gettop(L);
	for (int i = 0; i++ != n; )
	{
		size_t len;
		const char* str = luaL_tolstring(L, i, &len);
		msg.append(str, len);
		msg.push_back('\t');
	}
	if (!msg.empty())
	{
		msg.pop_back();
	}
	return msg;
}

struct owfScriptReplyReceiver;

struct owfScriptReplySender
{
	soup::TransientToken transient_token;
	soup::WeakRef<owfScriptReplyReceiver> receiver;
};

struct owfScriptReplyReceiver
{
	soup::TransientToken transient_token;
	soup::WeakRef<owfScriptReplySender> sender;
	soup::Optional<std::string> response;
};

void owfScript::openLibs(lua_State* L)
{
	luaL_openlibs(L);

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		owfScript::logNl(concat_arguments(L));
		return 0;
	});
	OWF_SET_GLOBAL(L, "print");

	{ ObfusString name("io"); lua_getglobal(L, name.c_str()); }
	{ ObfusString name("write"); lua_pushlstring(L, name.data(), name.size()); }
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		owfScript::log(concat_arguments(L));
		return 0;
	});
	lua_settable(L, -3);

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		conout << concat_arguments(L);
		return 0;
	});
	OWF_SET_GLOBAL(L, "write_to_console");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		conout << concat_arguments(L) << '\n';
		return 0;
	});
	OWF_SET_GLOBAL(L, "print_to_console");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		owfConsole::setTitle(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_console_set_title");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		std::lock_guard lock(script_log_mtx);
		lua_pushinteger(L, script_log.size());
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_script_log_len");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto i = luaL_checkinteger(L, 1);
		std::lock_guard lock(script_log_mtx);
		const auto data = script_log.data();
		const auto size = script_log.size();
		if (i < size)
		{
			lua_pushlstring(L, data + i, size - i);
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_get_script_log_sub");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		std::lock_guard lock(g_repo_mtx);
		size_t size;
		if (auto data = g_repo.find(soup::joaat::hash(luaL_checkstring(L, 1)), size))
		{
			lua_pushlstring(L, data, size);
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_repo_find");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushlstring(L, build_version, 16);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_build_version");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushlstring(L, build_hash, build_hash[0] ? 22 : 0);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_build_hash");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pluto_pushstring(L, server_host);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_server_host");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, http_port);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_http_port");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, https_port);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_https_port");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pluto_pushstring(L, auth_query);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_auth_query");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushboolean(L, secure_connections);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_using_secure_connections");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, client_http_port);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_client_http_port");

	lua_pushstring(L, BOOTSTRAPPER_TITLE);
	OWF_SET_GLOBAL(L, "OWF_CLIENT_TITLE"); // undocumented

	pluto_pushstring(L, dll_path_utf8);
	OWF_SET_GLOBAL(L, "OWF_CLIENT_DLL_PATH"); // undocumented

#if PRIVATE
	lua_pushboolean(L, true);
	lua_setglobal(L, "OWF_PRIVATE_BUILD");
#endif

	lua_pushboolean(L, os::isWine());
	OWF_SET_GLOBAL(L, "OWF_IS_WINE"); // undocumented

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pluto_pushstring(L, language);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_lang_code");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pluto_pushstring(L, game_lang_code);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_game_lang_code");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		size_t size;
		const char* data = luaL_checklstring(L, 1, &size);
		std::string utf8((const char*)data, size / sizeof(char)); // byte length -> character length
		auto utf16 = soup::unicode::utf8_to_utf16(utf8);
		lua_pushlstring(L, (const char*)utf16.data(), utf16.size() * sizeof(wchar_t)); // character length -> byte length
		return 1;
	});
	OWF_SET_GLOBAL(L, "utf8_to_utf16");
}

owfScript* get_script_by_instance_id(size_t instance_id)
{
	std::lock_guard lock(running_scripts_mtx);
	for (const auto& scr : running_scripts)
	{
		if (scr->instance_id == instance_id)
		{
			return scr;
		}
	}
	if (bgscript && bgscript->instance_id == instance_id)
	{
		return bgscript;
	}
	return nullptr;
}

static size_t next_instance_id = 0;

owfScript::owfScript()
	: instance_id(next_instance_id++)
{
	auto L = luaL_newstate();
	this->main = L;
	L->l_G->user_data = this;

	owfScript::openLibs(L);

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushboolean(L, reinterpret_cast<owfScript*>(L->l_G->user_data)->stop_requested);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_get_stop_requested");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto scr = reinterpret_cast<owfScript*>(L->l_G->user_data);
		SOUP_IF_UNLIKELY (scr->callback_context)
		{
			ObfusString err("Cannot yield in a callback context");
			luaL_error(L, "%s", err.c_str());
		}
		SOUP_IF_UNLIKELY (scr->stop_requested)
		{
			ObfusString err("Stop requested");
			luaL_error(L, "%s", err.c_str());
		}
		lua_yield(L, 0);
		return 0;
	});
	OWF_SET_GLOBAL(L, "yield");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		incnny(L);
		return 0;
	});
	OWF_SET_GLOBAL(L, "block_yield");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		decnny(L);
		return 0;
	});
	OWF_SET_GLOBAL(L, "unblock_yield");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		if (DWORD pid; GetWindowThreadProcessId(GetForegroundWindow(), &pid), pid == GetCurrentProcessId())
		{
			int vk = 0;
			if (lua_type(L, 1) == LUA_TSTRING)
			{
				size_t size;
				const char* data = luaL_checklstring(L, 1, &size);
				vk = soup::string_to_virtual_key(data, size);
			}
			if (!vk)
			{
				vk = (int)luaL_checkinteger(L, 1);
			}
			lua_pushboolean(L, (GetAsyncKeyState(vk) & 0x8000) != 0);
		}
		else
		{
			lua_pushboolean(L, false);
		}
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_is_key_down");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, regionmgr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_regionmgr");

	/*lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, regionmgr ? *regionmgr->game_rules : nullptr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_gamerules");*/

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, flashmgr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_flashmgr");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, gamedata);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_gamedata");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, profilemgr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_profilemgr");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, gClient);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_client");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, matchingservice);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_matchingservice");

	/*lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, regionmgr ? regionmgr->GetLocalPlayer() : nullptr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_local_player");*/

	/*lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, regionmgr ? regionmgr->GetGameCamera() : nullptr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_game_camera");*/

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, reinterpret_cast<Player*>(luaL_checkinteger(L, 1))->getAvatar());
		return 1;
	});
	OWF_SET_GLOBAL(L, "player_get_avatar");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushboolean(L, reinterpret_cast<Player*>(luaL_checkinteger(L, 1))->controlling_camera);
		return 1;
	});
	OWF_SET_GLOBAL(L, "player_get_controlling_camera");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		reinterpret_cast<Player*>(luaL_checkinteger(L, 1))->controlling_camera = lua_toboolean(L, 2);
		return 0;
	});
	OWF_SET_GLOBAL(L, "player_set_controlling_camera");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto entity = reinterpret_cast<Entity*>(luaL_checkinteger(L, 1));
		lua_pushnumber(L, entity->pos_x);
		lua_pushnumber(L, entity->pos_y);
		lua_pushnumber(L, entity->pos_z);
		return 3;
	});
	OWF_SET_GLOBAL(L, "entity_get_pos");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, reinterpret_cast<BaseAvatar*>(luaL_checkinteger(L, 1))->getDamageController());
		return 1;
	});
	OWF_SET_GLOBAL(L, "baseavatar_get_damage_controller");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, reinterpret_cast<BaseAvatar*>(luaL_checkinteger(L, 1))->getInventoryController());
		return 1;
	});
	OWF_SET_GLOBAL(L, "baseavatar_get_inventory_controller");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		reinterpret_cast<Avatar*>(luaL_checkinteger(L, 1))->followed_by_camera() = lua_toboolean(L, 2);
		return 0;
	});
	OWF_SET_GLOBAL(L, "avatar_set_followed_by_camera");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushboolean(L, reinterpret_cast<Avatar*>(luaL_checkinteger(L, 1))->followed_by_camera());
		return 1;
	});
	OWF_SET_GLOBAL(L, "avatar_get_followed_by_camera");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, reinterpret_cast<LotusInventoryController*>(luaL_checkinteger(L, 1))->GetWeaponInHand(luaL_checkinteger(L, 2)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "inventory_get_weapon_in_hand");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, reinterpret_cast<LotusInventoryController*>(luaL_checkinteger(L, 1))->GetActivePowerSuit());
		return 1;
	});
	OWF_SET_GLOBAL(L, "inventory_get_active_powersuit");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushpointer(L, reinterpret_cast<WeaponEx*>(luaL_checkinteger(L, 1))->GetActiveImpactBehavior());
		return 1;
	});
	OWF_SET_GLOBAL(L, "weaponex_get_active_impact_behavior");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		size_t len;
		const char* str = luaL_checklstring(L, 1, &len);
		const auto cache_key = soup::joaat::hashRange(str, len);
		if (auto e = lua_exe_scan_cache.find(cache_key); e != lua_exe_scan_cache.end())
		{
			lua_pushpointer(L, reinterpret_cast<void*>(e->second));
		}
		else
		{
			const auto res = Module(nullptr).range.scan(Pattern(str, len)).as<uintptr_t>();
			lua_exe_scan_cache.emplace(cache_key, res);
			lua_pushpointer(L, reinterpret_cast<void*>(res));
		}
		return 1;
	});
	OWF_SET_GLOBAL(L, "mem_scan_exe");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, *lua_checkpointer<int8_t*>(L, 1));
		return 1;
	});
	OWF_SET_GLOBAL(L, "mem_read_i8");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, *lua_checkpointer<int16_t*>(L, 1));
		return 1;
	});
	OWF_SET_GLOBAL(L, "mem_read_i16");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, *lua_checkpointer<int32_t*>(L, 1));
		return 1;
	});
	OWF_SET_GLOBAL(L, "mem_read_i32");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, *lua_checkpointer<int64_t*>(L, 1));
		return 1;
	});
	OWF_SET_GLOBAL(L, "mem_read_i64");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		*lua_checkpointer<int64_t*>(L, 1) = luaL_checkinteger(L, 2);
		return 0;
	});
	OWF_SET_GLOBAL(L, "mem_write_i64");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushnumber(L, *lua_checkpointer<float*>(L, 1));
		return 1;
	});
	OWF_SET_GLOBAL(L, "mem_read_f32");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		*lua_checkpointer<float*>(L, 1) = luaL_checknumber(L, 2);
		return 0;
	});
	OWF_SET_GLOBAL(L, "mem_write_f32");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.type = owf_game_tag(LUAU_NIL);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_nil");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.value.as_bool = lua_toboolean(L, 1);
		operation.value.type = owf_game_tag(LUAU_BOOL);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_bool");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.value.as_bool =
			static_cast<std::uint32_t>(luaL_checkinteger(L, 1));
		operation.value.type = owf_game_tag(LUAU_BOOL);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_int_as_bool");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.value.as_float = static_cast<float>(
			luaL_checkinteger(L, 1));
		operation.value.type = owf_game_tag(LUAU_NUMBER);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_int");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.value.as_float = static_cast<float>(
			luaL_checknumber(L, 1));
		operation.value.type = owf_game_tag(LUAU_NUMBER);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_float");

	
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_pushstring)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::push_string;
		operation.text = luaL_checkstring(L, 1);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_string");

	// Capture the DE GlobalState at wrapper construction.  The current bridge
	// state may point at a different movie by the time Pluto finalizes it.
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::registry_owner;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushlightuserdata(L, operation.pointer);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_registry_owner");

	// owfUserdata.__gc runs in Pluto's collector.  The native Application-frame
	// scheduler does not own a live DE Lua API invocation, so finalization may
	// only enqueue the registry key.  A real game-owned set-global call drains
	// the deletion later on the exact owning DE GlobalState.
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		size_t key_size = 0;
		const char* const key = luaL_checklstring(L, 1, &key_size);
		auto* const owner = reinterpret_cast<luau_GlobalState*>(
			lua_touserdata(L, 2));
		const bool queued = queue_deferred_game_registry_release(
			owner, key, key_size);
		lua_pushboolean(L, queued);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_defer_registry_release");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_pushpointer)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::push_pointer;
		operation.pointer = reinterpret_cast<void*>(luaL_checkinteger(L, 1));
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_pointer");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_pushobject)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::push_object;
		operation.object = reinterpret_cast<Object*>(luaL_checkinteger(L, 1));
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		/*luau_obj_buf[3] = &obj->self_pointer;
		luau_L->outtop->value.as_uintptr = reinterpret_cast<uintptr_t>(&luau_obj_buf[0]);
		luau_L->outtop->type = owf_game_tag(LUAU_USERDATA);
		luau_L->outtop++;*/
		/*if (***(void****)(luau_L->outtop[-1].value.as_uintptr + 0x18) != obj)
		{
			ObfusString err("invalid object");
			luaL_error(L, "%s", err.c_str());
		}*/
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_object");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_pushcclosurek)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		const auto cid = luaL_checkinteger(L, 1);
		const auto generation =
			renovice::de_vm_authority::transaction_generation_id();
		SOUP_IF_UNLIKELY (generation == 0)
		{
			luaL_error(L, ObfusString("game VM generation unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::push_callback;
		operation.callback_instance = static_cast<std::uintptr_t>(
			static_cast<owfScript*>(L->l_G->user_data)->instance_id);
		operation.callback_id = static_cast<std::uintptr_t>(cid);
		operation.callback_generation = generation;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 3))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_callback2");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_next)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::next;
		luau_TValue table{};
		bool pass_table = false;
		const auto index = static_cast<int>(luaL_checkinteger(L, 1));
		SOUP_IF_UNLIKELY (!capture_game_vm_table_argument(
			luau_L, index, operation, table, pass_table)
			|| !run_protected_game_vm_operation(
				luau_L, operation, 1, pass_table ? &table : nullptr, 2))
		{
			luaL_error(L, "%s", operation.error[0] != '\0'
				? operation.error : "invalid game VM table index");
		}
		lua_pushboolean(L, operation.api_result);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_next");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.value.as_uintptr = luaL_checkinteger(L, 1);
		operation.value.type = owf_game_tag(LUAU_USERDATA);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_userdata");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::append_value;
		operation.value.value.as_uintptr = luaL_checkinteger(L, 1);
		operation.value.type = owf_game_tag(LUAU_LIGHTUSERDATA);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_lightuserdata");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto index = static_cast<int>(luaL_checkinteger(L, 1));
		ProtectedGameVmOperation operation;
		if (index <= -10000)
		{
			operation.kind = ProtectedGameVmOperationKind::push_pseudo_index;
			operation.index = index;
		}
		else
		{
			operation.kind = ProtectedGameVmOperationKind::append_value;
			SOUP_IF_UNLIKELY (!capture_game_vm_stack_value(
				luau_L, index, operation.value))
			{
				luaL_error(L, ObfusString("invalid game VM stack index"));
			}
		}
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_value");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto f = lua_checkpointer<luau_CFunction>(L, 1);
		const auto raw_nargs = luaL_checkinteger(L, 2);
		SOUP_IF_UNLIKELY (luau_L == nullptr || f == nullptr
			|| raw_nargs < 0 || raw_nargs > 0x7fffffff
			|| !valid_game_vm_stack_window(luau_L))
		{
			luaL_error(L, ObfusString("game VM transaction unavailable"));
		}
		const auto nargs = static_cast<int>(raw_nargs);
		const auto available = luau_L->outtop - luau_L->intop;
		SOUP_IF_UNLIKELY (available < 0
			|| static_cast<std::ptrdiff_t>(nargs) > available
			|| luau_pushcclosurek == nullptr)
		{
			luaL_error(L, ObfusString("insufficient game VM stack"));
		}

		const auto base_offset = luau_savestack(
			luau_L, luau_L->outtop - nargs);
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::push_closure;
		operation.function = f;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		SOUP_IF_UNLIKELY (!valid_game_vm_stack_window(luau_L)
			|| luau_L->outtop <= luau_L->intop)
		{
			luaL_error(L, ObfusString("invalid game VM stack after closure push"));
		}
		auto* call_base = luau_restorestack(luau_L, base_offset);
		const auto function = luau_L->outtop[-1];
		if (nargs != 0)
		{
			std::memmove(call_base + 1, call_base,
				static_cast<std::size_t>(nargs) * sizeof(luau_TValue));
		}
		*call_base = function;
		luau_L->outtop = call_base + nargs + 1;

		const int status = renovice::de_vm_authority::protected_call(
			luau_L, nargs, -1, 0);
		SOUP_IF_UNLIKELY (!valid_game_vm_stack_window(luau_L))
		{
			luaL_error(L, ObfusString("invalid game VM stack after protected call"));
		}
		call_base = luau_restorestack(luau_L, base_offset);
		if (status != 0
			|| !renovice::de_vm_authority::transaction_generation_alive())
		{
			const auto message = protected_game_vm_error(
				luau_L, call_base,
				status != 0 ? "protected game call failed"
					: "game VM generation retired during call");
			luau_L->outtop = call_base;
			luaL_error(L, "%s", message.c_str());
		}
		const auto result_count = luau_L->outtop - call_base;
		SOUP_IF_UNLIKELY (result_count < 0 || result_count > 0x7fffffff)
		{
			luau_L->outtop = call_base;
			luaL_error(L, ObfusString("invalid protected result count"));
		}
		const auto nresults = static_cast<int>(result_count);
		lua_pushinteger(L, nresults);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_call");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::stack_top;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0)
			|| operation.result_stack_offset < 0
			|| operation.result_stack_offset % sizeof(luau_TValue) != 0)
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushinteger(L,
			operation.result_stack_offset / sizeof(luau_TValue));
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_top");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::set_stack_top;
		SOUP_IF_UNLIKELY (!game_vm_slot_index_to_offset(
			luaL_checkinteger(L, 1), operation.requested_stack_offset)
			|| !run_protected_game_vm_operation(
				luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error[0] != '\0'
				? operation.error : "invalid game VM top");
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_set_top");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::stack_base;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0)
			|| operation.result_stack_offset < 0
			|| operation.result_stack_offset % sizeof(luau_TValue) != 0)
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushinteger(L,
			operation.result_stack_offset / sizeof(luau_TValue));
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_base");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::set_stack_base;
		SOUP_IF_UNLIKELY (!game_vm_slot_index_to_offset(
			luaL_checkinteger(L, 1), operation.requested_stack_offset)
			|| !run_protected_game_vm_operation(
				luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error[0] != '\0'
				? operation.error : "invalid game VM base");
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_set_base");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto count = luaL_optinteger(L, 1, 1);
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_values;
		SOUP_IF_UNLIKELY (count < 0 || count > 0x7fffffff)
		{
			luaL_error(L, ObfusString("invalid game VM pop count"));
		}
		operation.index = static_cast<int>(count);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_BOOL);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushboolean(L, operation.value.value.as_bool);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_bool");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_NUMBER);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushnumber(L, operation.value.value.as_float);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_number");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_STRING);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushstring(L, operation.value.getString());
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_string");

	// Unused
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_USERDATA);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushinteger(L, operation.value.value.as_uintptr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_userdata");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::inspect_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_USERDATA);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushinteger(L, operation.value.value.as_uintptr);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_userdata");

	// Unused
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_USERDATA);
		operation.projection =
			ProtectedGameVmValueProjection::userdata_payload;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushpointer(L, operation.pointer);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_pointer");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_USERDATA);
		operation.projection =
			ProtectedGameVmValueProjection::object_pointer;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushpointer(L, operation.pointer);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_object");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::pop_value;
		operation.index = -1;
		operation.expected_type = owf_game_tag(LUAU_FUNCTION);
		operation.projection = ProtectedGameVmValueProjection::c_function;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushpointer(L, operation.pointer);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_pop_c_function");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto raw_index = luaL_checkinteger(L, 1);
		SOUP_IF_UNLIKELY (raw_index < 0 || raw_index > 0xff)
		{
			luaL_error(L, ObfusString("index out of range"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::get_upvalue;
		operation.index = static_cast<int>(raw_index);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_upvalue");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto raw_index = luaL_checkinteger(L, 1);
		SOUP_IF_UNLIKELY (raw_index < 0 || raw_index > 0xff)
		{
			luaL_error(L, ObfusString("index out of range"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::set_upvalue;
		operation.index = static_cast<int>(raw_index);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 1, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_set_upvalue");

	OWF_SET_GLOBAL_INT(L, "IVKR_NIL", owf_game_tag(LUAU_NIL));
	OWF_SET_GLOBAL_INT(L, "IVKR_BOOL", owf_game_tag(LUAU_BOOL));
	OWF_SET_GLOBAL_INT(L, "IVKR_NUMBER", owf_game_tag(LUAU_NUMBER));
	OWF_SET_GLOBAL_INT(L, "IVKR_STRING", owf_game_tag(LUAU_STRING));
	OWF_SET_GLOBAL_INT(L, "IVKR_TABLE", owf_game_tag(LUAU_TABLE));
	OWF_SET_GLOBAL_INT(L, "IVKR_FUNCTION", owf_game_tag(LUAU_FUNCTION));

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto raw_index = luaL_checkinteger(L, 1);
		SOUP_IF_UNLIKELY (raw_index < (std::numeric_limits<int>::min)()
			|| raw_index > (std::numeric_limits<int>::max)())
		{
			luaL_error(L, ObfusString("invalid game VM stack index"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::inspect_value;
		operation.index = static_cast<int>(raw_index);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushinteger(L, operation.value.type);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_type");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto raw_index = luaL_checkinteger(L, 1);
		SOUP_IF_UNLIKELY (raw_index < (std::numeric_limits<int>::min)()
			|| raw_index > (std::numeric_limits<int>::max)())
		{
			luaL_error(L, ObfusString("invalid game VM stack index"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::inspect_value;
		operation.index = static_cast<int>(raw_index);
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 0))
		{
			luaL_error(L, "%s", operation.error);
		}
		const auto type = operation.value.type;
		lua_pushboolean(L, type == owf_game_tag(LUAU_LIGHTUSERDATA) || type == owf_game_tag(LUAU_USERDATA));
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_isuserdata");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_gettable)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::gettable;
		luau_TValue table{};
		bool pass_table = false;
		const auto index = static_cast<int>(luaL_checkinteger(L, 1));
		SOUP_IF_UNLIKELY (!capture_game_vm_table_argument(
			luau_L, index, operation, table, pass_table)
			|| !run_protected_game_vm_operation(
				luau_L, operation, 1, pass_table ? &table : nullptr, 1))
		{
			luaL_error(L, "%s", operation.error[0] != '\0'
				? operation.error : "invalid game VM table index");
		}
		lua_pushinteger(L, operation.api_result);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_gettable");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_createtable)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::newtable;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_newtable");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (!luau_settable)
		{
			luaL_error(L, ObfusString("Function unavailable"));
		}
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::settable;
		luau_TValue table{};
		bool pass_table = false;
		const auto index = static_cast<int>(luaL_checkinteger(L, 1));
		SOUP_IF_UNLIKELY (!capture_game_vm_table_argument(
			luau_L, index, operation, table, pass_table)
			|| !run_protected_game_vm_operation(
				luau_L, operation, 2, pass_table ? &table : nullptr, 1))
		{
			luaL_error(L, "%s", operation.error[0] != '\0'
				? operation.error : "invalid game VM table index");
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_settable");

#if PRIVATE
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_Integer i = 0;
		lua_newtable(L);
		for (const auto& name : swig_type_names)
		{
			lua_pushinteger(L, ++i);
			pluto_pushstring(L, name);
			lua_settable(L, -3);
		}
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_types");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			lua_Integer i = 0;
			lua_newtable(L);
			for (auto method = e->second->methods; method->hash != 0; ++method)
			{
				lua_pushinteger(L, ++i);
				lua_pushinteger(L, method->hash);
				lua_settable(L, -3);
			}
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_methods");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			lua_Integer i = 0;
			lua_newtable(L);
			for (auto attr = e->second->attributes; attr->hash != 0; ++attr)
			{
				lua_pushinteger(L, ++i);
				lua_pushinteger(L, attr->hash);
				lua_settable(L, -3);
			}
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_attributes");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			lua_pushstring(L, *e->second->parent_ptr_name);
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_get_parent");

	if (game_version >= GV(40, 0, 0))
	{
		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			lua_newtable(L);
			lua_Integer n1 = 0;
			for (const auto& e1 : swig_enums2)
			{
				lua_pushinteger(L, ++n1);
				lua_newtable(L);
				lua_Integer n2 = 0;
				for (const auto& e2 : e1)
				{
					lua_pushinteger(L, ++n2);
					lua_newtable(L);
					{
						lua_pushstring(L, "name");
						lua_pushstring(L, e2.name);
						lua_settable(L, -3);
					}
					{
						lua_pushstring(L, "value");
						lua_pushinteger(L, e2.value);
						lua_settable(L, -3);
					}
					lua_settable(L, -3);
				}
				lua_settable(L, -3);
			}
			return 1;
		});
	}
	else
	{
		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			lua_newtable(L);
			lua_Integer n1 = 0;
			for (const auto& first : swig_enums1)
			{
				lua_pushinteger(L, ++n1);
				lua_newtable(L);
				lua_Integer n2 = 0;
				for (auto i = first; i->name != nullptr; ++i)
				{
					lua_pushinteger(L, ++n2);
					lua_newtable(L);
					{
						lua_pushstring(L, "name");
						lua_pushstring(L, i->name);
						lua_settable(L, -3);
					}
					{
						lua_pushstring(L, "value");
						lua_pushinteger(L, i->value);
						lua_settable(L, -3);
					}
					lua_settable(L, -3);
				}
				lua_settable(L, -3);
			}
			return 1;
		});
	}
	OWF_SET_GLOBAL(L, "ivkr_get_enums");
#endif

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, wf_hash(luaL_checkstring(L, 1)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_hash");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		void* res = nullptr;
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			res = reinterpret_cast<void*>(e->second->ctor);
		}
		lua_pushpointer(L, res);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_find_ctor");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		void* res = nullptr;
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			res = reinterpret_cast<void*>(e->second->findMethod(lua_type(L, 2) == LUA_TNUMBER ? luaL_checkinteger(L, 2) : wf_hash(luaL_checkstring(L, 2))));
		}
		lua_pushpointer(L, res);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_find_method");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		void* res = nullptr;
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			res = reinterpret_cast<void*>(e->second->findGetter(wf_hash(luaL_checkstring(L, 2))));
		}
		lua_pushpointer(L, res);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_find_getter");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		void* res = nullptr;
		if (auto e = swig_types.find(soup::joaat::hash(luaL_checkstring(L, 1))); e != swig_types.end())
		{
			res = reinterpret_cast<void*>(e->second->findSetter(wf_hash(luaL_checkstring(L, 2))));
		}
		lua_pushpointer(L, res);
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_find_setter");

	if (game_version >= GV(40, 0, 0))
	{
		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			const auto target = luaL_checkstring(L, 1);
			for (const auto& e1 : swig_enums2)
			{
				for (const auto& e2 : e1)
				{
					if (strcmp(e2.name, target) == 0)
					{
						lua_pushinteger(L, e2.value);
						return 1;
					}
				}
			}
			return 0;
		});
	}
	else
	{
		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			const auto target = luaL_checkstring(L, 1);
			for (const auto& first : swig_enums1)
			{
				for (auto i = first; i->name != nullptr; ++i)
				{
					if (strcmp(i->name, target) == 0)
					{
						lua_pushinteger(L, i->value);
						return 1;
					}
				}
			}
			return 0;
		});
	}
	OWF_SET_GLOBAL(L, "ivkr_get_enum_value");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, owfOverlay::getWidth());
		lua_pushinteger(L, owfOverlay::getHeight());
		return 2;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_get_size");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto id = owfOverlay::addRect(
			luaL_checkinteger(L, 1),
			luaL_checkinteger(L, 2),
			luaL_checkinteger(L, 3),
			luaL_checkinteger(L, 4),
			luaL_checkinteger(L, 5),
			luaL_checkinteger(L, 6),
			luaL_checkinteger(L, 7)
		);
		static_cast<owfScript*>(L->l_G->user_data)->overlay_items.emplace(id);
		lua_pushlightuserdata(L, id);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_add_rect");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto id = owfOverlay::addText(
			luaL_checkinteger(L, 1),
			luaL_checkinteger(L, 2),
			pluto_checkstring(L, 3),
			luaL_checkinteger(L, 4) == 5 ? &RasterFont::simple5() : &RasterFont::simple8(),
			luaL_checkinteger(L, 5),
			luaL_checkinteger(L, 6),
			luaL_checkinteger(L, 7),
			luaL_optinteger(L, 8, 1)
		);
		static_cast<owfScript*>(L->l_G->user_data)->overlay_items.emplace(id);
		lua_pushlightuserdata(L, id);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_add_text");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto id = (owfOverlay::DrawItem*)lua_touserdata(L, 1);
		SOUP_IF_UNLIKELY (!id)
		{
			luaL_typeerror(L, 1, lua_typename(L, LUA_TLIGHTUSERDATA));
		}
		if (lua_toboolean(L, 2) ^ (id->type >= 0))
		{
			id->type *= -1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_set_visibility");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto id = (owfOverlay::DrawItem*)lua_touserdata(L, 1);
		SOUP_IF_UNLIKELY (!id)
		{
			luaL_typeerror(L, 1, lua_typename(L, LUA_TLIGHTUSERDATA));
		}
		id->r = luaL_checkinteger(L, 2);
		id->g = luaL_checkinteger(L, 3);
		id->b = luaL_checkinteger(L, 4);
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_set_colour");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto id = (owfOverlay::Text*)lua_touserdata(L, 1);
		SOUP_IF_UNLIKELY (!id || id->getType() != owfOverlay::DrawItem::TEXT)
		{
			luaL_typeerror(L, 1, lua_typename(L, LUA_TLIGHTUSERDATA));
		}
		std::lock_guard lock(owfOverlay::mtx);
		id->text = pluto_checkstring(L, 2);
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_set_text");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto id = (owfOverlay::DrawItem*)lua_touserdata(L, 1);
		SOUP_IF_UNLIKELY (!id)
		{
			luaL_typeerror(L, 1, lua_typename(L, LUA_TLIGHTUSERDATA));
		}
		auto& overlay_items = static_cast<owfScript*>(L->l_G->user_data)->overlay_items;
		if (auto e = overlay_items.find(id); e != overlay_items.end())
		{
			overlay_items.erase(e);
			owfOverlay::remove(id);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_remove");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		owfOverlay::redraw();
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_overlay_update");

	lua_pushcfunction(L, ([](lua_State* L) -> int
	{
		const auto font = luaL_checkinteger(L, 1) == 5 ? &RasterFont::simple5() : &RasterFont::simple8();
		auto [width, height] = font->measure(pluto_checkstring(L, 2));
		lua_pushinteger(L, width);
		lua_pushinteger(L, height);
		return 2;
	}));
	OWF_SET_GLOBAL(L, "owf_measure_text");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushnumber(L, fov_override);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_fov_override");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pause_always_stops_time = lua_toboolean(L, 1);
		return 0;
	});
	OWF_SET_GLOBAL(L, "set_pause_always_stops_time");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->subscribed_chat_prefixes.emplace(pluto_checkstring(L, 1), lua_toboolean(L, 2));
		return 0;
	});
	OWF_SET_GLOBAL(L, "chat_subscribe_prefix");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->subscribed_chat_prefixes.erase(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "chat_unsubscribe_prefix");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->subscribed_outgoing_chat_prefixes.emplace(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "chat_subscribe_outgoing_prefix");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->subscribed_outgoing_chat_prefixes.erase(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "chat_unsubscribe_outgoing_prefix");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->websocket_message_prefixes.emplace(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "register_websocket_message_prefix");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->websocket_message_prefixes.erase(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "unregister_websocket_message_prefix");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		ProtectedGameVmOperation operation;
		operation.kind = ProtectedGameVmOperationKind::chat_redux;
		operation.pointer = ChatRedux_global_state;
		SOUP_IF_UNLIKELY (!run_protected_game_vm_operation(
			luau_L, operation, 0, nullptr, 1))
		{
			luaL_error(L, "%s", operation.error);
		}
		lua_pushboolean(L, operation.api_result
			== static_cast<int>(owf_game_tag(LUAU_TABLE)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "ivkr_push_chat_redux");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		SOUP_IF_UNLIKELY (luau_L == nullptr
			|| !valid_game_vm_stack_window(luau_L))
		{
			luaL_error(L, ObfusString("game VM transaction unavailable"));
		}

		const auto raw_nargs = luaL_checkinteger(L, 1);
		const auto raw_nresults = luaL_checkinteger(L, 2);
		SOUP_IF_UNLIKELY (raw_nargs < 0 || raw_nargs > 0x7fffffff
			|| raw_nresults < -1 || raw_nresults > 0x7fffffff)
		{
			luaL_error(L, ObfusString("invalid protected call arity"));
		}
		const auto nargs = static_cast<int>(raw_nargs);
		const auto nresults = static_cast<int>(raw_nresults);

		const auto available = luau_L->outtop - luau_L->intop;
		const auto required = static_cast<std::ptrdiff_t>(nargs) + 1;
		SOUP_IF_UNLIKELY (available < required)
		{
			luaL_error(L, ObfusString("invalid protected call stack"));
		}
		const auto call_top_offset = luau_savestack(
			luau_L, luau_L->outtop - required);
		const int status = renovice::de_vm_authority::protected_call(
			luau_L, nargs, nresults, 0);
		SOUP_IF_UNLIKELY (!valid_game_vm_stack_window(luau_L))
		{
			luaL_error(L, ObfusString("invalid game VM stack after protected call"));
		}
		auto* const call_top = luau_restorestack(luau_L, call_top_offset);
		if (status != 0
			|| !renovice::de_vm_authority::transaction_generation_alive())
		{
			const auto message = protected_game_vm_error(
				luau_L, call_top,
				status != 0 ? "protected game call failed"
					: "game VM generation retired during call");
			luau_L->outtop = call_top;
			luaL_error(L, "%s", message.c_str());
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "ivkr_call2");

	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_SUBMIT_CHAT_MESSAGE);
	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_OUTGOING_CHAT_MESSAGE);
	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_CUSTOM_ROUTE_REQUEST);
	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_CUSTOM_ROUTE_SERVED);
	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_CALLBACK);
	//OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_SCRIPT_TRIGGERED);
	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_WEBSOCKET_MESSAGE);
	OWF_EXPOSE_INT_CONSTANT(L, OWF_EVT_SCRIPT_MESSAGE);

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto scr = static_cast<owfScript*>(L->l_G->user_data);
		if (!scr->events.empty())
		{
			lua_newtable(L);
			{
				pluto_pushstring(L, ObfusString("type").str());
				lua_pushinteger(L, scr->events.front().type);
				lua_settable(L, -3);
			}
			switch (scr->events.front().type)
			{
			case OWF_EVT_SUBMIT_CHAT_MESSAGE:
				pluto_pushstring(L, ObfusString("text").str());
				pluto_pushstring(L, scr->events.front().data);
				lua_settable(L, -3);
				pluto_pushstring(L, ObfusString("blocked").str());
				lua_pushboolean(L, scr->events.front().intdata);
				lua_settable(L, -3);
				break;

			case OWF_EVT_CUSTOM_ROUTE_REQUEST:
				{
					pluto_pushstring(L, ObfusString("inst").str());
					SOUP_UNUSED(OWF_PLUTO_NEWCLASSINST(L, soup::SharedPtr<owfScriptRouteTask>, soup::SharedPtr<owfScriptRouteTask>::fromDumb(reinterpret_cast<void*>(scr->events.front().intdata))));
					lua_settable(L, -3);
				}
				[[fallthrough]];
			case OWF_EVT_CUSTOM_ROUTE_SERVED:
				pluto_pushstring(L, ObfusString("path").str());
				pluto_pushstring(L, scr->events.front().data);
				lua_settable(L, -3);
				break;

			case OWF_EVT_CALLBACK:
				pluto_pushstring(L, ObfusString("name").str());
				pluto_pushstring(L, scr->events.front().data);
				lua_settable(L, -3);
				break;

			case OWF_EVT_SCRIPT_MESSAGE:
				{
					pluto_pushstring(L, ObfusString("inst").str());
					SOUP_UNUSED(OWF_PLUTO_NEWCLASSINST(L, soup::UniquePtr<owfScriptReplySender>, reinterpret_cast<owfScriptReplySender*>(scr->events.front().intdata)));
					lua_settable(L, -3);
				}
				[[fallthrough]];
			//case OWF_EVT_SCRIPT_TRIGGERED:
			case OWF_EVT_OUTGOING_CHAT_MESSAGE:
				pluto_pushstring(L, ObfusString("data").str());
				pluto_pushstring(L, scr->events.front().data);
				lua_settable(L, -3);
				break;

			case OWF_EVT_WEBSOCKET_MESSAGE:
				pluto_pushstring(L, ObfusString("sender").str());
				lua_pushinteger(L, scr->events.front().intdata);
				lua_settable(L, -3);
				pluto_pushstring(L, ObfusString("text").str());
				pluto_pushstring(L, scr->events.front().data);
				lua_settable(L, -3);
				break;
			}
			scr->events.pop_front();
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_internal_next_event");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pluto_pushstring(L, active_input_filter);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_active_input_filter");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushboolean(L, active_input_filter_allows_hotkeys);
		return 1;
	});
	OWF_SET_GLOBAL(L, "get_active_input_filter_allows_hotkeys");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		std::lock_guard lock(g_server_tunables_mtx);
		lua_pushboolean(L, g_server_tunables.getBool(soup::joaat::hash(luaL_checkstring(L, 1))));
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_tunables_has");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->static_custom_routes.emplace(soup::joaat::hash(luaL_checkstring(L, 1)), CustomRouteResponse{ pluto_checkstring(L, 2), pluto_checkstring(L, 3) });
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_register_custom_route");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->static_custom_routes.erase(soup::joaat::hash(luaL_checkstring(L, 1)));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_unregister_custom_route");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->dynamic_custom_routes.emplace(soup::joaat::hash(luaL_checkstring(L, 1)));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_register_dynamic_custom_route");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->dynamic_custom_routes.erase(soup::joaat::hash(luaL_checkstring(L, 1)));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_unregister_dynamic_custom_route");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto& spTask = *(soup::SharedPtr<owfScriptRouteTask>*)luaL_checkudata(L, 1, soup::ObfusString("soup::SharedPtr<owfScriptRouteTask>").c_str());
		auto pTask = spTask.get();
		if (pTask == nullptr)
		{
			ObfusString msg("Request does not exist?! This should not happen.");
			luaL_error(L, "%s", msg.c_str());
		}
		if (pTask->response.load() != nullptr)
		{
			ObfusString msg("Request was already responded to");
			luaL_error(L, "%s", msg.c_str());
		}
		pTask->response.store(new CustomRouteResponse{ pluto_checkstring(L, 2), pluto_checkstring(L, 3) });
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_dynamic_custom_route_response");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		size_t tag_len;
		auto tag = luaL_checklstring(L, 1, &tag_len);

		std::string name = static_cast<owfScript*>(L->l_G->user_data)->name; // owf_script_get_name
		name.append(tag, tag_len);
		static_cast<owfScript*>(L->l_G->user_data)->callbacks.emplace(std::move(name));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_register_callback");

	/*lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto script = luaL_checkstring(L, 1);
		const auto func = luaL_checkstring(L, 2);
		const auto block = lua_toboolean(L, 3);

		uint32_t hash = 0;
		hash = joaat::partialStr(script, hash);
		hash = joaat::partialStr(func, hash);
		joaat::finalise(hash);

		static_cast<owfScript*>(L->l_G->user_data)->subscribed_script_triggers.emplace(hash, block);

		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_subscribe_to_script_trigger");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto script = luaL_checkstring(L, 1);
		const auto func = luaL_checkstring(L, 2);

		uint32_t hash = 0;
		hash = joaat::partialStr(script, hash);
		hash = joaat::partialStr(func, hash);
		joaat::finalise(hash);

		static_cast<owfScript*>(L->l_G->user_data)->subscribed_script_triggers.erase(hash);

		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_unsubscribe_from_script_trigger");*/

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, static_cast<float>(luaL_checkinteger(L, 1)) + static_cast<float>(luaL_checkinteger(L, 2)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "fltm_int_add");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, static_cast<float>(luaL_checkinteger(L, 1)) * static_cast<float>(luaL_checkinteger(L, 2)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "fltm_int_mul");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushnumber(L, static_cast<float>(luaL_checknumber(L, 1)) + static_cast<float>(luaL_checknumber(L, 2)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "fltm_float_add");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushnumber(L, static_cast<float>(luaL_checknumber(L, 1)) * static_cast<float>(luaL_checknumber(L, 2)));
		return 1;
	});
	OWF_SET_GLOBAL(L, "fltm_float_mul");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		/*if (pluto_checkstring(L, 1) == "[]")
		{
			luaL_error(L, ObfusString("u wot m8, no way you meant to broadcast []"));
		}*/
		owf_broadcast_message(pluto_checkstring(L, 1), luaL_optinteger(L, 2, 0));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_broadcast_message");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto cmd = pluto_checkstring(L, 1);
		try
		{
			if (JsonObject obj; owf_command(cmd, obj))
			{
				pluto_pushstring(L, obj.encode());
				return 1;
			}
		}
		catch (std::exception& e)
		{
			luaL_error(L, "%s", e.what());
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_command_raw");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		pluto_pushstring(L, static_cast<owfScript*>(L->l_G->user_data)->name);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_script_get_name");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		lua_pushinteger(L, static_cast<owfScript*>(L->l_G->user_data)->instance_id);
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_script_get_instance_id");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto cp_name = pluto_checkstring(L, 1);
		const auto cp_hash = joaat::hash(cp_name);
		size_t pathlen;
		const char* path = luaL_checklstring(L, 2, &pathlen);

		CachePair* cp;
		if (auto e = open_cache_pairs.find(cp_hash); e != open_cache_pairs.end())
		{
			cp = e->second;
		}
		else
		{
			try
			{
				cp = new CachePair(ObfusString("Cache.Windows/").str() + cp_name);
			}
			catch (const std::bad_alloc&)
			{
				cp = nullptr;
			}
			SOUP_IF_UNLIKELY (!cp || !cp->toc || !cp->cache)
			{
				delete cp;
				luaL_error(L, ObfusString("failed to open cache pair '%s'"), cp_name.c_str());
			}
			open_cache_pairs.emplace(cp_hash, cp);
		}

		if (auto entry = cp->findEntry(path, pathlen))
		{
			lua_pushlstring(L, (const char*)cp->cache + entry->cacheOffset, entry->compressedLen);
			lua_pushinteger(L, entry->length);
			return 2;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_cache_find");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		for (auto& e : open_cache_pairs)
		{
			delete e.second;
		}
		open_cache_pairs.clear();
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_cache_close");

	if (game_version >= GV(41, 0, 0))
	{
		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			lua_pushboolean(L, OodleLZ_Decompress != nullptr);
			return 1;
		});
		OWF_SET_GLOBAL(L, "oodle_available");

		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			size_t compressed_len;
			const char* compressed = luaL_checklstring(L, 1, &compressed_len);
			const size_t decompressed_size = luaL_checkinteger(L, 2);

			SOUP_IF_LIKELY (OodleLZ_Decompress != nullptr)
			{
				char shrtbuf[LUAI_MAXSHORTLEN];
				auto decompressed = plutoS_prealloc(L, shrtbuf, decompressed_size);
				OodleLZ_Decompress(compressed, compressed_len, decompressed, decompressed_size, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3);
				plutoS_commit(L, decompressed, decompressed_size);
				return 1;
			}
			return 0;
		});
		OWF_SET_GLOBAL(L, "oodle_decompress");
	}
	else
	{
		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			lua_pushboolean(L, std::filesystem::is_regular_file(ObfusString("Tools/Oodle/x64/final/oo2core_9_win64.dll").str()));
			return 1;
		});
		OWF_SET_GLOBAL(L, "oodle_available");

		lua_pushcfunction(L, [](lua_State* L) -> int
		{
			size_t compressed_len;
			const char* compressed = luaL_checklstring(L, 1, &compressed_len);
			const size_t decompressed_size = luaL_checkinteger(L, 2);

			SharedLibrary lib(ObfusString("Tools/Oodle/x64/final/oo2core_9_win64.dll"));
			using OodleLZ_Decompress_t = int(*)(const char* inputData, size_t inputLen, void* outputData, size_t outputLen, int a5, int a6, int a7, size_t a8, size_t a9, size_t a10, size_t a11, size_t a12, size_t a13, int a14);
			SOUP_IF_LIKELY (auto OodleLZ_Decompress = (OodleLZ_Decompress_t)lib.getAddress(ObfusString("OodleLZ_Decompress")))
			{
				char shrtbuf[LUAI_MAXSHORTLEN];
				auto decompressed = plutoS_prealloc(L, shrtbuf, decompressed_size);
				OodleLZ_Decompress(compressed, compressed_len, decompressed, decompressed_size, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3);
				plutoS_commit(L, decompressed, decompressed_size);
				return 1;
			}
			return 0;
		});
		OWF_SET_GLOBAL(L, "oodle_decompress");
	}

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->channels.emplace(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_script_register_channel");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		static_cast<owfScript*>(L->l_G->user_data)->channels.erase(pluto_checkstring(L, 1));
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_script_unregister_channel");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto channel = pluto_checkstring(L, 1);
		auto text = pluto_checkstring(L, 2);

		owfScript* target = nullptr;
		for (auto& scr : running_scripts)
		{
			if (scr->channels.contains(channel))
			{
				target = scr;
				break;
			}
		}
		if (!target && bgscript && bgscript->channels.contains(channel))
		{
			target = bgscript;
		}

		if (target)
		{
			auto pReplyReceiver = OWF_PLUTO_NEWCLASSINST(L, owfScriptReplyReceiver);
			auto pReplySender = new owfScriptReplySender();

			pReplyReceiver->sender = pReplySender;
			pReplySender->receiver = pReplyReceiver;

			JsonObject obj;
			obj.add(ObfusString("channel"), std::move(channel));
			obj.add(ObfusString("text"), std::move(text));
			target->events.emplace_back(OWF_EVT_SCRIPT_MESSAGE, reinterpret_cast<uint64_t>(pReplySender), obj.encode());
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_script_send_message");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto& upReplySender = *(soup::UniquePtr<owfScriptReplySender>*)luaL_checkudata(L, 1, soup::ObfusString("soup::UniquePtr<owfScriptReplySender>").c_str());
		if (auto pReplyReceiver = upReplySender->receiver.getPointer())
		{
			if (pReplyReceiver->response.has_value())
			{
				ObfusString msg("A reply was already sent");
				luaL_error(L, "%s", msg.c_str());
			}
			pReplyReceiver->response = pluto_checkstring(L, 2);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_script_send_reply");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto& replyReceiver = *(owfScriptReplyReceiver*)luaL_checkudata(L, 1, soup::ObfusString("owfScriptReplyReceiver").c_str());
		lua_pushboolean(L, replyReceiver.sender.isValid());
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_script_is_reply_pending");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		auto& replyReceiver = *(owfScriptReplyReceiver*)luaL_checkudata(L, 1, soup::ObfusString("owfScriptReplyReceiver").c_str());
		if (replyReceiver.response.has_value())
		{
			pluto_pushstring(L, replyReceiver.response.value());
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_script_get_reply");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto x = luaL_checkinteger(L, 1);
		const auto y = luaL_checkinteger(L, 2);
		const auto width = luaL_checkinteger(L, 3);
		const auto height = luaL_checkinteger(L, 4);
		pluto_pushstring(L, soup::os::makeScreenshotBmp(x, y, width, height));
		return 1;
	});
	OWF_SET_GLOBAL(L, "make_screenshot_bmp");

	// Undocumented
	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		if (auto scr = get_script_by_name(pluto_checkstring(L, 1)))
		{
			lua_pushinteger(L, scr->getHotfixVersion());
			return 1;
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_script_get_hotfix_version");

	std::string runtime;
	{
		std::lock_guard lock(g_repo_mtx);

		OWF_SET_GLOBAL_INT(L, "OWF_CLIENT_HOTFIX", g_repo.hotfix);

		size_t size;
		auto data = g_repo.find(soup::joaat::compileTimeHash("OpenWF/runtime.pluto"), size);
		runtime = std::string(data, size);
	}
#if PRIVATE
	if (auto from_file = string::fromFile(R"(OpenWF/runtime.pluto)"); !from_file.empty())
	{
		runtime = std::move(from_file);
	}
#endif
	if (luaL_loadbuffer(L, runtime.data(), runtime.size(), runtime_script_name.c_str()) != LUA_OK
		|| lua_pcall(L, 0, 1, 0) != LUA_OK
		)
	{
		owfScript::logNl(lua_type(L, -1) == LUA_TSTRING ? pluto_checkstring(L, -1) : ObfusString("Non-string script error").str());
	}
}

owfScript::~owfScript()
{
	lua_close(main);

	if (!overlay_items.empty())
	{
		bool need_redraw = false;
		for (auto& id : overlay_items)
		{
			owfOverlay::remove(id);
			need_redraw |= (id->type >= 0);
		}
		if (need_redraw)
		{
			owfOverlay::redraw();
		}
		overlay_items.clear();
	}

	while (!events.empty())
	{
		switch (events.front().type)
		{
		case OWF_EVT_CUSTOM_ROUTE_REQUEST:
			SOUP_UNUSED(soup::SharedPtr<owfScriptRouteTask>::fromDumb(reinterpret_cast<void*>(events.front().intdata)));
			break;

		case OWF_EVT_SCRIPT_MESSAGE:
			SOUP_UNUSED(soup::UniquePtr<owfScriptReplySender>(reinterpret_cast<owfScriptReplySender*>(events.front().intdata)));
			break;

		default:;
		}
		events.pop_front();
	}
}

void owfScript::openBgscriptLibs()
{
	const auto L = this->main;

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		size_t size;
		const char* data = luaL_checklstring(L, 1, &size);
		bool delta = lua_toboolean(L, 2);
		lua_pushboolean(L, set_server_tunables(data, size, delta));
		return 1;
	});
	OWF_SET_GLOBAL(L, "owf_tunables_load");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		size_t size;
		const char* data = luaL_checklstring(L, 1, &size);
		if (size == 22)
		{
			owf_set_build_hash(data);
		}
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_set_build_hash");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		const auto addr = lua_checkpointer(L, 1);
		const auto size = luaL_checkinteger(L, 2);
		memGuard::setAllowedAccess(addr, size, memGuard::ACC_RWX);
		return 0;
	});
	OWF_SET_GLOBAL(L, "mem_set_rwx");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		http_port = (uint16_t)luaL_checkinteger(L, 1);
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_set_http_port");

	lua_pushcfunction(L, [](lua_State* L) -> int
	{
		https_port = (uint16_t)luaL_checkinteger(L, 1);
		return 0;
	});
	OWF_SET_GLOBAL(L, "owf_set_https_port");
}

bool owfScript::loadFile(std::string&& path)
{
	this->name = std::move(path);
	if (luaL_loadfile(main, this->name.c_str()) == LUA_OK)
	{
		coro = lua_newthread(main);
		luaL_ref(main, LUA_REGISTRYINDEX);
		lua_xmove(main, coro, 2);
		int nresults;
		if (lua_resume(coro, main, 1, &nresults) == LUA_YIELD)
		{
			return true;
		}
		owfScript::logNl(lua_type(coro, -1) == LUA_TSTRING ? pluto_checkstring(coro, -1) : ObfusString("Non-string script error").str());
		coro = nullptr;
	}
	else
	{
		owfScript::logNl(lua_type(main, -1) == LUA_TSTRING ? pluto_checkstring(main, -1) : ObfusString("Non-string script error").str());
	}
	return false;
}

bool owfScript::loadString(const std::string& name, const std::string& code)
{
	this->name = name;
	if (luaL_loadbuffer(main, code.data(), code.size(), this->name.c_str()) == LUA_OK)
	{
		coro = lua_newthread(main);
		luaL_ref(main, LUA_REGISTRYINDEX);
		lua_xmove(main, coro, 2);
		int nresults;
		if (lua_resume(coro, main, 1, &nresults) == LUA_YIELD)
		{
			return true;
		}
		owfScript::logNl(lua_type(coro, -1) == LUA_TSTRING ? pluto_checkstring(coro, -1) : ObfusString("Non-string script error").str());
		coro = nullptr;
	}
	else
	{
		owfScript::logNl(lua_type(main, -1) == LUA_TSTRING ? pluto_checkstring(main, -1) : ObfusString("Non-string script error").str());
	}
	return false;
}

bool owfScript::tick()
{
	int nresults;
	int status = lua_resume(coro, main, 0, &nresults);
	if (status == LUA_YIELD)
	{
		return true;
	}
	if (status != LUA_OK)
	{
		owfScript::logNl(lua_type(coro, -1) == LUA_TSTRING ? pluto_checkstring(coro, -1) : ObfusString("Non-string script error").str());
	}
	return false;
}

int owfScript::tick(int nargs)
{
	int nresults = 0;
	int status = lua_resume(coro, main, nargs, &nresults);
	SOUP_IF_UNLIKELY (status != LUA_YIELD && status != LUA_OK)
	{
		owfScript::logNl(lua_type(coro, -1) == LUA_TSTRING ? pluto_checkstring(coro, -1) : ObfusString("Non-string script error").str());
		return 0;
	}
	return nresults;
}

lua_Integer owfScript::getHotfixVersion() const
{
	ObfusString str("OWF_CLIENT_HOTFIX");
	lua_getglobal(main, str.c_str());
	const auto res = lua_tointeger(main, -1);
	lua_pop(main, 1);
	return res;
}

void start_script_from_file(std::string&& path)
{
	auto scr = new owfScript();
	bool ok = scr->loadFile(std::move(path));
	std::lock_guard lock(running_scripts_mtx);
	if (ok)
	{
		running_scripts.emplace_back(scr);
	}
	broadcast_running_scripts_locked();
}

void start_script_from_string(const std::string& code)
{
	auto scr = new owfScript();
	bool ok = scr->loadString(code, code);
	std::lock_guard lock(running_scripts_mtx);
	if (ok)
	{
		running_scripts.emplace_back(scr);
	}
	broadcast_running_scripts_locked();
}

JsonArray get_available_scripts()
{
	JsonArray arr;
	for (auto& file : std::filesystem::recursive_directory_iterator(ObfusString("OpenWF/Scripts").str()))
	{
		if (std::filesystem::is_regular_file(file))
		{
			auto name = string::fixType(file.path().u8string()).substr(15);
			soup::string::replaceAll(name, '\\', '/');
			arr.children.emplace_back(soup::make_unique<JsonString>(std::move(name)));
		}
	}
	return arr;
}
