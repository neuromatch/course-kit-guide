# Guide Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganise the course guide by audience and task on course kit 0.4.0, with a single `guide/` content root, a reference layer, and "You write / You get" pairs backed by validated example pages.

**Architecture:** Mechanical moves first (kit bump, then skeleton) so the build is green before any prose changes; then reference pages, example pages, and section-by-section rewrites. "Tests" are the kit's own gates (`nma-kit check`, `notebooks`, `render-scrolly`, `myst build`) plus stale-name greps, run by one script on a scratch copy.

**Tech Stack:** MyST (mystmd 1.x), `neuromatch-course-kit` 0.4.0 (npm + PyPI), `nma-kit` CLI, uv, GitHub Actions (`@v0.4`).

**Spec:** `docs/superpowers/specs/2026-11-02-guide-restructure-design.md`

## Global Constraints

- Kit version: **0.4.0** in all three places: `extend:` URL in `myst.yml`, `@v0.4` in `.github/workflows/course.yml`, local `neuromatch-course-kit==0.4.0`.
- `nma.content` is `- guide` only (the folders listed there are the only ones the kit processes); `tutorials/` and `projects/` no longer exist after Task 3.
- No Week/Day numbering, schedules or learning objectives in titles or bodies. Page titles are task-shaped and unique.
- Every page under `guide/` (static pages included); a page outside the root is ignored by the kit.
- Page template (spec section 5): `For:` label, 2-3 sentence intro, **You write**, **You get**, rules, **Next** links and reference entry.
- Author pages do not explain CI internals; maintainer pages do not explain MyST syntax. "Why Markdown, not notebooks" lives only on `start/what-is-the-kit.md`.
- `{nma-feedback}`, `{nma-solution}`, `{nma-explanation}` must stay top-level: show their source only with `{include} :literal:`, never a plain include.
- Pages with `{nma-feedback}` keep their old ids via `feedback_prefix` (list in Task 3).
- Never commit badge HTML, `.ipynb` under `guide/`, or `_nma/`, `notebooks/`, `_build/`.
- Kit behaviour is not changed here; fix kit issues in the kit repo.
- Each task ends green on `docs/superpowers/verify.sh` and is one commit (or commit group). Add every new page to `project.toc` in the same task that creates it.

## Review Focus

- **Feedback ids change on rename.** A renamed page with `{nma-feedback}` and no `feedback_prefix` silently sends new ids. Test: generated notebook for each of the six pages contains `content_review(f"<old prefix>_...` (Task 3).
- **Pages silently dropped.** A page outside `guide/` gets no checks and no notebook. Test: `notebooks` reports the same file count before and after the move (Task 3).
- **Relative assets break after a move** (`images/`, `data/`, `slides/`). Test: `check` passes (it rejects missing images/undeclared data) and `notebooks --dry-run` shows no errors (Task 3).
- **Stale names.** `W1D`, `W2D`, `Tutorial N`, `tutorials/`, `Day N` references and old filenames. Test: `verify.sh` greps `guide/`, `README.md`, `AGENTS.md`, `myst.yml` and fails on hits (Task 1 creates the grep, Task 3 clears it).
- **Region include renders empty or errors** when a marker is renamed. Test: example-pair check in `verify.sh` asserts every `:start-after:` marker exists exactly once in its target file (Task 6).
- **Scrolly render keys follow paths.** Test: `render-scrolly` writes `_build/scrolly/guide/author/scrolly.json` and `.../examples/lds/scrolly-page.json` (Task 3).

---

### Task 1: Branch, verification script, kit 0.4.0

**Files:**
- Create: `docs/superpowers/verify.sh`
- Modify: `myst.yml` (`extend:` and `nma:` block), `.github/workflows/course.yml` (3 `uses:` lines and the two comments), `tutorials/new_course.md`, `README.md` (version text only: `@v0.3` -> `@v0.4`, `@0.3` -> `@0.4`, `0.3` -> `0.4`)
- Modify: `.venv` (local install)

**Interfaces:**
- Produces: `docs/superpowers/verify.sh` (exit 0 = green) used by every later task.

