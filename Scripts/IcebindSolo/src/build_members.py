# Icebind Solo package members: build + offline gates (research tool, 2026-10-08, client 44.1.0 2026.10.06.16.12).
#
# The members are exact content-key root replacements that differ from the stock module of this build ONLY in the
# instruction words listed in 'edits' and the number constants listed in 'consts' (same prototypes, string pool,
# constant tables and code sizes), so the update tool rebases them automatically after a future Warframe update
# (uc_artifacts.rebase_replacement).
#
# Gates (each printed PASS/FAIL, all recorded in ../build/gates.json and ../build/diff_report.md):
#   stock-key            stock bytes hash to the manifest content key (the loader's match key, = filename key)
#   expected-old-word    every edited instruction holds the expected canonical stock word before the edit
#   expected-old-const   every edited constant is a number constant holding the expected stock value, read only by
#                        the listed instructions
#   parse-u44            the candidate parses with the toolchain U44 opcode profile, clean instruction walks
#   same-shape           same prototype count / string pool / constants / code sizes as stock
#   byte-diff            the candidate differs from stock only inside the edited instruction words and constants
#   edit-script          uc_artifacts.edit_script(stock, candidate) == exactly the intended instruction and constant edits
#   self-rebase          rebase_replacement onto the unchanged stock reproduces the candidate byte for byte
#   shifted-rebase       rebase onto a synthetic shifted build (prototypes inserted first + no-op MOVEs inserted before
#                        each edited instruction) is AUTO and lands the same canonical words at the moved sites
#   de-roundtrip         derecomp de-roundtrip: the container re-emits byte-exact
#   const-identity       derecomp const-identity stock candidate --u44 (no hash / string / key-use change)
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
STOCK = ROOT / 'work/temp/update-check/stock-726365cc81044d28'
DERECOMP = ROOT / 'repos/toolchains/de-luau-toolchain/bin/derecomp.exe'
BUILD = '2026.10.08.13.05'

# canonical (U43-numbered) opcodes
JUMPIFNOTEQ, JUMPIFNOTLE, JUMPIFNOTLT, LOADN, LOADNIL, LOADB, MOVE = 0x27, 0x33, 0x1c, 0x12, 0x0d, 0x04, 0x14
JUMPIFEQ, JUMPIFLE = 0x37, 0x23
JUMPIF, JUMPIFNOT = 0x4b, 0x18  # 4-byte A, D (signed 16-bit offset)
LOADK = 0x4e
K_OPS = {0x38, 0x09, 0x32, 0x3c, 0x08, 0x24, 0x06, 0x3b, 0x3e, 0x31, 0x2b}  # ...K arithmetic/logic: C = constant index
KAUX_OPS = {0x20, 0x41, 0x34, 0x3a}  # JUMPXEQK*: aux low 24 bits = constant index

