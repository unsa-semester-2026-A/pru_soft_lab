#import "../util.typ" as util
#set par(justify: true)

*Ejercicio 4 — Calculadora de Reembolsos de Hotel usando BDD Y TDD (Alisson)* \

Se definió la regla de negocio indicada en la guía: el reembolso depende de las horas de anticipación y del estatus VIP del cliente.

#table(
  columns: (1fr, 1.2fr),
  stroke: 0.5pt,
  inset: 0.5em,

  [*Condición*], [*Reembolso*],
  [Horas > 72], [100% del monto],
  [24 < Horas ≤ 72], [50% del monto],
  [Horas ≤ 24], [0% del monto],
  [Cliente VIP con Horas ≤ 24], [50% del monto],
)

Adicional, el sistema debe validar que el monto sea positivo y las horas sean enteras no negativas.

*FASE 1 — BDD.* 

El escenario Gherkin para un cliente VIP quedó definido en el archivo `cal_reembolsos.feature`.

*Código fuente — `cal_reembolsos.feature`:*
#util.codeBlock("src/lst/ejercicio4/cal_reembolsos.feature", lang: "gherkin")

*FASE 2 — Diseño de Pruebas*

Se diseñan los casos de prueba necesarios para validar el comportamiento definido en la fase de BDD y la robustez del sistema, haciendo uso de las clases de equivalencia y valores límite.


*Paso 1 - Identificación de clases de equivalencia:*
Se identifican las siguientes clases de equivalencia para las horas de cancelación y el monto de la reserva:

#table(
  columns: (0.5fr, 1.5fr, 1fr, 1.3fr, 0.65fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id*], [*Clase de Equivalencia*], [*Entrada*], [*Resultado Esperado*], [*Estado*],
  [1], [Horas > 72], [(1000, 73, false)], [1000.0], [Válido],
  [2], [24 < Horas ≤ 72], [(1000, 24, false)], [500.0], [Válido],
  [3], [Horas ≤ 24], [(1000, 24, false)], [0.0], [Válido],
  [4], [Cliente VIP con Horas ≤ 24], [(1000, 2, true)], [500.0], [Válido],
  [5], [Monto cero], [(0, 48, false)], [0.0], [Válido],
  [6], [Monto con decimales], [(999.99, 48, false)], [499.995], [Válido],
  [7], [Monto negativo], [(-100, 48, false)], [ValueError], [Inválido],
  [8], [Horas cero], [(1000, 0, false)], [1000.0], [Válido],
  [9], [Horas con decimales], [(1000, 24.5, false)], [ValueError], [Inválido],
  [10], [Horas negativas], [(1000, -1, false)], [ValueError], [Inválido],
  [11], [Horas y/o Datos son texto], [("mil", "veinticuatro", "esfalse")], [ValueError], [Inválido],
  [12], [Horas y/o Datos son vacio], [("", "", "")], [ValueError], [Inválido],
  [13], [Horas y/o Datos son nulos], [(null, null, null)], [ValueError], [Inválido],
)


*Paso 2 - Análisis de Valores Límite*:
Se identifican los valores límite para las horas de cancelación (0, 24, 72) y el monto (0), asegurando que se prueben los casos justo en el borde de cada regla de negocio.

#table(
  columns: (0.5fr, 1.5fr, 1fr, 1.3fr, 0.65fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id*], [*Valor Límite*], [*Entrada(d0, cr, v)*], [*Resultado Esperado*], [*Estado*],
  [1], [Horas = 0], [(1000, 0, false)], [0.0], [Válido],
  [2], [Horas = 24], [(1000, 24, false)], [500.0], [Válido],
  [3], [Horas = 72], [(1000, 72, false)], [500.0], [Válido],
  [4], [Monto = 0], [(0, 48, false)], [ValueError], [Inválido],
  [5], [Monto = 0.01], [(0.01, 48, false)], [0.005], [Válido],
  [6], [Monto = -0.01], [(-0.01, 48, false)], [ValueError], [Inválido],
  [7], [Horas = 0.01], [(1000, 0.01, false)], [ValueError], [Inválido],
  [8], [Horas = -0.01], [(1000, -0.01, false)], [ValueError], [Inválido],
)

