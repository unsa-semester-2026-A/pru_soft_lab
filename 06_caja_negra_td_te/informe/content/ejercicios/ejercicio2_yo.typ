// ==========================================
// EJERCICIO 2: GUERRA DE TESTERS - PARTE II
// Responsable: Yo (Álvaro)
// Técnicas: Tablas de Decisión, Transición de Estados, Use Case testing, y Cause-effect Graphing.
// ==========================================

#show link: set text(fill: rgb("#1a0dab"))
#show link: underline

#block(
  fill: rgb("#fff7e6"),
  stroke: rgb("#ffd591"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Indicaciones de Álvaro:*
  Se han diseñado 4 técnicas avanzadas de pruebas de caja negra aplicadas sobre la interfaz gráfica de la aplicación de finanzas personales. Los casos se validaron de forma manual ejecutando la aplicación localmente.
]

== Ejercicio 2: Guerra de Testers - Parte II

=== Tablas de Decisión (TD)

Esta técnica modela la combinatoria lógica de la interfaz gráfica al registrar una transacción frente a combinaciones válidas e inválidas de entradas. Se consolidó la siguiente Tabla de Decisión de 11 reglas.

#table(
  columns: (2.2fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr),
  align: center + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Condiciones / Causas en la UI*]),
  [#strong("R1")], [#strong("R2")], [#strong("R3")], [#strong("R4")], [#strong("R5")], [#strong("R6")], [#strong("R7")], [#strong("R8")], [#strong("R9")], [#strong("R10")], [#strong("R11")],
  [C1: Tipo seleccionado es INCOME], [T], [T], [T], [T], [F], [F], [F], [F], [F], [F], [F],
  [C2: Tipo seleccionado es EXPENSE], [F], [F], [F], [F], [T], [T], [T], [T], [T], [T], [T],
  [C3: Categoría seleccionada (no nula)], [F], [T], [F], [F], [T], [T], [F], [T], [T], [T], [T],
  [C4: Cuenta activa y seleccionada], [T], [T], [F], [T], [T], [T], [T], [T], [T], [F], [T],
  [C5: Monto ingresado > 0], [T], [T], [T], [F], [T], [T], [T], [T], [T], [T], [F],
  [C6: Categoría activa seleccionada], [-], [-], [-], [-], [T], [T], [-], [F], [T], [-], [-],
  [C7: Saldo cuenta >= Monto], [-], [-], [-], [-], [T], [T], [-], [-], [F], [-], [-],
  [C8: Gastos del mes > Límite], [-], [-], [-], [-], [F], [T], [-], [-], [-], [-], [-],
  
  table.cell(fill: rgb("#f5f5f5"), [*Acciones / Efectos en la UI*]),
  [], [], [], [], [], [], [], [], [], [], [],
  [E1: Transacción guardada en historial], [X], [], [], [], [X], [X], [], [], [], [], [],
  [E2: Actualizar saldo de cuenta], [X], [], [], [], [X], [X], [], [], [], [], [],
  [E3: Mostrar Alerta "Fondos Insuficientes"], [], [], [], [], [], [], [], [], [X], [], [],
  [E4: Mostrar Mensaje de Error / Rechazo], [], [X], [X], [X], [], [], [X], [X], [], [X], [X],
  [E5: Mostrar Alerta de Presupuesto Excedido], [], [], [], [], [], [X], [], [], [], [], []
)

*Casos de Prueba Mapeados (Prueba Manual):*
- *TC_DT_01 (R1):* Registrar un ingreso de \$150.00 en una cuenta activa sin seleccionar categoría.
- *TC_DT_02 (R2):* Intentar registrar un ingreso seleccionando una categoría (el sistema debe impedirlo o dar error).
- *TC_DT_03 (R3):* Intentar registrar un ingreso en una cuenta desactivada.
- *TC_DT_04 (R4):* Intentar registrar un ingreso con monto nulo o negativo.
- *TC_DT_05 (R5):* Registrar un gasto sin sobrepasar el presupuesto de la categoría seleccionada.
- *TC_DT_06 (R6):* Registrar un gasto que excede el presupuesto y verificar que la UI muestre la advertencia visual.
- *TC_DT_07 (R7):* Intentar registrar un gasto omitiendo seleccionar una categoría.
- *TC_DT_08 (R8):* Intentar registrar un gasto seleccionando una categoría inactiva (Soft Deleted). *(Detecta error: la UI permite seleccionarla/usarla)*.
- *TC_DT_09 (R9):* Intentar registrar un gasto mayor al saldo de la cuenta activa.
- *TC_DT_10 (R10):* Intentar registrar un gasto en una cuenta desactivada (Soft Deleted). *(Detecta error: la UI permite seleccionarla/usarla)*.
- *TC_DT_11 (R11):* Intentar registrar un gasto con monto menor o igual a cero.

