#include <iostream>
#include <string_view>

#include "../../renovice/riven_core.hpp"

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
	using namespace renovice::riven;
	unsigned index = 99;
	check(parse_lock_href("#onHyperlinkPressed:lock0", index) && index == 0, "exact lock href parsed");
	check(parse_lock_href("#onHyperlinkPressed:lock31", index) && index == 31, "highest lock bit parsed");
	check(!parse_lock_href("#onHyperlinkPressed:lock32", index), "out-of-range lock rejected");
	check(!parse_lock_href("otherlock1", index), "unrelated lock substring rejected");
	check(looks_like_riven_stats("+123.4% Damage\r\n-22.0% Zoom"), "riven stat description accepted");
	check(!looks_like_riven_stats("+50% Ability Strength"), "warframe mod excluded");
	const auto wrapped = build_wrap("+10% Damage\r\n-5% Zoom", 2);
	check(wrapped.find("lock0") != std::string::npos && wrapped.find("#A785C9") != std::string::npos,
		"unlocked stat is linked purple");
	check(wrapped.find("lock1") != std::string::npos && wrapped.find("#FF0000") != std::string::npos,
		"locked stat is linked red");
	check(locked_indices_json((1u << 0) | (1u << 2) | (1u << 31))
		== "{\"indices\":[0,2,31]}", "server JSON is deterministic");
	std::cout << "RIVEN CORE RESULT failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
