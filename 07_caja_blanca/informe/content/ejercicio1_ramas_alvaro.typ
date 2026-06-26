=== Pruebas de Ramas (Branch Testing)

*Objetivo:* Diseñar una suite de pruebas con `pytest` que logre el *100% de cobertura de ramas (Branch Coverage)* para el módulo `bisect.py`. Esto requiere transitar por todas las aristas (True y False) de las ramificaciones y bucles del programa.

==== Grafos de Flujo de Control (CFG)

A continuación se presentan los Grafos de Flujo de Control (CFG) correspondientes a las cuatro funciones del módulo `bisect.py`, organizados en una tabla compacta para optimizar el espacio:

#align(center)[
  #table(
    columns: (1fr, 1fr),
    stroke: 0.5pt + rgb("#e2e8f0"),
    fill: none,
    inset: 10pt,
    align: center + horizon,
    figure(
      image("../src/fig/ejercicio1/bisect_left.pdf", width: 85%),
      caption: [CFG de `bisect_left`],
    ),
    figure(
      image("../src/fig/ejercicio1/bisect_right.pdf", width: 85%),
      caption: [CFG de `bisect_right`],
    ),

    figure(
      image("../src/fig/ejercicio1/insort_left.pdf", width: 85%),
      caption: [CFG de `insort_left`],
    ),
    figure(
      image("../src/fig/ejercicio1/insort_right.pdf", width: 85%),
      caption: [CFG de `insort_right`],
    ),
  )
]

==== Tabla de Casos de Prueba (Ramas)

Para lograr el 100% de cobertura de ramas en todo el módulo `bisect.py`, se diseñaron casos de prueba individuales para cada una de sus funciones. A continuación se detallan las tablas de casos de prueba separadas por función:

===== 1. Función `bisect_left`

#table(
  columns: (0.6fr, 1.8fr, 2.2fr, 1.8fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*Entradas*],
  table.cell(fill: rgb("#2c3e50"))[*Decisiones / Ramas*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado Esperado*],
  table.cell(fill: rgb("#2c3e50"))[*Camino*],

  [TB-01],
  [a = [1, 2, 3] \ x = 2 \ lo = -1 \ hi = None \ key = None],
  [lo < 0 \ (True)],
  [Lanza `ValueError`],
  [1 -> 2 -> 15 \ (Error)],
  [TB-02],
  [a = [10, 30, 50] \ x = 40 \ lo = 0 \ hi = None \ key = None],
  [lo < 0 (False) \ hi is None (True) \ key is None (True) \ while lo < hi (True/False) \ a[mid] < x (True/False)],
  [Retorna `2`],
  [1 -> 3 -> 4 -> 5 -> 6 \ -> 7 -> 8 -> 6 -> 7 \ -> 9 -> 6 -> 15],
  [TB-03],
  [a = [10, 30, 50] \ x = 40 \ lo = 0 \ hi = 3 \ key = lambda x: x],
  [lo < 0 (False) \ hi is None (False) \ key is None (False) \ while lo < hi (True/False) \ key(a[mid]) < x (True/False)],
  [Retorna `2`],
  [1 -> 3 -> 5 -> 10 -> 11 \ -> 12 -> 13 -> 11 -> 12 \ -> 14 -> 11 -> 15],
)

===== 2. Función `bisect_right`

#table(
  columns: (0.6fr, 1.8fr, 2.2fr, 1.8fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*Entradas*],
  table.cell(fill: rgb("#2c3e50"))[*Decisiones / Ramas*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado Esperado*],
  table.cell(fill: rgb("#2c3e50"))[*Camino*],

  [TB-04],
  [a = [1, 2, 3] \ x = 2 \ lo = -1 \ hi = None \ key = None],
  [lo < 0 \ (True)],
  [Lanza `ValueError`],
  [1 -> 2 -> 15 \ (Error)],
  [TB-05],
  [a = [10, 30, 50] \ x = 40 \ lo = 0 \ hi = None \ key = None],
  [lo < 0 (False) \ hi is None (True) \ key is None (True) \ while lo < hi (True/False) \ a[mid] <= x (True/False)],
  [Retorna `2`],
  [1 -> 3 -> 4 -> 5 -> 6 \ -> 7 -> 8 -> 6 -> 7 \ -> 9 -> 6 -> 15],
  [TB-06],
  [a = [10, 30, 50] \ x = 40 \ lo = 0 \ hi = 3 \ key = lambda x: x],
  [lo < 0 (False) \ hi is None (False) \ key is None (False) \ while lo < hi (True/False) \ key(a[mid]) <= x (True/False)],
  [Retorna `2`],
  [1 -> 3 -> 5 -> 10 -> 11 \ -> 12 -> 13 -> 11 -> 12 \ -> 14 -> 11 -> 15],
)

