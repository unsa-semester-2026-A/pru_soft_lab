= Solución de Ejercicios / Problemas


A continuación, se presenta la resolución detallada de las actividades de pruebas de caja blanca y cálculo de complejidad ciclomática desarrolladas en este laboratorio.


== Ejercicio 1: Cobertura de Caja Blanca en `bisect.py`

El módulo `bisect.py` proporciona algoritmos de bisección en Python para mantener listas ordenadas sin tener que ordenarlas después de cada inserción. Se presenta el código fuente exacto para referencia de todos:

#figure(
  ```py
    """Bisection algorithms."""

  def insort_right(a, x, lo=0, hi=None, *, key=None):
      if key is None:
          lo = bisect_right(a, x, lo, hi)
      else:
          lo = bisect_right(a, key(x), lo, hi, key=key)
      a.insert(lo, x)

  def bisect_right(a, x, lo=0, hi=None, *, key=None):
      if lo < 0:
          raise ValueError('lo must be non-negative')
      if hi is None:
          hi = len(a)
      if key is None:
          while lo < hi:
              mid = (lo + hi) // 2
              if x < a[mid]:
                  hi = mid
              else:
                  lo = mid + 1
      else:
          while lo < hi:
              mid = (lo + hi) // 2
              if x < key(a[mid]):
                  hi = mid
              else:
                  lo = mid + 1
      return lo

  def insort_left(a, x, lo=0, hi=None, *, key=None):
      if key is None:
          lo = bisect_left(a, x, lo, hi)
      else:
          lo = bisect_left(a, key(x), lo, hi, key=key)
      a.insert(lo, x)

  def bisect_left(a, x, lo=0, hi=None, *, key=None):
      if lo < 0:
          raise ValueError('lo must be non-negative')
      if hi is None:
          hi = len(a)
      if key is None:
          while lo < hi:
              mid = (lo + hi) // 2
              if a[mid] < x:
                  lo = mid + 1
              else:
                  hi = mid
      else:
          while lo < hi:
              mid = (lo + hi) // 2
              if key(a[mid]) < x:
                  lo = mid + 1
              else:
                  hi = mid
      return lo
  ```,
  caption: [Módulo `bisect.py` de la biblioteca estándar de Python (#link("https://github.com/python/cpython/blob/main/Lib/bisect.py")[url])],
)

#include "ejercicio1_sentencias_leo.typ"

#include "ejercicio1_ramas_alvaro.typ"

#include "ejercicio1_condiciones_alisson.typ"

== Ejercicio 2: Complejidad Ciclomática (Guerra de Testers - Parte III)

Para este ejercicio, evaluamos funciones del sistema *FinanceApp* que se encuentra en la carpeta `development/`.
*Nota crítica del equipo:* Se debe analizar exclusivamente el código adjunto en este espacio de trabajo para evitar discrepancias.

A continuación, cada integrante presenta el análisis detallado de la función asignada, incluyendo su Grafo de Flujo de Control (CFG), la matemática del cálculo de Complejidad Ciclomática (CC) por fórmulas, y la comparación del score obtenido mediante la herramienta `radon`.

#include "ejercicio2_cc_alvaro.typ"

#include "ejercicio2_cc_alisson.typ"

#include "ejercicio2_cc_leo.typ"
