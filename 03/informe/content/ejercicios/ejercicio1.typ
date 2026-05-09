== Ejercicio 1: Calculadora Básica
*Paso 1: Crear la Especificación (Docstrings)*
En este paso definimos la "promesa" de comportamiento de nuestra clase antes de programar logica interna.

* Archivo `calculadora.docstrings.py`: *
// #util.codeBlock("src/lst/exe1/calculadora_docstrings.py", lang: "python")

#align(center)[
  #image("/03/informe/src/img/exe1/test_calculadora_fallo.png", width: 85%)
  _Figura 1 — Ejecución inicial mostrando fallos debido a funciones no implementadas (fase ROJA)._
]

La ejecucion nos dara error porque las funciones no estan implementadas, pero esto es intencional: el objetivo es definir claramente lo que cada función debe hacer antes de escribir el codigo.

*Paso 2: Tabla de Casos de Prueba* \
Diseñamos 9 casos de prueba (TC-01 a TC-09) que cubren las cuatro operaciones, incluyendo operandos enteros, decimales y negativos.

Los casos TC-01 al TC-05 abordan sumas y restas (positivos y negativos). Los casos TC-06 y TC-07 evalúan la multiplicación con valores enteros y decimales. Los casos TC-08 y TC-09 verifican la división exacta y decimal, mientras TC-09 valida la gestión de la excepción ante divisor igual a cero.

#table(
  columns: (0.5fr, 2.2fr, 1.6fr, 1fr),
  stroke: 0.5pt,
  inset: 0.4em,
  align: center + horizon,
  table.cell(colspan: 4)[
    #set text(size: 9pt, weight: "bold")
    *Casos de Prueba Funcionales (TC-01 a TC-09)*
  ],
  [*Id*], [*Descripción*], [*Entrada*], [*Resultado Esperado*],
  [TC-01], [Suma de enteros positivos], [`sumar(5, 3)`], [`8`],
  [TC-02], [Suma con operandos negativos], [`sumar(-5, -3)`], [`-8`],
  [TC-03], [Resta de enteros positivos], [`restar(10, 4)`], [`6`],
  [TC-04], [Resta con operandos negativos], [`restar(-5, -3)`], [`-2`],
  [TC-05], [Multiplicación de enteros], [`multiplicar(4, 7)`], [`28`],
  [TC-06], [Multiplicación con decimales], [`multiplicar(2.5, 4.0)`], [`10.0`],
  [TC-07], [División exacta], [`dividir(20, 4)`], [`5`],
  [TC-08], [División con resultado decimal], [`dividir(7.5, 2.5)`], [`3.0`],
  [TC-09], [División por cero — excepción], [`dividir(10, 0)`], [`ValueError`],
)


Adicionalmente, se incorporaron casos de prueba de valores límites y precisión numérica (TC-10 a TC-19 y TC-L1 a TC-L4) para validar el comportamiento del sistema bajo condiciones extremas de una calculadora real. El objetivo es verificar que la implementación gestiona correctamente la precisión de punto flotante, el desbordamiento aritmético (overflow), la representación de infinito, y los bordes del tipo `float` en Python según el estándar IEEE 754. Estos casos permiten validar la robustez de la calculadora en escenarios que van más allá de las operaciones comunes, asegurando que el sistema responde de forma predecible cuando se expone a límites computacionales propios de una calculadora científica real.

#table(
  columns: (0.5fr, 2.2fr, 1.6fr, 1.1fr),
  stroke: 0.5pt,
  inset: 0.4em,
  align: center + horizon,
  table.cell(colspan: 4)[
    #set text(size: 9pt, weight: "bold")
    *Casos de Prueba Avanzados y de Límites (TC-10 a TC-19, TC-L1 a TC-L4)*
  ],
  [*Id*], [*Escenario de Prueba*], [*Entrada*], [*Resultado Esperado*],
  [TC-10], [Precisión de punto flotante], [`sumar(0.1, 0.2)`], [`≈ 0.3`],
  [TC-12], [Multiplicación de negativos], [`multiplicar(-5, -4)`], [`20`],
  [TC-13], [Dividir cero entre un número], [`dividir(0, 10)`], [`0.0`],
  [TC-14], [Operaciones con números grandes], [`sumar(1e10, 1e10)`], [`2e10`],
  [TC-17], [Desbordamiento por multiplicación], [`multiplicar(1e300, 1e20)`], [`inf`],
  [TC-18], [División por número ínfimo], [`dividir(1e300, 1e-20)`], [`inf`],
  [TC-19], [Verificación de infinito negativo], [`multiplicar(-1e300, 1e20)`], [`-inf`],
  [TC-L1], [Último valor permitido (borde interno)], [`sumar(1.79e308, 1.0)`], [`1.79e308`],
  [TC-L2], [Desbordamiento (borde externo)], [`sumar(1.8e308, 1.1)`], [`inf`],
  [TC-L3], [División límite (casi infinito)], [`dividir(1e308, 0.1)`], [`inf`],
  [TC-L4], [División prohibida], [`dividir(10, 0)`], [`ValueError`],
)

