---
title: "Structure and scale"
---

# Structure and scale

For: maintainer

`nma-kit init` creates one example day. This page is how to grow it into a full course: how the table of contents and the content folders work, how to add days, weeks and a precourse, and how to organise a large course. The kit needs two things only: pages live in a folder listed in `nma.content`, and they are listed in `project.toc`.

## You write

### The table of contents

The table of contents is a list in `myst.yml` under `project.toc`. Nothing generates it: a page that is not listed does not appear in the sidebar. Make each section's `index.md` the top-level entry and list its pages as `children`. Don't wrap the index in a `title:` group, which would list the section twice in the sidebar.

````text
project:
  toc:
    - file: guide/index.md
    - file: guide/week1/index.md
      children:
        - file: guide/week1/day1/index.md
          children:
            - file: guide/week1/day1/tutorial1.md
            - file: guide/week1/day1/tutorial2.md
        - file: guide/week1/day2/index.md
````

The Neuromatch Academy convention names day folders `W<week>D<day>_<Topic>` with `W<week>D<day>_Tutorial<n>.md` pages. Other courses can name folders as they like: the kit only needs the pages to be listed in `project.toc`.

### Content folders

`nma.content` lists the folders whose pages the kit checks and converts to notebooks. It is required since kit 0.4.0 and has no default:

````text
nma:
  content:
    - guide
````

This guide uses a single folder, `guide`. A course made by `nma-kit init` uses two, one per kind of content:

````text
nma:
  content:
    - tutorials
    - projects
````

Give a folder a different notebook name with `{name, path}`:

````text
nma:
  content:
    - tutorials
    - {name: booklet, path: docs/project-booklet}
````

### Adding days, weeks and a precourse

Add a folder per day, list it in `project.toc`, and push to `main`: CI handles notebook generation and deployment. For more weeks, repeat the pattern with the next week number. For prerequisite material, add a precourse folder and register it as the first section before week 1.

## You get

- **One notebook tree per content folder.** A page at `<path>/<folder>/<page>.md` becomes `notebooks/<name>/<folder>/<page>.ipynb` on the notebooks branch. The **name** is the first folder under `notebooks/`: it defaults to the path, and `{name, path}` overrides it.
- **Pages outside every content folder are ignored** by the kit: no checks, no notebook, no badges.
- **Section pages** in the sidebar, without duplicates, when each section's index is the parent entry.

## Rules

- Folders in `nma.content` cannot overlap or nest, must be inside the course (no `.` or `..`) and cannot be under `notebooks`, `_build`, `_nma` or `node_modules`. Names use letters, digits, `-`, `_` and `/`, and are unique ([`nma:` settings](../reference/nma-config.md#nma-content)).
- Every page the course publishes must be both under a content folder and listed in `project.toc`.
- Renaming or moving a folder changes the notebook URLs. Renaming a page *file* also changes the default feedback ids of its widgets unless `feedback_prefix` is set ([Add a page](../author/add-a-page.md)).
- **Large courses with content in several repositories:** the kit's workflows build the repository they run in and have no step for fetching other repositories. Bring the content into one repository before it builds, for example with a separate workflow that syncs it in.

## Next

- [Project booklet](project-booklet.md)
- [Upgrade the kit](upgrade-the-kit.md)
- Reference: [`nma:` settings](../reference/nma-config.md)
