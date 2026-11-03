---
title: "Figures, math and cross-references"
kernelspec:
  name: python3
  display_name: Python 3
---

# Figures, math and cross-references

For: author

MyST handles images, equations, cross-references and figures from code natively. Reference a local image by its path and the kit publishes it for the Colab and Kaggle notebooks automatically. This page is itself the example: each source block is followed by its result.

## You write

Three ways to include an image. Pick by what you need:

| Form | Use it when | You get |
|---|---|---|
| `![alt](path)` | A plain image, no options | Alt text |
| `{image}` | You need to control the size or alignment | `:alt:`, `:width:`, `:align:` |
| `{figure}` | The image needs a caption, a number or a cross-reference | All of the above, plus a caption, `:label:` and `{numref}` |

````text
![An example figure](images/example_figure.png)

```{image} images/example_figure.png
:alt: An example figure, resized
:width: 30%
:align: center
```

```{figure} images/example_figure.png
:label: fig-example
:alt: An example figure used to demonstrate the figure directive
:width: 60%

A figure with a caption and a label. Reference it with {numref}`fig-example`.
```
````

Math is LaTeX between dollar signs, with optional labels you reference with `{eq}`:

````text
Inline math: $E = mc^2$

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$ (eq-gaussian)

See {eq}`eq-gaussian`.
````

Label a heading with `(label)=` on the line above it, and link to it with a normal link:

````text
(sec-crossref-demo)=
### This section has a label

Go to [the labelled section](#sec-crossref-demo).
````

A Matplotlib figure from a code cell needs no extra syntax: the cell's figure is embedded.

## You get

![An example figure](images/example_figure.png)

```{image} images/example_figure.png
:alt: An example figure, resized
:width: 30%
:align: center
```

```{figure} images/example_figure.png
:label: fig-example
:alt: An example figure used to demonstrate the figure directive
:width: 60%

A figure with a caption and a label. Reference it with {numref}`fig-example`.
```

Inline math: $E = mc^2$

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$ (eq-gaussian)

See {eq}`eq-gaussian`.

(sec-crossref-demo)=
### This section has a label

Go to [the labelled section](#sec-crossref-demo).

```{code-cell} python
import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots(figsize=(6, 3))
x = np.linspace(0, 2 * np.pi, 200)
ax.plot(x, np.sin(x), label="sin(x)")
ax.plot(x, np.cos(x), label="cos(x)")
ax.legend()
ax.set_xlabel("x")
ax.set_title("Trigonometric functions")
plt.tight_layout()
```

## Rules

- Images live in an `images/` folder next to the page; paths are relative to the page, which is also the working directory when its code runs. Images a page only **displays** need no declaration. Files your *code* reads need `{nma-data}`: see [Images and data files](images-and-data.md).
- In the generated notebooks all three forms become an `<img>` with the file's published URL. `{image}` and `{figure}` keep `:alt:` and `:width:`, and a figure's caption becomes an italic line. Labels, numbering, `{numref}` and `:align:` only exist on the site, so don't rely on them for what a notebook reader must understand.
- The site renders math with KaTeX, not MathJax. Use `\begin{aligned}` inside `$$`, not `eqnarray`, and `bmatrix` rather than `array`.
- `check` fails on an image reference that points to a missing file ([Rules enforced by `check`](../reference/check-rules.md#rules-assets)).

## Next

- [Images and data files](images-and-data.md)
- [Write pages](write-pages.md)
- [Rich outputs](rich-outputs.md)
