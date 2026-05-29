// 06_casos_avl.typ — Casos de Prueba: Análisis de Valores Límite (UI)

#let valid = text(fill: rgb("#1a7a1a"), weight: "bold")[Válida]
#let invalid = text(fill: rgb("#b30000"), weight: "bold")[Inválida]
#let pass = text(fill: rgb("#1a7a1a"), weight: "bold")[PASA]

Las siguientes tablas documentan los casos de prueba diseñados con la técnica de
*Análisis de Valores Límite* (AVL) para los validadores de la capa UI
(`views.py`) y el servicio simulado (`dummy_service.py`).
En AVL se prueban los valores exactamente en los bordes de cada partición:
el límite inferior, el valor inmediatamente por debajo, el límite superior
y el valor inmediatamente por encima.

#v(0.5em)

=== AVL-01 — `validate_amount`

El dominio válido es $(0, +infinity)$; el único límite relevante es el valor
mínimo aceptable, que según la lógica de `views.py` es cualquier valor
estrictamente mayor que cero.

#table(
  columns: (0.7fr, 1fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Límite],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [AVL-01-1], [Mínimo válido],        [`"0.01"`], [Retorna `Decimal("0.01")`],              pass,
  [AVL-01-2], [Justo en el límite],   [`"0"`],    [Lanza `ValueError` — mensaje "mayor a 0"], pass,
)

#v(0.8em)

=== AVL-02 — `validate_month`

El dominio válido es $[1, 12]$; se prueban los cuatro valores canónicos de AVL:
límite inferior, por debajo del límite inferior, límite superior y por encima
del límite superior.

#table(
  columns: (0.7fr, 1.2fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Límite],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [AVL-02-1], [Inferior válido],       [`"1"`],  [Retorna `1`],                              pass,
  [AVL-02-2], [Bajo el límite inf.],   [`"0"`],  [Lanza `ValueError` — mensaje "entre 1 y 12"], pass,
  [AVL-02-3], [Superior válido],       [`"12"`], [Retorna `12`],                             pass,
  [AVL-02-4], [Sobre el límite sup.],  [`"13"`], [Lanza `ValueError` — mensaje "entre 1 y 12"], pass,
)

#v(0.8em)

=== AVL-03 — `validate_year`

El dominio válido es $[2000, +infinity)$; el límite inferior es 2000.

#table(
  columns: (0.7fr, 1.2fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Límite],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [AVL-03-1], [Inferior válido],      [`"2000"`], [Retorna `2000`],                           pass,
  [AVL-03-2], [Bajo el límite inf.],  [`"1999"`], [Lanza `ValueError` — mensaje "2000 o posterior"], pass,
)

#v(0.8em)

=== AVL-04 — `validate_name`

El dominio válido es cualquier cadena con al menos un carácter no-espacio.
El límite inferior es una cadena de longitud 1.

#table(
  columns: (0.7fr, 1.2fr, 1.1fr, 1.5fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Límite],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [AVL-04-1], [Longitud mínima],  [`"A"`],  [Retorna `"A"`],                              pass,
)
