---
title: "Feedback widgets"
---

# Feedback widgets

For: author

`{nma-feedback}` adds a row of 🙂 😐 🙁 buttons that sends feedback about one section to the course's datatops project. The widget is plain JavaScript, so it works before the kernel starts. Never write `content_review(...)` cells or the vibecheck import by hand.

## You write

```{include} ../examples/directives/feedback.md
:literal: true
:lang: text
:start-after: % region-start: feedback
:end-before: % region-end: feedback
```

The argument is the section name. Where the feedback goes is set once in `myst.yml`, by your maintainer ([`nma:` settings](../reference/nma-config.md)).

## You get

A live widget is on the [Feedback widget example](../examples/directives/feedback.md). 🙂 is sent right away; 😐 and 🙁 first ask for a comment. Each response posts `{button_name, feedback, section_id, timestamp_utc}` to the project, with the section id `<prefix>_<name>`.

In a generated notebook each directive becomes a hidden `# @title Submit your feedback` cell with `content_review(f"{feedback_prefix}_<name>")`, and one hidden "Import feedback gadget" cell at the top installs `vibecheck` and sets `feedback_prefix`.

## Rules

- **Section name:** letters, digits and underscores, unique on the page.
- **Prefix:** the frontmatter `feedback_prefix` if set, otherwise derived from the file name (`W<week>D<day>_Tutorial1` becomes `W<week>D<day>_T1`; any other name is used as it is). Renaming a page without setting `feedback_prefix` changes its ids ([Frontmatter keys](../reference/frontmatter.md#feedback-prefix)). MyST logs `extra key ignored: feedback_prefix`, which is expected.
- **Settings:** once any page uses the directive, `myst.yml` needs `nma.feedback.url`, `.project` and `.user_key`. Use your course's own project, never another course's. The `user_key` only allows adding responses and is published in every notebook, so it is not a secret.
- Top level, no options, no body. `check` rejects a hand-written feedback cell ([Rules enforced by `check`](../reference/check-rules.md#rules-feedback)).

## Next

- [Instructor notes](instructor-notes.md)
- [Convert an existing notebook](convert-a-notebook.md)
- Reference: [`{nma-feedback}`](../reference/directives.md#nma-feedback)
