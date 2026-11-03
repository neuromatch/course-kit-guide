---
title: "Convert an existing notebook"
---

# Convert an existing notebook

For: author

Content is Markdown, never `.ipynb`. When you receive a notebook, from an older course or a collaborator, convert it once, tidy the result, commit only the `.md`, and delete the original. `nma-kit check` rejects any `.ipynb` in a content folder.

## You write

Convert, then work through the mapping and checklist below:

```bash
uv run jupytext --to md:myst path/to/Notebook.ipynb -o guide/<folder>/tutorial1.md
```

How each notebook cell becomes MyST:

| Notebook cell | MyST |
|---|---|
| Markdown cell | Raw Markdown |
| Code cell | ```` ```{code-cell} python ```` |
| Badge cell (position 0) | Omit: CI adds badges |
| `cellView: "form"` / `# @title` | `:tags: [hide-input]` |
| `# to_remove solution` | `{nma-solution}` directly after the exercise cell (drop the marker line) |
| `# to_remove explanation` | `{nma-explanation}` (turn the docstring into Markdown) |
| `raise NotImplementedError` (exercise) | No tags: students must see and edit it |
| `# @markdown` / `@widgets.interact` | `:tags: [hide-input]` |
| `# @title Submit your feedback` (`content_review(f"{feedback_prefix}_X")`) | `{nma-feedback} X` |
| `# @title Import feedback gadget` | Omit: it is generated. Copy its `feedback_prefix` into the frontmatter if it differs from the file name's default |
| Video cell (`# @title Video …`, `video_ids = [...]`) | `{nma-video}` (copy the ids) |
| Slides cell (`# @title Tutorial slides`, `link_id = …`) | `{nma-slides}` with `:osf:` set to the `link_id` |

Replace all notebook metadata with clean frontmatter:

````text
---
title: "Linear dynamical systems"
kernelspec:
  name: python3
  display_name: Python 3
---
````

Checklist:

1. Strip the badge cell at position 0.
2. Add the frontmatter above.
3. Add a Pyodide setup cell if needed (`micropip` installs, see [Browser limits and packages](../reference/browser-limits.md)).
4. Convert every code cell to a `{code-cell}` with the right tags.
5. Replace video and slides cells with `{nma-video}` and `{nma-slides}`, and feedback cells with `{nma-feedback}`. Drop the gadget cell and set `feedback_prefix` if needed.
6. Replace `# to_remove` cells with `{nma-solution}` and `{nma-explanation}`.
7. Make the math KaTeX-compatible: `\begin{aligned}` in `$$` instead of `eqnarray`, `bmatrix` instead of `array`.
8. Keep prose, math, `<details>` blocks and HTML as they are.
9. List the page in `project.toc` ([Add a page](add-a-page.md)).
10. Run `uv run nma-kit check`, then open the pull request preview.

For a scrollytelling version, follow the converting checklist in [Scrollytelling pages](scrolly.md).

## You get

[Linear dynamical systems (normal page)](../examples/lds/normal-page.md) is a real Neuromatch Academy notebook converted this way. Its videos, exercises, solutions, interactive widgets and feedback widgets all became directives, and it keeps the original feedback ids through `feedback_prefix`. [Linear dynamical systems (scrolly page)](../examples/lds/scrolly-page.md) is the same tutorial as a scrolly page.

## Rules

- Commit only the `.md`. `check` rejects `.ipynb` files under a content folder.
- Keep the old feedback ids: set `feedback_prefix` to the notebook's prefix when it differs from the one derived from the file name ([Frontmatter keys](../reference/frontmatter.md#feedback-prefix)).
- Replace each video cell with a `{nma-video}` copying the ids from `video_ids = [...]`; each slides cell with `{nma-slides}` using its `link_id` as `:osf:`; each "Submit your feedback" cell with `{nma-feedback}` using the part of `content_review(f"{feedback_prefix}_…")` after the underscore. `check` rejects any leftover `content_review` or `vibecheck` code.
- Don't convert a heavy tutorial to run in the browser: give it `runtime: colab` ([Page types](page-types.md)).

## Next

- [Exercises, solutions and explanations](exercises.md)
- [Videos and slides](videos-and-slides.md)
- Reference: [Rules enforced by `check`](../reference/check-rules.md)
