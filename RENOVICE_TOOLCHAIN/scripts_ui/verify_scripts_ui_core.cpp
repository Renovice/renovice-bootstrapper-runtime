#include "../../renovice/injection_core.hpp"
#include "../../renovice/script_control_core.hpp"

#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <unordered_map>
#include <vector>

namespace
{
int failures = 0;
int checks = 0;

void check(bool condition, const char* label)
{
	++checks;
	if (condition) std::cout << "PASS " << label << '\n';
	else
	{
		std::cerr << "FAIL " << label << '\n';
		++failures;
	}
}
}

int main(int argc, char** argv)
{
	using namespace renovice;
	check(script_control::stable_id(
		script_control::Kind::Addon, "Example.ADDON.lua_B")
		== "addon:example.addon.lua_b", "addon stable id is case-normalized");
	check(script_control::stable_id(
		script_control::Kind::Replacement, "0123456789ABCDEF edit.lua_B")
		== "replacement:0123456789abcdef edit.lua_b",
		"replacement stable id preserves annotation");
	check(script_control::display_name(
		"08FAF07B504D058F.MALLETOVERGUARDANDCARD.TARGET.ADDON.lua_B")
		== "Mallet: Overguard and Ability Card",
		"uppercase target-addon filename receives canonical player label");
	check(script_control::display_name(
		"08faf07b504d058f.MalletOverguardAndCard.target.addon.lua_B")
		== "Mallet: Overguard and Ability Card",
		"camel-case target-addon filename receives the same canonical label");
	check(script_control::display_name(
		"08faf07b504d058f (Mallet explicit hook shim threat5).lua_B")
		== "Internal Hook Shim",
		"legacy hook shim is never described as a player feature");
	check(script_control::is_internal_hook_shim(
		"08faf07b504d058f (Mallet explicit hook shim threat5).lua_B")
		&& script_control::is_internal_hook_shim(
			"0123456789abcdef.Feature.internal-hook-shim.lua_B")
		&& !script_control::is_internal_hook_shim(
			"0123456789abcdef.UserReplacement.lua_B"),
		"internal hook-shim convention is generic and backward compatible");
	check(script_control::display_name(
		"4D3BAE2A1DB4F2E6 (OCTAVIA AMP BUFF--NO-DISTANCE).lua_B")
		== "Octavia Amp: No Range Limit",
		"Octavia Amp label uses canonical feature-description wording");
	check(script_control::display_name(
		"75904fc0ab2857a7 (Riven Lock script).lua_B")
		== "Riven Rerolls: Stat Locks",
		"Riven label identifies both the system and changed behavior");
	check(script_control::display_name(
		"fe3e36bc752a06cc (Octavia Metrone allscript).lua_B")
		== "Octavia Metronome: All Rhythm Buffs",
		"Metronome label corrects the typo and states the changed behavior");
	check(script_control::display_name("Missions.targets.addon.lua_B")
		== "Missions"
		&& script_control::menu_display_name(
			script_control::Kind::TargetAddon, "Missions.targets.addon.lua_B")
			== "[ADDON] Missions",
		"multi-target addon is one player-facing ADDON row without suffix noise");
	check(script_control::stable_id(
		script_control::Kind::TargetAddon, "Missions.TARGETS.addon.lua_B")
		== "target-addon:missions.targets.addon.lua_b"
		&& injection::classify_script("Missions.targets.addon.lua_B")
			== injection::ScriptKind::TargetManagedAddon,
		"multi-target addon owns one case-normalized target-addon policy id");
	check(script_control::display_name(
		"f10a043e7f825db2.missions.target.addon.lua_B") == "Missions",
		"single-key target addon display name is unchanged");
	check(script_control::display_name("MyFutureFeature.addon.lua_B")
		== "My Future Feature",
		"unknown future scripts retain generic filename normalization");
	check(script_control::menu_display_name(
		script_control::Kind::TargetAddon,
		"08FAF07B504D058F.MALLETOVERGUARDANDCARD.TARGET.ADDON.lua_B")
		== "[ADDON] Mallet: Overguard and Ability Card",
		"target addon is visibly grouped under the player-facing addon type");
	check(script_control::menu_display_name(
		script_control::Kind::Replacement,
		"4D3BAE2A1DB4F2E6 (OCTAVIA AMP BUFF--NO-DISTANCE).lua_B")
		== "[REPLACEMENT] Octavia Amp: No Range Limit",
		"replacement is visibly identified without changing its loader identity");
	check(script_control::menu_display_name(
		script_control::Kind::OneShot, "DeveloperProbe.lua_B")
		== "[ONE-SHOT] Developer Probe",
		"one-shot scripts are visibly distinguished from persistent policies");
	check(std::string(script_control::toggle_value_label(false)) == "OFF",
		"native toggle false option is OFF");
	check(std::string(script_control::toggle_value_label(true)) == "ON",
		"native toggle true option is ON");
	check(script_control::valid_state_id("target-addon:0123.lua_b"),
		"valid persisted id accepted");
	check(!script_control::valid_state_id("bad\nid"),
		"control characters rejected");
	std::unordered_map<std::string, bool> effective{
		{"addon:first.lua_b", true}, {"replacement:second.lua_b", true}};
	const std::unordered_map<std::string, bool> requested{
		{"addon:first.lua_b", false}, {"target-addon:third.lua_b", false}};
	script_control::overlay_requested(effective, requested);
	check(effective.size() == 3
		&& !effective.at("addon:first.lua_b")
		&& effective.at("replacement:second.lua_b")
		&& !effective.at("target-addon:third.lua_b"),
		"multiple pending requests are preserved in the next policy");

	const std::string all_markers = std::string(70 * 1024, 'x')
		+ "GetMenuEntries MenuSelectionDone ResumeGameUpperCase MenuAbilities MeleeCombos MenuOptions";
	check(injection::pause_top_menu_signature(
		reinterpret_cast<const unsigned char*>(all_markers.data()), all_markers.size()),
		"complete semantic fingerprint accepted");
	const std::string missing_marker = std::string(70 * 1024, 'x')
		+ "GetMenuEntries MenuSelectionDone ResumeGameUpperCase MenuAbilities";
	check(!injection::pause_top_menu_signature(
		reinterpret_cast<const unsigned char*>(missing_marker.data()), missing_marker.size()),
		"incomplete semantic fingerprint rejected");
	check(injection::pause_top_menu_closure_contract(23, 59),
		"current Initialize and builder upvalue counts accepted");
	check(!injection::pause_top_menu_closure_contract(22, 59),
		"changed Initialize closure fails closed");
	check(!injection::pause_top_menu_closure_contract(23, 58),
		"changed builder closure fails closed");
	check(injection::pause_initialize_builder_upvalue == 14
		&& injection::pause_builder_dispatch_upvalue == 58,
		"pinned zero-based ownership slots are explicit");
	check(injection::pause_menu_architecture_marker
		== "TOPMENU_EXACT_ROOT_EVENT_DRIVEN_V27_TARGET_ENV_HOOKS",
		"runtime architecture marker identifies exact target-environment hooks");
	check(injection::scripts_ui_bridge_filename
		== "_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B",
		"internal bridge filename is pinned and hidden from user script controls");
	check(injection::is_internal_scripts_ui_bridge(
		"_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B")
		&& !injection::is_internal_scripts_ui_bridge(
			"MyScriptsSettingsBridgeV10.lua_B"),
		"only the exact infrastructure bridge is excluded from user rows");
	check(injection::runtime_script_kind(
		"_RENOVICE_INTERNAL_ScriptsSettingsBridgeV10.lua_B")
			== injection::ScriptKind::ManagedAddon
		&& injection::runtime_script_kind("Example.addon.lua_B")
			== injection::ScriptKind::ManagedAddon
		&& injection::runtime_script_kind("Example.lua_B")
			== injection::ScriptKind::Ordinary,
		"runtime classifies the exact internal bridge as managed infrastructure");
	check(injection::scripts_ui_attachment_requested(true, true),
		"Scripts UI attachment requires both the runtime and internal bridge");
	check(!injection::scripts_ui_attachment_requested(false, true)
		&& !injection::scripts_ui_attachment_requested(true, false)
		&& !injection::scripts_ui_attachment_requested(false, false),
		"missing runtime or bridge preserves the stock TopMenu");
	check(injection::pause_lua_namecall_bridge_ready(true, true, true),
		"Lua NAMECALL bridge requires function, parent, and settings resource");
	check(!injection::pause_lua_namecall_bridge_ready(false, true, true)
		&& !injection::pause_lua_namecall_bridge_ready(true, false, true)
		&& !injection::pause_lua_namecall_bridge_ready(true, true, false),
		"Lua NAMECALL bridge fails closed when any prerequisite is absent");
	check(injection::pause_toggle_provider_argument_ready(1, true)
		&& injection::pause_toggle_provider_argument_ready(2, true),
		"native provider accepts a present numeric CHECKBOX enum");
	check(!injection::pause_toggle_provider_argument_ready(0, true)
		&& !injection::pause_toggle_provider_argument_ready(1, false),
		"missing or nonnumeric CHECKBOX provider argument fails closed");
	check(injection::scripts_settings_value_change_ready(2, true, true),
		"native checkbox value plus mSetting identifier are accepted");
	check(!injection::scripts_settings_value_change_ready(1, true, true)
		&& !injection::scripts_settings_value_change_ready(2, false, true)
		&& !injection::scripts_settings_value_change_ready(2, true, false),
		"incomplete checkbox value callback arguments fail closed");
	check(injection::classify_scripts_settings_completion(2, true, false, false)
		== injection::ScriptsSettingsCompletionDecision::Confirm,
		"Generic Settings nil completion flag commits staged changes");
	check(injection::classify_scripts_settings_completion(2, false, true, true)
		== injection::ScriptsSettingsCompletionDecision::Cancel,
		"Generic Settings true completion flag identifies the alternate close route");
	check(injection::classify_scripts_settings_completion(1, false, false, false)
		== injection::ScriptsSettingsCompletionDecision::Reject
		&& injection::classify_scripts_settings_completion(2, false, true, false)
			== injection::ScriptsSettingsCompletionDecision::Reject
		&& injection::classify_scripts_settings_completion(2, false, false, false)
			== injection::ScriptsSettingsCompletionDecision::Reject,
		"malformed completion callback shapes fail closed");
	check(injection::scripts_settings_should_apply_on_close(
		injection::ScriptsSettingsCompletionDecision::Confirm, 1)
		&& injection::scripts_settings_should_apply_on_close(
			injection::ScriptsSettingsCompletionDecision::Cancel, 1),
		"both recognized Generic Settings close routes apply staged changes");
	check(!injection::scripts_settings_should_apply_on_close(
		injection::ScriptsSettingsCompletionDecision::Confirm, 0)
		&& !injection::scripts_settings_should_apply_on_close(
			injection::ScriptsSettingsCompletionDecision::Cancel, 0)
		&& !injection::scripts_settings_should_apply_on_close(
			injection::ScriptsSettingsCompletionDecision::Reject, 1),
		"empty closes and malformed completion shapes never request an apply");
	check(injection::pause_callback_movie_capture_ready(true, true, true, true),
		"Lua owner environment and userdata movie enable callback capture");
	check(!injection::pause_callback_movie_capture_ready(false, true, true, true)
		&& !injection::pause_callback_movie_capture_ready(true, false, true, true)
		&& !injection::pause_callback_movie_capture_ready(true, true, false, true)
		&& !injection::pause_callback_movie_capture_ready(true, true, true, false),
		"incomplete callback movie ownership fails closed");
	const int top_menu_environment = 1;
	const int unrelated_environment = 2;
	const int top_menu_vm = 3;
	const int unrelated_vm = 4;
	const int top_menu_proto = 5;
	const int unrelated_proto = 6;
	check(injection::pause_runtime_root_owned(
		&top_menu_vm, &top_menu_proto,
		&top_menu_vm, &top_menu_proto, &top_menu_environment),
		"runtime clone accepts exact VM and root proto with instance environment");
	check(!injection::pause_runtime_root_owned(
		&top_menu_vm, &top_menu_proto,
		&unrelated_vm, &top_menu_proto, &top_menu_environment),
		"runtime clone rejects another VM");
	check(!injection::pause_runtime_root_owned(
		&top_menu_vm, &top_menu_proto,
		&top_menu_vm, &unrelated_proto, &top_menu_environment),
		"runtime clone rejects another root proto");
	check(!injection::pause_runtime_root_owned(
		&top_menu_vm, &top_menu_proto,
		&top_menu_vm, &top_menu_proto, nullptr),
		"runtime clone rejects missing instance environment");
	check(injection::pause_runtime_root_requires_revalidation(true, false),
		"first exact TopMenu instance requires attachment");
	check(injection::pause_runtime_root_requires_revalidation(true, true),
		"reopened exact TopMenu instance is never suppressed by prior attachment");
	check(!injection::pause_runtime_root_requires_revalidation(false, true),
		"unrelated roots stay rejected after a prior attachment");
	check(injection::pause_global_initialize_owned(
		&top_menu_environment, &top_menu_environment, true, 23),
		"published Initialize accepts exact TopMenu ownership");
	check(!injection::pause_global_initialize_owned(
		&top_menu_environment, &unrelated_environment, true, 23),
		"published Initialize rejects another module environment");
	check(!injection::pause_global_initialize_owned(
		&top_menu_environment, &top_menu_environment, false, 23),
		"published Initialize rejects non-Lua values");
	check(!injection::pause_global_initialize_owned(
		&top_menu_environment, &top_menu_environment, true, 22),
		"published Initialize rejects changed closure shape");
	check(injection::pause_exact_root_published(
		&top_menu_vm, &top_menu_proto, &top_menu_vm, &top_menu_proto),
		"published exact VM and root proto accept TopMenu execution");
	check(!injection::pause_exact_root_published(
		nullptr, &top_menu_proto, &top_menu_vm, &top_menu_proto)
		&& !injection::pause_exact_root_published(
			&top_menu_vm, &top_menu_proto, &unrelated_vm, &top_menu_proto)
		&& !injection::pause_exact_root_published(
			&top_menu_vm, &top_menu_proto, &top_menu_vm, &unrelated_proto),
		"unpublished and unrelated VM roots reject without fallback probing");
	check(injection::pause_environment_publication_ready(
		true, &top_menu_environment, &top_menu_environment, true, 23),
		"published mMenuOptions plus owned Initialize enables attachment");
	check(!injection::pause_environment_publication_ready(
		false, &top_menu_environment, &top_menu_environment, true, 23),
		"Initialize without published mMenuOptions cannot attach early");
	check(injection::pause_root_decoration_ready(true, true, 0),
		"successful exact root execution enables decoration");
	check(!injection::pause_root_decoration_ready(true, false, 0),
		"nested execution cannot decorate the pause module");
	check(!injection::pause_root_decoration_ready(true, true, 1),
		"failed root execution cannot decorate the pause module");
	check(!injection::pause_root_decoration_ready(false, true, 0),
		"unrecorded module identity cannot decorate the pause module");
	check(injection::pause_vm_root_decoration_ready(true, true, true),
		"successful exact VM root return enables decoration");
	check(!injection::pause_vm_root_decoration_ready(true, false, true),
		"nested VM closure cannot decorate the pause module");
	check(!injection::pause_vm_root_decoration_ready(false, true, true),
		"unassociated VM root cannot decorate the pause module");
	check(!injection::pause_vm_root_decoration_ready(true, true, false),
		"non-returning VM execution cannot decorate the pause module");
	const int runtime_vm = 7;
	const int other_runtime_vm = 8;
	check(injection::safe_runtime_tick_boundary_ready(
		&runtime_vm, 41, &runtime_vm, 41, 0, 0, true, false),
		"safe runtime tick accepts exact VM owner at outer host return");
	check(!injection::safe_runtime_tick_boundary_ready(
		&runtime_vm, 41, &other_runtime_vm, 41, 0, 0, true, false)
		&& !injection::safe_runtime_tick_boundary_ready(
			&runtime_vm, 41, &runtime_vm, 42, 0, 0, true, false),
		"safe runtime tick rejects another VM or owner thread");
	check(!injection::safe_runtime_tick_boundary_ready(
		&runtime_vm, 41, &runtime_vm, 41, 1, 0, true, false)
		&& !injection::safe_runtime_tick_boundary_ready(
			&runtime_vm, 41, &runtime_vm, 41, 0, 1, true, false)
		&& !injection::safe_runtime_tick_boundary_ready(
			&runtime_vm, 41, &runtime_vm, 41, 0, 0, false, false)
		&& !injection::safe_runtime_tick_boundary_ready(
			&runtime_vm, 41, &runtime_vm, 41, 0, 0, true, true),
		"safe runtime tick rejects nested, non-outer, and recursive execution");
	check(injection::safe_runtime_tick_due(100, 0, 8)
		&& injection::safe_runtime_tick_due(108, 100, 8)
		&& !injection::safe_runtime_tick_due(107, 100, 8),
		"safe runtime tick interval is deterministic and inclusive");
	check(injection::safe_runtime_tick_boundary_blocker(
		&runtime_vm, 41, &runtime_vm, 41, 0, 0, true, false)
		== injection::SafeRuntimeTickBoundaryBlocker::Ready
		&& injection::safe_runtime_tick_boundary_blocker(
			&runtime_vm, 41, &runtime_vm, 41, 0, 1, true, false)
			== injection::SafeRuntimeTickBoundaryBlocker::RenoviceExecutionActive,
		"settings reload diagnostics classify accepted and blocked boundaries");
	check(injection::safe_runtime_control_poll_ready(41, 41, 0, 0, false)
		&& !injection::safe_runtime_control_poll_ready(41, 42, 0, 0, false)
		&& !injection::safe_runtime_control_poll_ready(41, 41, 1, 0, false)
		&& !injection::safe_runtime_control_poll_ready(41, 41, 0, 1, false)
		&& !injection::safe_runtime_control_poll_ready(41, 41, 0, 0, true),
		"Lua-free F9 poll accepts any outer return only on the exact owner thread");

	if (argc == 2)
	{
		std::ifstream input(argv[1], std::ios::binary);
		std::vector<unsigned char> bytes{
			std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
		check(input.good() || input.eof(), "pinned current TopMenu bytecode readable");
		check(injection::pause_top_menu_signature(bytes.data(), bytes.size()),
			"pinned current TopMenu satisfies exact runtime fingerprint");
	}
	else
	{
		std::cerr << "FAIL pinned current TopMenu path argument missing\n";
		++failures;
	}

	if (failures != 0)
	{
		std::cerr << "SCRIPTS UI CORE FAIL failures=" << failures << '\n';
		return 1;
	}
	std::cout << "SCRIPTS UI CORE PASS checks=" << checks << '\n';
	return 0;
}
