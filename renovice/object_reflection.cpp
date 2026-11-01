#include "object_reflection.hpp"

#include "config.hpp"
#include <base.hpp>
#include "../owf_structs.hpp"
#include "diagnostic_read_probe.hpp"

#include <atomic>
#include <cstdlib>
#include <cstring>
#include <malloc.h>
#include <string>
#include <vector>

#include <winsock2.h>
#include <windows.h>

// OBJECT_REFLECTION_V1 (2026-10-31). See object_reflection_core.hpp for the
// engine contract and RESEARCH/OBJECT_REFLECTION_V1_2026-10-31.md for evidence.
//
// Enumeration route (chosen over a fake visitor): the engine's own TEXT WRITER
// runs the object's field-visit virtual exactly as engine dump sites do
// (ctor, begin, ApplyArchive(obj, writer, 1), end, dtor). A private COPY of the
// writer vtable is installed on our writer instance only; six entries (name
// slot and the five scalar slots) are wrappers that record (name, slot, field
// pointer, caller) and then call the original slot with the same arguments.
// Every other slot is the engine's own function, so composite fields, arrays
// and custom serialisers run unchanged, and nothing is ever written to the
// object (writer mode). A fake visitor would have to emulate the return values
// of 49 slots, including the "reading mode" byte and node-presence queries that
// composite helpers branch on (helper 0x1415d3250 resizes arrays in reading
// mode) - rejected as the less safe route.

