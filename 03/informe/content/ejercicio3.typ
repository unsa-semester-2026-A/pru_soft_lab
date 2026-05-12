== Ejercicio 3: Simulador de Cajero Automático con Pruebas Unitarias

=== Fase 1: Especificación (Docstrings)

El primer paso consistió en definir la interfaz de la clase `Atm` y las excepciones que se lanzarán, sin incluir la lógica de negocio. Esto nos permite establecer un "contrato" de lo que debe hacer cada método.

El siguiente código muestra la especificación inicial:

#import "../util/util.typ": codeBlock

#codeBlock("../src/lst/exe3/fase1/atm_specification.py", lang: "python")

=== Fase 2: Casos de Prueba (Rojo)

Con la especificación definida, procedimos a crear los casos de prueba utilizando particiones de equivalencia y análisis de valores límite. Se diseñaron múltiples casos de prueba (14 en total) cubriendo escenarios normales y bordes. La siguiente tabla resume los principales casos:

#table(
  columns: (auto, auto, auto, auto),
  align: horizon,
  table.header(
    [Id.], [Descripción], [Entrada], [Resultado Esperado]
  ),
  [TC-01], [Saldo inicial correcto], [saldo_inicial=1000], [saldo == 1000.0],
  [TC-02], [Depósito válido estándar], [depositar(500)], [saldo == 1500.0],
  [TC-03], [Retiro válido estándar], [retirar(300)], [saldo == 700.0],
  [TC-04], [Retiro exacto al saldo disponible], [retirar(1000)], [saldo == 0.0],
  [TC-05], [Retiro mayor al saldo], [retirar(1001)], [SaldoInsuficienteError],
  [TC-06], [Depósito de monto negativo], [depositar(-200)], [MontoInvalidoError],
  [TC-07], [Depósito de monto cero], [depositar(0)], [MontoInvalidoError],
  [TC-08], [Retiro de monto negativo], [retirar(-50)], [MontoInvalidoError],
  [TC-09], [Retiro de monto cero], [retirar(0)], [MontoInvalidoError],
  [TC-10], [Inicialización con saldo negativo], [saldo_inicial=-500], [MontoInvalidoError],
  [TC-11], [Múltiples operaciones consistentes], [depositar(500), retirar(200), depositar(100)], [saldo == 1400.0],
  [TC-12], [Límites: Depósito mínimo / Retiro mínimo], [depositar(0.01) / retirar(0.01)], [saldo == 1000.01 / 999.99],
)

A continuación, implementamos las pruebas unitarias siguiendo el patrón AAA (Arrange, Act, Assert) haciendo uso de `pytest`, `fixtures` y pruebas parametrizadas. Al ejecutar las pruebas sin la lógica implementada, todas fallaron, lo cual corresponde a la fase roja del TDD.

_Pruebas unitarias de la clase Atm (fase 2)_
#codeBlock("../../exercises/exe3/atm_cajero/test_atm.py", lang: "python")

#figure(
  image("../src/img/exe3/fase2_rojo.png", width: 85%, height: auto, fit: "contain"),
  caption: "Ejecución de pruebas unitarias - Fase Rojo",
)

=== Fase 3: Implementación (Verde)

Con las pruebas diseñadas y fallando, procedimos a implementar la lógica de negocio dentro de la clase `Atm`, reemplazando las declaraciones `pass` con el código funcional que maneja las validaciones de montos y el cálculo del saldo, además de lanzar las excepciones correspondientes según las reglas del negocio definidas en la Guía de Laboratorio.

_Implementación de la clase Atm (fase 3)_
#codeBlock("../../exercises/exe3/atm_cajero/atm.py", lang: "python")

Una vez implementada la lógica, ejecutamos nuevamente la suite de pruebas. Como se observa a continuación, los 15 casos de prueba pasaron exitosamente, confirmando que la unidad de código cumple con la especificación funcional y el diseño previo (Fase Verde del TDD).

#figure(
  image("../src/img/exe3/fase3_verde.png", width: 85%, height: auto, fit: "contain"),
  caption: "Ejecución de pruebas unitarias - Fase Verde",
)
