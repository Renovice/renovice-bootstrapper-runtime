# OBJECT_REFLECTION_V1 exe-structural gate (2026-10-31). READ-ONLY on the client executable.
#
#   python verify_object_reflection_exe.py <client.exe> "<RESOLVED line of verify_object_reflection_core.exe>"
#
# Independent of the C++ resolver (capstone disassembly, no shared code):
#   1. re-finds the metadata text-apply chain from the Metadata Patches signature
#      (reader ctor, text load, ApplyArchive, reader dtor) and compares it with the
#      C++ RESOLVED line;
#   2. confirms the writer sequence ctor -> begin -> ApplyArchive(obj, w, 1) -> end at
#      >= 2 engine sites for the C++ writer functions;
#   3. decodes the engine name normaliser and checks the exact rule the C++ core
#      implements (drop through last '.'/'>', drop m/s/g before 'A'..'Z');
#   4. finds NpcAiDirector's field-visit virtual WITHOUT an address (string
#      "mHardMaxAICap" -> name record -> lea xref -> function -> vtable slot +0x50)
#      and decodes its fields as the archive sees them; expects HardMaxAICap int,
#      SpawnTimer float, EventTimer float.
# Exit code 0 = PASS. Requires pefile and capstone.
import re
import struct
import sys

import capstone
import pefile

SLOTS = {0xc0: 'float', 0xd0: 'bool', 0x108: 'int', 0x110: 'int', 0x120: 'symbol'}
SIG = '41 B1 03 48 8D 55 ? 45 33 C0 48 8D 8D ? ? ? ? E8'

failures = []


def check(condition, message):
    print(('PASS\t' if condition else 'FAIL\t') + message)
    if not condition:
        failures.append(message)


def normalise(raw):
    start = 0
    for i, c in enumerate(raw):
        if c in '.>':
            start = i + 1
    name = raw[start:]
    if len(name) >= 2 and name[0] in 'msg' and 'A' <= name[1] <= 'Z':
        name = name[1:]
    return name


