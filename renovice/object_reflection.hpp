#pragma once
// OBJECT_REFLECTION_V1 (2026-10-31): native provider of RENOVICE.object.
// Engine functions are located per build from the Metadata Patches signature
// and engine writer call sites (object_reflection_core.hpp resolve()); an
// unresolved build makes only RENOVICE.object unavailable, with the exact reason.
// Every operation runs the engine's own archive code on the calling thread;
// the Lua layer (injection.cpp) admits only the captured DE VM owner thread.
#include "object_reflection_core.hpp"

#include <string>
#include <string_view>
#include <vector>

namespace renovice::object_reflection
{
// Called once at startup, before the Metadata Patches callsite hook rewrites
// the text-load call the resolver reads.
void initialise() noexcept;
bool available() noexcept;
// Stable text: "" when available, otherwise "<reason>[ <detail>]".
const char* unavailable_reason() noexcept;

struct FieldInfo
{
	std::string name;   // engine text key (normalised)
	FieldType type = FieldType::other;
	bool writable = false;
	std::uintptr_t pointer = 0;
};

// reason == nullptr: success. reason/detail are bounded ASCII.
struct Outcome
{
	const char* reason = nullptr;
	std::string detail;
};

Outcome fields(void* object, std::vector<FieldInfo>& output);
// value.kind: number / boolean for scalar fields (raw field memory),
// string for symbol and composite fields (engine dump text).
Outcome get(void* object, std::string_view key, LuaScalar& value);
Outcome dump(void* object, std::string& text);
Outcome apply(void* object, std::string_view text, std::vector<std::string>& changed);
Outcome set(void* object, std::string_view key, const LuaScalar& value, std::vector<std::string>& changed);
}
