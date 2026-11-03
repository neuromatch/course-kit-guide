---
title: "Notebooks, branches and badges"
kernelspec:
  name: python3
  display_name: Python 3
---

# Notebooks, branches and badges

For: maintainer

Colab and Kaggle can only open `.ipynb` files from raw GitHub URLs, not Markdown. So CI generates a notebook from every executable `.md` page and publishes it on a separate branch, and adds Colab and Kaggle badges that open it. The Markdown files are the only source: never edit a generated notebook, and never write badge HTML yourself. This page has a `kernelspec`, so it is an example: look for the badges at the top of it and of its notebook.

## You write

Nothing, beyond marking a page as executable in its frontmatter and keeping `project.github` right in `myst.yml`:

```yaml
---
kernelspec:
  name: python3
  display_name: Python 3
---
```

```yaml
project:
  github: https://github.com/<org>/<repo>
```

The badge URLs are derived from `project.github`, so they follow whichever repository the course lives in. No repository paths are hardcoded. To check the conversion yourself, from the course root:

```bash
uv run nma-kit notebooks --dry-run   # check that every page converts
uv run nma-kit notebooks             # write the notebooks to notebooks/
```

## You get

**Where notebooks live.** CI pushes them to `notebooks-branch` (or the branch in `nma.notebooks.branch`), under `notebooks/<root>/<folder>/`, where `<root>` is the name of the page's content folder ([`nma:` settings](../reference/nma-config.md#nma-content)). They are never committed to `main`.

| File | Purpose |
|---|---|
| `notebooks/<root>/<folder>/<page>.ipynb` | Student notebook, with badges |
| `notebooks/<root>/<folder>/instructor/<page>.ipynb` | Instructor notebook, solutions inline |
| `notebooks/<root>/<folder>/solutions/` | Solution and explanation files the "Click for solution" links open |
| `notebooks/<root>/<folder>/data/`, `.../slides/` | Copied `{nma-data}` files and `{nma-slides}` PDFs |

**How badges are added**, in two places and never committed:

1. In the generated notebooks, `nma-kit notebooks` scans the content folders for `.md` files with a `kernelspec`, converts each with `jupytext --from md:myst --to notebook`, and inserts a markdown cell at position 0 with the Colab and Kaggle badge HTML.
2. On the rendered site, CI runs `nma-kit prepare-site` right before `myst build`, which adds the badge HTML to the top of each executable page in CI's temporary checkout only. That is why a local `myst start` preview shows no badges.

**The badge URLs:**

```text
https://colab.research.google.com/github/<org>/<repo>/blob/notebooks-branch/notebooks/<path>.ipynb
https://kaggle.com/kernels/welcome?src=https://raw.githubusercontent.com/<org>/<repo>/notebooks-branch/notebooks/<path>.ipynb
```

The first cell of every generated notebook contains the two badges as HTML `<a>` links around the Colab and Kaggle images.

## Rules

- Only pages with a `kernelspec` get a notebook. Static pages (intros, further reading) are skipped.
- A page with `{code-cell}` blocks and no `kernelspec` fails `check`, so it never silently loses its notebook ([Rules enforced by `check`](../reference/check-rules.md#rules-kernelspec)).
- Never add badge HTML to a `.md` file. `check` rejects a page that starts with it (generated output was committed).
- The repository, and so the notebooks branch, must be public.
- Pull request previews publish notebooks to `notebooks-pr-<number>` instead ([Pull request previews](pr-previews.md)).

## Next

- [Publish with CI](publish-with-ci.md)
- [Instructor site](instructor-site.md)
- Reference: [`nma-kit notebooks`](../reference/cli.md#cmd-notebooks)
