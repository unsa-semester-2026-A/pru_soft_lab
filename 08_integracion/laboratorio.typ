
#import "./informe/style.typ" as style
#show: style.template_styles
#import "informe/config.typ" as config
#import "informe/util/util.typ" as util

#set document(
  title: upper[
    Laboratorio número #config.labNumber
  ],
)

#align(center)[#style.mainTitle[INFORME DE LABORATORIO]]

#include "informe/front-matter.typ"

// CONTENIDO
#set par(justify: true)
#table(
  stroke: 0.5pt,
  inset: 1em,
  columns: 1fr,
  table.cell(
    fill: style.tbHeaderBgColor,
    inset: 0.5em,
    align: center + horizon,
    style.tableTitle(weight: "bold", color: white)[SOLUCIÓN Y RESULTADOS],
  ),
  [#include "informe/content/ejercicios.typ"],
  [#include "informe/content/cuestionario.typ"],
  [#include "informe/content/conclusiones.typ"]
)

// RETROALIMENTACIÓN
#grid(
  align: left + horizon,
  stroke: black + 1pt,
  inset: 0.5em,
  columns: 1fr,
  grid.cell(
    fill: style.tbHeaderBgColor,
    style.tableTitle(weight: "bold", alignTo: center, color: white)[RETROALIMENTACIÓN GENERAL],
  ),
  [#v(6em)]
)

// REFERENCIAS
#grid(
  align: left + horizon,
  stroke: black + 1pt,
  inset: 0.5em,
  columns: 1fr,
  grid.cell(
    fill: style.tbHeaderBgColor,
    style.tableTitle(weight: "bold", alignTo: center, color: white)[REFERENCIAS Y BIBLIOGRAFÍA],
  ),
  [#bibliography("informe/references.bib", title: none, style: "ieee")]
)