==== Guía de Ejecución de Pruebas Manuales (TD):
Para verificar estas reglas de negocio en la aplicación:
1. Inicie la aplicación ejecutando `uv run python -m finance` desde la consola de desarrollo.
2. Vaya a la pestaña de *Cuentas* y cree una cuenta "BCP" activa.
3. Vaya a la pestaña de *Transacciones* e intente registrar un Ingreso de \$150.00 en la cuenta creada (C5=T, C4=T, C3=F). Verifique que el saldo suba a \$150.00 y se guarde en la tabla de historial (TC_DT_01).
4. Pruebe los casos excepcionales (montos negativos o cuentas/categorías inactivas) y verifique si el formulario de transacciones bloquea la acción o si permite registrar incorrectamente operaciones prohibidas (TC_DT_08 y TC_DT_10).

==== Resultados de la Validación Manual (TD):
Durante la ejecución manual en la app, se detectaron las siguientes discrepancias con la especificación (Bugs):
- *Bug 1 (R8):* Al desactivar una categoría desde la pestaña *Categorías*, esta sigue apareciendo en el menú desplegable del formulario de la pestaña *Transacciones*, permitiendo registrar gastos en categorías inactivas.
- *Bug 2 (R10):* Al desactivar una cuenta en la pestaña *Cuentas*, esta sigue seleccionable en el formulario de transacciones, permitiendo realizar depósitos o cobros en cuentas inactivas.

---

=== Transición de Estados (TE)

Se validaron las máquinas de estado del Presupuesto (Consumo Mensual) y de la Cuenta a través de la UI. A continuación se presenta la *Matriz de Transición de Estados* para el Presupuesto, mapeando los estados actuales en el eje Y y las acciones/eventos de la UI en el eje X:

#table(
  columns: (1.3fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr, 1.1fr),
  align: center + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Estado / Acción*]),
  table.cell(fill: rgb("#f5f5f5"), [*Asignar límite > gastos acumulados*]),
  table.cell(fill: rgb("#f5f5f5"), [*Asignar límite <= gastos acumulados*]),
  table.cell(fill: rgb("#f5f5f5"), [*Registrar gasto (total < límite)*]),
  table.cell(fill: rgb("#f5f5f5"), [*Registrar gasto (total == límite)*]),
  table.cell(fill: rgb("#f5f5f5"), [*Registrar gasto (total > límite)*]),
  
  [*S1: UNASSIGNED*], [$S_1 arrow.r S_2$], [No aplica], [No aplica], [No aplica], [No aplica],
  [*S2: UNDER_LIMIT*], [$S_2 arrow.r S_2$], [$S_2 arrow.r S_4$], [$S_2 arrow.r S_2$], [$S_2 arrow.r S_3$], [$S_2 arrow.r S_4$],
  [*S3: AT_LIMIT*], [$S_3 arrow.r S_2$], [$S_3 arrow.r S_4$], [No aplica], [No aplica], [$S_3 arrow.r S_4$],
  [*S4: EXCEEDED*], [$S_4 arrow.r S_2$], [$S_4 arrow.r S_4$], [No aplica], [No aplica], [$S_4 arrow.r S_4$]
)

_Leyenda de estados en el sistema:_
- *S1 (UNASSIGNED):* Categoría creada sin presupuesto mensual asignado en el panel.
- *S2 (UNDER_LIMIT):* Presupuesto asignado y el consumo de la categoría es menor al límite.
- *S3 (AT_LIMIT):* El consumo mensual de la categoría iguala de forma exacta al límite asignado.
- *S4 (EXCEEDED):* El consumo supera de forma estricta el límite asignado (la barra de progreso se torna roja en la interfaz).

*Casos de Prueba Mapeados (TE):*
- *TC_TE_01 (S1 -> S2):* Ir al panel de presupuestos y asignar un límite inicial a una categoría (ej. \$100.00). El estado pasa de `UNASSIGNED` a `UNDER_LIMIT`.
- *TC_TE_02 (S2 -> S2):* Registrar un gasto por un monto menor al límite (ej. \$50.00). El estado se mantiene en `UNDER_LIMIT` y la barra de progreso en la UI avanza al 50%.
- *TC_TE_03 (S2 -> S3):* Registrar otro gasto por \$50.00 (gasto acumulado = \$100.00). El estado pasa a `AT_LIMIT` (100% de la barra consumida).
- *TC_TE_04 (S3 -> S4):* Registrar un gasto adicional de \$0.01 (gasto acumulado = \$100.01). El estado pasa a `EXCEEDED` (barra cambia de color indicando sobregiro de presupuesto).
- *TC_TE_05 (S4 -> S2):* Editar el límite del presupuesto incrementándolo a \$150.00. El estado retorna a `UNDER_LIMIT` y se remueve la alerta.
- *TC_TE_06 (S2 -> S4):* Reducir el límite del presupuesto a \$80.00 (menor a los \$100.01 gastados). El estado transiciona a `EXCEEDED`.

Para ilustrar este comportamiento se generó el siguiente diagrama de estados usando PlantUML:

#align(center)[
  #image("../../src/img/state_transition_diagram.svg", width: 75%)
]

