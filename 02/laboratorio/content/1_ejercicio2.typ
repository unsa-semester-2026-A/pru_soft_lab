#import "../util.typ" as util
#set par(justify: true)

*Ejercicio 2 — Simulador de Cajero Automático (ATM) usando BDD y TDD* \

Este informe documenta el proceso de validación del comportamiento de un Cajero Automático (ATM) aplicando las metodologías BDD y TDD. El caso de prueba central consiste en verificar que el sistema bloquee correctamente un retiro cuando el monto solicitado supera el saldo disponible. Según Glen Myers, este tipo de prueba de error es fundamental para garantizar la robustez del software.

*FASE 1 — BDD (Behavior Driven Development)*

Antes de escribir cualquier línea de código, se definieron los escenarios en lenguaje natural usando el formato Gherkin.

*Archivo `atm.feature`:*
#util.codeBlock("src/lst/ejercicio2/atm.feature", lang: "gherkin")

#v(1em)

*FASE 2 — Diseño: Tabla de Clases de Equivalencia y Valores Límite*

Con un saldo de referencia = 100, se identifican las siguientes clases de equivalencia:

#table(
  columns: (0.8fr, 1.5fr, 1fr, 1.2fr),
  stroke: 0.5pt,
  inset: 0.45em,
  [*Clase*], [*Descripción*], [*Valores de prueba*], [*Resultado esperado*],
  [Inválida], [Monto ≤ 0 (sin sentido)], [0, -10], ["Monto inválido"],
  [Válida (menor)], [Monto menor al saldo], [50, 99], ["Retiro exitoso"],
  [Límite exacto], [Monto igual al saldo], [100], ["Retiro exitoso"],
  [Inválida (mayor)], [Monto supera el saldo], [101, 150], ["Fondos Insuficientes"],
)

*Valores Límite (saldo = 100)*

#table(
  columns: (0.7fr, 2fr, 1.2fr),
  stroke: 0.5pt,
  inset: 0.45em,
  [*Valor*], [*Descripción*], [*Resultado*],
  [99], [Un punto por debajo del límite], [Retiro exitoso],
  [100], [Exactamente el límite (frontera)], [Retiro exitoso],
  [101], [Un punto por encima del límite], [Fondos Insuficientes],
)

#v(1em)

*FASE 3 — TDD (ROJO)*

Siguiendo la metodología TDD, primero se escribe la prueba unitaria antes de implementar el código. Se creó el archivo `test_atm.py` y se verificó contra una especificación vacía (`atm_spec.py`). En este estado la prueba falla porque la lógica de la clase `CajeroATM` aún no existe.

*Especificación Inicial:*
#util.codeBlock("src/lst/ejercicio2/atm_spec.py", lang: "python")

#align(center)[
  #image("../src/img/ejercicio2/atm-red.png", width: 90%)
  _Figura 4 — Ejecución inicial mostrando fallos (fase ROJA)._
]

#v(1em)

*FASE 4 — TDD (VERDE)*

Se implementó el código mínimo necesario para que todas las pruebas pasen.

*Implementación `atm.py`:*
#util.codeBlock("src/lst/ejercicio2/atm.py", lang: "python")

#v(1em)

*FASE 5 — Refactor y Validación*

El código final se mejoró con Type hints y validaciones en el constructor. Todos los casos de prueba pasan exitosamente.

*Pruebas unitarias completas `test_atm.py`:*
#util.codeBlock("src/lst/ejercicio2/test_atm.py", lang: "python")

#align(center)[
  #image("../src/img/ejercicio2/atm-green.png", width: 90%)
  _Figura 5 — Pruebas exitosas (fase VERDE) validando el comportamiento del ATM._
]
