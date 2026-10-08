# Icebind Solo package members: build + offline gates (research tool, 2026-10-08, client 44.1.0 2026.10.06.16.12).
#
# Both members are exact content-key root replacements that differ from the stock module of this build ONLY in the
# instruction words listed in EDITS (instruction-level edits: same prototypes, string pool, constants and code sizes),
# so the update tool rebases them automatically after a future Warframe update (uc_artifacts.rebase_replacement).
#
# Gates (each printed PASS/FAIL, all recorded in ../build/gates.json and ../build/diff_report.md):
#   stock-key            stock bytes hash to the manifest content key (the loader's match key, = filename key)
#   expected-old-word    every edited instruction holds the expected canonical stock word before the edit
#   parse-u44            the candidate parses with the toolchain U44 opcode profile, clean instruction walks
#   same-shape           same prototype count / string pool / constants / code sizes as stock
#   byte-diff            the candidate differs from stock only inside the edited instruction words
#   edit-script          uc_artifacts.edit_script(stock, candidate) == exactly the intended (proto, instruction) edits
#   self-rebase          rebase_replacement onto the unchanged stock reproduces the candidate byte for byte
#   shifted-rebase       rebase onto a synthetic shifted build (prototypes inserted first + no-op MOVEs inserted before
#                        each edited instruction) is AUTO and lands the same canonical words at the moved sites
#   de-roundtrip         derecomp de-roundtrip: the container re-emits byte-exact
#   const-identity       derecomp const-identity stock candidate --u44 (no constant / string / key-use change)
#   cfg-identity         derecomp cfg-identity stock candidate --u44 (reported; a compare-opcode edit may be listed)
# Usage: python build_members.py
import hashlib
import json
import struct
import subprocess
import sys
from pathlib import Path

import disasm

ROOT = disasm.ROOT
B = disasm.B
sys.path.insert(0, str(ROOT / 'repos/apps/ability-editor/tools/update_check'))
import uc_artifacts as ART  # noqa: E402
import uc_remap as RM  # noqa: E402
import uc_synthetic as S  # noqa: E402

HERE = Path(__file__).resolve().parent
OUT = HERE.parent / 'build'
STOCK = ROOT / 'work/temp/update-check/stock-a71c700d9520b4a5'
DERECOMP = ROOT / 'repos/toolchains/de-luau-toolchain/bin/derecomp.exe'
BUILD = '2026.10.06.16.12'

# canonical (U43-numbered) opcodes
JUMPIFNOTEQ, JUMPIFNOTLE, JUMPIFNOTLT, LOADN, LOADNIL, LOADB = 0x27, 0x33, 0x1c, 0x12, 0x0d, 0x04

MEMBERS = [
    {
        'stock': 'Lotus_Interface_SixStackSetup.lua_B',
        'key': '112349dd35bbea7a',
        'file': '112349dd35bbea7a (Icebind Solo squad gate).lua_B',
        'edits': [
            {   # OnSquadMembersChanged: `if #members ~= ICE_BLADE_HUB_MAX_PLAYERS then <cancel countdown>`
                'proto': 40, 'i': 18,
                'old': (JUMPIFNOTEQ, 3, 4), 'new': (JUMPIFNOTLE, 3, 4),
                'why': 'countdown gate: cancel only when #members > ICE_BLADE_HUB_MAX_PLAYERS (was: whenever ~= 6); '
                       'keeps AllPlayersOfferedKey and the one-of-each-Warframe check as the remaining start conditions',
            },
            {   # squad hint: `if not (#members < MAX) then <equip-keys hint> else <SetupFullSquadHint>`
                'proto': 17, 'i': 51,
                'old': (JUMPIFNOTLT, 3, 4), 'new': (JUMPIFNOTLT, 4, 3),
                'why': 'hint: show the equip-Cryobell hint path when #members <= MAX (was: only when #members >= MAX); '
                       'SetupFullSquadHint is shown only above the maximum',
            },
        ],
    },
    {
        'stock': 'Lotus_Scripts_KuvaPath_KuvaPath.lua_B',
        'key': '4db007fa8f0145bd',
        'file': '4db007fa8f0145bd (Icebind Solo squad scaling).lua_B',
        'edits': [
            {   # MasterInit: `_T.CalculatedSquadSize = 6`
                'proto': 65, 'i': 76,
                'old': (LOADN, 5, 6), 'new': (LOADNIL, 5, None),
                'why': 'MasterInit stores nil instead of the fixed 6, so the KuvaPath ComplicationsMgr (created right '
                       'after, master only) computes the stock value Clamp(GetNumHumanPlayers() + '
                       'Server.NumVirtualTestClients, 1, 6) and prints "Calculated squad size = N"',
            },
            {   # MasterInit: `<scale-to-players flag upvalue> = false` (i9 LOADB, i10 SETUPVAL 1), added 2026-10-08
                'proto': 65, 'i': 9,
                'old': (LOADB, 1, 0), 'new': (LOADB, 1, 1),
                'why': 'MasterInit sets the KuvaPath flag that makes Squad Side Objectives require min(GetNumHumanPlayers(), 6) '
                       'nearby players (else a fixed 6, the "requires 1/6 players" a solo run cannot meet) to true. Its '
                       'only other use runs a pending event from the ImGui debug "Start Event" button, unreachable '
                       'in normal play',
            },
        ],
    },
]


