---
title: "Publish with CI"
---

# Publish with CI

For: maintainer

The build tooling (the MyST plugin, the `nma-kit` command and the GitHub Actions workflows) lives in the **Neuromatch course kit**, a separately versioned project published as `@neuromatch/course-kit` on npm and `neuromatch-course-kit` on PyPI. Your course calls the kit's reusable workflows instead of carrying its own copy, and picks up kit fixes on its next build. `nma-kit init` writes one workflow, `.github/workflows/course.yml`. This guide's own copy is below, so the page always shows what actually runs.

## You write

```{literalinclude} ../../.github/workflows/course.yml
:language: yaml
```

The `@v0.4` is the only version knob in the workflow: the newest 0.4.x (compatible updates), or an exact tag such as `@v0.4.0` to freeze a finished course. Move to a new minor version on purpose ([Upgrade the kit](upgrade-the-kit.md)).

In the repository, go to **Settings → Pages**, set **Source** to `GitHub Actions`, and push any change to `main` to trigger the first build. The book goes live at `https://<your-org>.github.io/<your-repo>/`. To use a custom domain, set it under **Settings → Pages → Custom domain**; with the GitHub Actions source no `CNAME` file is needed.

## You get

**On a pull request**, the workflow checks your changes without publishing anything:

1. `nma-kit check` validates the content rules ([Rules enforced by `check`](../reference/check-rules.md)).
2. `nma-kit notebooks --dry-run` checks that every executable page converts.
3. `nma-kit render-scrolly` runs every scrollytelling page headless. A cell that raises fails the check.
4. `nma-kit prepare-site` and `myst build --html` build the whole site, so a broken page fails the check too.

If previews are on, a `preview` job also builds the pull request and deploys it ([Pull request previews](pr-previews.md)).

**On a push to `main`**, the same steps run for real, in order, each one only if the previous one passed:

1. `nma-kit check`.
2. `nma-kit notebooks` converts each executable `.md` page to `.ipynb`, adds a Colab/Kaggle badge cell, turns `{nma-video}`, `{nma-slides}` and `{nma-feedback}` into notebook cells, and splits `{nma-solution}` and `{nma-explanation}` into a student notebook (links) and an instructor notebook (answers inline), plus the solution files. `{nma-instructor}` notes are dropped, and `{nma-data}` files and `{nma-slides}` PDFs are copied next to the notebooks.
3. `nma-kit publish-notebooks` pushes `notebooks/` to the separate `notebooks-branch`. The branch is created the first time, so a new course works on its first push.
4. `nma-kit render-scrolly` pre-renders the scrollytelling pages, so readers see real figures before they start Python.
5. `nma-kit prepare-site` adds Colab/Kaggle badges to the executable pages and, on pages with exercises, a hidden setup cell so "Run all" doesn't stop at an unfinished exercise. This happens only in CI's temporary checkout.
6. `myst build --html` builds the book, then `nma-kit finalize-site` fixes its `robots.txt` and sitemap, and the next job deploys it to GitHub Pages.
7. Optionally, the same course is built a second time as the [instructor site](instructor-site.md) and deployed to Cloudflare Pages.

Generated notebooks are never committed to `main`, which keeps `main` free of generated files and avoids CI commit loops. Videos, slides, solution links and feedback widgets need no extra step: the kit's MyST plugin renders them during `myst build`.

## Rules

- One publish runs at a time, and each step runs only if the previous one passed.
- Pull requests never publish anything to the live site.
- The notebooks branch must be public (Colab and Kaggle read raw GitHub URLs).
- To run the same steps locally:

```bash
uv venv && uv pip install -r requirements.txt neuromatch-course-kit
uv run nma-kit check
uv run nma-kit sync-assets   # branding files, written to _nma/
uv run nma-kit notebooks --dry-run
uv run myst start
```

`prepare-site` edits `.md` files in place and is meant for CI only; if you run it locally, revert with `git checkout -- <your content folders> myst.yml`.

## Next

- [Pull request previews](pr-previews.md)
- [Scheduled notebook runs](scheduled-runs.md)
- [Notebooks, branches and badges](notebooks-and-badges.md)
- [Instructor site](instructor-site.md)
- Reference: [`nma-kit` commands](../reference/cli.md)