- [ ] **Step 1:** `git checkout -b restructure-by-audience`.
- [ ] **Step 2: Write `docs/superpowers/verify.sh`.** It copies the repo (excluding `.git`, `.venv`, `notebooks`, `_build`) to `/tmp/verify`, then in the copy: runs `nma-kit check`, `nma-kit notebooks`, `nma-kit render-scrolly`, `nma-kit prepare-site`, `npx mystmd build --html` (log to `/tmp/verify/build.log`); fails on any `⛔` line except `Could not find DOI` and `Unsupported image extension ".txt"` (both are sandbox network artefacts); then greps the original tree (`guide/`, `README.md`, `AGENTS.md`, `myst.yml`) for `W[0-9]D[0-9]`, `tutorials/`, `Tutorial [0-9]`, `Day [0-9]`, `Week [0-9]` and fails on hits, except in `guide/examples/` (real NMA content) and the "history" parts of `AGENTS.md` it lists in an allowlist file `docs/superpowers/verify-allow.txt` (one `path:pattern` per line, starts empty). For the sandbox it patches the copy's `extend:` to `/tmp/kit/package/dist/nma.yml`, produced once by `npm pack @neuromatch/course-kit@<version>` into `/tmp/kit` (rewrite the plugin URL inside to the local `nma.mjs`); it skips the patch when `cdn.jsdelivr.net` is reachable.
- [ ] **Step 3:** Install the kit: `uv pip install neuromatch-course-kit==0.4.0` into `.venv`; `uv run nma-kit --version` prints `nma-kit 0.4.0`.
- [ ] **Step 4: Run `uv run nma-kit check` on the unchanged repo.** Expected: FAIL, `nma.content is required` (this is the red state).
- [ ] **Step 5:** Edit `myst.yml`: `extend:` -> `https://cdn.jsdelivr.net/npm/@neuromatch/course-kit@0.4/dist/nma.yml`; add under `nma:` `content: [tutorials, projects]` as a block list with a comment saying it names the folders the kit processes. Edit `course.yml`: `@v0.3` -> `@v0.4` (3 places) and update the comments. Update version mentions listed under Files.
- [ ] **Step 6: Run `verify.sh`.** Expected: all kit steps pass; the stale-name grep is expected to fail until Task 3, so run it with `SKIP_STALE=1` here (the script honours this variable) and confirm exit 0.
- [ ] **Step 7: Commit** `chore: move the guide to course kit 0.4.0 and declare nma.content`.

### Task 2: Finish the spikes

**Files:**
- Create (scratch, not committed): `/tmp/spike4/` copy
- Modify: `docs/superpowers/specs/2026-11-02-guide-restructure-design.md` (sections 6 and 11: record results)

**Interfaces:**
- Produces: decision A (region includes work or not; marker syntax) used by Task 6; decision B (redirects: yes/no, how) used by Task 3's last step.

- [ ] **Step 1:** In the scratch copy add `_snippets/region.md` containing `% region-start: demo`, a `{nma-solution}` block, `% region-end: demo`, and a page with ```` ```{include} ../_snippets/region.md ```` + `:literal: true`, `:lang: markdown`, `:start-after: % region-start: demo`, `:end-before: % region-end: demo`.
- [ ] **Step 2: Build it.** Expected: the built JSON for the page has a `code` node with `lang: markdown` whose value is the solution block and does not contain the `% region` lines. If not, try `<!-- region -->` markers and record which syntax works; if neither, record "use a fenced copy" and Task 6 switches to fenced code blocks in the example pages themselves.
- [ ] **Step 3:** Put the same region inside a `.md` page that has `kernelspec` and a real top-level `{nma-solution}` (the real example form). Expected: `nma-kit check` passes, the page builds, and `nma-kit notebooks` writes its notebook (this is the layout Task 6 uses).
- [ ] **Step 4:** Check whether mystmd 1.12 supports page redirects (`mystmd` docs: search "redirect" in `myst.yml` schema and site options). Record yes/no and the config key.
- [ ] **Step 5:** Read the 0.4.0 release notes (`https://github.com/neuromatch/course-kit/releases`) and list anything else that affects this repo.
- [ ] **Step 6: Commit** the spec update `docs: record spike results`.

### Task 3: Skeleton: move pages into `guide/`

**Files:**
- Create: `guide/{start,author,maintainer,instructor,reference,examples}/index.md` (one-paragraph stubs, title only: `Start here`, `For authors`, `For maintainers`, `For instructors`, `Reference`, `Examples`); `guide/index.md`
- Move (git mv), old -> new (relative to repo root; folder `tutorials/` and `projects/` are removed):

