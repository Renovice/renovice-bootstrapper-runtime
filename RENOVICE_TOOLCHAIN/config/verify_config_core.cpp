#include <iostream>
#include <string_view>

#include "../../renovice/config_core.hpp"

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
	using renovice::config::parse;

	const auto normal = parse(
		"# comment mentioning Logging=true must not enable it\r\n"
		"Logging = YES\r\nVerbose=on\r\nAutoSpawn=1\r\n");
	check(normal.logging, "Logging accepts YES case-insensitively");
	check(normal.verbose, "Verbose accepts on");
	check(normal.auto_spawn, "AutoSpawn accepts 1");

	const auto disabled = parse("Logging=false\nVerbose=0\nAutoSpawn=off\n");
	check(!disabled.logging && !disabled.verbose && !disabled.auto_spawn,
		"documented false values disable all flags");

	const auto comments = parse("# Logging=true\n;Verbose=true\nnotLogging=true\n");
	check(!comments.logging && !comments.verbose && !comments.auto_spawn,
		"comments and partial keys cannot enable flags");

	const auto duplicate = parse("Logging=true\nLogging=false\n");
	check(!duplicate.logging, "last exact key wins deterministically");

	const auto missing = parse("");
	check(!missing.logging && !missing.verbose && !missing.auto_spawn,
		"missing file contents default every flag off");

	std::cout << "CONFIG CORE RESULT failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
