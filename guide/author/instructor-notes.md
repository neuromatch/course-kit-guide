---
title: "Instructor notes"
---

# Instructor notes

For: author

Teaching notes (timing, common mistakes, what to say) go in `{nma-instructor}`. Students never see them: the note is removed from the student site and from every generated notebook, and appears as an "Instructor notes" box on the instructor site.

## You write

The body is Markdown:

```{include} ../examples/directives/instructor.md
:literal: true
:lang: text
:start-after: % region-start: instructor
:end-before: % region-end: instructor
```

## You get

On the student site, nothing: the [Instructor note example](../examples/directives/instructor.md) page shows the note only to the instructor build. On the instructor site the note appears in a labelled box ([Instructor site](../maintainer/instructor-site.md), [What instructors get](../instructor/what-you-get.md)).

## Rules

- Top level of the page, with no argument and no options, and a non-empty Markdown body.
- Not supported on pages with `layout: scrolly`.
- The instructor site is a second build of the same course. It is **not access controlled**: don't put anything in a note that must stay secret.

## Next

- [Exercises, solutions and explanations](exercises.md) (answers for instructors)
- [Instructor site](../maintainer/instructor-site.md)
- Reference: [`{nma-instructor}`](../reference/directives.md#nma-instructor)
