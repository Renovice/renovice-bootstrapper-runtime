"""ENGINE_PARAM_OVERRIDE registration (contract R16) relocated to a new image.

The registration carries the detour RVA (push_value), the name-hash seed, the DE Luau layout and 8 exact byte ranges
that `admit_image` compares byte for byte at startup. Each range is relocated by identity from the reference image
(nu_reloc strict verification), with the other ranges as anchors: a rel32 inside one range that targets another
range's start must target that range's NEW start. Switch tables (ranges of in-function RVAs) are found through the
instruction that indexes them. The writer contract of the research note (push_value reached only by its CALLs inside
apply_param; no JMP, LEA or absolute pointer) is re-checked on the new image.

Not derivable from code here and carried over unchanged (reported): the DE Luau/parameter-record layout. Its values
are those every other runtime component assumes for the VM; the byte ranges cover the record type byte, the float push
(tag 3, size 0x10, top +0x08), the key push (tag 1) and getfenv (closure env +0x10, tag 7).
"""
from __future__ import annotations

import struct

from nu_image import Image
from nu_reloc import Relocator


def _is_table(img: Image, rva: int, data: bytes) -> bool:
    if len(data) % 4 or not data:
        return False
    vals = struct.unpack(f'<{len(data) // 4}I', data)
    return all(img.is_code(v) and abs(v - rva) < 0x10000 for v in vals)