def sha(b):
    return hashlib.sha256(b).hexdigest()


def run(args):
    r = subprocess.run([str(x) for x in args], capture_output=True, text=True, encoding='utf-8', errors='replace',
                       timeout=600)
    return r.returncode, (r.stdout + r.stderr).strip()


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    om = disasm.opmap()
    raw_of = {c: r for r, c in enumerate(om)}
    gates, report = [], ['# Icebind Solo members: byte diff report', '',
                          f'Client 44.1.0 (`{BUILD}`), stock pack `stock-a71c700d9520b4a5`. Generated by '
                          '`tools/build_members.py`. Offsets are absolute file offsets; bytes are the raw U44 encoding.', '']
    ok_all = True

    def gate(member, name, ok, detail=''):
        nonlocal ok_all
        ok_all &= bool(ok)
        gates.append({'member': member, 'gate': name, 'pass': bool(ok), 'detail': detail})
        print(f'{"PASS" if ok else "FAIL"}  {member}: {name}' + (f'  [{detail}]' if detail else ''))

    manifest = {m['file']: m['key'] for m in json.loads((STOCK / 'manifest.json').read_text())['modules']}
    for spec in MEMBERS:
        name = spec['file']
        stock_bytes = (STOCK / spec['stock']).read_bytes()
        stock = B.Module(stock_bytes, om)
        gate(name, 'stock-key', stock.key == spec['key'] == manifest[spec['stock']] == name[:16],
             f'{spec["stock"]} key {stock.key}, sha256 {stock.sha256}')
        data = bytearray(stock_bytes)
        intended = []
        report += [f'## `{name}`', '', f'- Target: `{spec["stock"]}` , content key '
                   f'`{stock.key}`, stock size {len(stock_bytes)}, stock sha256 `{stock.sha256}`.', '',
                   '| Prototype | Instruction | File offset | Stock (canonical) | Edit (canonical) | Stock raw | Edit raw | Why |',
                   '|---|---|---|---|---|---|---|---|']
        for e in spec['edits']:
            p = stock.protos[e['proto']]
            logical, off, op = p.instructions[e['i']]
            w = stock.word(p, e['i'])
            old_op, old_a, old_x = e['old']
            if old_op == LOADN:
                ok = op == LOADN and w[1] == old_a and struct.unpack_from('<h', w, 2)[0] == old_x
            elif old_op == LOADB:
                ok = op == LOADB and w[1] == old_a and w[2] == old_x and w[3] == 0
            else:
                ok = op == old_op and w[1] == old_a and struct.unpack_from('<I', w, 4)[0] == old_x
            gate(name, f'expected-old-word P{e["proto"]} i{e["i"]}', ok, w.hex())
            new_op, new_a, new_x = e['new']
            nw = bytearray(w)
            nw[0] = new_op
            nw[1] = new_a
            if new_op == LOADNIL:
                nw[2] = nw[3] = 0
            elif new_op == LOADB:
                nw[2] = new_x                              # B = the boolean value; C (skip) stays 0
            elif new_op in (JUMPIFNOTLE, JUMPIFNOTLT):
                struct.pack_into('<I', nw, 4, new_x)       # Bx (branch target) unchanged
            raw = bytearray(nw)
            raw[0] = raw_of[new_op]
            start = p.code_start + off
            old_raw = bytes(data[start:start + len(w)])
            data[start:start + len(w)] = raw
            intended.append((e['proto'], e['i']))
            report.append(f'| P{e["proto"]} | i{e["i"]} | {start} (0x{start:x}) | `{w.hex()}` {disasm.NAMES[op]} | '
                          f'`{bytes(nw).hex()}` {disasm.NAMES[new_op]} | `{old_raw.hex()}` | `{bytes(raw).hex()}` | '
                          f'{e["why"]} |')
        cand_bytes = bytes(data)
        out = OUT / name
        out.write_bytes(cand_bytes)
        cand = B.Module(cand_bytes, om)
        gate(name, 'parse-u44', not cand.walk_errors() and len(cand.protos) == len(stock.protos),
             f'{len(cand.protos)} prototypes, walk errors {cand.walk_errors()[:2]}')
        diff = [i for i in range(len(stock_bytes)) if stock_bytes[i] != cand_bytes[i]]
        allowed = set()
        for pi, li in intended:
            p = stock.protos[pi]
            _, off, op = p.instructions[li]
            allowed |= set(range(p.code_start + off, p.code_start + off + len(stock.word(p, li))))
        gate(name, 'byte-diff', len(cand_bytes) == len(stock_bytes) and diff and set(diff) <= allowed,
             f'{len(diff)} bytes differ at {diff}')
        edits, why = ART.edit_script(stock, cand)
        gate(name, 'same-shape+edit-script', not why and sorted((p, i) for p, i, *_ in edits) == sorted(intended),
             why or f'edits {[(p, i) for p, i, *_ in edits]}')
        # self rebase: unchanged build -> identical bytes
        r = ART.rebase_replacement(stock, cand, stock, RM.ModuleMap(stock, B.Module(stock_bytes, om), spec['stock']))
        gate(name, 'self-rebase', r['action'] == 'auto' and r['bytes'] == cand_bytes and r['new_key'] == stock.key,
             r.get('reason', r['action']))
        # shifted synthetic build: 2 new functions first, and 3 no-op MOVEs before every edited instruction
        shifted = B.Module(S.insert_protos(stock, 0, [len(stock.protos) - 2, len(stock.protos) - 3], om), om)
        for pi, li in sorted(intended, reverse=True):
            shifted = B.Module(S.insert_moves(shifted, pi + 2, li, 3, om), om)
        r = ART.rebase_replacement(stock, cand, shifted, RM.ModuleMap(stock, shifted, spec['stock']))
        moved_ok = r['action'] == 'auto'
        if moved_ok:
            rb = B.Module(r['bytes'], om)
            # 3 no-op MOVEs are inserted before EVERY edited instruction, so an instruction moves by 3 for each
            # edited instruction at or before it in the same prototype (two edits in one prototype: +3 and +6).
            def moved(pi, li):
                return li + 3 * sum(1 for p2, l2 in intended if p2 == pi and l2 <= li)
            for pi, li in intended:
                want = cand.word(cand.protos[pi], li)
                q = rb.protos[pi + 2]
                got = rb.word(q, moved(pi, li))
                same_op = want[:2] == got[:2] and want[4:] == got[4:]
                if disasm.NAMES.get(want[0], '').startswith('JUMP'):
                    # branch: re-aimed to the moved target; compare the target instruction instead of the offset
                    pos_c, at = [], 0
                    for k in range(len(cand.protos[pi].instructions)):
                        pos_c.append(at); at += len(cand.word(cand.protos[pi], k)) // 4
                    tgt_c = {w: k for k, w in enumerate(pos_c)}[pos_c[li] + 1 + struct.unpack_from('<h', want, 2)[0]]
                    pos_b, at = [], 0
                    for k in range(len(q.instructions)):
                        pos_b.append(at); at += len(rb.word(q, k)) // 4
                    tgt_b = {w: k for k, w in enumerate(pos_b)}.get(pos_b[moved(pi, li)] + 1 + struct.unpack_from('<h', got, 2)[0])
                    same_op &= tgt_b == moved(pi, tgt_c)
                else:
                    same_op &= want == got
                moved_ok &= same_op
        gate(name, 'shifted-rebase', moved_ok, r.get('reason') or f'edits {r.get("edits")}')
        # toolchain gates
        code, text = run([DERECOMP, 'de-roundtrip', out])
        gate(name, 'de-roundtrip', code == 0 and 'FULL BODY identical: True' in text, text.splitlines()[-1] if text else '')
        stock_copy = OUT / ('stock.' + spec['stock'])
        stock_copy.write_bytes(stock_bytes)
        code, text = run([DERECOMP, 'const-identity', stock_copy, out, '--u44'])
        (OUT / (name + '.const-identity.txt')).write_text(text, encoding='utf-8')
        gate(name, 'const-identity', code == 0, text.splitlines()[-1] if text else '')
        code, text = run([DERECOMP, 'cfg-identity', stock_copy, out, '--u44'])
        (OUT / (name + '.cfg-identity.txt')).write_text(text, encoding='utf-8')
        gates.append({'member': name, 'gate': 'cfg-identity (report)', 'pass': None, 'detail': f'exit {code}: '
                      + ' | '.join(text.splitlines()[-3:])})
        print(f'INFO  {name}: cfg-identity exit {code}: ' + ' | '.join(text.splitlines()[-3:]))
        stock_copy.unlink()
        report += ['', f'- Candidate: size {len(cand_bytes)} (stock {len(stock_bytes)}), sha256 `{sha(cand_bytes)}`, '
                   f'content key of the candidate body `{cand.key}` (the loader matches the FILENAME key `{name[:16]}`).',
                   f'- Bytes differing from stock: {len(diff)} (all inside the edited instruction words).', '']
    (OUT / 'gates.json').write_text(json.dumps({'build': BUILD, 'gates': gates, 'all_pass': ok_all}, indent=1),
                                     encoding='utf-8')
    report += ['## Gates', '', '| Member | Gate | Result | Detail |', '|---|---|---|---|']
    for g in gates:
        res = 'PASS' if g['pass'] else ('FAIL' if g['pass'] is False else 'report')
        report.append(f'| `{g["member"]}` | {g["gate"]} | {res} | {str(g["detail"]).replace("|", "/")[:300]} |')
    (OUT / 'diff_report.md').write_text('\n'.join(report) + '\n', encoding='utf-8')
    print('ALL GATES PASS' if ok_all else 'GATES FAILED')
    return 0 if ok_all else 1


if __name__ == '__main__':
    sys.exit(main())
