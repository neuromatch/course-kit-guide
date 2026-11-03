#!/usr/bin/env bash
# Green gate for the guide restructure. Runs the kit steps and the stale-name grep
# on a scratch copy of the repo, so the working tree is never touched.
#   SKIP_STALE=1       skip the stale-name grep (until the last rewrite tasks)
#   STALE_SKIP_DOCS=1  leave README.md and AGENTS.md out of the stale-name grep
set -uo pipefail
export ROOT=$(cd "$(dirname "$0")/../.." && pwd)
W=/tmp/verify
KIT_VERSION=$("$ROOT/.venv/bin/nma-kit" --version | awk '{print $2}')
fail=0
say() { printf '\n== %s\n' "$*"; }

rm -rf "$W" && mkdir -p "$W"
(cd "$ROOT" && tar cf - --exclude=.git --exclude=.venv --exclude=notebooks --exclude=_build \
  --exclude=.superpowers --exclude=_wheels .) | tar xf - -C "$W"
cd "$W"
NK="$ROOT/.venv/bin/nma-kit"

# jsDelivr is blocked in some sandboxes: use the kit's files from npm instead.
if ! curl -s -m 8 -o /dev/null -w '%{http_code}' https://cdn.jsdelivr.net/npm/@neuromatch/course-kit@"$KIT_VERSION"/dist/nma.yml | grep -q '^200$'; then
  K=/tmp/kit-$KIT_VERSION
  if [ ! -f "$K/package/dist/nma.yml" ]; then
    mkdir -p "$K" && (cd "$K" && npm pack @neuromatch/course-kit@"$KIT_VERSION" >/dev/null && tar xzf ./*.tgz)
    sed -i "s#https://cdn.jsdelivr.net/npm/@neuromatch/course-kit@$KIT_VERSION/dist/nma.mjs#$K/package/dist/nma.mjs#" "$K/package/dist/nma.yml"
  fi
  sed -i "s#^extend:.*#extend: $K/package/dist/nma.yml#" myst.yml
fi

step() { local n=$1; say "$n"; shift; "$@" || { echo "FAILED: $n"; fail=1; }; }
step "nma-kit check" $NK check
step "nma-kit notebooks" $NK notebooks
step "nma-kit render-scrolly" $NK render-scrolly
step "nma-kit prepare-site" $NK prepare-site
say "myst build"
npx --yes mystmd build --html > build.log 2>&1 || { echo "FAILED: myst build"; fail=1; }
if grep '⛔' build.log | grep -v 'Could not find DOI' | grep -v 'Unsupported image extension' | grep -v 'Error saving image'; then
  echo "FAILED: build errors above"; fail=1
fi

# Every page under guide/ must be in project.toc, and every toc entry must exist.
say "toc coverage"
"$ROOT/.venv/bin/python" - <<'PY' || fail=1
import pathlib, sys, yaml
toc = yaml.safe_load(open("myst.yml"))["project"]["toc"]
listed = set()
def walk(nodes):
    for n in nodes:
        listed.add(n["file"]); walk(n.get("children", []))
walk(toc)
files = {str(p) for p in pathlib.Path("guide").rglob("*.md")}
for label, items in (("not in project.toc", sorted(files - listed)), ("in project.toc but missing", sorted(listed - files))):
    for i in items:
        print(f"{i}: {label}")
sys.exit(1 if (files ^ listed) else 0)
PY

# Links with a #fragment must point at an id that exists in the built page.
say "anchors"
python3 - <<'PY' || fail=1
import re, sys, pathlib
html = pathlib.Path("_build/html")
bad, cache = [], {}
def ids(page):
    rel = page.with_suffix("")
    p = html / (rel.parent if rel.name == "index" else rel) / "index.html"
    return set(re.findall(r'id="([^"]+)"', p.read_text())) if p.exists() else None
for f in sorted(pathlib.Path("guide").rglob("*.md")):
    text = re.sub(r"^(````*|~~~+).*?^\1\s*$", "", f.read_text(), flags=re.S | re.M)
    for m in re.finditer(r"\]\(([^)\s#]+\.md)#([^)\s]+)\)", text):
        tgt = (f.parent / m.group(1)).resolve().relative_to(pathlib.Path(".").resolve())
        cache.setdefault(tgt, ids(tgt))
        if cache[tgt] is None or m.group(2) not in cache[tgt]:
            bad.append(f"{f}: {m.group(1)}#{m.group(2)}")
print("\n".join(bad))
sys.exit(1 if bad else 0)
PY

if [ -z "${SKIP_STALE:-}" ]; then
  say "stale names"
  cd "$ROOT"
  if [ -n "${STALE_SKIP_DOCS:-}" ]; then
    targets=$(ls -d guide myst.yml 2>/dev/null)
  else
    targets=$(ls -d guide README.md AGENTS.md myst.yml tutorials projects 2>/dev/null)
  fi
  allow=docs/superpowers/verify-allow.txt
  hits=$(grep -rnE 'W[0-9]D[0-9]|tutorials/|Tutorial [0-9]|Day [0-9]|Week [0-9]' $targets --include=*.md --include=myst.yml \
    | grep -v '^guide/examples/' || true)
  if [ -n "$hits" ] && [ -s "$allow" ]; then
    hits=$(printf '%s\n' "$hits" | python3 -c "
import sys
allow = [l.rstrip('\n').split('|', 1) for l in open('$allow') if '|' in l and not l.startswith('#')]
for line in sys.stdin:
    path, _, text = line.partition(':')
    if any(path == a and b in line for a, b in allow):
        continue
    sys.stdout.write(line)
")
  fi
  if [ -n "$hits" ]; then printf '%s\n' "$hits" | head -40; echo "FAILED: stale names"; fail=1; fi

  say "relative links"
  python3 - <<'PY' || fail=1
import os, re, sys, pathlib
bad = []
for f in pathlib.Path("guide").rglob("*.md"):
    text = f.read_text()
    text = re.sub(r"^(````*|~~~+).*?^\1\s*$", "", text, flags=re.S | re.M)  # skip fenced examples
    for m in re.finditer(r"\]\(([^)\s#]+\.md)(#[^)\s]*)?\)", text):
        tgt = m.group(1)
        if re.match(r"[a-z]+:", tgt):
            continue
        if not (f.parent / tgt).resolve().exists():
            bad.append(f"{f}: {tgt}")
print("\n".join(bad))
sys.exit(1 if bad else 0)
PY
fi

# Region markers used by {include} blocks must exist exactly once in the target file.
say "region markers"
python3 - <<'PY' || fail=1
import re, sys, pathlib
root = pathlib.Path(__import__("os").environ["ROOT"])
bad = []
block = re.compile(r"```\{include\}\s+(\S+)\n((?::[a-z-]+:.*\n)+)")
for f in sorted((root / "guide").rglob("*.md")):
    for m in block.finditer(f.read_text()):
        target = (f.parent / m.group(1)).resolve()
        opts = dict(re.findall(r":([a-z-]+):\s*(.*)", m.group(2)))
        for key in ("start-after", "end-before"):
            if key not in opts:
                continue
            marker = opts[key].strip()
            if not target.exists():
                bad.append(f"{f.relative_to(root)}: include target {m.group(1)} does not exist")
                break
            n = len(re.findall(r"^" + re.escape(marker) + r"\s*$", target.read_text(), flags=re.M))
            if n != 1:
                bad.append(f"{f.relative_to(root)}: marker {marker!r} occurs {n} times in {m.group(1)}")
print("\n".join(bad))
sys.exit(1 if bad else 0)
PY

say "result"; [ $fail -eq 0 ] && echo GREEN || echo RED
exit $fail
