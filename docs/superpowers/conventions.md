# Conventions for "You write / You get" pairs

Feature pages in `guide/` show the source of an example next to its result. The
source comes from a real **example page** that the kit validates, so it cannot rot.

## Example pages

- They live in `guide/examples/directives/` (or beside the other examples) and hold the
  directives at the **top level** of the page, as the kit requires.
- A page with code carries `kernelspec`, so `check` validates its exercises and
  `notebooks` generates its notebook. A page without code stays static.
- Each shown region is wrapped in marker comments (MyST comment lines):

  ```text
  % region-start: video
  :::{nma-video} Video 1: Demo
  :youtube: 87z6OR7-DBI
  :::
  % region-end: video
  ```

  Region names are unique within a file and use lowercase letters, digits and `-`.

## Feature pages

*You write* literal-includes the region. Use `:lang: text`, not `markdown`: the Markdown
highlighter italicises underscores in directive examples.

````text
```{include} ../examples/directives/video-and-slides.md
:literal: true
:lang: text
:start-after: % region-start: video
:end-before: % region-end: video
```
````

*You get* links to the live example page. For plain Markdown, admonitions and
`{nma-video}` the page may instead include the same region twice (once literal, once
rendered). Never plain-include `{nma-feedback}`, `{nma-solution}` or `{nma-explanation}`:
an include counts as nested and the build fails.

## Checks

`docs/superpowers/verify.sh` asserts that every `:start-after:` and `:end-before:`
marker of an `{include}` block occurs exactly once in the target file. Renaming a marker
without updating the feature page fails the check.
