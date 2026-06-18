// ==========================================
// EJERCICIO 2: GUERRA DE TESTERS - PARTE II
// Responsable: Yo (Álvaro)
// Técnicas: Tablas de Decisión, Transición de Estados, Use Case testing, Pruebas Aleatorias y Cause-effect Graphing.
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
  Se han diseñado 5 técnicas avanzadas de pruebas de caja negra aplicadas sobre la aplicación. Las pruebas lógicas (TD, TE, Use Cases y Cause-Effect) se validaron de forma manual en la UI, mientras que las pruebas de invariantes (Random) se encuentran automatizadas a nivel de backend.
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

==== Evidencias de Ejecución en la Aplicación (TD):

// TODO: Álvaro - Colocar aquí capturas de pantalla de la ejecución en la app corriendo para las reglas de la Tabla de Decisión y describir los resultados.
// Ejemplo:
// #figure(
//   image("../../src/img/alvaro/td_evidencia1.png", width: 80%),
//   caption: [Verificación manual de la regla R1 en la interfaz]
// )

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

==== Evidencias de Ejecución en la Aplicación (TE):

// TODO: Álvaro - Colocar aquí capturas de pantalla del flujo de transición de estados en la UI (UNASSIGNED, UNDER_LIMIT, AT_LIMIT, EXCEEDED).
// Ejemplo:
// #figure(
//   image("../../src/img/alvaro/te_evidencia1.png", width: 80%),
//   caption: [Alerta visual de presupuesto excedido en el dashboard]
// )

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

==== Evidencias de Ejecución en la Aplicación (Casos de Uso):

// TODO: Álvaro - Colocar aquí capturas de pantalla de la ejecución manual de los flujos de Casos de Uso (UC-2, UC-3, UC-4) en la UI.
// Ejemplo:
// #figure(
//   image("../../src/img/alvaro/uc_evidencia1.png", width: 80%),
//   caption: [Flujo de desactivación lógica de cuenta y preservación de historial]
// )

---

=== Pruebas Aleatorias (Random Testing)

Esta técnica simula secuencias aleatorias de operaciones en el sistema para corroborar la inmutabilidad de cuatro invariantes lógicos clave:

1. *Invariante del Balance:* El saldo final de la cuenta debe coincidir con la suma aritmética de ingresos menos gastos.
   $B_"final" = sum "amount"_"income" - sum "amount"_"expense"$
2. *Invariante de Protección de Saldo (No Negatividad):* El saldo nunca puede caer por debajo de cero, levantando `InsufficientFundsError`.
   $B_"actual" - A_"gasto" >= 0$
3. *Invariante de Unicidad de Presupuesto:* Multiples presupuestos asignados al mismo periodo resultan en un único registro (Upsert).
4. *Invariante de Monto Positivo:* Montos $\le 0$ en transacciones o presupuestos deben ser rechazados.

==== Implementación del Código de Pruebas (Random Testing):
A continuación se detalla la clase `TestRandomTesting` encargada de estas pruebas de invariante:

```python
class TestRandomTesting:
    """Performs Property-Based testing to check invariants."""

    def test_random_transactions_and_invariants(self, test_bundle: ServiceBundle) -> None:
        """Generates random transaction paths to assert invariants."""
        acc = test_bundle.service.create_account(name="Master Account", bank="Bank")
        cat = test_bundle.service.create_category(name="General")
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(cat.id, Decimal("500.00"), now.month, now.year)

        local_balance = Decimal("0.00")
        local_incomes = Decimal("0.00")
        local_expenses = Decimal("0.00")

        rng = random.Random(42)  # Seeded for deterministic runs

        for _ in range(100):
            is_income = rng.choice([True, False])
            amount = Decimal(f"{rng.randint(1, 10000) / 100:.2f}")

            if is_income:
                test_bundle.service.register_transaction(acc.id, None, "INCOME", amount, "Random income")
                local_balance += amount
                local_incomes += amount
            else:
                if local_balance >= amount:
                    test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", amount, "Random expense")
                    local_balance -= amount
                    local_expenses -= amount
                else:
                    with pytest.raises(InsufficientFundsError):
                        test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", amount, "Random expense")

            stored_acc = test_bundle.accounts.get(acc.id)
            assert stored_acc.current_balance == local_balance
            assert stored_acc.current_balance >= Decimal("0.00")

        assert stored_acc.current_balance == local_incomes + local_expenses

    def test_random_budget_limit_invariants(self, test_bundle: ServiceBundle) -> None:
        """Validates that random budget assignments maintain uniqueness of budgets."""
        cat = test_bundle.service.create_category(name="Random Cat")
        rng = random.Random(1337)
        now = datetime.now(timezone.utc)

        last_limit = Decimal("0.00")
        for _ in range(50):
            limit = Decimal(f"{rng.randint(1, 1000):.2f}")
            test_bundle.service.assign_budget(cat.id, limit, now.month, now.year)
            last_limit = limit

        all_budgets = test_bundle.budgets.list_all()
        assert len(all_budgets) == 1
        assert all_budgets[0].limit_amount == last_limit
```

