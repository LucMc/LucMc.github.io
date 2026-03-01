// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black or heading-decoration == "underline"
           or heading-background-color != none) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#show: doc => article(
  title: [Projects],
  margin: (x: 1.5cm,y: 2cm,),
  paper: "a4",
  font: ("Liberation Sans",),
  fontsize: 10pt,
  pagenumbering: "1",
  toc: true,
  toc_title: [Table of contents],
  toc_depth: 2,
  cols: 1,
  doc,
)
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

#let project-card(img-path, title, description) = {
  block(
    width: 100%,
    stroke: 0.5pt + rgb("#e5e7eb"),
    inset: 12pt,
    below: 8pt,
  )[
    #grid(
      columns: (80pt, 1fr),
      gutter: 12pt,
      box(
        stroke: 0.5pt + rgb("#e5e7eb"),
        image(img-path, width: 80pt),
      ),
      [
        #text(weight: "bold", fill: rgb("#111827"), size: 10pt)[#title]\
        #v(2pt)
        #text(fill: rgb("#6b7280"), size: 9pt)[#description]
      ],
    )
  ]
}

#let project-grid-card(img-path, title, description) = {
  box(
    width: 100%,
    stroke: 0.5pt + rgb("#e5e7eb"),
    inset: 10pt,
  )[
    #image(img-path, width: 100%, height: 80pt, fit: "contain")
    #v(6pt)
    #text(weight: "bold", fill: rgb("#111827"), size: 9.5pt)[#title]\
    #v(2pt)
    #text(fill: rgb("#6b7280"), size: 8.5pt)[#description]
  ]
}

#let project-grid-card-text(title, description) = {
  box(
    width: 100%,
    stroke: 0.5pt + rgb("#e5e7eb"),
    inset: 10pt,
  )[
    #v(40pt)
    #text(weight: "bold", fill: rgb("#111827"), size: 9.5pt)[#title]\
    #v(2pt)
    #text(fill: rgb("#6b7280"), size: 8.5pt)[#description]
  ]
}
= Research & Robotics
<research-robotics>
#project-card(
  "images/projects/both_stairs.JPG",
  "Unitree G1 Locomotion & Stair Climbing — Cambridge Consultants",
  "Reinforcement learning pipelines for Unitree G1 humanoid locomotion. Developed stair-climbing policies in MuJoCo and Isaac Sim with sim-to-real transfer experiments on physical hardware.",
)

#project-card(
  "images/projects/elf_box_picking.png",
  "VLA Manipulation & Box Picking — Cambridge Consultants",
  "Fine-tuned Vision-Language-Action models (GR00T) for robotic manipulation tasks. Context-aware grasping and box picking with Unitree G1 humanoids.",
)
= Agentic AI
<agentic-ai>
#project-card(
  "images/projects/SAMX.png",
  "SAM-X: Computer Use Agent — Agile Loop",
  "VC-funded computer-use agent. Led a team of 10, combining reinforcement learning with VLM LoRA fine-tuning. Presented to Google Cloud.",
)

#project-card(
  "images/projects/lenovo-vantage-agile-loop.jpg",
  "Hybrid Edge/Cloud Model Routing — Agile Loop (Lenovo)",
  "Designed a hybrid edge/cloud model routing architecture for Lenovo, optimising inference across device and cloud endpoints. Built CV systems and RL environments for software testing.",
)
= Intelligent Vehicle Design
<intelligent-vehicle-design>
#project-card(
  "images/projects/intelligent_vehicle_design.jpg",
  "Intelligent Vehicle Design Module — University of Surrey",
  "Designed module content and delivered lectures for the Intelligent Vehicle Design module. Covered autonomous vehicle decision making, deep Q-Learning with Noisy Networks, and LSTM-based trajectory forecasting.",
)
= Cybersecurity & Defence
<cybersecurity-defence>
#project-card(
  "images/projects/mitre-attack.png",
  "MITRE ATT&CK Automation — QinetiQ",
  "Developed software to automate attacks from the MITRE ATT&CK framework for red team security assessments and penetration testing. Built voice cryptography systems in C++ and Python.",
)
= PhD Research
<phd-research>
#project-card(
  "images/projects/dexter-veolia.png",
  "RL for the DEXTER Robot — Veolia-Sponsored PhD",
  "Veolia-sponsored research developing reinforcement learning for the DEXTER industrial robot, entirely in simulation. World models for sample-efficient control, Neural Lyapunov functions for stability verification, and continual RL at scale in JAX.",
)
= GeoSnap
<geosnap>
#project-card(
  "images/projects/Geosnap2.png",
  "GeoSnap — Co-Founder & CTO",
  "A vision-based localisation and navigation platform. Built the full technical stack from concept to deployment, managing architecture decisions, development, and infrastructure.",
)
= Other Projects
<other-projects>
#grid(
  columns: (1fr, 1fr),
  gutter: 8pt,
  project-grid-card(
    "images/projects/big_rc_hardware_integration.jpg",
    "Autonomous RC Cars",
    "Embedded systems combined with reinforcement learning for autonomous navigation.",
  ),
  project-grid-card(
    "images/projects/rc_lane_following.png",
    "RC Lane Following",
    "End-to-end vision-to-steering on a taped track using convolutional neural networks.",
  ),
  project-grid-card(
    "images/projects/openai_hackathon.png",
    "ClimateCode",
    "OpenAI Hackathon project — LLM fine-tuning for compute-optimised code generation.",
  ),
  project-grid-card(
    "images/projects/cyclopic.jpg",
    "Cyclopic",
    "Contract robotics — communications and networking systems for GPS-denied environments.",
  ),
  project-grid-card(
    "images/projects/FUNIPEDIA_1.png",
    "Funipedia",
    "Fun Wikipedia-style article platform. Grokathon honourable mention.",
  ),
  project-grid-card(
    "images/projects/image_recognition.jpg",
    "Facial Recognition System",
    "Real-time face detection and recognition pipelines using computer vision.",
  ),
  project-grid-card(
    "images/projects/finance.JPG",
    "Stock Price Prediction",
    "BSc dissertation — LSTM model for 14-day stock price forecasting with a web interface comparing against indicator-based strategies.",
  ),
  project-grid-card(
    "images/projects/ctf.svg",
    "CTF Challenges",
    "Security challenges — web exploitation, reverse engineering, and cryptography.",
  ),
)




