---
title: "Which path are you?"
---

# Which path are you?

For: everyone

This guide has a path for each kind of reader. Pick the one that matches what you do.

## Pick your path

| If you… | You are an | Start here |
|---|---|---|
| Write or convert tutorials in an existing course repository | **Author** | [Quick start](../author/quick-start.md) |
| Create the course repository, run CI, branding, previews or the instructor site | **Maintainer** | [Create a course](../maintainer/create-a-course.md) |
| Teach with the course and read the instructor site | **Instructor / TA** | [What instructors get](../instructor/what-you-get.md) |

## Typical tasks

**Author.** Typical tasks:

- [Add a page](../author/add-a-page.md) and [write it](../author/write-pages.md).
- [Add an exercise with a solution](../author/exercises.md).
- [Embed a video or slides](../author/videos-and-slides.md) and [feedback widgets](../author/feedback.md).
- [Convert an existing notebook](../author/convert-a-notebook.md).
- [Fix a failing check](../author/fix-a-failing-check.md).

**Maintainer.** Typical tasks:

- [Create a course](../maintainer/create-a-course.md) with `nma-kit init`.
- [Publish with CI](../maintainer/publish-with-ci.md) and turn on [pull request previews](../maintainer/pr-previews.md).
- Catch broken tutorials early with [scheduled notebook runs](../maintainer/scheduled-runs.md).
- [Set up the instructor site](../maintainer/instructor-site.md).
- [Change branding](../maintainer/branding.md) and [upgrade the kit](../maintainer/upgrade-the-kit.md).

**Instructor.** Typical tasks:

- [Find solutions, explanations and teaching notes](../instructor/what-you-get.md).

**Everyone** can look things up in the [Reference](../reference/index.md), or copy from the [Examples](../examples/index.md).

## Good to know

- You can be more than one. An author on a small course is often the maintainer too.
- Authors never need to touch CI or `myst.yml` beyond the table of contents; maintainers rarely write course content.
- Developing the kit itself (the plugin and the CLI) is out of scope here: see [neuromatch/course-kit](https://github.com/neuromatch/course-kit).

## Next

- [What is the course kit?](what-is-the-kit.md)
