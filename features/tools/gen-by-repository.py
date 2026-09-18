#!/usr/bin/env python3
"""Generate BY-REPOSITORY.md from the `# Source:` headers of the .feature files.

The feature files are the single source of truth. This index is derived from
them, so it cannot drift: re-run it after changing any specification.

    python3 features/tools/gen-by-repository.py
"""
import re, os, glob, collections, datetime

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PROSE = ('Other half', 'See ', 'NOTE', 'Related', 'Decision', 'Migration',
         'This file', 'http', '---', 'Why it is done')

def parse(path):
    """Yield (repo, [what /e/OS does there]) from the header comment block.

    Only the indented lines under a `# Source: <repo>` header are kept, and
    prose blocks (NOTE, See, rationale) are skipped along with their
    continuation lines."""
    repo, items, skipping = None, [], False
    for line in open(path):
        if not line.startswith('#'):
            if repo: yield repo, items
            return
        m = re.match(r'#\s*Source:\s*(\S+)(.*)', line)
        if m:
            if repo: yield repo, items
            repo, items, skipping = m.group(1).rstrip(','), [], False
            rest = m.group(2).strip()
            # a trailing path fragment ("overlay", "core/res") is context, not an item
            if len(rest) > 14 and not rest.startswith('('):
                items.append(rest)
        elif line.startswith('#   ') and repo:
            s = line[1:].strip()
            if not s:
                skipping = False
                continue
            if s.startswith(PROSE):
                skipping = True
                continue
            if not skipping:
                items.append(s)
        else:
            # a top-level comment line ends any prose block
            s = line[1:].strip()
            skipping = bool(s) and s.startswith(PROSE)
    if repo: yield repo, items

def main():
    repos = collections.defaultdict(list)
    for p in sorted(glob.glob(os.path.join(BASE, '**', '*.feature'), recursive=True)):
        rel = os.path.relpath(p, BASE)
        title = ''
        for l in open(p):
            if l.startswith('Feature:'): title = l[len('Feature:'):].strip(); break
        for repo, items in parse(p):
            repos[repo].append((rel, title, items))

    out = ["# What /e/OS adds or modifies, by repository", "",
           "Derived from the `# Source:` headers of the `.feature` files — **do not edit**.",
           "Regenerate with `python3 features/tools/gen-by-repository.py` after changing a",
           "specification.", "",
           "The specifications are organised by feature, because that is how the product is",
           "decided and how the backlog is planned. This index is the other way in: for a",
           "given repository, what /e/OS does there and which specification says so.", "",
           f"{len(repos)} repositories, generated {datetime.date.today().isoformat()}.", "",
           "## Index", ""]
    for repo in sorted(repos):
        anchor = repo.replace('/', '').replace('.', '').replace('_', '-').lower()
        out.append(f"- [`{repo}`](#{anchor}) — {len(repos[repo])} feature(s)")
    out.append("")
    for repo in sorted(repos):
        out.append(f"## `{repo}`")
        out.append("")
        for rel, title, items in sorted(repos[repo]):
            out.append(f"**{title}** — [`{rel}`]({rel})")
            out.append("")
            for it in items:
                out.append(f"- {it}")
            if items: out.append("")
        out.append("")
    open(os.path.join(BASE, 'BY-REPOSITORY.md'), 'w').write('\n'.join(out).rstrip('\n') + '\n')
    print(f"BY-REPOSITORY.md: {len(repos)} repositories")

if __name__ == '__main__':
    main()
