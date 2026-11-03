---
title: "Write pages"
---

# Write pages

For: author

A page is a Markdown file in MyST, which extends standard Markdown with directives (blocks such as `{note}`) and roles (inline markup). Prose, admonitions and tables are plain text you write once; code cells run in the reader's browser. This page shows each form as source next to its result.

## You write

Everything standard Markdown supports works: **bold**, *italic*, `inline code`, [links](https://mystmd.org), lists and tables. Admonitions call out notes, tips and warnings:

```{include} ../examples/directives/markdown-basics.md
:literal: true
:lang: text
:start-after: % region-start: admonition
:end-before: % region-end: admonition
```

A table is a pipe table:

```{include} ../examples/directives/markdown-basics.md
:literal: true
:lang: text
:start-after: % region-start: table
:end-before: % region-end: table
```

Executable code is a `{code-cell}`, and tags decide what the reader sees. A plain cell shows editor and output:

```{include} ../examples/directives/code-cells.md
:literal: true
:lang: text
:start-after: % region-start: code-cell
:end-before: % region-end: code-cell
```

`hide-input` puts the code behind "Show code"; `remove-cell` hides the cell entirely:

```{include} ../examples/directives/code-cells.md
:literal: true
:lang: text
:start-after: % region-start: hide-input
:end-before: % region-end: hide-input
```

```{include} ../examples/directives/code-cells.md
:literal: true
:lang: text
:start-after: % region-start: remove-cell
:end-before: % region-end: remove-cell
```

## You get

The same regions, rendered (source: [Markdown basics](../examples/directives/markdown-basics.md)):

```{include} ../examples/directives/markdown-basics.md
:start-after: % region-start: admonition
:end-before: % region-end: admonition
```

```{include} ../examples/directives/markdown-basics.md
:start-after: % region-start: table
:end-before: % region-end: table
```

The code cells are live on the [Code cells example](../examples/directives/code-cells.md): edit one and press **▶ Run**. To learn how running works, see [Run code in the browser](run-code-in-browser.md).

## Rules

- A page with a `{code-cell}` needs `kernelspec` in its frontmatter ([Frontmatter keys](../reference/frontmatter.md#kernelspec)).
- Tags: no tag shows editor and output; `hide-input` or `hide-cell` puts the code behind "Show code"; `remove-input` shows only the output; `remove-cell` removes the panel but still runs the cell as an earlier cell.
- Exercise cells (an unfinished `raise NotImplementedError`) must have **no** tags, and need a solution ([Exercises, solutions and explanations](exercises.md)).
- Edits to a cell live in the reader's browser only. Reset restores the original.

## Next

- [Figures, math and cross-references](figures-math-xrefs.md)
- [Add a page](add-a-page.md)
- Reference: [Rules enforced by `check`](../reference/check-rules.md)
