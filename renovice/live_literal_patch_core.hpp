#pragma once

// LIVE_LITERALS_V1 shared patch core (2026-09-30; R11 coupled sites).
//
// The exact-literal site rules of the RENOVICE mission editor, shared by the
// build-time generator (ability-editor, exact replacement builder and recipe
// emitter) and the runtime host (bootstrapper, replacement synthesis at
// apply). This file is kept BYTE-IDENTICAL in both repositories:
//   bootstrapper-runtime  renovice/live_literal_patch_core.hpp
//   ability-editor        include/renovice/live_literal_patch_core.hpp
// Both repositories pin its SHA-256 in a gate, so the two copies cannot drift.
//
// A site is one exact place in the stock DE Luau (U44) container that encodes a
// literal the game reads:
//   - Loadn: a 4-byte U44 LOADN instruction {0x08, register, imm16 LE}. The
//     value must encode as a whole number in 1..32767 (the positive range the
//     registrar proved safe for these sites). A site flagged
//     `rewrites_instruction` has another stock instruction (a carried-over,
//     separately verified linked-result site) that is rewritten into LOADN.
//   - NumberConstant: the 8-byte little-endian IEEE-754 double of a native
//     number constant (tag byte 2 directly before it). The value must be
//     finite. Editing a constant changes every user of it, so a constant site
//     is admissible only with the registrar's K_CONSTANT_EXCLUSIVE_V1 proof,
//     computed on the pinned stock bytes (the stock SHA-256 makes it binding).
// The operand of a site is `value * numerator / denominator`, or
// `numerator / value` for an inverse site. A master knob drives a row with a
// scale: the row value is `llround(master * scale)` for an integer row and
// `master * scale` otherwise.
// R11 (2026-09-30): a COUPLED site adds a fixed `value_offset` to the row
// value first: operand = (value + value_offset) * numerator / denominator (or
// numerator / (value + value_offset)). One row then keeps two stock literals
// in their stock relation, e.g. an escape timer 30 and its host-migration
// threshold 27 = 30 - 3 (offset -3). Every site keeps its own preimage and
// domain check; value_offset 0 is the plain site.
//
// Only the C++ standard library is used; nothing here reads a file, a game
// folder or a VM.

#include <array>
#include <bit>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>