==== Guía de Validación de Transición de Estados (TE):
1. Inicie la aplicación gráfica.
2. Vaya a *Presupuestos* y asigne \$100.00 para la categoría "Transporte" (TC_TE_01).
3. Agregue un ingreso de \$500.00 en su cuenta activa.
4. Registre un gasto en "Transporte" de \$50.00. Compruebe que la interfaz actualiza la barra al 50% de consumo (TC_TE_02).
5. Agregue otro gasto de \$50.00 en "Transporte". Compruebe que la barra llega al 100% (TC_TE_03).
6. Registre \$1.00 de gasto. Compruebe que la interfaz cambia de color de la barra a rojo indicando que se ha excedido el límite asignado para el periodo (TC_TE_04).

---

=== Pruebas de Casos de Uso (Use Case Testing)

Se modelaron escenarios de extremo a extremo representativos de los flujos de usuario en la aplicación:

- *UC-2: Configuración del Entorno Financiero*
  - *Paso 1:* Crear una cuenta llamada "Cartera BBVA".
  - *Paso 2:* Crear una categoría llamada "Suscripciones".
  - *Paso 3:* Asignar un presupuesto de \$30.00 a la categoría "Suscripciones".
  - *Paso 4 (Modificación):* Actualizar el presupuesto de "Suscripciones" a \$45.00 en el mismo periodo. Comprobar que en la UI solo se muestra un registro con el nuevo límite (comportamiento de Upsert).

- *UC-3: Registro de Gastos y Control de Fondos*
  - *Paso 1:* Registrar un ingreso de \$100.00 en la cuenta "Cartera BBVA".
  - *Paso 2:* Registrar un gasto de \$20.00 en la categoría "Suscripciones". Comprobar que el saldo de la cuenta baja a \$80.00.
  - *Paso 3 (Intento de sobregiro):* Intentar registrar un gasto de \$90.00. Verificar que la aplicación muestra un mensaje de error por "Fondos Insuficientes" y no permite guardar la transacción, manteniendo el saldo en \$80.00.

- *UC-4: Desactivación Lógica (Soft Delete) y Preservación*
  - *Paso 1:* Crear una cuenta e ingresar \$100.00, luego registrar un gasto de \$40.00.
  - *Paso 2:* Desactivar la cuenta en el panel de gestión de cuentas.
  - *Paso 3 (Preservación):* Validar que la cuenta ya no se muestra en la lista de cuentas activas de la pestaña *Cuentas*, pero sus transacciones históricas siguen listadas en el historial general.
  - *Paso 4 (Restricción):* Validar que al intentar registrar una nueva transacción en el formulario de la UI, la cuenta desactivada no esté seleccionable. *(Fallo detectado: la cuenta sigue estando seleccionable)*.

---

=== Grafos Causa-Efecto (Cause-Effect Graphing)

El diseño del Grafo Causa-Efecto representa la lógica de negocio detrás de la pantalla de transacciones, analizando cómo interactúan las causas (entradas de la UI) y efectos (reacciones de la interfaz).

A continuación se muestra el diagrama del grafo causa-efecto generado mediante PlantUML:

#align(center)[
  #image("../../src/img/cause_effect_graph.svg", width: 85%)
]

*Causas en la UI:*
- *C1:* Se marca la opción de tipo `EXPENSE` (Gasto).
- *C2:* Se marca la opción de tipo `INCOME` (Ingreso).
- *C3:* Se selecciona una categoría de la lista.
- *C4:* Se selecciona una cuenta activa de la lista.
- *C5:* Se ingresa un valor positivo en el campo "Monto".
- *C6:* La categoría seleccionada se encuentra activa.
- *C7:* El saldo de la cuenta seleccionada es mayor o igual al monto ingresado.

*Efectos en la UI:*
- *E1:* La transacción se registra en el historial visible.
- *E2:* El saldo actual de la cuenta seleccionada se actualiza en el panel.
- *E3:* Se muestra una ventana emergente de error de "Fondos Insuficientes".
- *E4:* Se muestra un cuadro de error informando datos inválidos o bloqueados.
- *E5:* El indicador visual del presupuesto mensual de la categoría se torna rojo por sobregiro.

---

=== Evidencias de Ejecución Manual y Defectos Encontrados

Al realizar las pruebas de forma manual interactuando directamente con la interfaz gráfica de la aplicación, se obtuvieron las siguientes evidencias de los tres principales defectos descubiertos en el sistema:

1. *Defecto de Cuenta Inactiva Seleccionable (Soft Delete):* Al desactivar una cuenta, la interfaz de transacciones sigue listándola. Se comprobó que permite registrar un gasto en la cuenta desactivada, lo cual viola el flujo normal de persistencia lógica.
2. *Defecto de Categoría Inactiva Seleccionable (Soft Delete):* De la misma manera, las categorías desactivadas siguen apareciendo disponibles en el formulario de registro de transacciones, permitiendo registrar consumos vinculados a categorías archivadas.
3. *Control de Presupuesto Excedido:* El sistema cambia correctamente el color del progreso a rojo en la barra del panel de presupuestos cuando un nuevo gasto manual excede el límite del mes.
