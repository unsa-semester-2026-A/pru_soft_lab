=== Instrucciones para Alvaro (Prueba de Ramas)

*Objetivo:* Diseñar una suite de pruebas con `pytest` que logre el *100% de cobertura de ramas (Branch Coverage)* para el módulo `bisect.py`. Esto requiere transitar por todas las aristas (True y False) de las ramificaciones y bucles del programa.

==== Metodología y Pasos a Seguir:
1. Identifica todos los puntos de decisión en `bisect.py`. Esto incluye:
   - Evaluaciones `if` (como `if lo < 0`, `if hi is None`, `if key is None`).
   - Comparaciones booleanas dentro del bucle (`x < a[mid]`, `a[mid] < x`).
   - El bucle `while lo < hi` (cuando se ejecuta y cuando no ingresa al bucle).
2. Escribe los casos de prueba en un archivo `test_bisect_ramas.py`.
3. Ejecuta la suite de pruebas midiendo la cobertura de ramas:
   ```bash
   pytest test_bisect_ramas.py -v --cov=bisect --cov-branch
   ```
4. Completa la tabla de casos de prueba y pega los resultados de la terminal.

==== Tabla de Casos de Prueba (Ramas)

#table(
  columns: (0.8fr, 1.8fr, 1.2fr, 1.8fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Headers
  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*Entradas (a, x, lo, hi, key)*],
  table.cell(fill: rgb("#2c3e50"))[*Decisión / Rama Evaluada*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado Esperado*],
  table.cell(fill: rgb("#2c3e50"))[*Camino Transitado*],

  [TB-01], [`a = [1, 2, 3], x = 2, lo = 0, hi = 0`], [`while lo < hi`], [Retorna `0` sin entrar al bucle], [Bucle `while` evaluado como FALSO],
  [TB-02], [`a = [1, 2, 3], x = 2, lo = 0, hi = 3`], [`while lo < hi`], [Ingresa al bucle y retorna índice], [Bucle `while` evaluado como VERDADERO],
  [TB-03], [`a = [2], x = 1`], [`if x < a[mid]` en `bisect_right`], [Establece `hi = mid`], [Decisión `if` evaluada como VERDADERO],
  [TB-04], [`a = [2], x = 3`], [`if x < a[mid]` en `bisect_right`], [Establece `lo = mid + 1`], [Decisión `if` evaluada como FALSO],
  [TB-05], [Por completar], [Por completar], [Por completar], [Por completar]
)

==== Código de Pruebas de Ramas (`test_bisect_ramas.py`)

#block(
  fill: rgb("#F1F3F4"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(size: 8pt)[
      ```py
      # Escribe aquí tu código pytest
      import pytest
      from bisect import bisect_right, bisect_left

      def test_bisect_right_empty_range():
          # Prueba del bucle while evaluado como Falso inmediatamente
          assert bisect_right([1, 2, 3], 2, lo=1, hi=1) == 1
      ```
    ]
  ]
)

==== Reporte de Cobertura de Ramas (Terminal)

#block(
  fill: rgb("#000000"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(fill: rgb("#00FF00"), size: 8.5pt)[
      \$ pytest test_bisect_ramas.py -v --cov=bisect --cov-branch\n
      #raw("Name        Stmts   Miss Branch BrPart  Cover\n---------------------------------------------\nbisect.py      48      0     26      0   100%\n---------------------------------------------\nTOTAL          48      0     26      0   100%")
    ]
  ]
)
