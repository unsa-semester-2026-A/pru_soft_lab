#import "../util.typ" as util
#set par(justify: true)

*Ejercicio 3 — Validador de Calificaciones usando BDD y TDD*

Se desarrolló la función `evaluar_rendimiento(nota)` en Python utilizando la metodología BDD (Behavior Driven Development) y TDD (Test Driven Development). El programa clasifica el rendimiento de un estudiante según su nota y valida entradas inválidas.

#table(
  columns: (1fr, 1.2fr),
  stroke: 0.5pt,
  inset: 0.5em,

  [*Rango de Nota*], [*Resultado Esperado*],

  [0 – 10], ["Insuficiente"],
  [11 – 15], ["Regular"],
  [16 – 20], ["Excelente"],
)

El sistema debe lanzar excepciones en los siguientes casos:

- Nota menor que 0.
- Nota mayor que 20.
- Valor no entero.
- Valores nulos o cadenas de texto.

#v(1em)

*FASE 1 — BDD (Behavior Driven Development)*

*Escenario Gherkin:*
#util.codeBlock("src/lst/ejercicio3/evaluador.feature", lang: "gherkin")


#v(1em)

*FASE 2 — Diseño de Pruebas: Clases de Equivalencia y Valores Límite*

En esta fase se identificaron los diferentes tipos de entradas válidas e inválidas para la función `evaluar_rendimiento(nota)`. Primero se definieron las clases de equivalencia, luego los valores límite y finalmente se verificó que todos los criterios estuvieran cubiertos mediante casos de prueba.

#v(0.5em)

*Paso 1 — Identificación de Clases de Equivalencia.*

Las clases de equivalencia permiten agrupar entradas que producen el mismo comportamiento esperado dentro del sistema, reduciendo la cantidad de pruebas necesarias sin perder cobertura funcional.

#table(
  columns: (0.7fr, 0.8fr, 1fr, 1.5fr),
  stroke: 0.5pt,
  inset: 0.45em,

  [*Clase*], [*Tipo*], [*Entrada*], [*Resultado Esperado*],

  [CE1], [Válida], [0 – 10], ["Insuficiente"],
  [CE2], [Válida], [11 – 15], ["Regular"],
  [CE3], [Válida], [16 – 20], ["Excelente"],
  [CE4], [Inválida], [menor que 0], [ValueError],
  [CE5], [Inválida], [mayor que 20], [ValueError],
  [CE6], [Inválida], [decimal], [TypeError],
  [CE7], [Inválida], [texto], [TypeError],
  [CE8], [Inválida], [None], [TypeError],
)

#v(1em)

*Paso 2 — Análisis de Valores Límite.*

Se evaluaron los valores extremos de cada rango, ya que son los puntos donde normalmente ocurren errores de validación.

#table(
  columns: (0.7fr, 1fr, 1.5fr),
  stroke: 0.5pt,
  inset: 0.45em,

  [*Caso*], [*Valor*], [*Resultado Esperado*],

  [L1], [-1], [ValueError],
  [L2], [0], ["Insuficiente"],
  [L3], [10], ["Insuficiente"],
  [L4], [11], ["Regular"],
  [L5], [15], ["Regular"],
  [L6], [16], ["Excelente"],
  [L7], [20], ["Excelente"],
  [L8], [21], [ValueError],
)

#v(1em)

*Paso 3 — Verificación de Cobertura de Criterios de Prueba.*

En este paso se comprobó que todas las clases de equivalencia y valores límite definidos anteriormente estuvieran representados mediante al menos un caso de prueba. Esto garantiza que el diseño de pruebas cubra correctamente los escenarios válidos, inválidos y los límites críticos del sistema.

#table(
  columns: (0.35fr, 2.4fr, 0.9fr),
  stroke: 0.5pt,
  inset: 0.45em,

  [*N°*], [*¿Se tiene un caso de prueba que...?*], [*¿Cumple?*],

  [1], [Represente una nota válida insuficiente.], [Sí — (5)],
  [2], [Represente el límite inferior válido.], [Sí — (0)],
  [3], [Represente el límite superior insuficiente.], [Sí — (10)],
  [4], [Represente una nota válida regular.], [Sí — (13)],
  [5], [Represente el límite inferior regular.], [Sí — (11)],
  [6], [Represente el límite superior regular.], [Sí — (15)],
  [7], [Represente una nota válida excelente.], [Sí — (18)],
  [8], [Represente el límite inferior excelente.], [Sí — (16)],
  [9], [Represente el límite superior válido.], [Sí — (20)],
  [10], [Represente una nota menor que 0.], [Sí — (-1)],
  [11], [Represente una nota mayor que 20.], [Sí — (21)],
  [12], [Represente un valor decimal.], [Sí — (15.5)],
  [13], [Represente un valor no numérico.], [Sí — ("abc")],
  [14], [Represente un valor vacío.], [Sí — (None)],
  [15], [Represente una cadena numérica.], [Sí — ("18")],
)

