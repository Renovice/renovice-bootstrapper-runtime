"""Read-only PE32+ image model for the native update tool.

The image is mapped at its section RVAs (RVA == offset into `mem`), exactly like the in-process module the runtime
scans and like the offline verifiers (`verify_client_44.cpp map_image`). Nothing here writes a file.

Volatile operand fields: an instruction's rel32 branch displacement, its RIP-relative disp32 and an absolute RVA used as
a memory displacement (MSVC switch tables: `mov ecx,[rdx+rax*4+TABLE]`). These are the bytes a relink changes without
changing the code; every relocation strategy masks exactly these, never an opcode, register, immediate or stack size.
"""
from __future__ import annotations

import bisect
import functools
import hashlib
import re
import struct
from pathlib import Path

import capstone

_MD = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
_MD.detail = True
_MDL = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)

BRANCH_MNEMONICS = re.compile(r'^(call|jmp|j[a-z]{1,3}|loop\w*|jrcxz|jecxz)$')


@functools.lru_cache(None)
def pattern_regex(pattern: str):
    parts = []
    for t in pattern.split():
        parts.append(b'.' if t in ('?', '??') else re.escape(bytes([int(t, 16)])))
    return re.compile(b''.join(parts), re.S)


def pattern_tokens(pattern: str) -> list[int | None]:
    return [None if t in ('?', '??') else int(t, 16) for t in pattern.split()]


def tokens_pattern(tokens: list[int | None]) -> str:
    return ' '.join('?' if t is None else f'{t:02X}' for t in tokens)


class Field:
    """One volatile operand field of a decoded instruction."""
    __slots__ = ('offset', 'size', 'kind', 'target', 'opsize')

    def __init__(self, offset: int, size: int, kind: str, target: int, opsize: int = 0):
        self.offset, self.size, self.kind, self.target, self.opsize = offset, size, kind, target, opsize

    def __repr__(self):
        return f'Field(+{self.offset},{self.size},{self.kind},0x{self.target:x})'


class Insn:
    __slots__ = ('rva', 'size', 'mnemonic', 'op_str', 'raw', 'fields')

    def __init__(self, rva, size, mnemonic, op_str, raw, fields):
        self.rva, self.size, self.mnemonic, self.op_str, self.raw, self.fields = \
            rva, size, mnemonic, op_str, raw, fields

    def __repr__(self):
        return f'{self.rva:x}: {self.raw.hex():<20} {self.mnemonic} {self.op_str}'


