# Course Guide restructure: design

Status: draft, updated for course kit 0.4.0. Date: 2026-11-02.

## 1. Problem

The guide is the manual for the Neuromatch course kit, but it is organised as a
three-day course (`W1D1`, `W1D2`, `W1D3`) with schedules and learning objectives.
Readers arrive with a task ("add an exercise", "turn on previews"), not a day number.
Specific problems found in the review:

- Chapter intros are stale: the W1D2 schedule lists 6 tutorials (there are 7) and its
  numbering is shifted; W2D1 and `AGENTS.md` link to "W1D2 Tutorial 6" as the scrolly
  how-to, which is now Tutorial 7.
- Topics are scattered: instructor material (W1D2 T4, W1D3 T4), notebook conversion
  (W1D2 T3, T4, `AGENTS.md`), "why Markdown" (intro, W1D1 T1, W1D2 T3).
- No reference layer: no directive index, no `nma:` settings reference, no `nma-kit`
  command reference, no list of `check` rules, no troubleshooting.
- Inconsistent naming ("Day 1", "Week 2 Day 1", "Tutorial N"); four identical
  "Further Reading" titles; demo content (LDS, projects) mixed in with guide content.
- `nma-kit init` is presented to everyone, but only whoever creates a course runs it.

## 2. Goals and non-goals

Goals
- Organise by audience and task, so each reader finds their pages without a path.
- Every feature page shows **what you write** next to **what you get**, with the
  source taken from a real, validated file so it cannot drift.
- One owner page per concept; other pages link to it.
- Add the missing reference layer and a "fix a failing check" page.

- Move the guide to kit **0.4.0** and use its arbitrary content folders
  (`nma.content`), so the folder layout follows the information architecture.

Non-goals
- No kit changes (this repo holds content only).
- No rewrite of the Neuromatch example content (LDS, projects) beyond moving it.
- No new authoring features.

## 3. Audiences

| Audience | Does | Touches |
|---|---|---|
| **Author** (most readers) | Writes or converts tutorials in an existing course repo | pages in the content folders, PR previews, `nma-kit check` |
| **Maintainer** (1–2 per course) | Creates the repo, CI, Pages, branding, previews, instructor site, kit upgrades | `myst.yml`, `course.yml`, Cloudflare, `init` |
| **Instructor / TA** | Reads the instructor site and notebooks | Nothing to write |
| Kit developer | Changes the plugin or CLI | Out of scope; link to the kit repo |

Authors are the default reader. Their feedback loop is the **PR preview**, because it
is the only build that matches what students get (badges, run-all fallback, notebooks,
scrolly outputs). Local `myst start` is an optional faster loop that omits those.
Previews need the maintainer to have enabled them (same-repo PRs, Cloudflare secrets),
so the author Quick start states that prerequisite and links to the maintainer page.

## 4. Information architecture

Section order in the sidebar. Page titles are task-shaped and unique. No Week/Day
numbering and no schedules or learning objectives.

**Start here**
- Welcome (landing; short, links to the three paths)
- What is the course kit? (the model: Markdown is the only source; site + notebooks
  + badges; what students get)
- Which path are you? (Author / Maintainer / Instructor)

**For authors**
- Quick start (PR preview first; `nma-kit check` and `myst start` as optional)
- Write pages (Markdown, admonitions, code cells, hiding cells)
- Figures, math and cross-references
- Add a page (file, frontmatter, TOC entry, naming)
- Page types (executable, static, Colab, scrolly)
- Run code in the browser
- Rich outputs (Altair, widgets, DataFrames)
- Images and data files
- Exercises, solutions and explanations
- Videos and slides
- Feedback widgets
- Instructor notes
- Scrollytelling pages
- More MyST (tabs, dropdowns, proofs, margin notes, footnotes)
- Convert an existing notebook (generic and NMA-specific steps)
- Fix a failing check

