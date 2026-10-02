"""Writes the auto items into a bootstrapper source tree (a git worktree; never the game folder).

Only `auto` items are written; `review` items are left out, so their feature fails closed in the rebuilt DLL:
  signature    the literal (or the active OpenWF/vv/sig version entry) gets the relaxed pattern; exact copies of the old
               literal in RENOVICE_TOOLCHAIN/version44/verify_client_44.cpp follow;
  table        one new row in renovice/engine_damage_builds.hpp and/or renovice/engine_params_builds.hpp;
  allowlist    OpenWF/tunables.json supported_builds_44 / supported_client_sha256_44 (shipped in Hotfix.owf and the
               built-in archive) and the certified table of RENOVICE_TOOLCHAIN/version44/verify_client_44.ps1.
Each file keeps its line endings. Returns the list of changed files.
"""
from __future__ import annotations

import re
from pathlib import Path

import nu_engine_damage
import nu_engine_params

VERIFIER_DUPLICATES = ['RENOVICE_TOOLCHAIN/version44/verify_client_44.cpp']


class Tree:
    def __init__(self, repo: Path):
        self.repo = repo
        self.changed: dict[str, str] = {}
        self.eol: dict[str, str] = {}

    def read(self, rel: str) -> str:
        if rel not in self.changed:
            raw = (self.repo / rel).read_bytes().decode('utf-8')
            self.eol[rel] = '\r\n' if '\r\n' in raw else '\n'
            self.changed[rel] = raw.replace('\r\n', '\n')
        return self.changed[rel]

    def write(self, rel: str, text: str):
        self.read(rel)
        self.changed[rel] = text

    def flush(self) -> list[str]:
        written = []
        for rel, text in self.changed.items():
            original = (self.repo / rel).read_bytes().decode('utf-8').replace('\r\n', '\n')
            if original == text:
                continue
            data = text.replace('\n', self.eol[rel]).encode('utf-8')
            (self.repo / rel).write_bytes(data)
            written.append(rel)
        return sorted(written)


def _apply_signatures(tree: Tree, items: list[dict]) -> list[str]:
    log = []
    by_file: dict[str, list[dict]] = {}
    for it in items:
        if it['status'] == 'auto' and it.get('edit') == 'signature':
            if it['apply']['span'] is None and it['apply']['json_key'] is None:
                log.append(f'{it["id"]}: test-only row (no source literal), not applied')
                continue
            by_file.setdefault(it['apply']['file'], []).append(it['apply'])
    for rel, edits in by_file.items():
        text = tree.read(rel)
        if rel.startswith('OpenWF/vv/sig/'):
            for e in edits:
                rx = re.compile(r'("' + re.escape(e['json_key']) + r'"\s*:\s*")([^"]*)(")')
                text, n = rx.subn(lambda m: m.group(1) + e['new_pattern'] + m.group(3), text, count=1)
                if n != 1:
                    raise ValueError(f'{rel}: version key {e["json_key"]} not found')
                log.append(f'{rel} [{e["json_key"]}]: {e["old_pattern"]} -> {e["new_pattern"]}')
        else:
            for e in sorted(edits, key=lambda e: -e['span'][0]):
                a, b = e['span']
                old = ' '.join(' '.join(re.findall(r'"([^"]*)"', text[a:b])).split()).upper()
                if old != e['old_pattern']:
                    raise ValueError(f'{rel}: literal at {a} is no longer the census pattern')
                text = text[:a] + '"' + e['new_pattern'] + '"' + text[b:]
                log.append(f'{rel}:{text.count(chr(10), 0, a) + 1}: {e["old_pattern"]} -> {e["new_pattern"]}')
        tree.write(rel, text)
    for rel in VERIFIER_DUPLICATES:
        text = tree.read(rel)
        for edits in by_file.values():
            for e in edits:
                needle = '"' + e['old_pattern'] + '"'
                if needle in text:
                    text = text.replace(needle, '"' + e['new_pattern'] + '"')
                    log.append(f'{rel}: verifier copy of {e["old_pattern"]} relaxed')
        tree.write(rel, text)
    return log


