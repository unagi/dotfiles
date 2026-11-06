#!/usr/bin/env python3
"""Measure explicitly declared reading paths; never execute chezmoi/templates."""
import argparse
from collections import Counter
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
INCLUDE = re.compile(r'{{\s*include "([^"]+)"\s*}}')
METRICS = ('total_chars', 'unique_chars', 'duplicate_chars', 'file_reads', 'unique_files')


def read(root, name):
    path = (root / name).resolve()
    if Path(name).is_absolute() or not path.is_relative_to(root.resolve()):
        raise ValueError('Path outside repository: ' + name)
    return path.read_text(encoding='utf-8')  # universal newlines: CRLF -> LF


def body(name, text):
    if name.endswith('.toml.tmpl'):
        # Deliberately support only the repository's literal multiline field.
        # Fail closed on escapes/new syntax rather than approximate TOML decoding.
        matches = list(re.finditer(r'^developer_instructions = """\n(.*?)^"""\s*$', text, re.M | re.S))
        if len(matches) != 1 or '\\' in matches[0][1] or '"""' in matches[0][1]:
            raise ValueError('Unsupported developer_instructions syntax: ' + name)
        return matches[0][1]
    if text.startswith('---\n'):
        parts = text.split('\n---\n', 1)
        if len(parts) != 2:
            raise ValueError('Unclosed frontmatter: ' + name)
        return parts[1]
    return text


def measure(root, case):
    chunks = {}
    counts = Counter()
    files = []

    def expand(name, stack=()):
        if name in stack:
            raise ValueError('Include cycle: ' + ' -> '.join(stack + (name,)))
        text = body(name, read(root, name))
        files.append(name)
        pos = 0
        for index, match in enumerate(INCLUDE.finditer(text)):
            add(name, index, text[pos:match.start()])
            expand(match[1], stack + (name,))
            pos = match.end()
        add(name, -1, text[pos:])

    def add(name, index, text):
        if '{{' in text or '}}' in text:
            raise ValueError('Unsupported template expression: ' + name)
        if text:
            key = (name, index)
            chunks[key] = text
            counts[key] += 1

    if not case.get('conditions') or not case.get('reads'):
        raise ValueError('Case needs conditions and reads: ' + case['id'])
    for entry in case['reads']:
        if not entry.get('reason'):
            raise ValueError('Read needs reason: ' + case['id'])
        expand(entry['path'])
    total = sum(len(text) * counts[key] for key, text in chunks.items())
    unique = sum(map(len, chunks.values()))
    return dict(id=case['id'], conditions=case['conditions'], reads=case['reads'],
                total_chars=total, unique_chars=unique, duplicate_chars=total-unique,
                file_reads=len(files), unique_files=len(set(files)),
                files=[dict(path=p, occurrences=n) for p, n in sorted(Counter(files).items())])


def report(root, config):
    if config['schema_version'] != 1:
        raise ValueError('Unsupported cases schema')
    ids = [c['id'] for c in config['cases']]
    if len(ids) != len(set(ids)):
        raise ValueError('Duplicate case id')
    return dict(schema_version=1, measurement_version=1,
                cases=[measure(root, c) for c in config['cases']])


def markdown(current, baseline):
    old = {c['id']: c for c in baseline['cases']} if baseline else {}
    lines = ['| Case | Total | Unique | Duplicate | Reads / files | Δ total | Definition |',
             '| --- | ---: | ---: | ---: | ---: | ---: | --- |']
    for c in current['cases']:
        b = old.pop(c['id'], None)
        same = b and c['conditions'] == b['conditions'] and c['reads'] == b['reads']
        delta = str(c['total_chars']-b['total_chars']) if b else 'NEW'
        lines.append('| {} | {} | {} | {} | {} / {} | {} | {} |'.format(
            c['id'], c['total_chars'], c['unique_chars'], c['duplicate_chars'],
            c['file_reads'], c['unique_files'], delta, 'same' if same else 'NEW/CHANGED'))
    for name in old:
        lines.append('| '+name+' | — | — | — | — | REMOVED | removed |')
    lines += ['', 'Definition changes require review; deltas alone do not prove improvement.']
    for c in current['cases']:
        lines += ['', '<details><summary>'+c['id']+' — inputs</summary>', '', c['conditions'], '']
        lines += ['- '+e['path']+': '+e['reason'] for e in c['reads']]
        lines += ['', 'Expanded files:']
        lines += ['- '+f['path']+' × '+str(f['occurrences']) for f in c['files']]
        lines += ['', '</details>']
    return '\n'.join(lines)+'\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--format', choices=['markdown', 'json'], default='markdown')
    parser.add_argument('--baseline', default='docs/instruction-reading-baseline.json')
    parser.add_argument('--write-baseline', action='store_true', help='Explicitly replace baseline after review')
    args = parser.parse_args()
    try:
        config = json.loads(read(ROOT, 'docs/instruction-reading-cases.json'))
        current = report(ROOT, config)
        if args.write_baseline:
            # Fixed repository-owned output: no arbitrary filesystem writes.
            (ROOT / 'docs/instruction-reading-baseline.json').write_text(
                json.dumps(current, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
            print('Saved docs/instruction-reading-baseline.json')
            return
        baseline = json.loads(read(ROOT, args.baseline))
        if (baseline['schema_version'], baseline['measurement_version']) != (1, 1):
            raise ValueError('Incompatible baseline')
        if args.format == 'json':
            old = {c['id']: c for c in baseline['cases']}
            for c in current['cases']:
                b = old.get(c['id'])
                c['delta'] = {m: c[m]-b[m] for m in METRICS} if b else None
                c['definition_changed'] = not b or any(c[k] != b[k] for k in ('reads','conditions'))
            current['removed_cases'] = sorted(set(old)-{c['id'] for c in current['cases']})
            print(json.dumps(current, ensure_ascii=False, indent=2))
        else:
            print(markdown(current, baseline), end='')
    except (OSError, ValueError, KeyError, TypeError) as error:
        print('Measurement failed: '+str(error), file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