*Paso 3 - Verificación de cobertura de pruebas*: 
Se verifica que los casos de prueba diseñados cubren todas las reglas de negocio y validaciones, asegurando que cada condición y valor límite sea probado adecuadamente.

#table(
  columns: (0.5fr, 2.55fr, 0.5fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Se tiene un caso de prueba que...?*],[*Estado*],
  [1], [Pruebe que las horas de cancelación mayores a 72 horas generan un reembolso del 100%], [Pasa],
  [2], [Pruebe que las horas de cancelación entre 24 y 72 horas generan un reembolso del 50%], [Pasa],
  [3], [Pruebe que las horas de cancelación menores o iguales a 24 horas generan un reembolso del 0%], [Pasa],
  [4], [Pruebe que los clientes VIP con horas de cancelación menores o iguales a 24 horas generan un reembolso del 50%], [Pasa],
  [5], [Pruebe que un monto de reserva igual a cero genera un error], [Pasa],
  [6], [Pruebe que un monto de reserva con decimales es procesado correctamente], [Pasa],
  [7], [Pruebe que un monto de reserva negativo genera un error], [Pasa],
  [8], [Pruebe que horas de cancelación igual a cero generan un reembolso del 100%], [Pasa],
  [9], [Pruebe que horas de cancelación con decimales generan un error], [Pasa],
  [10], [Pruebe que horas de cancelación negativas generan un error], [Pasa],
  [11], [Pruebe que horas y/o datos de entrada como texto generan un error], [Pasa],
  [12], [Pruebe que horas y/o datos de entrada vacíos generan un error], [Pasa],
  [13], [Pruebe que horas y/o datos de entrada nulos generan un error], [Pasa],
)
  

*FASE 3 — TDD - ROJO(Red)*

Usando el ciclo de Red-Green-Refactor, aplicaremos pruebas unitarias para validar cada regla de negocio. Definimos la función `calcular_reembolso`. Empezaremos por validar la clase de equivalencia 1 (Horas de Cancelación > 72), la función no existe por ende la prueba fallará, como se ve en la imagen:

Archivo `reembolso_red.py`:

#util.codeBlock("src/lst/ejercicio4/reembolso_red.py", lang: "python")

#align(center)[
  #image("../src/img/ejercicio4/reembolso_red.png", width: 90%)

  _Figura 11 — Prueba fallida: cancelación con más de 72 horas._
]

*FASE 4 — TDD - VERDE(Green)*

Implementamos el código mínimo para pasar la prueba, devolviendo el monto completo para la cancelación. 

Archivo `reembolso_green.py`:

#util.codeBlock("src/lst/ejercicio4/reembolso_green.py", lang: "python")


*FASE 5 — TDD - REFACTOR Y VALIDACIÓN*

Iterando los pasos 3 y 4 para cada clase de equivalencia y valor límite, se implementa la lógica completa de la función `calcular_reembolso` para cubrir todas las reglas de negocio y validaciones, asegurando que todas las pruebas unitarias pasen exitosamente como se ve en la siguiente imagen:

Archivo `reembolso_refactor.py`:

#util.codeBlock("src/lst/ejercicio4/reembolso_refactor.py", lang: "python")

Archivo `reembolso_test.py`:

#util.codeBlock("src/lst/ejercicio4/reembolso_test.py", lang: "python")


#align(center)[
  #image("../src/img/ejercicio4/reembolso_test.png", width: 90%)

  _Figura 12 — Ejecución de `python -m unittest reembolso_test.py` con todas las pruebas pasando exitosamente (13 OK)._
]
