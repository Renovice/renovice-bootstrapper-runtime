# Research-only disassembler for the Icebind Solo evidence (2026-10-08, client 2026.10.06.16.12).
# Reads a DE 09 03 container with the update tool's reader (uc_bytecode) and the toolchain U44 opcode profile, and
# prints one prototype as canonical (U43-numbered) instructions with operands, constants and string-pool names.
# Usage: python disasm.py <module.lua_B> <proto> [first] [last]
import struct
import sys
from pathlib import Path

ROOT = Path(r'C:\Users\Bartek\OneDrive\Dokumenter\Warframe RE PROJECT RENOVICE')
sys.path.insert(0, str(ROOT / 'repos/apps/ability-editor/tools/update_check'))
import uc_bytecode as B  # noqa: E402

NAMES = {
    0x12: 'LOADN', 0x4e: 'LOADK', 0x0d: 'LOADNIL', 0x04: 'LOADB', 0x14: 'MOVE', 0x4c: 'GETVARARGS', 0x11: 'PREPVARARGS',
    0x49: 'ADD', 0x07: 'SUB', 0x22: 'MUL', 0x1a: 'DIV', 0x55: 'MOD', 0x45: 'POW', 0x0e: 'MINUS', 0x38: 'ADDK',
    0x09: 'MULK', 0x32: 'DIVK', 0x3c: 'MODK', 0x08: 'POWK', 0x24: 'IDIVK', 0x06: 'SUBRK', 0x3b: 'DIVRK',
    0x37: 'JUMPIFEQ', 0x27: 'JUMPIFNOTEQ', 0x21: 'JUMPIFLT', 0x1c: 'JUMPIFNOTLT', 0x23: 'JUMPIFLE', 0x33: 'JUMPIFNOTLE',
    0x40: 'JUMP', 0x4b: 'JUMPIF', 0x18: 'JUMPIFNOT', 0x47: 'FORNPREP', 0x0a: 'FORNLOOP', 0x30: 'FORGPREP',
    0x1b: 'FORGPREP_INEXT', 0x1e: 'FORGLOOP', 0x01: 'GETTABLE', 0x2a: 'SETTABLE', 0x3d: 'GETTABLEKS', 0x15: 'SETTABLEKS',
    0x44: 'GETTABLEN', 0x2e: 'SETTABLEN', 0x2c: 'NEWTABLE', 0x4f: 'DUPTABLE', 0x3f: 'SETLIST', 0x54: 'CALL',
    0x2d: 'NAMECALL', 0x29: 'RETURN', 0x16: 'NEWCLOSURE', 0x35: 'CAPTURE', 0x42: 'DUPCLOSURE', 0x39: 'CLOSEUPVALS',
    0x13: 'GETUPVAL', 0x53: 'SETUPVAL', 0x46: 'GETIMPORT', 0x02: 'SETGLOBAL', 0x17: 'GETGLOBAL', 0x28: 'CONCAT',
    0x4d: 'LENGTH', 0x50: 'NOT', 0x19: 'FASTCALL1', 0x10: 'FASTCALL', 0x0c: 'FASTCALL2K', 0x26: 'FASTCALL2',
    0x4a: 'FASTCALLx', 0x25: 'JUMPBACK', 0x3e: 'SUBK', 0x00: 'MODswap', 0x2b: 'OR', 0x2f: 'AND', 0x31: 'ANDK',
    0x20: 'JUMPXEQKN', 0x41: 'JUMPXEQKS', 0x34: 'JUMPXEQKB', 0x3a: 'JUMPXEQKNIL', 0x51: 'TESTSET',
}
JUMPS = {0x37, 0x27, 0x21, 0x1c, 0x23, 0x33, 0x40, 0x4b, 0x18, 0x47, 0x0a, 0x30, 0x1b, 0x1e, 0x25, 0x20, 0x41, 0x34, 0x3a}


def opmap():
    return B.load_opcode_profile((ROOT / 'repos/toolchains/de-luau-toolchain/src/de_opcode_profile.h').read_text())


def const_text(m, p, k):
    if k >= len(p.consts):
        return f'K{k}?'
    c = p.consts[k]
    if c.tag == 3:
        return repr((m.string(c.value) or b'').decode('utf-8', 'replace'))
    if c.tag == 1:
        return f'hash:{c.value:08x}'
    if c.tag == 2:
        return repr(c.value)
    return f'tag{c.tag}:{c.value!r}'


def lines(m, p, first=0, last=None):
    pos, at = [], 0
    for i in range(len(p.instructions)):
        pos.append(at)
        at += len(m.word(p, i)) // 4
    word_to_logical = {w: i for i, w in enumerate(pos)}
    out = []
    for logical, off, op in p.instructions:
        if logical < first or (last is not None and logical > last):
            continue
        w = m.word(p, logical)
        a, b, c = w[1], w[2], w[3]
        bx = struct.unpack_from('<h', w, 2)[0]
        aux = struct.unpack_from('<I', w, 4)[0] if len(w) == 8 else None
        name = NAMES.get(op, f'op{op:02x}')
        text = f'A={a} B={b} C={c}'
        if op in JUMPS:
            tgt = word_to_logical.get(pos[logical] + 1 + bx)
            text = f'A={a} -> i{tgt}'
            if aux is not None:
                text += f' aux={aux:#x}' + (f' (R{aux})' if op in (0x37, 0x27, 0x21, 0x1c, 0x23, 0x33) and not aux & 0x80000000 else '')
        elif op == 0x12:
            text = f'R{a} = {bx}'
        elif op == 0x4e:
            text = f'R{a} = K{bx & 0xffff} {const_text(m, p, bx & 0xffff)}'
        elif op in (0x3d, 0x15, 0x17, 0x02, 0x2d):
            text += f' key={const_text(m, p, aux)}'
        elif op == 0x46:
            text += f' import={aux:#x}'
        elif aux is not None:
            text += f' aux={aux:#x}'
        out.append(f'i{logical:4d} +{off:5d} {w.hex():16s} {name:13s} {text}')
    return out


if __name__ == '__main__':
    path, proto = Path(sys.argv[1]), int(sys.argv[2])
    first = int(sys.argv[3]) if len(sys.argv) > 3 else 0
    last = int(sys.argv[4]) if len(sys.argv) > 4 else None
    m = B.Module(path.read_bytes(), opmap())
    p = m.protos[proto]
    print(f'# {path.name} key={m.key} protos={len(m.protos)} P{proto} name={m.name(p)!r} sizecode={p.sizecode} '
          f'instructions={len(p.instructions)} header={p.header.hex()}')
    print('\n'.join(lines(m, p, first, last)))