===== 3. Función `insort_left`

#table(
  columns: (0.6fr, 1.8fr, 2.2fr, 1.8fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*Entradas*],
  table.cell(fill: rgb("#2c3e50"))[*Decisiones / Ramas*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado Esperado*],
  table.cell(fill: rgb("#2c3e50"))[*Camino*],

  [TB-07],
  [a = [10, 20, 30] \ x = 25 \ lo = 0 \ hi = None \ key = None],
  [key is None \ (True)],
  [Inserta `25` en `a` \ (a = [10, 20, 25, 30])],
  [1 -> 2 -> 4],
  [TB-08],
  [a = [10, 20, 30] \ x = 25 \ lo = 0 \ hi = None \ key = lambda x: x],
  [key is None \ (False)],
  [Inserta `25` en `a` \ (a = [10, 20, 25, 30])],
  [1 -> 3 -> 4],
)

===== 4. Función `insort_right`

#table(
  columns: (0.6fr, 1.8fr, 2.2fr, 1.8fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*Entradas*],
  table.cell(fill: rgb("#2c3e50"))[*Decisiones / Ramas*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado Esperado*],
  table.cell(fill: rgb("#2c3e50"))[*Camino*],

  [TB-09],
  [a = [10, 20, 30] \ x = 25 \ lo = 0 \ hi = None \ key = None],
  [key is None \ (True)],
  [Inserta `25` en `a` \ (a = [10, 20, 25, 30])],
  [1 -> 2 -> 4],
  [TB-10],
  [a = [10, 20, 30] \ x = 25 \ lo = 0 \ hi = None \ key = lambda x: x],
  [key is None \ (False)],
  [Inserta `25` en `a` \ (a = [10, 20, 25, 30])],
  [1 -> 3 -> 4],
)

==== Código de Pruebas de Ramas (Fragmento)

El código de pruebas completo está disponible en el repositorio: #link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/07_caja_blanca/code/test/test_bisect_ramas.py")[test_bisect_ramas.py]. A continuación se muestra un fragmento representativo que implementa los casos de prueba para `bisect_left`:

#block(
  fill: rgb("#F1F3F4"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(size: 8pt)[
      ```py
      # Forzar el uso de la implementación en Python puro para poder medir cobertura
      sys.modules["_bisect"] = None
      import bisect
      importlib.reload(bisect)
      from bisect import bisect_left

      def test_bisect_left_lo_negative():
          """Flujo 1: lo < 0 es True -> Lanza ValueError (Nodos 1 -> 2 -> 15)"""
          with pytest.raises(ValueError, match="lo must be non-negative"):
              bisect_left([1, 2, 3], 2, lo=-1)

      def test_bisect_left_flow_key_none():
          """Flujo 2: lo >= 0, hi is None, key is None (Nodos 1 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 6 -> 7 -> 9 -> 6 -> 15)"""
          assert bisect_left([10, 30, 50], 40, lo=0, hi=None, key=None) == 2

      def test_bisect_left_flow_key_present():
          """Flujo 3: lo >= 0, hi is not None, key is not None (Nodos 1 -> 3 -> 5 -> 10 -> 11 -> 12 -> 13 -> 11 -> 12 -> 14 -> 11 -> 15)"""
          assert bisect_left([10, 30, 50], 40, lo=0, hi=3, key=lambda x: x) == 2
      ```
    ]
  ],
)

==== Reporte de Cobertura de Ramas (Terminal)

La ejecución de la suite de pruebas unitarias demuestra que se alcanzó el *100% de cobertura de ramas (Branch Coverage)* sobre el código en Python puro:

#figure(
  image("../src/img/code/success_branches.png", width: 85%),
  caption: [Resultado de la ejecución del reporte de cobertura de ramas con pytest],
)