def _append_row(tree: Tree, rel: str, row: str) -> None:
    text = tree.read(rel)
    m = re.search(r'std::array<BuildRegistration, (\d+)> registered_builds\{\{', text)
    if not m:
        raise ValueError(f'{rel}: registered_builds array not found')
    text = text[:m.start(1)] + str(int(m.group(1)) + 1) + text[m.end(1):]
    end = text.index('\n}};', m.end())
    text = text[:end] + '\n' + row + text[end:]
    tree.write(rel, text)


def _allowlist(tree: Tree, label: str, sha: str, family: int, note: str) -> list[str]:
    log = []
    rel = 'OpenWF/tunables.json'
    text = tree.read(rel)
    key = f'"supported_builds_{family}"'
    m = re.search(re.escape(key) + r'\s*:\s*\[([^\]]*)\]', text)
    if not m:
        raise ValueError(f'{rel}: {key} not found')
    if f'"{label}"' not in m.group(1):
        body = m.group(1).rstrip()
        sep = '' if body.endswith(',') or not body.strip() else ', '
        text = text[:m.start(1)] + body + sep + f'"{label}"' + m.group(1)[len(m.group(1).rstrip()):] + text[m.end(1):]
        log.append(f'{rel}: supported_builds_{family} += {label}')
    key = f'"supported_client_sha256_{family}"'
    m = re.search(re.escape(key) + r'\s*:\s*\[(.*?)\n(\s*)\]', text, re.S)
    if not m:
        raise ValueError(f'{rel}: {key} not found')
    if f'"{sha}"' not in m.group(1):
        indent = re.search(r'\n(\s*)"', m.group(1))
        indent = indent.group(1) if indent else '\t\t'
        insert = f'\n{indent}"{sha}", // {note}'
        text = text[:m.end(1)] + insert + text[m.end(1):]
        log.append(f'{rel}: supported_client_sha256_{family} += {sha}')
    tree.write(rel, text)
    return log


def _certify(tree: Tree, label: str, sha: str, undump: dict, note: str) -> list[str]:
    rel = 'RENOVICE_TOOLCHAIN/version44/verify_client_44.ps1'
    text = tree.read(rel)
    if f'Sha256 = "{sha}"' in text:
        return []
    m = re.search(r'\n\}\)\n\$repo = ', text)
    if not m:
        raise ValueError(f'{rel}: certified table end not found')
    block = (f'\n}}, @{{\n    # {note}\n    Version = "{label}"\n    Sha256 = "{sha}"\n'
             f'    UndumpRaw = "{undump["raw"]:x}"\n    UndumpRva = "{undump["rva"]:x}"')
    text = text[:m.start()] + block + text[m.start():]
    tree.write(rel, text)
    return [f'{rel}: certified {label} {sha[:16]} undump raw 0x{undump["raw"]:x} rva 0x{undump["rva"]:x}']


def apply(repo: Path, report: dict, row_label: str, note: str) -> dict:
    tree = Tree(repo)
    log = _apply_signatures(tree, report['items'])
    sha = report['exe']['sha256']
    tables = report['tables']
    ed = tables.get('engine_damage', {})
    if ed.get('status') == 'auto':
        _append_row(tree, 'renovice/engine_damage_builds.hpp', nu_engine_damage.row_cpp(row_label, [sha], ed['registration']))
        log.append(f'renovice/engine_damage_builds.hpp: registration "{row_label}"')
    ep = tables.get('engine_params', {})
    if ep.get('status') == 'auto':
        _append_row(tree, 'renovice/engine_params_builds.hpp', nu_engine_params.row_cpp(
            row_label, [sha], ep['registration'], f'carried over from {ep["from"]} ({note})'))
        log.append(f'renovice/engine_params_builds.hpp: registration "{row_label}"')
    allow = report['allowlist']
    if allow['decision'] == 'add':
        log += _allowlist(tree, report['exe']['build_label'], sha, report['exe']['family'], note)
        if report['facts'].get('undump'):
            log += _certify(tree, report['exe']['build_label'], sha, report['facts']['undump'], note)
    files = tree.flush()
    return {'files': files, 'log': log}
