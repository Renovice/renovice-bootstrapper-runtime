"""Every native dependency of the bootstrapper, checked against a new image and re-found by identity when it moved.

Item statuses (report field `status`):
  unchanged  same RVA and the same bytes as on the reference build;
  auto       moved and/or rewritten, and re-found uniquely with strict verification. `edit` says what the tool
             changes for it: `none` (the runtime re-finds it itself), `signature` (a source literal is relaxed) or
             `table` (a per-build row / allowlist entry is added);
  review     not re-found uniquely, or verification failed. Nothing is applied for it; the feature fails closed;
  inactive   a version-gated, legacy or commented signature that does not match on the reference build either.

Scopes: `process` items gate the whole build (an unresolved one keeps the build off the allowlist, so the DLL refuses
the client); `feature` items fail closed in their own feature only; `verifier` items affect only an offline verifier;
`cosmetic` items change nothing at run time.
"""
from __future__ import annotations

import re
import struct

from nu_engine_damage import compare as ed_compare, derive as ed_derive
from nu_engine_params import relocate as ep_relocate
from nu_image import Image, pattern_tokens
from nu_reloc import Relocator
from nu_source import SourceFacts, census_rows, cpp_int, cpp_string, name_hash

FILE_FEATURES = [
    ('renovice/de_vm_authority', 'DE Lua API: VM capture, Scripts menu, Inject/addons, F9 reload'),
    ('renovice/injection_core', 'DE Lua injection: module loader, addons, replacements'),
    ('renovice/injected_interrupt_budget', 'luaCalls before-hooks (Missions values, mission addons)'),
    ('renovice/vm_memory_evidence', 'VM memory diagnostics'),
    ('renovice/vm_stack_write', 'Addon hooks: argument/result write-back (luaCalls, nativeCalls)'),
    ('renovice/riven_core', 'Riven lock UI'),
    ('renovice/swf_core', 'SWF replacements'),
    ('renovice/engine_damage', 'ENGINE_DAMAGE observer (battle log, Mallet Overguard numbers)'),
    ('renovice/replacements', 'Replacement lane (module undump)'),
    ('renovice/application_frame_profile', 'OpenWF frame tick (hotkeys F9/F10, safe runtime tick)'),
    ('renovice/', 'RENOVICE runtime'),
    ('main.cpp', 'OpenWF bootstrapper core'),
    ('OpenWF/vv/sig/', 'OpenWF bootstrapper core (versioned signature)'),
]
# Files whose signatures are resolved first-match (no uniqueness check at run time): a relaxed pattern must be unique
# on every image we can check, and an unresolved one keeps the build off the allowlist (main.cpp, vv/sig).
PROCESS_FILES = ('main.cpp', 'OpenWF/vv/sig/')
FIRST_MATCH_FILES = ('main.cpp', 'OpenWF/vv/sig/', 'renovice/replacements.cpp')
NAME_HASH_FUNCTION = ('B8 ? ? ? ? 48 85 D2 74 ? 66 0F 1F 44 00 00 44 0F B6 01 48 8D 49 01 44 33 C0 41 69 C0 '
                      '93 01 00 01 48 83 EA 01 75 ? F7 D0 C1 C0 11 C3')
UNDUMP = '40 53 55 56 57 41 55 41 56 41 57 48 81 EC F0 01 00 00 48 8B 05 ? ? ? ? 48 33'
PROFILE_DIR = ('40 55 53 56 48 8D AC 24 ? ? ? ? 48 81 EC ? ? ? ? 48 8B 05 ? ? ? ? 48 33 C4 48 89 85 ? ? ? ? 48 8D 99 '
               '? ? ? ? 48 8B F1')
PROFILE_DIR_PIN = 0x2B8
NATIVE_FEATURES = {'RunScript': 'RunScript observer: ability-card rows (Mallet, Ice Wave cards)',
                   'PushFloatArg': 'nativeCalls float transform (Mallet threat level)',
                   'SetDamageCallback': 'afterDamage hooks (Mallet Overguard)',
                   'SetSourceObject': 'afterDamage hooks (damage source)',
                   'GetAbilityUpgradeLevelInfo': 'ability-card compatibility path',
                   'Initialize': 'target-addon Initialize export binding'}


