// CV Styling — Brutalist Academic Design
// Translating website aesthetic (sharp corners, blue accents, uppercase headings) to print

// ─── Color Palette ───────────────────────────────────────
#let dark-bg = rgb("#111111")
#let accent-blue = rgb("#1d4ed8")
#let lighter-blue = rgb("#3b82f6")
#let text-dark = rgb("#111111")
#let text-gray = rgb("#666666")

// ─── Page Setup ──────────────────────────────────────────
#set page(
  header: none,
  footer: context {
    let pg = counter(page).get().first()
    let total = counter(page).final().first()
    if pg > 1 [
      #line(length: 100%, stroke: 0.4pt + luma(200))
      #v(3pt)
      #text(size: 7pt, fill: luma(150), tracking: 0.5pt)[
        lucmccutcheon.home\@gmail.com
        #h(1fr)
        #pg / #total
        #h(1fr)
        github.com/LucMc
      ]
    ]
  },
)

// ─── Typography ──────────────────────────────────────────
#set par(leading: 0.55em, spacing: 0.65em)
#set text(fill: text-dark)

// ─── Title Block ─────────────────────────────────────────
#align(center)[
  #text(size: 30pt, weight: "bold", tracking: 2.5pt)[
    #upper[Luc McCutcheon]
  ]
  #v(1pt)
  #text(size: 8pt, tracking: 5pt, fill: text-gray)[
    #upper[Senior Research Scientist]
  ]
  #v(6pt)
  #line(length: 100%, stroke: 0.5pt + luma(180))
  #v(3pt)
  #text(size: 7.5pt)[
    lucmccutcheon.home\@gmail.com
    #h(1fr)
    linkedin.com/in/lucmcc
    #h(1fr)
    lucmc.github.io
    #h(1fr)
    github.com/LucMc
  ]
  #v(3pt)
  #line(length: 100%, stroke: 0.5pt + luma(180))
]
#v(8pt)

// ─── Heading Styles ──────────────────────────────────────

// H1: Hidden — name already rendered in title block
#show heading.where(level: 1): it => {}

// H2: Section headers — dark filled bar, white uppercase letter-spaced text
#show heading.where(level: 2): it => {
  v(8pt)
  block(
    width: 100%,
    fill: dark-bg,
    inset: (x: 12pt, y: 5pt),
  )[
    #align(center)[
      #text(
        size: 10pt,
        weight: "bold",
        fill: white,
        tracking: 3pt,
      )[#upper(it.body)]
    ]
  ]
  v(5pt)
}

// H3: Entry titles — bold, left-aligned (job titles, degrees)
#show heading.where(level: 3): it => {
  v(3pt)
  text(size: 10pt, weight: "bold")[#it.body]
  v(0.5pt)
}

// H4: Sub-section labels — blue, centered with underline (First Author, Co-Author, etc.)
#show heading.where(level: 4): it => {
  v(4pt)
  align(center)[
    #text(
      size: 9pt,
      weight: "bold",
      fill: accent-blue,
      tracking: 2pt,
    )[#upper(it.body)]
    #v(1pt)
    #line(length: 25%, stroke: 0.5pt + accent-blue)
  ]
  v(3pt)
}

// ─── Links ───────────────────────────────────────────────
#show link: it => text(fill: accent-blue, it)

// ─── Lists ───────────────────────────────────────────────
#set list(indent: 8pt, body-indent: 5pt, spacing: 3pt)
