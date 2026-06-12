#import  "informe/util/util.typ" as util
#import "informe/config.typ" as config
// Constantes de diseño
#let tableBorderWidth = 0.5pt
#let headerBorderColor = rgb("#808080")
#let tbHeaderBgColor = rgb("#C8310E")
#let codeBgColor = rgb("#F1F3F4")
// fonts
#set text(
  font: "Lato",
  lang: "es",
)
#set heading(numbering: "1.")
#show heading: it => {
  set text(size: 8.5pt, weight: "bold")
  it
}
#show link: it => underline(
  text(fill: rgb("#05A7F7"), it)
)
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
    headerSmall(weight: "bold")[Código: GUIA-PRLD-001],
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
  tableContents(weight: "bold")[ASIGNATURA:],
  table.cell(
    colspan: 5,
    tableContents[#config.courseName],
  ),
  tableContents(weight: "bold")[TÍTULO DE LA PRÁCTICA:],
  table.cell(
    colspan: 5,
    tableContents[#config.labTitle],
  ),
  tableContents(weight: "bold")[NÚMERO DE LA PRÁCTICA:],
  tableContents[#config.labNumber],
  tableContents(weight: "bold")[AÑO LECTIVO:],
  tableContents[#datetime.today().year()],
  tableContents(weight: "bold")[NRO. SEMESTRE:],
  tableContents[#config.semCode],
  tableContents(weight: "bold")[FECHA DE PRESENTACIÓN:],
  tableContents[#config.presentationDate],
  tableContents(weight: "bold")[HORA DE PRESENTACIÓN:],
  table.cell(
    colspan: 3,
    tableContents[#config.presentationHour],
  ),
  table.cell(
    colspan: 4,
    [
      #tableContents(weight: "bold")[INTEGRANTE(s):] \
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
      #tableContents(weight: "bold")[DOCENTE: ] \
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
    #heading(level: 1)[SOLUCIÓN DE EJERCICIOS/PROBLEMAS]

    #include "informe/content/1_ejercicios.typ"

    
    // Espacio reservado para las soluciones
    #v(4em)
  ],
  tableContents[
    #heading(level: 1)[\u{00A0}\u{00A0}SOLUCIÓN DEL CUESTIONARIO]
    
    #include "informe/content/2_cuestionario.typ"
    #v(4em)
  ],
  tableContents[
    #heading(level: 1)[\u{00A0}CONCLUSIONES] 
    
    #include "informe/content/3_conclusiones.typ"
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

#set par(justify: true)
// #lorem(10000)
