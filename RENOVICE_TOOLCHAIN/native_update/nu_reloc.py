"""Identity-preserving relocation of a byte span (a signature or a registered byte range) from the reference image (the
last certified build) to a new image.

Strategies, in order (each candidate must pass strict verification):
  exact       the original pattern (its own wildcards only);
  masked      the pattern with every volatile operand field of the reference code wildcarded (rel32 branch targets,
              RIP-relative displacements, absolute switch-table RVAs);
  trimmed     a pattern that runs past its function's end (ret/jmp + int3 padding) into a neighbour is cut at that
              boundary (the 44.0.2 lock-stub defect), then exact/masked again;
  anchors     no unique candidate: functions of the new image that reference the same imports / string constants as
              the reference function are searched for the closest alignment. Reported for review, never applied.

Strict verification of a candidate, instruction by instruction over the span: same instruction boundaries, sizes and
mnemonics; every non-volatile byte equal; every volatile field of the same kind and the same identity:
  import   the IAT slot names the same DLL!function;
  rdata    the same constant bytes (qwords that are code pointers compare by kind);
  code     a target in .text (and, when the target is another relocated anchor, exactly that anchor's new RVA);
  data     a writable global (.data/.bss): accepted as volatile (signatures already wildcard these);
  absrva   the same distance from the instruction (switch table placement).
"""
from __future__ import annotations

from dataclasses import dataclass, field

from nu_image import Image, Insn, pattern_tokens, tokens_pattern

CODE_FINGERPRINT_BYTES = 32


@dataclass
class Located:
    status: str                         # exact | masked | masked+callee | trimmed | none | ambiguous | undecodable
    rva: int | None = None              # new RVA of the span start
    length: int = 0                     # span length in the new pattern (trimmed spans are shorter)
    strategy: str = ''
    evidence: list[str] = field(default_factory=list)
    candidates: list[int] = field(default_factory=list)
    diffs: list[str] = field(default_factory=list)


