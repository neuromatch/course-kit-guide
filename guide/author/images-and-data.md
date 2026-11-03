---
title: "Images and data files"
kernelspec:
  name: python3
  display_name: Python 3
---

# Images and data files

For: author

Code that reads a file (`np.load`, `open`, ...) needs that file declared with `{nma-data}`, so the kit can embed it for the browser and fetch it in Colab and Kaggle notebooks. Images a page only *displays* need no declaration: reference them and the kit publishes them.

## You write

Declare the files your code reads, at the top level of the page. One path per line, each in `data/` or `images/` next to the page:

````text
:::{nma-data}
data/spike_times.npz
data/neuron_metadata.npz
:::
````

Then read them with ordinary code, the same in the browser and in notebooks:

````text
```{code-cell} python
import numpy as np
spike_data = np.load('data/spike_times.npz', allow_pickle=True)
```
````

Display an image by referencing it. No declaration needed:

````text
```{figure} images/experimental_setup.png
:label: fig-setup
:alt: Experimental setup schematic
:width: 80%

Our experimental pipeline.
```
````

## You get

This page declares its files and uses them below:

```{code-cell} python
:tags: [remove-cell]
import sys
if sys.platform == "emscripten":  # only true in JupyterLite/Pyodide
    import micropip
    await micropip.install(["ipywidgets"])
```

:::{nma-data}
data/spike_times.npz
data/neuron_metadata.npz
:::

```{figure} images/experimental_setup.png
:label: fig-setup
:alt: Experimental setup schematic
:width: 80%

Our experimental pipeline: stimulus presentation, neural recording, and spike train analysis.
```

### Load the data

Load the data the same way in the browser and in notebooks: normal NumPy works.

```{code-cell} python
import numpy as np

# Load spike data (allow_pickle=True needed for ragged arrays stored as object dtype)
spike_data = np.load('data/spike_times.npz', allow_pickle=True)
metadata = np.load('data/neuron_metadata.npz', allow_pickle=True)

print(f"Loaded {len(spike_data['neuron_ids'])} neurons")
print(f"Loaded {len(spike_data['trial_ids'])} trials")
print(f"Loaded {len(spike_data['condition_ids'])} conditions")
```

### Plot a raster

Let's create a raster plot showing spike times for the first neuron across all trials:

```{code-cell} python
import matplotlib.pyplot as plt

# Get spikes for neuron 0 across all trials
n_trials = len(spike_data['trial_ids'])
neuron_idx = 0

fig, ax = plt.subplots(figsize=(10, 6))

for trial in range(n_trials):
    spike_idx = neuron_idx * n_trials + trial
    spikes = spike_data['spikes'][spike_idx]
    ax.scatter(spikes, [trial] * len(spikes), c='black', s=1, marker='|')

ax.set_xlabel('Time (s)')
ax.set_ylabel('Trial')
ax.set_title(f'{metadata["neuron_labels"][neuron_idx]} - Spike Raster')
ax.set_ylim(-1, n_trials)
plt.tight_layout()
```

### Compute firing rates

Calculate mean firing rate by condition:

```{code-cell} python
n_neurons = len(spike_data['neuron_ids'])
n_conditions = len(spike_data['condition_ids'])

# Compute firing rates
firing_rates = np.zeros((n_neurons, n_conditions))

for neuron in range(n_neurons):
    for trial in range(n_trials):
        spike_idx = neuron * n_trials + trial
        condition = metadata['trial_conditions'][trial]
        n_spikes = len(spike_data['spikes'][spike_idx])
        firing_rates[neuron, condition] += n_spikes / 1.0  # 1 second trials

# Average across trials
firing_rates /= (n_trials // n_conditions)

# Plot firing rates
fig, ax = plt.subplots(figsize=(8, 6))
im = ax.imshow(firing_rates, aspect='auto', cmap='viridis')
ax.set_xlabel('Condition')
ax.set_ylabel('Neuron')
ax.set_title('Mean Firing Rate by Condition')
ax.set_xticks(range(n_conditions))
ax.set_xticklabels(metadata['condition_labels'])
plt.colorbar(im, ax=ax, label='Firing Rate (Hz)')
plt.tight_layout()
```

### Explore with a widget

Use a widget to explore different neurons and conditions:

```{code-cell} python
:tags: [hide-input]
import ipywidgets as widgets

@widgets.interact(
    neuron=widgets.IntSlider(min=0, max=19, value=0, description='Neuron'),
    condition=widgets.IntSlider(min=0, max=4, value=0, description='Condition')
)
def explore_spikes(neuron, condition):
    # Get trials for this condition
    condition_trials = np.where(metadata['trial_conditions'] == condition)[0]
    
    fig, ax = plt.subplots(figsize=(10, 4))
    
    for i, trial in enumerate(condition_trials):
        spike_idx = neuron * n_trials + trial
        spikes = spike_data['spikes'][spike_idx]
        ax.scatter(spikes, [i] * len(spikes), c='black', s=2, marker='|')
    
    ax.set_xlabel('Time (s)')
    ax.set_ylabel('Trial (within condition)')
    ax.set_title(f'{metadata["neuron_labels"][neuron]} - {metadata["condition_labels"][condition]}')
    ax.set_ylim(-1, len(condition_trials))
    plt.tight_layout()
    plt.show()
```

## Rules

- **Declare what code reads.** Only declare an image with `{nma-data}` if your code *reads* it (for example loading a PNG into an array).
- **Keep files small.** On the site, files up to 2 MB are embedded for the page's editable cells; larger files are not.
- **Where they live.** Files must be in `data/` or `images/` inside the page's folder (the names come from `nma.assets`, see [`nma:` settings](../reference/nma-config.md)). Slide PDFs for `{nma-slides}` live in `slides/` ([Videos, slides and feedback](videos-and-slides.md)).
- **What `check` does.** It rejects references to missing images, undeclared files that code reads, and dynamic paths ([Rules enforced by `check`](../reference/check-rules.md#rules-assets)).
- The generation scripts (`generate_data.py`, `generate_schematic.py`) beside this page are only for reproducibility. Commit the files themselves, not generation scripts, in your own course.

## Where files go

Keep a page's files next to it, in `images/`, `data/` and `slides/` folders (the names are set by `nma.assets`, see [`nma:` settings](../reference/nma-config.md)). Paths are relative to the page.

- **Beside the page.** With one or two files you can put them directly next to the page.
- **Site-wide files** (a custom logo, extra CSS) go in a root `_static/` folder, which you create when needed (see [Branding and customising](../maintainer/branding.md)).
- **On the site**, relative image paths just work.
- **In the generated notebooks** (Colab and Kaggle), every image a page displays is copied to the notebooks branch automatically, and a download cell fetches the files you declare with `{nma-data}`. For any other file a notebook needs, use an absolute URL such as `https://raw.githubusercontent.com/<org>/<repo>/main/<folder>/<file>`. In the browser, fetch data with `pyodide.http.open_url` ([Browser limits and packages](../reference/browser-limits.md)), since Pyodide has no sockets.

## Next

- [Videos, slides and feedback](videos-and-slides.md)
- [Figures, math and cross-references](figures-math-xrefs.md)
- Reference: [`{nma-data}`](../reference/directives.md#nma-data)