def main():
    exe, resolved_line = sys.argv[1], sys.argv[2]
    resolved = dict(kv.split('=', 1) for kv in resolved_line.split() if '=' in kv and not kv.startswith('image='))
    want = {k: int(v, 16) for k, v in resolved.items() if v.startswith('0x')}

    pe = pefile.PE(exe, fast_load=True)
    base = pe.OPTIONAL_HEADER.ImageBase
    image = pe.get_memory_mapped_image()
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
    text = [s for s in pe.sections if s.Characteristics & 0x20000000]

    def dis(va, count):
        o = va - base
        return list(md.disasm(image[o:o + count * 15], va))[:count]

    def u64(va):
        return struct.unpack_from('<Q', image, va - base)[0]

    def cstr(va):
        o = va - base
        return image[o:image.index(b'\0', o)].decode('latin1')

    def in_text(va):
        return any(s.VirtualAddress + base <= va < s.VirtualAddress + base + s.Misc_VirtualSize for s in text)

    def pattern(sig):
        return re.compile(b''.join(b'.' if t == '?' else re.escape(bytes([int(t, 16)])) for t in sig.split()), re.S)

    # 1. Reader chain from the signature.
    sites = [m.start() + base for s in text for m in pattern(SIG).finditer(
        image, s.VirtualAddress, s.VirtualAddress + s.Misc_VirtualSize)]
    check(len(sites) == 1, 'metadata site unique (%d)' % len(sites))
    site = sites[0]
    window = dis(site - 0x40, 60)
    calls = [i for i in window if i.mnemonic == 'call' and i.op_str.startswith('0x')]
    reader_ctor = int([c for c in calls if c.address < site][-1].op_str, 16)
    text_load = int([c for c in calls if c.address > site][0].op_str, 16)
    after = [i for i in window if i.address > site]
    lock = next(k for k, i in enumerate(after) if i.mnemonic == 'mov' and i.op_str == 'r8b, 1')
    apply_call = next(i for i in after[lock:] if i.mnemonic == 'call')
    apply_fn = int(apply_call.op_str, 16)
    reader_dtor = int(next(i for i in after if i.mnemonic == 'call' and i.address > apply_call.address
                           and 'rbp + 0x' in after[after.index(i) - 1].op_str).op_str, 16)
    check(site == want['site'], 'site matches C++ resolver %#x' % site)
    check(reader_ctor == want['reader_ctor'], 'reader ctor matches %#x' % reader_ctor)
    check(text_load == want['text_load'], 'text load matches %#x' % text_load)
    check(apply_fn == want['apply'], 'ApplyArchive matches %#x' % apply_fn)
    check(reader_dtor == want['reader_dtor'], 'reader dtor matches %#x' % reader_dtor)
    apply_body = dis(apply_fn, 80)
    check(any(i.mnemonic == 'call' and i.op_str == 'qword ptr [rax + 0x50]' for i in apply_body),
          'ApplyArchive calls the object field-visit virtual (vtable +0x50)')

    # 2. Writer sequence at engine sites.
    callers = []
    for s in text:
        lo = s.VirtualAddress
        blob = image[lo:lo + s.Misc_VirtualSize]
        for m in re.finditer(b'\xe8', blob):
            o = m.start()
            if o + 5 <= len(blob) and lo + base + o + 5 + struct.unpack_from('<i', blob, o + 1)[0] == apply_fn:
                callers.append(lo + base + o)
    agreeing = 0
    for c in callers:
        before = [i for i in dis(c - 0x30, 24) if i.address < c]
        later = dis(c, 6)
        targets = [int(i.op_str, 16) for i in before if i.mnemonic == 'call' and i.op_str.startswith('0x')]
        nxt = [int(i.op_str, 16) for i in later[1:] if i.mnemonic == 'call' and i.op_str.startswith('0x')]
        if (len(targets) >= 2 and targets[-2:] == [want['writer_ctor'], want['writer_begin']]
                and nxt and nxt[0] == want['writer_end']):
            agreeing += 1
    check(agreeing >= 2, 'writer ctor/begin/ApplyArchive/end agreed by %d engine sites' % agreeing)
    wctor = dis(want['writer_ctor'], 30)
    check(any(i.mnemonic == 'mov' and i.op_str == 'dword ptr [rdi + %#x], ebx' % want['writer_flags_offset'] for i in wctor),
          'writer ctor stores its flags at %#x' % want['writer_flags_offset'])
    check(any(i.mnemonic == 'mov' and i.op_str == 'word ptr [rdi + %#x], 0xf' % (want['writer_output'] + 0xf) for i in wctor),
          'writer ctor initialises the output GameString at %#x' % want['writer_output'])

    # 3. Normaliser rule.
    norm = dis(want['normaliser'], 60)
    ops = ['%s %s' % (i.mnemonic, i.op_str) for i in norm]
    for needed in ('movabs rcx, 0xa000000000000000', 'sub dl, 0x2e', 'test dl, 0xef', 'cmp dl, 0x6d',
                   'cmp al, 0x73', 'cmp al, 0x67', 'cmp dl, 0x41', 'cmp dl, 0x5a'):
        check(needed in ops, 'normaliser: %s' % needed)
    check(normalise('mHardMaxAICap') == 'HardMaxAICap' and normalise('mbX') == 'mbX'
          and normalise('this->mX') == 'X', 'normaliser rule as implemented by the C++ core')

    # 4. NpcAiDirector fields without addresses.
    needle = image.find(b'mHardMaxAICap\0')
    check(needle >= 0, 'string mHardMaxAICap present')
    string_va = needle + base
    record = None
    for s in pe.sections:
        if s.Characteristics & 0x80000000:  # writable data: name records
            blob = image[s.VirtualAddress:s.VirtualAddress + s.Misc_VirtualSize]
            for m in re.finditer(re.escape(struct.pack('<Q', string_va)), blob):
                o = m.start() - 8
                if o >= 0 and struct.unpack_from('<Q', blob, o)[0] & 0xe000000000000000 == 0xa000000000000000:
                    record = s.VirtualAddress + base + o
    check(record is not None, 'name record for mHardMaxAICap')
    xref = None
    for s in text:
        lo = s.VirtualAddress
        blob = image[lo:lo + s.Misc_VirtualSize]
        for m in re.finditer(b'\x48\x8d\x15', blob):
            o = m.start()
            if lo + base + o + 7 + struct.unpack_from('<i', blob, o + 3)[0] == record:
                xref = lo + base + o
                break
        if xref:
            break
    check(xref is not None, 'field-visit code references the record')
    pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_EXCEPTION']])
    rva = xref - base
    function = next(e.struct.BeginAddress + base for e in pe.DIRECTORY_ENTRY_EXCEPTION
                    if e.struct.BeginAddress <= rva < e.struct.EndAddress)
    # Chained unwind info: the outer function begins at or before this fragment; the
    # vtable slot holds an entry in the same function (prologue thunk or body).
    vtable = None
    for s in pe.sections:
        if s.Characteristics & 0x20000000 or s.Characteristics & 0x80000000:
            continue
        blob = image[s.VirtualAddress:s.VirtualAddress + s.Misc_VirtualSize]
        for candidate in (function, function - 0x10):
            for m in re.finditer(re.escape(struct.pack('<Q', candidate)), blob):
                if m.start() % 8 == 0:
                    vtable = s.VirtualAddress + base + m.start() - 0x50
                    break
            if vtable:
                break
    check(vtable is not None and in_text(u64(vtable + 0x50)), 'NpcAiDirector vtable found from the field-visit function')
    visit = u64(vtable + 0x50)
    fields, name, last = [], None, None
    for i in dis(visit, 3000):
        if i.mnemonic == 'ret':
            break
        if i.mnemonic == 'lea' and i.op_str.startswith('rdx, [rip'):
            last = i.address + i.size + int(i.op_str.split('+ ')[1].rstrip(']'), 16)
        m = re.match(r'qword ptr \[rax \+ (0x[0-9a-f]+)\]', i.op_str) if i.mnemonic == 'call' else None
        if m:
            slot = int(m.group(1), 16)
            if slot == 0x138:
                name = normalise(cstr(u64(last + 8)))
            elif name:
                fields.append((name, SLOTS.get(slot, 'other'), slot))
                name = None
        elif i.mnemonic == 'call' and name:
            fields.append((name, 'other', 0))
            name = None
    lookup = {n: t for n, t, _ in fields}
    print('INFO\tNpcAiDirector visit=%#x vtable=%#x fields=%d' % (visit, vtable, len(fields)))
    check(len(fields) >= 40, 'NpcAiDirector field count %d >= 40' % len(fields))
    check(lookup.get('HardMaxAICap') == 'int', 'HardMaxAICap is int (text key without the m prefix)')
    check(lookup.get('SpawnTimer') == 'float', 'SpawnTimer is float')
    check(lookup.get('EventTimer') == 'float', 'EventTimer is float')
    for n, t, slot in fields[:12]:
        print('INFO\tfield %s %s slot=%#x' % (n, t, slot))
    if failures:
        print('OBJECT REFLECTION EXE GATE FAIL failures=%d' % len(failures))
        return 1
    print('OBJECT REFLECTION EXE GATE PASS image=%s' % exe)
    return 0


if __name__ == '__main__':
    sys.exit(main())
