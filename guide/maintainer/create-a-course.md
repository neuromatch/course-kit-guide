---
title: "Create a course"
---

# Create a course

For: maintainer

A course starts from a fresh repository that the kit's `init` command fills in. Don't fork or copy this guide's repository: your course will never merge back into it, and the two would diverge. `init` writes a minimal starter with its own history, and the CI logic, the MyST plugin and the `nma-kit` CLI all come from the kit, so your course gets fixes through version numbers rather than copied files.

## You write

You need a GitHub account (with Pages enabled), [uv](https://docs.astral.sh/uv/), Node.js 20 or newer, and Python 3.10 or newer. Create an empty **public** repository on GitHub (Colab and Kaggle read the notebooks from it), clone it, and from its root run:

```bash
uv venv && uv pip install neuromatch-course-kit
uv run nma-kit init --title "My Course" --author "Your Name" \
    --github https://github.com/<org>/<repo>
```

Leave out the flags and `init` asks for them. It also takes `--license` (`BSD-3-Clause`, `MIT`, `Apache-2.0` or `CC-BY-4.0`) and `--preview`, which turns on the pull request preview job ([Pull request previews](pr-previews.md)). `init` never overwrites existing files. Set the licence to match your institution's requirements; this guide's own content is CC-BY-4.0 and its code BSD-3-Clause.

## You get

| File | Purpose |
|---|---|
| `myst.yml` | Title, authors, GitHub URL, table of contents, branding. The kit is loaded with `extend:`, and `nma.content` lists the folders that hold your pages |
| `.github/workflows/course.yml` | Calls the kit's reusable workflows: checks on pull requests, publishing on `main`, and optional PR previews and instructor site |
| `tutorials/` | An intro page and one example day with a video, an exercise and a solution |
| `projects/` | A stub for the project booklet |
| `requirements.txt` | The packages your pages import |
| `README.md` | A setup checklist for GitHub Pages and the first push |
| `LICENSE`, `.gitignore`, `.nvmrc` | Licence of your choice, ignores for generated folders, Node version for MyST |

The feedback settings (`nma.feedback`) are commented out. Feedback widgets post to a datatops project, so ask its owner for your **own** project and key. Don't copy the values from this guide's `myst.yml`.

## Rules

- The first push to `main` needs **Settings → Pages → Source: GitHub Actions** ([Publish with CI](publish-with-ci.md)).
- Work through the checklist in the generated `README.md`.
- Read the example day, replace it with your own, and update `project.toc` ([Structure and scale](structure-and-scale.md)).
- Preview locally with `uv run nma-kit sync-assets && uv run myst start`, then push to `main`. Authors usually work through pull requests ([Quick start](../author/quick-start.md)).
- Optional: turn on [pull request previews](pr-previews.md) and the [instructor site](instructor-site.md), both of which need Cloudflare Pages.

### Getting kit updates

Your course depends on the kit in three places, and all three follow the same release line:

- `extend:` in `myst.yml` (the MyST plugin),
- `@v0.4` in `.github/workflows/course.yml` (the CI workflows, which also install the matching `nma-kit`),
- the `neuromatch-course-kit` package you use locally.

`@v0.4` and `@0.4` mean "the newest 0.4.x", so compatible fixes arrive on your next build. Pin an exact version (for example `@v0.4.0`) to freeze a finished course. The kit is still in development, so a new minor version can change the rules: change all three places together and run `nma-kit check`.

## Next

- [Publish with CI](publish-with-ci.md)
- [Pull request previews](pr-previews.md)
- [Branding and customising](branding.md)
- Reference: [`nma-kit` commands](../reference/cli.md) and [`nma:` settings](../reference/nma-config.md)
