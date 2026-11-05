---
title: "`nma-kit` commands"
---

# `nma-kit` commands

For: author and maintainer (lookup)

`nma-kit` is the course kit's command line (PyPI: `neuromatch-course-kit`). Run it from the course root, the folder with `myst.yml`. Exit codes: 0 ok, 1 content problems, 2 usage or configuration errors.

| Command | Who runs it | What it does |
|---|---|---|
| [`check`](#cmd-check) | Authors, CI | Validate content and `myst.yml` |
| [`notebooks`](#cmd-notebooks) | Maintainers, CI | Generate student and instructor notebooks and solution files |
| [`render-scrolly`](#cmd-render-scrolly) | Authors, CI | Run scrolly pages and save their outputs |
| [`run-notebooks`](#cmd-run-notebooks) | Maintainers, CI | Run the generated instructor notebooks and report which broke |
| [`sync-assets`](#cmd-sync-assets) | Authors, maintainers | Write the site branding to `_nma/` |
| [`init`](#cmd-init) | Maintainers, once | Write a starter course |
| [`prepare-site`](#cmd-prepare-site) | **CI only** | Prepare the `.md` pages for `myst build` |
| [`publish-notebooks`](#cmd-publish-notebooks) | **CI only** | Push `notebooks/` to the notebooks branch |
| [`finalize-site`](#cmd-finalize-site) | **CI only** | Fix `robots.txt` and the sitemap of the built site |

(cmd-check)=
## `check`

```bash
uv run nma-kit check
```

Validates the content rules and `myst.yml` (see [Rules enforced by `check`](check-rules.md)): page rules, the `nma:` block, `.ipynb` files in content folders, and the `nma.style.extra` file. Writes nothing. `notebooks` and `prepare-site` run the same checks first.

(cmd-notebooks)=
## `notebooks`

```bash
uv run nma-kit notebooks [--dry-run]
```

For every page with a `kernelspec`, writes `notebooks/<root>/<folder>/<page>.ipynb` (student, with badges), `notebooks/<root>/<folder>/instructor/<page>.ipynb` and `.../solutions/*`, plus copied data, image and slide files. Never modifies `.md` files. `notebooks/` is git-ignored. `--dry-run` only prints what it would write.

(cmd-render-scrolly)=
## `render-scrolly`

```bash
uv run nma-kit render-scrolly
```

Runs each scrolly page's instructor notebook (exercise cells removed, `# @param` at defaults) and writes `_build/scrolly/<root>/<folder>/<page>.json` (`<root>` is the name of the content folder) with each cell's output. A cell that raises fails the command with `file:line`. Run it before `myst start` so scrolly panels show real outputs.

(cmd-run-notebooks)=
## `run-notebooks`

```bash
uv run nma-kit notebooks
uv run nma-kit run-notebooks [--runtime browser|colab] [--notebook PATH] [--timeout SECONDS] [--report FILE.json]
```

Runs the instructor notebooks that `notebooks` generated (solutions filled in) and prints one state per notebook: `passed`, `failed`, `timeout` or `needs-check` (a `runtime: colab` page that failed or timed out, to be confirmed in Colab with a GPU). `--runtime` limits the run to pages with that runtime, `--notebook` runs a single file, `--timeout` is the budget for one whole notebook (default 1200 seconds) and `--report` also writes the results as JSON. Exits 1 if a notebook failed or timed out, and 0 otherwise. `--list` and `--targets` are used by the scheduled workflow to split the notebooks into parallel jobs. It runs the notebooks in your own Python; the nightly CI job runs them in Colab's image. See [Scheduled notebook runs](../maintainer/scheduled-runs.md). Needs kit 0.4.1 or newer.

(cmd-sync-assets)=
## `sync-assets`

```bash
uv run nma-kit sync-assets
```

Writes the kit's stylesheet, logos and favicon to `_nma/` (self-ignoring, never committed). Run it once for local previews and after kit upgrades. CI runs it for you.

(cmd-init)=
## `init`

```bash
uv run nma-kit init --title "My Course" --author "Your Name" \
    --github https://github.com/<org>/<repo> [--license MIT] [--preview] [dir]
```

Writes a starter course into `dir` (default: the current folder) and asks for anything you leave out. `--license` is one of `BSD-3-Clause` (default), `MIT`, `Apache-2.0`, `CC-BY-4.0`. `--preview` turns on the pull request preview job (needs Cloudflare Pages). It never overwrites existing files. See [Create a course](../maintainer/create-a-course.md).

(cmd-prepare-site)=
## `prepare-site`

```bash
uv run nma-kit prepare-site [--dry-run] [--kit-version X.Y.Z]
```

**CI only.** Edits the `.md` pages in place right before `myst build`: adds badges and the run-all fallback cell, runs `sync-assets`, and pins the `extend:` URL in `myst.yml` to `--kit-version` (default: the CLI's own version). If you run it locally, revert with `git checkout -- <content folders> myst.yml`.

(cmd-publish-notebooks)=
## `publish-notebooks`

```bash
uv run nma-kit publish-notebooks [--remote origin] [--message "..."]
```

**CI only.** Makes the notebooks branch contain exactly `notebooks/`, creating the branch if it is missing. Does nothing if nothing changed.

(cmd-finalize-site)=
## `finalize-site`

```bash
uv run nma-kit finalize-site [--dir _build/html]
```

**CI only.** After `myst build`: writes `robots.txt`, removes the sitemap, and adds `noindex` for the instructor site.
