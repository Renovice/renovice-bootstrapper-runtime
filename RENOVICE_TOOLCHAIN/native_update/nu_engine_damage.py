"""ENGINE_DAMAGE registration derived from game code (the method of RESEARCH/ENGINE_DAMAGE_CODEC_2026-09-30,
tools/derive_engine_damage_layout.py), from scratch for a new image: nothing is carried over from the previous
registration except the DamageControl handler0 vtable slot (0xF8), which is re-checked by the vtable scan.

Every value has an independent cross-check; a value that cannot be derived uniquely leaves the whole registration out
(ENGINE_DAMAGE installs nothing on that build: fail closed).
"""
from __future__ import annotations

import collections
import re
import struct

from nu_image import Image
from nu_source import ED_LAYOUT, name_hash

DAMAGECONTROL_HANDLER0_SLOT = 0xF8
ACCESSOR = re.compile(rb'\x48\x81\xc1(.{4})\x8b\x01\xc1\xc0(.)\x48\xc1\xf9\x03\x33\xc1\x35(.{4})\xc3', re.S)
EVALUATOR = re.compile(
    r'movzx r8d, byte ptr \[rcx \+ (0x\w+)\] \| mov rdx, rcx \| test r8b, (0x\w+) \| je \w+ \| '
    r'movss xmm0, dword ptr \[rcx \+ (0x\w+)\] \| ret  \| movss xmm1, dword ptr \[rcx \+ 0x1c\] \| '
    r'test r8b, (0x\w+) \| je \w+ \| movss xmm0, dword ptr \[rcx \+ (0x\w+)\] \| '
    r'addss xmm0, dword ptr \[rcx \+ (0x\w+)\] \| jmp \w+ \| lea rax, \[rcx \+ (0x\w+)\] \| '
    r'mov ecx, dword ptr \[rcx \+ (0x\w+)\] \| rol ecx, (0x\w+) \| sar rax, 3 \| xor ecx, eax \| '
    r'xor ecx, (0x\w+) \| movd xmm0, ecx \| addss xmm0, dword ptr \[rdx \+ (0x\w+)\]')


def _accessors(img: Image) -> dict[int, dict]:
    found = {}
    for m in ACCESSOR.finditer(img.mem, img.text[0], img.text[1]):
        found[m.start()] = {'field': struct.unpack('<I', m.group(1))[0], 'rotate': m.group(2)[0],
                            'key': struct.unpack('<I', m.group(3))[0]}
    return found


def _rdata(img: Image):
    s = img.section('.rdata')
    return s[1], s[1] + s[2]


def _vtable_run_start(img: Image, rva: int, lo: int) -> int:
    start = rva
    while start - 8 >= lo and img.is_code(img.q(start - 8) - img.base):
        start -= 8
    return start


def _binding_slots(img: Image, name: str, seed: int):
    marker = struct.pack('<I', name_hash(name, seed))
    functions, at = set(), img.mem.find(marker)
    while at >= 0:
        if at % 8 == 0 and img.mem[at + 4:at + 8] == bytes(4):
            address = struct.unpack_from('<Q', img.mem, at + 8)[0]
            if img.is_code(address - img.base):
                functions.add(address - img.base)
        at = img.mem.find(marker, at + 1)
    slots = set()
    for function in functions:
        for ins in img.decode(function, 0x120):
            m = re.fullmatch(r'qword ptr \[rdx \+ (0x[0-9a-f]+)\]', ins.op_str)
            if ins.mnemonic == 'call' and m:
                slots.add(int(m.group(1), 16))
                break
            if ins.mnemonic == 'ret':
                break
    return sorted(slots), sorted(functions)


