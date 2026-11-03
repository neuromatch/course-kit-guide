---
title: "Run code in the browser"
kernelspec:
  name: python3
  display_name: Python 3
---

# Run code in the browser

For: author

Any page with a `kernelspec` runs its code in the reader's browser: no server and no installation. The kit uses JupyterLite (Python through Pyodide, WebAssembly), so each code cell becomes an editor with a **▶ Run** button.

## You write

Write an ordinary `{code-cell}` on a page whose frontmatter declares `kernelspec`:

````text
```{code-cell} python
result = sum(range(1, 101))
print(f"Sum of 1 to 100: {result}")
```
````

A heavy tutorial (for example one that needs PyTorch) opts out with `runtime: colab` in its frontmatter. Its code is then shown read-only with a banner that links to Colab and Kaggle ([Page types](page-types.md)).

## You get

Every code cell below is an editor. Edit the code and press **▶ Run** (or Shift-Enter). The first run takes about ten seconds while Python starts. Running a cell first runs the cells above it that haven't run yet, as in a notebook.

### Basic computation

```{code-cell} python
result = sum(range(1, 101))
print(f"Sum of 1 to 100: {result}")
```

### NumPy

```{code-cell} python
import numpy as np

rng = np.random.default_rng(seed=42)
arr = rng.standard_normal(1000)
print(f"Mean: {arr.mean():.4f}")
print(f"Std:  {arr.std():.4f}")
```

### Matplotlib

```{code-cell} python
import matplotlib.pyplot as plt
import numpy as np

rng = np.random.default_rng(seed=0)

fig, axes = plt.subplots(1, 2, figsize=(8, 3))

x = np.linspace(-3, 3, 300)
axes[0].plot(x, np.tanh(x))
axes[0].set_title("tanh(x)")
axes[0].set_xlabel("x")

axes[1].hist(rng.standard_normal(500), bins=30)
axes[1].set_title("Random normal samples")

plt.tight_layout()
```

## Rules

- **Only pages with `kernelspec`** get editable, runnable cells. The kit's `extend:` file in `myst.yml` turns on `project.jupyter.lite`, which MyST needs to emit the in-browser kernel; keep it.
- **One kernel per page.** Edits live in memory only (Reset restores the original). Changing page disposes the kernel; **Restart** starts a fresh one.
- **Package limits.** `numpy`, `scipy`, `pandas`, `matplotlib` and `altair` are bundled; others need `micropip`; some packages (GPU `torch`) can't run at all. See [Browser limits and packages](../reference/browser-limits.md).
- **Students who prefer Colab or Kaggle** use the badges that CI adds to every executable page and notebook ([Notebooks, branches and badges](../maintainer/notebooks-and-badges.md)). You never add badges by hand.

## Next

- [Rich outputs](rich-outputs.md)
- [Images and data files](images-and-data.md)
- Reference: [Browser limits and packages](../reference/browser-limits.md)