namespace renovice::object_reflection
{
namespace
{
using ReaderCtor = void* (*)(void*);
using TextLoad = void (*)(void*, GameString*, int, char);
using ApplyArchive = void (*)(void*, void*, bool);
using ArchiveStep = void (*)(void*);
using WriterCtor = void* (*)(void*, int);
using SlotFunction = std::uint64_t (*)(void*, void*, void*, void*);

Resolution resolved;
std::atomic_bool ready = false;
std::string unavailable_text = "not-initialised";

// Recording vtable (process-owned, built once at startup, never freed).
constexpr std::size_t recording_vtable_capacity = 128;
void* recording_vtable[recording_vtable_capacity]{};
enum RecordedSlot : std::size_t { slot_name, slot_float, slot_bool, slot_int32, slot_int_wide, slot_symbol, slot_count };
SlotFunction original_slots[slot_count]{};
std::uint32_t recorded_slot_offsets[slot_count]{};

struct RecordedField
{
	std::string name;
	std::uintptr_t container = 0;
	std::uintptr_t name_return = 0;
	FieldType type = FieldType::other;
	std::uintptr_t pointer = 0;
	bool bound = false;
};

struct Probe
{
	void* writer = nullptr;
	std::uintptr_t root = 0;
	std::vector<RecordedField> calls;
	bool overflow = false;
};
constexpr std::size_t probe_call_limit = 8192;
thread_local Probe* active_probe = nullptr;
thread_local bool operation_active = false;

// Bounded operational logging (Verbose for calls, Logging for failures).
std::atomic<std::uint32_t> call_lines = 0, failure_lines = 0;
constexpr std::uint32_t call_line_limit = 64, failure_line_limit = 32;

bool readable(const void* address, std::size_t size) noexcept
{
	return address != nullptr && !diagnostics::bad_read_ptr(address, size);
}

std::string bounded_c_string(const char* text, std::size_t maximum)
{
	std::string out;
	for (std::size_t i = 0; i != maximum; ++i)
	{
		if (!readable(text + i, 1) || text[i] == '\0') break;
		out.push_back(text[i]);
	}
	return out;
}

std::string read_name_record(const void* record)
{
	if (!readable(record, 16)) return {};
	std::uint64_t head = 0;
	const char* text = nullptr;
	std::memcpy(&head, record, 8);
	std::memcpy(&text, static_cast<const std::uint8_t*>(record) + 8, 8);
	if ((head >> 63) != 0)
	{
		// Not normalised yet: raw C string (the engine normalises it in place
		// inside the slot we are about to call).
		const auto raw = bounded_c_string(text, 256);
		return (head & name_record_tag_mask) == name_record_raw_tag ? normalise_field_name(raw) : raw;
	}
	if (head == 0 || head > 256 || !readable(text, static_cast<std::size_t>(head))) return {};
	return std::string(text, static_cast<std::size_t>(head));
}

void record_name(void* self, void* record, std::uintptr_t return_address) noexcept
{
	auto* probe = active_probe;
	if (probe == nullptr || probe->writer != self) return;
	try
	{
		if (probe->calls.size() >= probe_call_limit) { probe->overflow = true; return; }
		RecordedField field;
		field.name = read_name_record(record);
		const auto* node = static_cast<const std::uint8_t*>(self) + resolved.writer_current_node;
		if (readable(node, sizeof(std::uintptr_t))) std::memcpy(&field.container, node, sizeof(std::uintptr_t));
		field.name_return = return_address;
		// begin() normally sets the root node; if it did not, the first name
		// visited (the base class's first field) defines the root container.
		if (probe->root == 0 && probe->calls.empty()) probe->root = field.container;
		probe->calls.push_back(std::move(field));
	}
	catch (...)
	{
		probe->overflow = true;
	}
}

void record_typed(void* self, std::size_t kind, void* field_pointer, std::uintptr_t return_address) noexcept
{
	auto* probe = active_probe;
	if (probe == nullptr || probe->writer != self || probe->calls.empty()) return;
	auto& last = probe->calls.back();
	if (last.bound || last.container != probe->root
		|| !typed_call_follows_name(last.name_return, return_address)) return;
	const auto* before = reinterpret_cast<const std::uint8_t*>(return_address);
	if (!readable(before - 8, 8) || !call_site_encodes_slot(before, 8, recorded_slot_offsets[kind])) return;
	last.bound = true;
	last.pointer = reinterpret_cast<std::uintptr_t>(field_pointer);
	last.type = classify_slot(resolved.slots, recorded_slot_offsets[kind]);
}

template<std::size_t Kind>
std::uint64_t recording_slot(void* self, void* a, void* b, void* c)
{
	const auto return_address = reinterpret_cast<std::uintptr_t>(__builtin_return_address(0));
	if constexpr (Kind == slot_name) record_name(self, a, return_address);
	else record_typed(self, Kind, a, return_address);
	return original_slots[Kind](self, a, b, c);
}

bool build_recording_vtable() noexcept
{
	const auto count = resolved.writer_vtable_slots;
	if (count == 0 || count > recording_vtable_capacity) return false;
	const auto* engine = reinterpret_cast<void* const*>(resolved.writer_vtable);
	for (std::uint32_t i = 0; i != count; ++i) recording_vtable[i] = engine[i];
	const std::uint32_t offsets[slot_count]{resolved.slots.name, resolved.slots.float32, resolved.slots.boolean,
		resolved.slots.int32, resolved.slots.int_wide, resolved.slots.symbol};
	void* const wrappers[slot_count]{
		reinterpret_cast<void*>(&recording_slot<slot_name>), reinterpret_cast<void*>(&recording_slot<slot_float>),
		reinterpret_cast<void*>(&recording_slot<slot_bool>), reinterpret_cast<void*>(&recording_slot<slot_int32>),
		reinterpret_cast<void*>(&recording_slot<slot_int_wide>), reinterpret_cast<void*>(&recording_slot<slot_symbol>)};
	for (std::size_t k = 0; k != slot_count; ++k)
	{
		const auto index = offsets[k] / 8;
		if (offsets[k] % 8 != 0 || index >= count) return false;
		original_slots[k] = reinterpret_cast<SlotFunction>(engine[index]);
		recorded_slot_offsets[k] = offsets[k];
		recording_vtable[index] = wrappers[k];
	}
	return true;
}

std::string hex(std::uint64_t value)
{
	char buffer[32]{};
	std::snprintf(buffer, sizeof(buffer), "0x%llx", static_cast<unsigned long long>(value));
	return buffer;
}

// --------------------------------------------------------- object validation

const char* validate_object(void* object, const ImageView& image) noexcept
{
	if (object == nullptr) return "object-null";
	if (!readable(object, 0x28)) return "object-unreadable";
	std::uint64_t vtable = 0;
	std::memcpy(&vtable, object, 8);
	if (!image.in_readonly_data(vtable) || !readable(reinterpret_cast<void*>(vtable), object_field_visit_slot + 8))
		return "object-vtable-not-in-game-image";
	std::uint64_t visit = 0;
	std::memcpy(&visit, reinterpret_cast<const void*>(vtable + object_field_visit_slot), 8);
	if (!image.in_executable(visit)) return "object-field-visit-not-in-game-code";
	// ApplyArchive reads object+0x08 (type record and its parents), object+0x10
	// (self pointer, dereferenced with lock=true), object+0x1c and object+0x24.
	const auto* raw = static_cast<const std::uint8_t*>(object);
	std::uintptr_t type = 0, self = 0;
	std::memcpy(&type, raw + 0x08, 8);
	std::memcpy(&self, raw + 0x10, 8);
	if (self == 0 || !readable(reinterpret_cast<void*>(self), 8)) return "object-self-pointer-invalid";
	for (int depth = 0; type != 0; ++depth)
	{
		if (depth == 64 || !readable(reinterpret_cast<void*>(type), 0x30)) return "object-type-record-invalid";
		std::uint64_t type_vtable = 0;
		std::memcpy(&type_vtable, reinterpret_cast<const void*>(type), 8);
		if (depth == 0 && !image.in_readonly_data(type_vtable)) return "object-type-record-invalid";
		std::uintptr_t path = 0;
		std::memcpy(&path, reinterpret_cast<const std::uint8_t*>(type) + 0x10, 8);
		if (path != 0 && !readable(reinterpret_cast<void*>(path), 4)) return "object-type-record-invalid";
		std::memcpy(&type, reinterpret_cast<const std::uint8_t*>(type) + 0x18, 8);
	}
	std::memcpy(&type, raw + 0x08, 8);
	if (type == 0) return "object-type-record-invalid";
	return nullptr;
}

ImageView running_image;

// ------------------------------------------------------------- engine runs

struct Block
{
	std::uint8_t* bytes = nullptr;
	explicit Block(std::size_t size) noexcept
	{
		bytes = static_cast<std::uint8_t*>(_aligned_malloc(size, 64));
		if (bytes != nullptr) std::memset(bytes, 0, size);
	}
	~Block() { if (bytes != nullptr) _aligned_free(bytes); }
	Block(const Block&) = delete;
	Block& operator=(const Block&) = delete;
};

bool read_game_string(const std::uint8_t* address, std::string& out)
{
	if (!readable(address, 16)) return false;
	GameString value{};
	std::memcpy(&value, address, 16);
	const std::size_t length = value.getSize();
	const char* data = value.isLong() ? value.lng.ptr : reinterpret_cast<const char*>(address);
	if (length > (16u << 20) || (length != 0 && !readable(data, length))) return false;
	out.assign(data, length);
	return true;
}

// Writer run: ctor, begin, ApplyArchive(obj, w, 1), end, dtor. With a probe,
// the recording vtable is installed between begin and end only.
Outcome run_writer(void* object, std::string& text, Probe* probe)
{
	Block block(archive_block_size(resolved.writer_frame_size));
	if (block.bytes == nullptr) return {"allocation-failed", {}};
	void* writer = block.bytes;
	reinterpret_cast<WriterCtor>(resolved.writer_ctor)(writer, writer_flags);
	reinterpret_cast<ArchiveStep>(resolved.writer_begin)(writer);
	void* engine_vtable = nullptr;
	if (probe != nullptr)
	{
		std::memcpy(&engine_vtable, writer, 8);
		if (reinterpret_cast<std::uint64_t>(engine_vtable) != resolved.writer_vtable)
		{
			reinterpret_cast<ArchiveStep>(resolved.writer_end)(writer);
			reinterpret_cast<ArchiveStep>(resolved.writer_dtor)(writer);
			return {"writer-vtable-mismatch", {}};
		}
		probe->writer = writer;
		std::memcpy(&probe->root, block.bytes + resolved.writer_current_node, sizeof(std::uintptr_t));
		void* recording = recording_vtable;
		std::memcpy(writer, &recording, 8);
		active_probe = probe;
	}
	reinterpret_cast<ApplyArchive>(resolved.apply)(object, writer, true);
	if (probe != nullptr)
	{
		active_probe = nullptr;
		std::memcpy(writer, &engine_vtable, 8);
	}
	reinterpret_cast<ArchiveStep>(resolved.writer_end)(writer);
	const std::uint8_t error_flag = block.bytes[resolved.writer_output + 0x10];
	Outcome outcome;
	if (error_flag != 0) outcome = {"engine-writer-error", "flag=" + std::to_string(error_flag)};
	else if (!read_game_string(block.bytes + resolved.writer_output, text)) outcome = {"writer-text-unreadable", {}};
	reinterpret_cast<ArchiveStep>(resolved.writer_dtor)(writer);
	if (outcome.reason == nullptr && probe != nullptr && probe->overflow) outcome = {"probe-call-limit", {}};
	return outcome;
}

// Reader run: the metadata apply path (ctor, load text, post-load flag,
// ApplyArchive(obj, r, 1), status, dtor).
Outcome run_reader(void* object, std::string_view text, std::uint8_t& status)
{
	Block block(archive_block_size(resolved.reader_frame_size));
	if (block.bytes == nullptr) return {"allocation-failed", {}};
	std::string owned(text);
	void* reader = block.bytes;
	reinterpret_cast<ReaderCtor>(resolved.reader_ctor)(reader);
	GameString source{};
	source.setUnownedData(owned.c_str(), owned.size());
	reinterpret_cast<TextLoad>(resolved.text_load)(reader, &source, 0, 3);
	block.bytes[resolved.reader_post_load_flag] = 0;
	reinterpret_cast<ApplyArchive>(resolved.apply)(object, reader, true);
	status = block.bytes[resolved.reader_status];
	reinterpret_cast<ArchiveStep>(resolved.reader_dtor)(reader);
	return {};
}

struct Snapshot
{
	std::string text;
	std::vector<FieldInfo> fields;
};

Outcome probe_object(void* object, Snapshot& snapshot)
{
	Probe probe;
	auto outcome = run_writer(object, snapshot.text, &probe);
	if (outcome.reason != nullptr) return outcome;
	for (const auto& call : probe.calls)
	{
		if (call.container != probe.root || call.name.empty()) continue;
		const bool duplicate = std::any_of(snapshot.fields.begin(), snapshot.fields.end(),
			[&](const FieldInfo& field) { return field.name == call.name; });
		if (duplicate) continue;
		FieldInfo field;
		field.name = call.name;
		field.type = call.bound ? call.type : FieldType::other;
		field.writable = field_type_writable(field.type);
		field.pointer = call.pointer;
		snapshot.fields.push_back(std::move(field));
	}
	return {};
}

const FieldInfo* find_field(const std::vector<FieldInfo>& fields, std::string_view name) noexcept
{
	for (const auto& field : fields)
		if (field.name == name) return &field;
	return nullptr;
}

bool read_scalar(const FieldInfo& field, LuaScalar& value) noexcept
{
	const auto* pointer = reinterpret_cast<const std::uint8_t*>(field.pointer);
	switch (field.type)
	{
	case FieldType::float32:
	{
		float number = 0;
		if (!readable(pointer, 4)) return false;
		std::memcpy(&number, pointer, 4);
		value.kind = LuaScalar::Kind::number;
		value.number = number;
		return true;
	}
	case FieldType::boolean:
		if (!readable(pointer, 1)) return false;
		value.kind = LuaScalar::Kind::boolean;
		value.boolean = *pointer != 0;
		return true;
	case FieldType::int32:
	case FieldType::int_wide:
	{
		// The widening slot stores the int32 result zero-extended (or -1 as all
		// ones); the low dword is the engine value in both cases.
		std::int32_t number = 0;
		if (!readable(pointer, 4)) return false;
		std::memcpy(&number, pointer, 4);
		value.kind = LuaScalar::Kind::number;
		value.number = number;
		return true;
	}
	default:
		return false;
	}
}

// Precondition shared by every public operation.
const char* admit(void* object) noexcept
{
	if (!ready.load(std::memory_order_acquire)) return "capability-unavailable";
	if (operation_active) return "reentrant-call";
	return validate_object(object, running_image);
}

struct OperationScope
{
	OperationScope() noexcept { operation_active = true; }
	~OperationScope() { operation_active = false; }
	OperationScope(const OperationScope&) = delete;
	OperationScope& operator=(const OperationScope&) = delete;
};

void report(const char* operation, std::string_view field, const Outcome& outcome, std::size_t changed)
{
	if (outcome.reason == nullptr)
	{
		if (!config::verbose_enabled()) return;
		const auto line = call_lines.fetch_add(1, std::memory_order_relaxed);
		if (line > call_line_limit) return;
		if (line == call_line_limit)
		{
			config::verbose("RENOVICE OBJECT_REFLECTION CALL SUPPRESSED limit=" + std::to_string(call_line_limit));
			return;
		}
		config::verbose(std::string("RENOVICE OBJECT_REFLECTION CALL PASS op=") + operation
			+ (field.empty() ? std::string() : " field=" + std::string(field))
			+ " changed=" + std::to_string(changed));
		return;
	}
	const auto line = failure_lines.fetch_add(1, std::memory_order_relaxed);
	if (line > failure_line_limit) return;
	if (line == failure_line_limit)
	{
		config::info("RENOVICE OBJECT_REFLECTION CALL FAIL SUPPRESSED limit=" + std::to_string(failure_line_limit));
		return;
	}
	config::info(std::string("RENOVICE OBJECT_REFLECTION CALL FAIL op=") + operation
		+ (field.empty() ? std::string() : " field=" + std::string(field))
		+ " reason=" + outcome.reason + (outcome.detail.empty() ? std::string() : " " + outcome.detail));
}
}

void initialise() noexcept
{
	try
	{
		auto* module = reinterpret_cast<const std::uint8_t*>(GetModuleHandleW(nullptr));
		if (module == nullptr) { unavailable_text = "game-module-unavailable"; return; }
		const auto* dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(module);
		const auto* nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(module + dos->e_lfanew);
		running_image.base = reinterpret_cast<std::uint64_t>(module);
		running_image.bytes = module;
		running_image.size = nt->OptionalHeader.SizeOfImage;
		if (!parse_sections(running_image))
		{
			unavailable_text = "game-image-headers";
		}
		else
		{
			resolved = resolve(running_image);
			if (resolved.reason != nullptr)
				unavailable_text = std::string(resolved.reason) + (resolved.detail.empty() ? "" : " " + resolved.detail);
			else if (!build_recording_vtable())
				unavailable_text = "recording-vtable";
			else
				unavailable_text.clear();
		}
		if (!unavailable_text.empty())
		{
			config::error("RENOVICE OBJECT_REFLECTION FAIL reason=" + unavailable_text
				+ " scope=capability-local (only RENOVICE.object is unavailable)");
			return;
		}
		ready.store(true, std::memory_order_release);
		const auto rva = [&](std::uint64_t va) { return hex(va - running_image.base); };
		config::info("RENOVICE OBJECT_REFLECTION PASS version=1 route=engine-text-writer+metadata-reader"
			" site=+" + rva(resolved.metadata_site)
			+ " reader_ctor=+" + rva(resolved.reader_ctor) + " text_load=+" + rva(resolved.text_load)
			+ " apply=+" + rva(resolved.apply) + " reader_dtor=+" + rva(resolved.reader_dtor)
			+ " writer_ctor=+" + rva(resolved.writer_ctor) + " writer_begin=+" + rva(resolved.writer_begin)
			+ " writer_end=+" + rva(resolved.writer_end) + " writer_dtor=+" + rva(resolved.writer_dtor)
			+ " writer_sites=" + std::to_string(resolved.writer_sites)
			+ " writer_slots=" + std::to_string(resolved.writer_vtable_slots));
	}
	catch (...)
	{
		unavailable_text = "native-exception";
		config::error("RENOVICE OBJECT_REFLECTION FAIL reason=native-exception scope=capability-local");
	}
}

bool available() noexcept
{
	return ready.load(std::memory_order_acquire);
}

const char* unavailable_reason() noexcept
{
	return ready.load(std::memory_order_acquire) ? "" : unavailable_text.c_str();
}

Outcome fields(void* object, std::vector<FieldInfo>& output)
{
	output.clear();
	if (const auto reason = admit(object)) return {reason, {}};
	OperationScope scope;
	Snapshot snapshot;
	auto outcome = probe_object(object, snapshot);
	if (outcome.reason == nullptr) output = std::move(snapshot.fields);
	report("fields", {}, outcome, 0);
	return outcome;
}

Outcome get(void* object, std::string_view key, LuaScalar& value)
{
	value = {};
	const auto name = normalise_lua_key(key);
	if (!valid_field_key(name)) return {"field-name-invalid", {}};
	if (const auto reason = admit(object)) return {reason, {}};
	OperationScope scope;
	Snapshot snapshot;
	auto outcome = probe_object(object, snapshot);
	if (outcome.reason == nullptr)
	{
		const auto* field = find_field(snapshot.fields, name);
		if (field == nullptr) outcome = {"field-not-found", {}};
		else if (field->type == FieldType::symbol || field->type == FieldType::other)
		{
			const auto parsed = parse_top_level(snapshot.text);
			const auto* entry = parsed.reason == nullptr ? find_entry(parsed.entries, name) : nullptr;
			if (parsed.reason != nullptr) outcome = {parsed.reason, {}};
			else if (entry == nullptr) outcome = {"field-not-in-dump", {}};
			else
			{
				value.kind = LuaScalar::Kind::string;
				value.text = field->type == FieldType::symbol ? unquote(entry->value) : entry->value;
			}
		}
		else if (!read_scalar(*field, value)) outcome = {"field-unreadable", {}};
	}
	report("get", name, outcome, 0);
	return outcome;
}

Outcome dump(void* object, std::string& text)
{
	text.clear();
	if (const auto reason = admit(object)) return {reason, {}};
	OperationScope scope;
	auto outcome = run_writer(object, text, nullptr);
	report("dump", {}, outcome, 0);
	return outcome;
}

namespace
{
Outcome apply_text(void* object, std::string_view text, std::vector<std::string>& changed)
{
	std::string before, after;
	auto outcome = run_writer(object, before, nullptr);
	if (outcome.reason != nullptr) return outcome;
	std::uint8_t status = 0;
	outcome = run_reader(object, text, status);
	if (outcome.reason != nullptr) return outcome;
	outcome = run_writer(object, after, nullptr);
	if (outcome.reason != nullptr) return outcome;
	const auto parsed_before = parse_top_level(before);
	const auto parsed_after = parse_top_level(after);
	if (parsed_before.reason != nullptr || parsed_after.reason != nullptr)
		return {"dump-text-unbalanced", {}};
	changed = changed_names(parsed_before.entries, parsed_after.entries);
	if (status == resolved.reader_error_status)
		return {"engine-reader-error", "status=" + std::to_string(status) + " changed=" + std::to_string(changed.size())};
	return {};
}
}

Outcome apply(void* object, std::string_view text, std::vector<std::string>& changed)
{
	changed.clear();
	if (const auto reason = validate_apply_text(text)) return {reason, {}};
	if (const auto reason = admit(object)) return {reason, {}};
	OperationScope scope;
	auto outcome = apply_text(object, text, changed);
	report("apply", {}, outcome, changed.size());
	return outcome;
}

Outcome set(void* object, std::string_view key, const LuaScalar& value, std::vector<std::string>& changed)
{
	changed.clear();
	const auto name = normalise_lua_key(key);
	if (!valid_field_key(name)) return {"field-name-invalid", {}};
	if (const auto reason = admit(object)) return {reason, {}};
	OperationScope scope;
	Snapshot snapshot;
	auto outcome = probe_object(object, snapshot);
	const FieldInfo* field = nullptr;
	if (outcome.reason == nullptr)
	{
		field = find_field(snapshot.fields, name);
		if (field == nullptr) outcome = {"field-not-found", {}};
		else if (!field->writable) outcome = {"field-type-not-writable", field_type_label(field->type)};
	}
	Formatted formatted;
	if (outcome.reason == nullptr)
	{
		formatted = format_value(field->type, value);
		if (formatted.reason != nullptr) outcome = {formatted.reason, {}};
	}
	if (outcome.reason == nullptr)
	{
		outcome = apply_text(object, name + "=" + formatted.text + "\n", changed);
		// Scalar fields: the field memory must now hold the requested value.
		LuaScalar now;
		if (outcome.reason == nullptr && field->type != FieldType::symbol && read_scalar(*field, now))
		{
			bool equal = false;
			if (field->type == FieldType::boolean) equal = now.boolean == value.boolean;
			else if (field->type == FieldType::float32)
				equal = static_cast<float>(now.number) == static_cast<float>(value.number);
			else equal = now.number == value.number;
			if (!equal) outcome = {"field-not-applied", "text=" + formatted.text};
		}
	}
	report("set", name, outcome, changed.size());
	return outcome;
}
}