def derive(img: Image, handlers: list[int], seed: int) -> tuple[dict | None, list[str], list[str]]:
    """(registration fields, evidence, failures). Registration is None on any failure."""
    ev, fail = [], []
    handler0 = handlers[0]
    code = img.decode(handler0, 0x900)
    text = [(i.rva, i.mnemonic, i.op_str) for i in code]
    roles = {op for _, mn, op in text[:24] if mn == 'mov' and op in ('r12, rcx', 'r14, rdx')}
    if roles != {'r12, rcx', 'r14, rdx'}:
        fail.append(f'handler0 0x{handler0:x}: register roles {sorted(roles)} (expected r12=control, r14=packet)')
    target = {int(m.group(1), 16) for k, (_, mn, op) in enumerate(text[:-2])
              for m in [re.fullmatch(r'rcx, qword ptr \[r12 \+ (0x[0-9a-f]+)\]', op)]
              if mn == 'mov' and m and any(t[1] == 'call' and t[2].startswith('qword ptr [rax + ')
                                           for t in text[k + 1:k + 3])}
    calls = set()
    for k, (_, mn, op) in enumerate(text[:-1]):
        m = re.fullmatch(r'rcx, \[r14 \+ (0x[0-9a-f]+)\]', op)
        if mn == 'lea' and m and text[k + 1][1] == 'call' and text[k + 1][2].startswith('0x'):
            calls.add((int(m.group(1), 16), int(text[k + 1][2], 16)))
    loads = sorted({int(m.group(1) or '0', 16) for _, mn, op in text if mn == 'movups'
                    for m in [re.fullmatch(r'xmm\d+, xmmword ptr \[r14(?: \+ (0x[0-9a-f]+))?\]', op)] if m})
    if len(target) != 1:
        fail.append(f'control->target offset not unique: {sorted(target)}')
    if len(calls) != 1:
        fail.append(f'packet->UpgradedValue + evaluator call not unique: {sorted(calls)}')
    fractions = loads[0] if loads else None
    if fractions is None or [o for o in loads if fractions <= o < fractions + 0x50] != [fractions + 16 * i for i in range(5)]:
        fail.append(f'20 damage fractions as five 16-byte loads not found: {loads}')
    if fail:
        return None, ev, fail
    control_target = target.pop()
    packet_value, evaluator = calls.pop()
    ev.append(f'handler0 0x{handler0:x}: control->target +0x{control_target:x}, packet->value +0x{packet_value:x}, '
              f'evaluator 0x{evaluator:x}, fractions +0x{fractions:x}')
    joined = ' | '.join(f'{i.mnemonic} {i.op_str}' for i in img.decode(evaluator, 0x60))
    m = EVALUATOR.search(joined)
    if not m or m.start() != 0:
        return None, ev, fail + [f'evaluator 0x{evaluator:x}: shape not recognized']
    v = [int(x, 16) for x in m.groups()]
    if v[5] != v[10] or v[6] != v[7]:
        return None, ev, fail + ['evaluator: addition/encoded offsets inconsistent']
    layout = {'control_target': control_target, 'packet_fractions': fractions, 'packet_value': packet_value,
              'value_flags': v[0], 'value_override_flag': v[1], 'value_override': v[2], 'value_cached_flag': v[3],
              'value_cached': v[4], 'value_addition': v[5], 'value_encoded': v[6]}
    float_codec = {'rotate': v[8], 'key': v[9]}
    ev.append(f'evaluator: float codec rol{v[8]}/0x{v[9]:08x}, flags +0x{v[0]:x} override 0x{v[1]:x}->+0x{v[2]:x} '
              f'cached 0x{v[3]:x}->+0x{v[4]:x} encoded +0x{v[6]:x} addition +0x{v[5]:x}')
    for method, fieldname in (('GetHealth', 'target_health_slot'), ('GetShield', 'control_shield_slot'),
                              ('GetOverguardAmount', 'control_overguard_slot')):
        slots, functions = _binding_slots(img, method, seed)
        if len(slots) != 1:
            fail.append(f'Lua binding {method}: slots {slots} (functions {[hex(f) for f in functions]})')
        else:
            layout[fieldname] = slots[0]
            ev.append(f'Lua binding {method} ({len(functions)} function(s)) -> call [rdx+0x{slots[0]:x}]')
    if fail:
        return None, ev, fail
    accessors = _accessors(img)
    by_va = {img.base + rva: info for rva, info in accessors.items()}
    lo, hi = _rdata(img)
    handler_va = img.base + handler0
    tables = [rva - DAMAGECONTROL_HANDLER0_SLOT for rva in range(lo, hi - 7, 8) if img.q(rva) == handler_va]
    exact = sum(_vtable_run_start(img, t + DAMAGECONTROL_HANDLER0_SLOT, lo) == t for t in tables)
    if not tables or exact != len(tables):
        return None, ev, fail + [f'DamageControl vtables holding handler0 at +0x{DAMAGECONTROL_HANDLER0_SLOT:x}: '
                                 f'{len(tables)} found, {exact} at exact run starts']
    codecs = collections.Counter()
    for fieldname in ('control_shield_slot', 'control_overguard_slot'):
        for t in tables:
            info = by_va.get(img.q(t + layout[fieldname]))
            codecs[(info['rotate'], info['key']) if info else None] += 1
    if None in codecs or len(codecs) != 1:
        return None, ev, fail + [f'shield/Overguard accessor codecs across {len(tables)} DamageControl vtables: '
                                 f'{dict(codecs)} (expected one codec)']
    rotate, key = next(iter(codecs))
    health = collections.Counter()
    for rva in range(lo, hi - 7, 8):
        info = by_va.get(img.q(rva))
        if info and rva - _vtable_run_start(img, rva, lo) == layout['target_health_slot']:
            health[(info['rotate'], info['key'])] += 1
    if not health or set(health) != {(rotate, key)}:
        return None, ev, fail + [f'health-slot accessors {dict(health)} not all on the shield/Overguard codec']
    histogram = collections.Counter((a['rotate'], a['key']) for a in accessors.values())
    ev.append(f'{len(tables)} DamageControl vtables, shield/Overguard accessors rol{rotate}/0x{key:08x}; '
              f'{sum(health.values())} vtables with an accessor at health +0x{layout["target_health_slot"]:x}; '
              f'accessor codecs in image {dict((f"rol{r}/0x{k:08x}", n) for (r, k), n in histogram.items())}')
    if img.mem.count(key.to_bytes(4, 'little')) == 0 or img.mem.count(float_codec['key'].to_bytes(4, 'little')) == 0:
        return None, ev, fail + ['codec key absent from image']
    reg = {'handlers': handlers, 'evaluator': evaluator, 'integer_codec': {'rotate': rotate, 'key': key},
           'float_codec': float_codec, 'layout': {k: layout[k] for k in ED_LAYOUT}}
    return reg, ev, []


