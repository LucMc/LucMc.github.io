# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal portfolio website built with [Quarto](https://quarto.org/), producing both an HTML site and a combined PDF via Typst.

## Commands

```bash
# Preview site locally with live reload
quarto preview

# Build HTML site (output → docs/)
quarto render

# Build combined PDF (output → _pdf-output/portfolio-pdf.pdf)
quarto render --profile portfolio
```

## Architecture

**Dual-output from shared content:** Root `.qmd` files (index, cv, publications, projects, about) are thin wrappers that include content fragments from `_content/` using `{{< include _content/*.qmd >}}`. This lets the same content feed both the HTML website (`_quarto.yml`) and the combined PDF (`_quarto-portfolio.yml` with `portfolio-pdf.qmd`).

**Format-conditional blocks:** Content files use `{.content-visible when-format="html"}` and `{.content-visible when-format="typst"}` to tailor sections per output format.

**Key directories:**
- `_content/` — Reusable content fragments (the actual prose/data)
- `_styles/` — SCSS theme (`custom.scss`), CSS overrides (`styles.css`), Typst PDF styling (`typst/before-body.typ`)
- `docs/` — Generated HTML output (committed to repo, serves via GitHub Pages)

**Styling:** Dark theme built on Quarto's "darkly" base. SCSS variables in `_styles/custom.scss` define the color palette (background `#0d0d0d`, accent blue `#1d4ed8`/`#3b82f6`, text `#e8e8e8`). Semantic CSS classes: `.experience-entry`, `.skill-badge`, `.project-card`, `.pub-entry`, `.talk-card`.
