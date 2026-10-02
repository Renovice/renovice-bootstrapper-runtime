#!/usr/bin/env python3
"""Synthetic "new builds" made from a COPY of a certified Warframe.x64.exe, for the native update regression test.

Never writes the source image; every output goes to the given folder. The mutations model what a relink or a hotfix
does to the bootstrapper's dependencies:

  unchanged   same code; only the ProductVersion (build label) differs, so the digest is new;
  shift       `--shift-bytes` of int3 inserted at a function start in the middle of .text: everything after it moves
              (all rel32 / RIP-relative / switch-table / .reloc / .pdata references are re-pointed, as a linker would);
  neighbour   the 44.0.2 lock-stub case: the LeaveCriticalSection thunk moves to another padding gap (new neighbours;
              the dispatcher's tail jump follows), and the function after a test-only signature's leaf gets a new
              prologue (a signature that ran past its function end would break);
  codec       ENGINE_DAMAGE codec keys rotated: every integer accessor key and every float key in .text;
  instr       a changed instruction inside a matched feature signature (Riven SetStringVariable: stack frame size);
  process     a changed instruction inside a matched process-scope signature (main.cpp), plus `instr`.

Usage: make_synthetic.py <certified exe> <out dir> <case> [<case> ...]
"""
from __future__ import annotations

import json
import re
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))

import capstone  # noqa: E402

from nu_image import Image  # noqa: E402

LABELS = {'unchanged': '2026.10.06.12.00', 'shift': '2026.10.06.12.01', 'neighbour': '2026.10.06.12.02',
          'codec': '2026.10.06.12.03', 'instr': '2026.10.06.12.04', 'process': '2026.10.06.12.05'}
SHIFT_AT = 0x800000           # first .pdata function at or after this RVA
SHIFT_BYTES = 0xF0            # fits the .text raw padding (raw size - virtual size = 0x10b on 44.0.2)
INT_KEY, FLOAT_KEY = 0xAC7E8740, 0x8637D1B6
NEW_INT_KEY, NEW_FLOAT_KEY = 0x5A17C3E1, 0x2B9D04F7
REPO = HERE.parent.parent.parent
MAIN_SIG = '48 89 5C 24 08 57 48 83 EC 20 48 8B DA 48 8B F9 48 85 D2 75 0F'


class Editable:
    def __init__(self, img: Image):
        self.img = img
        self.mem = bytearray(img.mem)
        self.log: list[str] = []

    def to_file(self) -> bytes:
        out = bytearray(self.img.file)
        for name, va, vsize, roff, rsize in self.img.sections:
            n = min(vsize or rsize, rsize)
            out[roff:roff + n] = self.mem[va:va + n]
        return bytes(out)

    def relabel(self, old: str, new: str):
        assert len(old) == len(new)
        rva, size = self.img.data_dirs[2]
        a, b = old.encode('utf-16-le'), new.encode('utf-16-le')
        blob = bytes(self.mem[rva:rva + size])
        n = blob.count(a)
        self.mem[rva:rva + size] = blob.replace(a, b)
        a8, b8 = old.encode(), new.encode()
        self.log.append(f'ProductVersion {old} -> {new} ({n} UTF-16 occurrence(s) in .rsrc)')
        return n


# -- full .text decode (pdata functions + gaps), the input of the shift fixups -------------------------------------------
def decode_text(img: Image):
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
    mdd = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
    mdd.detail = True
    lo, hi = img.text
    funcs = img.functions()
    ranges, pos = [], lo
    for b, e in funcs:
        if b > pos:
            ranges.append((pos, b, 'gap'))
        ranges.append((b, e, 'fn'))
        pos = max(pos, e)
    if pos < hi:
        ranges.append((pos, hi, 'gap'))
    fields = []          # (insn rva, insn size, field offset, kind, target)
    tables = set()
    rx_hex = re.compile(r'^0x[0-9a-f]+$')

    def sweep(a, b):
        p = a
        while p < b:
            got = False
            for (addr, size, mn, op) in md.disasm_lite(img.mem[p:b], p):
                got = True
                p = addr + size
                if 'rip' in op or ('*' in op and '+ 0x' in op) or (size >= 5 and rx_hex.match(op) and
                                                                     (mn == 'call' or mn.startswith('j'))):
                    i = next(mdd.disasm(img.mem[addr:addr + size], addr))
                    for f in img._fields(i):
                        fields.append((addr, size, f.offset, f.kind, f.target))
                        if f.kind == 'absrva' and lo <= f.target < hi:
                            tables.add(f.target)
            if not got:
                p += 1
    for a, b, kind in ranges:
        if kind == 'fn':
            sweep(a, b)
    table_regions = []
    for t in sorted(tables):
        nxt = next((fb for fb, _ in funcs if fb > t), hi)
        table_regions.append((t, nxt))
    for a, b, kind in ranges:
        if kind != 'gap':
            continue
        cuts = [(ta, tb) for ta, tb in table_regions if a <= ta < b]
        p = a
        for ta, tb in cuts:
            if ta > p:
                sweep(p, ta)
            p = max(p, min(tb, b))
        if p < b:
            sweep(p, b)
    return fields, sorted(tables)


