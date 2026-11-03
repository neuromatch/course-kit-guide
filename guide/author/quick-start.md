---
title: "Quick start"
---

# Quick start

For: author

Change a page, open a pull request, and read the result on the preview the build creates for you. You need write access to the course repository and nothing installed on your computer.

```{note}
The preview link needs pull request previews, which the course maintainer turns on once (Cloudflare Pages, same-repository pull requests only). If your pull request gets no preview comment, ask your maintainer to enable them: see [Pull request previews](../maintainer/pr-previews.md). Without previews you still get the check result (tier 2 below).
```

## You write

Every page is a Markdown file in the course's content folder (for this book, `guide/`). To try the loop, change one sentence:

1. On GitHub, open a page file and choose **Edit** (the pencil), or edit it in a clone.
2. Change a sentence. Don't touch the frontmatter between the two `---` lines.
3. Commit to a new branch and open a pull request.

From a clone, the same steps are:

```bash
git checkout -b fix-intro
# edit guide/author/some-page.md
git commit -am "docs: clarify the intro"
git push -u origin fix-intro
gh pr create --fill
```

## You get

Three tiers, from least to most setup. Start with the first.

**1. The pull request preview (realistic, no setup).** Within a few minutes the pull request gets one comment with a link such as `https://pr-12.<project>.pages.dev`. It is built exactly like the live site: Colab and Kaggle badges, the run-all fallback for exercises, generated notebooks (on a `notebooks-pr-12` branch), and scrolly outputs. The comment updates on every push. Closing the pull request deletes the preview.

**2. `nma-kit check` (fast, optional).** The check is pure Python, no Node needed. It catches most mistakes before you push:

```bash
uv venv && uv pip install neuromatch-course-kit
uv run nma-kit check
```

CI runs the same command on every pull request. If it fails, see [Fix a failing check](fix-a-failing-check.md).

**3. A local preview (fastest edit loop, optional).** This needs Node.js 20 or newer (`nvm use` reads the repository's `.nvmrc`) and the course's requirements:

```bash
uv pip install -r requirements.txt neuromatch-course-kit
uv run nma-kit sync-assets    # the branding, once and after kit upgrades
uv run nma-kit render-scrolly # only if you edit scrolly pages
uv run myst start             # http://localhost:3000
```

A local preview is not the whole picture. It does not show:

| Missing locally | Why |
|---|---|
| Colab and Kaggle badges | CI adds them at build time (`prepare-site`) |
| The run-all fallback cell for exercises | Same |
| The generated notebooks | `nma-kit notebooks` output is never part of `myst start` |
| Scrolly outputs | They show "Run to see output" until you run `render-scrolly` |

Always confirm a finished change on the pull request preview.

## Rules

- The pull request must pass the `check` job before it is merged.
- Never commit generated files: badges, `.ipynb` files, `_nma/`, `notebooks/` or `_build/`.
- Don't create pages outside the content folders listed in `nma.content` ([`nma:` settings](../reference/nma-config.md)). The kit ignores them.

## Next

- [Write pages](write-pages.md)
- [Add a page](add-a-page.md)
- [Fix a failing check](fix-a-failing-check.md)
- Reference: [`nma-kit` commands](../reference/cli.md)
