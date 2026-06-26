=== Pruebas de Sentencia (Statement Testing)

*Objetivo:* Diseñar una suite de pruebas con `pytest` que logre el *100% de cobertura de sentencias (Statement Coverage)* para el módulo `bisect.py`. Esto significa que cada línea de instrucción ejecutable en el código provisto debe ser ejecutada al menos una vez.

==== Metodología y Pasos a Seguir:
1. Identifica todas las sentencias ejecutables en `bisect.py`. Presta especial atención a:
   - Validaciones de parámetros (ej: `lo < 0` que lanza `ValueError`).
   - Ramas con `key is None` y `key is not None`.
   - Bucle `while lo < hi` en `bisect_right` y `bisect_left`.
2. Escribe los casos de prueba en un archivo `test_bisect_sentencias.py`.
3. Ejecuta la suite de pruebas midiendo la cobertura de código con el plugin `pytest-cov`:
   ```bash
   pytest test_bisect_sentencias.py -v --cov=bisect
   ```
4. Completa la tabla de casos de prueba y pega los resultados de la terminal a continuación.

==== Tabla de Casos de Prueba (Sentencias)

#table(
  columns: (0.8fr, 1.8fr, 1.2fr, 1.8fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#2c3e50") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Headers
  table.cell(fill: rgb("#2c3e50"))[*ID*],
  table.cell(fill: rgb("#2c3e50"))[*Entradas (a, x, lo, hi, key)*],
  table.cell(fill: rgb("#2c3e50"))[*Función Evaluada*],
  table.cell(fill: rgb("#2c3e50"))[*Resultado / Efecto Esperado*],
  table.cell(fill: rgb("#2c3e50"))[*Líneas Cubiertas*],

  [TS-01], [`a = [1, 2, 3], x = 2, lo = -1`], [`bisect_right`], [Lanza `ValueError` ("lo must be non-negative")], [Validación `lo < 0`],
  [TS-02], [`a = [1, 3, 5], x = 4, lo = 0, hi = None, key = None`], [`bisect_right`], [Retorna `2` (posición para insertar 4)], [Bucle `while` con `key = None`],
  [TS-03], [`a = [1, 3, 5], x = 4, key = lambda v: v`], [`bisect_right`], [Retorna `2`], [Bucle `while` con `key` activa],
  [TS-04], [Por completar], [Por completar], [Por completar], [Por completar]
)

==== Código de Pruebas de Sentencias (`test_bisect_sentencias.py`)

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
      from bisect import bisect_right, bisect_left, insort_right, insort_left

      def test_bisect_right_lo_negative():
          with pytest.raises(ValueError, match="lo must be non-negative"):
              bisect_right([1, 2, 3], 2, lo=-1)
      ```
    ]
  ]
)

==== Reporte de Cobertura de Sentencias (Terminal)

#block(
  fill: rgb("#000000"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(fill: rgb("#00FF00"), size: 8.5pt)[
      \$ pytest test_bisect_sentencias.py -v --cov=bisect\n
      #raw("Name        Stmts   Miss  Cover\n-------------------------------\nbisect.py      48      0   100%\n-------------------------------\nTOTAL          48      0   100%")
    ]
  ]
)
