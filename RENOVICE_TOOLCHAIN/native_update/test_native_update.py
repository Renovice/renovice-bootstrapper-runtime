#!/usr/bin/env python3
"""Regression test of the native update tool on synthetic builds (COPIES of the certified client; never the game folder).

For every case of synthetic/make_synthetic.py the tool runs with --apply on a scratch copy of the source facts it reads
and writes (main.cpp, main.hpp, renovice/, OpenWF/ data, RENOVICE_TOOLCHAIN/version44/), and the test asserts the
classification, the emitted rows (every registered byte range is re-read from the synthetic image and compared), the
applied source and the allowlist decision. `verify_client_44.ps1` (the offline certification verifier, compiled from the
APPLIED headers) then runs against the synthetic image where the build was certified.

  python test_native_update.py [--reference <certified exe>] [--work <dir>] [--cases a,b] [--no-verifier]
         [--build <worktree>]   also apply the shift case to a full bootstrapper worktree and rebuild it with every
                                gate checking the synthetic image (nu_build.ps1 -ClientExe); slow (one private build)

Exit 0 = every assertion passed. The certified reference defaults to the newest image in the native-update reference
store. No old real game build is used: every case is derived from the current certified image.
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import struct
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE / 'synthetic'))

import make_synthetic  # noqa: E402
import renovice_native_update as tool  # noqa: E402
from nu_image import Image  # noqa: E402
from nu_source import parse_certified_clients, parse_engine_damage_builds, parse_engine_params_builds, \
    loads_jsonc, read_text  # noqa: E402

CASES = ['unchanged', 'shift', 'neighbour', 'codec', 'instr', 'process']
TREE_PATHS = ['main.cpp', 'main.hpp', 'renovice', 'OpenWF/tunables.json', 'OpenWF/hash_to_code_version.json',
              'OpenWF/vv', 'RENOVICE_TOOLCHAIN/version44', 'RENOVICE_TOOLCHAIN/gate_paths.ps1']
UNDUMP_TAIL = '48 8B 05 ? ? ? ? 48 33'

failures: list[str] = []
checks = 0


def check(cond: bool, what: str):
    global checks
    checks += 1
    print(('PASS' if cond else 'FAIL') + '\t' + what)
    if not cond:
        failures.append(what)


def scratch_tree(dest: Path) -> Path:
    if dest.exists():
        shutil.rmtree(dest)
    for rel in TREE_PATHS:
        src = REPO / rel
        if src.is_dir():
            shutil.copytree(src, dest / rel, ignore=shutil.ignore_patterns('bin', '__pycache__'))
        else:
            (dest / rel).parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dest / rel)
    return dest


def tighten_undump(tree: Path, ref: Image) -> str:
    """Make the replacements.cpp undump literal carry its RIP displacement (as a signature author who did not
    wildcard it would): a mechanical relink then breaks it, and the tool must relax it again."""
    hit = ref.scan(make_synthetic_undump())[0]
    tail = ' '.join(f'{c:02X}' for c in ref.mem[hit + 18:hit + 27])
    p = tree / 'renovice/replacements.cpp'
    text = p.read_bytes().decode('utf-8')
    assert text.count(f'"{UNDUMP_TAIL}"') == 1
    p.write_bytes(text.replace(f'"{UNDUMP_TAIL}"', f'"{tail}"').encode('utf-8'))
    return tail


def make_synthetic_undump() -> str:
    from nu_checks import UNDUMP
    return UNDUMP


def admit(img: Image, row: dict) -> list[str]:
    bad = []
    for c in row['checks']:
        want = bytes.fromhex(c['hex'])
        if img.mem[c['rva']:c['rva'] + len(want)] != want:
            bad.append(hex(c['rva']))
    return bad


def run_case(case: str, ref_path: Path, work: Path, verifier: bool, proxy: Path) -> dict:
    print(f'== case {case}')
    meta = make_synthetic.make(ref_path, work / 'images', case)
    game = work / 'images' / case
    tree = scratch_tree(work / 'trees' / case)
    ref = Image.load(ref_path)
    tightened = tighten_undump(tree, ref) if case == 'shift' else None
    out = work / 'out' / case
    argv = ['--game', str(game), '--out', str(out), '--repo', str(tree), '--reference', str(ref_path), '--apply',
            '--no-snapshot']
    if meta['extra_signatures']:
        argv += ['--extra-signatures', str(game / 'extra_signatures.json')]
    code = tool.main(argv)
    report = json.loads((out / 'native_update_report.json').read_text(encoding='utf-8'))
    new = Image.load(game / 'Warframe.x64.exe')
    items = {it['id']: it for it in report['items']}
    reviews = [it for it in report['items'] if it['status'] == 'review']
    tables = report['tables']
    label = meta['label']
    tun = loads_jsonc(read_text(tree / 'OpenWF/tunables.json'))
    certified = parse_certified_clients(read_text(tree / 'RENOVICE_TOOLCHAIN/version44/verify_client_44.ps1'))
    ed_rows = parse_engine_damage_builds(read_text(tree / 'renovice/engine_damage_builds.hpp'))
    ep_rows = parse_engine_params_builds(read_text(tree / 'renovice/engine_params_builds.hpp'))
    ed_new = next((b for b in ed_rows if new.sha256 in b['digests']), None)
    ep_new = next((b for b in ep_rows if new.sha256 in b['digests']), None)
    check(report['exe']['sha256'] == new.sha256 and report['exe']['build_label'] == label,
          f'{case}: report names the synthetic image {new.sha256[:12]} / {label}')
    allow = report['allowlist']['decision']
    if case != 'process':
        check(allow == 'add' and label in tun['supported_builds_44'] and new.sha256 in tun['supported_client_sha256_44'],
              f'{case}: allowlist add -> tunables.json lists {label} and the digest')
        check(any(c['Sha256'] == new.sha256 and c['Version'] == label for c in certified),
              f'{case}: verify_client_44.ps1 certifies the digest with its undump row')
    check(ed_new is not None and ep_new is not None and len(ed_rows) == 4 and len(ep_rows) == 2,
          f'{case}: one new ENGINE_DAMAGE row and one new ENGINE_PARAM row (tables 4 / 2)')
    if ep_new:
        check(admit(new, ep_new) == [], f'{case}: every ENGINE_PARAM byte range of the new row is the synthetic '
                                        'image\'s bytes (admit_image)')
        check(admit(ref, ep_new) != [] or ep_new['checks'] == ep_rows[0]['checks'],
              f'{case}: the new row is specific to the image (or identical where the code did not move)')
    sig_auto = [it for it in report['items'] if it['kind'] == 'signature' and it['status'] == 'auto']
    if case == 'unchanged':
        check(code == 0 and not reviews and not sig_auto, 'unchanged: exit 0, no review, no signature moved')
        check(ed_new and ed_new['handlers'] == ed_rows[2]['handlers'] and ed_new['integer_codec'] == ed_rows[2]['integer_codec'],
              'unchanged: the derived ENGINE_DAMAGE values equal the 44.0.2 registration')
        check(ep_new and ep_new['checks'] == ep_rows[0]['checks'], 'unchanged: ENGINE_PARAM ranges equal the 44.0.2 ranges')
    elif case == 'shift':
        k = make_synthetic.SHIFT_BYTES
        moved_at = next(b for b, _e in ref.functions() if b >= make_synthetic.SHIFT_AT)
        check(code == 0 and not reviews, 'shift: exit 0, nothing needs review')
        check(len(sig_auto) >= 50 and all(it['new_rva'] == hex(int(it['ref_rva'], 16) + k) for it in sig_auto),
              f'shift: {len(sig_auto)} signatures re-found exactly {k:#x} further (every moved one)')
        und = [it for it in sig_auto if it['source']['file'] == 'renovice/replacements.cpp']
        check(len(und) == 1 and und[0]['edit'] == 'signature' and und[0]['strategy'] == 'masked'
              and und[0]['new_pattern'].endswith(UNDUMP_TAIL), 'shift: the tightened undump literal ('
              f'...{tightened}) is re-found by the masked strategy and relaxed to ...{UNDUMP_TAIL}')
        text = read_text(tree / 'renovice/replacements.cpp')
        check(f'"40 53 55 56 57 41 55 41 56 41 57 48 81 EC F0 01 00 00 {UNDUMP_TAIL}"' in text and tightened not in text,
              'shift: --apply rewrote the replacements.cpp literal run in place')
        pv = ep_rows[0]['push_value_rva']
        check(ep_new and ep_new['push_value_rva'] == pv + k, f'shift: push_value 0x{pv:x} -> 0x{pv + k:x}')
        check(ep_new and [c['rva'] for c in ep_new['checks']] ==
              [c['rva'] + (k if c['rva'] >= moved_at else 0) for c in ep_rows[0]['checks']],
              'shift: each ENGINE_PARAM range moved exactly as its code did (unmoved ones stay)')
        check(ep_new and ep_new['checks'][1]['hex'] != ep_rows[0]['checks'][1]['hex'],
              'shift: the switch-table range carries the new handler RVA (re-read, not copied)')
        exp = [h + (k if h >= moved_at else 0) for h in ed_rows[2]['handlers']]
        check(ed_new and ed_new['handlers'] == exp and ed_new['evaluator'] == ed_rows[2]['evaluator'] + k,
              'shift: ENGINE_DAMAGE handlers and evaluator re-derived at their moved RVAs')
        leave = items['de_vm_authority.lock-leave']
        check(leave['status'] == 'auto' and leave['edit'] == 'none', 'shift: the moved lock thunk is re-found by '
                                                                     'import identity (no source change)')
    elif case == 'neighbour':
        check(code == 0 and not reviews, 'neighbour: exit 0, nothing needs review')
        leave = items['de_vm_authority.lock-leave']
        check(leave['status'] == 'auto' and leave['edit'] == 'none' and leave['new_rva'] != leave['ref_rva'],
              f'neighbour: the relocated LeaveCriticalSection thunk ({leave["ref_rva"]} -> {leave["new_rva"]}) is '
              're-found by import identity')
        check(items['de_vm_authority.cross-check']['status'] == 'unchanged',
              'neighbour: the locked dispatcher still tail-jumps to the re-found thunk')
        syn = items['synthetic/neighbour_leaf#0']
        check(syn['status'] == 'auto' and syn['strategy'].startswith('trimmed') and
              syn['new_pattern'] == 'FF 81 88 00 00 00 8B 81 88 00 00 00 C3',
              'neighbour: a signature that ran into the changed neighbour is trimmed at its function end')
    elif case == 'codec':
        check(code == 0 and not reviews, 'codec: exit 0, nothing needs review')
        check(ed_new and ed_new['integer_codec']['key'] == make_synthetic.NEW_INT_KEY
              and ed_new['float_codec']['key'] == make_synthetic.NEW_FLOAT_KEY
              and ed_new['integer_codec']['rotate'] == 19 and ed_new['float_codec']['rotate'] == 17,
              'codec: the new row carries the rotated integer and float keys, derived from the accessors')
        check(ed_new and ed_new['layout'] == ed_rows[2]['layout'], 'codec: slots and layout unchanged')
    elif case == 'instr':
        check(code == 1 and len(reviews) == 1 and reviews[0]['id'].startswith('renovice/riven_core.hpp')
              and reviews[0]['scope'] == 'feature', 'instr: exit 1, exactly the changed Riven signature needs review')
        check(any('candidate 0x' in e for e in reviews[0]['evidence']),
              'instr: the review names the closest candidate found through the function\'s string anchors')
        check('riven' not in ' '.join(report['applied']['log']).lower(),
              'instr: nothing is applied for the review item (the Riven feature fails closed)')
    elif case == 'process':
        ids = sorted(it['id'].split('#')[0] for it in reviews)
        check(code == 1 and ids == ['main.cpp', 'renovice/riven_core.hpp'], f'process: exit 1, reviews {ids}')
        check(allow == 'refused' and label not in tun['supported_builds_44']
              and new.sha256 not in tun['supported_client_sha256_44']
              and not any(c['Sha256'] == new.sha256 for c in certified),
              'process: allowlist refused; tunables.json and the verifier table do not list the build (DLL refuses it)')
    if verifier:
        result = run_verifier(tree, game / 'Warframe.x64.exe', proxy)
        if case in ('unchanged', 'shift', 'neighbour', 'codec'):
            check(result['pass'], f'{case}: verify_client_44.ps1 (built from the applied headers) PASS on the synthetic '
                                  f'image ({result["summary"]})')
        elif case == 'instr':
            check(not result['pass'] and result['failed'] == ['Riven SetStringVariable'],
                  f'instr: verify_client_44.ps1 fails exactly the Riven SetStringVariable row ({result["failed"]})')
        else:
            check(not result['pass'] and ('not certified' in result['summary'].lower()
                                          or 'mismatch' in result['summary'].lower()),
                  f'process: verify_client_44.ps1 refuses the uncertified image ({result["summary"][:90]})')
    return report


def run_verifier(tree: Path, exe: Path, proxy: Path) -> dict:
    ps1 = tree / 'RENOVICE_TOOLCHAIN/version44/verify_client_44.ps1'
    r = subprocess.run(['powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(ps1), '-ExePath',
                        str(exe), '-ProxyDllPath', str(proxy)], capture_output=True, text=True, errors='replace')
    out = r.stdout + r.stderr
    failed = [m.group(1) for m in re.finditer(r'^FAIL\t([^\t]+)', out, re.M)]
    last = [l for l in out.splitlines() if 'V44 COMPATIBILITY PASS' in l or 'FAIL' in l or 'certified' in l.lower()]
    return {'pass': r.returncode == 0 and 'V44 COMPATIBILITY PASS' in out, 'failed': failed,
            'summary': (last[-1] if last else out.strip().splitlines()[-1] if out.strip() else '').strip()}


def full_build(worktree: Path, ref_path: Path, work: Path) -> None:
    """The shift case applied to a complete worktree, rebuilt with every gate checking the synthetic image."""
    print('== full build (shift case)')
    game = work / 'images' / 'shift'
    if not (game / 'Warframe.x64.exe').is_file():
        make_synthetic.make(ref_path, work / 'images', 'shift')
    out = work / 'out' / 'build-shift'
    code = tool.main(['--game', str(game), '--out', str(out), '--repo', str(worktree), '--reference', str(ref_path),
                      '--apply', '--build', '--no-snapshot'])
    report = json.loads((out / 'native_update_report.json').read_text(encoding='utf-8'))
    b = report.get('build', {})
    check(code == 0 and b.get('status') == 'PASS' and b.get('dll_sha256'),
          f'full build: shift case applied, build_private.ps1 PASS (every gate on the synthetic image), staged DLL '
          f'{b.get("dll_sha256", "-")[:16]} Hotfix.owf {b.get("hotfix_sha256", "-")[:16]}')
    log = Path(b.get('log', out / 'build.log')).read_text(encoding='utf-8', errors='replace') if b else ''
    check('ENGINE_DAMAGE CODEC GATE PASS registered=4 covered=4' in log,
          'full build: the codec gate covers the new registration with the synthetic image')
    check(log.count("D2 every registered byte range is present in the mapped image (8 ranges)") >= 2,
          'full build: the ENGINE_PARAM byte gate admits the synthetic image (and 44.0.2 from the reference store)')


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--reference', help='certified Warframe.x64.exe (default: newest in the reference store)')
    ap.add_argument('--work', help='scratch folder (default <workspace>/work/temp/native-update-synthetic)')
    ap.add_argument('--cases', default=','.join(CASES))
    ap.add_argument('--no-verifier', action='store_true')
    ap.add_argument('--build', help='full bootstrapper worktree for the shift-case rebuild')
    args = ap.parse_args()
    ws = tool.workspace_root(REPO)
    work = Path(args.work) if args.work else ws / 'work' / 'temp' / 'native-update-synthetic'
    if args.reference:
        ref_path = Path(args.reference)
    else:
        store = tool.store_images(tool.default_store(REPO))
        ranked = sorted(store, key=lambda p: Image.load(p).product_version() or '')
        if not ranked:
            print('FAIL\tno certified reference image (store one with renovice_native_update.py first)')
            return 1
        ref_path = ranked[-1]
    proxy = ws / 'repos' / 'runtime' / 'bootstrapper-runtime' / 'wtsapi32.dll'
    print(f'reference {ref_path}')
    for case in [c for c in args.cases.split(',') if c]:
        run_case(case, ref_path, work, not args.no_verifier, proxy)
    if args.build:
        full_build(Path(args.build), ref_path, work)
    print(f'NATIVE UPDATE REGRESSION {"PASS" if not failures else "FAIL"} checks={checks} failures={len(failures)}')
    for f in failures:
        print('  FAIL ' + f)
    return 0 if not failures else 1


if __name__ == '__main__':
    sys.exit(main())
