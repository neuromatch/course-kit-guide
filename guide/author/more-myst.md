---
title: "More MyST: tabs, dropdowns and proofs"
---

# More MyST: tabs, dropdowns and proofs

For: author

MyST has more blocks than the course kit needs, and they all work in a course book. These are the ones authors reach for most: tabs, dropdowns, theorems, margin notes and footnotes. Each shows its source and then the result.

## You write

Tabs show alternative versions of the same content:

````text
::::{tab-set}
:::{tab-item} Python
`print("Hello from Python")`
:::
:::{tab-item} Julia
`println("Hello from Julia")`
:::
::::
````

A dropdown hides an answer students should try first:

````text
:::{dropdown} Click to reveal the answer
Here is the answer.
:::
````

A theorem with a label:

````text
:::{prf:theorem} Bayes theorem
:label: thm-bayes

$P(A|B) = \frac{P(B|A)\,P(A)}{P(B)}$
:::
````

A margin note, and a footnote:

````text
:::{aside}
:class: margin
Margin notes appear in the gutter on wide screens.
:::

A sentence with a footnote[^fn1].

[^fn1]: The footnote text appears at the bottom of the page.
````

## You get

::::{tab-set}
:::{tab-item} Python
`print("Hello from Python")`
:::
:::{tab-item} Julia
`println("Hello from Julia")`
:::
::::

:::{dropdown} Click to reveal the answer
Here is the answer.
:::

:::{prf:theorem} Bayes theorem
:label: thm-bayes

$P(A|B) = \frac{P(B|A)\,P(A)}{P(B)}$
:::

:::{aside}
:class: margin
Margin notes appear in the gutter on wide screens.
:::

A sentence with a footnote[^fn1].

[^fn1]: The footnote text appears at the bottom of the page.

## Rules

- These are plain MyST. The course kit adds nothing to them and they need no extension.
- Don't nest `{nma-solution}`, `{nma-explanation}`, `{nma-feedback}`, `{nma-instructor}` or `{nma-video}` inside a tab or a dropdown: they must be at the top level ([Directives](../reference/directives.md)).
- For the full list of MyST blocks, see the [MyST directives reference](https://mystmd.org/guide/directives).

## Next

- [Write pages](write-pages.md)
- [Exercises, solutions and explanations](exercises.md)
