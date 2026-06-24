=== Instrucciones para Alisson (Prueba de Combinación de Condiciones)

*Objetivo:* Diseñar una suite de pruebas con `pytest` enfocada en la *Prueba de Combinación de Condiciones (Branch Condition Combination Testing / Multiple Condition Coverage)* para el módulo `bisect.py`.

==== Consideraciones de Diseño:
La cobertura de combinación de condiciones requiere probar todas las combinaciones de verdad de las condiciones atómicas que conforman una decisión compuesta. Si una decisión consta de $N$ condiciones atómicas unidas por operadores lógicos (`and`, `or`), se requieren $2^N$ casos de prueba para esa decisión.

En `bisect.py`, las decisiones son simples (constan de una sola condición atómica, como `if lo < 0` o `if key is None`). Sin embargo, para cumplir formalmente con esta técnica, debes:
1. Mapear cada condición atómica e identificar sus combinaciones.
2. Elaborar la tabla de verdad para las decisiones de control clave.
3. Escribir la suite de pruebas unitarias en `test_bisect_condiciones.py` y ejecutarla:
   ```bash
   pytest test_bisect_condiciones.py -v --cov=bisect --cov-branch
   ```

==== Tabla de Combinación de Condiciones (Ejemplo para `bisect_right`)

#table(
  columns: (0.8fr, 1.2fr, 1.2fr, 1.2fr, 1.8fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Headers
  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*C1 (lo < 0)*],
  table.cell(fill: rgb("#2c3e50"))[*C2 (hi is None)*],
  table.cell(fill: rgb("#2c3e50"))[*C3 (key is None)*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado del Flujo / Excepción*],

  [TC-01], [V (True)], [V (True)], [V (True)], [Lanza `ValueError` (C1 interrumpe)],
  [TC-02], [F (False)], [V (True)], [V (True)], [Establece `hi = len(a)` y usa `bisect_right` sin key],
  [TC-03], [F (False)], [F (False)], [V (True)], [Usa rango acotado `[lo, hi]` sin key],
  [TC-04], [F (False)], [V (True)], [F (False)], [Establece `hi = len(a)` y usa `bisect_right` con key],
  [TC-05], [F (False)], [F (False)], [F (False)], [Usa rango acotado con key],
)

==== Código de Pruebas de Combinación de Condiciones (`test_bisect_condiciones.py`)

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
      from bisect import bisect_right

      def test_combination_c2_c3_true():
          # lo >= 0 (F), hi is None (V), key is None (V)
          assert bisect_right([10, 20, 30], 25) == 2
      ```
    ]
  ]
)

==== Reporte de Cobertura de Condiciones (Terminal)

#block(
  fill: rgb("#000000"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(fill: rgb("#00FF00"), size: 8.5pt)[
      \$ pytest test_bisect_condiciones.py -v --cov=bisect --cov-branch\n
      #raw("Name        Stmts   Miss Branch BrPart  Cover\n---------------------------------------------\nbisect.py      48      0     26      0   100%\n---------------------------------------------\nTOTAL          48      0     26      0   100%")
    ]
  ]
)
