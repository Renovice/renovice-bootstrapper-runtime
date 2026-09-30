#include <filesystem>
#include <fstream>
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
	// R5: the optional gate file. Absent (file or parent folder) is "off", never
	// an error, so the F9 transaction is never rejected by it.
	{
		std::error_code error;
		const auto root = std::filesystem::temp_directory_path(error) / "renovice_riven_gate_probe";
		std::filesystem::remove_all(root, error);
		std::filesystem::create_directories(root / "folder.cfg", error);
		check(!error, "gate probe folder created");
		{
			std::ofstream file(root / "riven_lock.cfg");
			file << "gate cfg";
		}
		std::error_code status;
		check(classify_gate_file(root / "riven_lock.cfg", status) == GateFile::Present && !status,
			"present riven_lock.cfg: gate on");
		check(classify_gate_file(root / "absent.cfg", status) == GateFile::Absent && !status,
			"absent riven_lock.cfg: gate off with no error (MSVC is_regular_file reports ERROR_FILE_NOT_FOUND)");
		check(classify_gate_file(root / "missing" / "riven_lock.cfg", status) == GateFile::Absent && !status,
			"absent parent folder: gate off with no error (ERROR_PATH_NOT_FOUND)");
		check(classify_gate_file(root / "folder.cfg", status) == GateFile::Absent && !status,
			"a folder with the gate name is not a gate file");
		std::error_code probe;
		const bool msvc_reports_missing = !std::filesystem::is_regular_file(root / "absent.cfg", probe) && probe;
		check(msvc_reports_missing,
			"negative control: is_regular_file(missing, ec) sets ec on this STL (the pre-R5 F9 rejection)");
		std::filesystem::remove_all(root, error);
	}
	std::cout << "RIVEN CORE RESULT failures=" << failures << '\n';
	return failures == 0 ? 0 : 1;
}