def base_relocs(img: Image) -> list[int]:
    rva, size = img.data_dirs[5]
    out, p = [], rva
    while p < rva + size:
        page, block = struct.unpack_from('<II', img.mem, p)
        if block < 8:
            break
        for k in range((block - 8) // 2):
            e = struct.unpack_from('<H', img.mem, p + 8 + 2 * k)[0]
            if e >> 12 == 10:
                out.append(page + (e & 0xFFF))
        p += block
    return out


def shift(ed: Editable, at_least: int = SHIFT_AT, k: int = SHIFT_BYTES):
    img = ed.img
    lo, hi = img.text
    a = next(b for b, _e in img.functions() if b >= at_least)
    b = hi
    name, va, vsize, roff, rsize = img.section('.text')
    if va + vsize + k > va + rsize:
        raise SystemExit('shift does not fit the .text raw padding')
    moves = lambda r: a <= r < b  # noqa: E731
    fields, tables = decode_text(img)
    n_code = 0
    for addr, size, off, kind, target in fields:
        site = addr + off
        if kind in ('rel', 'rip'):
            new_end = addr + size + (k if moves(addr) else 0)
            new_target = target + (k if moves(target) else 0)
            disp = new_target - new_end
            old = struct.unpack_from('<i', ed.mem, site)[0]
            if disp != old:
                struct.pack_into('<i', ed.mem, site, disp)
                n_code += 1
        elif kind == 'absrva' and moves(target):
            struct.pack_into('<I', ed.mem, site, target + k)
            n_code += 1
    n_tab = 0
    for t in tables:
        p = t
        while p + 4 <= hi:
            v = struct.unpack_from('<I', img.mem, p)[0]
            if not (lo <= v < hi and abs(v - t) < 0x40000):
                break
            if moves(v):
                struct.pack_into('<I', ed.mem, p, v + k)
                n_tab += 1
            p += 4
    n_rel = 0
    for loc in base_relocs(img):
        v = struct.unpack_from('<Q', img.mem, loc)[0] - img.base
        if moves(v):
            struct.pack_into('<Q', ed.mem, loc, v + k + img.base)
            n_rel += 1
    prva, psize = img.data_dirs[3]
    n_pd = 0
    for i in range(psize // 12):
        bgn, end, unw = struct.unpack_from('<III', img.mem, prva + 12 * i)
        if bgn and moves(bgn):
            struct.pack_into('<II', ed.mem, prva + 12 * i, bgn + k, end + k)
            n_pd += 1
    block = bytes(ed.mem[a:b])
    ed.mem[a + k:b + k] = block
    ed.mem[a:a + k] = b'\xcc' * k
    hdr = img.section_headers[[s[0] for s in img.sections].index('.text')]
    vsize_off = hdr + 8 - 0                                  # VirtualSize in the section header (file offset)
    ed.vsize_patch = (vsize_off, vsize + k)                  # written into the file headers by make()
    ed.log.append(f'shift: {k:#x} int3 bytes inserted at 0x{a:x}; [0x{a:x}, 0x{b:x}) moved; fixups: {n_code} code '
                  f'operands, {n_tab} switch-table entries, {n_rel} absolute pointers (.reloc), {n_pd} .pdata entries')
    return a, k


def find_gap(img: Image, need: int, avoid: tuple[int, int], start: int) -> int:
    """A run of int3 padding of at least `need`+2 bytes (between functions), away from `avoid`; the stub starts one
    byte into it, so an int3 stays on both sides."""
    for m in re.finditer(rb'\xcc{%d,}' % (need + 2), img.mem[start:img.text[1]]):
        q = start + m.start() + 1
        if not (avoid[0] - 0x100 <= q <= avoid[1] + 0x100):
            return q
    raise SystemExit('no padding gap')


def neighbour(ed: Editable):
    img = ed.img
    slot = img.import_slot('KERNEL32.dll', 'LeaveCriticalSection')
    thunks = [t for t in img.scan('48 8B 09 48 8B 09 48 FF 25 ? ? ? ?') if img.rel32_target(t + 9) == slot]
    assert len(thunks) == 1
    old = thunks[0]
    new = find_gap(img, 13, (old, old + 13), 0x1000000)
    code = bytearray(img.mem[old:old + 13])
    struct.pack_into('<i', code, 9, slot - (new + 13))
    ed.mem[new:new + 13] = code
    ed.mem[old:old + 13] = b'\xcc' * 13
    sites = img.rel_index().get(old, [])
    for site, _op in sites:
        struct.pack_into('<i', ed.mem, site + 1, new - (site + 5))
    ed.log.append(f'neighbour: LeaveCriticalSection thunk 0x{old:x} -> 0x{new:x} (new neighbours); {len(sites)} '
                  f'rel32 reference(s) re-pointed')
    # test-only signature that runs past its leaf into the next function (the old _u44 lock-signature shape)
    leaf = img.scan('FF 81 88 00 00 00 8B 81 88 00 00 00 C3')[0]
    nxt = leaf + 13
    while img.mem[nxt] == 0xCC:
        nxt += 1
    span = nxt + 8 - leaf
    sig = ' '.join(f'{c:02X}' for c in img.mem[leaf:leaf + span])
    before = bytes(ed.mem[nxt:nxt + 8])
    # the next function's prologue changes (a different frame): keep the instruction lengths, change the bytes
    frame = next((i for i in img.decode(nxt, 8) if i.mnemonic == 'sub' and i.op_str.startswith('rsp, ')
                  and i.size == 4), None)
    if frame is None:
        raise SystemExit('neighbour: the next function has no imm8 frame allocation in its first 8 bytes')
    ed.mem[frame.rva + 3] = frame.raw[3] - 0x10 if frame.raw[3] >= 0x20 else frame.raw[3] + 0x10
    ed.log.append(f'neighbour: function after the interrupt leaf 0x{leaf:x} (0x{nxt:x}) changed '
                  f'{before.hex()} -> {bytes(ed.mem[nxt:nxt + 8]).hex()}')
    return {'id': 'synthetic/neighbour_leaf#0', 'file': 'synthetic/neighbour_leaf', 'line': 0,
            'context': 'test-only: interrupt leaf + padding + next prologue (runs past its function end)',
            'pattern': sig, 'commented': False, 'span': None, 'json_key': None}


def codec(ed: Editable):
    lo, hi = ed.img.text
    counts = {}
    for old, new in ((INT_KEY, NEW_INT_KEY), (FLOAT_KEY, NEW_FLOAT_KEY)):
        a, b = struct.pack('<I', old), struct.pack('<I', new)
        seg = bytes(ed.mem[lo:hi])
        counts[f'0x{old:08x}'] = seg.count(a)
        ed.mem[lo:hi] = seg.replace(a, b)
    ed.log.append(f'codec: integer key 0x{INT_KEY:08x} -> 0x{NEW_INT_KEY:08x}, float key 0x{FLOAT_KEY:08x} -> '
                  f'0x{NEW_FLOAT_KEY:08x} in .text ({counts})')


def riven_set_string() -> str:
    from nu_source import cpp_string, read_text
    return cpp_string(read_text(REPO / 'renovice' / 'riven_core.hpp'), 'signature_set_string_variable')


def change_frame(ed: Editable, pattern: str, label: str):
    hits = ed.img.scan(pattern)
    assert len(hits) == 1, (label, len(hits))
    h = hits[0]
    n = len(pattern.split())
    for i in ed.img.decode(h, n):
        if i.mnemonic == 'sub' and i.op_str.startswith('rsp, ') and i.size in (4, 7) and i.rva + i.size <= h + n:
            if i.size == 4:
                ed.mem[i.rva + 3] = i.raw[3] + 0x10
            else:
                struct.pack_into('<I', ed.mem, i.rva + 3, struct.unpack_from('<I', i.raw, 3)[0] + 0x10)
            ed.log.append(f'{label}: 0x{i.rva:x} `{i.mnemonic} {i.op_str}` frame +0x10 (inside the matched pattern '
                          f'at 0x{h:x})')
            return
    raise SystemExit(f'{label}: no sub rsp in the pattern')


def make(src: Path, out: Path, case: str) -> dict:
    img = Image.load(src)
    ed = Editable(img)
    label_old = img.product_version()
    extra = []
    if case == 'shift':
        shift(ed)
    elif case == 'neighbour':
        extra.append(neighbour(ed))
    elif case == 'codec':
        codec(ed)
    elif case in ('instr', 'process'):
        change_frame(ed, riven_set_string(), 'instr (Riven SetStringVariable)')
        if case == 'process':
            change_frame(ed, MAIN_SIG, 'process (main.cpp signature)')
    elif case != 'unchanged':
        raise SystemExit(f'unknown case {case}')
    ed.relabel(label_old, LABELS[case])
    data = ed.to_file()
    if case == 'shift':
        off, value = ed.vsize_patch
        data = data[:off] + struct.pack('<I', value) + data[off + 4:]
    folder = out / case
    folder.mkdir(parents=True, exist_ok=True)
    (folder / 'Warframe.x64.exe').write_bytes(data)
    new = Image(data)
    meta = {'case': case, 'label': LABELS[case], 'sha256': new.sha256, 'source_sha256': img.sha256,
            'log': ed.log, 'extra_signatures': extra}
    (folder / 'synthetic.json').write_text(json.dumps(meta, indent=2) + '\n', encoding='utf-8')
    if extra:
        (folder / 'extra_signatures.json').write_text(json.dumps(extra, indent=2) + '\n', encoding='utf-8')
    return meta


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(2)
    for c in sys.argv[3:]:
        m = make(Path(sys.argv[1]), Path(sys.argv[2]), c)
        print(c, m['sha256'], *m['log'], sep='\n  ')
