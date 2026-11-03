# Neuromatch Course Kit Guide

The manual and showcase for building a course with [MyST](https://mystmd.org)
(JupyterBook 2) and the [Neuromatch course kit](https://github.com/neuromatch/course-kit).

**Live book:** https://neuromatch.github.io/course-kit-guide/

## Read the guide

The book is organised by who you are:

| You… | Start here |
|---|---|
| Write or convert tutorials | [Quick start for authors](https://neuromatch.github.io/course-kit-guide/guide/author/quick-start) |
| Create and run a course repository | [Create a course](https://neuromatch.github.io/course-kit-guide/guide/maintainer/create-a-course) |
| Teach with a course | [What instructors get](https://neuromatch.github.io/course-kit-guide/guide/instructor/what-you-get) |
| Look something up | [Reference](https://neuromatch.github.io/course-kit-guide/guide/reference/) |

**Don't fork or copy this repository** to start a course: a course never merges back
into it. Generate a fresh repository with `nma-kit init` (see "Create a course" above).
Changes to the kit itself belong in the
[kit repository](https://github.com/neuromatch/course-kit).

## What is in this repository

Everything is under `guide/` (one content folder, `nma.content: [guide]` in `myst.yml`):

| Folder | What it holds |
|---|---|
| `guide/start/`, `guide/author/` | Orientation; how-to pages for authors |
| `guide/maintainer/`, `guide/instructor/` | Setup and operation pages; the instructor view |
| `guide/reference/` | Directives, frontmatter, settings, commands, rules, limits |
| `guide/examples/` | Working pages to copy: directive examples, a real tutorial as a normal and a scrolly page, a Colab page, project booklet examples |

## Working on this repository

Requires **Node.js >= 20** (`nvm use`) and Python 3.10+.

```bash
uv venv
uv pip install -r requirements.txt neuromatch-course-kit
uv run nma-kit check
uv run nma-kit sync-assets      # branding files (_nma/), re-run after kit upgrades
uv run myst start               # http://localhost:3000
```

For scrollytelling pages, run `uv run nma-kit render-scrolly` first so their
panels show real outputs. Pushes to `main` publish the site; pull requests are
checked and, with the Cloudflare settings in place, previewed.

`docs/superpowers/verify.sh` runs every gate on a scratch copy (check, notebooks,
scrolly rendering, site build, stale-name and link checks).

Agents and contributors: see `AGENTS.md` for the authoring conventions.