class Image:
    def __init__(self, data: bytes, path: str | Path | None = None):
        self.path = str(path) if path else None
        self.file = data
        self.sha256 = hashlib.sha256(data).hexdigest()
        nt = struct.unpack_from('<I', data, 0x3C)[0]
        if data[nt:nt + 4] != b'PE\0\0':
            raise ValueError('not a PE image')
        sections = struct.unpack_from('<H', data, nt + 6)[0]
        opt_size = struct.unpack_from('<H', data, nt + 20)[0]
        opt = nt + 24
        if struct.unpack_from('<H', data, opt)[0] != 0x20B:
            raise ValueError('not PE32+')
        self.base = struct.unpack_from('<Q', data, opt + 24)[0]
        self.entry = struct.unpack_from('<I', data, opt + 16)[0]
        image_size = struct.unpack_from('<I', data, opt + 56)[0]
        headers = struct.unpack_from('<I', data, opt + 60)[0]
        mem = bytearray(image_size)
        mem[:headers] = data[:headers]
        self.sections = []
        self.section_headers = []
        for i in range(sections):
            h = opt + opt_size + i * 40
            name = data[h:h + 8].rstrip(b'\0').decode('ascii', 'replace')
            vsize, va, rsize, roff = struct.unpack_from('<IIII', data, h + 8)
            copy = rsize if (rsize < vsize or vsize == 0) else vsize
            if copy:
                mem[va:va + copy] = data[roff:roff + copy]
            self.sections.append((name, va, vsize, roff, rsize))
            self.section_headers.append(h)
        self.mem = bytes(mem)
        self.size = image_size
        self.data_dirs = [struct.unpack_from('<II', data, opt + 112 + 8 * i) for i in range(16)]
        text = self.section('.text')
        self.text = (text[1], text[1] + text[2])
        self._functions = None
        self._imports = None
        self._rel_index = None

    @classmethod
    def load(cls, path: str | Path) -> 'Image':
        return cls(Path(path).read_bytes(), path)

    # -- layout ---------------------------------------------------------------------------------------------------------
    def section(self, name: str):
        return next(s for s in self.sections if s[0] == name)

    def section_of(self, rva: int) -> str | None:
        for name, va, vsize, _roff, _rsize in self.sections:
            if va <= rva < va + max(vsize, 1):
                return name
        return None

    def is_code(self, rva: int) -> bool:
        return self.text[0] <= rva < self.text[1]

    def rva_to_offset(self, rva: int) -> int | None:
        for _name, va, vsize, roff, rsize in self.sections:
            if va <= rva < va + min(vsize or rsize, rsize):
                return roff + rva - va
        return None

    def functions(self) -> list[tuple[int, int]]:
        """Sorted (begin, end) of every .pdata RUNTIME_FUNCTION (leaf functions have none)."""
        if self._functions is None:
            rva, size = self.data_dirs[3]
            out = []
            for i in range(size // 12):
                b, e, _u = struct.unpack_from('<III', self.mem, rva + 12 * i)
                if b and e > b:
                    out.append((b, e))
            out.sort()
            self._functions = out
            self._function_starts = [b for b, _e in out]
        return self._functions

    def containing_function(self, rva: int) -> tuple[int, int] | None:
        funcs = self.functions()
        i = bisect.bisect_right(self._function_starts, rva) - 1
        if i >= 0 and funcs[i][0] <= rva < funcs[i][1]:
            return funcs[i]
        return None

    def code_start_before(self, rva: int) -> int:
        """A decoding start at or before `rva` that is an instruction boundary: the covering .pdata entry; outside
        .pdata (leaf functions, which every signature here starts at) the span itself."""
        f = self.containing_function(rva)
        return f[0] if f else rva

    # -- scans ---------------------------------------------------------------------------------------------------------
    def scan(self, pattern: str, limit: int | None = None, start: int = 0, end: int | None = None) -> list[int]:
        rx = pattern_regex(pattern)
        hits, pos = [], start
        end = len(self.mem) if end is None else end
        while True:
            m = rx.search(self.mem, pos, end)
            if not m:
                return hits
            hits.append(m.start())
            if limit is not None and len(hits) >= limit:
                return hits
            pos = m.start() + 1

    def scan_file(self, pattern: str) -> list[int]:
        rx = pattern_regex(pattern)
        hits, pos = [], 0
        while True:
            m = rx.search(self.file, pos)
            if not m:
                return hits
            hits.append(m.start())
            pos = m.start() + 1

    def u32(self, rva: int) -> int:
        return struct.unpack_from('<I', self.mem, rva)[0]

    def q(self, rva: int) -> int:
        return struct.unpack_from('<Q', self.mem, rva)[0]

    def rel32_target(self, displacement_rva: int) -> int:
        return displacement_rva + 4 + struct.unpack_from('<i', self.mem, displacement_rva)[0]

    def bytes_at(self, rva: int, n: int) -> bytes:
        return self.mem[rva:rva + n]

    # -- decoding ------------------------------------------------------------------------------------------------------
    def decode(self, rva: int, size: int) -> list[Insn]:
        out = []
        for i in _MD.disasm(self.mem[rva:rva + size + 16], rva):
            if i.address >= rva + size:
                break
            out.append(Insn(i.address, i.size, i.mnemonic, i.op_str, bytes(i.bytes), self._fields(i)))
        return out

    def _fields(self, i) -> list[Field]:
        fields = []
        if BRANCH_MNEMONICS.match(i.mnemonic) and i.imm_size == 4 and i.operands and i.operands[0].type == 2:
            fields.append(Field(i.imm_offset, 4, 'rel', i.operands[0].imm))
        if i.disp_size == 4:
            for op in i.operands:
                if op.type == 3:
                    mem = op.mem
                    if mem.base == capstone.x86.X86_REG_RIP:
                        fields.append(Field(i.disp_offset, 4, 'rip', i.address + i.size + mem.disp, op.size))
                    elif (mem.index != 0 and 0x1000 <= mem.disp < self.size
                          and mem.base not in (capstone.x86.X86_REG_RSP, capstone.x86.X86_REG_RBP)):
                        fields.append(Field(i.disp_offset, 4, 'absrva', mem.disp, op.size))
                    break
        return fields

    def instructions_covering(self, rva: int, length: int) -> list[Insn] | None:
        """Instructions whose bytes overlap [rva, rva+length), decoded from a proven boundary. None when the span
        does not decode cleanly from that boundary (data, or a start inside an instruction we cannot align)."""
        start = self.code_start_before(rva)
        if rva - start > 0x20000:
            start = rva
        out = []
        pos = start
        while pos < rva + length:
            progressed = False
            for i in _MD.disasm(self.mem[pos:pos + 0x400], pos):
                if i.address >= rva + length:
                    break
                if i.address + i.size > rva:
                    out.append(Insn(i.address, i.size, i.mnemonic, i.op_str, bytes(i.bytes), self._fields(i)))
                pos = i.address + i.size
                progressed = True
            if not progressed:
                return None
        if not out or out[0].rva > rva:
            return None
        return out

    def volatile_mask(self, rva: int, length: int) -> list[bool] | None:
        """True at every byte of [rva, rva+length) that belongs to a volatile operand field."""
        ins = self.instructions_covering(rva, length)
        if ins is None:
            return None
        mask = [False] * length
        for i in ins:
            for f in i.fields:
                for k in range(f.size):
                    p = i.rva + f.offset + k - rva
                    if 0 <= p < length:
                        mask[p] = True
        return mask

    # -- imports / exports --------------------------------------------------------------------------------------------
    def _cstr(self, rva: int) -> str:
        end = self.mem.index(b'\0', rva)
        return self.mem[rva:end].decode('ascii', 'replace')

    def imports(self) -> dict[str, list[tuple[str | None, int]]]:
        if self._imports is not None:
            return self._imports
        rva, _size = self.data_dirs[1]
        out: dict[str, list[tuple[str | None, int]]] = {}
        off = rva
        while rva:
            ilt, _ts, _fw, name_rva, iat = struct.unpack_from('<IIIII', self.mem, off)
            if not (ilt or name_rva or iat):
                break
            dll = self._cstr(name_rva)
            entries = out.setdefault(dll, [])
            table = ilt or iat
            k = 0
            while True:
                thunk = struct.unpack_from('<Q', self.mem, table + 8 * k)[0]
                if thunk == 0:
                    break
                fn = None if thunk & (1 << 63) else self._cstr((thunk & 0x7FFFFFFF) + 2)
                entries.append((fn, iat + 8 * k))
                k += 1
            off += 20
        self._imports = out
        return out

    def import_slot(self, dll: str, function: str) -> int:
        """IAT slot bound by name; 0 when missing or ambiguous (de_vm_authority find_import_slot_rva)."""
        slots = [slot for name, entries in self.imports().items() if name.lower() == dll.lower()
                 for fn, slot in entries if fn == function]
        return slots[0] if len(slots) == 1 else 0

    def import_name_at(self, slot: int) -> str | None:
        if not hasattr(self, '_slot_names'):
            self._slot_names = {s: f'{dll.lower()}!{fn}' for dll, entries in self.imports().items()
                                for fn, s in entries}
        return self._slot_names.get(slot)

    def exports(self) -> list[str]:
        rva, _size = self.data_dirs[0]
        if not rva:
            return []
        n_names = struct.unpack_from('<I', self.mem, rva + 24)[0]
        names_rva = struct.unpack_from('<I', self.mem, rva + 32)[0]
        return [self._cstr(struct.unpack_from('<I', self.mem, names_rva + 4 * i)[0]) for i in range(n_names)]

    # -- references ---------------------------------------------------------------------------------------------------
    def rel_index(self) -> dict[int, list[tuple[int, int]]]:
        """{target: [(site, opcode)]} of every E8/E9 rel32 in .text (raw scan, as the R16 research tool did)."""
        if self._rel_index is None:
            idx: dict[int, list[tuple[int, int]]] = {}
            lo, hi = self.text
            mem = self.mem
            for m in re.finditer(rb'[\xe8\xe9]', mem[lo:hi]):
                j = lo + m.start()
                if j + 5 > hi:
                    continue
                t = j + 5 + struct.unpack_from('<i', mem, j + 1)[0]
                if lo <= t < hi:
                    idx.setdefault(t, []).append((j, mem[j]))
            self._rel_index = idx
        return self._rel_index

    def callers(self, target: int) -> list[int]:
        return sorted(s for s, op in self.rel_index().get(target, []) if op == 0xE8)

    def jumpers(self, target: int) -> list[int]:
        return sorted(s for s, op in self.rel_index().get(target, []) if op == 0xE9)

    def lea_refs(self, target: int) -> list[int]:
        lo, hi = self.text
        res = []
        for m in re.finditer(rb'[\x48\x4c]\x8d[\x05\x0d\x15\x1d\x25\x2d\x35\x3d]', self.mem[lo:hi]):
            j = lo + m.start()
            if j + 7 + struct.unpack_from('<i', self.mem, j + 3)[0] == target:
                res.append(j)
        return res

    def qword_refs(self, target: int) -> list[int]:
        needle = struct.pack('<Q', self.base + target)
        return [m.start() for m in re.finditer(re.escape(needle), self.mem)]

    # -- version resource ---------------------------------------------------------------------------------------------
    def product_version(self) -> str | None:
        key = 'ProductVersion'.encode('utf-16-le') + b'\0\0'
        rva, size = self.data_dirs[2]
        blob = self.mem[rva:rva + size] if rva else self.file
        i = blob.find(key)
        if i < 0:
            return None
        j = i + len(key)
        j += (-j) % 4 if rva else 0
        while j < len(blob) and blob[j:j + 2] == b'\0\0':
            j += 2
        end = blob.find(b'\0\0', j)
        while end != -1 and (end - j) % 2:
            end = blob.find(b'\0\0', end + 1)
        return blob[j:end].decode('utf-16-le', 'replace') if end != -1 else None