def relocate(ref: Image, new: Image, prev: dict, rel: Relocator) -> tuple[dict | None, list[str], list[str], list[dict]]:
    """(registration or None, evidence, failures, per-range results)."""
    ev, fail, ranges = [], [], []
    checks = prev['checks']
    kinds = []
    for c in checks:
        data = bytes.fromhex(c['hex'])
        if ref.mem[c['rva']:c['rva'] + len(data)] != data:
            return None, ev, [f'reference image does not carry range 0x{c["rva"]:x} (wrong reference)'], ranges
        kinds.append('table' if _is_table(ref, c['rva'], data) else 'code')
    # pass 1: code ranges independently
    located: dict[int, int] = {}
    results: dict[int, dict] = {}
    for c, kind in zip(checks, kinds):
        if kind != 'code':
            continue
        data = bytes.fromhex(c['hex'])
        got = rel.locate(c['rva'], list(data), None, allow_trim=False)
        results[c['rva']] = {'rva': c['rva'], 'reason': c['reason'], 'kind': 'code', 'length': len(data),
                             'status': got.status, 'new_rva': got.rva, 'evidence': got.evidence, 'diffs': got.diffs}
        if got.rva is not None:
            located[c['rva']] = got.rva
    # pass 2: strict verification with every other range as an anchor
    for r in results.values():
        if r['new_rva'] is None:
            continue
        diffs = rel.strict(r['rva'], r['new_rva'], r['length'], located)
        if diffs:
            r['status'], r['diffs'] = 'anchor-mismatch', diffs
    # tables: through the instruction that indexes them
    for c, kind in zip(checks, kinds):
        if kind != 'table':
            continue
        data = bytes.fromhex(c['hex'])
        r = {'rva': c['rva'], 'reason': c['reason'], 'kind': 'table', 'length': len(data), 'status': 'none',
             'new_rva': None, 'evidence': [], 'diffs': []}
        results[c['rva']] = r
        for s, ns in located.items():
            if results[s]['status'] not in ('exact', 'masked', 'masked+callee'):
                continue
            insn = next((i for i in ref.decode(s, 0x1000)
                         for f in i.fields if f.kind == 'absrva' and f.target == c['rva']), None)
            if insn is None:
                continue
            prefix = insn.rva + insn.size - s
            diffs = rel.strict(s, ns, prefix, located)
            if diffs:
                r['status'], r['diffs'] = 'indexing-code-differs', diffs
                break
            ninsn = new.decode(ns + (insn.rva - s), insn.size)[0]
            table = next(f.target for f in ninsn.fields if f.kind == 'absrva')
            ref_entries = struct.unpack(f'<{len(data) // 4}I', data)
            expected = [ns + (e - s) for e in ref_entries]
            actual = list(struct.unpack(f'<{len(data) // 4}I', new.mem[table:table + len(data)]))
            r['evidence'].append(f'indexed by `{insn.mnemonic} {insn.op_str}` at +0x{insn.rva - s:x} of range 0x{s:x}')
            if actual != expected:
                r['status'], r['diffs'] = 'table-entries-differ', [
                    f'entries {[hex(a) for a in actual]} expected {[hex(e) for e in expected]}']
            else:
                r['status'], r['new_rva'] = 'table', table
                located[c['rva']] = table
            break
        if r['status'] == 'none':
            r['diffs'] = ['no relocated range indexes this table']
    ok_status = ('exact', 'masked', 'masked+callee', 'table')
    for c in checks:
        r = results[c['rva']]
        ranges.append(r)
        if r['status'] not in ok_status:
            fail.append(f'range 0x{c["rva"]:x} ({c["reason"]}): {r["status"]}; ' + '; '.join(r['diffs'][:3]))
    if fail:
        return None, ev, fail, ranges
    # detour target and writer contract
    pv = prev['push_value_rva']
    if pv not in located:
        return None, ev, [f'push_value 0x{pv:x} is not a registered range start'], ranges
    npv = located[pv]
    ref_sites = ref.callers(pv)
    mapped = []
    for site in ref_sites:
        owner = next((s for s, r in results.items() if r['kind'] == 'code' and s <= site < s + r['length']), None)
        if owner is None:
            fail.append(f'reference caller 0x{site:x} of push_value lies outside every registered range')
        else:
            mapped.append(located[owner] + site - owner)
    new_sites = new.callers(npv)
    if sorted(mapped) != new_sites:
        fail.append(f'push_value callers: new {[hex(s) for s in new_sites]}, expected {[hex(s) for s in sorted(mapped)]}')
    extra = {'jmp': new.jumpers(npv), 'lea': new.lea_refs(npv), 'qword': new.qword_refs(npv)}
    if any(extra.values()):
        fail.append(f'push_value is reached by other references: {extra}')
    ev.append(f'push_value 0x{pv:x} -> 0x{npv:x}: called only at {[hex(s) for s in new_sites]} (inside the relocated '
              f'apply_param range), no JMP/LEA/absolute reference')
    seed_range = next((located[c['rva']] for c in checks if c['hex'].startswith('b8') and 'seed' in c['reason']), None)
    seed = new.u32(seed_range + 1) if seed_range is not None else None
    if seed != prev['seed']:
        fail.append(f'name-hash seed {seed and hex(seed)} != registered 0x{prev["seed"]:x}')
    if fail:
        return None, ev, fail, ranges
    reg = {'push_value_rva': npv, 'seed': seed, 'layout': list(prev['layout']),
           'checks': [{'rva': located[c['rva']], 'hex': new.mem[located[c['rva']]:located[c['rva']] + len(c['hex']) // 2].hex(),
                       'reason': c['reason']} for c in checks]}
    return reg, ev, [], ranges


_LAYOUT_LINES = [(0, 3), (3, 5), (5, 9), (9, 12), (12, 16), (16, 22)]


def row_cpp(label: str, digests: list[str], reg: dict, layout_source: str) -> str:
    d = (digests + ['', ''])[:2]
    lay = reg['layout']
    fmt = lambda v, k: f'0x{v:02x}' if k not in (5, 6, 7, 8, 12) else str(v)  # noqa: E731  (tags and gc tag decimal)
    digest_text = (f'{{"{d[0]}", ""}}' if not d[1] else f'{{"{d[0]}",\n         "{d[1]}"}}')
    lines = ['    {', f'        "{label}",', f'        {digest_text},', f'        0x{reg["push_value_rva"]:x},',
             f'        0x{reg["seed"]:08x},', '        {']
    for a, b in _LAYOUT_LINES:
        lines.append('            ' + ', '.join(fmt(lay[k], k) for k in range(a, b)) + ',')
    lines.append(f'            {{{lay[22]}, {lay[23]}}},')
    lines.append(f'        }},  // DE Luau / parameter-record layout: {layout_source}')
    lines.append('        {{')
    for c in reg['checks']:
        hx = c['hex']
        chunks = [hx[i:i + 108] for i in range(0, len(hx), 108)]
        lit = '"' + '"\n             "'.join(chunks) + '"'
        lines.append(f'            {{0x{c["rva"]:x},\n             {lit},\n             "{c["reason"]}"}},')
    lines += ['        }},', '    },']
    return '\n'.join(lines)
