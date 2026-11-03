---
title: "What is the course kit?"
---

# What is the course kit?

All course content in a kit course is written in MyST Markdown (`.md`).
Jupyter notebooks are still produced for Colab and Kaggle, but CI generates them.
They are never written or edited by hand, and never committed to `main`.

## How content flows

```
tutorials/W1D2_.../W1D2_Tutorial1.md     <- you edit this
        │
        ├── myst build ──────────────►  the website (with Colab/Kaggle badges)
        │
        └── jupytext (CI) ───────────►  notebooks-branch:
                                          notebooks/W1D2_.../W1D2_Tutorial1.ipynb
                                          (opened by the Colab/Kaggle badges)
                                          plus instructor/ and solutions/
```

Every page that has a `kernelspec` in its frontmatter goes down both paths. See
Day 3, Tutorial 2 for the details of notebook generation and badges.

## Why not commit `.ipynb` files?

- **Clean git history**: no output blobs or metadata churn in diffs
- **Easy review**: collaborators read plain text, not JSON
- **One source of truth**: the website and the notebooks can't drift apart,
  because both come from the same `.md` file

## Rules enforced by CI

`nma-kit check` runs in CI and fails the build on any violation: no `.ipynb` files in the content folders, pages with code need a `kernelspec`, exercises need solutions, and more. The full list is in [Rules enforced by `check`](../reference/check-rules.md).

## Bringing in an existing notebook

If you receive a `.ipynb`, convert it once to Markdown and delete the original. The steps are in [Convert an existing notebook](../author/convert-a-notebook.md).
