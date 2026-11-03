---
title: "Add a page"
---

# Add a page

For: author

A new page is a Markdown file under one of the course's content folders, plus one entry in the table of contents. The table of contents is a list in `myst.yml`; nothing generates it, so a page that is not listed in it does not appear in the sidebar.

## You write

A new file `guide/author/my-topic.md` (in your course, the folder is whichever one `nma.content` lists):

````text
---
title: "My topic"
kernelspec:
  name: python3
  display_name: Python 3
---

# My topic

Text and `{code-cell}` blocks go here.
````

Leave out `kernelspec` for a page without code. Then list the page in `project.toc` in `myst.yml`, under the section it belongs to:

````text
project:
  toc:
    - file: guide/author/index.md
      children:
        - file: guide/author/my-topic.md
````

## You get

After you push, the page appears in the sidebar under its section parent, builds on the pull request preview, and (if it has a `kernelspec`) gets a student notebook, an instructor notebook and Colab and Kaggle badges.

## Rules

- **Section parents.** Make the section's `index.md` the top-level entry and list its pages as `children`. Don't wrap it in a `title:` group: the section then appears twice in the sidebar, once as the group and once as the index page.
- **File names matter.** The file name (without `.md`) names the generated notebook and its solution files. It also sets the default id prefix of feedback widgets (`W<week>D<day>_Tutorial1` becomes `W<week>D<day>_T1`; any other name is used as it is). Renaming a page that has feedback widgets changes those ids unless you set `feedback_prefix` ([Frontmatter keys](../reference/frontmatter.md#feedback-prefix)).
- **Neuromatch Academy courses** name day folders `W<week>D<day>_<Topic>` with `W<week>D<day>_Tutorial<n>.md` pages. Other courses can use any names.
- **Inside a content folder.** A page outside every folder listed in `nma.content` is ignored by the kit: no checks and no notebook ([`nma:` settings](../reference/nma-config.md#nma-content)).
- **Static pages** (intros, further reading) have no `kernelspec`, so nothing runs and no notebook is made.
- Run `uv run nma-kit check` before pushing ([Quick start](quick-start.md)).

## Next

- [Page types](page-types.md)
- [Structure and scale](../maintainer/structure-and-scale.md) for sections and multi-week courses
- Reference: [Frontmatter keys](../reference/frontmatter.md)
