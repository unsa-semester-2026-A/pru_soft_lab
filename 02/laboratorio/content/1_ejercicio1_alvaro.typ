#import  "../util.typ" as util

*Problema 1: Validador de Identificadores (Alvaro)* \

*Fase 1: BDD (Comportamiento Esperado)* \
Antes de escribir código, se definió el comportamiento mediante un escenario en Gherkin (`identificador.feature`) basado en las reglas de Fortran descritas por Myers:
#util.codeBlock("src/lst/ejercicio1/identificador.feature", lang: "gherkin")

*Fase 2: Diseño (Clases de Equivalencia y Valores Límite)* \
Se analizaron las condiciones para identificar los datos de prueba óptimos, enfocándonos en la longitud exacta de la cadena y en la validez de los caracteres.

#table(
  columns: (0.35fr, 2fr, 1.5fr, 1fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Condición / Regla*], [*Valores de Prueba (Límites)*], [*Resultado Esperado*],
  [1], [Longitud frontera inferior interior], [`"A"` (1 char)], [Válido (`True`)],
  [2], [Longitud frontera superior interior], [`"A1B2C3"` (6 chars)], [Válido (`True`)],
  [3], [Longitud frontera inferior exterior], [`""` (0 chars)], [Inválido (`False`)],
  [4], [Longitud frontera superior exterior], [`"A123456"` (7 chars)], [Inválido (`False`)],
  [5], [Regla inicial: Letra], [`"X"`], [Válido (`True`)],
  [6], [Regla inicial: Número], [`"1ABC"`], [Inválido (`False`)],
  [7], [Regla inicial: Símbolo], [`"_ABC"`], [Inválido (`False`)],
  [8], [Regla cuerpo: Alfanumérico], [`"Var1"`], [Válido (`True`)],
  [9], [Regla cuerpo: Símbolos/Espacios], [`"Var_1"`, `"A#B"`, `"A B"`], [Inválido (`False`)],
)

*Fase 3: TDD - ROJO (Red)* \
Siguiendo la metodología "Test-First", se definió primero la especificación (*signature* y *docstring*) en el archivo `identificador.py`.

*Especificación (Spec):*
#util.codeBlock("src/lst/ejercicio1/identificador_spec.py", lang: "python")

Posteriormente, se escribieron las pruebas unitarias en `test_identificador.py` basadas en el diseño de límites. Al ejecutar las pruebas sin la implementación, se obtuvo el estado de fallo esperado.

#align(center)[
  #image("../src/img/ejercicio1/tdd-red.png", width: 80%)
  _Figura 7 — Pruebas fallando (Estado ROJO)._
]

*Fase 4: TDD - VERDE (Green)* \
Se implementó la lógica mínima necesaria en `identificador.py` para satisfacer todas las reglas de validación y superar las pruebas unitarias.

*Implementación final:*
#util.codeBlock("src/lst/ejercicio1/identificador.py", lang: "python")

#align(center)[
  #image("../src/img/ejercicio1/tdd-green.png", width: 80%)
  _Figura 8 — Pruebas exitosas (Estado VERDE)._
]

*Fase 5: Refactor y Validación* \
El código fue revisado para asegurar legibilidad y eficiencia. Se verificó que todos los casos de la tabla de diseño pasaran correctamente, consolidando la robustez del validador de identificadores.

*Pruebas unitarias completas:*
#util.codeBlock("src/lst/ejercicio1/test_identificador.py", lang: "python")