class Relocator:
    def __init__(self, ref: Image, new: Image):
        self.ref, self.new = ref, new

    # -- identities -------------------------------------------------------------------------------------------------------
    def _code_fingerprint(self, img: Image, rva: int):
        ins = img.decode(rva, CODE_FINGERPRINT_BYTES)
        out = []
        for i in ins:
            raw = bytearray(i.raw)
            for f in i.fields:
                raw[f.offset:f.offset + f.size] = b'\0' * f.size
            out.append((i.mnemonic, bytes(raw)))
        return tuple(out)

    def identity(self, img: Image, insn: Insn, f, deep: bool = False):
        t = f.target
        if f.kind == 'absrva':
            return ('absrva', t - insn.rva)
        sec = img.section_of(t)
        if f.kind == 'rip' and sec == '.rdata':
            name = img.import_name_at(t)
            if name:
                return ('import', name)
            if insn.mnemonic == 'lea':
                s = img.mem[t:t + 64].split(b'\0')[0]
                if len(s) >= 2 and all(32 <= c < 127 for c in s):
                    return ('string', s)
                return ('rdata-address',)
            n = min(max(f.opsize, 1), 16)
            raw = img.mem[t:t + n]
            if n == 8 and img.is_code(int.from_bytes(raw, 'little') - img.base):
                return ('rdata-code-pointer',)
            return ('rdata', raw)
        if sec == '.text':
            return ('code', self._code_fingerprint(img, t)) if deep else ('code',)
        if sec in ('.data', '.bss', '.shr', '_RDATA', '.fptable', '.pdata'):
            return ('data', sec)
        return ('other', sec)

    def strict(self, ref_rva: int, new_rva: int, length: int, anchors: dict[int, int] | None = None,
               deep: bool = False) -> list[str]:
        """[] when the new span is the same code as the reference span; otherwise every difference."""
        ri = self.ref.instructions_covering(ref_rva, length)
        ni = self.new.instructions_covering(new_rva, length)
        if ri is None or ni is None:
            return ['span does not decode as code' + (' (reference)' if ri is None else ' (new image)')]
        diffs = []
        if [i.rva - ref_rva for i in ri] != [i.rva - new_rva for i in ni]:
            return [f'instruction boundaries differ: reference {[i.size for i in ri]} new {[i.size for i in ni]}']
        anchors = anchors or {}
        for a, b in zip(ri, ni):
            if a.mnemonic != b.mnemonic or a.size != b.size:
                diffs.append(f'+0x{a.rva - ref_rva:x}: `{a.mnemonic} {a.op_str}` -> `{b.mnemonic} {b.op_str}`')
                continue
            ma, mb = bytearray(a.raw), bytearray(b.raw)
            for f in a.fields + b.fields:
                ma[f.offset:f.offset + f.size] = b'\0' * f.size
                mb[f.offset:f.offset + f.size] = b'\0' * f.size
            if ma != mb or [(f.offset, f.kind) for f in a.fields] != [(f.offset, f.kind) for f in b.fields]:
                diffs.append(f'+0x{a.rva - ref_rva:x}: `{a.mnemonic} {a.op_str}` -> `{b.mnemonic} {b.op_str}`')
                continue
            for fa, fb in zip(a.fields, b.fields):
                if fa.target in anchors:
                    if anchors[fa.target] != fb.target:
                        diffs.append(f'+0x{a.rva - ref_rva:x}: anchor 0x{fa.target:x} should be 0x{anchors[fa.target]:x}, '
                                     f'new code targets 0x{fb.target:x}')
                    continue
                ia, ib = self.identity(self.ref, a, fa, deep), self.identity(self.new, b, fb, deep)
                if ia != ib:
                    diffs.append(f'+0x{a.rva - ref_rva:x}: `{a.mnemonic} {a.op_str}` target identity {ia[0]} differs')
        return diffs

    # -- masks ----------------------------------------------------------------------------------------------------------
    def masked_tokens(self, img: Image, rva: int, tokens: list[int | None]) -> list[int | None] | None:
        mask = img.volatile_mask(rva, len(tokens))
        if mask is None:
            return None
        return [None if (m or t is None) else t for t, m in zip(tokens, mask)]

    def boundary(self, rva: int, length: int) -> int | None:
        """Offset of the first int3 padding byte that follows a ret/jmp inside the span, else None."""
        ins = self.ref.instructions_covering(rva, length)
        if not ins:
            return None
        for k, i in enumerate(ins[:-1]):
            if i.mnemonic in ('ret', 'jmp') and ins[k + 1].mnemonic == 'int3' and ins[k + 1].rva > rva:
                return ins[k + 1].rva - rva
        return None

    # -- location ---------------------------------------------------------------------------------------------------------
    def _filter(self, hits, ref_rva, length, anchors, ev, label):
        passing = [h for h in hits if not self.strict(ref_rva, h, length, anchors)]
        if len(passing) == 1:
            return Located('masked' if label != 'exact' else 'exact', passing[0], length, label, ev + [
                f'{label}: {len(hits)} hit(s), 1 passes strict verification at 0x{passing[0]:x}'])
        if len(passing) > 1:
            deep = [h for h in passing if not self.strict(ref_rva, h, length, anchors, deep=True)]
            if len(deep) == 1:
                return Located('masked+callee', deep[0], length, label + '+callee-identity', ev + [
                    f'{label}: {len(passing)} hits pass strict verification; callee prologue identity selects 0x{deep[0]:x}'])
            return Located('ambiguous', None, length, label, ev + [
                f'{label}: {len(passing)} hits pass strict verification: '
                + ', '.join(hex(h) for h in passing[:8])], candidates=passing)
        return None

    def locate(self, ref_rva: int, tokens: list[int | None], anchors: dict[int, int] | None = None,
               allow_trim: bool = True) -> Located:
        length = len(tokens)
        ev: list[str] = []
        exact = self.new.scan(tokens_pattern(tokens), limit=64)
        ev.append(f'exact pattern: {len(exact)} hit(s)' + (f' first 0x{exact[0]:x}' if exact else ''))
        if exact:
            got = self._filter(exact, ref_rva, length, anchors, ev, 'exact')
            if got:
                return got
        masked = self.masked_tokens(self.ref, ref_rva, tokens)
        if masked is None:
            return Located('undecodable', None, length, '', ev + ['reference span does not decode as code'])
        if masked != tokens:
            hits = self.new.scan(tokens_pattern(masked), limit=64)
            ev.append(f'masked pattern ({sum(t is None for t in masked) - sum(t is None for t in tokens)} volatile '
                      f'bytes wildcarded): {len(hits)} hit(s)')
            got = self._filter(hits, ref_rva, length, anchors, ev, 'masked')
            if got:
                return got
        if allow_trim:
            b = self.boundary(ref_rva, length)
            if b is not None and b >= 8:
                ev.append(f'pattern runs {length - b} byte(s) past its function end (ret/jmp + int3); trimmed to {b}')
                got = self.locate(ref_rva, tokens[:b], anchors, allow_trim=False)
                if got.rva is not None:
                    got.status, got.strategy = 'trimmed', 'trimmed+' + got.strategy
                    got.evidence = ev + got.evidence
                    return got
                ev += got.evidence
        cands = self.anchor_candidates(ref_rva, masked)
        if cands:
            best = cands[0]
            diffs = self.strict(ref_rva, best[0], length, anchors)
            ev.append(f'anchor search: closest candidate 0x{best[0]:x} ({best[1]} masked byte(s) differ) via '
                      f'{best[2]}')
            return Located('none', None, length, 'anchors', ev, [c[0] for c in cands[:4]], diffs[:6])
        return Located('none', None, length, '', ev + ['anchor search: no function of the new image shares an '
                                                       'import or string constant with the reference function'])

    # -- anchor search (review evidence only) ------------------------------------------------------------------------------
    def _function_anchors(self, img: Image, start: int, end: int) -> set:
        anchors = set()
        for i in img.decode(start, min(end - start, 0x4000)):
            for f in i.fields:
                if f.kind != 'rip':
                    continue
                name = img.import_name_at(f.target)
                if name:
                    anchors.add(('import', name))
                elif img.section_of(f.target) == '.rdata':
                    s = img.mem[f.target:f.target + 48].split(b'\0')[0]
                    if len(s) >= 6 and all(32 <= c < 127 for c in s):
                        anchors.add(('string', s))
        return anchors

    def anchor_candidates(self, ref_rva: int, masked: list[int | None] | None) -> list[tuple[int, int, str]]:
        f = self.ref.containing_function(ref_rva)
        if not f or masked is None:
            return []
        anchors = self._function_anchors(self.ref, *f)
        strings = sorted((a for a in anchors if a[0] == 'string'), key=lambda a: -len(a[1]))[:4]
        funcs: dict[tuple[int, int], str] = {}
        for _k, s in strings:
            for at in self.new.scan(' '.join(f'{c:02X}' for c in s + b'\0'), limit=4):
                for site in self.new.lea_refs(at)[:16]:
                    g = self.new.containing_function(site)
                    if g:
                        funcs.setdefault(g, f'string "{s.decode()[:40]}"')
        out = []
        offset = ref_rva - f[0]
        for (gs, ge), why in funcs.items():
            best = None
            for start in range(max(gs, gs + offset - 0x200), min(ge, gs + offset + 0x200)):
                window = self.new.mem[start:start + len(masked)]
                if len(window) < len(masked):
                    break
                d = sum(1 for t, c in zip(masked, window) if t is not None and t != c)
                if best is None or d < best[1]:
                    best = (start, d)
            if best:
                out.append((best[0], best[1], why))
        return sorted(out, key=lambda c: c[1])

    # -- new pattern for a relocated signature --------------------------------------------------------------------------
    def relaxed_pattern(self, old_tokens: list[int | None], new_rva: int, length: int,
                        references: list[tuple[Image, int]]) -> tuple[str | None, list[str]]:
        """A pattern for the new site that keeps the old one's specificity: the old tokens (cut to `length`) with
        every volatile field of the new code wildcarded; if that is not unique, only the bytes that changed. It must
        be unique on the new image and on every reference image (at that image's own site)."""
        tokens = old_tokens[:length]
        new_bytes = self.new.mem[new_rva:new_rva + length]
        notes = []
        full = self.masked_tokens(self.new, new_rva, tokens)
        minimal = [None if (t is not None and t != c) else t for t, c in zip(tokens, new_bytes)]
        for label, cand in (('volatile fields wildcarded', full), ('changed bytes wildcarded', minimal)):
            if cand is None:
                continue
            if any(t is not None and t != c for t, c in zip(cand, new_bytes)):
                continue
            pattern = tokens_pattern(cand)
            hits = self.new.scan(pattern, limit=3)
            ok = hits == [new_rva]
            detail = [f'{label}: new image {len(hits)} hit(s)']
            for img, site in references:
                rh = img.scan(pattern, limit=3)
                detail.append(f'{img.product_version() or "?"} {img.sha256[:8]} {len(rh)} hit(s)')
                ok = ok and rh == [site]
            notes.append('; '.join(detail))
            if ok:
                return pattern, notes
        return None, notes


def tokens_of(pattern: str) -> list[int | None]:
    return pattern_tokens(pattern)
