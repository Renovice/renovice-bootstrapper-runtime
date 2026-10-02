#!/usr/bin/env python3
"""RENOVICE native update tool (update resilience, native side; steps 2 and 4).

After a Warframe update: re-find every native signature / RVA / per-build value the bootstrapper depends on in the new
Warframe.x64.exe, classify each as unchanged / auto (re-found by identity, strictly verified) / review, and emit the
per-build table rows and allowlist entries. With --apply the auto items are written into the bootstrapper source tree;
with --build the DLL and a matching Hotfix.owf are rebuilt (build_private.ps1, every gate) and staged.

The game folder is only read. Contract for callers: work/research/update-resilience/NATIVE_INTERFACE.md.

Exit codes: 0 OK (nothing needs review), 1 REVIEW (at least one item needs review; it fails closed), 2 BUILD FAILED,
3 TOOL ERROR.
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import shutil
import subprocess
import sys
import time
import traceback
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from nu_checks import Checker  # noqa: E402
from nu_image import Image  # noqa: E402
from nu_source import SignatureRow, read_source  # noqa: E402
import nu_apply  # noqa: E402

FORMAT = 'RENOVICE_NATIVE_UPDATE_REPORT_V1'
TOOL_VERSION = '1.0.0'
EXIT_OK, EXIT_REVIEW, EXIT_BUILD, EXIT_ERROR = 0, 1, 2, 3


def workspace_root(start: Path) -> Path | None:
    p = start
    while True:
        if (p / 'WORKSPACE.json').is_file():
            return p
        if p.parent == p:
            return None
        p = p.parent


def default_repo() -> Path:
    return HERE.parent.parent


def default_store(repo: Path) -> Path:
    ws = workspace_root(repo)
    return (ws or repo) / 'work' / 'native-update' / 'reference'


def store_images(store: Path) -> list[Path]:
    return sorted(store.glob('*/Warframe.x64.exe')) if store.is_dir() else []


def choose_reference(src, new: Image, explicit: list[Path], store: Path) -> tuple[Image | None, list[Image], str]:
    certified = set()
    for key, val in src.tunables.items():
        if key.startswith('supported_client_sha256_'):
            certified.update(val)
    paths = list(explicit) + [p for p in store_images(store) if p not in explicit]
    images = []
    for p in paths:
        try:
            img = new if p.resolve() == Path(new.path).resolve() else Image.load(p)
        except Exception:  # noqa: BLE001
            continue
        images.append(img)
    if explicit:
        ref = images[0] if images else None
        why = f'--reference {explicit[0]}'
    else:
        reg_ep = [d for b in src.engine_params for d in b['digests']]
        same = [i for i in images if i.sha256 == new.sha256]
        ranked = sorted((i for i in images if i.sha256 in certified),
                        key=lambda i: (i.sha256 in reg_ep, i.product_version() or ''), reverse=True)
        ref = same[0] if same else (ranked[0] if ranked else None)
        why = ('the installed image itself is a stored certified reference' if same else
               f'newest certified image in {store}' if ref else f'no certified image in {store}')
    extras = [i for i in images if ref is not None and i.sha256 != ref.sha256 and i.sha256 in certified]
    return ref, extras, why


def summarize(items: list[dict]) -> dict:
    out = {'unchanged': 0, 'auto': 0, 'review': 0, 'inactive': 0, 'by_kind': {}}
    for it in items:
        out[it['status']] += 1
        k = out['by_kind'].setdefault(it['kind'], {'unchanged': 0, 'auto': 0, 'review': 0, 'inactive': 0})
        k[it['status']] += 1
    return out


def allowlist_decision(src, facts: dict, sha: str, items: list[dict]) -> dict:
    label, family = facts['build_label'], facts['family']
    builds = src.tunables.get(f'supported_builds_{family}', [])
    digests = src.tunables.get(f'supported_client_sha256_{family}', [])
    blocking = [it['id'] for it in items if it['scope'] == 'process' and it['status'] == 'review']
    already = label in builds and sha in digests
    if blocking:
        decision = 'refused'
    elif already:
        decision = 'already'
    else:
        decision = 'add'
    return {'decision': decision, 'build_label': label, 'sha256': sha, 'family': family, 'blocking': blocking,
            'listed_label': label in builds, 'listed_sha256': sha in digests,
            'reason': ('process-scope items need review: the build stays off supported_builds/supported_client_sha256'
                       f'_{family}, so the DLL refuses this client (fail closed)') if blocking else
                      ('already allowlisted' if already else 'every process-scope dependency resolved')}


def write_markdown(report: dict, path: Path):
    s = report['summary']
    lines = [f'# RENOVICE native update report: {report["exe"]["build_label"]}', '',
             f'- Executable: `{report["exe"]["path"]}` sha256 `{report["exe"]["sha256"]}`',
             f'- Reference: {report["reference"]["build_label"]} `{report["reference"]["sha256"]}` ({report["reference"]["why"]})',
             f'- Bootstrapper source: `{report["repo"]["path"]}` at `{report["repo"]["commit"][:12]}`'
             + (f' (dirty: {len(report["repo"]["dirty"])} files)' if report['repo']['dirty'] else ''),
             f'- Result: **{report["result"]}** (exit {report["exit_code"]}); allowlist: **{report["allowlist"]["decision"]}**'
             f' ({report["allowlist"]["reason"]})', '',
             '| Kind | unchanged | auto | review | inactive |', '|---|---:|---:|---:|---:|']
    for kind, c in sorted(s['by_kind'].items()):
        lines.append(f'| {kind} | {c["unchanged"]} | {c["auto"]} | {c["review"]} | {c["inactive"]} |')
    lines.append(f'| **all** | {s["unchanged"]} | {s["auto"]} | {s["review"]} | {s["inactive"]} |')
    for status, title in (('review', 'Needs review (left out; the feature fails closed)'),
                          ('auto', 'Auto-relocated')):
        rows = [it for it in report['items'] if it['status'] == status]
        if not rows:
            continue
        lines += ['', f'## {title}', '']
        for it in rows:
            where = it.get('source', {}).get('file', '')
            lines.append(f'- **{it["id"]}** ({it["kind"]}, {it["scope"]}; {it["feature"]}) {where} '
                         f'{it.get("ref_rva") or ""} -> {it.get("new_rva") or ""} strategy `{it["strategy"]}` '
                         f'edit `{it["edit"]}`' + (f' - {it["reason"]}' if it['reason'] else ''))
            for e in it['evidence'][:6]:
                lines.append(f'  - {e}')
    if report.get('applied'):
        lines += ['', '## Applied', ''] + [f'- {l}' for l in report['applied']['log']]
    if report.get('build'):
        b = report['build']
        lines += ['', '## Build', '', f'- status: {b["status"]}', f'- staged: `{b.get("staged_dir")}`']
        for k in ('dll_sha256', 'dll_bytes', 'hotfix_sha256'):
            if b.get(k):
                lines.append(f'- {k}: `{b[k]}`')
    path.write_text('\n'.join(lines) + '\n', encoding='utf-8')


def proposed_rows(report: dict, label: str) -> str:
    import nu_engine_damage
    import nu_engine_params
    out = []
    t = report['tables']
    if t.get('engine_damage', {}).get('status') == 'auto':
        out += ['// renovice/engine_damage_builds.hpp', nu_engine_damage.row_cpp(label, [report['exe']['sha256']],
                                                                                t['engine_damage']['registration']), '']
    if t.get('engine_params', {}).get('status') == 'auto':
        out += ['// renovice/engine_params_builds.hpp', nu_engine_params.row_cpp(
            label, [report['exe']['sha256']], t['engine_params']['registration'],
            f'carried over from {t["engine_params"]["from"]}'), '']
    a = report['allowlist']
    if a['decision'] == 'add':
        out += ['// OpenWF/tunables.json', f'"supported_builds_{a["family"]}" += "{a["build_label"]}"',
                f'"supported_client_sha256_{a["family"]}" += "{a["sha256"]}"']
        u = report['facts'].get('undump')
        if u:
            out += ['// RENOVICE_TOOLCHAIN/version44/verify_client_44.ps1',
                    f'@{{ Version = "{a["build_label"]}"; Sha256 = "{a["sha256"]}"; UndumpRaw = "{u["raw"]:x}"; '
                    f'UndumpRva = "{u["rva"]:x}" }}', '']
    for it in report['items']:
        if it['status'] == 'auto' and it['edit'] == 'signature':
            out += [f'// {it["source"]["file"]}:{it["source"]["line"]}', f'- "{it["apply"]["old_pattern"]}"',
                    f'+ "{it["apply"]["new_pattern"]}"', '']
    return '\n'.join(out) + '\n'


def run_build(repo: Path, out: Path, main_checkout: Path | None, client_exe: Path) -> dict:
    stage = out / 'stage'
    cmd = ['powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(HERE / 'nu_build.ps1'),
           '-Repo', str(repo), '-Stage', str(stage), '-ClientExe', str(client_exe)]
    if main_checkout:
        cmd += ['-InputsFrom', str(main_checkout)]
    log = out / 'build.log'
    t = time.time()
    with log.open('w', encoding='utf-8', errors='replace') as fh:
        rc = subprocess.run(cmd, stdout=fh, stderr=subprocess.STDOUT).returncode
    text = log.read_text(encoding='utf-8', errors='replace')
    result = {'status': 'PASS' if rc == 0 else 'FAIL', 'exit': rc, 'log': str(log), 'seconds': round(time.time() - t),
              'staged_dir': str(stage) if rc == 0 else None}
    for line in text.splitlines():
        if line.startswith('PRIVATE BUILD PASS'):
            result['build_line'] = line.strip()
        if line.startswith('NATIVE UPDATE STAGE PASS'):
            for kv in line.split()[4:]:
                k, _, v = kv.partition('=')
                result[k] = v
    return result


def snapshot_reference(new: Image, store: Path) -> str:
    label = new.product_version() or 'unknown'
    dest = store / f'{label}_{new.sha256[:12]}'
    exe = dest / 'Warframe.x64.exe'
    if exe.is_file():
        return f'already stored: {exe}'
    dest.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(new.path, exe)
    (dest / 'reference.json').write_text(json.dumps({
        'format': 'RENOVICE_NATIVE_REFERENCE_V1', 'build_label': label, 'sha256': new.sha256,
        'bytes': len(new.file), 'copied_from': new.path, 'copied': dt.datetime.now().isoformat(timespec='seconds'),
        'purpose': 'reference image for the next native update (read-only copy; never deployed)'}, indent=2) + '\n',
        encoding='utf-8')
    return f'stored {exe}'


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--game', required=True, help='Warframe game folder (read only); its Warframe.x64.exe is the new image')
    ap.add_argument('--out', required=True, help='output folder (report, proposed rows, build log, stage/)')
    ap.add_argument('--repo', help='bootstrapper source tree to read and (with --apply) update; default: this tool\'s repo')
    ap.add_argument('--reference', action='append', default=[], help='reference image(s) (default: the reference store)')
    ap.add_argument('--reference-store', help='folder of reference images (default <workspace>/work/native-update/reference)')
    ap.add_argument('--label', help='registration label for new table rows (default "<family>.x <build label>")')
    ap.add_argument('--apply', action='store_true', help='write the auto items into --repo')
    ap.add_argument('--build', action='store_true', help='after --apply, rebuild with build_private.ps1 and stage')
    ap.add_argument('--inputs-from', help='main bootstrapper checkout to copy untracked build inputs from')
    ap.add_argument('--no-snapshot', action='store_true', help='do not store the new image as the next reference')
    ap.add_argument('--extra-signatures', help=argparse.SUPPRESS)          # regression test hook (JSON list)
    args = ap.parse_args(argv)
    out = Path(args.out).resolve()
    game = Path(args.game).resolve()
    report: dict = {'format': FORMAT, 'tool_version': TOOL_VERSION,
                    'generated': dt.datetime.now().isoformat(timespec='seconds'), 'game_dir': str(game)}
    try:
        exe = game / 'Warframe.x64.exe'
        if not exe.is_file():
            raise SystemExit(f'no Warframe.x64.exe in {game}')
        if out == game or game in out.parents:
            raise SystemExit('the output folder must not be inside the game folder')
        out.mkdir(parents=True, exist_ok=True)
        repo = Path(args.repo).resolve() if args.repo else default_repo()
        store = Path(args.reference_store).resolve() if args.reference_store else default_store(repo)
        t0 = time.time()
        new = Image.load(exe)
        src = read_source(repo)
        ref, extras, why = choose_reference(src, new, [Path(p) for p in args.reference], store)
        if ref is None:
            raise SystemExit(f'no reference image: {why}. Store the last certified Warframe.x64.exe with '
                             '--reference or in the reference store before the update.')
        extra_sigs = []
        if args.extra_signatures:
            for row in json.loads(Path(args.extra_signatures).read_text(encoding='utf-8')):
                extra_sigs.append(SignatureRow(**row))
        result = Checker(src, ref, new, extras, extra_sigs).run()
        facts = result['facts']
        items = result['items']
        report.update({
            'exe': {'path': str(exe), 'sha256': new.sha256, 'bytes': len(new.file), 'build_label': facts['build_label'],
                    'game_version': facts['game_version'], 'family': facts['family'],
                    'seed': facts.get('seed') and f'0x{facts["seed"]:08x}'},
            'reference': {'path': ref.path, 'sha256': ref.sha256, 'build_label': ref.product_version(), 'why': why,
                          'also_checked': [{'path': i.path, 'sha256': i.sha256} for i in extras]},
            'repo': {'path': str(repo), 'commit': src.commit, 'dirty': src.dirty},
            'facts': {k: v for k, v in facts.items() if k in ('undump', 'census_rows', 'toonew', 'game_version')},
            'items': items, 'tables': result['tables'], 'summary': summarize(items)})
        report['allowlist'] = allowlist_decision(src, facts, new.sha256, items)
        reviews = [it for it in items if it['status'] == 'review']
        report['exit_code'] = EXIT_REVIEW if reviews else EXIT_OK
        report['result'] = 'REVIEW' if reviews else 'OK'
        report['seconds'] = round(time.time() - t0, 1)
        label = args.label or f'{facts["family"]}.x {facts["build_label"]}'
        report['row_label'] = label
        (out / 'proposed_rows.txt').write_text(proposed_rows(report, label), encoding='utf-8')
        note = f'{facts["build_label"]} (native update tool {dt.date.today().isoformat()})'
        if args.apply:
            report['applied'] = nu_apply.apply(repo, report, label, note)
        if args.build:
            if not args.apply:
                raise SystemExit('--build requires --apply')
            main_checkout = Path(args.inputs_from).resolve() if args.inputs_from else None
            report['build'] = run_build(repo, out, main_checkout, exe)
            if report['build']['status'] != 'PASS':
                report['exit_code'], report['result'] = EXIT_BUILD, 'BUILD FAILED'
        if not args.no_snapshot and report['allowlist']['decision'] in ('add', 'already') \
                and report['exit_code'] in (EXIT_OK, EXIT_REVIEW):
            report['reference_snapshot'] = snapshot_reference(new, store)
    except SystemExit as e:
        report.update({'exit_code': EXIT_ERROR, 'result': 'TOOL ERROR', 'error': str(e)})
    except Exception as e:  # noqa: BLE001
        report.update({'exit_code': EXIT_ERROR, 'result': 'TOOL ERROR', 'error': f'{type(e).__name__}: {e}',
                       'traceback': traceback.format_exc()})
    out.mkdir(parents=True, exist_ok=True)
    (out / 'native_update_report.json').write_text(json.dumps(report, indent=2, default=str) + '\n', encoding='utf-8')
    if 'summary' in report:
        write_markdown(report, out / 'native_update_report.md')
        s = report['summary']
        print(f'NATIVE UPDATE {report["result"]} build={report["exe"]["build_label"]} unchanged={s["unchanged"]} '
              f'auto={s["auto"]} review={s["review"]} inactive={s["inactive"]} allowlist={report["allowlist"]["decision"]} '
              f'report={out / "native_update_report.json"}')
    else:
        print(f'NATIVE UPDATE TOOL ERROR {report.get("error")}', file=sys.stderr)
    return report['exit_code']


if __name__ == '__main__':
    sys.exit(main())