**For maintainers**
- Create a course (`nma-kit init`, generated files, first push)
- Publish with CI (GitHub Pages and the workflow)
- Notebooks, branches and badges
- Pull request previews
- Instructor site
- Branding and customising
- Structure and scale (TOC, multi-week, precourse, splitting repos)
- Project booklet
- Upgrade the kit

**For instructors**
- What you get (instructor site, instructor notebooks, solutions inline)

**Reference**
- Directives
- Frontmatter keys
- `nma:` settings in `myst.yml`
- `nma-kit` commands
- Rules enforced by `check`
- Browser (Pyodide) limits and packages
- Further reading (one page, replaces four)

**Examples** (showcases, labelled as such)
- Example pages for each directive (the validated source used by the feature pages)
- Linear Dynamical Systems: normal page, scrolly page
- Heavy-compute tutorial (Colab)
- Project booklet examples (moved from `projects/` to `examples/projects/`)

## 5. Page template

Every how-to (feature) page, in this order. Reference pages, indexes, examples, orientation and instructor pages are exempt or adapt the headings (see `conventions.md`):

1. One-line label: `For: author` (or maintainer / instructor).
2. Two or three sentences: what it does and when to use it.
3. **You write**: the source, taken from the example file (see section 6).
4. **You get**: the live result, or a link to the live example page.
5. Rules and gotchas (what `check` enforces, links to the check-rules reference).
6. **Next** links, and the matching reference entry.

Author pages never explain CI internals. Maintainer pages never explain MyST syntax.
"Why Markdown, not notebooks" lives only on *What is the course kit?*; the landing
page links to it. `README.md` is a pointer; *Create a course* owns the `init` steps.

## 6. "You write / You get"

Spike results (scratch copy, kit 0.3.0):

| Snippet content | `:literal:` include | Plain include |
|---|---|---|
| Admonitions, Markdown, `{nma-video}` | works | works |
| `{nma-feedback}`, `{nma-solution}`, `{nma-explanation}` | works | **build error** (plugin sees the include as nested; these must be top-level) |

`nma-kit check` does not scan included files, so a bad include only fails at
`myst build`.

Decision:
- **Real example pages** (`guide/examples/...`) hold the directives at the top
  level. The kit validates them, builds them and (for executable ones) generates their
  notebooks, so they cannot rot.
- **Feature pages** show *You write* with `{include} :literal: :lang: markdown`
  on a marked region of the example file (`:start-after:` / `:end-before:` comment
  markers), and link to the live example for *You get*.
- For plain Markdown, admonitions and video, a feature page may use include-twice
  inline (same file shown and rendered).
- Scrolly, Colab and full-tutorial examples are always their own pages, because they
  are page-level layouts. The feature page links to the demo and literal-includes the
  relevant part of its source.

Phase 0 results (kit 0.4.0, mystmd 1.12.0):
- A `{include}` with `:literal:`, `:start-after:` and `:end-before:` works on a `.md`
  file. Markers are MyST comment lines (`% region-start: <name>` /
  `% region-end: <name>`); the marker lines are not shown, and the value is exactly the
  region, including a top-level `{nma-solution}` or a `{code-cell}`.
- An example page with `kernelspec`, a real top-level exercise, solution and region
  markers passes `nma-kit check` and generates its notebook and solution file. The
  feature page that literal-includes it (no `kernelspec`) also passes `check`.
- 0.4.0's only other change is the `nma.content` breaking change already planned for.

## 7. Layout and naming

### Kit 0.4.0 and content folders

0.4.0 replaces the fixed `tutorials/` and `projects/` roots with a required
`nma.content` list: the folders whose pages the kit processes (`check`, notebooks,
badges, scrolly rendering). There are no defaults, and `nma.paths` is removed (`check`
reports it). Each entry is a path or `{name, path}`; the name is the first folder under
`notebooks/`. Roots cannot overlap or nest, must be inside the course, and cannot sit
under `notebooks`, `_build`, `_nma` or `node_modules`.

