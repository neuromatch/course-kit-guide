---
title: "Page types"
---

# Page types

For: author

The frontmatter, a YAML block between two `---` lines at the top of a page, decides what kind of page you get: static or executable, editable in the browser or Colab-only, ordinary or scrollytelling. Pick the type first, then write the page. Each key is described in [Frontmatter keys](../reference/frontmatter.md).

## You write

A text page (an intro, further reading) has only a title:

````text
---
title: "A text page"
---
````

A normal tutorial adds `kernelspec`:

````text
---
title: "A tutorial"
kernelspec:
  name: python3
  display_name: Python 3
---
````

A tutorial too heavy for the browser adds `runtime: colab`:

````text
---
title: "Training a CNN"
runtime: colab
kernelspec:
  name: python3
  display_name: Python 3
---
````

A scrollytelling tutorial adds `layout: scrolly`, and hides the outline column to give the story its width:

````text
---
title: "A story"
layout: scrolly
site:
  hide_outline: true
kernelspec:
  name: python3
  display_name: Python 3
---
````

## You get

| I want… | Frontmatter | Notebook generated? | Code on the page |
|---|---|---|---|
| A text page | `title` only | no | none, or static |
| A normal tutorial | `title` + `kernelspec` | yes | editable, runs in the browser |
| A tutorial too heavy for the browser | `title` + `kernelspec` + `runtime: colab` | yes | read-only, with a banner linking to Colab and Kaggle |
| A scrollytelling tutorial | `title` + `kernelspec` + `layout: scrolly` (+ `site.hide_outline`) | yes | live panels pinned beside the text |

Live examples: [Run code in the browser](run-code-in-browser.md) (a normal tutorial), [A heavy-compute page (Colab)](../examples/colab/heavy-compute.md), and [Scrollytelling pages](scrolly.md), which is itself a scrolly page.

## Rules

- A page with a `{code-cell}` must have `kernelspec`; without it the page gets no notebook, badges or editable cells.
- `runtime: colab` can't be combined with `layout: scrolly`.
- A page that uses `{include}` to show example source should be static: an executable page's generated notebook would show the raw `{include}` block as text.
- MyST prints `extra key ignored` for `runtime`, `layout` and `feedback_prefix`. That is expected: the kit reads them.
- Options for a single cell (`hide-input`, `remove-cell`) go on the cell, not in the frontmatter ([Write pages](write-pages.md)).

## Next

- [Frontmatter keys](../reference/frontmatter.md)
- [Add a page](add-a-page.md)
- [Run code in the browser](run-code-in-browser.md)
