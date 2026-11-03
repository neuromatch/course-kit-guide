---
title: "Frontmatter keys"
---

# Frontmatter keys

For: author (lookup)

Every page starts with a block of YAML between two `---` lines. These are the keys the course kit reads. For which combination to choose, see [Page types](../author/page-types.md).

| Key | Values | Read by | Effect |
|---|---|---|---|
| [`title`](#title) | string | MyST | Page title. Always set it. |
| [`kernelspec`](#kernelspec) | `name: python3`, `display_name: Python 3` | MyST, course kit | Makes the page executable: editable cells, generated notebooks, badges. Required if the page has a `{code-cell}`. |
| [`runtime`](#runtime) | `browser` (default), `colab` | course kit | `colab` = read-only code plus a Colab/Kaggle banner, no fallback cell. Not with `layout: scrolly`. |
| [`layout`](#layout) | `scrolly` | course kit | Scrollytelling page. Pair with `site: {hide_outline: true}`. |
| [`feedback_prefix`](#feedback-prefix) | string | course kit | Overrides the prefix of `{nma-feedback}` ids. |

(title)=
## `title`

The page title in the sidebar, the browser tab and the notebook.

```yaml
title: "Add a page"
```

(kernelspec)=
## `kernelspec`

Declare it on every page that has a `{code-cell}`. `check` rejects a page with code and no `kernelspec`.

```yaml
kernelspec:
  name: python3
  display_name: Python 3
```

A page **with** `kernelspec`:

- gets editable, runnable code cells on the site (unless `runtime: colab`),
- is converted to student and instructor notebooks on `notebooks-branch`,
- gets Colab and Kaggle badges at build time (never write them yourself).

A page **without** it is static: nothing is run, converted or badged.

(runtime)=
## `runtime`

Where the page's code runs. The default is `browser`, so you normally leave the key out.

```yaml
runtime: colab
```

- `browser`: each cell is an editor with a **▶ Run** button, running Python in the reader's browser (Pyodide). Good for numpy, scipy, matplotlib, pandas and small demos.
- `colab`: the code is shown read-only and a banner, *Do this tutorial in Colab*, links to the generated notebook on Colab and Kaggle. Use it for PyTorch, GPUs, big datasets or long training runs.

Any other value is an error, and `runtime: colab` can't be combined with `layout: scrolly`. See [A heavy-compute page (Colab)](../examples/colab/heavy-compute.md).

(layout)=
## `layout`

`layout: scrolly` turns the page into a story of **steps**: a card of text on one side, a pinned stage with figures and live code on the other.

```yaml
layout: scrolly
site:
  hide_outline: true
```

`site.hide_outline` gives the story the width of the "On this page" column. Don't use `hide_toc`: readers could no longer leave the page. The `{step}` and `{stage}` markers are covered in [Scrollytelling pages](../author/scrolly.md).

(feedback-prefix)=
## `feedback_prefix`

The section id sent by a `{nma-feedback}` widget is `<prefix>_<name>`. The prefix is derived from the file name (`W<week>D<day>_Tutorial1` becomes `W<week>D<day>_T1`; any other name is used as is). Set the key when a page is renamed or converted from a notebook whose ids must not change:

```yaml
feedback_prefix: Old_Notebook_T1
```

It may use only letters, digits and underscores.

## A complete example

```yaml
---
title: "Training a CNN"
runtime: colab
feedback_prefix: Old_Notebook_T3
kernelspec:
  name: python3
  display_name: Python 3
---
```

## Warnings you can ignore

MyST only knows its own keys, so it logs `extra key ignored: <key>` for `runtime`, `layout` and `feedback_prefix`. Nothing is wrong. The same goes for the `nma:` block in `myst.yml`.

## What `check` validates

`nma-kit check` (run by CI) validates frontmatter and fails with the file name and line:

- `runtime` is `browser` or `colab`.
- `runtime: colab` and `layout: scrolly` are not combined.
- A page with a `{code-cell}` has `kernelspec`.
- A `layout: scrolly` page has at least one `{step}`.
- `feedback_prefix` uses only letters, digits and underscores.

See [Rules enforced by `check`](check-rules.md).

## Per-cell options are not frontmatter

Options for one code cell go on the cell. For example `:tags: [hide-input]` collapses the code, `remove-input` shows only the output and `remove-cell` hides the cell entirely. See [Write pages](../author/write-pages.md).
