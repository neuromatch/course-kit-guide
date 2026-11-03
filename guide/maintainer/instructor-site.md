---
title: "Instructor site"
---

# Instructor site

The same course can be published a second time for teaching
assistants and instructors, at its own address such as
`instructor.<course domain>`. It is built from the same `.md` files as the
student site. Nothing is duplicated or maintained by hand.

## How it differs from the student site

| | Student site | Instructor site |
|---|---|---|
| `{nma-solution}`, `{nma-explanation}` | A *Click for solution* link | The content inline, in collapsed boxes |
| Colab and Kaggle buttons | The student notebooks | The **instructor notebooks** (solutions filled in) |
| `{nma-instructor}` notes | Removed | An "Instructor notes" box |
| Search engines | Indexed | `robots.txt` with `Disallow: /`, a `noindex` header, no sitemap |

The instructor build is selected by one environment variable,
`NMA_AUDIENCE=instructor`. It has no `myst.yml` key, and `nma-kit check`
rejects any value other than `student` (the default) or `instructor`.

:::{admonition} Not access controlled
:class: warning
The instructor site is a convenience view, not a secret. The solutions stay
on the public notebooks branch, so students who look for them can find them.
Never put anything in `{nma-instructor}` that you could not tolerate students reading in the repository.
Notes are removed from the student site and notebooks, but they are in the `.md` source on `main`.
:::

## Writing instructor notes

`{nma-instructor}` takes Markdown, goes at the top level of a page, and has no
argument or options:

````markdown
:::{nma-instructor}
Allow 10 minutes here. Students often forget the sign of the drift term.
:::
````

See [Tutorial 4 of Day 2](../author/videos-and-slides.md) for a live
example (it is invisible on the student site and shows on the instructor site).

## Turning it on

The instructor site is deployed to [Cloudflare Pages](https://pages.cloudflare.com),
like the pull request previews, and uses the same two secrets. Once per course
repository:

1. Optional: in Cloudflare, create a Pages project (Workers & Pages → Create →
   Pages → Direct Upload), for example `my-course-instructor`. The first deploy
   creates it otherwise.
2. In the repository (Settings → Secrets and variables → Actions), add the
   secrets `CLOUDFLARE_API_TOKEN` (permission *Cloudflare Pages: Edit*) and
   `CLOUDFLARE_ACCOUNT_ID`, and the variable `CLOUDFLARE_INSTRUCTOR_PROJECT`
   with the project name.
3. Check that the `publish` job in `.github/workflows/course.yml` passes
   `instructor-cloudflare-project` and `secrets: inherit`. `nma-kit init` writes
   them, and this book's copy on [Tutorial 1](publish-with-ci.md) shows them.
4. Push to `main`, so that the project gets its first deployment.
5. In the Cloudflare project: Custom domains → Set up a custom domain →
   `instructor.<course domain>`. If the domain's DNS is on Cloudflare, accept the
   CNAME it offers. Otherwise add a CNAME from `instructor` to
   `<project>.pages.dev` at your DNS provider. The kit does not manage DNS.
6. Check it: a solution shows inline, and `/robots.txt` says `Disallow: /`.

Without the variable or the secrets the job is skipped and nothing else changes.

## Previews of the instructor site

When `CLOUDFLARE_INSTRUCTOR_PROJECT` is set, every pull request is built a second
time as the instructor site. The preview comment then carries two links,
`https://pr-<number>.<project>.pages.dev` and
`https://pr-<number>.<instructor project>.pages.dev`. The instructor preview goes to the
instructor project as the branch `pr-<number>`, never to its production branch,
and closing the pull request removes both.

## Building it locally

Export the audience so that every command sees it:

```bash
export NMA_AUDIENCE=instructor
uv run nma-kit prepare-site && uv run myst build --html && uv run nma-kit finalize-site
git checkout -- tutorials projects myst.yml   # undo prepare-site
```

`finalize-site` replaces the `robots.txt` and removes the sitemap that MyST
writes (they would list `http://localhost:3000` URLs). It runs for the student
site too.

## Instructor notebooks

`notebooks/<Day>/instructor/<Tutorial>.ipynb` holds the solutions as code cells,
and the instructor site's buttons open them. `{nma-instructor}` notes never reach
any notebook.