*Paso 3: Implementar el Código y Pruebas* \
Ahora desarrollamos la lógica necesaria para que los casos de prueba pasen a "Verde".

*Paso 3.1: Implementación del Código* \
A continuación se presenta la implementación del módulo `calculadora.py`, la cual expone la clase `Calculadora`, siguiendo las buenas prácticas de programación orientada a objetos. Cada método de operación realiza la función matemática correspondiente, y se asegura de manejar adecuadamente la división por cero lanzando una excepción con el mensaje específico requerido por la especificación.

* Archivo `calculadora.py`: *
// #util.codeBlock("src/lst/exe1/calculadora.py", lang: "python")

*Paso 3.2: Implementación de Pruebas Unitarias* \
Se implementó el archivo `test_calculadora.py` utilizando el framework Pytest. Las pruebas se organizaron mediante clases para agrupar semánticamente los casos de pruebas por operación (suma, resta, multiplicación, división).

*Estandarización AAA:* Se aplicó el patrón AAA (Arrange-Act-Assert) mediante comentarios, separando las fases de preparación de datos, ejecución de la operación y verificación del resultado.

*Optimización Parametrizada: * Adicionalmente, Se incluyó una clase `TestParametrizadas` que demuestra el uso avanzado de `@pytest.mark.parametrize`, permitiendo ejecutar un mismo escenario de prueba con múltiples combinaciones de datos en una sola definición de método, mejorando mantenibilidad y cobertura del código.

* Modularidad con Fixture*: Se utilizó `@pytest.fixture` para crear una instancia compartida de la clase `Calculadora`, eliminando la redundancia de instaciación manual

*Pruebas de Precisión Numérica y Límites:* Se añadieron las clases `TestPrecisionAvanzada` y `TestLimitesFlotantes` para evaluar el comportamiento del sistema bajo condiciones extremas. Los casos con exponentes muy grandes (1e300, 1e20, 1e10) verifican que la aritmética de Python maneja correctamente órdenes de magnitud extremos sin errores inesperados. Se cubren además los escenarios de desbordamiento (overflow) donde Python retorna `inf` o `-inf`, y se confirma que la división por cero lanza el `ValueError` requerido. 

* Archivo `test_calculadora.py`: *
// #util.codeBlock("src/lst/exe1/test_calculadora.py", lang: "python")

#align(center)[
  #image("/03/informe/src/img/exe1/test_calculadora.png", width: 85%)
  _Figura 2 — Ejecución mostrando todos los casos de prueba pasando exitosamente (fase VERDE) ._
]

*Paso 4: Interfaz Gráfica de Usuario* \
Se agregó una interfaz gráfica simple desarrollada con `tkinter` que permite al usuario interactuar con la calculadora mediante botones. La interfaz incluye un display de entrada, botones numéricos (0-9), botones de operadores (+, -, \*, /), el botón de limpiar (C) y el botón de ejecutar (=). Los botones de operadores están estilizados en color naranja para diferenciarlos visualmente de los numéricos, y el botón limpiar se distingue en rojo, siguiendo las convenciones típicas de calculadoras. La implementación modular en `ui/gui.py` mantiene la separación entre la lógica de negocio (clase `Calculadora`) y la capa de presentación, facilitando el mantenimiento y la extensibilidad del código.

* Archivo `ui/gui.py`: *
// #util.codeBlock("src/lst/exe1/ui/gui.py", lang: "python")

#align(center)[
  #image("/03/informe/src/img/exe1/gui_calculadora.png", width: 70%)
  _Figura 3 — Interfaz gráfica de la calculadora con botones operativos._
]
