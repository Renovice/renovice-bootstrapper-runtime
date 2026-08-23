#include <array>
#include <cstring>
#include <iostream>
#include <string_view>

#include "../../renovice/swf_core.hpp"

namespace
{
int failures = 0;
void check(bool condition, std::string_view label)
{
	std::cout << (condition ? "PASS\t" : "FAIL\t") << label << '\n';
	if (!condition) ++failures;
}
}

int main()
{
	using namespace renovice::swf;
	std::array<unsigned char, 12> fws{'F','W','S', 10, 12,0,0,0, 1,2,3,4};
	check(valid_replacement(fws), "bounded FWS with exact FileLength accepted");
	fws[4] = 11;
	check(!valid_replacement(fws), "mismatched FileLength rejected");
	fws[0] = 'C'; fws[4] = 12;
	check(!valid_replacement(fws), "compressed replacement rejected at parser overlay boundary");

	std::uint64_t parsed = 0;
	check(parse_key("0123456789abcdef (Riven UI)", parsed)
		&& parsed == 0x0123456789abcdefULL, "annotated content key parsed");

	std::array<unsigned char, 64> toc{};
	const std::uint64_t cache_offset = 0x87fbe03ULL;
	const std::uint32_t compressed = 5545;
	const std::uint32_t decompressed = 28704;
	std::memcpy(toc.data() + 8, &cache_offset, sizeof(cache_offset));
	std::memcpy(toc.data() + 24, &compressed, sizeof(compressed));
	std::memcpy(toc.data() + 28, &decompressed, sizeof(decompressed));
	TocRule rule{cache_offset, compressed, decompressed, 40000};
	check(patch_toc_buffer(toc, rule), "matching TOC entry patched");
	check(little_u32(toc.data() + 28) == 40000, "TOC capacity becomes replacement capacity");
	check(!patch_toc_buffer(toc, rule), "already-patched entry is idempotent");

	auto unrelated = toc;
	std::fill(unrelated.begin(), unrelated.end(), static_cast<unsigned char>(0));
	check(!patch_toc_buffer(unrelated, rule), "unrelated read remains unchanged");
	check(!patch_toc_buffer(toc, TocRule{cache_offset, compressed, decompressed, decompressed}),
		"non-growing rule cannot patch");

	std::cout << "SWF CORE RESULT failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
