---
title: "Upgrade the kit"
---

# Upgrade the kit

For: maintainer

Your course depends on the kit in three places, and all three must follow the same release line. Compatible fixes arrive on their own; a new minor version can change the rules, so you move to it on purpose.

## You write

Change all three together:

| Where | Setting |
|---|---|
| `myst.yml` | `extend: https://cdn.jsdelivr.net/npm/@neuromatch/course-kit@0.4/dist/nma.yml` (the MyST plugin and assets) |
| `.github/workflows/course.yml` | `@v0.4` on each `uses:` line (the CI workflows, which also install the matching `nma-kit`) |
| Your computer | `uv pip install --upgrade neuromatch-course-kit` (the local `nma-kit`) |

Then run `uv run nma-kit sync-assets` (the branding changes between versions) and `uv run nma-kit check`.

`@v0.4` and `@0.4` mean "the newest 0.4.x", so compatible fixes arrive on your next build. To freeze a finished course, pin an exact version (for example `@v0.4.0`). On CI, `prepare-site` pins the `extend:` URL in `myst.yml` to the exact version of the workflow's kit release, so the plugin, assets and CLI come from one release.

## You get

- The kit's newest 0.4.x on every build, with no change in your repository.
- A failing `nma-kit check` that names exactly what to change when a minor version tightens a rule.

### From 0.4.0 to 0.4.1

0.4.1 changes nothing you have to do: it adds the optional [scheduled notebook runs](scheduled-runs.md). To use them, upgrade the local package, then copy the kit's `nightly.yml` to `.github/workflows/nightly.yml` (it is not part of `nma-kit init`) and commit it to the default branch. Courses on `@v0.4` already run 0.4.1 on CI.

### From 0.3 to 0.4

0.4.0 has one breaking change: `nma.paths.tutorials` and `nma.paths.projects` are no longer read, and `nma.content` is required.

1. Add `nma.content` to `myst.yml` with the folders that hold your pages: `content: [tutorials, projects]` for a course with the default folders ([`nma:` settings](../reference/nma-config.md#nma-content)).
2. Remove `nma.paths`. If you renamed a folder with it, declare it as `{name: tutorials, path: <your folder>}` to keep the notebook URLs `notebooks/tutorials/...`.
3. Bump `extend:` and `@v0.4` and the local package together.
4. Run `uv run nma-kit check`. The legacy `nma.paths` is reported with the exact replacement.

Notebook paths are `notebooks/<name>/<folder>/<page>.ipynb`, where `<name>` is the content folder's name.

## Rules

- The kit is still in development: a new minor version can change the rules. Change all three places in one commit.
- Never upgrade only one place: the plugin, the workflows and the CLI must come from the same release line.
- To force the newest version locally, upgrade the package explicitly: CI pins its own. Local previews also cache the downloaded plugin for 30 days: run `uv run myst clean --cache` after a bump.
- Other refs: `@v0` follows the newest 0.x including breaking changes, and the workflows' `kit-version: latest` input forces the newest release on CI. Both can break your build without a change in your repository.

## Next

- [Publish with CI](publish-with-ci.md)
- Reference: [`nma-kit` commands](../reference/cli.md) and [`nma:` settings](../reference/nma-config.md)
