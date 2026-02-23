// Portfolio PDF styling

// Header and footer
#set page(
  header: context {
    if counter(page).get().first() > 1 [
      _Luc McCutcheon — Portfolio_
      #h(1fr)
      #counter(page).display()
    ]
  },
  footer: context {
    if counter(page).get().first() > 1 [
      #line(length: 100%, stroke: 0.5pt + luma(180))
      #v(2pt)
      #text(size: 8pt, fill: luma(120))[
        lucmccutcheon.home\@gmail.com
        #h(1fr)
        github.com/LucMc
      ]
    ]
  },
)

// Heading styling
#show heading.where(level: 1): it => {
  v(4pt)
  text(size: 16pt, weight: "bold", it)
  v(2pt)
  line(length: 100%, stroke: 1pt + luma(180))
  v(4pt)
}

#show heading.where(level: 2): it => {
  v(4pt)
  text(size: 13pt, weight: "bold", it)
  v(2pt)
}

#show heading.where(level: 3): it => {
  v(2pt)
  text(size: 11pt, weight: "bold", it)
  v(1pt)
}

// Link styling
#show link: it => {
  text(fill: rgb("#2563eb"), it)
}
