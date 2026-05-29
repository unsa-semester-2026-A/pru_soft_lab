// 05_casos_pe.typ — Casos de Prueba: Partición de Equivalencia (UI)

#let valid = text(fill: rgb("#1a7a1a"), weight: "bold")[Válida]
#let invalid = text(fill: rgb("#b30000"), weight: "bold")[Inválida]
#let pass = text(fill: rgb("#1a7a1a"), weight: "bold")[PASA]

Las siguientes tablas documentan los casos de prueba diseñados con la técnica de
*Partición de Equivalencia* (PE) para los validadores de la capa UI
(`views.py`) y el servicio simulado (`dummy_service.py`).
En PE se identifican clases de equivalencia —válidas e inválidas— y se elige
un valor representativo de cada clase; probar ese representante equivale a
probar cualquier otro valor de la misma clase.

#v(0.5em)

=== PE-01 — `validate_amount`

#table(
  columns: (0.6fr, 1fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Clase],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [PE-01-V1], valid,   [`"150.50"`], [Retorna `Decimal("150.50")`],          pass,
  [PE-01-V2], valid,   [`"200"`],    [Retorna `Decimal("200")`],             pass,
  [PE-01-I1], invalid, [`"abc"`],    [Lanza `ValueError` — mensaje "número"], pass,
  [PE-01-I2], invalid, [`""`],       [Lanza `ValueError` — mensaje "vacío"],  pass,
  [PE-01-I3], invalid, [`"   "`],    [Lanza `ValueError` — mensaje "vacío"],  pass,
  [PE-01-I4], invalid, [`"-10"`],    [Lanza `ValueError` — mensaje "mayor a 0"], pass,
)

#v(0.8em)

=== PE-02 — `validate_name`

#table(
  columns: (0.6fr, 1fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Clase],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [PE-02-V1], valid,   [`"  Ahorros  "`], [Retorna `"Ahorros"` (con strip)],            pass,
  [PE-02-I1], invalid, [`""`],            [Lanza `ValueError` — mensaje "nombre"],      pass,
  [PE-02-I2], invalid, [`"   "`],         [Lanza `ValueError` — mensaje "nombre"],      pass,
)

#v(0.8em)

=== PE-03 — `validate_month`

#table(
  columns: (0.6fr, 1fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Clase],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [PE-03-V1], valid,   [`"6"`],     [Retorna `6`],                                    pass,
  [PE-03-I1], invalid, [`"marzo"`], [Lanza `ValueError` — mensaje "entero"],          pass,
)

#v(0.8em)

=== PE-04 — `validate_year`

#table(
  columns: (0.6fr, 1fr, 1fr, 1.6fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Clase],
    text(fill: white, weight: "bold")[Entrada],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [PE-04-V1], valid,   [`"2026"`],   [Retorna `2026`],                               pass,
  [PE-04-I1], invalid, [`"veinte"`], [Lanza `ValueError` — mensaje "entero"],        pass,
)

#v(0.8em)

=== PE-05 — `DummyFinanceService`

#table(
  columns: (0.6fr, 1.2fr, 1.4fr, 1.4fr, 0.7fr),
  fill: (_, row) => if row == 0 { rgb("#C8310E") } else if calc.odd(row) { rgb("#f9f9f9") } else { white },
  stroke: 0.5pt + rgb("#808080"),
  inset: 0.55em,
  table.header(
    text(fill: white, weight: "bold")[ID],
    text(fill: white, weight: "bold")[Clase],
    text(fill: white, weight: "bold")[Escenario],
    text(fill: white, weight: "bold")[Resultado esperado],
    text(fill: white, weight: "bold")[Estado],
  ),
  [PE-05-V1], valid,
    [Ingreso de \$100 sobre saldo inicial \$1000],
    [Saldo actualizado a `\$1100.00`],
    pass,
  [PE-05-I1], invalid,
    [Gasto de \$1000.01 sobre saldo de \$1000],
    [Lanza `InsufficientFundsError`],
    pass,
  [PE-05-V2], valid,
    [Crear cuenta → desactivar → listar activas],
    [Lista vacía (0 cuentas activas)],
    pass,
)
