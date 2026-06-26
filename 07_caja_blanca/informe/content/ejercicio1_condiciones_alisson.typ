=== Instrucciones para Alisson (Prueba de Combinación de Condiciones)

// *Objetivo:* Diseñar una suite de pruebas con `pytest` enfocada en la *Prueba de Combinación de Condiciones (Branch Condition Combination Testing / Multiple Condition Coverage)* para el módulo `bisect.py`.

==== Consideraciones de Diseño:

La cobertura de combinación de condiciones requiere probar todas las combinaciones de verdad de las condiciones atómicas que conforman una decisión compuesta. Si una decisión consta de $N$ condiciones atómicas unidas por operadores lógicos (`and`, `or`), se requieren $2^N$ casos de prueba para esa decisión.

En `bisect.py`, las decisiones son simples (constan de una sola condición atómica, como `if lo < 0` o `if key is None`). Sin embargo, para cumplir formalmente con esta técnica, debes:
1. Mapear cada condición atómica e identificar sus combinaciones.
2. Elaborar la tabla de verdad para las decisiones de control clave.
3. Escribir la suite de pruebas unitarias en `test_bisect_condiciones.py` y ejecutarla:
  ```bash
  pytest test_bisect_condiciones.py -v
  ```

==== Análisis de Condiciones Atómicas en `bisect.py`

Las decisiones compuestas (con `and`/`or`) requieren combinaciones exhaustivas. En `bisect.py`, las decisiones son simples (una sola condición atómica), por lo que cada una requiere solo 2 combinaciones (V y F). Sin embargo, se analizan todas las ramas para garantizar cobertura completa:

