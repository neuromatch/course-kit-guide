---
title: "Project booklet examples"
---

# Project booklet examples

For: author and maintainer (examples)

This section contains project booklet material converted to MyST.

## Worked examples

Real Neuromatch project material, converted to MyST. Each shows a different kind of
page a project booklet needs:

- [Daily guide for projects](project_guidance.md) (CompNeuro): plain-Markdown guidance
  for students, with a day-by-day plan, timings and submission links. No code, so no
  `kernelspec`.
- [Macrocircuits](example_macrocircuits/Macrocircuits.md) (NeuroAI): a full project
  notebook with background, video and slides, a project-template image, setup for
  Colab/Kaggle/local, exercises and feedback widgets.
- [Guide to choosing a Neurons dataset](example_neurons/index.md) (CompNeuro): a
  dataset chooser with project-template diagrams, linking to starter pages such as
  [Allen Institute Visual Behavior](example_neurons/allen_visual_behavior.md).

The two code pages use `runtime: colab` because their dependencies (`dm_control`,
MuJoCo) or data downloads can't be assumed to work in the browser. Images are linked
from the upstream course repositories instead of being copied here, to keep this
repository small.

To set up a booklet in your own course, see [Project booklet](../../maintainer/project-booklet.md).

## Layout used by the examples

    guide/examples/projects/
      index.md                       <- this file: the booklet examples
      project_guidance.md            <- daily guidance for students
      example_macrocircuits/
        Macrocircuits.md             <- one full project notebook
      example_neurons/
        index.md                     <- dataset guide
        allen_visual_behavior.md     <- starter page for one dataset
