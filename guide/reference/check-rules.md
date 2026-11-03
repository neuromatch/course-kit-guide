---
title: "Rules enforced by `check`"
---

# Rules enforced by `check`

For: author (lookup)

`nma-kit check` validates your content and exits non-zero on any violation. `notebooks` and `prepare-site` run the same checks before doing anything, and CI runs `check` on every pull request. Each error starts with the file and line (`guide/p.md: line 8: ...`). For a walkthrough of fixing them, see [Fix a failing check](../author/fix-a-failing-check.md).

(rules-kernelspec)=
## Executable pages need `kernelspec`

A page with a top-level `{code-cell}`, or with `{nma-solution}`/`{nma-explanation}`, must declare `kernelspec` in its frontmatter. Code cells that only appear as examples inside another fenced block don't count.

```text
guide/p.md: contains {code-cell} blocks but no `kernelspec` in its frontmatter, so it would get no notebook, badges, or JupyterLite button.
```

Fix: add `kernelspec` ([Frontmatter keys](frontmatter.md#kernelspec)). Also, a page must not be a `.ipynb`: all content is Markdown, and incoming notebooks are converted once ([Convert an existing notebook](../author/convert-a-notebook.md)).

(rules-exercises)=
## Exercises need solutions

An exercise is a code cell with an uncommented `raise NotImplementedError` line. Every exercise must be directly followed by an `{nma-solution}`, and every `{nma-solution}` must directly follow an exercise.

```text
guide/p.md: line 8: exercise code cell (raises NotImplementedError) has no {nma-solution} directly after it
guide/p.md: line 8: {nma-solution} must come directly after an exercise code cell (one that raises NotImplementedError)
guide/p.md: line 8: code cell has a `# to_remove` marker. Move the solution into an {nma-solution} or the explanation into an {nma-explanation} directive
guide/p.md: line 8: {nma-explanation} is empty
```

Also: no `# to_remove` markers in code cells; a solution body is a single ```` ```python ```` fence; an explanation is not empty; neither directive is nested or takes an argument or options. See [`{nma-solution}`](directives.md#nma-solution).

(rules-media)=
## Media directives

`{nma-video}` needs a title and at least one of `:youtube:`, `:bilibili:`, `:osf:`. `{nma-slides}` needs `:osf:` and/or `:path:`, where `:path:` is a `.pdf` inside the page folder's `slides/` folder that exists. Unknown options, body text and unclosed blocks are errors.

```text
guide/p.md: line 8: {nma-video} needs at least one of :youtube:, :bilibili:, :osf:
guide/p.md: line 8: {nma-slides} :path: '../x.pdf' must stay inside the day folder
guide/p.md: line 8: {nma-slides} :path: 'deck.pdf' must start with slides/
guide/p.md: line 8: {nma-slides} :path: 'slides/deck.txt' must be a .pdf file
```

"The day folder" in these messages is the folder that holds the page. See [`{nma-video}`](directives.md#nma-video) and [`{nma-slides}`](directives.md#nma-slides).

(rules-feedback)=
## Feedback uses the directive

`{nma-feedback}` takes a section name (`[A-Za-z0-9_]+`, unique on the page), at the top level, with no options or body. No code cell may call `content_review(`, import `vibecheck`, or be an "Import feedback gadget" cell. If any page uses `{nma-feedback}`, `myst.yml` needs `nma.feedback.url`, `.project` and `.user_key`.

```text
guide/p.md: uses {nma-feedback} but myst.yml has no complete nma.feedback block (url, project, user_key)
```

See [`{nma-feedback}`](directives.md#nma-feedback) and [`nma:` settings](nma-config.md).

(rules-instructor)=
## Instructor notes

`{nma-instructor}` is top-level, takes Markdown, has no argument or options, and is not supported on `layout: scrolly` pages.

```text
guide/p.md: line 9: {nma-instructor} must be at the top level of the page, not inside another directive
guide/p.md: line 9: {nma-instructor} is empty
```

(rules-runtime)=
## `runtime` and frontmatter

`runtime` is `browser` or `colab`, and `colab` can't be combined with `layout: scrolly`. `feedback_prefix` may use only letters, digits and underscores.

```text
guide/p.md: runtime: 'gpu' must be one of browser, colab
```

(rules-scrolly)=
## Scrolly pages

`{step}` and `{stage}` work only on pages with `layout: scrolly`, at the top level. `{step}` takes no argument or `hero`, only `:section:` and `:kicker:`, and no body. At most one `{stage}` per step (options `:style: list`, `:class:`), and none before the first step. A scrolly page needs at least one `{step}`. On scrolly pages every `# @param` line must parse.

```text
guide/p.md: line 1: page has `layout: scrolly` but no {step} markers
guide/p.md: line 8: {step} only works on pages with `layout: scrolly` in the frontmatter
```

See [`{step}`](directives.md#step) and [Scrollytelling pages](../author/scrolly.md).

(rules-assets)=
## Images and data files

Every image reference that starts with the images folder (`images/`, set by `nma.assets.image`) must stay inside it (no `..`) and exist. References that don't start with that folder are not checked, and not published to the notebooks. Every `{nma-data}` path must start with `data/` or `images/`, stay inside the page's folder and exist, and the declared files together may not exceed 2 MB. Files that code reads without a declaration, and dynamic paths, are rejected.

```text
guide/p.md: image 'images/nope.png' does not exist (guide/images/nope.png)
guide/p.md: line 8: {nma-data} declares 'data/nope.npz', but guide/data/nope.npz does not exist
guide/p.md: {nma-data} files total 3.1 MB, more than the 2 MB that can be embedded in the page for browser cells. Declare only small files; ...
guide/p.md: line 8: {nma-data} is empty; list at least one file, e.g. data/data.npz
```

See [`{nma-data}`](directives.md#nma-data).

(rules-content-roots)=
## Content folders and settings

`nma.content` lists the folders that hold pages. The `nma:` block must be `section:` mappings of `key: value` with string values. `nma.brand` colours must be `#RRGGBB`.

```text
nma.content is required: list the folders that hold your pages, for example ...
nma.paths.tutorials is no longer read: declare the folder in nma.content instead (...)
nma.content folders 'guide' and 'guide/sub' overlap: a page must belong to one root
nma.content path '../up' must be a folder inside the course (no '.' or '..')
nma.content folder docs/ (root docs) does not exist
myst.yml: nma.brand.primary must be a colour like "#008CBF", got 'red'
```

See [`nma:` settings](nma-config.md#nma-content).

## Generated content must not be committed

`check` also fails if a page starts with Colab/Kaggle badge HTML or contains the generated run-all fallback cell. That means `nma-kit prepare-site` output was committed: revert it with `git checkout -- <your content folders>`.
