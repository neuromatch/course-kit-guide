---
title: "Videos and slides"
---

# Videos and slides

For: author

Lecture videos and slide decks are two directives, `{nma-video}` and `{nma-slides}`. On the site they render as plain embeds, so readers see them without starting the in-browser kernel. In the Colab and Kaggle notebooks they become the usual hidden `# @title Video …` cells.

## You write

A video needs a title and at least one host:

```{include} ../examples/directives/video-and-slides.md
:literal: true
:lang: text
:start-after: % region-start: video
:end-before: % region-end: video
```

Slides take an OSF file id, a PDF in the repository, or both:

```{include} ../examples/directives/video-and-slides.md
:literal: true
:lang: text
:start-after: % region-start: slides
:end-before: % region-end: slides
```

## You get

The video, rendered:

```{include} ../examples/directives/video-and-slides.md
:start-after: % region-start: video
:end-before: % region-end: video
```

The slides need a page with a `kernelspec` to use `:path:`, so their live version is on the [Video and slides example](../examples/directives/video-and-slides.md). With both `:osf:` and `:path:` the deck appears in two tabs (OSF, PDF); with one it appears without tabs. A download link is always shown, because phone browsers often can't display a PDF inside a page.

In a generated notebook each directive becomes a hidden code cell (`hide-input`). A video cell builds the YouTube/Bilibili `ipywidgets` tab used in all Neuromatch notebooks. A slides cell shows the OSF and PDF decks in tabs and prints the download links. In Colab, which can't draw a bare PDF, the notebook uses a small PDF.js viewer with zoom, fit and page buttons.

## Rules

- **Video:** the argument is the title. `:youtube:`, `:bilibili:` and `:osf:` are each optional but you need at least one. Tabs always appear in that order; with a single host the player has no tabs.
- **Slides:** the argument is the title (default "Tutorial slides"; there is no `:title:` option). `:osf:` is the id of an OSF file.
- **PDFs in the repository (`:path:`):** put the PDF in a `slides/` folder next to the page (the name is `nma.assets.slides`). The path starts with that folder and ends in `.pdf`: no absolute path and no `..`. Only a page with a `kernelspec` can use `:path:`, because the PDF is copied to the notebooks branch while the page's notebook is generated.
- **Where PDFs are served from:** the jsDelivr mirror of GitHub, so the repository must be public. jsDelivr caches a branch for about 12 hours, so a changed PDF can take a while to appear.
- Put the directives at the top level of the page, with options only and no body.
- `check` fails on a missing file, a path outside `slides/`, or a file that isn't a `.pdf` ([Rules enforced by `check`](../reference/check-rules.md#rules-media)).
- Adding a new video host is a change to the course kit, not to your course.

## Next

- [Feedback widgets](feedback.md)
- [Instructor notes](instructor-notes.md)
- Reference: [`{nma-video}`](../reference/directives.md#nma-video) and [`{nma-slides}`](../reference/directives.md#nma-slides)
