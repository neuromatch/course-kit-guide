---
title: "Example: Code cells"
kernelspec:
  name: python3
  display_name: Python 3
---

# Example: Code cells

For: author (example source)

This page is the source behind the code-cell blocks on [Write pages](../../author/write-pages.md). Edit a cell and press **▶ Run** (or Shift-Enter).

% region-start: code-cell
```{code-cell} python
message = "Hello from MyST!"
print(message)
```
% region-end: code-cell

A `hide-input` cell shows only its output; the code is behind "Show code":

% region-start: hide-input
```{code-cell} python
:tags: [hide-input]
import numpy as np
print(f"pi = {np.pi:.6f}")
```
% region-end: hide-input

A `remove-cell` cell is invisible but still runs, so later cells can use what it defines:

% region-start: remove-cell
```{code-cell} python
:tags: [remove-cell]
greeting = "set up out of sight"
```
% region-end: remove-cell

```{code-cell} python
print(greeting)
```
