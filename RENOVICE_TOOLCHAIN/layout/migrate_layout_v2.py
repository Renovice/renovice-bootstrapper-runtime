#!/usr/bin/env python3
"""One-time migration of the RENOVICE script folder to layout V2 (2026-10-10).

    python migrate_layout_v2.py <OpenWF folder>            dry run: prints the plan, writes nothing
    python migrate_layout_v2.py <OpenWF folder> --apply    copies into <OpenWF>/LuaScripts, then verifies

Old layout <OpenWF>/CustomScripts            ->  new layout <OpenWF>/LuaScripts
  Inject/**                                  ->  Addons/**
  <key>.lua_B, *.swf, *.swf.toc (root)       ->  Replacements/
  Packages/**                                ->  Packages/**
  renovice.cfg                               ->  Config/Logs.cfg
  ScriptStates.json + Settings/*.json        ->  Config/ScriptStates.json (schema 2: scripts + values)
  riven_lock.cfg[.disabled]                  ->  Config/
  Logs/**                                    ->  Logs/**
  Diagnostics/**                             ->  Logs/Dumps/**
  HOW_TO_ADD_SCRIPTS.md                      ->  HOW_TO_ADD_SCRIPTS.md
Anything else is reported and not copied (desktop.ini is Windows folder metadata).

Never deletes or changes CustomScripts. Refuses when LuaScripts already exists (the loader uses LuaScripts as soon as it
exists, so a half-filled folder must never appear). Once LuaScripts exists the loader ignores CustomScripts; delete or
rename CustomScripts yourself after the live test. The merged ScriptStates.json is written in the loader's own schema-2
format (compose_state_file_v2 in renovice/script_control_core.hpp).
"""
import hashlib
import json
import re
import shutil
import sys
from pathlib import Path

KEY_NAME = re.compile(r'^[0-9a-fA-F]{16}')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def json_quote(text):
    return json.dumps(text, ensure_ascii=False)


def indent_value(body):
    """Same canonical indentation as compose_state_file_v2: common indent of continuation lines removed, +4, CRLF."""
    lines = body.replace('\r', '').rstrip('\n ').split('\n')
    rest = [l for l in lines[1:] if l.strip(' ')]
    common = min((len(l) - len(l.lstrip(' ')) for l in rest), default=0)
    return '\r\n    '.join([lines[0]] + [l[common:] if len(l) >= common else '' for l in lines[1:]])


def compose_state_file_v2(switches, values):
    out = '{\r\n  "schema": 2,\r\n  "scripts": {'
    ordered = sorted(switches.items())
    out += ''.join((',\r\n    ' if n else '\r\n    ') + json_quote(k) + ': ' + ('true' if v else 'false')
                   for n, (k, v) in enumerate(ordered))
    out += '},\r\n' if not ordered else '\r\n  },\r\n'
    out += '  "values": {'
    vals = sorted(values.items())
    out += ''.join((',\r\n    ' if n else '\r\n    ') + json_quote(k) + ': ' + indent_value(v)
                   for n, (k, v) in enumerate(vals))
    out += '}\r\n}\r\n' if not vals else '\r\n  }\r\n}\r\n'
    return out


def plan(old):
    copies, reports = [], []

    def tree(src_dir, dst_prefix):
        for f in sorted(p for p in (old / src_dir).rglob('*') if p.is_file()):
            copies.append((f, dst_prefix + '/' + f.relative_to(old / src_dir).as_posix()))

    for entry in sorted(old.iterdir(), key=lambda p: p.name.lower()):
        name = entry.name
        if entry.is_dir():
            target = {'Inject': 'Addons', 'Packages': 'Packages', 'Logs': 'Logs', 'Diagnostics': 'Logs/Dumps'}.get(name)
            if target:
                tree(name, target)
            elif name != 'Settings':
                reports.append(f'folder {name}/ not migrated (unknown to the loader)')
            continue
        lower = name.lower()
        if lower == 'renovice.cfg':
            copies.append((entry, 'Config/Logs.cfg'))
        elif lower in ('riven_lock.cfg', 'riven_lock.cfg.disabled'):
            copies.append((entry, 'Config/' + name))
        elif lower == 'scriptstates.json':
            pass  # merged below
        elif lower == 'how_to_add_scripts.md':
            reports.append(f'{name} replaced by the Layout V2 README.md and HOW_TO_ADD_SCRIPTS.md from the repository')
        elif (lower.endswith('.lua_b') and KEY_NAME.match(name)) or lower.endswith('.swf') or lower.endswith('.swf.toc'):
            copies.append((entry, 'Replacements/' + name))
        elif lower == 'desktop.ini':
            reports.append('desktop.ini not migrated (Windows folder metadata)')
        else:
            reports.append(f'{name} not migrated (not a replacement, config or doc the loader reads)')
    return copies, reports


