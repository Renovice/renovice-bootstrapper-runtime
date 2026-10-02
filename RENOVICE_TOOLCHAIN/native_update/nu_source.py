"""The bootstrapper's native facts, read from a source tree (a worktree on disk; never the game folder).

Every reader here records WHERE a fact lives (file + character span) so `nu_apply` can rewrite exactly that span.
"""
from __future__ import annotations

import hashlib
import json
import re
from dataclasses import dataclass, field
from pathlib import Path

HEX_LITERAL_RUN = re.compile(
    r'"((?:[0-9A-Fa-f]{2}|\?\??)(?: +(?:[0-9A-Fa-f]{2}|\?\??))*\s*)"'
    r'(?:\s*(?://[^\n]*\n\s*)?"((?:[0-9A-Fa-f]{2}|\?\??)(?: +(?:[0-9A-Fa-f]{2}|\?\??))*\s*)")*')
HEX_ONE = re.compile(r'"([^"]*)"')
CENSUS_TOKENS_MIN = 4


def read_text(path: Path) -> str:
    """UTF-8 text with LF line ends (spans recorded on this text are what nu_apply rewrites)."""
    return path.read_bytes().decode('utf-8').replace('\r\n', '\n')


def loads_jsonc(text: str):
    """JSON with // comments, trailing commas and 0x integers (the OpenWF data files)."""
    out, i, n, in_str = [], 0, len(text), False
    while i < n:
        c = text[i]
        if in_str:
            out.append(c)
            if c == '\\':
                out.append(text[i + 1])
                i += 1
            elif c == '"':
                in_str = False
        elif c == '"':
            in_str = True
            out.append(c)
        elif text.startswith('//', i):
            while i < n and text[i] != '\n':
                i += 1
            continue
        else:
            out.append(c)
        i += 1
    cleaned = re.sub(r',(\s*[}\]])', r'\1', ''.join(out))
    cleaned = re.sub(r'"(?:[^"\\]|\\.)*"|\b0x[0-9a-fA-F]+\b',
                     lambda m: m.group(0) if m.group(0).startswith('"') else str(int(m.group(0), 16)), cleaned)
    return json.loads(cleaned)


def gv2n(ver: str) -> int:
    parts = [int(x) for x in ver.split('.')] + [0, 0]
    return parts[0] * 10000 + parts[1] * 100 + parts[2]


def joaat(text: str | bytes) -> int:
    h = 0
    for c in (text.encode() if isinstance(text, str) else text):
        h = (h + c) & 0xFFFFFFFF
        h = (h + (h << 10)) & 0xFFFFFFFF
        h ^= h >> 6
    h = (h + (h << 3)) & 0xFFFFFFFF
    h ^= h >> 11
    return (h + (h << 15)) & 0xFFFFFFFF


def name_hash(name: str, seed: int) -> int:
    """DE name hash (FNV-1a 32 from the build seed, not, rol 17)."""
    h = seed
    for byte in name.encode():
        h = ((h ^ byte) * 0x01000193) & 0xFFFFFFFF
    h = (~h) & 0xFFFFFFFF
    return ((h << 17) | (h >> 15)) & 0xFFFFFFFF


# -- census -----------------------------------------------------------------------------------------------------------------
@dataclass
class SignatureRow:
    id: str
    file: str
    line: int
    context: str
    pattern: str
    commented: bool
    span: tuple[int, int] | None = None       # character span of the literal run in `file` (for rewriting)
    json_key: str | None = None               # OpenWF/vv/sig: the version key whose value is the active pattern


def _normal(pattern: str) -> str:
    return ' '.join(t if t not in ('??',) else '?' for t in pattern.split()).upper().replace('??', '?')


