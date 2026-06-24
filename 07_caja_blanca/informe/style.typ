#import "/informe/util/util.typ" as util
// colors
#let headerBorderColor = rgb("#808080")
#let tbHeaderBgColor = rgb("#C8310E")
#let codeBgColor = rgb("#F1F3F4")

// For front matter and header
#let headerSmall(content, weight: "regular", alignTo: none, color: black) = util.fontBuild(
  content,
  weight,
  7pt,
  alignTo,
  color,
)
#let mainTitle(content) = util.fontBuild(content, "bold", 13pt, center, black)
#let tableTitle(content, weight: "regular", alignTo: none, color: black) = util.fontBuild(
  content,
  weight,
  11pt,
  alignTo,
  color,
)

// Header
#let pageHeader = block(
  width: 100%,
  inset: (bottom: 1em),
)[
  #table(
    align: center + horizon,
    stroke: 0.5pt + headerBorderColor,
    columns: (1fr, 2fr, 1fr),
    align(horizon)[#image("/informe/src/fig/fixed/epis.png", width: 95%)],
    text(size: 7.5pt, weight: "bold", fill: black)[
      UNIVERSIDAD NACIONAL DE SAN AGUSTÍN \
      FACULTAD DE INGENIERÍA DE PRODUCCIÓN Y SERVICIOS \
      ESCUELA PROFESIONAL DE INGENIERÍA DE SISTEMAS
    ],
    align(horizon)[#image("/informe/src/fig/fixed/abet.png", width: 97%)],
    table.cell(colspan: 3)[
      #headerSmall(weight: "bold")[Formato: ]
      #headerSmall[Guía de Práctica de Laboratorio / Talleres / Centros de Simulación]
    ],
    headerSmall(weight: "bold")[Aprobación: 2022/03/01],
    headerSmall(weight: "bold")[Código: GUIA-PRLE-001],
    context headerSmall(weight: "bold", alignTo: right)[Página: #counter(page).display("1")],
  )
]

/// This function applies the template's global styles
/// - body (content): The document content.
#let template_styles(body) = {
  // table
  let tableBorderWidth = 0.5pt
  // fonts
  set text(
    // font: "New Computer Modern",
    font: "Lato",
    lang: "es",
    size: 10pt,
  )
  show link: it => {
    set text(fill: blue, style: "italic")
    underline(it)
  }
  // raw
  show raw.where(block: true): it => block(
    fill: codeBgColor, // Slightly off-black for better contrast
    width: auto,
    inset: 2em,
    radius: 8pt,
    breakable: true,
    // Ensure the text inside is white
    text(fill: rgb("303030"), it),
  )
  // figure
  show figure: set block(breakable: true)
  // IEEE
  set heading(numbering: "1.")
  show heading.where(level: 1): it => block(width: 100%, above: 1.2em, below: 1em)[
    #set align(left)
    #set text(weight: "regular", size: 10pt)
    #smallcaps(it)
  ]
  show heading.where(level: 2): it => block(above: 1em, below: 0.8em)[
    #set align(left)
    #set text(weight: "regular", style: "italic", size: 10pt)
    #it
  ]
  show heading.where(level: 3): it => block(above: 1em, below: 0.8em)[
    #set align(left)
    #set text(weight: "regular", style: "italic", size: 10pt)
    #it
  ]
  // set page
  set page(
    paper: "a4",
    margin: (
      top: 6cm,
      bottom: 2.54cm,
      left: 1.9cm,
      right: 1.9cm,
    ),
    header: pageHeader,
    header-ascent: 5%,
  )
  body
}
