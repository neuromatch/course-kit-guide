#!/usr/bin/env bash
# Green gate for the guide restructure. Runs the kit steps and the stale-name grep
# on a scratch copy of the repo, so the working tree is never touched.
#   SKIP_STALE=1  skip the stale-name grep (until the last rewrite tasks)
set -uo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
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

if [ -z "${SKIP_STALE:-}" ]; then
  say "stale names"
  cd "$ROOT"
  targets=$(ls -d guide README.md AGENTS.md myst.yml tutorials projects 2>/dev/null)
  allow=docs/superpowers/verify-allow.txt
  hits=$(grep -rnE 'W[0-9]D[0-9]|tutorials/|Tutorial [0-9]|Day [0-9]|Week [0-9]' $targets --include=*.md --include=myst.yml \
    | grep -v '^guide/examples/' || true)
  if [ -s "$allow" ] && [ -n "$hits" ]; then
    hits=$(printf '%s\n' "$hits" | grep -vFf <(sed 's/:/ /;s/ .*//' "$allow") || true)
  fi
  if [ -n "$hits" ]; then printf '%s\n' "$hits" | head -40; echo "FAILED: stale names"; fail=1; fi
fi

say "result"; [ $fail -eq 0 ] && echo GREEN || echo RED
exit $fail
