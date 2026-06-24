= Solución de Ejercicios / Problemas

Este documento contiene la repartición de tareas, instrucciones y los espacios de trabajo modularizados para evitar conflictos de fusión en Git. Cada integrante debe trabajar exclusivamente en sus archivos correspondientes en la carpeta `informe/content/`.

== Tabla de Repartición de Responsabilidades

#table(
  columns: (1.5fr, 1.2fr, 2.5fr, 1.2fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#C8310E") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
  inset: (x: 8pt, y: 7pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
  
  // Headers
  table.cell(fill: rgb("#C8310E"))[*Ejercicio / Actividad*],
  table.cell(fill: rgb("#C8310E"))[*Responsable*],
  table.cell(fill: rgb("#C8310E"))[*Detalles del Trabajo*],
  table.cell(fill: rgb("#C8310E"))[*Archivo Destino*],

  // Row 1
  [Ejercicio 1: Prueba de Sentencias],
  [Leo (Leonardo Arce)],
  [Diseño de pruebas para cobertura del 100% de sentencias en el módulo `bisect.py` (de la librería estándar).],
  [`ejercicio1_sentencias_leo.typ`],

  // Row 2
  [Ejercicio 1: Prueba de Ramas],
  [Alvaro (Alvaro Quispe)],
  [Diseño de pruebas para cobertura del 100% de ramas (Branch Testing) en el módulo `bisect.py`.],
  [`ejercicio1_ramas_alvaro.typ`],

  // Row 3
  [Ejercicio 1: Combinación de Condiciones],
  [Alisson (Alisson Jara)],
  [Diseño de pruebas para combinación de condiciones (Branch Condition Combination Testing) en `bisect.py`.],
  [`ejercicio1_condiciones_alisson.typ`],

  // Row 4
  [Ejercicio 2: CC de `Account.__post_init__`],
  [Alvaro (Alvaro Quispe)],
  [Elaboración de Grafo de Flujo (CFG), cálculo manual de CC y verificación con Radon para `Account.__post_init__` en `finance/core/domain/entities.py`.],
  [`ejercicio2_cc_alvaro.typ`],

  // Row 5
  [Ejercicio 2: CC de `Transaction.__post_init__`],
  [Alisson (Alisson Jara)],
  [Elaboración de Grafo de Flujo (CFG), cálculo manual de CC y verificación con Radon para `Transaction.__post_init__` en `finance/core/domain/entities.py`.],
  [`ejercicio2_cc_alisson.typ`],

  // Row 6
  [Ejercicio 2: CC de `register_transaction`],
  [Leo (Leonardo Arce)],
  [Elaboración de Grafo de Flujo (CFG), cálculo manual de CC y verificación con Radon para `FinanceService.register_transaction` en `finance/core/app/services.py`.],
  [`ejercicio2_cc_leo.typ`],

  // Row 7
  [Cuestionario (Preguntas 1, 2 y 3)],
  [Anette (Anette Gallegos)],
  [Desarrollo de las 3 preguntas de debate usando entre 3 y 5 referencias bibliográficas estructuradas en BibTeX.],
  [`cuestionario.typ`]
)

#v(1em)

#block(
  fill: rgb("#fcf8e3"),
  stroke: 1pt + rgb("#faf2cc"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(weight: "bold", fill: rgb("#8a6d3b"))[¡IMPORTANTE PARA EL GRUPO!] \
    - *No modifiquen este archivo principal* (`ejercicios.typ`) a menos que sea estrictamente necesario para la estructura. Cada uno tiene asignado archivos independientes para evitar conflictos en Git.
    - *Código del Ejercicio 1:* Se utilizará la implementación del módulo `bisect` de CPython: #link("https://github.com/python/cpython/blob/main/Lib/bisect.py")[GitHub - bisect.py].
    - *Código del Ejercicio 2:* Debe evaluarse el código del directorio `development/` *de este laboratorio 07*. No consulten el repositorio o código del laboratorio anterior, utilicen la implementación que se encuentra directamente aquí.
  ]
)

#v(1em)

= Ejercicio 1: Cobertura de Caja Blanca en `bisect.py`

El módulo `bisect.py` proporciona algoritmos de bisección en Python para mantener listas ordenadas sin tener que ordenarlas después de cada inserción. Se presenta el código fuente exacto para referencia de todos:

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
```

== Pruebas de Sentencia (Statement Testing) - Asignado a Leo
#include "ejercicio1_sentencias_leo.typ"

== Pruebas de Ramas (Branch Testing) - Asignado a Alvaro
#include "ejercicio1_ramas_alvaro.typ"

== Pruebas de Combinación de Condiciones - Asignado a Alisson
#include "ejercicio1_condiciones_alisson.typ"

= Ejercicio 2: Complejidad Ciclomática (Guerra de Testers - Parte III)

Para este ejercicio, evaluamos funciones del sistema *FinanceApp* que se encuentra en la carpeta `development/`.
*Nota crítica del equipo:* Se debe analizar exclusivamente el código adjunto en este espacio de trabajo para evitar discrepancias.

A continuación, cada integrante presenta el análisis detallado de la función asignada, incluyendo su Grafo de Flujo de Control (CFG), la matemática del cálculo de Complejidad Ciclomática (CC) por fórmulas, y la comparación del score obtenido mediante la herramienta `radon`.

== Análisis de `Account.__post_init__` - Asignado a Alvaro
#include "ejercicio2_cc_alvaro.typ"

== Análisis de `Transaction.__post_init__` - Asignado a Alisson
#include "ejercicio2_cc_alisson.typ"

== Análisis de `FinanceService.register_transaction` - Asignado a Leo
#include "ejercicio2_cc_leo.typ"
