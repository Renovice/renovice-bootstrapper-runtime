#pragma once

// SCRIPT SETTINGS pause-menu editor: pure page model and staging.
//
// Contract: INGAME_EDITOR_DESIGN.md sections 4.2-4.6, CONTRACT_PHASE1.md
// Revision R7 (2026-09-30). The host (injection.cpp) turns a Page into plain DE
// Luau row descriptors; the compiled bridge
// (RENOVICE_SCRIPTING/INTERNAL/ScriptSettingsBridgeV1.luau) maps them onto the
// stock GenericSettings row types TITLE, SPACER, CHECKBOX, INPUTCOUNT, INPUTBOX,
// TOGGLE and BUTTON. Nothing here is Pluto, an overlay or a custom movie.
//
// R7 value model (live feedback 2026-09-30): no "Custom" switches, no package,
// member, "Use stock values" or section switches (enabling a script is the
// SCRIPTS menu's job). Every value has a current value and a Default:
//   * the default is the declared `default` (an addon-owned option, for example
//     the Ice Wave bonus 50x) or else the game stock;
//   * changing a value applies it; a value equal to its default means "leave
//     it as intended". In the values file that is `enabled = value ~= default`
//     (unchanged V1 file format and delivery);
//   * "Reset to default" (value page) and "Reset all to defaults" (every list
//     page) put values back at their default;
//   * the Quick settings page is the one on/off: `active:` toggles the stored
//     `enabled` flag and keeps the typed value (`stored:`).
//
// Row setting ids (the value-changed callback receives them as mSetting):
//   value:<folder lower>/<value id>   the value (detailed pages)
//   stored:<folder lower>/<value id>  the kept value of a quick value (qval page)
//   active:<folder lower>/<value id>  the quick on/off (and the legacy literal switch)
// BUTTON actions:
//   open:<page id>                    push a child page
//   reset:<Folder>/value:<value id>   value page: reset, then close the page
//   resetall:<Folder>[/node:<node>]   list page: reset everything below, refresh in place
// Page ids: root, flat, pkg:<Folder>, node:<Folder>/<node id>, quick:<Folder>,
// val:<Folder>/<value id>, qval:<Folder>/<value id>.
// Layout: nested by default (root -> package -> path pages -> value page);
// SettingsMenuNested=false selects one flat list.

#include <algorithm>
#include <cctype>
#include <charconv>
#include <cmath>
#include <cstdio>
#include <map>
#include <set>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "script_control_core.hpp"
#include "settings_core.hpp"

