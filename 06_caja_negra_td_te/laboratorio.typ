// fonts
#set text(
  // font: "New Computer Modern",
  font: "Lato",
  lang: "es"
)

#import  "informe/util/util.typ" as util
#import "informe/config.typ" as config
// Constantes de diseño
#let tableBorderWidth = 0.5pt
#let headerBorderColor = rgb("#808080")
#let tbHeaderBgColor = rgb("#C8310E")
#let codeBgColor = rgb("#F1F3F4")

// Document formart
#show raw.where(block: true): it => block(
  fill: codeBgColor, // Slightly off-black for better contrast
  width: auto,
  inset: 2em,
  radius: 8pt,
  breakable: true,
  // Ensure the text inside is white
  text(fill: rgb("303030"), it) 
)
#show figure: set block(breakable: true)

// IEEE like
#set heading(numbering: "1.")
// H1
#show heading.where(level: 1): it => block(width: 100%, above: 1.2em, below: 1em)[
  #set align(left)
  #set text(weight: "regular", size: 10pt)
  #smallcaps(it)
]
// H2
#show heading.where(level: 2): it => block(above: 1em, below: 0.8em)[
  #set align(left)
  #set text(weight: "regular", style: "italic", size: 10pt)
  #it
]
// H3
#show heading.where(level: 3): it => block(above: 1em, below: 0.8em)[
  #set align(left)
  #set text(weight: "regular", style: "italic", size: 10pt)
  #it
]

#let headerBig(content, weight: "regular", alignTo: none, color: black) = util.fontBuild(
  content,
  weight,
  7.5pt,
  alignTo,
  color,
)
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
#let tableContents(content, weight: "regular", alignTo: none, color: black) = util.fontBuild(
  content,
  weight,
  8.5pt,
  alignTo,
  color,
)

// technically components
#let ordList(items) = [
  #set list(
    indent: 1em,
    marker: "1.1.",
  )
  #for item in items [
    + #item
  ]
]
#let unordList(items) = [
  #set list(
    indent: 1em,
    marker: "-",
  )
  #for item in items [
    - #item
  ]
]

