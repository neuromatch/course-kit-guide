---
title: "`nma:` settings"
---

# `nma:` settings

For: maintainer (lookup)

The kit reads one top-level block of `myst.yml`, `nma:`. MyST itself logs `extra key ignored: nma`, which is expected. Use `section: {key: value}` mappings with string values; `nma-kit check` rejects numbers, lists (except `content`) and deeper nesting.

```yaml
nma:
  content:
    - guide
  assets:
    data: data
    image: images
    slides: slides
  notebooks:
    branch: notebooks-branch
  feedback:
    url: https://example.org/api
    project: my_course
    user_key: abc123
  scrolly:
    pyodide_url: https://cdn.jsdelivr.net/pyodide/v314.0.7/full/
  brand:
    primary: "#D9480F"
  style:
    extra: _static/extra.css
```

| Key | Required | Default | What it does |
|---|---|---|---|
| [`content`](#nma-content) | **yes** | none | The folders whose pages the kit processes |
| `assets.data`, `assets.image`, `assets.slides` | no | `data`, `images`, `slides` | Folder names, inside a page's folder, for `{nma-data}` files, images and `{nma-slides}` PDFs |
| `notebooks.branch` | no | `notebooks-branch` | Branch the generated notebooks are published to. The environment variable `NMA_NOTEBOOKS_BRANCH` overrides it (PR previews set it) |
| `feedback.url`, `.project`, `.user_key` | if any page uses `{nma-feedback}` | none | Where feedback widgets post (a datatops project). `user_key` is write-only and published in every notebook, so it is not a secret. Use your own project, never another course's |
| `scrolly.pyodide_url` | no | the kit's pinned Pyodide | Pyodide build that scrolly pages load; the host must send CORS headers |
| `brand.primary`, `.primary_hover`, `.primary_light`, `.secondary`, `.accent` | no | the kit's colours | `#RRGGBB` overrides. `primary_hover` and `primary_light` default to darker and lighter versions of `primary` |
| `style.extra` | no | none | A CSS file that `nma-kit sync-assets` appends after the kit's stylesheet |

The audience (student or instructor site) is not a `myst.yml` key: set the environment variable `NMA_AUDIENCE=instructor` for the instructor build.

(nma-content)=
## `content`

`content` is required since kit 0.4.0 and has no default. Each entry is a folder inside the course, or a `{name, path}` pair:

```yaml
nma:
  content:
    - tutorials                         # name = path
    - {name: guide, path: docs/guide}   # name: first folder under notebooks/
```

- A page is processed only if it lives under one of these folders. A page outside every folder gets no checks and no notebook.
- Folders cannot overlap or nest, must be relative to the course root with no `.` or `..`, and cannot be under `notebooks`, `_build`, `_nma` or `node_modules`.
- The **name** is the first folder under `notebooks/` on the notebooks branch: `docs/guide/week1/intro.md` becomes `notebooks/guide/week1/intro.ipynb`.
- Names use letters, digits, `-`, `_` and `/`, and must be unique.

For how to organise several folders, see [Structure and scale](../maintainer/structure-and-scale.md).
