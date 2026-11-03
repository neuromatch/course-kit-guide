---
title: "Project booklet"
---

# Project booklet

For: maintainer

Most Neuromatch courses add a project booklet next to the tutorials: guidance for students, dataset guides and starter notebooks. It is ordinary pages in a content folder of its own, so the kit checks them and builds notebooks for the ones with code. This page shows how to set it up. For real pages to copy, see the [project booklet examples](../examples/projects/index.md).

## You write

A course made by `nma-kit init` has two content folders, `tutorials` and `projects`:

````text
nma:
  content:
    - tutorials
    - projects
````

Add the project pages to `projects/`, with the landing page as the parent entry in `project.toc` (don't wrap it in a `title:` group, which would list it twice in the sidebar):

````text
- file: projects/index.md
  children:
    - file: projects/project_guidance.md
    - file: projects/datasets.md
````

A project introduction usually has an overview of the project format, the timeline and milestones, links to datasets, and guidance on the modelling workflow.

## You get

- Plain pages (guidance, timelines, submission links) with no `kernelspec`: static, no notebook.
- Starter notebooks as pages with a `kernelspec`, which get student and instructor notebooks under `notebooks/projects/...` and Colab and Kaggle badges.
- A project notebook that depends on heavy libraries or large downloads uses `runtime: colab`, so the site shows its code read-only with a banner linking to Colab and Kaggle ([Page types](../author/page-types.md)).

The examples show the three kinds of page a booklet needs: [guidance for students](../examples/projects/project_guidance.md) (no code), [a full project notebook](../examples/projects/example_macrocircuits/Macrocircuits.md) and [a dataset chooser](../examples/projects/example_neurons/index.md) with a starter page.

## Rules

- Images in booklet pages may be linked from the upstream course repository instead of copied, to keep your repository small. A displayed image that is a local file must exist in the page's `images/` folder.
- The booklet is just another content folder: the same rules as tutorials apply ([Rules enforced by `check`](../reference/check-rules.md)).
- This guide keeps its project examples under `examples/projects/` inside its single `guide` content folder; a real course keeps `projects` as its own folder.

## Next

- [Structure and scale](structure-and-scale.md)
- [Project booklet examples](../examples/projects/index.md)