def census_rows(repo: Path, game_version: int) -> list[SignatureRow]:
    """Every hex-pattern literal in main.cpp, renovice/*.{cpp,hpp} and the active OpenWF/vv/sig entries (the 44.0.2
    census method). Ids match the ability-editor update check (`file#sha1(pattern)[:10]#ordinal`)."""
    rows: list[SignatureRow] = []
    files = ['main.cpp'] + sorted(str(p.relative_to(repo)).replace('\\', '/')
                                  for p in (repo / 'renovice').glob('*') if p.suffix in ('.cpp', '.hpp'))
    for f in files:
        text = read_text(repo / f)
        seen: dict[str, int] = {}
        for m in HEX_LITERAL_RUN.finditer(text):
            parts = HEX_ONE.findall(m.group(0))
            pattern = _normal(' '.join(' '.join(p.split()) for p in parts))
            if len(pattern.split()) < CENSUS_TOKENS_MIN:
                continue
            line_start = text.rfind('\n', 0, m.start()) + 1
            line_end = text.find('\n', m.start())
            context = text[line_start:line_end].strip()
            if context.startswith('"') or len(context) < 12:
                prev = text.rfind('\n', 0, line_start - 1) + 1
                context = text[prev:line_start].strip() + ' ' + context
            ordinal = seen.get(pattern, 0)
            seen[pattern] = ordinal + 1
            rows.append(SignatureRow(
                id=f'{f}#{hashlib.sha1(pattern.encode()).hexdigest()[:10]}#{ordinal}', file=f,
                line=text.count('\n', 0, m.start()) + 1, context=context[:110], pattern=pattern,
                commented=text[line_start:m.start()].lstrip().startswith('//'), span=(m.start(), m.end())))
    for p in sorted((repo / 'OpenWF' / 'vv' / 'sig').glob('*.json')):
        f = str(p.relative_to(repo)).replace('\\', '/')
        table = loads_jsonc(read_text(p))
        best = None
        for ver, pattern in table.items():
            if gv2n(ver) <= game_version and (best is None or gv2n(ver) > gv2n(best[0])):
                best = (ver, pattern)
        if best and best[1]:
            rows.append(SignatureRow(id=f'{f}@{best[0]}', file=f, line=0, context=f'{p.stem} (version {best[0]})',
                                     pattern=_normal(best[1]), commented=False, json_key=best[0]))
    return rows


# -- per-build tables -------------------------------------------------------------------------------------------------------
_TOKEN = re.compile(r'"((?:[^"\\]|\\.)*)"|(0x[0-9a-fA-F]+|\b\d+\b)')


def _tokens(text: str, anchor: str) -> list:
    start = text.index(anchor)
    end = text.index('}};', start)
    body = re.sub(r'"\s*\n\s*"', '', text[start + len(anchor):end])
    body = re.sub(r'//[^\n]*', '', body)
    return [m.group(1) if m.group(1) is not None else int(m.group(2), 0) for m in _TOKEN.finditer(body)]


ED_LAYOUT = ['control_target', 'target_health_slot', 'control_shield_slot', 'control_overguard_slot',
             'packet_fractions', 'packet_value', 'value_encoded', 'value_addition', 'value_override',
             'value_cached', 'value_flags', 'value_override_flag', 'value_cached_flag']


def parse_engine_damage_builds(text: str) -> list[dict]:
    t = _tokens(text, 'registered_builds{{')
    builds, i = [], 0
    while i < len(t):
        label, d1, d2 = t[i], t[i + 1], t[i + 2]
        i += 3
        nums = []
        while i < len(t) and isinstance(t[i], int):
            nums.append(t[i])
            i += 1
        if len(nums) != 21:
            raise ValueError(f'engine_damage_builds: {label}: expected 21 numbers, found {len(nums)}')
        builds.append({'label': label, 'digests': [d for d in (d1, d2) if d], 'handlers': nums[0:3],
                       'evaluator': nums[3], 'integer_codec': {'rotate': nums[4], 'key': nums[5]},
                       'float_codec': {'rotate': nums[6], 'key': nums[7]},
                       'layout': dict(zip(ED_LAYOUT, nums[8:21]))})
    return builds


EP_LAYOUT_COUNT = 24          # Layout fields incl. the two number types


