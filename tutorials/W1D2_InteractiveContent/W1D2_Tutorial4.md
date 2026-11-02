---
title: "Tutorial 4: Videos, Slides and Feedback"
kernelspec:
  name: python3
  display_name: Python 3
---

# Tutorial 4: Videos, Slides and Feedback

Lecture videos and slide decks are written as two MyST directives,
`{nma-video}` and `{nma-slides}`. They render as plain embeds on the website,
so readers see them right away without starting the in-browser kernel. In the
Colab/Kaggle notebooks they become the usual hidden `# @title Video …` cells.
Per-section feedback works the same way, with `{nma-feedback}`.

## Videos

````markdown
:::{nma-video} Video 1: Linear Dynamical Systems
:youtube: 87z6OR7-DBI
:bilibili: BV1up4y1S7wj
:::
````

renders as:

:::{nma-video} Video 1: Linear Dynamical Systems
:youtube: 87z6OR7-DBI
:bilibili: BV1up4y1S7wj
:::

- The argument is the title.
- `:youtube:`, `:bilibili:` and `:osf:` are each optional, but you need at
  least one. Tabs always appear in that order. With only one host, the player
  is shown without tabs.

## Slides

````markdown
:::{nma-slides} Tutorial slides
:osf: snv4m
:path: slides/example_slides.pdf
:::
````

renders as:

:::{nma-slides} Tutorial slides
:osf: snv4m
:path: slides/example_slides.pdf
:::

- The argument is the title. Leave it out for the default, "Tutorial slides".
  There is no `:title:` option.
- `:osf:` is the id of an OSF file. `:path:` is a PDF **inside your repository**,
  relative to the page's folder. Use either or both. With both, the deck
  appears in two tabs (OSF, PDF), and with one it appears without tabs.
- A download link is always shown, because phone browsers often can't display a
  PDF inside a page.

### PDFs in the repository (`:path:`)

Put the PDF in a `slides/` folder inside the day's folder, like `data/` and
`images/` (the folder name is `nma.assets.slides`, `slides` by default). The
path starts with that folder and ends in `.pdf`: no absolute paths and no `..`.
The example above uses
`tutorials/W1D2_InteractiveContent/slides/example_slides.pdf`.

`nma-kit notebooks` copies the file to `notebooks/<Day>/slides/` on the
notebooks branch. The site and the notebooks both show it from there (through
the jsDelivr mirror of GitHub), so the repository must be public. jsDelivr
caches a branch for up to about 12 hours, so a changed PDF can take a while to
appear. In Colab, which can't draw a bare PDF, the notebook uses a small PDF.js
viewer with zoom, fit and page buttons. The PDF is only published with a page that has a
`kernelspec` (it is copied while that page's notebook is generated), so a
static page can't use `:path:`. `nma-kit check` fails on a missing
file, a path outside `slides/` or a file that isn't a `.pdf`.

## Feedback

````markdown
:::{nma-feedback} Linear_Dynamical_Systems_Video
:::
````

renders a row of 🙂 😐 🙁 buttons (see any section of
[W2D1 Tutorial 1](../W2D1_Examples/W2D1_Tutorial1.md)). 🙂 is sent right away.
😐 and 🙁 first ask for a comment. The widget is plain JavaScript, so it works
before the kernel starts, and it posts straight to the
datatops project that the Neuromatch notebooks already use.

- The argument is the section name: letters, digits and underscores, unique
  on the page. It's sent as `<prefix>_<name>`, e.g.
  `W2D1_T1_Linear_Dynamical_Systems_Video`.
- The prefix comes from the file name (`W2D1_Tutorial1` → `W2D1_T1`). To keep
  the ids of an existing notebook, set it in the frontmatter:
  `feedback_prefix: W2D2_T1`. MyST then logs
  `extra key ignored: feedback_prefix`, which is expected.
- Where to send feedback is set once in `myst.yml`:

  ```yaml
  nma:
    feedback:
      url: https://pmyvdlilci.execute-api.us-east-1.amazonaws.com/klab
      project: neuromatch_cn
      user_key: y1x3mpx5
  ```

  Use plain `key: value` lines only. The website plugin reads this block
  without a YAML library, and CI rejects anything it would misread. The
  `user_key` only allows adding responses and is in every notebook anyway, so
  it isn't a secret. A course that wants its own datatops project changes
  these three values.

## Instructor notes

Teaching notes (timing, common mistakes, what to say) go in `{nma-instructor}`.
The body is Markdown:

````markdown
:::{nma-instructor}
Allow about 10 minutes here. Students often forget the sign of the drift term.
:::
````

On the student site and in every generated notebook the note is removed. On the
[instructor site](../W1D3_PublishingAndCI/W1D3_Tutorial3.md) it appears as an
"Instructor notes" box. Like the other directives it sits at the top level of the page.

:::{nma-instructor}
This note is only visible on the instructor site. The student site and the
notebooks never contain it.
:::

## Rules

- Put the directives at the top level of the page, not inside another
  directive such as `{note}` or `{tab-set}`.
- Don't add body text inside them, only options (`{nma-feedback}` takes none).
- CI checks every directive. Missing ids, unknown options and unclosed blocks
  fail the build with the file and line number.

## What the notebook gets

`nma-kit notebooks` replaces each directive with a hidden code
cell (`cellView: form`, `hide-input`). For videos, that cell builds the
YouTube/Bilibili `ipywidgets` Tab used in all Neuromatch notebooks. For
slides, it shows the OSF and PDF decks in tabs and prints the download links. For feedback,
it is the usual `# @title Submit your feedback` / `content_review(...)` cell,
and one hidden "Import feedback gadget" cell at the top of the notebook
installs `vibecheck` and sets `feedback_prefix`.

## How it works

Both sides live in the course kit ([neuromatch/course-kit](https://github.com/neuromatch/course-kit)):

| Where | Course kit file | Job |
|---|---|---|
| Website | `js/src/media/plugin.mjs` (part of the kit's MyST plugin, listed in `myst.yml` under `project.plugins`) | Turns directives into iframes and tabs during `myst build` |
| Notebooks | `python/src/nma_kit/media.py` | Validates directives and replaces them with code cells |
| Website | `js/src/feedback/plugin.mjs` and `js/src/feedback/assets/widget.mjs` | The feedback widget, loaded in the browser through MyST's `anywidget` node |
| Notebooks | `python/src/nma_kit/feedback.py` | Validates `{nma-feedback}` and the `nma:` settings, writes the feedback cells |

Adding a new video host is a course kit change in both files: add the embed
and page URL in `VIDEO_SOURCES` in `media/plugin.mjs`, and the option and label
in `VIDEO_SOURCES` in `media.py`, plus a branch in the generated `PlayVideo`
class.

## Converting an existing NMA notebook

Replace each `# @title Video …` cell with an `{nma-video}`, copying the ids
from its `video_ids = [...]` line. Replace the `# @title Tutorial slides`
cell with `{nma-slides}`, using its `link_id` as `:osf:`. Replace each "Submit your
feedback" cell with `{nma-feedback}`, using the part of
`content_review(f"{feedback_prefix}_…")` after the underscore, and delete the
"Import feedback gadget" cell. Set `feedback_prefix` in the frontmatter if the
notebook's prefix differs from the one derived from the file name. CI
rejects any leftover `content_review` or `vibecheck` code.