Verified on a scratch copy with 0.4.0: pages under `guide/` (a root that isn't
`tutorials`) pass `check`, and notebooks are written to `notebooks/guide/...`; a missing
`nma.content` fails with a clear message. Nothing below a root is name-sensitive.

Consequence for scope: a page outside every root is ignored by the kit (no rules
checked, no notebook). So **every guide page, including static ones, must live under a
root**.

### Decision

```yaml
nma:
  content:
    - guide        # every page, projects included (notebooks under notebooks/guide/...)
```

```
guide/
  index.md            landing (was tutorials/intro.md)
  start/              what-is-the-kit.md, which-path.md
  author/             quick-start.md, write-pages.md, ... (plain slugs)
  maintainer/         create-a-course.md, publish-with-ci.md, ...
  instructor/         what-you-get.md
  reference/          directives.md, frontmatter.md, nma-config.md, cli.md,
                      check-rules.md, browser-limits.md, further-reading.md
  examples/           directive examples, lds/, colab/, projects/ (moved from ./projects)
docs/superpowers/     design and plan documents (not a content root, not built)
```

- `tutorials/` disappears. The guide is no longer shaped like a course, and 0.4.0
  makes that legitimate. Pages with code keep a `kernelspec` and still get notebooks.
- `projects/` moves into `guide/examples/projects/`, leaving a single root. A real
  course keeps its own `projects` root (as `init` writes); the maintainer page
  *Project booklet* shows that configuration, and this book shows the project pages
  as examples.
- One `guide` root rather than one root per section keeps the config small and the
  notebook tree simple. See open decision 2.
- This also becomes content: the maintainer page *Structure and scale* teaches
  `nma.content` (several roots, `{name, path}`, notebook naming), with this book as
  the example.
- The repo still tracks `nma-kit init` output for everything except the folder
  names; the guide states that difference in `AGENTS.md`.
- Each section has an `index.md` as the TOC parent (not a `title:` group, per
  `AGENTS.md`), replacing the chapter intros. Images, data and slides stay in
  `images/`, `data/`, `slides/` beside the page that uses them (or one per section).

Side effects of renaming, handled in phase 1:
- The file stem names the notebook and `<stem>_Solution_n.py`, and sets the default
  feedback id prefix. For pages with `{nma-feedback}`, set `feedback_prefix` to the
  old id prefix so submitted feedback stays continuous.
- Notebook paths change from `notebooks/tutorials/...` to `notebooks/guide/...`, so
  every Colab/Kaggle link changes (they are regenerated on publish).
- Old site URLs change. See open decisions.

## 8. Mapping from current pages

New paths are relative to `guide/`. Old paths are relative to `tutorials/`.

| Current | New |
|---|---|
| `intro.md` | `index.md` (landing, cut down) |
| `new_course.md` | `maintainer/create-a-course.md` |
| W1D1 T1 (Why MyST) | `start/what-is-the-kit.md` |
| W1D1 T1 (rest) | `author/write-pages.md` |
| W1D1 T2 (TOC) | `author/add-a-page.md` + `maintainer/structure-and-scale.md` |
| W1D1 T3 | `author/figures-math-xrefs.md` (images part to `images-and-data`) |
| W1D1 T4 | `author/page-types.md` + `reference/frontmatter.md` |
| W1D1 Bonus | `author/more-myst.md` |
| W1D2 T1 | `author/run-code-in-browser.md` |
| W1D2 T2 | `author/rich-outputs.md` |
| W1D2 T3 | `start/what-is-the-kit.md`, `author/convert-a-notebook.md`, `reference/check-rules.md` |
| W1D2 T4 | `author/videos-and-slides.md`, `author/feedback.md`, `author/instructor-notes.md`, conversion part to `author/convert-a-notebook.md` |
| W1D2 T5 | `author/images-and-data.md` |
| W1D2 T6 | `author/exercises.md` |
| W1D2 T7 | `author/scrolly.md` (how-to) + `examples/` scrolly demo |
| W1D2 Bonus | `reference/browser-limits.md` |
| W1D3 T1 | `maintainer/publish-with-ci.md`, `maintainer/pr-previews.md` |
| W1D3 T2 | `maintainer/notebooks-and-badges.md` |
| W1D3 T3 | `maintainer/branding.md` |
| W1D3 T4 | `maintainer/instructor-site.md`, `instructor/what-you-get.md` |
| W1D3 Bonus | `maintainer/structure-and-scale.md`, `maintainer/project-booklet.md` |
| W2D1 T1, T2, T3 | `examples/lds/`, `examples/colab/` |
| `projects/**` | `examples/projects/**` (same names, except each `README.md` becomes `index.md`) |
| `further_reading.md` x4 | `reference/further-reading.md` |
| chapter intros | removed; replaced by section `index.md` |
| (new) | `author/quick-start.md`, `author/fix-a-failing-check.md`, `maintainer/upgrade-the-kit.md`, `reference/directives.md`, `nma-config.md`, `cli.md`, `check-rules.md`, `start/which-path.md` |