namespace renovice::settings_ui
{
inline constexpr std::size_t maximum_row_label = 40;
inline constexpr std::size_t maximum_title_label = 48;
inline constexpr std::size_t maximum_tooltip = 300;
inline constexpr std::size_t maximum_input_chars = 16;

// Stock scroll contract (Lotus.Interface.ThemedGenericSettings Update; 44.0.2
// render L4740-4880, pre-44 NSTM render L4880-4940). The list only attaches
// Container.ScrollBar, enables smooth scroll, limits itself to 14 visible rows
// and masks at 600 px when UniformElementHeights is true: every element has
// the same height (mHeight, else the per-type default {44,44,44,44,24,108,8,
// 44,87,84,44}) and no element is an INPUTBOX or multi-line. Otherwise the
// scroll bar is hidden, the mask takes the movie height and the background
// grows with the summed row heights, so a long list runs off the screen and
// the mouse wheel (onKeyDown_MENU_MOUSE_Z needs mScrollBar) does nothing.
// Therefore: the bridge gives TITLE and SPACER mHeight = 44 (the CHECKBOX,
// TOGGLE, BUTTON and INPUTCOUNT default), and an editor never shares a list
// page: it lives on its value page ("val:" page id) with at most its reset
// BUTTON, which never scrolls.
inline constexpr double stock_uniform_row_height = 44.0;
inline constexpr double stock_inputbox_row_height = 108.0;
inline constexpr std::size_t stock_uniform_visible_rows = 14;

enum class RowKind { Title, Spacer, Checkbox, InputCount, InputBox, Toggle, Button };

inline const char* row_kind_name(RowKind kind) noexcept
{
	switch (kind)
	{
	case RowKind::Title: return "TITLE";
	case RowKind::Spacer: return "SPACER";
	case RowKind::Checkbox: return "CHECKBOX";
	case RowKind::InputCount: return "INPUTCOUNT";
	case RowKind::InputBox: return "INPUTBOX";
	case RowKind::Toggle: return "TOGGLE";
	case RowKind::Button: return "BUTTON";
	}
	return "TITLE";
}

struct ToggleOption
{
	std::string label;
	double value = 0.0;
};

struct Row
{
	RowKind kind = RowKind::Title;
	std::string label;
	std::string tooltip;
	std::string setting;
	std::string action;
	std::string content;           // INPUTBOX text
	bool value = false;            // CHECKBOX
	double count = 0.0;            // INPUTCOUNT
	double minimum = 0.0;          // validator bounds (INPUTCOUNT/INPUTBOX)
	double maximum = 0.0;
	double number = 0.0;           // TOGGLE selected value
	bool validate = false;         // attach mOnValidateSetting
	bool integer = false;
	std::string invalid_message;   // ShowMessage text when the validator fails
	bool locked = false;
	std::vector<ToggleOption> options;
};

struct Page
{
	std::string title;
	bool search = false;
	std::string empty_message = "NO SETTINGS";
	std::vector<Row> rows;
};

// Height the stock Update uses for the row the bridge builds from `kind`.
inline double stock_row_height(RowKind kind) noexcept
{
	return kind == RowKind::InputBox ? stock_inputbox_row_height : stock_uniform_row_height;
}

// Mirror of the stock UniformElementHeights decision for one page.
inline bool stock_uniform_heights(const Page& page) noexcept
{
	for (const auto& row : page.rows)
	{
		if (row.kind == RowKind::InputBox) return false;
		if (stock_row_height(row.kind) != stock_row_height(page.rows.front().kind)) return false;
	}
	return true;
}

// True when the stock screen attaches its scroll bar (and wheel scrolling).
inline bool stock_scroll_attached(const Page& page) noexcept
{
	return stock_uniform_heights(page) && page.rows.size() > stock_uniform_visible_rows;
}

// Members stay in the view for the host's inventory; since R7 no page shows
// them (enabling a package or a member is the SCRIPTS menu's job).
struct MemberView
{
	std::string filename;
	std::string label;
	std::string state_id;
	bool enabled = true;
	bool replacement = false;
};

struct PackageView
{
	std::string folder;
	std::string display;
	bool package_enabled = true;
	const settings::Declarations* declarations = nullptr;
	std::vector<MemberView> members;
	settings::UserState state; // current file state (absent file: empty)
	bool file_malformed = false;
	std::string file_reason;
};

// ---------------------------------------------------------------------------
// Text helpers. Labels never get leading spaces, bullets, tree glyphs or an
// ellipsis: a label over budget falls back to a shorter wording, and the full
// text always goes to the tooltip.
// ---------------------------------------------------------------------------
inline std::string upper(std::string_view text)
{
	std::string out(text);
	std::transform(out.begin(), out.end(), out.begin(), [](unsigned char c)
	{
		return static_cast<char>(std::toupper(c));
	});
	return out;
}

inline std::string clean(std::string_view text)
{
	std::string out;
	out.reserve(text.size());
	for (const char ch : text)
	{
		const auto c = static_cast<unsigned char>(ch);
		out.push_back(c < 0x20u || c == 0x7Fu ? ' ' : ch);
	}
	while (!out.empty() && out.front() == ' ') out.erase(out.begin());
	while (!out.empty() && out.back() == ' ') out.pop_back();
	return out;
}

// Cuts at the last word boundary that fits; never adds an ellipsis.
inline std::string fit_words(std::string text, std::size_t budget)
{
	text = clean(text);
	if (text.size() <= budget) return text;
	std::size_t cut = budget;
	while (cut != 0 && text[cut] != ' ') --cut;
	if (cut == 0) cut = budget;
	while (cut != 0 && (static_cast<unsigned char>(text[cut]) & 0xC0u) == 0x80u) --cut;
	text.resize(cut);
	while (!text.empty() && (text.back() == ' ' || text.back() == ':' || text.back() == ',')) text.pop_back();
	return text;
}

inline std::string bounded_tooltip(std::string text)
{
	text = clean(text);
	if (text.size() <= maximum_tooltip) return text;
	return fit_words(text, maximum_tooltip);
}

inline std::string sentence(std::string text)
{
	text = clean(text);
	if (!text.empty() && text.back() != '.' && text.back() != '!' && text.back() != '?') text += '.';
	return text;
}

inline std::string folder_key(std::string_view folder)
{
	return script_control::ascii_lower(folder);
}

inline std::string applies_text(settings::Applies applies)
{
	switch (applies)
	{
	case settings::Applies::LiveNextRead: return "live, at the next read";
	case settings::Applies::NextInstance: return "at the next instance";
	case settings::Applies::NextMission: return "at the next mission";
	case settings::Applies::Restart: return "after a game restart";
	}
	return "at the next read";
}

// Display numbers (CONTRACT_PHASE1 D1): whole numbers without a decimal
// point, otherwise %.6g.
inline std::string display_number(double value)
{
	if (std::floor(value) == value && std::fabs(value) < 1.0e15)
		return std::to_string(static_cast<long long>(value));
	char buffer[48]{};
	std::snprintf(buffer, sizeof(buffer), "%.6g", value);
	return buffer;
}

inline std::string value_text(const settings::ValueDecl& declaration, double value)
{
	if (declaration.type == settings::ValueType::Enum)
	{
		for (const auto& option : declaration.options)
			if (option.value == value) return clean(option.label);
	}
	return display_number(value);
}

// Unit `x` follows the number directly ("1.5x"); any other unit after a space.
inline std::string with_unit(const settings::ValueDecl& declaration, double value)
{
	auto text = value_text(declaration, value);
	if (!declaration.unit.empty() && declaration.type != settings::ValueType::Enum)
		text += declaration.unit == "x" ? declaration.unit : " " + declaration.unit;
	return text;
}

// "<label>: <detail>" within the 40-character row, cutting the label at a word,
// never the detail. BUTTON rows never carry a stock sub-label (R3: the stock
// draw needs mButtonWidth for it, source line 991).
inline std::string button_label(std::string_view label, std::string_view detail)
{
	const std::string base = clean(label);
	const std::string text = clean(detail);
	if (text.empty()) return fit_words(base, maximum_row_label);
	const std::string full = base + ": " + text;
	if (full.size() <= maximum_row_label) return full;
	constexpr std::size_t minimum_label = 8;
	if (text.size() + 2 + minimum_label <= maximum_row_label)
		return fit_words(base, maximum_row_label - text.size() - 2) + ": " + text;
	return fit_words(base, maximum_row_label);
}

inline Row title(std::string_view text)
{
	Row row;
	row.kind = RowKind::Title;
	row.label = fit_words(upper(text), maximum_title_label);
	return row;
}

inline Row spacer()
{
	Row row;
	row.kind = RowKind::Spacer;
	return row;
}

inline Row checkbox(std::string label, std::string setting, bool value, std::string tooltip)
{
	Row row;
	row.kind = RowKind::Checkbox;
	row.label = fit_words(std::move(label), maximum_row_label);
	row.setting = std::move(setting);
	row.value = value;
	row.tooltip = bounded_tooltip(std::move(tooltip));
	return row;
}

inline Row button(std::string label, std::string action, std::string detail, std::string tooltip)
{
	Row row;
	row.kind = RowKind::Button;
	row.label = button_label(label, detail);
	row.action = std::move(action);
	row.setting = "action:" + row.action;
	row.tooltip = bounded_tooltip(std::move(tooltip));
	return row;
}

// ---------------------------------------------------------------------------
// R7 value model.
// ---------------------------------------------------------------------------
inline double default_value(const settings::ValueDecl& declaration) noexcept
{
	return settings::default_of(declaration);
}

// Literal lane (a replacement built with a fixed number): the option the
// built script applies, i.e. the first declared option that is not the stock.
inline const settings::EnumOption* built_option(const settings::ValueDecl& declaration) noexcept
{
	if (declaration.lane != settings::Lane::Literal || declaration.type != settings::ValueType::Enum) return nullptr;
	for (const auto& option : declaration.options)
		if (option.value != declaration.stock) return &option;
	return nullptr;
}

inline bool group_enabled(const settings::UserState& state, std::string_view group)
{
	const auto found = state.groups.find(std::string(group));
	return found == state.groups.end() || found->second;
}

inline const settings::UserValue* entry_of(const PackageView& view, const settings::ValueDecl& declaration)
{
	const auto entry = view.state.values.find(declaration.id);
	if (entry == view.state.values.end() || !entry->second.shape_valid) return nullptr;
	return &entry->second;
}

// The stored number of an entry, when it is one the declaration accepts.
inline bool stored_number(const PackageView& view, const settings::ValueDecl& declaration, double& number)
{
	const auto* entry = entry_of(view, declaration);
	if (entry == nullptr || !entry->has_value || !settings::validate_value(declaration, entry->value).empty()) return false;
	number = entry->value;
	return true;
}

// Whether the file entry is what applies (the host's evaluation, ignoring
// build-carry-over checks): a valid file, not use_stock, section on, enabled
// and, outside the literal lane, a valid number.
inline bool entry_applies(const PackageView& view, const settings::ValueDecl& declaration)
{
	if (view.file_malformed || view.state.use_stock || !group_enabled(view.state, declaration.group)) return false;
	const auto* entry = entry_of(view, declaration);
	if (entry == nullptr || !entry->enabled) return false;
	if (declaration.lane == settings::Lane::Literal) return true;
	double number = 0.0;
	return stored_number(view, declaration, number);
}

// The value the player currently gets (what the rows show).
inline double current_value(const PackageView& view, const settings::ValueDecl& declaration)
{
	if (declaration.lane == settings::Lane::Literal)
	{
		if (!entry_applies(view, declaration)) return declaration.stock;
		if (const auto* built = built_option(declaration)) return built->value;
		double number = 0.0;
		return stored_number(view, declaration, number) ? number : declaration.stock;
	}
	if (!entry_applies(view, declaration)) return default_value(declaration);
	const auto* entry = entry_of(view, declaration);
	return entry->value;
}

// The number a quick value keeps while it is off (the qval page edits it).
inline double kept_value(const PackageView& view, const settings::ValueDecl& declaration)
{
	double number = 0.0;
	if (stored_number(view, declaration, number)) return number;
	if (const auto* built = built_option(declaration)) return built->value;
	return default_value(declaration);
}

inline bool at_default(const PackageView& view, const settings::ValueDecl& declaration)
{
	return current_value(view, declaration) == default_value(declaration);
}

inline std::string default_text(const settings::ValueDecl& declaration)
{
	if (!declaration.default_label.empty()) return clean(declaration.default_label);
	return with_unit(declaration, default_value(declaration));
}

inline std::string number_text(const settings::ValueDecl& declaration, double value)
{
	return value == default_value(declaration) ? default_text(declaration) : with_unit(declaration, value);
}

inline std::string shown_value(const PackageView& view, const settings::ValueDecl& declaration)
{
	return number_text(declaration, current_value(view, declaration));
}

inline std::string row_text(const settings::ValueDecl& declaration)
{
	return clean(declaration.row.empty() ? declaration.label : declaration.row);
}

// "Time between rewards: 60 s", or "Time between rewards: 300 s (default)".
inline std::string value_row_label(const PackageView& view, const settings::ValueDecl& declaration)
{
	const bool is_default = at_default(view, declaration);
	return button_label(row_text(declaration),
		shown_value(view, declaration) + (is_default ? " (default)" : ""));
}

inline std::string description(const settings::ValueDecl& declaration)
{
	if (!declaration.scope.empty()) return sentence(declaration.scope);
	return sentence(clean(declaration.label));
}

// The addon compares the live game value with its stock before writing
// (`stock_check` live): said once, on the editor, in player words.
inline constexpr std::string_view live_stock_sentence = " A changed value applies only where the game still uses its default.";

inline std::string editor_tooltip(const settings::ValueDecl& declaration)
{
	std::string text = "Default " + default_text(declaration) + ".";
	if (declaration.lane == settings::Lane::Literal)
	{
		text += " Built into the mission script; applies at the next mission.";
		return bounded_tooltip(text);
	}
	if (declaration.lane == settings::Lane::Metadata)
		return bounded_tooltip(text + " Metadata value: read-only here; applies after a game restart.");
	if (declaration.type != settings::ValueType::Enum)
		text += " Range " + display_number(declaration.minimum) + " to " + display_number(declaration.maximum) + ".";
	text += " Applies " + applies_text(declaration.applies) + ".";
	if (declaration.stock_check == settings::StockCheck::Live) text += live_stock_sentence;
	return bounded_tooltip(text);
}

// ---------------------------------------------------------------------------
// Tree of pages (R7 `path`). Values are taken in (section order, declaration
// order); a node's items (child pages and value rows) keep the order in which
// they first appear. Values without `path` in a package that uses paths sit
// under their section label. A package without any `path` renders its
// sections flat on the package page (older packages, for example Frost).
// ---------------------------------------------------------------------------
struct TreeItem
{
	std::size_t node = 0;                          // child node index (when value == nullptr)
	const settings::ValueDecl* value = nullptr;
};

struct TreeNode
{
	std::string name;
	std::string id;       // "" for the package page, else "0", "0.2", ...
	std::size_t children = 0;
	std::vector<TreeItem> items;
};

struct Tree
{
	bool uses_paths = false;
	std::vector<TreeNode> nodes; // nodes[0] = package page
};

inline std::vector<const settings::ValueDecl*> ordered_values(const settings::Declarations& declarations)
{
	std::map<std::string, long long> order;
	for (const auto& group : declarations.groups) order[group.id] = group.order;
	std::vector<const settings::ValueDecl*> values;
	for (const auto& value : declarations.values) values.push_back(&value);
	std::stable_sort(values.begin(), values.end(), [&](const auto* lhs, const auto* rhs)
	{
		return order[lhs->group] < order[rhs->group];
	});
	return values;
}

inline std::vector<const settings::GroupDecl*> ordered_groups(const settings::Declarations& declarations)
{
	std::vector<const settings::GroupDecl*> groups;
	for (const auto& group : declarations.groups) groups.push_back(&group);
	std::stable_sort(groups.begin(), groups.end(), [](const auto* lhs, const auto* rhs)
	{
		return lhs->order < rhs->order;
	});
	return groups;
}

inline std::vector<std::string> value_path(const settings::Declarations& declarations, const settings::ValueDecl& value)
{
	if (!value.path.empty()) return value.path;
	const auto* group = declarations.group(value.group);
	return {group != nullptr ? clean(group->label) : value.group};
}

inline Tree build_tree(const settings::Declarations& declarations)
{
	Tree tree;
	tree.nodes.push_back(TreeNode{});
	tree.uses_paths = std::any_of(declarations.values.begin(), declarations.values.end(),
		[](const settings::ValueDecl& value) { return !value.path.empty(); });
	for (const auto* value : ordered_values(declarations))
	{
		if (!tree.uses_paths)
		{
			tree.nodes[0].items.push_back(TreeItem{0, value});
			continue;
		}
		std::size_t at = 0;
		for (const auto& name : value_path(declarations, *value))
		{
			std::size_t found = 0;
			bool exists = false;
			for (const auto& item : tree.nodes[at].items)
			{
				if (item.value == nullptr && tree.nodes[item.node].name == name)
				{
					found = item.node;
					exists = true;
					break;
				}
			}
			if (!exists)
			{
				TreeNode node;
				node.name = name;
				const auto index = tree.nodes[at].children++;
				node.id = tree.nodes[at].id.empty() ? std::to_string(index) : tree.nodes[at].id + "." + std::to_string(index);
				found = tree.nodes.size();
				tree.nodes.push_back(std::move(node));
				tree.nodes[at].items.push_back(TreeItem{found, nullptr});
			}
			at = found;
		}
		tree.nodes[at].items.push_back(TreeItem{0, value});
	}
	return tree;
}

inline const TreeNode* find_node(const Tree& tree, std::string_view id)
{
	for (const auto& node : tree.nodes)
		if (node.id == id) return &node;
	return nullptr;
}

inline void collect_values(const Tree& tree, const TreeNode& node, std::vector<const settings::ValueDecl*>& out)
{
	for (const auto& item : node.items)
	{
		if (item.value != nullptr) out.push_back(item.value);
		else collect_values(tree, tree.nodes[item.node], out);
	}
}

inline std::size_t changed_count(const PackageView& view, const std::vector<const settings::ValueDecl*>& values)
{
	return static_cast<std::size_t>(std::count_if(values.begin(), values.end(),
		[&](const settings::ValueDecl* value) { return !at_default(view, *value); }));
}

inline std::string changed_detail(std::size_t changed)
{
	return changed == 0 ? std::string() : std::to_string(changed) + " changed";
}

inline std::string value_page_action(const PackageView& view, const settings::ValueDecl& declaration)
{
	return "open:val:" + view.folder + "/" + declaration.id;
}

inline Row value_row(const PackageView& view, const settings::ValueDecl& declaration)
{
	Row row;
	row.kind = RowKind::Button;
	row.label = value_row_label(view, declaration);
	row.action = value_page_action(view, declaration);
	row.setting = "action:" + row.action;
	row.tooltip = bounded_tooltip(description(declaration));
	return row;
}

inline Row node_row(const PackageView& view, const Tree& tree, const TreeNode& node)
{
	std::vector<const settings::ValueDecl*> values;
	collect_values(tree, node, values);
	return button(node.name, "open:node:" + view.folder + "/" + node.id,
		changed_detail(changed_count(view, values)), "Open " + clean(node.name) + ".");
}

inline void append_items(std::vector<Row>& rows, const PackageView& view, const Tree& tree, const TreeNode& node)
{
	for (const auto& item : node.items)
	{
		if (item.value != nullptr) rows.push_back(value_row(view, *item.value));
		else rows.push_back(node_row(view, tree, tree.nodes[item.node]));
	}
}

inline Row reset_all_row(std::string action, std::string_view where)
{
	return button("Reset all to defaults", std::move(action), "",
		"Sets every value " + std::string(where) + " back to its default.");
}

// The stock search box stays off (R4). The stock filter (ThemedGenericSettings
// 44.0.2 source lines 685-709) rebuilds the list from copies taken at populate
// (lines 1656-1678): a row edited before typing shows its old value again and
// the completion pass would stage that old value. Live 2026-09-30 the filter
// also re-added an INPUTCOUNT row copy without widgets, the per-frame count
// poll raised a script error and the screen could not be left.
inline constexpr bool stock_search_box = false;

inline std::vector<const settings::ValueDecl*> quick_values(const settings::Declarations& declarations)
{
	std::vector<const settings::ValueDecl*> values;
	for (const auto* value : ordered_values(declarations))
		if (!value->quick.empty()) values.push_back(value);
	return values;
}

inline bool quick_on(const PackageView& view, const settings::ValueDecl& declaration)
{
	return entry_applies(view, declaration);
}

// Nested layout, the default (SettingsMenuNested=false selects the flat list).
// The top page lists only the packages that declare settings.
inline Page build_root_page(const std::vector<PackageView>& views)
{
	Page page;
	page.title = "SCRIPT SETTINGS";
	page.empty_message = "NO PACKAGE SETTINGS FOUND";
	for (const auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		std::vector<const settings::ValueDecl*> values;
		for (const auto& value : view.declarations->values) values.push_back(&value);
		page.rows.push_back(button(clean(view.display), "open:pkg:" + view.folder,
			changed_detail(changed_count(view, values)),
			"Open the settings of " + clean(view.display) + ". Turn the script on or off in SCRIPTS."));
	}
	return page;
}

// Package page: Quick settings (when declared), then the path pages and value
// rows (or, without paths, the values section by section), then one "Reset
// all to defaults". No package, member, "Use stock values" or section switch.
inline Page build_package_page(const PackageView& view)
{
	Page page;
	page.title = fit_words(upper(view.display), maximum_title_label);
	if (view.declarations == nullptr) return page;
	const auto quick = quick_values(*view.declarations);
	if (!quick.empty())
	{
		const auto on = static_cast<std::size_t>(std::count_if(quick.begin(), quick.end(),
			[&](const settings::ValueDecl* value) { return quick_on(view, *value); }));
		page.rows.push_back(button("Quick settings", "open:quick:" + view.folder,
			on == 0 ? std::string() : std::to_string(on) + " on",
			"The main value of each mission type, each with its own on/off."));
	}
	const auto tree = build_tree(*view.declarations);
	if (tree.uses_paths)
	{
		append_items(page.rows, view, tree, tree.nodes[0]);
	}
	else
	{
		std::size_t sections = 0;
		for (const auto* group : ordered_groups(*view.declarations))
		{
			sections += std::any_of(view.declarations->values.begin(), view.declarations->values.end(),
				[&](const settings::ValueDecl& value) { return value.group == group->id; }) ? 1 : 0;
		}
		for (const auto* group : ordered_groups(*view.declarations))
		{
			bool titled = false;
			for (const auto* value : ordered_values(*view.declarations))
			{
				if (value->group != group->id) continue;
				if (!titled && sections > 1) page.rows.push_back(title(group->label));
				titled = true;
				page.rows.push_back(value_row(view, *value));
			}
		}
	}
	page.rows.push_back(spacer());
	page.rows.push_back(reset_all_row("resetall:" + view.folder, "of " + clean(view.display)));
	return page;
}

inline Page build_node_page(const PackageView& view, std::string_view node_id)
{
	Page page;
	page.search = stock_search_box;
	if (view.declarations == nullptr) return page;
	const auto tree = build_tree(*view.declarations);
	const auto* node = node_id.empty() ? nullptr : find_node(tree, node_id);
	if (node == nullptr) return page;
	page.title = fit_words(upper(node->name), maximum_title_label);
	append_items(page.rows, view, tree, *node);
	page.rows.push_back(spacer());
	page.rows.push_back(reset_all_row("resetall:" + view.folder + "/node:" + node->id, "on this page"));
	return page;
}

// Quick settings: per quick value its on/off (CHECKBOX, `active:`) and the
// number it keeps (BUTTON to the qval page). Off returns the mission to its
// default; on restores the kept number. Same storage as the detailed pages.
inline Page build_quick_page(const PackageView& view)
{
	Page page;
	page.title = "QUICK SETTINGS";
	page.search = stock_search_box;
	if (view.declarations == nullptr) return page;
	const std::string key = folder_key(view.folder);
	for (const auto* value : quick_values(*view.declarations))
	{
		const std::string kept = number_text(*value, kept_value(view, *value));
		page.rows.push_back(checkbox(value->quick, "active:" + key + "/" + value->id, quick_on(view, *value),
			"On: " + kept + ". Off: the default (" + default_text(*value) + "); your number is kept. "
				+ description(*value)));
		const std::string target = value->lane == settings::Lane::Literal
			? "open:val:" + view.folder + "/" + value->id
			: "open:qval:" + view.folder + "/" + value->id;
		// "<mission>: <kept value>", the part of the quick label before its colon.
		const std::string quick = clean(value->quick);
		const auto colon = quick.find(':');
		const std::string owner = colon == std::string::npos ? quick : quick.substr(0, colon);
		const bool is_default = kept_value(view, *value) == default_value(*value);
		Row open = button(owner, target, kept + (is_default ? " (default)" : ""),
			"The value used while " + quick + " is on (default " + default_text(*value) + ").");
		page.rows.push_back(std::move(open));
	}
	return page;
}

// The stock editor of one value: TOGGLE (enum, literal choices), INPUTCOUNT
// (int >= 0) or a validated INPUTBOX (float, negative int). `setting` is
// value: (detailed) or stored: (quick kept value).
inline Row value_editor(const PackageView& view, const settings::ValueDecl& declaration, bool kept)
{
	const double current = kept ? kept_value(view, declaration) : current_value(view, declaration);
	Row editor;
	editor.label = declaration.unit.empty() || declaration.type == settings::ValueType::Enum
		? std::string("Value") : "Value (" + clean(declaration.unit) + ")";
	editor.setting = std::string(kept ? "stored:" : "value:") + folder_key(view.folder) + "/" + declaration.id;
	editor.tooltip = editor_tooltip(declaration);
	editor.minimum = declaration.minimum;
	editor.maximum = declaration.maximum;
	editor.integer = declaration.type != settings::ValueType::Float;
	editor.locked = declaration.lane == settings::Lane::Metadata;
	editor.invalid_message = fit_words(clean(declaration.label), 40) + ": enter "
		+ (editor.integer ? "a whole number" : "a number") + " from "
		+ display_number(declaration.minimum) + " to "
		+ display_number(declaration.maximum) + ".";
	if (declaration.type == settings::ValueType::Enum)
	{
		editor.kind = RowKind::Toggle;
		editor.number = current;
		for (const auto& option : declaration.options)
		{
			std::string label = clean(option.label);
			if (option.value == default_value(declaration) && label.size() + 10 <= maximum_row_label) label += " (default)";
			editor.options.push_back(ToggleOption{fit_words(label, maximum_row_label), option.value});
		}
	}
	else if (declaration.type == settings::ValueType::Int && declaration.minimum >= 0)
	{
		// INPUTCOUNT takes integers >= 0 only and clamps typed input to
		// 0..mMaxCount; the validator enforces the declared minimum.
		editor.kind = RowKind::InputCount;
		editor.count = current;
		editor.validate = !editor.locked;
	}
	else
	{
		editor.kind = RowKind::InputBox;
		editor.content = settings::json::number_text(current);
		editor.validate = !editor.locked;
	}
	return editor;
}

// Value page ("val:<Folder>/<id>", or "qval:" for a quick value's kept
// number): the editor and "Reset to default: <default>". A literal value
// without choices (packages before R7) shows its switch instead of an editor.
inline Page build_value_page(const PackageView& view, std::string_view value_id, bool kept = false)
{
	Page page;
	page.empty_message = "NO SETTINGS";
	if (view.declarations == nullptr) return page;
	const auto* declaration = view.declarations->value(value_id);
	if (declaration == nullptr) return page;
	if (kept && (declaration->quick.empty() || declaration->lane != settings::Lane::Addon)) return page;
	page.title = fit_words(upper(declaration->label), maximum_title_label);
	if (declaration->lane == settings::Lane::Literal && declaration->type != settings::ValueType::Enum)
	{
		page.rows.push_back(checkbox("Use the built value", "active:" + folder_key(view.folder) + "/" + declaration->id,
			entry_applies(view, *declaration), description(*declaration) + " " + editor_tooltip(*declaration)));
	}
	else
	{
		page.rows.push_back(value_editor(view, *declaration, kept));
	}
	page.rows.push_back(button("Reset to default", "reset:" + view.folder + "/value:" + declaration->id,
		default_text(*declaration), "Puts this value back to its default and returns."));
	return page;
}

// Flat layout (SettingsMenuNested=false): one list, a TITLE per package and per
// page of values, every value one row.
inline Page build_flat_page(const std::vector<PackageView>& views)
{
	Page page;
	page.title = "SCRIPT SETTINGS";
	page.search = stock_search_box;
	page.empty_message = "NO PACKAGE SETTINGS FOUND";
	for (const auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		page.rows.push_back(title(view.display));
		const auto tree = build_tree(*view.declarations);
		if (!tree.uses_paths)
		{
			for (const auto& item : tree.nodes[0].items) page.rows.push_back(value_row(view, *item.value));
			continue;
		}
		// Depth-first; a TITLE names the page ("Survival - Timers") before its values.
		std::vector<std::pair<std::size_t, std::string>> stack{{0, std::string()}};
		while (!stack.empty())
		{
			const auto [index, name] = stack.back();
			stack.pop_back();
			const auto& node = tree.nodes[index];
			bool titled = false;
			for (const auto& item : node.items)
			{
				if (item.value == nullptr) continue;
				if (!titled && !name.empty()) page.rows.push_back(title(name));
				titled = true;
				page.rows.push_back(value_row(view, *item.value));
			}
			for (auto item = node.items.rbegin(); item != node.items.rend(); ++item)
			{
				if (item->value != nullptr) continue;
				const auto& child = tree.nodes[item->node];
				stack.emplace_back(item->node, name.empty() ? child.name : name + " - " + child.name);
			}
		}
	}
	return page;
}

inline const PackageView* view_for_folder(const std::vector<PackageView>& views, std::string_view folder)
{
	for (const auto& view : views)
		if (view.folder == folder && view.declarations != nullptr) return &view;
	return nullptr;
}

// Page id -> page (the host serves exactly these).
inline Page select_page(const std::vector<PackageView>& views, std::string_view page_id, bool& found)
{
	found = true;
	if (page_id == "flat") return build_flat_page(views);
	if (page_id == "root") return build_root_page(views);
	const auto split = [&](std::string_view prefix, std::string_view& folder, std::string_view& rest)
	{
		if (page_id.substr(0, prefix.size()) != prefix) return false;
		const auto body = page_id.substr(prefix.size());
		const auto slash = body.find('/');
		folder = slash == std::string_view::npos ? body : body.substr(0, slash);
		rest = slash == std::string_view::npos ? std::string_view() : body.substr(slash + 1);
		return true;
	};
	std::string_view folder, rest;
	if (split("pkg:", folder, rest) && rest.empty())
	{
		if (const auto* view = view_for_folder(views, folder)) return build_package_page(*view);
	}
	else if (split("node:", folder, rest))
	{
		if (const auto* view = view_for_folder(views, folder))
		{
			auto page = build_node_page(*view, rest);
			if (!page.rows.empty()) return page;
		}
	}
	else if (split("quick:", folder, rest) && rest.empty())
	{
		if (const auto* view = view_for_folder(views, folder))
		{
			auto page = build_quick_page(*view);
			if (!page.rows.empty()) return page;
		}
	}
	else if (split("val:", folder, rest) || split("qval:", folder, rest))
	{
		if (const auto* view = view_for_folder(views, folder))
		{
			auto page = build_value_page(*view, rest, page_id.substr(0, 5) == "qval:");
			if (!page.rows.empty()) return page;
		}
	}
	found = false;
	return {};
}

// ---------------------------------------------------------------------------
// Staging. Every edit is an operation replayed in order over the file state;
// the host re-validates every value (the native validator runs only on the
// Confirm route). A completion restage that equals what the page showed is not
// an operation, so opening and closing pages never writes a file.
// ---------------------------------------------------------------------------
struct StagedValue
{
	enum class Kind { Bool, Number, Text };
	Kind kind = Kind::Bool;
	bool boolean = false;
	double number = 0.0;
	std::string text;