def feature_for(path: str) -> str:
    for prefix, feature in FILE_FEATURES:
        if path.startswith(prefix):
            return feature
    return 'RENOVICE runtime'


def item(id, kind, feature, scope, status, **kw):
    d = {'id': id, 'kind': kind, 'feature': feature, 'scope': scope, 'status': status, 'edit': 'none',
         'strategy': '', 'ref_rva': None, 'new_rva': None, 'evidence': [], 'reason': ''}
    d.update(kw)
    for k in ('ref_rva', 'new_rva'):
        if isinstance(d[k], int):
            d[k] = f'0x{d[k]:x}'
    return d


class Checker:
    def __init__(self, src: SourceFacts, ref: Image, new: Image, extra_refs: list[Image] | None = None,
                 extra_signatures: list | None = None):
        self.src, self.ref, self.new = src, ref, new
        self.extra_refs = extra_refs or []
        self.extra_signatures = extra_signatures or []
        self.rel = Relocator(ref, new)
        self.items: list[dict] = []
        self.sig_new: dict[str, int | None] = {}       # signature id -> new RVA when unique
        self.sig_pattern: dict[str, str] = {}          # signature id -> pattern that resolves on the new image
        self.tables: dict = {}
        self.facts: dict = {}

    def add(self, it):
        self.items.append(it)
        return it

    def run(self) -> dict:
        self.identity()
        self.signatures()
        self.de_vm_authority()
        self.lua_calls()
        self.openwf_frame()
        self.seed()
        self.native_names()
        self.engine_damage()
        self.engine_params()
        self.undump()
        self.wts()
        self.profile_dir()
        return {'items': self.items, 'tables': self.tables, 'facts': self.facts}

    # -- build identity --------------------------------------------------------------------------------------------------
    def identity(self):
        label = self.new.product_version() or ''
        gv, gvn = self.src.game_version_of(label)
        toonew = self.src.tunables.get('toonew', {}).get('$gv', '0')
        self.facts.update(build_label=label, game_version=gv, game_version_n=gvn,
                          family=44 if gvn >= 440000 else 43, reference_label=self.ref.product_version(),
                          toonew=toonew)
        ok = bool(re.fullmatch(r'\d{4}\.\d{2}\.\d{2}\.\d{2}\.\d{2}', label)) and gv is not None
        from nu_source import gv2n
        below = gvn < gv2n(toonew)
        family_ok = 440000 <= gvn < 450000
        self.add(item('build.identity', 'build', 'OpenWF bootstrapper start', 'process',
                      'unchanged' if ok and below and family_ok else 'review',
                      new=label, evidence=[f'ProductVersion {label!r} -> game_versions.json {gv}; toonew {toonew}; '
                                           f'exe sha256 {self.new.sha256}'],
                      reason='' if ok and below and family_ok else
                      'build label/game version outside the U44 family this tool maintains (a new major version '
                      'needs game_versions.json, seeds and the toonew cutoff reviewed by hand)'))

    # -- census ------------------------------------------------------------------------------------------------------------
    def _references_for(self, pattern: str) -> list[tuple[Image, int]]:
        out = []
        for img in [self.ref] + self.extra_refs:
            hits = img.scan(pattern, limit=2)
            if len(hits) == 1:
                out.append((img, hits[0]))
        return out

    def signatures(self):
        rows = census_rows(self.src.repo, self.facts['game_version_n'] or 440000) + self.extra_signatures
        self.facts['census_rows'] = len(rows)
        for row in rows:
            feature = feature_for(row.file)
            scope = 'process' if row.file.startswith(PROCESS_FILES) else 'feature'
            src = {'file': row.file, 'line': row.line, 'context': row.context}
            ref_hits = self.ref.scan(row.pattern, limit=1024)
            new_hits = self.new.scan(row.pattern, limit=1024)
            base = dict(source=src, pattern=row.pattern, ref_count=len(ref_hits), new_count=len(new_hits))
            if row.commented or not ref_hits:
                self.add(item(row.id, 'signature', feature, scope, 'inactive', **base,
                              evidence=[('commented out; ' if row.commented else '') +
                                        f'{len(ref_hits)} match(es) on the reference build, {len(new_hits)} on the new'
                                        + (' (a legacy row now matches: not used on this family)' if new_hits and not ref_hits else '')]))
                continue
            if len(ref_hits) > 1:
                st = 'unchanged' if len(new_hits) == len(ref_hits) else 'review'
                self.add(item(row.id, 'signature', feature, scope, st, **base, strategy='count',
                              evidence=[f'multi-match row: {len(ref_hits)} on the reference, {len(new_hits)} on the new'],
                              reason='' if st == 'unchanged' else 'multi-match count changed; the first-match / '
                              'iteration use needs a manual check'))
                continue
            r = ref_hits[0]
            tokens = pattern_tokens(row.pattern)
            if len(new_hits) == 1:
                h = new_hits[0]
                diffs = self.rel.strict(r, h, len(tokens))
                self.sig_new[row.id], self.sig_pattern[row.id] = h, row.pattern
                self.add(item(row.id, 'signature', feature, scope, 'unchanged' if h == r else 'auto', **base,
                              strategy='exact', ref_rva=r, new_rva=h,
                              evidence=[f'pattern unique on the new image at 0x{h:x}'] +
                                       ([f'identity notes: {"; ".join(diffs[:3])}'] if diffs else [])))
                continue
            got = self.rel.locate(r, tokens)
            if got.rva is None:
                self.sig_new[row.id] = None
                self.add(item(row.id, 'signature', feature, scope, 'review', **base, strategy=got.strategy,
                              ref_rva=r, evidence=got.evidence + [f'candidate 0x{c:x}' for c in got.candidates[:3]]
                              + got.diffs, reason=f'not re-found uniquely ({got.status}); the runtime refuses this '
                              'signature' + (' and the build stays off the allowlist' if scope == 'process' else '')))
                continue
            refs = [(self.ref, r)] + [(img, s) for img, s in self._references_for(row.pattern) if img is not self.ref]
            pattern, notes = self.rel.relaxed_pattern(tokens, got.rva, got.length, refs)
            if pattern is None:
                self.sig_new[row.id] = None
                self.add(item(row.id, 'signature', feature, scope, 'review', **base, strategy=got.strategy,
                              ref_rva=r, new_rva=got.rva, evidence=got.evidence + notes,
                              reason='re-found, but no relaxed pattern is unique on every checked image'))
                continue
            self.sig_new[row.id], self.sig_pattern[row.id] = got.rva, pattern
            self.add(item(row.id, 'signature', feature, scope, 'auto', **base, edit='signature', strategy=got.strategy,
                          ref_rva=r, new_rva=got.rva, new_pattern=pattern, evidence=got.evidence + notes,
                          apply={'file': row.file, 'span': row.span, 'json_key': row.json_key,
                                 'old_pattern': row.pattern, 'new_pattern': pattern},
                          checked_images=[f'{img.product_version()} {img.sha256[:12]}' for img, _ in refs]))

    def _sig(self, file_prefix: str, const_text: str) -> tuple[str | None, int | None]:
        """(id, new RVA) of the census row for a named source constant."""
        pattern = ' '.join(const_text.split()).upper()
        for it in self.items:
            if it['kind'] == 'signature' and it['source']['file'].startswith(file_prefix) and it['pattern'] == pattern:
                return it['id'], self.sig_new.get(it['id'])
        return None, None

    # -- DE_VM_AUTHORITY lock identity -------------------------------------------------------------------------------------
    def de_vm_authority(self):
        core = self.src.text('renovice/de_vm_authority_core.hpp')
        thunk_sig = cpp_string(core, 'signature_lock_thunk')
        slot_disp = cpp_int(core, 'lock_thunk_slot_displacement')
        capacity = cpp_int(core, 'lock_thunk_scan_capacity')
        module = cpp_string(core, 'lock_import_module')
        imports = (cpp_string(core, 'signature_lock_enter_import'), cpp_string(core, 'signature_lock_leave_import'))
        enter_disp = cpp_int(core, 'locked_dispatcher_enter_displacement')
        epi_sig = cpp_string(core, 'signature_locked_dispatcher_epilogue')
        window = cpp_int(core, 'locked_dispatcher_epilogue_window')
        leave_disp = cpp_int(core, 'locked_dispatcher_leave_displacement')
        feature = 'DE Lua API: VM capture, Scripts menu, Inject/addons, target addons, F9 reload (whole DE Lua lane)'

        def resolve(img: Image):
            thunks = img.scan(thunk_sig, limit=capacity)
            out = []
            for imp in imports:
                slot = img.import_slot(module, imp)
                hits = [t for t in thunks if slot and img.rel32_target(t + slot_disp) == slot]
                out.append((hits[0] if len(hits) == 1 and len(thunks) < capacity else None, len(hits), len(thunks), slot))
            return out
        ref_r, new_r = resolve(self.ref), resolve(self.new)
        for label, (rr, nr) in zip(('lock-enter', 'lock-leave'), zip(ref_r, new_r)):
            ok = nr[0] is not None
            st = 'review' if not ok else ('unchanged' if nr[0] == rr[0] else 'auto')
            self.add(item(f'de_vm_authority.{label}', 'identity', feature, 'feature', st, strategy='import identity',
                          ref_rva=rr[0], new_rva=nr[0],
                          evidence=[f'thunks={nr[2]} matches={nr[1]} import={module}!{imports[label == "lock-leave"]} '
                                    f'slot=0x{nr[3]:x}' + ('' if st != 'auto' else
                                    f'; moved 0x{rr[0]:x} -> 0x{nr[0]:x} (resolved at run time by import identity; '
                                    'no source change)')],
                          reason='' if ok else 'lock thunk not unique by import identity'))
        did, disp = self._sig('renovice/de_vm_authority_core', cpp_string(core, 'signature_locked_dispatcher'))
        ok, detail = disp is not None, []
        if ok:
            enter = self.new.rel32_target(disp + enter_disp)
            epis = self.new.scan(epi_sig, start=disp, end=disp + window)
            leave = self.new.rel32_target(epis[0] + leave_disp) if len(epis) == 1 else 0
            ok = len(epis) == 1 and enter == new_r[0][0] and leave == new_r[1][0]
            detail.append(f'dispatcher 0x{disp:x}: +{enter_disp} calls 0x{enter:x}, epilogue tail-jumps to 0x{leave:x} '
                          f'(lock-enter 0x{(new_r[0][0] or 0):x}, lock-leave 0x{(new_r[1][0] or 0):x})')
        self.add(item('de_vm_authority.cross-check', 'identity', feature, 'feature', 'unchanged' if ok else 'review',
                      strategy='dispatcher cross-check', new_rva=disp, evidence=detail,
                      reason='' if ok else 'locked dispatcher does not call the resolved lock thunks'))

    # -- luaCalls boundary -----------------------------------------------------------------------------------------------
    def lua_calls(self):
        text = self.src.text('renovice/injected_interrupt_budget.hpp')
        inc, guard = cpp_string(text, 'signature_interrupt_increment_u43'), cpp_string(text, 'signature_interrupt_guard_u43')
        feature = 'luaCalls before-hooks: Missions values, mission target addons (every luaCalls hook)'
        _, leaf = self._sig('renovice/injected_interrupt_budget', inc)
        gid, g = self._sig('renovice/injected_interrupt_budget', guard)
        ok, ev = leaf is not None and g is not None, []
        if ok:
            gpat = self.sig_pattern[gid]
            call = g + gpat.split().index('E8') + 1
            target = self.new.rel32_target(call)
            ok = target == leaf
            ev.append(f'owner callback 0x{g:x} calls 0x{target:x}; interrupt leaf 0x{leaf:x}')
            leaf_bytes = self.new.mem[leaf:leaf + 13]
            ev.append(f'leaf: inc dword [rcx+0x{struct.unpack_from("<I", leaf_bytes, 2)[0]:x}]; '
                      f'limit cmp eax,0x{self.new.u32(g + 18):x} in the owner callback')
        self.add(item('lua_calls.boundary', 'identity', feature, 'feature', 'unchanged' if ok else 'review',
                      strategy='owner callback calls the leaf', new_rva=leaf, evidence=ev,
                      reason='' if ok else 'owner callback does not call the interrupt leaf'))
        m = re.search(r'leaf-0x([0-9A-Fa-f]+) owner-callback=0x([0-9A-Fa-f]+)', self.src.text('renovice/injection.cpp'))
        if m:
            self.add(item('lua_calls.log-label', 'label', feature, 'cosmetic', 'unchanged',
                          evidence=[f'the `luaCalls before observer` log line prints the fixed text leaf 0x{m.group(1)} / '
                                    f'owner-callback 0x{m.group(2)} (U43 values); resolution is by signature, so the '
                                    'text has no run-time effect']))

    def openwf_frame(self):
        prof = self.src.text('renovice/application_frame_profile.hpp')
        legacy = ' '.join(cpp_string(prof, 'legacy_pattern').split()).upper()
        current = ' '.join(cpp_string(prof, 'current_u43_pattern').split()).upper()
        lc = len(self.new.scan(legacy, limit=4))
        _, cur = self._sig('renovice/application_frame_profile', current)
        ok = lc == 0 and cur is not None
        self.add(item('openwf_frame.profile', 'identity', 'OpenWF frame tick: hotkeys F9/F10, safe runtime tick, Pluto UI',
                      'feature', 'unchanged' if ok else 'review', strategy='select_unique_profile', new_rva=cur,
                      evidence=[f'legacy matches={lc}, current_u43 resolved={cur is not None}'],
                      reason='' if ok else 'frame profile is not uniquely current_u43'))

    # -- seed and native names -----------------------------------------------------------------------------------------------
    def seed(self):
        def derive(img):
            seeds = sorted({img.u32(h + 1) for h in img.scan(NAME_HASH_FUNCTION, limit=4)})
            return seeds[0] if len(seeds) == 1 else None
        ref_seed, new_seed = derive(self.ref), derive(self.new)
        table = self.src.seed_for(self.facts['game_version_n'])
        ok = new_seed is not None and new_seed == table
        self.facts['seed'] = new_seed
        self.add(item('native.name_hash_seed', 'seed', 'DE name hashes: every native name, the Lua toolchain, recipes',
                      'process', 'unchanged' if ok else 'review', old=ref_seed and f'0x{ref_seed:08x}',
                      new=new_seed and f'0x{new_seed:08x}',
                      evidence=[f'name-hash function seed {new_seed and hex(new_seed)}; wf_fnv_2_initial.json for '
                                f'{self.facts["game_version"]}: {table and hex(table)}'],
                      reason='' if ok else 'the name-hash seed changed: every DE name hash, the toolchain seed and '
                      'OpenWF/vv/wf_fnv_2_initial.json need a reviewed update (a new major version)'))

    def native_names(self):
        names = sorted(set(re.findall(r'wf_hash\("([A-Za-z0-9_]+)"\)', self.src.text('renovice/injection.cpp'))))
        seed = self.facts.get('seed') or self.src.seed_for(self.facts['game_version_n']) or 0
        for n in names:
            pat = ' '.join(f'{x:02X}' for x in struct.pack('<I', name_hash(n, seed))) + ' 00 00 00 00'
            rc, nc = len(self.ref.scan(pat, limit=64)), len(self.new.scan(pat, limit=64))
            if rc == 0:
                self.add(item(f'native.name.{n}', 'native-name', NATIVE_FEATURES.get(n, 'RENOVICE native binding'),
                              'feature', 'inactive', evidence=[f'not a static method-table name (0 rows on the reference)']))
                continue
            st = 'review' if nc == 0 else 'unchanged'
            self.add(item(f'native.name.{n}', 'native-name', NATIVE_FEATURES.get(n, 'RENOVICE native binding'),
                          'feature', st, old=rc, new=nc,
                          evidence=[f'{nc} method-table row(s), reference {rc}' +
                                    ('' if nc == rc else ' (resolved by name hash at run time; count change noted)')],
                          reason='' if st != 'review' else 'binding name no longer in any method table'))

    # -- per-build tables ---------------------------------------------------------------------------------------------------
    def engine_damage(self):
        feature = 'ENGINE_DAMAGE observer (battle log, Mallet Overguard/health/shield numbers)'
        latest = self.src.engine_damage[-1]
        registered = next((b for b in self.src.engine_damage if self.new.sha256 in b['digests']), None)
        text = self.src.text('renovice/engine_damage.cpp')
        block = text[text.index('constexpr std::array<const char*, 3> patterns{'):]
        pats = re.findall(r'"([0-9A-F? ]+)"', block[:block.index('};')])
        handlers = [self._sig('renovice/engine_damage', p)[1] for p in pats]
        if None in handlers or len(handlers) != 3:
            self.tables['engine_damage'] = {'status': 'review'}
            self.add(item('table.engine_damage', 'table', feature, 'feature', 'review',
                          reason='a handler signature is not unique on the new image; no registration (ENGINE_DAMAGE '
                          'installs nothing)'))
            return
        reg, ev, fail = ed_derive(self.new, handlers, self.facts.get('seed') or latest.get('seed', 0x768E5ED0))
        if reg is None:
            self.tables['engine_damage'] = {'status': 'review', 'failures': fail}
            self.add(item('table.engine_damage', 'table', feature, 'feature', 'review', evidence=ev + fail,
                          reason='registration could not be derived uniquely; none is added (ENGINE_DAMAGE installs '
                          'nothing on this build)'))
            return
        changes = ed_compare(registered or latest, reg)
        if registered:
            st = 'unchanged' if not changes else 'review'
            self.tables['engine_damage'] = {'status': st, 'registered_as': registered['label']}
            self.add(item('table.engine_damage', 'table', feature, 'feature', st, evidence=ev + changes,
                          reason='' if st == 'unchanged' else 'existing registration differs from the derived values'))
            return
        self.tables['engine_damage'] = {'status': 'auto', 'registration': reg, 'changes': changes}
        self.add(item('table.engine_damage', 'table', feature, 'feature', 'auto', edit='table',
                      strategy='re-derived from code', evidence=ev + [f'vs {latest["label"]}: ' + ('; '.join(changes) or
                                                                                                   'identical values')]))

    def engine_params(self):
        feature = 'Missions: engine-parameter overrides (Railjack kill goals, Interception, Spy, Sabotage, Exterminate)'
        registered = next((b for b in self.src.engine_params if self.new.sha256 in b['digests']), None)
        prev = next((b for b in reversed(self.src.engine_params) if self.ref.sha256 in b['digests']), None)
        if prev is None:
            self.tables['engine_params'] = {'status': 'review'}
            self.add(item('table.engine_params', 'table', feature, 'feature', 'review',
                          reason='the reference image has no ENGINE_PARAM registration to relocate from'))
            return
        reg, ev, fail, ranges = ep_relocate(self.ref, self.new, prev, self.rel)
        for r in ranges:
            st = 'review' if r['status'] not in ('exact', 'masked', 'masked+callee', 'table') else (
                'unchanged' if r['new_rva'] == r['rva'] else 'auto')
            self.add(item(f'engine_params.range.0x{r["rva"]:x}', 'byte-range', feature, 'feature', st,
                          strategy=r['status'], ref_rva=r['rva'], new_rva=r['new_rva'],
                          evidence=r['evidence'][-2:] + r['diffs'][:4], reason=r['reason'] if st == 'review' else ''))
        if reg is None:
            self.tables['engine_params'] = {'status': 'review', 'failures': fail}
            self.add(item('table.engine_params', 'table', feature, 'feature', 'review', evidence=ev + fail,
                          reason='registration not relocated; none is added (ENGINE_PARAM_OVERRIDE installs nothing; '
                          'the addon entry lane keeps the values)'))
            return
        if registered:
            same = registered['push_value_rva'] == reg['push_value_rva'] and \
                [(c['rva'], c['hex']) for c in registered['checks']] == [(c['rva'], c['hex']) for c in reg['checks']]
            st = 'unchanged' if same else 'review'
            self.tables['engine_params'] = {'status': st, 'registered_as': registered['label']}
            self.add(item('table.engine_params', 'table', feature, 'feature', st, evidence=ev,
                          reason='' if same else 'existing registration differs from the relocated ranges'))
            return
        self.tables['engine_params'] = {'status': 'auto', 'registration': reg, 'from': prev['label']}
        self.add(item('table.engine_params', 'table', feature, 'feature', 'auto', edit='table',
                      strategy='relocated by identity', evidence=ev + [
                          f'push_value 0x{prev["push_value_rva"]:x} -> 0x{reg["push_value_rva"]:x}; 8 ranges re-read '
                          'from the new image; layout carried over from ' + prev['label']]))

    # -- undump, WTS, verifier pins ------------------------------------------------------------------------------------------
    def undump(self):
        raw = self.new.scan_file(UNDUMP)
        mapped = self.new.scan(UNDUMP, limit=3)
        ok = len(raw) == 1 and len(mapped) == 1
        self.facts['undump'] = {'raw': raw[0], 'rva': mapped[0]} if ok else None
        self.add(item('verifier.undump', 'verifier-row', 'Offline client certification (verify_client_44 undump row)',
                      'verifier', 'unchanged' if ok else 'review', new_rva=mapped[0] if mapped else None,
                      evidence=[f'file matches={len(raw)} image matches={len(mapped)}' +
                                (f' raw=0x{raw[0]:x} rva=0x{mapped[0]:x}' if ok else '')],
                      reason='' if ok else 'undump prologue not unique: no certified verifier row'))

    def wts(self):
        def wts_imports(img):
            return sorted({fn for name, entries in img.imports().items() if name.lower() == 'wtsapi32.dll'
                           for fn, _ in entries if fn})
        new_i, ref_i = wts_imports(self.new), wts_imports(self.ref)
        missing = [n for n in new_i if n not in ref_i]
        self.add(item('process.wts_proxy', 'imports', 'Bootstrapper load (the game loads the WTSAPI32 proxy DLL)',
                      'process', 'unchanged' if not missing else 'review',
                      evidence=[f'{len(new_i)} WTSAPI32 imports; reference {len(ref_i)}'] +
                               ([f'new imports: {", ".join(missing)}'] if missing else []),
                      reason='' if not missing else 'the client imports WTSAPI32 functions the proxy may not export'))

    def profile_dir(self):
        hits = self.new.scan(PROFILE_DIR, limit=3)
        value = self.new.u32(hits[0] + 0x27) if len(hits) == 1 else None
        ok = value == PROFILE_DIR_PIN
        self.add(item('verifier.profile_dir_pin', 'verifier-row', 'Offline client certification (profile-dir pin)',
                      'verifier', 'unchanged' if ok else 'review',
                      evidence=[f'matches={len(hits)} displacement={value and hex(value)} (verify_client_44.cpp pins '
                                f'0x{PROFILE_DIR_PIN:x}; the runtime reads it from code)'],
                      reason='' if ok else 'verify_client_44.cpp profile-dir pin differs (runtime unaffected)'))