namespace renovice::live_literal_patch
{
inline constexpr unsigned char u44_loadn_opcode = 0x08u;
inline constexpr unsigned char native_number_tag = 0x02u;
inline constexpr double loadn_minimum = 1.0;
inline constexpr double loadn_maximum = 32767.0;
inline constexpr const char* constant_exclusivity_gate = "K_CONSTANT_EXCLUSIVE_V1";

enum class SiteKind : std::uint8_t
{
	Loadn,
	NumberConstant,
};

struct Site
{
	SiteKind kind = SiteKind::Loadn;
	std::size_t offset = 0;
	std::array<unsigned char, 8> expected{};
	unsigned char reg = 0;
	bool rewrites_instruction = false;
	bool inverse = false;
	double numerator = 1.0;
	double denominator = 1.0;
	double value_offset = 0.0;  // R11 coupled site (0 = plain site)
};

enum class Error : std::uint8_t
{
	None,
	Extent,              // the site does not lie inside the body
	ConstantTag,         // no native number tag before a constant site
	ZeroDenominator,     // a non-inverse site with denominator 0
	PreimageChanged,     // the stock bytes differ from the recorded preimage
	NotLoadnOfRegister,  // a Loadn preimage is not LOADN of the recorded register
	OperandNotFinite,    // the operand of a constant site is not finite
	OperandOutOfDomain,  // the operand of a Loadn site is not a whole 1..32767
	StockDisagrees,      // the recorded stock value does not encode the preimage
	Overlap,             // two sites of one module share a byte
	UnexpectedChange,    // the patched body differs outside the permitted bytes
};

inline const char* error_text(Error error) noexcept
{
	switch (error)
	{
	case Error::None: return "none";
	case Error::Extent: return "site-extent-outside-body";
	case Error::ConstantTag: return "constant-tag-missing";
	case Error::ZeroDenominator: return "zero-denominator";
	case Error::PreimageChanged: return "preimage-changed";
	case Error::NotLoadnOfRegister: return "preimage-not-loadn-of-register";
	case Error::OperandNotFinite: return "operand-not-finite";
	case Error::OperandOutOfDomain: return "operand-outside-loadn-domain";
	case Error::StockDisagrees: return "stock-value-disagrees-with-preimage";
	case Error::Overlap: return "sites-overlap";
	case Error::UnexpectedChange: return "unexpected-byte-change";
	}
	return "unknown";
}

inline constexpr std::size_t width(SiteKind kind) noexcept
{
	return kind == SiteKind::NumberConstant ? 8u : 4u;
}

// The value a master knob gives one driven row.
inline double row_value(double master, double scale, bool integer_row) noexcept
{
	const double scaled = master * scale;
	return integer_row ? static_cast<double>(std::llround(scaled)) : scaled;
}

inline double operand(const Site& site, double value) noexcept
{
	const double coupled = value + site.value_offset;
	return site.inverse ? site.numerator / coupled : coupled * site.numerator / site.denominator;
}

// Domain of the encoded operand (no byte access).
inline Error operand_error(const Site& site, double value) noexcept
{
	const double exact = operand(site, value);
	if (site.kind == SiteKind::NumberConstant)
		return std::isfinite(exact) ? Error::None : Error::OperandNotFinite;
	if (!std::isfinite(exact) || exact < loadn_minimum || exact > loadn_maximum || std::floor(exact) != exact)
		return Error::OperandOutOfDomain;
	return Error::None;
}

// The replacement bytes of one site for `value`; `out` receives width(kind)
// bytes. Returns the operand domain error, if any.
inline Error encode(const Site& site, double value, std::array<unsigned char, 8>& out) noexcept
{
	out.fill(0);
	if (const Error error = operand_error(site, value); error != Error::None) return error;
	const double exact = operand(site, value);
	if (site.kind == SiteKind::NumberConstant)
	{
		const auto bits = std::bit_cast<std::uint64_t>(exact);
		for (std::size_t n = 0; n != 8; ++n) out[n] = static_cast<unsigned char>((bits >> (8 * n)) & 0xFFu);
		return Error::None;
	}
	const int whole = static_cast<int>(exact);
	out[0] = u44_loadn_opcode;
	out[1] = site.reg;
	out[2] = static_cast<unsigned char>(whole & 0xFF);
	out[3] = static_cast<unsigned char>((whole >> 8) & 0xFF);
	return Error::None;
}

// Structural checks that need no stock bytes: denominator, Loadn preimage shape.
inline Error shape_error(const Site& site) noexcept
{
	if (!site.inverse && site.denominator == 0.0) return Error::ZeroDenominator;
	if (site.kind != SiteKind::Loadn) return Error::None;
	// A LOADN preimage must load the recorded register; any other preimage is
	// admissible only as a flagged, separately verified rewrite into LOADN.
	const bool loadn = site.expected[0] == u44_loadn_opcode;
	if (loadn ? site.expected[1] != site.reg : !site.rewrites_instruction) return Error::NotLoadnOfRegister;
	return Error::None;
}

// The stock value a site's preimage encodes, when the preimage is a LOADN or a
// constant and the site is not inverse (the registrar pins it); `known` is
// false otherwise (a non-LOADN rewrite or an inverse site carries no directly
// readable stock).
inline double preimage_operand(const Site& site, bool& known) noexcept
{
	known = false;
	if (site.inverse) return 0.0;
	if (site.kind == SiteKind::NumberConstant)
	{
		std::uint64_t bits = 0;
		for (std::size_t n = 0; n != 8; ++n) bits |= static_cast<std::uint64_t>(site.expected[n]) << (8 * n);
		known = true;
		return std::bit_cast<double>(bits);
	}
	if (site.expected[0] != u44_loadn_opcode) return 0.0;
	known = true;
	return static_cast<double>(static_cast<std::int16_t>(
		static_cast<std::uint16_t>(site.expected[2] | (static_cast<unsigned>(site.expected[3]) << 8))));
}

// The recorded stock value of the site's row must be exactly what the stock
// preimage encodes (where that is readable).
inline Error stock_error(const Site& site, double row_stock) noexcept
{
	bool known = false;
	const double encoded = preimage_operand(site, known);
	if (!known) return Error::None;
	return encoded == operand(site, row_stock) ? Error::None : Error::StockDisagrees;
}

// Verifies one site against the stock body: extent, constant tag, preimage and
// shape. `body` is the complete stock container.
inline Error verify(const Site& site, const unsigned char* body, std::size_t size) noexcept
{
	const std::size_t span = width(site.kind);
	if (body == nullptr || site.offset > size || span > size - site.offset) return Error::Extent;
	if (site.kind == SiteKind::NumberConstant
		&& (site.offset == 0 || body[site.offset - 1] != native_number_tag))
	{
		return Error::ConstantTag;
	}
	if (std::memcmp(body + site.offset, site.expected.data(), span) != 0) return Error::PreimageChanged;
	return shape_error(site);
}

inline bool overlaps(const Site& lhs, const Site& rhs) noexcept
{
	return lhs.offset < rhs.offset + width(rhs.kind) && rhs.offset < lhs.offset + width(lhs.kind);
}

// One resolved edit: the site and the bytes it receives.
struct Patch
{
	Site site;
	std::array<unsigned char, 8> bytes{};
};

// Applies resolved patches to a copy of the stock body. Every site is verified
// against the stock bytes first, no two patches may overlap, and the result
// may differ from stock only inside the patched extents. On any error `out`
// is left empty and `failed` names the offending patch index.
inline Error apply(
	const unsigned char* stock, std::size_t size, const std::vector<Patch>& patches,
	std::vector<unsigned char>& out, std::size_t& failed)
{
	out.clear();
	failed = 0;
	for (std::size_t i = 0; i != patches.size(); ++i)
	{
		failed = i;
		if (const Error error = verify(patches[i].site, stock, size); error != Error::None) return error;
		for (std::size_t j = 0; j != i; ++j)
			if (overlaps(patches[i].site, patches[j].site)) return Error::Overlap;
	}
	std::vector<unsigned char> bytes(stock, stock + size);
	std::vector<bool> permitted(size, false);
	for (const auto& patch : patches)
	{
		const std::size_t span = width(patch.site.kind);
		for (std::size_t n = 0; n != span; ++n)
		{
			bytes[patch.site.offset + n] = patch.bytes[n];
			permitted[patch.site.offset + n] = true;
		}
	}
	for (std::size_t n = 0; n != size; ++n)
	{
		if (bytes[n] != stock[n] && !permitted[n])
		{
			failed = patches.size();
			return Error::UnexpectedChange;
		}
	}
	failed = 0;
	out = std::move(bytes);
	return Error::None;
}
}
