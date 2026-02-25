// Portfolio PDF styling — light theme with blue accents

// Color palette
#let bg = rgb("#ffffff")
#let surface = rgb("#f9fafb")
#let border = rgb("#e5e7eb")
#let accent = rgb("#2563eb")
#let accent-dark = rgb("#1d4ed8")
#let text-primary = rgb("#1f2937")
#let text-secondary = rgb("#374151")
#let text-muted = rgb("#6b7280")
#let text-heading = rgb("#111827")

// Page setup
#set page(
  fill: bg,
  header: context {
    if counter(page).get().first() > 1 [
      #text(size: 8pt, fill: text-muted, font: "Liberation Mono")[
        Luc McCutcheon — Portfolio
        #h(1fr)
        #counter(page).display()
      ]
    ]
  },
  footer: context {
    if counter(page).get().first() > 1 [
      #line(length: 100%, stroke: 0.5pt + border)
      #v(2pt)
      #text(size: 8pt, fill: text-muted, font: "Liberation Mono")[
        lucmccutcheon.home\@gmail.com
        #h(1fr)
        github.com/LucMc
      ]
    ]
  },
)

// Body text
#set text(fill: text-secondary)

// Heading styling
#show heading.where(level: 1): it => {
  v(4pt)
  text(size: 16pt, weight: "bold", fill: text-heading, it)
  v(2pt)
  line(length: 100%, stroke: 1pt + accent-dark)
  v(4pt)
}

#show heading.where(level: 2): it => {
  v(6pt)
  text(size: 13pt, weight: "bold", fill: text-heading, it)
  v(2pt)
  line(length: 100%, stroke: 0.5pt + border)
  v(4pt)
}

#show heading.where(level: 3): it => {
  v(2pt)
  text(size: 11pt, weight: "bold", fill: rgb("#374151"), it)
  v(1pt)
}

// Link styling
#show link: it => {
  text(fill: accent, it)
}

// Strong text
#show strong: it => {
  text(fill: text-heading, it)
}

// Emphasis in muted color
#show emph: it => {
  text(fill: text-muted, style: "italic", it)
}

// List styling
#set list(marker: text(fill: accent)[▸])
