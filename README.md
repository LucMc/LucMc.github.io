# Portfolio

Personal portfolio site built with [Quarto](https://quarto.org/), producing both an HTML site and a combined PDF via Typst.

## Commands

**Preview the site locally:**

```bash
quarto preview
```

**Build the HTML site** (output in `docs/`):

```bash
quarto render
```

**Build the combined Portfolio PDF** (output in `_pdf-output/portfolio-pdf.pdf`):

```bash
quarto render --profile pdf
```

**Build a standalone PDF for a single section** (e.g. the CV):

```bash
quarto render cv.qmd --to typst
```

## Architecture

All content lives in `_content/` as reusable fragments. The root `.qmd` files (index, cv, publications, projects, about) are thin wrappers that include from `_content/` using `{{< include _content/*.qmd >}}`. This means editing a file in `_content/` is automatically reflected in both the HTML website and the combined portfolio PDF.

```
_content/          ← Single source of truth (actual prose/data)
├── index.qmd
├── cv.qmd
├── publications.qmd
├── projects.qmd
└── about.qmd

Root .qmd files     ← Thin wrappers for the HTML site
portfolio-pdf.qmd   ← Combines all sections into one PDF

_styles/            ← SCSS theme, CSS overrides, Typst PDF styling
docs/               ← Generated HTML output (GitHub Pages)
_pdf-output/        ← Generated PDF output
```

Content files use `{.content-visible when-format="html"}` and `{.content-visible when-format="typst"}` blocks to tailor sections per output format.
