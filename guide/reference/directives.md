---
title: "Directives"
---

# Directives

For: author (lookup)

The course kit adds nine directives to MyST. Use them instead of writing the equivalent code cells by hand. Every directive goes at the **top level** of the page (not inside another directive, a list or a tab), except where noted. `nma-kit check` reports a violation as `<file>: line N: ...`, see [Rules enforced by `check`](check-rules.md).

| Directive | Purpose | Feature page |
|---|---|---|
| [`{nma-video}`](#nma-video) | Embed a lecture video | [Videos and slides](../author/videos-and-slides.md) |
| [`{nma-slides}`](#nma-slides) | Embed slides from OSF or a PDF in the repo | [Videos and slides](../author/videos-and-slides.md) |
| [`{nma-solution}`](#nma-solution) | The reference solution of an exercise | [Exercises](../author/exercises.md) |
| [`{nma-explanation}`](#nma-explanation) | A written answer to a discussion question | [Exercises](../author/exercises.md) |
| [`{nma-feedback}`](#nma-feedback) | A 🙂/😐/🙁 feedback widget | [Feedback widgets](../author/feedback.md) |
| [`{nma-instructor}`](#nma-instructor) | Notes only instructors see | [Instructor notes](../author/instructor-notes.md) |
| [`{nma-data}`](#nma-data) | Declare files that code on the page reads | [Images and data files](../author/images-and-data.md) |
| [`{step}`](#step) | Start a step of a scrollytelling page | [Scrollytelling pages](../author/scrolly.md) |
| [`{stage}`](#stage) | Stage-only Markdown for a step | [Scrollytelling pages](../author/scrolly.md) |

(nma-video)=
## `{nma-video}`

````text
:::{nma-video} Video 1: Linear Dynamical Systems
:youtube: 87z6OR7-DBI
:bilibili: BV1up4y1S7wj
:::
````

| | |
|---|---|
| Argument | The title. Required. |
| Options | `:youtube:`, `:bilibili:`, `:osf:` (at least one). With several, the site shows one tab per host. |
| Body | None. |
| Site | A static iframe, so it shows without starting a kernel. |
| Notebook | The standard hidden NMA cells (an ipywidgets `Tab`, or an OSF `IFrame`). |

(nma-slides)=
## `{nma-slides}`

````text
:::{nma-slides} Tutorial slides
:osf: snv4m
:path: slides/deck.pdf
:::
````

| | |
|---|---|
| Argument | The title. Optional, default `Tutorial slides`. There is no `:title:` option. |
| Options | `:osf:` (an OSF file id) and/or `:path:` (at least one). |
| `:path:` | A `.pdf` inside the page's `slides/` folder (set by `nma.assets.slides`), relative to the page's folder. No absolute path or `..`, and the file must exist. Only pages with a `kernelspec` can use `:path:`: the file is copied to `notebooks/` when the page's notebook is generated. |
| Site | An iframe (a tab per backend when both options are set) and a download link. `:path:` PDFs load through the jsDelivr mirror of the notebooks branch, so the repository must be public. |

(nma-solution)=
## `{nma-solution}`

````text
```{code-cell} python
def f(x):
  raise NotImplementedError("Student exercise: implement f")
```

::::{nma-solution}
```python
def f(x):
  return 2 * x
```
::::
````

| | |
|---|---|
| Argument and options | None. |
| Body | A single ```` ```python ```` fence. The outer fence needs more colons than the inner backticks need. |
| Placement | Directly after an exercise code cell (an uncommented `raise NotImplementedError` line), with only blank lines between. Every exercise needs one, and every solution needs an exercise. |
| Site | A *Click for solution* link to `notebooks/<root>/<folder>/solutions/<stem>_Solution_<n>.py` on the notebooks branch; the answer is not on the page. The instructor site shows it inline. |
| Student notebook | The same link as a markdown cell. |
| Instructor notebook | A code cell starting with `# Solution`. |

`n` counts solutions from the top of the page.

(nma-explanation)=
## `{nma-explanation}`

````text
:::{nma-explanation}
Markdown answer to a discussion question, math allowed: $a < 0$.
:::
````

| | |
|---|---|
| Argument and options | None. |
| Body | Markdown, not empty. Stands alone, usually after a demo or a "Think!" question. |
| Site and notebooks | Like `{nma-solution}`, with files named `<stem>_Explanation_<n>.md`. |

(nma-feedback)=
## `{nma-feedback}`

````text
:::{nma-feedback} Linear_Dynamical_Systems_Video
:::
````

| | |
|---|---|
| Argument | A section name: letters, digits and underscores, unique on the page. Required. |
| Options and body | None. |
| Id sent | `<prefix>_<name>`. The prefix is the frontmatter `feedback_prefix` if set, otherwise derived from the file name (`W<week>D<day>_Tutorial1` becomes `W<week>D<day>_T1`; any other name is used as is). |
| Settings | `nma.feedback.{url, project, user_key}` in `myst.yml`, see [`nma:` settings](nma-config.md). Required once any page uses the directive. |
| Site | A widget that needs no kernel and posts to the datatops project. |
| Notebook | A hidden `content_review(...)` cell per directive and one hidden "Import feedback gadget" cell at the top. |

Never write `content_review(...)` or the vibecheck import cell by hand: `check` rejects them.

(nma-instructor)=
## `{nma-instructor}`

````text
:::{nma-instructor}
Allow 10 minutes. Students often forget the sign.
:::
````

| | |
|---|---|
| Argument and options | None. |
| Body | Markdown, not empty. |
| Student site and **every** notebook | Removed. |
| Instructor site | An "Instructor notes" box. |
| Not supported | On pages with `layout: scrolly`. |

(nma-data)=
## `{nma-data}`

````text
:::{nma-data}
data/spike_times.npz
data/neuron_metadata.npz
:::
````

| | |
|---|---|
| Argument | None. |
| Body | One path per line, each starting with `data/` or `images/` (set by `nma.assets`), inside the page's folder, and the file must exist. Not empty. |
| Site | The declared files are embedded for the page's editable cells, so `np.load('data/x.npz')` works. Together they may not exceed 2 MB per page (`check` fails above that). |
| Notebook | The files are copied to `notebooks/<root>/<folder>/` and a hidden download cell is added. |

Images a page only displays do not need a declaration. See [Images and data files](../author/images-and-data.md).

(step)=
## `{step}`

````text
:::{step}
:section: One dimension
:kicker: Coding Exercise 1
:::
````

| | |
|---|---|
| Pages | Only pages with `layout: scrolly`. A scrolly page needs at least one step. |
| Argument | None, or `hero` (a title step with no card). |
| Options | `:section:`, `:kicker:`. |
| Body | None. The step's content is what comes after the closing fence, up to the next `{step}`. |

(stage)=
## `{stage}`

````text
:::{stage}
:style: list
1. Stage-only markdown
:::
````

| | |
|---|---|
| Pages | Only pages with `layout: scrolly`. At most one per step, and none before the first `{step}`. |
| Argument | None. |
| Options | `:style:` (only `list`), `:class:`. |
| Body | Markdown shown on the stage only. |

On the same pages, `# @param` lines in code cells become sliders and dropdowns; see [Scrollytelling pages](../author/scrolly.md).
