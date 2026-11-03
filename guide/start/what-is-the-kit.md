---
title: "What is the course kit?"
---

# What is the course kit?

For: everyone

The Neuromatch course kit turns Markdown pages into a course: a website where students edit and run code in their browser, Colab and Kaggle notebooks, solution and feedback links, and an instructor site. You write one set of Markdown files and the kit builds everything else. This book is built with the kit, so each page is also a working example.

## You write

All course content is MyST Markdown (`.md`). Jupyter notebooks (`.ipynb`) are still produced for Colab and Kaggle, but CI generates them: they are never written or edited by hand, and never committed to `main`.

````text
guide/author/exercises.md     <- you edit this
````

## You get

```text
a page (.md)
   │
   ├── myst build ──────────────►  the website
   │                                 editable, runnable code cells
   │                                 videos, slides, feedback widgets
   │                                 Colab and Kaggle badges
   │
   ├── nma-kit notebooks (CI) ──►  notebooks-branch:
   │                                 student notebook (opened by the badges)
   │                                 instructor/ and solutions/
   │
   └── NMA_AUDIENCE=instructor ─►  the instructor site
                                     solutions inline, teaching notes
```

Every page that has a `kernelspec` in its frontmatter goes down all paths. Pages without one are static site pages. Students get:

- the website, with code they can edit and run in the browser (no install),
- Colab and Kaggle notebooks, for anything the browser can't run,
- links to solutions and explanations, video and slide embeds, and feedback widgets.

Instructors get the same pages with solutions inline and teaching notes ([What instructors get](../instructor/what-you-get.md)).

### Why Markdown instead of notebooks?

- **Clean git history.** No output blobs or cell metadata in diffs.
- **Easy review.** Collaborators read plain text, not JSON.
- **One source of truth.** The website and the notebooks can't drift apart, because both come from the same `.md` file.
- **Executable anyway.** Cells run in the reader's browser (JupyterLite), and in notebooks on Colab, Kaggle or locally.

## Rules

- Never commit `.ipynb` files to a content folder. `nma-kit check` rejects them.
- Never write badge HTML, video players, solution cells or feedback cells by hand: the kit's directives generate them ([Directives](../reference/directives.md)).
- `nma-kit check` runs in CI and fails the build on any violation. The full list is in [Rules enforced by `check`](../reference/check-rules.md).
- The tooling (MyST plugin, `nma-kit` CLI, CI workflows) is the published kit, [neuromatch/course-kit](https://github.com/neuromatch/course-kit). This book holds content and documentation only; fixes to kit behaviour belong in the kit repository.

## Next

- [Which path are you?](which-path.md)
- [Convert an existing notebook](../author/convert-a-notebook.md)
