---
title: "Rich outputs"
kernelspec:
  name: python3
  display_name: Python 3
---

# Rich outputs

For: author

Charts, widgets and tables render as rich outputs: Altair and Plotly charts and DataFrames show in the static build from their stored output, and ipywidgets become live once the cell runs (▶ Run). You write plain code; the last expression of a cell is what gets displayed.

## You write

End a cell with the chart, widget or table you want shown:

````text
```{code-cell} python
points & bars        # an Altair chart: interactive with no kernel
```

```{code-cell} python
widgets.interact(plot_wave, frequency=(0.5, 5.0, 0.5))   # live after ▶ Run
```

```{code-cell} python
df                   # a pandas DataFrame: a styled HTML table
```
````

ipywidgets is not bundled with Pyodide, so install it in a hidden setup cell with `micropip` (the check on `sys.platform` makes it do nothing in Colab or Kaggle). Label a cell with `#| label: fig-name` to embed its output on another page with `{embed}`.

## You get

### An Altair chart

Altair charts are interactive in the rendered book with no kernel. Drag to select points in the scatter plot; the bar chart updates.

```{code-cell} python
import altair as alt
from vega_datasets import data

source = data.cars()
brush = alt.selection_interval(encodings=["x"])

points = alt.Chart(source).mark_point().encode(
    x="Horsepower:Q",
    y="Miles_per_Gallon:Q",
    color=alt.condition(brush, "Origin:N", alt.value("lightgray")),
).add_params(brush)

bars = alt.Chart(source).mark_bar().encode(
    y="Origin:N",
    color="Origin:N",
    x="count(Origin):Q",
).transform_filter(brush)

points & bars
```

### An ipywidgets slider

Once you run this cell, the slider is live and interactive.

JupyterLite uses Pyodide (Python in WebAssembly), which requires packages to be
loaded via `micropip` before importing. The setup cell below handles this — it is
hidden from students but runs automatically when the kernel starts.

```{code-cell} python
:tags: [remove-cell]
# JupyterLite/Pyodide setup — installs packages not bundled in the default WASM environment
import sys
if sys.platform == "emscripten":
    import micropip
    await micropip.install(["ipywidgets"])
```

```{code-cell} python
import ipywidgets as widgets
import matplotlib.pyplot as plt
import numpy as np

def plot_wave(frequency=1.0):
    x = np.linspace(0, 2 * np.pi, 300)
    fig, ax = plt.subplots(figsize=(6, 2))
    ax.plot(x, np.sin(frequency * x))
    ax.set_title(f"sin({frequency:.1f} x)")
    ax.set_xlabel("x")
    plt.tight_layout()
    plt.show()

widgets.interact(plot_wave, frequency=(0.5, 5.0, 0.5))
```

### A pandas DataFrame

DataFrames render as styled HTML tables in the book:

```{code-cell} python
import pandas as pd
from vega_datasets import data

df = data.cars().iloc[:5, :5]
df
```

### A labelled output

Label a cell to embed its output on another page:

```{code-cell} python
#| label: fig-horsepower-scatter
import matplotlib.pyplot as plt
from vega_datasets import data

df = data.cars()
fig, ax = plt.subplots(figsize=(5, 3))
scatter = ax.scatter(
    df["Horsepower"], df["Miles_per_Gallon"],
    alpha=0.4, c=df["Year"], cmap="viridis"
)
ax.set_xlabel("Horsepower")
ax.set_ylabel("Miles per gallon")
plt.colorbar(scatter, ax=ax, label="Model year")
plt.tight_layout()
```

On any other page in the book, embed this output with:

````text
{embed}`fig-horsepower-scatter`
````

## Rules

- Altair charts are interactive without a kernel; ipywidgets need the cell to be run first.
- A hidden `remove-cell` setup cell is where `micropip.install` goes ([Browser limits and packages](../reference/browser-limits.md)).
- Label outputs with `#| label: fig-name` to reuse them across pages.
- On scrolly pages don't use `@widgets.interact`; use `# @param` ([Scrollytelling pages](scrolly.md)).

## Next

- [Images and data files](images-and-data.md)
- [Exercises, solutions and explanations](exercises.md)