def merged_states(old, reports):
    switches = {}
    states = old / 'ScriptStates.json'
    if states.exists():
        data = json.loads(states.read_text(encoding='utf-8'))
        if data.get('schema') != 1 or not isinstance(data.get('scripts'), dict):
            raise SystemExit(f'{states}: not a schema-1 ScriptStates.json; refusing to merge')
        switches = {k: bool(v) for k, v in data['scripts'].items()}
        # Member switches were retired by contract R13: the loader ignores every `member:` entry (it logs
        # "MEMBER POLICY IGNORED" each start; the package row is the only switch). Carrying them would show a
        # state that is not real (e.g. a member listed as false while it runs), so they are dropped, reported.
        for key in sorted(k for k in switches if k.startswith('member:')):
            reports.append(f'ScriptStates.json switch {key} = {str(switches[key]).lower()} dropped '
                           '(member switches are ignored by the loader since R13; the package row is the switch)')
        switches = {k: v for k, v in switches.items() if not k.startswith('member:')}
    values = {}
    settings = old / 'Settings'
    for f in sorted(settings.glob('*.json')) if settings.is_dir() else []:
        text = f.read_text(encoding='utf-8')
        data = json.loads(text)
        key = data.get('package')
        expect = 'package:' + f.stem.lower()
        if key != expect:
            raise SystemExit(f'{f}: "package" is {key!r}, expected {expect!r}; refusing to merge')
        values[key] = text
    for f in sorted(settings.iterdir()) if settings.is_dir() else []:
        if f.suffix.lower() != '.json':
            reports.append(f'Settings/{f.name} not migrated (not a values file)')
    return switches, values


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    apply = '--apply' in sys.argv[1:]
    if len(args) != 1:
        raise SystemExit(__doc__)
    openwf = Path(args[0])
    old, new = openwf / 'CustomScripts', openwf / 'LuaScripts'
    if not old.is_dir():
        raise SystemExit(f'{old} does not exist')
    if new.exists():
        raise SystemExit(f'{new} already exists; refusing (the loader would use a half-filled folder)')
    copies, reports = plan(old)
    docs = Path(__file__).resolve().parents[2] / 'OpenWF' / 'LuaScripts'
    for doc in ('README.md', 'HOW_TO_ADD_SCRIPTS.md'):
        if (docs / doc).exists():
            copies.append((docs / doc, doc))
    switches, values = merged_states(old, reports)
    state_text = compose_state_file_v2(switches, values)
    print(f'MIGRATION PLAN {old} -> {new}')
    for src, dst in copies:
        shown = src.relative_to(old).as_posix() if src.is_relative_to(old) else f'(repository) {src.name}'
        print(f'  copy  {shown}  ->  {dst}')
    print(f'  merge ScriptStates.json ({len(switches)} switches) + Settings/*.json ({len(values)} packages: '
          f'{", ".join(sorted(values))})  ->  Config/ScriptStates.json')
    for line in reports:
        print(f'  skip  {line}')
    print(f'  {len(copies)} files to copy, 1 merged file, {len(reports)} reported; CustomScripts is left unchanged')
    if not apply:
        print('DRY RUN: nothing written (add --apply)')
        return 0
    staging = openwf / 'LuaScripts.migrating'
    if staging.exists():
        raise SystemExit(f'{staging} exists from an interrupted run; inspect and remove it first')
    for src, dst in copies:
        target = staging / dst
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, target)
    (staging / 'Config').mkdir(parents=True, exist_ok=True)
    (staging / 'Config' / 'ScriptStates.json').write_bytes(state_text.encode('utf-8'))
    for name in ('Addons', 'Replacements', 'Packages', 'Logs/Dumps'):
        (staging / name).mkdir(parents=True, exist_ok=True)
    bad = [dst for src, dst in copies if sha(src) != sha(staging / dst)]
    written = json.loads((staging / 'Config' / 'ScriptStates.json').read_text(encoding='utf-8'))
    ok_states = (written.get('schema') == 2 and written.get('scripts') == switches
                 and set(written.get('values', {})) == set(values)
                 and all(written['values'][k] == json.loads(v) for k, v in values.items()))
    if bad or not ok_states:
        raise SystemExit(f'VERIFY FAIL: {len(bad)} copied files differ {bad[:3]}; merged states ok={ok_states}; '
                         f'{staging} kept for inspection, LuaScripts not created')
    staging.rename(new)   # the loader only ever sees a complete folder
    print(f'MIGRATION PASS: {len(copies)} files byte-identical, ScriptStates.json schema 2 with {len(switches)} switches '
          f'and {len(values)} packages\' values identical; {new} created, {old} unchanged')
    return 0


if __name__ == '__main__':
    sys.exit(main())