def compare(prev: dict, new: dict) -> list[str]:
    """Human list of what differs between two registrations (addresses and values)."""
    out = []
    if prev['handlers'] != new['handlers']:
        out.append('handlers ' + ' '.join(f'0x{a:x}->0x{b:x}' for a, b in zip(prev['handlers'], new['handlers'])))
    if prev['evaluator'] != new['evaluator']:
        out.append(f'evaluator 0x{prev["evaluator"]:x}->0x{new["evaluator"]:x}')
    for k in ('integer_codec', 'float_codec'):
        if prev[k] != new[k]:
            out.append(f'{k} rol{prev[k]["rotate"]}/0x{prev[k]["key"]:08x} -> rol{new[k]["rotate"]}/0x{new[k]["key"]:08x}')
    for k in ED_LAYOUT:
        if prev['layout'][k] != new['layout'][k]:
            out.append(f'layout.{k} 0x{prev["layout"][k]:x}->0x{new["layout"][k]:x}')
    return out


def row_cpp(label: str, digests: list[str], reg: dict) -> str:
    d = (digests + ['', ''])[:2]
    lay = reg['layout']
    digest_text = (f'{{"{d[0]}", ""}}' if not d[1] else f'{{"{d[0]}",\n         "{d[1]}"}}')
    lines = [
        '    {',
        f'        "{label}",',
        f'        {digest_text},',
        '        {' + ', '.join(f'0x{h:x}' for h in reg['handlers']) + '},',
        f'        0x{reg["evaluator"]:x},',
        f'        {{{reg["integer_codec"]["rotate"]}, 0x{reg["integer_codec"]["key"]:08x}}},',
        f'        {{{reg["float_codec"]["rotate"]}, 0x{reg["float_codec"]["key"]:08x}}},',
        '        {',
    ]
    for k in ED_LAYOUT:
        v = lay[k]
        lines.append(f'            0x{v:02x},')
    lines += ['        },', '    },']
    return '\n'.join(lines)