#table(
  columns: (0.8fr, 1.5fr, 1.2fr, 1.5fr, 2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#dfdfdf") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  // Headers
  table.cell(fill: rgb("#f8f9fa"))[*ID*],
  table.cell(fill: rgb("#f8f9fa"))[*Función*],
  table.cell(fill: rgb("#f8f9fa"))[*Condición*],
  table.cell(fill: rgb("#f8f9fa"))[*Combinación*],
  table.cell(fill: rgb("#f8f9fa"))[*Resultado Esperado*],

  [CC-01], [`bisect_right`], [`if lo < 0`], [V (True)], [Lanza `ValueError`],
  [CC-02], [`bisect_right`], [`if lo < 0`], [F (False)], [Continúa ejecución],
  [CC-03], [`bisect_right`], [`if hi is None`], [V (True)], [Establece `hi = len(a)`],
  [CC-04], [`bisect_right`], [`if hi is None`], [F (False)], [Acota búsqueda: busca `40` con `hi=2`],
  [CC-05], [`bisect_right`], [`if key is None`], [V (True)], [Bucle sin key],
  [CC-06], [`bisect_right`], [`if key is None`], [F (False)], [Bucle con key],
  [CC-07], [`bisect_right`], [`while lo < hi`], [V (True)], [Entra al bucle],
  [CC-08], [`bisect_right`], [`while lo < hi`], [F (False)], [No entra al bucle],
  [CC-09], [`bisect_right`], [`if x < a[mid]`], [V (True)], [Establece `hi = mid`],
  [CC-10], [`bisect_right`], [`if x < a[mid]`], [F (False)], [Establece `lo = mid + 1`],
  [CC-11], [`bisect_left`], [`if lo < 0`], [V (True)], [Lanza `ValueError`],
  [CC-12], [`bisect_left`], [`if lo < 0`], [F (False)], [Continúa ejecución],
  [CC-13], [`bisect_left`], [`if hi is None`], [V (True)], [Establece `hi = len(a)`],
  [CC-14], [`bisect_left`], [`if hi is None`], [F (False)], [Acota búsqueda: busca `40` con `hi=2`],
  [CC-15], [`bisect_left`], [`if key is None`], [V (True)], [Bucle sin key],
  [CC-16], [`bisect_left`], [`if key is None`], [F (False)], [Bucle con key],
  [CC-17], [`bisect_left`], [`while lo < hi`], [V (True)], [Entra al bucle],
  [CC-18], [`bisect_left`], [`while lo < hi`], [F (False)], [No entra al bucle],
  [CC-19], [`bisect_left`], [`if a[mid] < x`], [V (True)], [Establece `lo = mid + 1`],
  [CC-20], [`bisect_left`], [`if a[mid] < x`], [F (False)], [Establece `hi = mid`],
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
      """Pruebas de Combinación de Condiciones para bisect.py.

      Branch Condition Combination Testing / Multiple Condition Coverage.
      """
      import os
      import sys
      sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
      from bisect import bisect_left, bisect_right, insort_left, insort_right
      import pytest

      # =========================================================
      # BISECT_RIGHT - Combinación de Condiciones
      # =========================================================

      def test_cc_right_lo_negativo():
          """CC-01: lo < 0 es VERDADERO → lanza ValueError"""
          with pytest.raises(ValueError, match="lo must be non-negative"):
              bisect_right([1, 2, 3], 2, lo=-1)

      def test_cc_right_lo_positivo():
          """CC-02: lo < 0 es FALSO → continúa ejecución"""
          assert bisect_right([1, 2, 3], 2, lo=0) == 2

      def test_cc_right_hi_none_verdadero():
          """CC-03: hi is None es VERDADERO → establece hi = len(a)"""
          assert bisect_right([10, 20, 30], 25) == 2

      def test_cc_right_hi_none_falso():
          """CC-04: hi is None es FALSO → acota la búsqueda"""
          assert bisect_right([10, 20, 30], 40, hi=2) == 2

      def test_cc_right_key_none_verdadero():
          """CC-05: key is None es VERDADERO → ejecuta bucle sin key"""
          assert bisect_right([1, 3, 5, 7], 4) == 2

      def test_cc_right_key_none_falso():
          """CC-06: key is None es FALSO → ejecuta bucle con key"""
          assert bisect_right(["a", "c", "e"], "d", key=lambda x: x) == 2

      def test_cc_right_while_true():
          """CC-07: while lo < hi es VERDADERO → entra al bucle"""
          assert bisect_right([1, 2, 3, 4, 5], 3) == 3

      def test_cc_right_while_false():
          """CC-08: while lo < hi es FALSO → no entra al bucle"""
          assert bisect_right([1, 2, 3], 2, lo=2, hi=2) == 2

      def test_cc_right_x_less_than_mid():
          """CC-09: x < a[mid] es VERDADERO → establece hi = mid"""
          assert bisect_right([1, 2, 3], 1) == 1

      def test_cc_right_x_not_less_than_mid():
          """CC-10: x < a[mid] es FALSO → establece lo = mid + 1"""
          assert bisect_right([1, 2, 3], 3) == 3

      # =========================================================
      # BISECT_LEFT - Combinación de Condiciones
      # =========================================================

      def test_cc_left_lo_negativo():
          """CC-11: lo < 0 es VERDADERO → lanza ValueError"""
          with pytest.raises(ValueError, match="lo must be non-negative"):
              bisect_left([1, 2, 3], 2, lo=-1)

      def test_cc_left_lo_positivo():
          """CC-12: lo < 0 es FALSO → continúa ejecución"""
          assert bisect_left([1, 2, 3], 2, lo=0) == 1

      def test_cc_left_hi_none_verdadero():
          """CC-13: hi is None es VERDADERO → establece hi = len(a)"""
          assert bisect_left([10, 20, 30], 20) == 1

      def test_cc_left_hi_none_falso():
          """CC-14: hi is None es FALSO → acota la búsqueda"""
          assert bisect_left([10, 20, 30], 40, hi=2) == 2

      def test_cc_left_key_none_verdadero():
          """CC-15: key is None es VERDADERO → ejecuta bucle sin key"""
          assert bisect_left([1, 3, 5, 7], 4) == 2

      def test_cc_left_key_none_falso():
          """CC-16: key is None es FALSO → ejecuta bucle con key"""
          assert bisect_left(["a", "c", "e"], "d", key=lambda x: x) == 2

      def test_cc_left_while_true():
          """CC-17: while lo < hi es VERDADERO → entra al bucle"""
          assert bisect_left([1, 2, 3, 4, 5], 3) == 2

      def test_cc_left_while_false():
          """CC-18: while lo < hi es FALSO → no entra al bucle"""
          assert bisect_left([1, 2, 3], 2, lo=2, hi=2) == 2

      def test_cc_left_a_mid_less_than_x():
          """CC-19: a[mid] < x es VERDADERO → establece lo = mid + 1"""
          assert bisect_left([1, 2, 3], 3) == 2

      def test_cc_left_a_mid_not_less_than_x():
          """CC-20: a[mid] < x es FALSO → establece hi = mid"""
          assert bisect_left([1, 2, 3], 1) == 0

      # =========================================================
      # INSORT - Combinación de Condiciones
      # =========================================================

      def test_insort_right_key_none():
          """insort_right con key=None → inserta a la derecha de duplicados"""
          a = [10, 20, 20, 30]
          insort_right(a, 20)
          assert a == [10, 20, 20, 20, 30]

      def test_insort_right_key_func():
          """insort_right con key_func → inserta con transformación"""
          a = ["a", "c", "e"]
          insort_right(a, "d", key=lambda x: ord(x))
          assert a == ["a", "c", "d", "e"]

      def test_insort_left_key_none():
          """insort_left con key=None → inserta a la izquierda de duplicados"""
          a = [10, 20, 20, 30]
          insort_left(a, 20)
          assert a == [10, 20, 20, 20, 30]

      def test_insort_left_key_func():
          """insort_left con key_func → inserta con transformación"""
          a = ["a", "c", "e"]
          insort_left(a, "d", key=lambda x: ord(x))
          assert a == ["a", "c", "d", "e"]
      ```
    ]
  ],
)


==== Reporte de Cobertura de Condiciones (Terminal)

```bash
pytest test_bisect_condiciones.py -v
```

#figure(
  image("../src/img/code/success_conditions.png", width: 80%),
  caption: [Resultado de ejecución de pruebas de combinación de condiciones],
)