MEMBERS = [
    {
        'stock': 'Lotus_Interface_SixStackSetup.lua_B',
        'key': '94825e22a3427b34',
        'file': '94825e22a3427b34 (Icebind Solo squad gate).lua_B',
        'edits': [
            {   # 44.1.1 CanStart helper (v49): `ok = true; if #members ~= ICE_BLADE_HUB_MAX_PLAYERS then ok = IsDevServer()
                # end; if ok and AllPlayersOfferedKey(members) then ok = <no duplicate Warframe> end; return ok`. It gates
                # the host's Start button (v50) and cancels a running countdown in OnSquadMembersChanged (proto 42).
                'proto': 5, 'i': 10,
                'old': (JUMPIFEQ, 3, 4), 'new': (JUMPIFLE, 3, 4),
                'why': 'start gate: a squad of up to ICE_BLADE_HUB_MAX_PLAYERS counts as full (was: exactly 6, else only '
                       'on a dev server); keeps AllPlayersOfferedKey, the one-of-each-Warframe check and the host Start '
                       'button as the remaining start conditions',
            },
            {   # squad hint: `if not (#members < MAX) then <equip-keys hint> else <SetupFullSquadHint>`
                'proto': 18, 'i': 51,
                'old': (JUMPIFNOTLT, 3, 4), 'new': (JUMPIFNOTLT, 4, 3),
                'why': 'hint: show the equip-Cryobell hint path when #members <= MAX (was: only when #members >= MAX); '
                       'SetupFullSquadHint is shown only above the maximum',
            },
        ],
    },
    {
        'stock': 'Lotus_Scripts_KuvaPath_KuvaPath.lua_B',
        'key': '248d54e0074e52c2',
        'file': '248d54e0074e52c2 (Icebind Solo squad scaling).lua_B',
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
    # Squad Side Objective events (added 2026-10-08): each event script has its own "scale to the real squad" flag
    # (upvalue 0), set false by its MasterInit at i3 (LOADB R1 false; SETUPVAL 0). False = the event assumes 6 players.
    {
        'stock': 'Lotus_Scripts_KuvaPath_AntiVoidSurgeEvent.lua_B',
        'key': '6ada7a9b075edb74',
        'file': '6ada7a9b075edb74 (Icebind Solo void surge objective).lua_B',
        'edits': [
            {   # MasterInit: `<scale-to-players flag> = false`
                'proto': 22, 'i': 3,
                'old': (LOADB, 1, 0), 'new': (LOADB, 1, 1),
                'why': 'Void Surge: the crystal-proximity objective needs GetNumHumanPlayers() Tenno inside the zone '
                       'instead of a fixed 6 (all five flag reads are that count: gather, maintain, HUD)',
            },
        ],
    },
    {
        'stock': 'Lotus_Scripts_KuvaPath_LockedCrateEvent.lua_B',
        'key': 'e505b900b6f52758',
        'file': 'e505b900b6f52758 (Icebind Solo locked crate objective).lua_B',
        'edits': [
            {   # MasterInit: `<scale-to-players flag> = false`
                'proto': 24, 'i': 3,
                'old': (LOADB, 1, 0), 'new': (LOADB, 1, 1),
                'why': 'Locked Crate: the unlock needs the real player count at the crate instead of a fixed 6 (count '
                       'and "n / 6" HUD reads). The flag also registers the event\'s debug ImGui panel on the '
                       'blackboard, shown only by DE\'s developer ImGui overlay',
            },
        ],
    },
    {
        # Cryothermia (Cryo Core): the core is neutralized once the holders' combined DefuseTimer reaches 60 s. Each time
        # a holder's own hold time passes a whole second n, the holder takes MaxHealth x n x 0.05 (P9 i133-140), after
        # shield/overshield/overguard-related calls (hashed names). The damage is CUMULATIVE: 5 + 10 + 15 + ... % of
        # max health, about 105 % after 6 s, so one Tenno cannot finish alone (live 2026-10-08: downed at about 3.6 s
        # held, with enemy fire; the first build, 10 s defuse with the stock 5 % ramp, was not enough). No squad-size
        # input exists in this script (its MasterInit flag is never read).
        'stock': 'Lotus_Scripts_KuvaPath_HotPotatoEvent.lua_B',
        'key': '8416e33425fb8b4f',
        'file': '8416e33425fb8b4f (Icebind Solo cryo core objective).lua_B',
        'edits': [
            {   # tick: `if DefuseTimer < 60 then <hold and damage> else <neutralized>`
                'proto': 12, 'i': 77,
                'old': (LOADN, 7, 60), 'new': (LOADN, 7, 10),
                'why': 'Cryothermia: the core is neutralized after 10 s of total hold instead of 60 s, a full squad\'s '
                       'per-player share (60 / 6)',
            },
        ],
        'consts': [
            {   # damage: baseAmount = MaxHealth * (floor(ownSeconds) * K37)
                'proto': 12, 'k': 37, 'old': 0.05, 'new': 0.01, 'users': [139],
                'why': 'Cryothermia damage ramp 1 % per held second instead of 5 %: a solo 10 s hold totals 55 % of '
                       'max health (stock ramp: about 105 % after 6 s)',
            },
            {   # ramp helper v39: floor(x) * K0, the same ramp
                'proto': 7, 'k': 0, 'old': 0.05, 'new': 0.01, 'users': [4],
                'why': 'the ramp helper uses the same 1 % per second as the damage',
            },
            {   # HUD tracker text: floor(DefuseTimer / K1 * 100) .. "%"
                'proto': 4, 'k': 1, 'old': 60.0, 'new': 10.0, 'users': [2],
                'why': 'the defuse percentage reaches 100 % at the 10 s neutralize point',
            },
            {   # HUD objective text (holder name and percentage): DefuseTimer / K18 * 100, both branches
                'proto': 5, 'k': 18, 'old': 60.0, 'new': 10.0, 'users': [45, 60],
                'why': 'the defuse percentage reaches 100 % at the 10 s neutralize point',
            },
        ],
    },
    {
        'stock': 'Lotus_Scripts_KuvaPath_SignalBridgeEvent.lua_B',
        'key': '93b4bb73bf20069c',
        'file': '93b4bb73bf20069c (Icebind Solo signal chain objective).lua_B',
        'edits': [
            {   # MasterInit: `<scale-to-players flag> = false`
                'proto': 27, 'i': 3,
                'old': (LOADB, 1, 0), 'new': (LOADB, 1, 1),
                'why': 'Signal Chain (master): the chain is sized for GetNumHumanPlayers() nodes instead of 6 (console '
                       'spawn range MapToRange((n-1)/5) of 20..30 and node distance ceil(dist/(n+1)+3)), so a solo '
                       'Tenno can link device and console',
            },
            {   # ReplicaInit: the replica's copy of the same flag (upvalue 6), read when it sizes the chain locally
                'proto': 28, 'i': 55,
                'old': (LOADB, 1, 0), 'new': (LOADB, 1, 1),
                'why': 'Signal Chain (replica): same flag on clients, so the replica sizes the chain with the same '
                       'player count as the host',
            },
        ],
    },
    {
        # Cryobell pillars (added 2026-10-09, opt-in, ships disabled): the pillar loop KeyAcquisitionManager (P12) keeps
        # the Cryobell offers cached in gGameData and asks the server again (Lotus_Game request with
        # KuvaKeysLib.LATEST_KUVA_KEY_ITEM, then waits for its callback and rereads gGameData) only when the cached
        # expiry has passed. The server's child clock rolls the Cryobells to a new rotation after all three are finished,
        # long before that expiry, so the pillars kept the old rotation until the peak was entered from outside.
        'stock': 'Lotus_Scripts_KuvaPath_KuvaPathAcquire.lua_B',
        'key': '59bb8fd0ab33eadc',
        'file': '59bb8fd0ab33eadc (Icebind Solo Cryobell refresh).lua_B',
        'edits': [
            {   # `if not cached or expired then if expired then <request, wait for reply> end; cached = <reread>; <redraw> end`
                'proto': 12, 'i': 108,
                'old': (JUMPIFNOT, 3, 45), 'new': (JUMPIFNOT, 3, 0),
                'why': 'the inner `if expired` falls through: the first pass after the peak loads (nothing cached yet) also '
                       'sends the game\'s own refresh request and waits for its reply, so the pillars show the current '
                       'rotation; later passes refresh on expiry as before. One request per peak load',
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
            elif old_op == MOVE:
                ok = op == MOVE and len(w) == 4 and w[1] == old_a and w[2] == old_x and w[3] == 0
            elif old_op == LOADB:
                ok = op == LOADB and w[1] == old_a and w[2] == old_x and w[3] == 0
            elif old_op in (JUMPIF, JUMPIFNOT):
                ok = op == old_op and len(w) == 4 and w[1] == old_a and struct.unpack_from('<h', w, 2)[0] == old_x
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
            elif new_op == LOADN:
                assert len(w) == 4, 'LOADN replaces a 4-byte instruction only'
                struct.pack_into('<h', nw, 2, new_x)       # D = the signed 16-bit constant
            elif new_op in (JUMPIFNOTLE, JUMPIFNOTLT):
                struct.pack_into('<I', nw, 4, new_x)       # Bx (branch target) unchanged
            elif new_op in (JUMPIF, JUMPIFNOT):
                assert len(w) == 4, 'JUMPIF/JUMPIFNOT is a 4-byte instruction'
                struct.pack_into('<h', nw, 2, new_x)       # D = the branch offset (0 = falls through either way)
            raw = bytearray(nw)
            raw[0] = raw_of[new_op]
            start = p.code_start + off
            old_raw = bytes(data[start:start + len(w)])
            data[start:start + len(w)] = raw
            intended.append((e['proto'], e['i']))
            report.append(f'| P{e["proto"]} | i{e["i"]} | {start} (0x{start:x}) | `{w.hex()}` {disasm.NAMES[op]} | '
                          f'`{bytes(nw).hex()}` {disasm.NAMES[new_op]} | `{old_raw.hex()}` | `{bytes(raw).hex()}` | '
                          f'{e["why"]} |')
        intended_consts = []
        for c in spec.get('consts', []):
            p = stock.protos[c['proto']]
            k = c['k']
            ok = k < len(p.consts) and p.consts[k].tag == 2 and p.consts[k].value == c['old']
            readers = sorted(
                [li for li, _, op in p.instructions if op in K_OPS and stock.word(p, li)[3] == k]
                + [li for li, _, op in p.instructions
                   if op == LOADK and struct.unpack_from('<H', stock.word(p, li), 2)[0] == k]
                + [li for li, _, op in p.instructions
                   if op in KAUX_OPS and struct.unpack_from('<I', stock.word(p, li), 4)[0] & 0xffffff == k])
            ok &= readers == sorted(c['users'])
            gate(name, f'expected-old-const P{c["proto"]} K{k}', ok,
                 f'{p.consts[k].value if k < len(p.consts) else "missing"} read by {readers}')
            start = stock.constant_offset(p, k)
            old_raw = bytes(data[start:start + 8])
            data[start:start + 8] = struct.pack('<d', c['new'])
            intended_consts.append((c['proto'], k, c['old'], c['new']))
            report.append(f'| P{c["proto"]} | K{k} | {start} (0x{start:x}) | `{c["old"]!r}` number | '
                          f'`{c["new"]!r}` number | `{old_raw.hex()}` | `{struct.pack("<d", c["new"]).hex()}` | '
                          f'{c["why"]} |')
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
        for pi, k, *_ in intended_consts:
            start = stock.constant_offset(stock.protos[pi], k)
            allowed |= set(range(start, start + 8))
        gate(name, 'byte-diff', len(cand_bytes) == len(stock_bytes) and diff and set(diff) <= allowed,
             f'{len(diff)} bytes differ at {diff}')
        consts_found: list = []
        edits, why = ART.edit_script(stock, cand, consts_found)
        gate(name, 'same-shape+edit-script', not why and sorted((p, i) for p, i, *_ in edits) == sorted(intended)
             and sorted(consts_found) == sorted(intended_consts),
             why or f'edits {[(p, i) for p, i, *_ in edits]} constants {consts_found}')
        # self rebase: unchanged build -> identical bytes
        r = ART.rebase_replacement(stock, cand, stock, RM.ModuleMap(stock, B.Module(stock_bytes, om), spec['stock']))
        gate(name, 'self-rebase', r['action'] == 'auto' and r['bytes'] == cand_bytes and r['new_key'] == stock.key,
             r.get('reason', r['action']))
        # shifted synthetic build: 2 new functions first, and 3 no-op MOVEs before every edited instruction
        # The copies come from the last two prototypes below the root that no edit touches: an inserted identical copy
        # of an EDITED prototype makes the remap pick the copy (P12 -> P0 for the Cryobell refresh member, 2026-10-09;
        # known remap limitation, see README), which is not the moved-function case this gate proves.
        edited = {pi for pi, _ in intended} | {pi for pi, *_ in intended_consts}
        copies = [i for i in range(len(stock.protos) - 2, -1, -1) if i not in edited][:2]
        shifted = B.Module(S.insert_protos(stock, 0, copies, om), om)
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
            for pi, k, _, new in intended_consts:
                moved_ok &= rb.protos[pi + 2].consts[k].tag == 2 and rb.protos[pi + 2].consts[k].value == new
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
