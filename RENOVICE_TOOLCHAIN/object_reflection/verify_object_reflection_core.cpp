// OBJECT_REFLECTION_V1 offline gate (2026-10-31): the pure core of RENOVICE.object.
//   verify_object_reflection_core.exe [<client.exe> ...]
// Every client image is READ only (mapped into memory by RVA). For each image
// the exact runtime resolver runs and prints one RESOLVED line that the Python
// exe gate cross-checks with an independent capstone decode.
#include "../../renovice/object_reflection_core.hpp"

#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <iterator>
#include <limits>
#include <string>
#include <vector>

using namespace renovice::object_reflection;

namespace
{
int failures = 0;

void check(bool condition, const std::string& message)
{
	std::cout << (condition ? "PASS\t" : "FAIL\t") << message << '\n';
	if (!condition) ++failures;
}

std::string hex(std::uint64_t value)
{
	char buffer[32]{};
	std::snprintf(buffer, sizeof(buffer), "0x%llx", static_cast<unsigned long long>(value));
	return buffer;
}

LuaScalar number(double value) { LuaScalar s; s.kind = LuaScalar::Kind::number; s.number = value; return s; }
LuaScalar boolean(bool value) { LuaScalar s; s.kind = LuaScalar::Kind::boolean; s.boolean = value; return s; }
LuaScalar text(const char* value) { LuaScalar s; s.kind = LuaScalar::Kind::string; s.text = value; return s; }

void names()
{
	// Engine normaliser rule (0x1413dbd90 on 44.1.3).
	check(normalise_field_name("mHardMaxAICap") == "HardMaxAICap", "name: m + uppercase drops the m (mHardMaxAICap -> HardMaxAICap)");
	check(normalise_field_name("HardMaxAICap") == "HardMaxAICap", "name: metadata spelling is unchanged");
	check(normalise_field_name("sInstance") == "Instance" && normalise_field_name("gValue") == "Value", "name: s/g + uppercase prefixes drop too");
	check(normalise_field_name("mbFlag") == "mbFlag" && normalise_field_name("m") == "m" && normalise_field_name("mx") == "mx", "name: m + non-uppercase is kept");
	check(normalise_field_name("this->mSpawnTimer") == "SpawnTimer" && normalise_field_name("a.b.mX") == "X", "name: qualifier up to the last '.' or '>' is dropped");
	check(normalise_field_name("Spawn.Timer") == "Timer", "name: a dot inside the name is a qualifier (engine rule)");
	check(valid_field_key("HardMaxAICap") && !valid_field_key("") && !valid_field_key("A=B")
		&& !valid_field_key("A\nB") && !valid_field_key("A{") && !valid_field_key(std::string(129, 'a')),
		"key: only [A-Za-z0-9_]{1,128} (no line, '=' or brace injection)");
	check(normalise_lua_key("mSpawnTimer") == "SpawnTimer", "key: Lua may pass the engine member spelling");
}

void values()
{
	check(format_value(FieldType::float32, number(0.5)).text == "0.5", "value: float 0.5");
	check(format_value(FieldType::float32, number(60)).text == "60", "value: float 60");
	const auto tenth = format_value(FieldType::float32, number(static_cast<float>(0.1)));
	check(tenth.reason == nullptr && static_cast<float>(std::strtod(tenth.text.c_str(), nullptr)) == static_cast<float>(0.1),
		"value: float text round-trips the 32-bit value (" + tenth.text + ")");
	check(format_value(FieldType::float32, number(std::numeric_limits<double>::infinity())).reason != nullptr
		&& format_value(FieldType::float32, number(1e39)).reason != nullptr, "value: float infinity / beyond float range rejected");
	check(format_value(FieldType::float32, boolean(true)).reason != nullptr, "value: float from boolean rejected");
	check(format_value(FieldType::int32, number(60)).text == "60" && format_value(FieldType::int_wide, number(-5)).text == "-5", "value: int");
	check(format_value(FieldType::int32, number(1.5)).reason != nullptr, "value: int from non-integer rejected");
	check(format_value(FieldType::int32, number(4294967296.0)).reason != nullptr, "value: int out of int32 range rejected");
	check(format_value(FieldType::boolean, boolean(true)).text == "1" && format_value(FieldType::boolean, boolean(false)).text == "0",
		"value: bool is 1/0 (writer bool slot writes '0'+value; reader parses an integer)");
	check(format_value(FieldType::boolean, number(1)).reason != nullptr, "value: bool from number rejected");
	check(format_value(FieldType::symbol, text("Grineer")).text == "\"Grineer\"", "value: symbol is quoted (writer symbol slot quotes)");
	check(format_value(FieldType::symbol, text("a\"b")).reason != nullptr && format_value(FieldType::symbol, text("a\nB=1")).reason != nullptr,
		"value: symbol with quote/newline/'=' rejected");
	check(format_value(FieldType::other, number(1)).reason != nullptr, "value: composite fields are not writable");
	check(validate_apply_text("A=1") == nullptr && validate_apply_text("") != nullptr
		&& validate_apply_text(std::string(apply_text_limit + 1, 'a')) != nullptr
		&& validate_apply_text(std::string("A=1\0B", 5)) != nullptr, "apply text: non-empty, <= 64 KiB, no NUL");
}

void parser()
{
	const char* dump =
		"SpawnTimer=0.5\n"
		"HardMaxAICap=60\n"
		"Faction=\"Grineer\"\n"
		"Waves={\n"
		"Count=3\n"
		"List={1,2,3}\n"
		"}\n"
		"Name=\"a=b {x}\"\r\n"
		"Flag=1";
	const auto parsed = parse_top_level(dump);
	check(parsed.reason == nullptr && parsed.entries.size() == 6, "parse: 6 depth-0 entries");
	check(find_entry(parsed.entries, "SpawnTimer") && find_entry(parsed.entries, "SpawnTimer")->value == "0.5", "parse: scalar");
	check(find_entry(parsed.entries, "Count") == nullptr, "parse: nested keys are not top-level");
	check(find_entry(parsed.entries, "Waves") && find_entry(parsed.entries, "Waves")->value.find("List={1,2,3}") != std::string::npos, "parse: nested value kept as raw text");
	check(find_entry(parsed.entries, "Name") && unquote(find_entry(parsed.entries, "Name")->value) == "a=b {x}", "parse: quoted string with '=' and braces");
	check(find_entry(parsed.entries, "Flag") && find_entry(parsed.entries, "Flag")->value == "1", "parse: last line without newline");
	check(parse_top_level("A={\nB=1\n").reason != nullptr && parse_top_level("A=1\n}\n").reason != nullptr, "parse: unbalanced text rejected");
	const auto after = parse_top_level("SpawnTimer=0.25\nHardMaxAICap=60\nFaction=\"Grineer\"\nFlag=1\nNew=2\n");
	const auto changed = changed_names(parsed.entries, after.entries);
	check(changed.size() == 4 && changed[0] == "SpawnTimer" && changed[1] == "New" && changed[2] == "Waves" && changed[3] == "Name",
		"diff: changed, added, then removed names");
}

void association()
{
	// call [rax+0x138] = FF 90 38 01 00 00; call [r8+0x108] = 41 FF 90 08 01 00 00; call [rax+0x50] = FF 50 50.
	const std::uint8_t name_call[]{0xFF, 0x90, 0x38, 0x01, 0x00, 0x00};
	const std::uint8_t wide_inner[]{0x41, 0xFF, 0x90, 0x08, 0x01, 0x00, 0x00};
	const std::uint8_t short_call[]{0xFF, 0x50, 0x50};
	check(call_site_encodes_slot(name_call + 6, 6, 0x138) && !call_site_encodes_slot(name_call + 6, 6, 0xc0), "association: disp32 virtual call names its slot");
	check(call_site_encodes_slot(wide_inner + 7, 7, 0x108), "association: REX-prefixed call decodes");
	check(call_site_encodes_slot(short_call + 3, 3, 0x50), "association: disp8 virtual call decodes");
	check(typed_call_follows_name(0x1000, 0x1013) && !typed_call_follows_name(0x1000, 0x1000)
		&& !typed_call_follows_name(0x1000, 0x1041) && !typed_call_follows_name(0x2000, 0x1000),
		"association: typed call must follow the name call within 0x40 bytes");
	check(classify_slot(archive_slots_u44, 0xc0) == FieldType::float32 && classify_slot(archive_slots_u44, 0x110) == FieldType::int_wide
		&& classify_slot(archive_slots_u44, 0x148) == FieldType::other, "association: slot classification");
	check(field_type_writable(FieldType::symbol) && !field_type_writable(FieldType::other), "association: composite is read-only");
}

bool read_file(const char* path, std::vector<std::uint8_t>& bytes)
{
	std::ifstream input(path, std::ios::binary);
	if (!input) return false;
	bytes.assign(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>());
	return !bytes.empty();
}

void image(const char* path)
{
	std::vector<std::uint8_t> file, mapped;
	std::uint64_t base = 0;
	if (!read_file(path, file) || !map_file_image(file, mapped, base))
	{
		check(false, std::string("image readable and mappable: ") + path);
		return;
	}
	ImageView view;
	view.base = base;
	view.bytes = mapped.data();
	view.size = mapped.size();
	check(parse_sections(view), std::string("image sections: ") + path);
	const auto r = resolve(view);
	if (r.reason != nullptr)
	{
		check(false, std::string("resolve: ") + path + " reason=" + r.reason + " " + r.detail);
		return;
	}
	check(true, std::string("resolve: ") + path);
	check(r.reader_post_load_flag >= 0 && r.reader_status >= 0 && r.reader_error_status != 0, "resolve: reader post-load flag and status byte");
	check(r.writer_sites >= 2, "resolve: writer sequence agreed by " + std::to_string(r.writer_sites) + " engine sites");
	check(archive_block_size(r.reader_frame_size) >= r.reader_frame_size + 0x1000
		&& archive_block_size(r.writer_frame_size) > static_cast<std::size_t>(r.writer_output) + 0x20,
		"resolve: archive heap blocks exceed every touched offset");
	std::cout << "RESOLVED"
		<< " site=" << hex(r.metadata_site)
		<< " reader_ctor=" << hex(r.reader_ctor) << " reader_vtable=" << hex(r.reader_vtable)
		<< " text_load=" << hex(r.text_load) << " apply=" << hex(r.apply) << " reader_dtor=" << hex(r.reader_dtor)
		<< " post_load_flag=" << hex(static_cast<std::uint64_t>(r.reader_post_load_flag))
		<< " status=" << hex(static_cast<std::uint64_t>(r.reader_status))
		<< " error_status=" << static_cast<int>(r.reader_error_status)
		<< " normaliser=" << hex(r.name_normaliser)
		<< " writer_ctor=" << hex(r.writer_ctor) << " writer_vtable=" << hex(r.writer_vtable)
		<< " writer_slots=" << r.writer_vtable_slots
		<< " writer_begin=" << hex(r.writer_begin) << " writer_end=" << hex(r.writer_end)
		<< " writer_dtor=" << hex(r.writer_dtor)
		<< " writer_output=" << hex(static_cast<std::uint64_t>(r.writer_output))
		<< " writer_flags_offset=" << hex(static_cast<std::uint64_t>(r.writer_flags_offset))
		<< " writer_node=" << hex(static_cast<std::uint64_t>(r.writer_current_node))
		<< " reader_extent=" << hex(r.reader_frame_size) << " writer_extent=" << hex(r.writer_frame_size)
		<< " image=" << path << '\n';
}
}

int main(int argc, char** argv)
{
	names();
	values();
	parser();
	association();
	for (int i = 1; i < argc; ++i) image(argv[i]);
	if (failures != 0)
	{
		std::cout << "OBJECT REFLECTION CORE FAIL failures=" << failures << '\n';
		return 1;
	}
	std::cout << "OBJECT REFLECTION CORE PASS\n";
	return 0;
}