	static StagedValue of_bool(bool value) { StagedValue staged; staged.kind = Kind::Bool; staged.boolean = value; return staged; }
	static StagedValue of_number(double value) { StagedValue staged; staged.kind = Kind::Number; staged.number = value; return staged; }
	static StagedValue of_text(std::string value) { StagedValue staged; staged.kind = Kind::Text; staged.text = std::move(value); return staged; }
};

// Click: the bridge's value-changed callback (a player's action). Restage: the
// completion pass of a closing page (what the rows hold).
enum class StageSource { Restage, Click };

struct Operation
{
	enum class Kind { Value, Stored, Active, Reset };
	Kind kind = Kind::Value;
	std::string folder_key;
	std::string target;   // value id, or the reset scope after the folder
	double number = 0.0;
	bool boolean = false;
};

struct Session
{
	std::vector<Operation> operations;
	std::size_t resets = 0;
};

struct ParsedSetting
{
	std::string prefix;
	std::string folder_key;
	std::string rest;
};

inline ParsedSetting parse_setting(std::string_view setting)
{
	ParsedSetting parsed;
	const auto colon = setting.find(':');
	if (colon == std::string_view::npos) return parsed;
	parsed.prefix = std::string(setting.substr(0, colon));
	const auto body = setting.substr(colon + 1);
	const auto slash = body.find('/');
	parsed.folder_key = std::string(slash == std::string_view::npos ? body : body.substr(0, slash));
	if (slash != std::string_view::npos) parsed.rest = std::string(body.substr(slash + 1));
	return parsed;
}

inline const PackageView* find_view(const std::vector<PackageView>& views, std::string_view key)
{
	for (const auto& view : views)
		if (folder_key(view.folder) == key && view.declarations != nullptr) return &view;
	return nullptr;
}

inline bool parse_number_text(std::string_view text, double& value) noexcept
{
	while (!text.empty() && text.front() == ' ') text.remove_prefix(1);
	while (!text.empty() && text.back() == ' ') text.remove_suffix(1);
	if (text.empty() || text.size() > 32) return false;
	if (text.front() == '+') text.remove_prefix(1);
	const auto result = std::from_chars(text.data(), text.data() + text.size(), value);
	return result.ec == std::errc{} && result.ptr == text.data() + text.size() && std::isfinite(value);
}

// The values a reset scope covers: "<Folder>", "<Folder>/node:<node id>",
// "<Folder>/value:<value id>" or (older pages) "<Folder>/<group id>".
inline std::vector<const settings::ValueDecl*> scope_values(const PackageView& view, std::string_view rest)
{
	std::vector<const settings::ValueDecl*> values;
	if (view.declarations == nullptr) return values;
	if (rest.empty())
	{
		for (const auto& value : view.declarations->values) values.push_back(&value);
	}
	else if (rest.substr(0, 5) == "node:")
	{
		const auto tree = build_tree(*view.declarations);
		if (const auto* node = find_node(tree, rest.substr(5)); node != nullptr && !node->id.empty())
			collect_values(tree, *node, values);
	}
	else if (rest.substr(0, 6) == "value:")
	{
		if (const auto* value = view.declarations->value(rest.substr(6))) values.push_back(value);
	}
	else
	{
		for (const auto& value : view.declarations->values)
			if (value.group == rest) values.push_back(&value);
	}
	return values;
}

// An entry that turns on must also apply: a package on use_stock or a section
// switched off (files written before R7; the UI no longer has those switches)
// is switched back on, and every other entry that was not applying because of
// it is turned off, so nothing else starts to apply.
inline void make_effective(settings::UserState& state, const settings::Declarations& declarations,
	const settings::ValueDecl& declaration)
{
	if (state.use_stock)
	{
		for (auto& [id, entry] : state.values) if (id != declaration.id) entry.enabled = false;
		state.use_stock = false;
	}
	if (!group_enabled(state, declaration.group))
	{
		for (auto& [id, entry] : state.values)
		{
			const auto* other = declarations.value(id);
			if (id != declaration.id && other != nullptr && other->group == declaration.group) entry.enabled = false;
		}
		state.groups[declaration.group] = true;
	}
}

inline settings::UserValue& entry_for(settings::UserState& state, const settings::ValueDecl& declaration)
{
	auto& entry = state.values[declaration.id];
	if (!entry.shape_valid || !entry.has_value)
	{
		entry = settings::UserValue{};
		entry.has_value = true;
		entry.value = default_value(declaration);
	}
	return entry;
}

inline void replay(settings::UserState& state, const PackageView& view, const Operation& operation)
{
	const auto& declarations = *view.declarations;
	if (operation.kind == Operation::Kind::Reset)
	{
		for (const auto* declaration : scope_values(view, operation.target))
		{
			const auto found = state.values.find(declaration->id);
			if (found == state.values.end()) continue;
			found->second = settings::UserValue{};
			found->second.enabled = false;
			found->second.has_value = true;
			found->second.value = default_value(*declaration);
		}
		return;
	}
	const auto* declaration = declarations.value(operation.target);
	if (declaration == nullptr) return;
	const bool existed = state.values.count(declaration->id) != 0;
	if (operation.kind == Operation::Kind::Value)
	{
		const bool enabled = operation.number != default_value(*declaration);
		if (!existed && !enabled) return;
		auto& entry = entry_for(state, *declaration);
		entry.value = operation.number;
		entry.enabled = enabled;
		if (enabled) make_effective(state, declarations, *declaration);
	}
	else if (operation.kind == Operation::Kind::Stored)
	{
		if (!existed && operation.number == default_value(*declaration)) return;
		auto& entry = entry_for(state, *declaration);
		entry.value = operation.number;
	}
	else if (operation.kind == Operation::Kind::Active)
	{
		if (!existed && !operation.boolean) return;
		auto& entry = entry_for(state, *declaration);
		if (!existed)
		{
			if (const auto* built = built_option(*declaration)) entry.value = built->value;
		}
		entry.enabled = operation.boolean;
		if (operation.boolean) make_effective(state, declarations, *declaration);
	}
}

// Session replayed over the current state: what the next page shows and what
// the root close writes.
inline settings::UserState overlaid_state(const Session& session, const PackageView& view)
{
	auto state = view.state;
	const std::string key = folder_key(view.folder);
	state.package = "package:" + key;
	if (view.declarations != nullptr) state.build = view.declarations->build;
	if (view.declarations == nullptr) return state;
	for (const auto& operation : session.operations)
		if (operation.folder_key == key) replay(state, view, operation);
	return state;
}

inline bool touches(const Session& session, const PackageView& view)
{
	const auto key = folder_key(view.folder);
	return std::any_of(session.operations.begin(), session.operations.end(),
		[&](const Operation& operation) { return operation.folder_key == key; });
}

inline std::vector<PackageView> overlay(const Session& session, std::vector<PackageView> views)
{
	for (auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		view.state = overlaid_state(session, view);
		// An edit of a package with a malformed file writes a valid file.
		if (touches(session, view)) view.file_malformed = false;
	}
	return views;
}

// Returns an empty string when the staged value is accepted (an unchanged
// completion restage is accepted and records nothing).
inline std::string stage(
	Session& session, const std::vector<PackageView>& views,
	std::string_view setting, const StagedValue& value,
	StageSource source = StageSource::Restage)
{
	// R7: a click and a restage are the same edit; an unchanged value is none.
	(void)source;
	const auto parsed = parse_setting(setting);
	const auto* view = find_view(views, parsed.folder_key);
	if (view == nullptr) return "unknown-setting";
	const auto* declaration = view->declarations->value(parsed.rest);
	if (declaration == nullptr) return "unknown-setting";
	Operation operation;
	operation.folder_key = parsed.folder_key;
	operation.target = declaration->id;
	PackageView current = *view;
	current.state = overlaid_state(session, *view);
	if (touches(session, *view)) current.file_malformed = false;
	if (parsed.prefix == "active")
	{
		if (value.kind != StagedValue::Kind::Bool) return "wrong-type";
		const bool legacy_literal = declaration->lane == settings::Lane::Literal
			&& declaration->type != settings::ValueType::Enum;
		if (declaration->quick.empty() && !legacy_literal) return "unknown-setting";
		if (declaration->lane == settings::Lane::Metadata) return "read-only-row";
		if (value.boolean == entry_applies(current, *declaration)) return {};
		operation.kind = Operation::Kind::Active;
		operation.boolean = value.boolean;
	}
	else if (parsed.prefix == "value" || parsed.prefix == "stored")
	{
		if (declaration->lane == settings::Lane::Metadata) return "read-only-row";
		if (declaration->lane == settings::Lane::Literal && declaration->type != settings::ValueType::Enum)
			return "read-only-row";
		if (parsed.prefix == "stored" && (declaration->quick.empty() || declaration->lane != settings::Lane::Addon))
			return "unknown-setting";
		double number = 0.0;
		if (value.kind == StagedValue::Kind::Number) number = value.number;
		else if (value.kind == StagedValue::Kind::Text)
		{
			if (!parse_number_text(value.text, number)) return "not-a-number";
		}
		else return "wrong-type";
		if (auto reason = settings::validate_value(*declaration, number); !reason.empty()) return reason;
		// What the row showed: an unchanged restage (or click) is not an edit.
		const double shown = parsed.prefix == "stored" ? kept_value(current, *declaration) : current_value(current, *declaration);
		if (number == shown) return {};
		operation.kind = parsed.prefix == "stored" ? Operation::Kind::Stored : Operation::Kind::Value;
		operation.number = number;
	}
	else
	{
		// package:, member:, stock:, group: and custom: rows no longer exist (R7).
		return "unknown-setting";
	}
	session.operations.push_back(std::move(operation));
	return {};
}

// Reset scope after "reset:" / "resetall:" / (older pages) "restore:".
inline bool reset(Session& session, const std::vector<PackageView>& views, std::string_view scope)
{
	const auto slash = scope.find('/');
	const auto folder = scope.substr(0, slash);
	const auto* view = find_view(views, folder_key(folder));
	if (view == nullptr) return false;
	const auto rest = slash == std::string_view::npos ? std::string_view() : scope.substr(slash + 1);
	if (slash != std::string_view::npos && scope_values(*view, rest).empty()) return false;
	Operation operation;
	operation.kind = Operation::Kind::Reset;
	operation.folder_key = folder_key(folder);
	operation.target = std::string(rest);
	session.operations.push_back(std::move(operation));
	++session.resets;
	return true;
}

inline void restore(Session& session, const std::vector<PackageView>& views, std::string_view scope)
{
	(void)reset(session, views, scope);
}

struct AppliedPackage
{
	std::string folder;
	settings::UserState state;
	const settings::Declarations* declarations = nullptr;
};

struct Applied
{
	std::vector<AppliedPackage> packages;               // values files to write
	std::vector<std::pair<std::string, bool>> policy;   // ScriptStates.json batch (never used since R7)
};

inline bool same_state(const settings::UserState& lhs, const settings::UserState& rhs)
{
	if (lhs.use_stock != rhs.use_stock || lhs.groups != rhs.groups || lhs.values.size() != rhs.values.size())
		return false;
	for (const auto& [id, value] : lhs.values)
	{
		const auto other = rhs.values.find(id);
		if (other == rhs.values.end() || other->second.shape_valid != value.shape_valid
			|| other->second.enabled != value.enabled || other->second.has_value != value.has_value
			|| (value.has_value && other->second.value != value.value))
		{
			return false;
		}
	}
	return true;
}

// A file written by SCRIPT SETTINGS: no use_stock, every declared section on,
// and every entry that did not apply because of those switches turned off.
inline settings::UserState normalized(settings::UserState state, const settings::Declarations& declarations)
{
	for (auto& [id, entry] : state.values)
	{
		const auto* declaration = declarations.value(id);
		if (declaration == nullptr) continue;
		if (state.use_stock || !group_enabled(state, declaration->group)) entry.enabled = false;
	}
	state.use_stock = false;
	for (const auto& group : declarations.groups) state.groups[group.id] = true;
	return state;
}

inline Applied apply(const Session& session, const std::vector<PackageView>& views)
{
	Applied applied;
	for (const auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		// Only a real difference writes the values file: opening and closing the
		// screen is a no-op, and a hand-edited malformed file is replaced only
		// by an actual edit.
		auto state = overlaid_state(session, view);
		if (!same_state(state, view.state))
			applied.packages.push_back(AppliedPackage{view.folder, normalized(std::move(state), *view.declarations), view.declarations});
	}
	return applied;
}
}
