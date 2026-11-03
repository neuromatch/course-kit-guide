---
title: "Page types"
feedback_prefix: W1D1_T4
---

# Page types

Every page in this book starts with a block of YAML between two `---` lines, called the **frontmatter**. A few keys in it decide what kind of page you get: static or executable, editable in the browser or Colab-only, ordinary or scrollytelling. This page is the reference for all of them.

## The short version

| I want… | Frontmatter | Notebook generated? | Code on the page |
|---|---|---|---|
| A text page (intro, further reading) | `title` only | no | none, or static |
| A normal tutorial | `title` + `kernelspec` | yes | editable, runs in the browser |
| A tutorial that is too heavy for the browser | `title` + `kernelspec` + `runtime: colab` | yes | read-only, with a banner linking to Colab and Kaggle |
| A scrollytelling tutorial | `title` + `kernelspec` + `layout: scrolly` (+ `site.hide_outline`) | yes | live panels pinned beside the text |

## Keys

Each key is described in the [frontmatter reference](../reference/frontmatter.md): `title`, `kernelspec`, `runtime`, `layout` (with `site`) and `feedback_prefix`.

## A complete example

```yaml
---
title: "Tutorial 3: Training a CNN"
runtime: colab
feedback_prefix: W3D2_T3
kernelspec:
  name: python3
  display_name: Python 3
---
```

## Related, but not frontmatter

Per-cell options go on the code cell, not in the frontmatter. For example `:tags: [hide-input]` collapses the code, `remove-input` shows only the output and `remove-cell` hides the cell entirely. A cell with an unfinished `raise NotImplementedError` is an exercise and must be followed by an `{nma-solution}`. See [Day 2, Tutorial 1](run-code-in-browser.md) and [Tutorial 3](../start/what-is-the-kit.md).
