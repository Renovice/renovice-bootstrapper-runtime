#pragma once
#include <array>
#include <cstdint>
#include <cstring>
#include <unordered_map>
#include <vector>

namespace renovice::injection
{
// U43 executable CCA46D604A498CD95F0D28E3E8F3EEE8833F5D362666A8E5C820C535F7C2AF93.
// Read-only evidence: UNIVERSAL_ADDON_API_REQUIREMENTS_2026-09-07.md.
struct TargetProtoRecord
{
	std::uintptr_t address = 0, parent = 0, code = 0;
	std::int32_t instructions = 0, bytecode_id = 0;
};
struct TargetProtoGraph
{
	std::vector<TargetProtoRecord> records;
	const char* error = nullptr;
	std::uintptr_t error_address = 0;
};
// Construct off the execution path; never publish an incomplete graph.
template <typename Reader>
TargetProtoGraph collect_target_proto_graph_u43(std::uintptr_t root, Reader&& read,
	std::size_t maximum_nodes = 4096, std::size_t maximum_depth = 256)
{
	TargetProtoGraph result;
	std::unordered_map<std::uintptr_t, int> colors;
	std::size_t edges = 0;
	const auto reject = [&](const char* reason, std::uintptr_t address)
	{
		result.error = reason; result.error_address = address; return false;
	};
	const auto visit = [&](auto&& self, std::uintptr_t address,
		std::uintptr_t parent, std::size_t depth) -> bool
	{
		if (address < 0x10000 || address % 8 != 0)
			return reject("invalid-prototype-pointer", address);
		const auto previous = colors.find(address);
		if (previous != colors.end())
			return previous->second == 2 || reject("prototype-cycle", address);
		if (colors.size() >= maximum_nodes || depth >= maximum_depth)
			return reject("prototype-graph-limit", address);
		std::array<unsigned char, 0xb0> bytes{};
		if (!read(address, bytes.data(), bytes.size()))
			return reject("unreadable-prototype", address);
		std::uint64_t children = 0, code = 0;
		std::int32_t count = 0, instructions = 0, bytecode_id = 0;
		std::memcpy(&children, bytes.data() + 0x18, sizeof(children));
		std::memcpy(&code, bytes.data() + 0x10, sizeof(code));
		std::memcpy(&instructions, bytes.data() + 0x88, sizeof(instructions));
		std::memcpy(&count, bytes.data() + 0x8c, sizeof(count));
		std::memcpy(&bytecode_id, bytes.data() + 0xa8, sizeof(bytecode_id));
		if (bytes[0] != 12 || instructions <= 0 || instructions > 1048576
			|| code < 0x10000 || code % 4 != 0 || bytecode_id < 0
			|| count < 0 || static_cast<std::size_t>(count) > maximum_nodes)
			return reject("prototype-layout-mismatch", address);
		if (edges + static_cast<std::size_t>(count) > 16384)
			return reject("prototype-edge-limit", address);
		edges += static_cast<std::size_t>(count);
		std::vector<std::uint64_t> pointers(static_cast<std::size_t>(count));
		if (count != 0 && (children < 0x10000 || children % 8 != 0
			|| !read(children, pointers.data(), pointers.size() * sizeof(std::uint64_t))))
			return reject("unreadable-child-array", address);
		colors.emplace(address, 1);
		result.records.push_back({address, parent, code, instructions, bytecode_id});
		for (const auto child : pointers)
			if (!self(self, child, address, depth + 1)) return false;
		colors[address] = 2;
		return true;
	};
	if (!visit(visit, root, 0, 0)) result.records.clear();
	return result;
}
}