==== Resultados de Ejecución (Random Testing):
Al ejecutar las pruebas aleatorias e invariantes, se obtiene un resultado totalmente exitoso (2 aprobadas):

```
$ uv run pytest finance/core/app/test_blackbox_advanced.py::TestRandomTesting -v
============================= test session starts ==============================
collected 2 items

finance/core/app/test_blackbox_advanced.py::TestRandomTesting::test_random_transactions_and_invariants PASSED
finance/core/app/test_blackbox_advanced.py::TestRandomTesting::test_random_budget_limit_invariants PASSED

============================== 2 passed in 0.04s ===============================
```

==== Evidencias de Ejecución en la Aplicación (Random Testing):

// TODO: Álvaro - Colocar aquí evidencias o comentarios sobre las pruebas de invariantes aleatorias en la UI o logs de ejecución si aplica.

---

=== Grafos Causa-Efecto (Cause-Effect Graphing)

El diseño del Grafo Causa-Efecto representa la lógica de negocio detrás de la pantalla de transacciones, analizando cómo interactúan las causas (entradas de la UI) y efectos (reacciones de la interfaz).

A continuación se muestra el diagrama del grafo causa-efecto generado mediante PlantUML:

#align(center)[
  #image("../../src/img/cause_effect_graph.svg", width: 85%)
]

*Causas:*
- *C1:* El tipo de transacción es `EXPENSE`.
- *C2:* El tipo de transacción es `INCOME`.
- *C3:* Se proporciona un `category_id` (no nulo).
- *C4:* El ID de la cuenta existe en el repositorio y la cuenta está activa (`is_active = true`).
- *C5:* El monto (`amount`) es strictly mayor a cero.
- *C6:* El ID de la categoría existe en el repositorio y está activa (`is_active = true`).
- *C7:* El saldo actual de la cuenta es suficiente (`current_balance >= amount`).

*Efectos:*
- *E1:* La transacción se almacena con éxito en el repositorio y se visualiza en el historial.
- *E2:* El saldo actual de la cuenta seleccionada se actualiza en el panel.
- *E3:* Se muestra una ventana emergente de error de "Fondos Insuficientes" (`InsufficientFundsError`).
- *E4:* Se muestra un cuadro de error informando datos inválidos o bloqueados (`ValueError`).
- *E5:* El indicador visual del presupuesto mensual de la categoría se torna rojo por sobregiro (retorna `exceeded = true`).

*Fórmulas Booleanas:*
- $E_1 = (C_2 and not C_3 and C_4 and C_5) or (C_1 and C_3 and C_4 and C_5 and C_6 and C_7)$
- $E_2 " (Ingreso)" = C_2 and not C_3 and C_4 and C_5$
- $E_2 " (Gasto)" = C_1 and C_3 and C_4 and C_5 and C_6 and C_7$
- $E_3 = C_1 and C_3 and C_4 and C_5 and C_6 and not C_7$
- $E_4 = not C_4 or not C_5 or (C_2 and C_3) or (C_1 and not C_3) or (C_1 and C_3 and not C_6)$
- $E_5 = E_1 and C_1 and ("Gastos del mes" > "Límite del presupuesto")$

==== Evidencias de Ejecución en la Aplicación (Grafo Causa-Efecto):

// TODO: Álvaro - Colocar aquí evidencias de la verificación manual del comportamiento causa-efecto en la UI.

=== Evidencias de Ejecución General del Suite

Al ejecutar todo el conjunto de pruebas del sistema (combinando pruebas básicas PE y AVL unitarias de caja de cristal previa y la técnica aleatoria automatizada), se evidencia que se ejecutan 95 tests, resultando en 95 aprobados (excluyendo los tests manuales):

```
$ uv run pytest
============================= test session starts ==============================
platform linux -- Python 3.12.3, pytest-8.1.1, pluggy-1.6.0
rootdir: /home/alvaro9rqc/1_Pacha/1-unsa/7_S/ps/lab/06_caja_negra_td_te/development
configfile: pyproject.toml
testpaths: finance
collecting ... collected 95 items                                                             

finance/adapters/inbound/ui_python/test_app_ui.py ...................... [ 23%]
................                                                         [ 40%]
finance/adapters/outbound/db_memory/test_memory_repos.py ............    [ 52%]
finance/core/app/test_blackbox_advanced.py ..                            [ 54%]
finance/core/app/test_services.py ............                           [ 67%]
finance/core/domain/test_entities.py ...............................     [100%]

============================== 95 passed in 0.25s ==============================
```
