#import "style.typ" as style
#import "config.typ" as config
#set text(
  size: 8.5pt,
)
// Front matter
#table(
  align: left + horizon,
  stroke: black + 0.5pt,
  inset: 0.5em,
  columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  table.cell(
    colspan: 6,
    fill: style.tbHeaderBgColor,
    style.tableTitle(weight: "bold", alignTo: center, color: white)[INFORMACIÓN BÁSICA],
  ),
  [*Asignatura:*], table.cell(colspan: 5, [#config.courseName]),
  [*Título de la práctica:*], table.cell(colspan: 5, [#config.labTitle]),
  [*Número de la práctica:*], [#config.labNumber],
  [*Año lectivo:*], [#datetime.today().year()],
  [*Nro. semestre:*], [#config.semCode],
  [*Fecha de presentación:*], [#config.presentationDate],
  [*Hora de presentación:*], table.cell(colspan: 3, [#config.presentationHour]),
  table.cell(
    colspan: 4,
    [
      *Integrante(s):*
      #set list(marker: "-")
      #for member in config.memberList [
        - #member
      ]

    ],
  ),
  [*NOTA:*], [Nota colocada por el docente],
  table.cell(
    colspan: 6,
    [
      *Docente:*\
      #config.instructorName
    ],
  ),
)