#let pageHeader = block(
  width: 100%,
  inset: (bottom: 1em),
)[
  #table(
    align: center + horizon,
    stroke: tableBorderWidth + headerBorderColor,
    columns: (1fr, 2fr, 1fr),
    align(horizon)[#image("informe/src/img/fixed/epis.png", width: 95%)],
    headerBig(weight: "bold")[
      UNIVERSIDAD NACIONAL DE SAN AGUSTÍN \
      FACULTAD DE INGENIERÍA DE PRODUCCIÓN Y SERVICIOS \
      ESCUELA PROFESIONAL DE INGENIERÍA DE SISTEMAS
    ],
    align(horizon)[#image("informe/src/img/fixed/abet.png", width: 97%)],
    table.cell(colspan: 3)[
      #headerSmall(weight: "bold")[Formato: ]
      #headerSmall[Guía de Práctica de Laboratorio / Talleres / Centros de Simulación]
    ],
    headerSmall(weight: "bold")[Aprobación: 2022/03/01],
    headerSmall(weight: "bold")[Código: GUIA-PRLE-001],
    context headerSmall(weight: "bold", alignTo: right)[Página: #counter(page).display("1")],
  )
]

#set page(
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

#let memberAbbvList = config.memberList.map(util.AbbreviateFullName)
#set document(
  title: upper[
    Laboratorio número #config.labNumber
  ],
)

#align(center)[#mainTitle[INFORME DE LABORATORIO]]
// General information table
#table(
  align: left + horizon,
  stroke: black + 1pt,
  inset: 0.5em,
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  table.cell(
    colspan: 6,
    fill: tbHeaderBgColor,
    tableTitle(weight: "bold", alignTo: center, color: white)[INFORMACIÓN BÁSICA],
  ),
  tableContents(weight: "bold")[Asignatura:],
  table.cell(
    colspan: 5,
    tableContents[#config.courseName],
  ),
  tableContents(weight: "bold")[Título de la práctica:],
  table.cell(
    colspan: 5,
    tableContents[#config.labTitle],
  ),
  tableContents(weight: "bold")[Número de la práctica:],
  tableContents[#config.labNumber],
  tableContents(weight: "bold")[Año lectivo:],
  tableContents[#datetime.today().year()],
  tableContents(weight: "bold")[Nro. semestre:],
  tableContents[#config.semCode],
  tableContents(weight: "bold")[Fecha de presentación:],
  tableContents[#config.presentationDate],
  tableContents(weight: "bold")[Hora de presentación:],
  table.cell(
    colspan: 3,
    tableContents[#config.presentationHour],
  ),
  table.cell(
    colspan: 4,
    [
      #tableContents(weight: "bold")[Integrante(s):] \
      #tableContents[
        #set list(marker: "-")
        #for member in config.memberList [
          - #member
        ]
      ]

    ],
  ),
  tableContents(weight: "bold")[NOTA:],
  tableContents[Nota colocada por el docente],
  table.cell(
    colspan: 6,
    [
      #tableContents(weight: "bold")[Docente: ] \
      #tableContents[#config.instructorName]
    ],
  ),
)


// Ejemplo
// #grid(
//   align: left + horizon,
//   stroke: black + 1pt,
//   inset: 0.5em,
//   columns: 1fr,
//   grid.cell(
//     fill: tbHeaderBgColor,
//     tableTitle(weight: "bold", alignTo: center, color: white)[RESULTADOS Y PRUEBAS],
//   ),
//   tableContents[
//     #set enum(numbering: "1.1.")
//     #set par(justify: true)
//     + PRUEBA DE EJERCICIOS RESUELTOS:
//       + Ejercicio 1: \
//         #codeBlock("./src/lst/A.java", lang: "java")
//         El programa usa threads extendiendo la clase Thread donde cada thread ejecuta un bucle imprimiendo números del aaaa junto con su nombre, al crear dos threads Pepe y Juan ambos se ejecutan intercalando sus salidas
//         #image("./img/fixed/abet.png")
//       + Ejercicio 2: \
//         #codeBlock("./src/lst/A.java", lang: "java")
//         El programa crea una clase que implementa Runnable donde en su método run ejecuta un bucle imprimiendo números del 1 al 5 junto con el nombre del thread, al crear dos threads Ana y Luis ambos se ejecutan intercalando sus salidas
//         #image("./img/fixed/abet.png")
//     // #lorem(10000)
//   ]
// )

// CONTENIDO
#set par(justify: true)
#table(
  align: left + top,
  stroke: black + 0.5pt,
  inset: 1em,
  columns: 1fr,
  table.cell(
    fill: tbHeaderBgColor,
    inset: 0.5em,
    align: center + horizon,
    tableTitle(weight: "bold", color: white)[SOLUCIÓN Y RESULTADOS],
  ),
  tableContents[
    = SOLUCIÓN DE EJERCICIOS/PROBLEMAS

    #include "informe/content/1_ejercicios.typ"

    
    // Espacio reservado para las soluciones
    #v(4em)
  ],
  tableContents[
    = SOLUCIÓN DEL CUESTIONARIO
    
    #include "informe/content/2_cuestionario.typ"
    #v(4em)
  ],
  tableContents[
    = CONCLUSIONES
    
    #include "informe/content/3_conclusiones.typ"
    // Espacio reservado para las conclusiones
    #v(4em)
  ]
)

// RETROALIMENTACIÓN
#grid(
  align: left + horizon,
  stroke: black + 1pt,
  inset: 0.5em,
  columns: 1fr,
  grid.cell(
    fill: tbHeaderBgColor,
    tableTitle(weight: "bold", alignTo: center, color: white)[RETROALIMENTACIÓN GENERAL],
  ),
  tableContents[
    #v(6em)
  ]
)

// REFERENCIAS
#grid(
  align: left + horizon,
  stroke: black + 1pt,
  inset: 0.5em,
  columns: 1fr,
  grid.cell(
    fill: tbHeaderBgColor,
    tableTitle(weight: "bold", alignTo: center, color: white)[REFERENCIAS Y BIBLIOGRAFÍA],
  ),
  tableContents[
    #bibliography("informe/references.bib", title: none, style: "ieee")
  ]
)
