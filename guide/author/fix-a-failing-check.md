---
title: "Fix a failing check"
---

# Fix a failing check

For: author

When the `check` job on your pull request fails, open its log. Every error starts with the file and line, for example `guide/p.md: line 8: ...`. Find the message below, apply the fix, and run `uv run nma-kit check` locally to confirm. Every rule is described in [Rules enforced by `check`](../reference/check-rules.md).

## You write

The most common failure is an exercise without a solution:

````text
```{code-cell} python
def f(x):
  raise NotImplementedError("Student exercise: implement f")
```
````

CI prints:

```text
guide/p.md: line 8: exercise code cell (raises NotImplementedError) has no {nma-solution} directly after it
```

Add the solution directly after the exercise cell, with only blank lines between them. See [Exercises, solutions and explanations](exercises.md).

## You get

One entry per family of errors. Each gives the message as it appears in the log, why it happens, and the fix.

### Missing `kernelspec`

```text
contains {code-cell} blocks but no `kernelspec` in its frontmatter
uses {nma-solution}/{nma-explanation} but has no `kernelspec` in its frontmatter
```

A page with code needs a `kernelspec` in its frontmatter, so it gets a notebook and editable cells. Add it ([Frontmatter keys](../reference/frontmatter.md#kernelspec)). Rules: [`kernelspec`](../reference/check-rules.md#rules-kernelspec).

### Exercises and solutions

```text
exercise code cell (raises NotImplementedError) has no {nma-solution} directly after it
{nma-solution} must come directly after an exercise code cell (one that raises NotImplementedError)
code cell has a `# to_remove` marker. Move the solution into an {nma-solution} or ...
{nma-explanation} is empty
```

An exercise and its solution must be neighbours. Delete leftover `# to_remove` marker lines and put the solution in a `{nma-solution}` directive. Rules: [exercises](../reference/check-rules.md#rules-exercises).

### Videos and slides

```text
{nma-video} needs at least one of :youtube:, :bilibili:, :osf:
{nma-slides} :path: '../x.pdf' must stay inside the day folder
```

Add a host option to the video. A slide `:path:` is a `.pdf` in the `slides/` folder next to your page. Rules: [media](../reference/check-rules.md#rules-media).

### Directives that must be at the top level

```text
{nma-instructor} must be at the top level of the page, not inside another directive
```

Move the directive out of the list, tab, admonition or other directive it sits in. This applies to `{nma-solution}`, `{nma-explanation}`, `{nma-feedback}`, `{nma-instructor}` and `{nma-video}`. Rules: [directives](../reference/directives.md).

### Feedback

```text
uses {nma-feedback} but myst.yml has no complete nma.feedback block (url, project, user_key)
```

Ask your maintainer for the course's datatops project and add it to `myst.yml` ([`nma:` settings](../reference/nma-config.md)). Rules: [feedback](../reference/check-rules.md#rules-feedback).

### Images and data

```text
image 'images/nope.png' does not exist (guide/images/nope.png)
{nma-data} declares 'data/nope.npz', but guide/data/nope.npz does not exist
```

The path is relative to your page, and the folder is `images/` or `data/` beside it. Rules: [assets](../reference/check-rules.md#rules-assets).

### `runtime` and scrolly

```text
runtime: 'gpu' must be one of browser, colab
page has `layout: scrolly` but no {step} markers
{step} only works on pages with `layout: scrolly` in the frontmatter
```

Rules: [runtime](../reference/check-rules.md#rules-runtime) and [scrolly](../reference/check-rules.md#rules-scrolly).

### `nma.content` and generated files

```text
nma.content is required: list the folders that hold your pages ...
starts with Colab/Kaggle badge HTML, which CI adds at build time
```

These are usually the maintainer's. A page that starts with badge HTML means generated output was committed: `git checkout -- <content folders>`. Rules: [content folders](../reference/check-rules.md#rules-content-roots).

## MyST warnings you can ignore

MyST prints `extra key ignored` for `nma`, `runtime`, `layout` and `feedback_prefix`: the kit reads them, MyST does not. The warning `Language is not defined for code block` is cosmetic. Anything marked `⛔` in the build log is a real error.

## Rules

- Fix errors from the top: one mistake often causes several lines.
- Reproduce locally with `uv run nma-kit check` before pushing again.
- If you can't tell which rule you broke, search the message text in [Rules enforced by `check`](../reference/check-rules.md).

## Next

- [Quick start](quick-start.md)
- Reference: [Rules enforced by `check`](../reference/check-rules.md)