| Old | New |
|---|---|
| `tutorials/intro.md` | `guide/index.md` |
| `tutorials/new_course.md` | `guide/maintainer/create-a-course.md` |
| `W1D1_GettingStarted/W1D1_Tutorial1.md` | `guide/author/write-pages.md` |
| `.../W1D1_Tutorial2.md` | `guide/author/add-a-page.md` |
| `.../W1D1_Tutorial3.md` | `guide/author/figures-math-xrefs.md` |
| `.../W1D1_Tutorial4.md` | `guide/author/page-types.md` |
| `.../W1D1_Bonus.md` | `guide/author/more-myst.md` |
| `W1D2_InteractiveContent/W1D2_Tutorial1.md` | `guide/author/run-code-in-browser.md` |
| `.../W1D2_Tutorial2.md` | `guide/author/rich-outputs.md` |
| `.../W1D2_Tutorial3.md` | `guide/start/what-is-the-kit.md` |
| `.../W1D2_Tutorial4.md` | `guide/author/videos-and-slides.md` |
| `.../W1D2_Tutorial5.md` | `guide/author/images-and-data.md` |
| `.../W1D2_Tutorial6.md` | `guide/author/exercises.md` |
| `.../W1D2_Tutorial7.md` | `guide/author/scrolly.md` |
| `.../W1D2_Bonus.md` | `guide/reference/browser-limits.md` |
| `W1D3_PublishingAndCI/W1D3_Tutorial1.md` | `guide/maintainer/publish-with-ci.md` |
| `.../W1D3_Tutorial2.md` | `guide/maintainer/notebooks-and-badges.md` |
| `.../W1D3_Tutorial3.md` | `guide/maintainer/branding.md` |
| `.../W1D3_Tutorial4.md` | `guide/maintainer/instructor-site.md` |
| `.../W1D3_Bonus.md` | `guide/maintainer/structure-and-scale.md` |
| `W2D1_Examples/W2D1_Tutorial1.md` | `guide/examples/lds/normal-page.md` |
| `.../W2D1_Tutorial2.md` | `guide/examples/lds/scrolly-page.md` |
| `.../W2D1_Tutorial3.md` | `guide/examples/colab/heavy-compute.md` |
| `projects/**` | `guide/examples/projects/**` (each `README.md` -> `index.md`) |
| `W1D1_GettingStarted/images/*`, `W1D2_InteractiveContent/{data,images,slides}/*` | `guide/author/{images,data,slides}/` (no name collisions) |

- Delete: the four `chapter_intro.md` and, after merging them in Step 4, the four `further_reading.md`.
- Modify: `myst.yml` (`nma.content: [guide]`, `project.toc`), every moved page (links, `feedback_prefix`, titles).

**Interfaces:**
- Consumes: `verify.sh` (Task 1), decision B (Task 2).
- Produces: the final folder tree and slugs used by every later task; `project.toc` ordered as spec section 4 (Start here, authors, maintainers, instructors, reference, examples), each section an `index.md` parent with its pages as `children`.