## 9. Phases

0. **Spikes finish.** Region-include test on 0.4.0; confirm whether MyST supports
   redirects; read the 0.4.0 release notes for anything else that changed.
1. **Kit 0.4.0 and skeleton.** (a) Bump the kit in all three places (`extend:` URL,
   `@v0.4` in `course.yml`, the local package) and add `nma.content` to `myst.yml`
   with the current folders, so the guide builds on 0.4.0 before anything moves.
   (b) Create `guide/`, move and rename pages, change `nma.content` to
   `guide` (projects included), rewrite `project.toc`, add section `index.md` files, fix
   cross-links, delete chapter intros, set `feedback_prefix`. Green: `check`,
   `notebooks`, `render-scrolly`, `myst build`. No content rewrites yet.
2. **Reference layer.** Directives, frontmatter, `nma:` settings, CLI, check rules,
   browser limits, further reading. Source facts from the kit (`nma_kit`, docs) and
   the existing `AGENTS.md`.
3. **Author section.** Split and rewrite pages to the template, add example pages
   and region includes, write *Quick start* and *Fix a failing check*.
4. **Maintainer, instructor, start.** Rewrite to the template, add *PR previews*,
   *Upgrade the kit*, *What is the course kit?*, *Which path are you?*, the landing.
5. **Docs and CI.** Update `README.md` and `AGENTS.md` (architecture, `guide/` layout,
   `nma.content`, stale notebook paths and "Tutorial 6" references, new conventions), open a PR, check the CI
   preview.

Each phase is one commit group, reviewable on its own and leaves the build green.

## 10. Verification

Per phase: `uv run nma-kit check`, `uv run nma-kit notebooks`,
`uv run nma-kit render-scrolly`, `myst build --html` with no new `⛔` errors, plus a
grep for stale `W1D`/`W2D` links. At the end: the PR preview, and a read-through of
each audience path. The local build needs `cdn.jsdelivr.net` allowed, or the
kit's `nma.yml` copied from npm (`npm pack @neuromatch/course-kit@0.4.0`) as in the spike.

## 11. Open decisions (my defaults)

1. **Old URLs.** Decided: accept the break. mystmd 1.12 has no site redirect option
   and GitHub Pages has no server-side redirects; the PR description says so.
2. **One root or one per section.** Default: one `guide` root. The alternative is a
   root per section (`{name: author, path: guide/author}` and so on) for
   audience-named notebook folders; it costs more config and gains little.
3. **Content folder name.** Default: `guide/`. (`docs/` is avoided because it holds
   these design documents.)
4. **Instructor section size.** Default: one page; grow only if instructors need more.
5. **Examples placement.** Default: a top-level *Examples* section, with project
   booklet examples reached from it.
6. **Feature-page demos that need a kernel.** Default: the page itself carries
   `kernelspec` where it was already executable (run-code, exercises, data), and
   the others link to an example page.
