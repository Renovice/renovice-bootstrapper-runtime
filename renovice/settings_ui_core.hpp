#pragma once

// SCRIPT SETTINGS pause-menu editor: pure page model and staging (2026-09-30).
//
// Contract: INGAME_EDITOR_DESIGN.md sections 4.2-4.6. The host (injection.cpp)
// turns a Page into plain DE Luau row descriptors; the compiled bridge
// (RENOVICE_SCRIPTING/INTERNAL/ScriptSettingsBridgeV1.luau) maps them onto the
// stock GenericSettings row types TITLE, SPACER, CHECKBOX, INPUTCOUNT, INPUTBOX,
// TOGGLE and BUTTON. Nothing here is Pluto, an overlay or a custom movie.
//
// Row setting ids (the value-changed callback receives them as mSetting):
//   package:<folder lower>            package enable (ScriptStates.json)
//   member:<folder lower>/<file lower> member enable  (ScriptStates.json)
//   stock:<folder lower>              master "Use stock values"
//   group:<folder lower>/<group id>   section switch
//   custom:<folder lower>/<value id>  per-value "Custom" switch
//   value:<folder lower>/<value id>   the value editor
// BUTTON actions: open:val:<Folder>/<value id> (every layout: the one-value
// INPUTCOUNT or INPUTBOX page, see "Stock scroll contract" below and
// uses_value_page), open:pkg:<Folder>,
// open:grp:<Folder>/<group>, restore:<Folder> and restore:<Folder>/<group>
// (nested layout only).

#include <algorithm>
#include <cctype>
#include <charconv>
#include <cmath>
#include <cstdio>
#include <map>
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
// TOGGLE, BUTTON and INPUTCOUNT default), and an INPUTBOX editor never shares
// a list page: it lives alone on its one-value page ("val:" page id).
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
	while (!text.empty() && text.back() == ' ') text.pop_back();
	return text;
}

