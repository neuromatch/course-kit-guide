---
title: "Pull request previews"
---

# Pull request previews

For: maintainer

Reviewers read Markdown diffs, so they never see scrolly pages, editable cells or the Colab buttons. The `preview` job builds each pull request exactly like a publish and deploys it to [Cloudflare Pages](https://pages.cloudflare.com) at a public URL, `https://pr-<number>.<project>.pages.dev`, which updates on every push. One comment on the pull request carries the link. This is the feedback loop authors rely on ([Quick start](../author/quick-start.md)).

(enable-previews)=
## You write

Set it up once per course repository (or run `nma-kit init --preview` when you create the course):

1. **Create a Cloudflare API token** (My Profile → API Tokens → Custom token) with **Account → Cloudflare Pages → Edit**, and note the account ID (Workers & Pages overview).
2. **Add repository secrets and a variable** (Settings → Secrets and variables → Actions): the secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`, and the variable `CLOUDFLARE_PROJECT` (the Pages project name; the first preview creates it).
3. **Use the `preview` job** from the workflow, with the `pull_request` types that include `closed`. The job needs `contents: write` and `pull-requests: write`. This guide's own `course.yml` is shown on [Publish with CI](publish-with-ci.md).

```yaml
  preview:
    if: >-
      github.event_name == 'pull_request' &&
      github.event.pull_request.head.repo.full_name == github.repository
    uses: neuromatch/course-kit/.github/workflows/course-preview.yml@v0.4
    with:
      pr-number: ${{ github.event.pull_request.number }}
      action: ${{ github.event.action == 'closed' && 'cleanup' || 'deploy' }}
      cloudflare-project: ${{ vars.CLOUDFLARE_PROJECT }}
    secrets: inherit
    permissions:
      contents: write
      pull-requests: write
```

Delete the job to turn previews off.

## You get

- **The preview link** in one comment on each pull request, updated on every push.
- **Notebook buttons that open the PR's own notebooks.** The preview pushes them to the branch `notebooks-pr-<number>` and sets `NMA_NOTEBOOKS_BRANCH`, which every Colab, Kaggle, solution and data-download link follows. The production `notebooks-branch` and the Pages site are never touched. The branch is public like the repository.
- **Cleanup.** Closing the pull request deletes the branch and the Cloudflare deployments and marks the comment as removed.
- **A second preview for the instructor site** when `CLOUDFLARE_INSTRUCTOR_PROJECT` is set: `https://pr-<number>.<instructor project>.pages.dev` ([Instructor site](instructor-site.md)).

(limits)=
## Rules

- **Same-repository pull requests only.** Pull requests from forks get no secrets, so they get no preview (the check still runs). Authors need write access to the repository.
- **Without the secrets** the job still builds the site and skips the deploy with a notice, so a course can adopt the template before it has Cloudflare. Authors then get the `check` result but no preview link.
- **The repository must be public.** Colab and Kaggle read raw GitHub URLs.
- Previews do not publish anything to the live site.

(cloudflare)=
### Cloudflare

The token and the account ID are the same ones the [instructor site](instructor-site.md) uses. The Pages project is created by the first preview; no manual project setup is needed.

## Next

- [Instructor site](instructor-site.md)
- [Publish with CI](publish-with-ci.md)
- Reference: [`nma-kit` commands](../reference/cli.md)
