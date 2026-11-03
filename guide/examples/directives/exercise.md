---
title: "Example: Exercise, solution and explanation"
kernelspec:
  name: python3
  display_name: Python 3
---

# Example: Exercise, solution and explanation

For: author (example source)

This page is the source behind the "You write" blocks on [Exercises, solutions and explanations](../../author/exercises.md). Start the kernel and run the exercise cell without changing it: the run-all fallback runs the reference solution instead and prints a note.

% region-start: exercise
```{code-cell} python
def double(x):
  ###################################################################
  ## Fill out the following then remove
  raise NotImplementedError("Student exercise: double x")
  ###################################################################
  return ...

print(double(21))
```

::::{nma-solution}
```python
def double(x):
  return 2 * x

print(double(21))
```
::::
% region-end: exercise

% region-start: explanation
:::{nma-explanation}
Doubling is linear: $f(a + b) = f(a) + f(b)$.
:::
% region-end: explanation
