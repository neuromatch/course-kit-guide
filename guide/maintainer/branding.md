---
title: "Branding and customising"
---

# Branding and customising

For: maintainer

The kit gives your course the Neuromatch look (colours, the Rubik font, logos, favicon and the styling of its own widgets). Everything you change lives in `myst.yml`, in the `site:` block for MyST and the `nma:` block for the kit. Change the title, colours, logo and CSS to make the book yours.

## You write

### Title and metadata

Edit `myst.yml`: these fields appear in the browser tab, sidebar, and Open Graph
metadata when the book is published:

```yaml
project:
  title: Computational Neuroscience 2027
  description: An introduction to modelling the brain
  authors:
    - name: Your Name
      github: your-github-username
  github: https://github.com/your-org/your-course-repo
```

### Branding files

The kit provides the Neuromatch look: colours, the Rubik font, logos, favicon,
and the styling of its own widgets. `nma-kit sync-assets` writes them to `_nma/`
(CI does this automatically; run it once locally before `myst start`, and again
after upgrading the kit). `myst.yml` points at those files:

```yaml
site:
  options:
    logo_text: Your Course Title   # your course's name next to the logo
    style: _nma/site.css
    logo: _nma/logo.svg
    logo_dark: _nma/logo-dark.svg
    favicon: _nma/favicon.png
```

### Colours

Set any of these in the `nma:` block of `myst.yml` (all optional, `"#RRGGBB"`):

```yaml
nma:
  brand:
    primary: "#D9480F"       # links, accents, buttons
    primary_hover: "#A63700" # default: primary, 25% darker
    primary_light: "#FF8A57" # accent on dark backgrounds
    secondary: "#45429C"     # header surface, tips
    accent: "#FA7A7A"        # exercise cells
```

### Your own logo

To replace the Neuromatch logo, place your file in `_static/` and point the
logo options at it instead of `_nma/`:

```yaml
site:
  options:
    logo: _static/your_logo.svg
    logo_dark: _static/your_logo_dark.svg   # optional, shown in dark mode
    logo_text: Your Course Title             # optional, shown next to the logo
```

SVG and PNG both work. The logo appears in the top-left of the sidebar.
`logo_dark` swaps in a light version of the logo when the reader is in dark mode,
and `logo_text` puts the course title beside the logo — handy when the logo is an
icon rather than a full wordmark. 

### Custom CSS

Put your own rules in a file such as `_static/extra.css` and list it in `myst.yml`.
The kit appends it after its own stylesheet (into `_nma/site.css`), so your
rules win. The brand colours are CSS variables (`--nma-brand-primary`, ...):

```yaml
nma:
  style:
    extra: _static/extra.css
```

Example contents:

```css
/* Style exercise admonitions */
.admonition.tip {
  border-left-color: #4ECDC4;
}
```

### Download buttons

Let students download pages as PDF or Jupyter notebook:

```yaml
site:
  options:
    downloads: true
```

### Theme

MyST uses `book-theme` by default. To list available themes:

```bash
myst templates list --site
```

Then set it in `myst.yml`:

```yaml
site:
  template: book-theme
```

## You get

- A book with your title and metadata in the browser tab, sidebar and Open Graph tags.
- The kit's stylesheet with your colours, written into `_nma/site.css` by `nma-kit sync-assets` (CI does this for you; run it once locally before `myst start`, and again after upgrading the kit). `_nma/` is self-ignoring and is never committed.
- Your own `_static/extra.css` appended after the kit's stylesheet, so your rules win.

## Rules

- Colours are `"#RRGGBB"` strings. `primary_hover` and `primary_light` default to darker and lighter versions of `primary`.
- Keep `project.jupyter.lite` on (the kit's `extend:` file sets it): MyST only emits the in-browser kernel assets with it.
- Site-wide files (a custom logo, extra CSS) go in a root `_static/` folder, which you create when needed. A page's own images stay beside the page.
- `logo_text` puts the course title beside the logo: handy when the logo is an icon rather than a wordmark.
- Never edit files in `_nma/`: they are regenerated.

## Next

- [Structure and scale](structure-and-scale.md)
- [Publish with CI](publish-with-ci.md)
- Reference: [`nma:` settings](../reference/nma-config.md)
