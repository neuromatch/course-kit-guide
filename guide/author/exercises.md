---
title: "Exercises, solutions and explanations"
---

# Exercises, solutions and explanations

For: author

An exercise is an ordinary code cell that raises `NotImplementedError` until the student fills it in. You write the answers once, in two directives: `{nma-solution}` for the code that solves an exercise, and `{nma-explanation}` for the answer to a discussion question or an interactive demo. The build produces four versions of the page.

| Where | What readers see |
|---|---|
| Website | A *Click for solution* / *Click for explanation* link. The answer is not shown on the page. |
| Student notebook (Colab/Kaggle) | The same link, in its own markdown cell. The `.ipynb` holds no answers. |
| Instructor notebook | The solution as a code cell (starting `# Solution`) and the explanation as markdown. |
| Instructor site (optional) | The solution and explanation inline, in collapsed boxes ([Instructor site](../maintainer/instructor-site.md)). |

## You write

The exercise is a normal `{code-cell}` with **no tags**, so students can see and edit it. The `{nma-solution}` goes directly after it, with only blank lines in between; its body is a single ```` ```python ```` fence and its outer fence needs more colons than the inner backticks:

```{include} ../examples/directives/exercise.md
:literal: true
:lang: text
:start-after: % region-start: exercise
:end-before: % region-end: exercise
```

An `{nma-explanation}` stands on its own and takes ordinary Markdown, math included:

```{include} ../examples/directives/exercise.md
:literal: true
:lang: text
:start-after: % region-start: explanation
:end-before: % region-end: explanation
```

## You get

The live version is the [Exercise example](../examples/directives/exercise.md). The links on the site point to files that CI writes next to the notebooks on the notebooks branch:

```text
notebooks/<root>/<folder>/<page>.ipynb                      student notebook
notebooks/<root>/<folder>/instructor/<page>.ipynb           instructor notebook
notebooks/<root>/<folder>/solutions/<page>_Solution_<n>.py
notebooks/<root>/<folder>/solutions/<page>_Explanation_<n>.md
```

`<root>` is the name of the content folder (see [`nma:` settings](../reference/nma-config.md#nma-content)) and `n` counts each directive type separately, from the top of the page.

### "Run all" on the website

Normally "Run all" would stop at the first unfinished exercise, so nothing below it would run. To prevent that, the published site adds a hidden setup cell to every page that has exercises. While a cell still has an uncommented `raise NotImplementedError` line, the setup cell runs the matching reference solution instead and prints a note saying so. Once the student deletes or comments out that line, their own code runs.

Try it on the [Exercise example](../examples/directives/exercise.md): start the kernel and run the exercise without changing it.

- The setup cell is added at build time (`nma-kit prepare-site` in CI), so a local `myst start` preview doesn't have it.
- The solutions are hidden, not secret: the setup cell and the page source are both downloadable from the site.
- Colab and Kaggle notebooks don't get the fallback. There the exercise raises, as in Neuromatch notebooks.

## Rules

- A code cell with an uncommented `raise NotImplementedError` line is an exercise. Every exercise needs an `{nma-solution}` directly after it, and every solution needs an exercise directly before it.
- No `# to_remove solution` or `# to_remove explanation` marker may be left in a code cell (the old convention).
- A solution body is a single ```` ```python ```` fence; an explanation is not empty.
- Neither directive is nested inside another directive, takes an argument or options, or is left unclosed.
- A page with exercises needs a `kernelspec` ([Page types](page-types.md)).
- `check` reports each violation with the file and line ([Rules enforced by `check`](../reference/check-rules.md#rules-exercises)).

## Next

- [Videos and slides](videos-and-slides.md)
- [Instructor notes](instructor-notes.md)
- Reference: [`{nma-solution}`](../reference/directives.md#nma-solution) and [`{nma-explanation}`](../reference/directives.md#nma-explanation)