inline std::string bounded_tooltip(std::string text)
{
	text = clean(text);
	if (text.size() <= maximum_tooltip) return text;
	return fit_words(text, maximum_tooltip);
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
			if (option.value == value) return option.label;
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

inline std::string custom_label(std::string_view label)
{
	const std::string full = "Custom " + clean(label);
	return full.size() <= maximum_row_label ? full : fit_words(clean(label), maximum_row_label);
}

inline std::string editor_label(const settings::ValueDecl& declaration)
{
	const std::string full = clean(declaration.label) + " (stock " + with_unit(declaration, declaration.stock) + ")";
	return full.size() <= maximum_row_label ? full : fit_words(declaration.label, maximum_row_label);
}

// The tooltip always starts with the stock value (CONTRACT_PHASE1 D1: when
// the "(stock ...)" suffix does not fit the 40-character label, this is where
// the player reads it), then the range, the scope and the apply timing. The
// live-stock sentence is derived from the declaration (`stock_check`): only an
// addon that compares the live value with stock before writing says so.
inline constexpr std::string_view live_stock_sentence = " Custom value applies only where the live value equals stock.";

inline std::string value_tooltip(const settings::ValueDecl& declaration)
{
	std::string text = "Stock " + with_unit(declaration, declaration.stock) + ".";
	if (declaration.type != settings::ValueType::Enum)
	{
		text += " Range " + display_number(declaration.minimum) + " to "
			+ display_number(declaration.maximum) + ".";
	}
	if (!declaration.scope.empty()) text += " " + clean(declaration.scope) + ".";
	if (declaration.lane == settings::Lane::Literal)
		text += " Edited in Ability Studio; this switch applies the edited script at the next mission.";
	else if (declaration.lane == settings::Lane::Metadata)
		text += " Metadata value: read-only here; applies after a game restart.";
	else
	{
		text += " Applies: " + applies_text(declaration.applies) + ".";
		if (declaration.stock_check == settings::StockCheck::Live) text += live_stock_sentence;
	}
	return bounded_tooltip(text);
}

inline std::size_t custom_count(const PackageView& view, std::string_view group)
{
	if (view.declarations == nullptr) return 0;
	std::size_t count = 0;
	for (const auto& declaration : view.declarations->values)
	{
		if (!group.empty() && declaration.group != group) continue;
		const auto entry = view.state.values.find(declaration.id);
		if (entry != view.state.values.end() && entry->second.shape_valid && entry->second.enabled) ++count;
	}
	return count;
}

inline std::size_t value_count(const PackageView& view, std::string_view group)
{
	if (view.declarations == nullptr) return 0;
	return static_cast<std::size_t>(std::count_if(view.declarations->values.begin(),
		view.declarations->values.end(), [&](const settings::ValueDecl& declaration)
		{
			return group.empty() || declaration.group == group;
		}));
}

inline std::string summary(std::size_t values, std::size_t custom)
{
	return std::to_string(values) + (values == 1 ? " value - " : " values - ")
		+ std::to_string(custom) + " custom";
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

// BUTTON rows never carry a stock sub-label (R3). The stock draw callback
// (ThemedGenericSettings 44.0.2, source line 991) places mSubLabel at
// `mButtonWidth - (mSubLabelOffset or 100)`, and stock screens that use it
// always set mButtonWidth (ThemedTennoCustomization: 400). A BUTTON with a
// sub-label and no width raised a nil arithmetic error that aborted the List
// redraw and the panel layout (live, bridge 2e337a43). The detail (a current
// value or a section summary) is therefore part of the label: "<label>:
// <detail>" within the 40-character row, cutting the label, never the detail.
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

inline Row button(std::string label, std::string action, std::string detail, std::string tooltip)
{
	Row row;
	row.kind = RowKind::Button;
	row.label = button_label(label, detail);
	row.action = std::move(action);
	row.setting = "action:" + row.action;
	const std::string shown = clean(detail);
	const bool detail_shown = shown.empty()
		|| (row.label.size() >= shown.size() + 2 && row.label.compare(row.label.size() - shown.size() - 2, std::string::npos, ": " + shown) == 0);
	row.tooltip = bounded_tooltip(detail_shown ? std::move(tooltip) : shown + ". " + tooltip);
	return row;
}

inline bool group_enabled(const PackageView& view, std::string_view group)
{
	const auto found = view.state.groups.find(std::string(group));
	return found == view.state.groups.end() || found->second;
}

// Every number is edited on its own one-value page (R4). Floats and negative
// integers use an INPUTBOX, which the stock scroll contract forbids on a list
// page. Integers >= 0 use the stock INPUTCOUNT stepper, which cannot live on a
// recycled (scrolled) list: stock builds its Minus/Count/Plus widgets once per
// row, bound to the clip of the first draw (ThemedGenericSettings 44.0.2
// source lines 1081-1152), while CHECKBOX and TOGGLE are rebuilt on every
// scrolled draw (lines 878-880, 927-929). A scrolled INPUTCOUNT showed an
// uninitialised count field (raw "SELECT ITEMS", `size="19" color`, "Hold to
// clear"), and after a search filter the per-frame count poll (line 1627 ->
// 1474) indexed a row copy without mCountButton (live EE.log 2026-09-30). On
// a one-row page the INPUTCOUNT is drawn once in its own clip, like stock.
inline bool uses_value_page(const settings::ValueDecl& declaration) noexcept
{
	return declaration.type == settings::ValueType::Float || declaration.type == settings::ValueType::Int;
}

inline double current_value(const PackageView& view, const settings::ValueDecl& declaration)
{
	const auto entry = view.state.values.find(declaration.id);
	if (entry != view.state.values.end() && entry->second.shape_valid && entry->second.has_value
		&& settings::validate_value(declaration, entry->second.value).empty())
	{
		return entry->second.value;
	}
	return declaration.stock;
}

inline std::string value_page_action(const PackageView& view, const settings::ValueDecl& declaration)
{
	return "open:val:" + view.folder + "/" + declaration.id;
}

// The stock value editor of one value: TOGGLE (enum, inline), or on the value
// page INPUTCOUNT (int >= 0) or a validated INPUTBOX (float, negative int).
inline Row value_editor(const PackageView& view, const settings::ValueDecl& declaration)
{
	const double current = current_value(view, declaration);
	Row editor;
	editor.label = editor_label(declaration);
	editor.setting = "value:" + folder_key(view.folder) + "/" + declaration.id;
	editor.tooltip = value_tooltip(declaration);
	editor.minimum = declaration.minimum;
	editor.maximum = declaration.maximum;
	editor.integer = declaration.type != settings::ValueType::Float;
	editor.locked = declaration.lane != settings::Lane::Addon;
	editor.invalid_message = fit_words(clean(declaration.label), 40) + ": enter "
		+ (editor.integer ? "a whole number" : "a number") + " from "
		+ display_number(declaration.minimum) + " to "
		+ display_number(declaration.maximum) + ".";
	if (declaration.type == settings::ValueType::Enum)
	{
		editor.kind = RowKind::Toggle;
		editor.number = current;
		for (const auto& option : declaration.options)
			editor.options.push_back(ToggleOption{fit_words(option.label, maximum_row_label), option.value});
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

// Label of the BUTTON that opens a value page: "<label>: <current> (stock
// <stock>)" when it fits the row, else "<label>: <current>" (the tooltip
// always starts with the stock value). The value is as of this page build (the
// stock list is built once per open).
inline std::string value_button_label(const settings::ValueDecl& declaration, double current)
{
	const std::string value = with_unit(declaration, current);
	const std::string with_stock = clean(declaration.label) + ": " + value + " (stock "
		+ with_unit(declaration, declaration.stock) + ")";
	if (with_stock.size() <= maximum_row_label) return with_stock;
	return button_label(declaration.label, value);
}

// The per-value pair: "Custom <label>" CHECKBOX, then either the enum TOGGLE
// (rebuilt by stock on every scrolled draw, list-safe) or a BUTTON showing the
// current value (value_button_label) that opens the value's one-value page
// (INPUTCOUNT or INPUTBOX). The BUTTON is never locked: stock dims a locked
// row's Label (source line 1304, alpha 60) and never restores it, so on a
// recycled list the next row drawn into that clip stayed dimmed. The value
// page's editor carries the lock (read-only lanes) instead.
inline void append_value_rows(std::vector<Row>& rows, const PackageView& view, const settings::ValueDecl& declaration)
{
	const std::string key = folder_key(view.folder);
	const auto entry = view.state.values.find(declaration.id);
	const bool enabled = entry != view.state.values.end() && entry->second.shape_valid && entry->second.enabled;
	const std::string tooltip = value_tooltip(declaration);
	auto custom = checkbox(custom_label(declaration.label), "custom:" + key + "/" + declaration.id, enabled,
		"Off: the stock value is used. " + tooltip);
	custom.locked = declaration.lane == settings::Lane::Metadata;
	rows.push_back(std::move(custom));

	if (!uses_value_page(declaration))
	{
		rows.push_back(value_editor(view, declaration));
		return;
	}
	Row open;
	open.kind = RowKind::Button;
	open.label = value_button_label(declaration, current_value(view, declaration));
	open.action = value_page_action(view, declaration);
	open.setting = "action:" + open.action;
	open.tooltip = tooltip;
	open.locked = false;
	rows.push_back(std::move(open));
}

// One-value page (page id "val:<Folder>/<value id>"): the value's stock
// editor alone (INPUTCOUNT for int >= 0, validated INPUTBOX otherwise). Its
// close stages the value; the root close applies.
inline Page build_value_page(const PackageView& view, std::string_view value_id)
{
	Page page;
	page.empty_message = "NO SETTINGS";
	if (view.declarations == nullptr) return page;
	const auto* declaration = view.declarations->value(value_id);
	if (declaration == nullptr || !uses_value_page(*declaration)) return page;
	page.title = fit_words(upper(declaration->label), maximum_title_label);
	page.rows.push_back(value_editor(view, *declaration));
	return page;
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

// Member switch label: the manifest label when it fits the row. A longer label
// (the loader allows 128) is cut at a word boundary without the dangling list
// punctuation ("Mission tunables: Purgatory," read as a broken sentence); the
// full label always opens the tooltip. Producers should keep labels within 40.
inline std::string member_row_label(const MemberView& member)
{
	std::string label = clean(member.label.empty() ? member.filename : member.label);
	if (label.size() <= maximum_row_label) return label;
	label = fit_words(std::move(label), maximum_row_label);
	while (!label.empty() && std::string_view(" ,;:(-/").find(label.back()) != std::string_view::npos)
		label.pop_back();
	return label.empty() ? fit_words(member.filename, maximum_row_label) : label;
}

// Member tooltip: full label, what the switch does, the file, and the values
// the member declares per section (derived from the declarations, so every
// package gets the detail without extra manifest fields).
inline std::string member_tooltip(const PackageView& view, const MemberView& member)
{
	std::string text = clean(member.label.empty() ? member.filename : member.label);
	if (!text.empty() && text.back() != '.') text += '.';
	if (member.replacement) text += " Replaces a stock script.";
	text += " Off: this script stays out of the package. File: " + clean(member.filename) + ".";
	if (view.declarations == nullptr) return bounded_tooltip(text);
	const std::string member_key = script_control::ascii_lower(member.filename);
	std::size_t total = 0;
	std::string sections;
	std::size_t section_count = 0;
	for (const auto* group : ordered_groups(*view.declarations))
	{
		const auto count = static_cast<std::size_t>(std::count_if(view.declarations->values.begin(),
			view.declarations->values.end(), [&](const settings::ValueDecl& declaration)
			{
				return declaration.group == group->id && script_control::ascii_lower(declaration.member) == member_key;
			}));
		if (count == 0) continue;
		total += count;
		++section_count;
		sections += (sections.empty() ? "" : ", ") + clean(group->label) + " (" + std::to_string(count) + ")";
	}
	if (total == 0) return bounded_tooltip(text);
	const std::string detailed = " Sections: " + sections + ".";
	const std::string compact = " Sections: " + std::to_string(section_count) + " (" + std::to_string(total)
		+ (total == 1 ? " value)." : " values).");
	return bounded_tooltip(text + (text.size() + detailed.size() <= maximum_tooltip ? detailed : compact));
}

inline void append_package_switches(std::vector<Row>& rows, const PackageView& view, bool with_title)
{
	const std::string key = folder_key(view.folder);
	if (with_title) rows.push_back(title(view.display));
	rows.push_back(checkbox(clean(view.display) + " package", "package:" + key, view.package_enabled,
		"Turns the whole package on or off (same switch as the SCRIPTS row)."));
	rows.push_back(checkbox("Use stock values", "stock:" + key, view.state.use_stock,
		"On: every value of this package is stock. Your custom values are kept for later."));
	if (view.file_malformed)
	{
		auto note = checkbox("Values file invalid, using stock", "note:" + key, false,
			"Settings/" + view.folder + ".json was rejected (" + view.file_reason
				+ "). Saving from this screen writes a new file.");
		note.locked = true;
		rows.push_back(std::move(note));
	}
	if (view.members.size() > 1)
	{
		for (const auto& member : view.members)
		{
			rows.push_back(checkbox(member_row_label(member), member.state_id, member.enabled,
				member_tooltip(view, member)));
		}
	}
}

inline void append_group_rows(std::vector<Row>& rows, const PackageView& view, const settings::GroupDecl& group, bool with_title)
{
	const std::string key = folder_key(view.folder);
	if (with_title) rows.push_back(title(group.label));
	const std::string section_label = "Custom " + clean(group.label) + " values";
	rows.push_back(checkbox(section_label.size() <= maximum_row_label ? section_label : std::string("Custom values in this section"),
		"group:" + key + "/" + group.id, group_enabled(view, group.id),
		"Off: every value in " + clean(group.label) + " is stock. Your custom values are kept."));
	for (const auto& declaration : view.declarations->values)
	{
		if (declaration.group == group.id) append_value_rows(rows, view, declaration);
	}
}

// The stock search box stays off (R4). The stock filter (ThemedGenericSettings
// 44.0.2 source lines 685-709) rebuilds the list from copies taken at populate
// (lines 1656-1678): a row edited before typing shows its old value again and
// the completion pass would stage that old value. Live 2026-09-30 the filter
// also re-added an INPUTCOUNT row copy without widgets, the per-frame count
// poll raised a script error and the screen could not be left.
inline constexpr bool stock_search_box = false;

// Default layout: one flat list with TITLE sections. Its only BUTTON rows
// open one-value pages (open:val:); it has no package/section navigation,
// Restore or FinishSelection buttons.
inline Page build_flat_page(const std::vector<PackageView>& views)
{
	Page page;
	page.title = "SCRIPT SETTINGS";
	page.search = stock_search_box;
	page.empty_message = "NO PACKAGE SETTINGS FOUND";
	// No SPACER rows: under the stock scroll contract every row takes one 43 px
	// slot of the 14 visible, and each package and section already starts with
	// a TITLE row.
	for (const auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		append_package_switches(page.rows, view, true);
		for (const auto* group : ordered_groups(*view.declarations))
		{
			if (value_count(view, group->id) == 0) continue;
			append_group_rows(page.rows, view, *group, true);
		}
	}
	return page;
}

// Nested layout (behind SettingsMenuNested=true until gate N-1 passes live).
inline Page build_root_page(const std::vector<PackageView>& views)
{
	Page page;
	page.title = "SCRIPT SETTINGS";
	page.empty_message = "NO PACKAGE SETTINGS FOUND";
	page.rows.push_back(title("Packages"));
	for (const auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		page.rows.push_back(button(clean(view.display), "open:pkg:" + view.folder,
			summary(value_count(view, {}), custom_count(view, {})),
			"Open the settings of " + clean(view.display) + "."));
	}
	return page;
}

inline Page build_package_page(const PackageView& view)
{
	Page page;
	page.title = fit_words(upper(view.display), maximum_title_label);
	if (view.declarations == nullptr) return page;
	append_package_switches(page.rows, view, true);
	page.rows.push_back(spacer());
	page.rows.push_back(title("Sections"));
	for (const auto* group : ordered_groups(*view.declarations))
	{
		const auto values = value_count(view, group->id);
		if (values == 0) continue;
		page.rows.push_back(button(clean(group->label), "open:grp:" + view.folder + "/" + group->id,
			summary(values, custom_count(view, group->id)),
			group->aliases.empty() ? "Open " + clean(group->label) + "."
				: "Open " + clean(group->label) + ". Also: " + [&]()
				{
					std::string aliases;
					for (const auto& alias : group->aliases)
					{
						if (aliases.size() + alias.size() > 160) break;
						aliases += (aliases.empty() ? "" : ", ") + clean(alias);
					}
					return aliases;
				}()));
	}
	page.rows.push_back(spacer());
	page.rows.push_back(button("Restore all stock values", "restore:" + view.folder, "",
		"Unticks every Custom switch of this package and returns. Your values are kept."));
	return page;
}

inline Page build_group_page(const PackageView& view, std::string_view group_id)
{
	Page page;
	page.search = stock_search_box;
	if (view.declarations == nullptr) return page;
	const auto* group = view.declarations->group(group_id);
	if (group == nullptr) return page;
	page.title = fit_words(upper(group->label), maximum_title_label);
	append_group_rows(page.rows, view, *group, false);
	page.rows.push_back(spacer());
	const std::string restore_label = "Restore " + clean(group->label) + " stock values";
	page.rows.push_back(button(restore_label.size() <= maximum_row_label ? restore_label : std::string("Restore stock values"),
		"restore:" + view.folder + "/" + group->id, "",
		"Unticks every Custom switch in " + clean(group->label) + " and returns. Your values are kept."));
	return page;
}

// ---------------------------------------------------------------------------
// Staging. The host re-validates every value (the native validator runs only
// on the Confirm route and cannot see filtered copies).
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

struct Session
{
	std::map<std::string, StagedValue> staged;
	std::vector<std::string> restores; // "<Folder>" or "<Folder>/<group>"
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

// Returns an empty string when the staged value is accepted.
inline std::string stage(
	Session& session, const std::vector<PackageView>& views,
	std::string_view setting, const StagedValue& value)
{
	const auto parsed = parse_setting(setting);
	const auto* view = find_view(views, parsed.folder_key);
	if (view == nullptr) return "unknown-setting";
	if (parsed.prefix == "package" || parsed.prefix == "stock")
	{
		if (!parsed.rest.empty()) return "unknown-setting";
		if (value.kind != StagedValue::Kind::Bool) return "wrong-type";
	}
	else if (parsed.prefix == "member")
	{
		if (value.kind != StagedValue::Kind::Bool) return "wrong-type";
		if (std::none_of(view->members.begin(), view->members.end(),
			[&](const MemberView& member) { return member.state_id == setting; }))
		{
			return "unknown-setting";
		}
	}
	else if (parsed.prefix == "group")
	{
		if (value.kind != StagedValue::Kind::Bool) return "wrong-type";
		if (view->declarations->group(parsed.rest) == nullptr) return "unknown-setting";
	}
	else if (parsed.prefix == "custom" || parsed.prefix == "value")
	{
		const auto* declaration = view->declarations->value(parsed.rest);
		if (declaration == nullptr) return "unknown-setting";
		if (parsed.prefix == "custom")
		{
			if (value.kind != StagedValue::Kind::Bool) return "wrong-type";
			if (declaration->lane == settings::Lane::Metadata) return "read-only-row";
		}
		else
		{
			if (declaration->lane != settings::Lane::Addon) return "read-only-row";
			double number = 0.0;
			if (value.kind == StagedValue::Kind::Number) number = value.number;
			else if (value.kind == StagedValue::Kind::Text)
			{
				if (!parse_number_text(value.text, number)) return "not-a-number";
			}
			else return "wrong-type";
			if (auto reason = settings::validate_value(*declaration, number); !reason.empty()) return reason;
			session.staged[std::string(setting)] = StagedValue::of_number(number);
			return {};
		}
	}
	else
	{
		return "unknown-setting";
	}
	session.staged[std::string(setting)] = value;
	return {};
}

inline void restore(Session& session, const std::vector<PackageView>& views, std::string_view scope)
{
	const auto slash = scope.find('/');
	const auto folder = scope.substr(0, slash);
	if (find_view(views, folder_key(folder)) == nullptr) return;
	session.restores.emplace_back(scope);
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
	std::vector<std::pair<std::string, bool>> policy;   // ScriptStates.json batch
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

// Session overlaid on the current state: what the next page should show and
// what the root close writes. Staged rows first, restores last (a Restore
// always wins over the rows the bridge restages at close).
inline settings::UserState overlaid_state(const Session& session, const PackageView& view)
{
	auto state = view.state;
	const std::string key = folder_key(view.folder);
	state.package = "package:" + key;
	if (view.declarations != nullptr) state.build = view.declarations->build;
	for (const auto& [setting, staged] : session.staged)
	{
		const auto parsed = parse_setting(setting);
		if (parsed.folder_key != key) continue;
		if (parsed.prefix == "stock") state.use_stock = staged.boolean;
		else if (parsed.prefix == "group")
		{
			const bool current = group_enabled(view, parsed.rest);
			if (staged.boolean != current || state.groups.count(parsed.rest)) state.groups[parsed.rest] = staged.boolean;
		}
		else if (parsed.prefix == "custom" || parsed.prefix == "value")
		{
			const auto* declaration = view.declarations->value(parsed.rest);
			if (declaration == nullptr) continue;
			auto entry = state.values.find(parsed.rest);
			if (entry == state.values.end() || !entry->second.shape_valid)
			{
				// Creating an entry only when it changes something: an untouched
				// stock row restaged at close must not write a file.
				const bool becomes_custom = parsed.prefix == "custom" && staged.boolean;
				const bool non_stock_value = parsed.prefix == "value" && staged.number != declaration->stock;
				if (!becomes_custom && !non_stock_value) continue;
				settings::UserValue fresh;
				fresh.enabled = false;
				fresh.has_value = true;
				fresh.value = declaration->stock;
				entry = state.values.insert_or_assign(parsed.rest, fresh).first;
			}
			if (parsed.prefix == "custom") entry->second.enabled = staged.boolean;
			else
			{
				entry->second.has_value = true;
				entry->second.value = staged.number;
			}
		}
	}
	for (const auto& scope : session.restores)
	{
		const auto slash = scope.find('/');
		if (folder_key(std::string_view(scope).substr(0, slash)) != key) continue;
		const std::string group = slash == std::string::npos ? std::string() : scope.substr(slash + 1);
		for (auto& [id, value] : state.values)
		{
			const auto* declaration = view.declarations->value(id);
			if (declaration != nullptr && (group.empty() || declaration->group == group)) value.enabled = false;
		}
	}
	return state;
}

inline std::vector<PackageView> overlay(const Session& session, std::vector<PackageView> views)
{
	for (auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		view.state = overlaid_state(session, view);
		const std::string key = folder_key(view.folder);
		if (const auto staged = session.staged.find("package:" + key); staged != session.staged.end())
			view.package_enabled = staged->second.boolean;
		for (auto& member : view.members)
		{
			if (const auto staged = session.staged.find(member.state_id); staged != session.staged.end())
				member.enabled = staged->second.boolean;
		}
	}
	return views;
}

inline Applied apply(const Session& session, const std::vector<PackageView>& views)
{
	Applied applied;
	for (const auto& view : views)
	{
		if (view.declarations == nullptr) continue;
		const std::string key = folder_key(view.folder);
		// Only a real difference writes the values file: opening and closing the
		// screen (the bridge restages every visible row) is a no-op, and a
		// hand-edited malformed file is replaced only by an actual edit.
		auto state = overlaid_state(session, view);
		if (!same_state(state, view.state))
			applied.packages.push_back(AppliedPackage{view.folder, std::move(state), view.declarations});
		if (const auto staged = session.staged.find("package:" + key);
			staged != session.staged.end() && staged->second.boolean != view.package_enabled)
		{
			applied.policy.emplace_back("package:" + key, staged->second.boolean);
		}
		for (const auto& member : view.members)
		{
			const auto staged = session.staged.find(member.state_id);
			if (staged != session.staged.end() && staged->second.boolean != member.enabled)
				applied.policy.emplace_back(member.state_id, staged->second.boolean);
		}
	}
	return applied;
}
}