#v(1em)

*Paso 4 — Diseño de Casos de Prueba.*

Finalmente, se definieron los casos de prueba concretos que serán implementados posteriormente durante la fase TDD para validar el comportamiento del sistema.

#table(
  columns: (0.35fr, 2fr, 0.8fr, 1.8fr),
  stroke: 0.5pt,
  inset: 0.4em,

  [*Id.*], [*Descripción*], [*Datos de Entrada*], [*Resultado Esperado*],

  [1], [Nota insuficiente válida], [(5)], ["Insuficiente"],
  [2], [Límite inferior válido], [(0)], ["Insuficiente"],
  [3], [Límite superior insuficiente], [(10)], ["Insuficiente"],
  [4], [Nota regular válida], [(13)], ["Regular"],
  [5], [Límite inferior regular], [(11)], ["Regular"],
  [6], [Límite superior regular], [(15)], ["Regular"],
  [7], [Nota excelente válida], [(18)], ["Excelente"],
  [8], [Límite inferior excelente], [(16)], ["Excelente"],
  [9], [Límite superior válido], [(20)], ["Excelente"],
  [10], [Nota menor que 0], [(-1)], [ValueError],
  [11], [Nota mayor que 20], [(21)], [ValueError],
  [12], [Valor decimal], [(15.5)], [TypeError],
  [13], [Valor no numérico], [("abc")], [TypeError],
  [14], [Valor vacío], [(None)], [TypeError],
  [15], [Cadena numérica], [("18")], [TypeError],
)
*FASE 3 — TDD (RED)*

Se creó el archivo `test_evaluador.py` antes de implementar la lógica principal.

```bash
pytest -v
```

Resultado esperado:

```text
ModuleNotFoundError
```

o

```text
ImportError
```

Esto demuestra correctamente la fase RED del TDD.

#align(center)[
  #image("../src/img/ejercicio3/exe3_red.png", width: 75%)

  _Figura 1 — Ejecución inicial de pruebas mostrando errores (fase RED)._
]

#v(1em)

*Código del archivo `test_evaluador.py`.*

#util.codeBlock("src/lst/ejercicio3/test_evaluador.py", lang: "python")

#v(1em)

*FASE 4 — TDD (GREEN)*

Se implementó el código mínimo necesario para satisfacer todas las pruebas.

*Código del archivo `evaluador.py`.*

#util.codeBlock("src/lst/ejercicio3/evaluador.py", lang: "python")

Luego de ejecutar nuevamente:

```bash
pytest -v
```

Resultado esperado:

```text
==========================
15 passed in 0.xx s
==========================
```

#align(center)[
  #image("../src/img/ejercicio3/exe3_green.png", width: 75%)

  _Figura 2 — Resultado final de pytest mostrando todas las pruebas aprobadas._
]

#v(1em)

*Validación de casos de prueba.*

#table(
  columns: (0.35fr, 1.8fr, 0.8fr, 1.7fr, 0.55fr),
  stroke: 0.5pt,
  inset: 0.4em,

  [*Id.*], [*Descripción*], [*Entrada*], [*Resultado Real*], [*Estado*],

  [1], [Nota insuficiente], [(5)], ["Insuficiente"], [Pasa],
  [2], [Límite inferior], [(0)], ["Insuficiente"], [Pasa],
  [3], [Límite superior insuficiente], [(10)], ["Insuficiente"], [Pasa],
  [4], [Nota regular], [(13)], ["Regular"], [Pasa],
  [5], [Límite inferior regular], [(11)], ["Regular"], [Pasa],
  [6], [Límite superior regular], [(15)], ["Regular"], [Pasa],
  [7], [Nota excelente], [(18)], ["Excelente"], [Pasa],
  [8], [Límite inferior excelente], [(16)], ["Excelente"], [Pasa],
  [9], [Límite superior válido], [(20)], ["Excelente"], [Pasa],
  [10], [Nota menor que 0], [(-1)], [ValueError], [Pasa],
  [11], [Nota mayor que 20], [(21)], [ValueError], [Pasa],
  [12], [Valor decimal], [(15.5)], [TypeError], [Pasa],
  [13], [Valor texto], [("abc")], [TypeError], [Pasa],
  [14], [Valor None], [(None)], [TypeError], [Pasa],
  [15], [Cadena numérica], [("18")], [TypeError], [Pasa],
)

#v(1em)

*Conclusión.* El uso de BDD y TDD permitió desarrollar un software confiable y robusto para la validación de calificaciones. Se aplicaron clases de equivalencia, análisis de valores límite y pruebas funcionales para garantizar el correcto comportamiento del sistema ante entradas válidas e inválidas.