def parse_engine_params_builds(text: str) -> list[dict]:
    t = _tokens(text, 'registered_builds{{')
    builds, i = [], 0
    while i < len(t):
        label, d1, d2 = t[i], t[i + 1], t[i + 2]
        i += 3
        nums = []
        while i < len(t) and isinstance(t[i], int) and not (i + 1 < len(t) and isinstance(t[i + 1], str)):
            nums.append(t[i])
            i += 1
        checks = []
        while i + 2 < len(t) and isinstance(t[i], int) and isinstance(t[i + 1], str) and isinstance(t[i + 2], str):
            checks.append({'rva': t[i], 'hex': t[i + 1], 'reason': t[i + 2]})
            i += 3
        builds.append({'label': label, 'digests': [d for d in (d1, d2) if d], 'push_value_rva': nums[0],
                       'seed': nums[1], 'layout': nums[2:], 'checks': checks})
    return builds


def parse_certified_clients(ps1: str) -> list[dict]:
    out = []
    for block in re.findall(r'@\{(.*?)\}', ps1, re.S):
        fields = dict(re.findall(r'(\w+)\s*=\s*"([^"]*)"', block))
        if 'Sha256' in fields:
            out.append(fields)
    return out


def cpp_string(text: str, name: str) -> str:
    m = re.search(name + r'\[\]\s*=\s*((?:\s*"[^"]*")+)\s*;', text) or \
        re.search(name + r'\s*=\s*((?:\s*"[^"]*")+)\s*;', text)
    if not m:
        raise ValueError(f'string constant {name} not found')
    return ''.join(re.findall(r'"([^"]*)"', m.group(1)))


def cpp_int(text: str, name: str) -> int:
    m = re.search(name + r'\s*=\s*(0x[0-9a-fA-F]+|\d+)', text)
    if not m:
        raise ValueError(f'integer constant {name} not found')
    return int(m.group(1), 0)


@dataclass
class SourceFacts:
    repo: Path
    commit: str
    dirty: list[str]
    title: str
    game_versions: dict
    tunables: dict
    seeds: dict
    engine_damage: list[dict]
    engine_params: list[dict]
    certified: list[dict]
    texts: dict = field(default_factory=dict)

    def text(self, rel: str) -> str:
        if rel not in self.texts:
            self.texts[rel] = read_text(self.repo / rel)
        return self.texts[rel]

    def game_version_of(self, build_label: str) -> tuple[str | None, int]:
        gv = None
        for date, ver in sorted(self.game_versions.items()):
            if date <= build_label:
                gv = ver
        return gv, (gv2n(gv) if gv else 0)

    def seed_for(self, game_version: int) -> int | None:
        best = None
        for ver, seed in self.seeds.items():
            if gv2n(ver) <= game_version and (best is None or gv2n(ver) > gv2n(best[0])):
                best = (ver, seed)
        return (best[1] & 0xFFFFFFFF) if best else None


def read_source(repo: Path) -> SourceFacts:
    import subprocess
    def git(*args):
        r = subprocess.run(['git', '-C', str(repo), *args], capture_output=True, text=True, encoding='utf-8',
                           errors='replace')
        return r.stdout.strip() if r.returncode == 0 else ''
    commit = git('rev-parse', 'HEAD')
    dirty = [l[3:] for l in git('status', '--porcelain').splitlines() if l.strip()]
    main_hpp = read_text(repo / 'main.hpp')
    title = re.search(r'#define BOOTSTRAPPER_TITLE "([^"]+)"', main_hpp).group(1)
    return SourceFacts(
        repo=repo, commit=commit, dirty=dirty, title=title,
        game_versions=loads_jsonc(read_text(repo / 'OpenWF/vv/game_versions.json')),
        tunables=loads_jsonc(read_text(repo / 'OpenWF/tunables.json')),
        seeds=loads_jsonc(read_text(repo / 'OpenWF/vv/wf_fnv_2_initial.json')),
        engine_damage=parse_engine_damage_builds(read_text(repo / 'renovice/engine_damage_builds.hpp')),
        engine_params=parse_engine_params_builds(read_text(repo / 'renovice/engine_params_builds.hpp')),
        certified=parse_certified_clients(read_text(repo / 'RENOVICE_TOOLCHAIN/version44/verify_client_44.ps1')))