- [ ] **Step 1:** Record the baseline: `uv run nma-kit notebooks --dry-run | tail -1` (file count) and the six feedback prefixes below. Run `uv run nma-kit render-scrolly` once and note the two scrolly JSON paths.
- [ ] **Step 2:** `git mv` per the table; create the six section `index.md` files and `guide/index.md` keeps the old intro text for now.
- [ ] **Step 3: Rewrite links mechanically** with a one-off script (not committed): for every old path in the table, replace link targets in all `guide/**/*.md` with the new relative path computed from the linking page. Leave prose such as "W1D2 Tutorial 6" for the later rewrite tasks (`verify.sh` keeps failing on them until Task 17; run it with `SKIP_STALE=1` until then).
- [ ] **Step 4: Merge the four `further_reading.md` into `guide/reference/further-reading.md`** (title `Further reading`, one page, sections: MyST, JupyterBook, Neuromatch, plus any page-specific links from the four, deduplicated); delete the four originals and the four chapter intros.
- [ ] **Step 5:** Set unique, task-shaped titles in frontmatter for every moved page (spec section 4 names). Drop `title:` groups.
- [ ] **Step 6:** Add `feedback_prefix:` to these pages (old default prefix): `author/page-types.md` -> `W1D1_T4`; `author/videos-and-slides.md` -> `W1D2_T4`; `author/scrolly.md` -> `W1D2_T7`; `maintainer/publish-with-ci.md` -> `W1D3_T1`; `examples/lds/scrolly-page.md` -> `W2D1_T2`. (`examples/lds/normal-page.md` and `examples/projects/example_macrocircuits/Macrocircuits.md` already set theirs; keep.)
- [ ] **Step 7:** `myst.yml`: set `nma.content` to `- guide`; rewrite `project.toc` per the Interfaces note; update `README.md`'s table row for `projects/` later (Task 18).
- [ ] **Step 8: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; `notebooks` file count equals Step 1's; `_build/scrolly/guide/author/scrolly.json` and `_build/scrolly/guide/examples/lds/scrolly-page.json` exist; every one of the five renamed pages with `{nma-feedback}` has its old prefix in the generated notebook (`grep -c 'content_review(f"' ` and check the `feedback_prefix` cell).
- [ ] **Step 9:** If decision B says redirects are supported, add redirects from the old URLs (`/tutorials/<slug>`) to the new pages; otherwise add a line to the PR description that old URLs break.
- [ ] **Step 10: Commit** `refactor: move the guide into guide/ by audience`.

### Task 4: Reference: directives and frontmatter

**Files:**
- Create: `guide/reference/directives.md`, `guide/reference/frontmatter.md`
- Modify: `guide/author/page-types.md` (replace the key tables with a link to `frontmatter.md`; keep the narrative), `myst.yml` toc

**Interfaces:**
- Produces: stable anchors `#nma-video`, `#nma-slides`, `#nma-solution`, `#nma-explanation`, `#nma-feedback`, `#nma-instructor`, `#nma-data`, `#step`, `#stage` in `directives.md`, and `#title` ... `#feedback_prefix` in `frontmatter.md`, linked from author pages (Tasks 8-11).

- [ ] **Step 1: `directives.md`:** one section per directive (nine) with: purpose, syntax block, options table (name, values, required), placement rule (top level, body allowed or not), what it becomes on the site / in notebooks / on the instructor site, and the `check` error it triggers. Source facts: this repo's `AGENTS.md` (Videos and slides, Feedback, Instructor notes, Exercises, Scrollytelling, Images and data files) and `uv run nma-kit check` messages. Start with a summary table (directive, one-line purpose, where it works, link to its feature page).
- [ ] **Step 2: `frontmatter.md`:** the keys table from `AGENTS.md` (`title`, `kernelspec`, `runtime`, `layout`, `feedback_prefix`, `site: hide_outline`) plus "warnings you can ignore" and "what CI checks" moved from the old Tutorial 4 text; keep `AGENTS.md`'s instruction that both stay in sync (update that line in Task 18).
- [ ] **Step 3: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green. Every directive name used in `check` rules appears in `directives.md` (`grep -c 'nma-' guide/reference/directives.md` >= 9 headings).
- [ ] **Step 4: Commit** `docs: add directive and frontmatter reference`.

### Task 5: Reference: `nma:` settings, CLI and check rules

**Files:**
- Create: `guide/reference/nma-config.md`, `guide/reference/cli.md`, `guide/reference/check-rules.md`
- Modify: `guide/start/what-is-the-kit.md` (replace its "Rules enforced by CI" list with a link to `check-rules.md`), `myst.yml` toc

**Interfaces:**
- Produces: `check-rules.md` with one anchor per rule group (`#exercises`, `#media`, `#feedback`, `#runtime`, `#scrolly`, `#content-roots`, `#assets`) linked from `fix-a-failing-check.md` (Task 8).

- [ ] **Step 1: `nma-config.md`:** every key of the `nma:` block: `content` (required; path or `{name, path}`; name = first folder under `notebooks/`; no overlap or nesting; reserved folders `notebooks`, `_build`, `_nma`, `node_modules`), `assets.{data,image,slides}`, `feedback.{url,project,user_key}`, `scrolly.pyodide_url`, `brand`, `style.extra`, `notebooks.branch`; values must be strings. Source: the kit's `nma_kit/config.py` docstring and `myst.yml.tmpl` in the 0.4.0 wheel. Include a migration note: `nma.paths` was removed in 0.4.0.
- [ ] **Step 2: `cli.md`:** each `nma-kit` command (`check`, `notebooks`, `render-scrolly`, `prepare-site`, `publish-notebooks`, `finalize-site`, `sync-assets`, `init`): what it does, who runs it (author/maintainer/CI-only), key flags from `uv run nma-kit <cmd> --help`, what it writes. Mark CI-only commands.
- [ ] **Step 3: `check-rules.md`:** the rules from `AGENTS.md` "Content rules" grouped as in the anchors above, each with a failing snippet (fenced, not rendered), the error text shape, and the fix. Verify each error text by actually triggering it in a scratch copy.
- [ ] **Step 4: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; no unresolved links.
- [ ] **Step 5: Commit** `docs: add nma settings, CLI and check rules reference`.

### Task 6: Example pages and region-include convention

**Files:**
- Create: `guide/examples/directives/index.md` and one page per feature as later tasks need them (this task creates `markdown-basics.md`, `video-and-slides.md`); `docs/superpowers/conventions.md` (marker syntax and rules)
- Modify: `docs/superpowers/verify.sh` (add the marker check), `AGENTS.md` (Task 18 finishes it)

**Interfaces:**
- Produces: the convention used by Tasks 8-11: in an example page, wrap each shown region in `% region-start: <name>` / `% region-end: <name>` (syntax confirmed in Task 2); a feature page shows it with a `{include}` block (`:literal: true`, `:lang: markdown`, `:start-after: % region-start: <name>`, `:end-before: % region-end: <name>`). `verify.sh` asserts each `:start-after:` marker occurs exactly once in the target file and the matching end marker too.

- [ ] **Step 1:** Write `conventions.md` (the rules above, plus: example pages hold the directives at top level; executable examples carry `kernelspec`; feature pages link to the live example for "You get").
- [ ] **Step 2:** Extend `verify.sh`: parse every `{include}` block in `guide/**/*.md` that has `:start-after:`; fail on a missing or duplicated marker.
- [ ] **Step 3: Create `video-and-slides.md` and `markdown-basics.md`** as real example pages with one region each (a `{nma-video}`, a `{nma-slides}` with `:path:` on the existing `author/slides/example_slides.pdf` copy or `:osf:`; a few admonitions and a table) and the directives at top level.
- [ ] **Step 4: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; negative test: temporarily rename one marker in an example page, run the marker check, expect FAIL naming the file, then revert.
- [ ] **Step 5: Commit** `docs: add example pages and the region-include convention`.

### Task 7: Author: Quick start and Fix a failing check

**Files:**
- Create: `guide/author/quick-start.md`, `guide/author/fix-a-failing-check.md`
- Modify: `myst.yml` toc (quick start first among the author pages)

**Interfaces:**
- Consumes: `check-rules.md` anchors (Task 5).
- Produces: `fix-a-failing-check.md` anchors per error family.

- [ ] **Step 1: `quick-start.md`:** three tiers: (1) open a pull request and use the preview link (prerequisite line: the maintainer enabled previews, same-repo PRs only, link `maintainer/pr-previews.md` which Task 14 creates; until then link `maintainer/publish-with-ci.md`); (2) optional `uv pip install neuromatch-course-kit && uv run nma-kit check`; (3) optional `uv run nma-kit sync-assets && uv run myst start`, with a table of what local preview does not show (badges, run-all fallback cell, generated notebooks, scrolly outputs unless `render-scrolly` is run). Includes "edit one page" walkthrough: change a sentence, open a PR, find the preview comment.
- [ ] **Step 2: `fix-a-failing-check.md`:** one section per error family from `check-rules.md`, each: the message as it appears in the CI log, why it happens, the fix, link to the rule. Also the "MyST warnings you can ignore" list (extra key ignored: `nma`, `runtime`, `layout`, `feedback_prefix`).
- [ ] **Step 3: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green.
- [ ] **Step 4: Commit** `docs: add author quick start and check troubleshooting`.

### Task 8: Author: write, add, figures, page types, more MyST

**Files:**
- Modify: `guide/author/{write-pages,add-a-page,figures-math-xrefs,page-types,more-myst}.md`
- Modify: `guide/examples/directives/markdown-basics.md` (extend regions as needed)

- [ ] **Step 1:** Rewrite each page to the template (spec section 5): `For: author` label, intro, You write / You get using the Task 6 convention (plain Markdown and admonitions may use include-twice inline), rules, Next links. Remove "Summary" sections, schedules and "Tutorial N" wording. Keep the pages' current facts; `write-pages.md` drops "Why MyST instead of notebooks" (now on `what-is-the-kit.md`); `add-a-page.md` gets the file + frontmatter + TOC entry steps and the naming/slug rules (including: the filename is the notebook name and default feedback prefix); `page-types.md` is the narrative (executable / static / Colab / scrolly) and links to `frontmatter.md` for keys.
- [ ] **Step 2: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; each rewritten page contains `## You write` and `## You get` (`grep -L` over the five pages returns nothing).
- [ ] **Step 3: Commit** `docs: rewrite author pages for writing and page types`.

### Task 9: Author: run code, rich outputs, images and data

**Files:**
- Modify: `guide/author/{run-code-in-browser,rich-outputs,images-and-data}.md` (these stay executable; keep `kernelspec`, `{nma-data}` and `data/`/`images/` references working)
- Modify: `guide/reference/browser-limits.md` (apply the reference style: tables, no tutorial voice)

- [ ] **Step 1:** Rewrite to the template. `images-and-data.md` merges the "where images and data files go" part of `figures-math-xrefs.md` (remove it there) with the existing data tutorial; the figure/data demo cells remain.
- [ ] **Step 2: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; the generated notebooks for these three pages still exist and the data cell downloads (`ls notebooks/guide/author/*.ipynb`).
- [ ] **Step 3: Commit** `docs: rewrite author pages for in-browser code and data`.

### Task 10: Author: exercises, videos and slides, feedback, instructor notes

**Files:**
- Modify: `guide/author/{exercises,videos-and-slides}.md`
- Create: `guide/author/feedback.md`, `guide/author/instructor-notes.md`, `guide/examples/directives/{exercise,feedback,instructor}.md`
- Modify: `guide/examples/directives/video-and-slides.md` (as needed)

**Interfaces:**
- Consumes: Task 6 convention; `directives.md` anchors.

- [ ] **Step 1:** Create the three example pages with real top-level directives and regions: `exercise.md` (with `kernelspec`: an exercise cell, its `{nma-solution}`, an `{nma-explanation}`), `feedback.md` (`{nma-feedback} Demo_Section`; needs the `nma.feedback` settings already in `myst.yml`), `instructor.md` (`{nma-instructor}`).
- [ ] **Step 2:** Split the old Tutorial 4 content into `videos-and-slides.md`, `feedback.md`, `instructor-notes.md` (each to the template, You write = literal include of the region, You get = link to the live example and, for video/slides, an inline include-twice). Keep `feedback_prefix` only on the page that still contains `{nma-feedback}` (if `videos-and-slides.md` no longer has one, move `W1D2_T4` to whichever page keeps the live feedback demo; otherwise drop it).
- [ ] **Step 3:** Rewrite `exercises.md` to the template; keep its live exercise and the "Run all" explanation.
- [ ] **Step 4: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; marker check passes; `nma-kit check` accepts the example pages (exercise has its solution directly after).
- [ ] **Step 5: Commit** `docs: split and rewrite author pages for media, feedback and exercises`.

### Task 11: Author: scrollytelling and convert a notebook

**Files:**
- Modify: `guide/author/scrolly.md` (stays `layout: scrolly`; keep `site: hide_outline: true`)
- Create: `guide/author/convert-a-notebook.md`
- Modify: `guide/start/what-is-the-kit.md` (remove the "Bringing in an existing notebook" section, now owned by `convert-a-notebook.md`)

- [ ] **Step 1: `convert-a-notebook.md`:** the cell-mapping table and conversion checklist from `AGENTS.md`, plus an NMA-specific section (feedback prefix, video/slides cells, `to_remove` markers) taken from the old Tutorial 4 "Converting an existing NMA notebook" text; You write/You get uses the LDS example (`examples/lds/normal-page.md` is the converted result; link it).
- [ ] **Step 2:** Keep `scrolly.md` as a how-to page that is itself scrolly; reword headers so the page does not use "tutorial" wording; link `examples/lds/scrolly-page.md` for the full example and literal-include a small `{step}`/`{stage}` region from it.
- [ ] **Step 3: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green; `_build/scrolly/guide/author/scrolly.json` exists and has no `error` entries.
- [ ] **Step 4: Commit** `docs: rewrite scrolly page and add notebook conversion guide`.

### Task 12: Maintainer: create a course, publish, previews

**Files:**
- Modify: `guide/maintainer/create-a-course.md`, `guide/maintainer/publish-with-ci.md`
- Create: `guide/maintainer/pr-previews.md`

**Interfaces:**
- Produces: `pr-previews.md` anchors `#cloudflare`, `#enable-previews`, `#limits`, linked from `author/quick-start.md` (update the Task 7 link).

- [ ] **Step 1:** `create-a-course.md`: `For: maintainer`; steps from the old `new_course.md` (`nma-kit init`, generated files table, first push). Add the 0.4.0 note that `init` writes `nma.content`. Remove the "Where this book fits" and "Getting kit updates" sections (the latter moves to Task 14).
- [ ] **Step 2:** `publish-with-ci.md`: the workflow, what runs on PR vs `main`, GitHub Pages setup; move the previews text out to `pr-previews.md`.
- [ ] **Step 3:** `pr-previews.md`: Cloudflare Pages setup, secrets (`CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`) and variable (`CLOUDFLARE_PROJECT`), `init --preview`, same-repo PRs only, `notebooks-pr-<n>` branch, the comment, cleanup on close.
- [ ] **Step 4:** Update the `quick-start.md` link to `pr-previews.md`.
- [ ] **Step 5: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green.
- [ ] **Step 6: Commit** `docs: rewrite maintainer pages for setup, CI and previews`.

### Task 13: Maintainer: notebooks and badges, instructor site

**Files:**
- Modify: `guide/maintainer/{notebooks-and-badges,instructor-site}.md`
- Create: `guide/instructor/what-you-get.md`

- [ ] **Step 1:** Rewrite `notebooks-and-badges.md` to the template; update notebook paths to the 0.4.0 form `notebooks/<root>/<folder>/<stem>.ipynb` (here `notebooks/guide/...`).
- [ ] **Step 2:** Rewrite `instructor-site.md` as the maintainer-only setup (Cloudflare variable and secrets, `instructor-cloudflare-project`, previews, local build `NMA_AUDIENCE=instructor`); move "what instructors see" to `instructor/what-you-get.md` (`For: instructor`: solutions and explanations inline, instructor notes box, instructor notebooks, the site is not access-controlled).
- [ ] **Step 3: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green.
- [ ] **Step 4: Commit** `docs: rewrite maintainer pages for notebooks and instructor site; add instructor page`.

### Task 14: Maintainer: branding, structure and scale, project booklet, upgrade

**Files:**
- Modify: `guide/maintainer/{branding,structure-and-scale}.md`
- Create: `guide/maintainer/project-booklet.md`, `guide/maintainer/upgrade-the-kit.md`

- [ ] **Step 1:** `branding.md` to the template.
- [ ] **Step 2:** `structure-and-scale.md`: TOC format and naming, multi-week, precourse, splitting repos, and a new section **Content folders** teaching `nma.content` (single root, several roots, `{name: guide, path: docs/guide}`, notebook naming under `notebooks/<name>/...`, roots cannot nest, files outside roots are ignored) with this book's own `guide` root as the example.
- [ ] **Step 3:** `project-booklet.md`: the old "Projects section" text plus the `examples/projects/index.md` "How to structure your project booklet" section (remove it there, link here); show the two-root configuration (`tutorials` + `projects`) that `init` writes, and link the example pages.
- [ ] **Step 4:** `upgrade-the-kit.md`: the "Getting kit updates" content (three places, `@v0.4` meaning, pinning, run `check`) and the 0.3 -> 0.4 migration (add `nma.content`, remove `nma.paths`, notebook path layout, bump all three).
- [ ] **Step 5: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green.
- [ ] **Step 6: Commit** `docs: rewrite maintainer pages for branding, structure, projects and upgrades`.

### Task 15: Start here: what is the kit, which path, landing

**Files:**
- Modify: `guide/start/what-is-the-kit.md`, `guide/index.md`
- Create: `guide/start/which-path.md`
- Modify: `guide/{start,author,maintainer,instructor,reference,examples}/index.md` (real section landing pages: one-line description plus the page list with one-line summaries, no duplication of the TOC order)

- [ ] **Step 1: `what-is-the-kit.md`:** the model in one page: Markdown is the only source; what CI makes (site, notebooks on `notebooks-branch`, badges, instructor site); what students get; "why Markdown" (moved here only). Include a small diagram as a table or ASCII flow (md -> site, notebooks, solutions).
- [ ] **Step 2: `which-path.md`:** three cards (Author, Maintainer, Instructor) each with who it is for, 3-4 typical tasks as links, and a "start here" link.
- [ ] **Step 3: `guide/index.md`:** short landing: what this book is, link to `which-path.md`, link to the reference, licence sentence; remove the Why-MyST and prerequisites sections (prerequisites move to `quick-start.md` and `create-a-course.md`).
- [ ] **Step 4: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green.
- [ ] **Step 5: Commit** `docs: add the orientation pages and section landings`.

### Task 16: Examples section polish

**Files:**
- Modify: `guide/examples/index.md`, `guide/examples/lds/{normal-page,scrolly-page}.md`, `guide/examples/colab/heavy-compute.md`, `guide/examples/projects/index.md`, `guide/examples/directives/index.md`

- [ ] **Step 1:** `examples/index.md`: label the section as showcases, link the LDS pair, the Colab page, the directive examples and the projects, say which feature pages use which example. Page titles: `Linear dynamical systems (normal page)`, `Linear dynamical systems (scrolly page)`, `A heavy-compute page (Colab)`; keep the page bodies as NMA content, but replace in-body "Tutorial N" / "W1D2 Tutorial 6" references that point to guide pages with links to the new pages.
- [ ] **Step 2:** `examples/directives/index.md`: table of example pages, which feature page uses each, and the marker names.
- [ ] **Step 3: Run `verify.sh` (`SKIP_STALE=1`).** Expected: green.
- [ ] **Step 4: Commit** `docs: polish the examples section`.

### Task 17: Cross-links, titles and the stale-name sweep

**Files:**
- Modify: any `guide/**/*.md` with hits; `docs/superpowers/verify-allow.txt` (only for real NMA content under `guide/examples/`, one `path:pattern` per line)

- [ ] **Step 1:** Run `verify.sh` without `SKIP_STALE`. Fix every hit (stale `W1D`, `W2D`, `Tutorial N`, `Day N`, `Week N`, `tutorials/`) by rewriting the sentence to link the new page by its task-shaped title.
- [ ] **Step 2:** Check titles: no two pages share a `title:` (`grep -h '^title:' -r guide | sort | uniq -d` prints nothing) and every non-index page begins with a `For:` label (`grep -L '^For: ' guide/{author,maintainer,instructor}/*.md` prints only `index.md` files).
- [ ] **Step 3:** Check each audience path by reading it start to finish through the built site (`/tmp/verify/_build/html`): Author (quick start to scrolly), Maintainer (create a course to upgrade), Instructor (what you get). Fix dead ends.
- [ ] **Step 4: Run `verify.sh`.** Expected: exit 0, no `SKIP_STALE`.
- [ ] **Step 5: Commit** `docs: fix stale names and cross-links`.

### Task 18: README, AGENTS.md and CI

**Files:**
- Modify: `README.md`, `AGENTS.md`

- [ ] **Step 1: `README.md`:** make it a pointer: what the repo is, the live link, the three audiences with one link each, how to work on it (`uv run nma-kit check`, `sync-assets`, `myst start`), no repeated `init` walkthrough (link `guide/maintainer/create-a-course.md`).
- [ ] **Step 2: `AGENTS.md`:** update Architecture (the `guide/` tree and `nma.content: [guide]`, no `tutorials/` or `projects/`), the stale notebook paths (`notebooks/guide/...`), "Adding a new day" -> "Adding a page" (pick the section; add to `project.toc`; stems become notebook names and feedback prefixes), the `{nma-feedback}` prefix note, the frontmatter table pointer (`guide/reference/frontmatter.md`, keep both in sync), `@v0.4`/`extend` `0.4`, the conventions for example pages and region includes (link `docs/superpowers/conventions.md`), and a note that the guide differs from `init` output only in folder names.
- [ ] **Step 3: Run `verify.sh`.** Expected: exit 0.
- [ ] **Step 4:** Push the branch and open a PR (`git push -u origin restructure-by-audience`, `gh pr create --fill`). Expected: the `course-check` job passes; if Cloudflare is configured, open the preview and spot-check one page per section and the two scrolly pages.
- [ ] **Step 5: Commit** `docs: update README and AGENTS for the new structure` (before the push).
