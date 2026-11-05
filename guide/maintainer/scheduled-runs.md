---
title: "Scheduled notebook runs"
---

# Scheduled notebook runs

For: maintainer

Tutorials rot quietly. A library releases a new version, Colab updates its runtime image, and a notebook that worked in June stops working in October, with nobody looking. The kit's **nightly workflow** runs every generated notebook end to end on a schedule, in Google's Colab runtime image, and opens one GitHub issue when something breaks. Nothing is published. It needs kit 0.4.1 or newer and is optional.

## You write

Copy one file into your course repository, `.github/workflows/nightly.yml`. This guide's own copy is below, so the page always shows what actually runs. New and existing courses alike add it by hand: `nma-kit init` does not write it.

```{literalinclude} ../../.github/workflows/nightly.yml
:language: yaml
```

Then:

1. **Commit it to the default branch.** GitHub only runs scheduled workflows from there.
2. **Allow issues.** The job needs `issues: write`, which the file grants, and Issues must be enabled in the repository settings.
3. **Start a first run by hand** from the **Actions** tab (**Nightly notebooks → Run workflow**) instead of waiting for the night. Leave `runtime` empty to run everything.

The `cron` lines are the schedule (UTC). Change the hours as you like, but keep the Sunday line and the expression in `runtime:` identical: the workflow compares the two strings to decide which notebooks to run. As in [Publish with CI](publish-with-ci.md), `@v0.4` follows the newest 0.4.x, and an exact tag such as `@v0.4.1` freezes the course.

## You get

- **A nightly run of the browser notebooks and a weekly run of the Colab ones.** Pages with the default `runtime: browser` run every night at 04:00. Pages with `runtime: colab` (PyTorch, big datasets, long training) are heavier and run on Sundays at 05:00 ([`runtime`](../reference/frontmatter.md#runtime)).
- **The instructor notebooks, not the student ones.** The solutions are filled in, so a correct notebook never raises on purpose. The student notebooks differ only by the exercise stubs and solution links, which `nma-kit check` already validates.
- **Colab's own environment.** Each notebook runs in Colab's Docker image with that image's Python and packages. The kit is installed on top without its dependencies, so it cannot change what the notebook sees. A pass here means it passes in Colab, not just on your laptop.
- **A result per notebook:**

  | State | Meaning |
  |---|---|
  | `passed` | Every cell ran. |
  | `failed` | A cell raised. The report names the notebook, the cell and the last line of the error. |
  | `timeout` | The notebook used more than its time budget (20 minutes by default). |
  | `needs-check` | A `runtime: colab` notebook failed or timed out. The job runs on CPU, so this may only mean "needs a GPU": open it in Colab with a GPU to confirm. It does not turn the run red. |

- **One issue, not one per night.** Failures go to the job summary and to a single issue with the label `course-nightly`. Each run adds a comment while problems remain, and closes the issue when everything passes.
- **Parallel jobs that share the work.** The Colab image is large, so the notebooks are dealt out to at most four jobs. Each job downloads the image once and runs its notebooks in turn.

## Rules

- **It runs on CPU.** A GPU notebook that needs one will end as `needs-check`, so it still needs an occasional manual look. Keep `runtime: colab` on any page that does not run in the browser, so a CPU failure does not raise a false alarm.
- **Only pages with a `kernelspec` run.** Static pages have no notebook.
- **Notebooks must be self-contained.** A notebook that downloads data or installs packages needs network access at run time. Declare the files it reads with `{nma-data}` ([Images and data](../author/images-and-data.md)).
- **The workflow follows `latest` Colab by default.** That is the point (you hear about breakage early), but a failure may come from Colab rather than from your page. To freeze the image, pass a tag to the reusable workflow's `colab-image` input.
- **Tuning.** The reusable workflow also takes `timeout` (seconds per notebook, default 1200), `shards` (default 4), `open-issue` (default true), `requirements` (default `requirements.txt`) and `working-directory`. Add them under `with:` in `nightly.yml`.
- **Run it locally** with the same commands the job uses. The notebooks run in your own Python, not in Colab's image, so a local pass proves less than the nightly one:

```bash
uv run nma-kit notebooks
uv run nma-kit run-notebooks                 # all of them
uv run nma-kit run-notebooks --runtime colab # only the runtime: colab pages
```

## Next

- [Publish with CI](publish-with-ci.md)
- [Notebooks, branches and badges](notebooks-and-badges.md)
- [Upgrade the kit](upgrade-the-kit.md)
- Reference: [`nma-kit` commands](../reference/cli.md#cmd-run-notebooks)
