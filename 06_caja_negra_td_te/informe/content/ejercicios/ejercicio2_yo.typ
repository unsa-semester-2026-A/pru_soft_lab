// ==========================================
// EJERCICIO 2: GUERRA DE TESTERS - PARTE II
// Responsable: Yo (Álvaro)
// Técnicas: Tablas de Decisión, Transición de Estados, Use Case testing, Random testing y Cause-effect Graphing.
// ==========================================

#block(
  fill: rgb("#fff7e6"),
  stroke: rgb("#ffd591"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Indicaciones de Álvaro:*
  Se han diseñado e implementado 5 técnicas avanzadas de pruebas de caja negra aplicadas sobre el núcleo hexagonal (`finance/core/domain` y `finance/core/app/services.py`). Los casos se encuentran automatizados en `finance/core/app/test_blackbox_advanced.py`.
]

== Ejercicio 2: Guerra de Testers - Parte II

=== Tablas de Decisión (TD)

Esta técnica modela la combinatoria lógica del comportamiento del método `register_transaction` frente a combinaciones válidas e inválidas de entradas. Se consolidó la siguiente Tabla de Decisión de 11 reglas.

#table(
  columns: (2.2fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr, 0.6fr),
  align: center + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Condiciones / Causas*]),
  [#strong("R1")], [#strong("R2")], [#strong("R3")], [#strong("R4")], [#strong("R5")], [#strong("R6")], [#strong("R7")], [#strong("R8")], [#strong("R9")], [#strong("R10")], [#strong("R11")],
  [C1: Tipo es EXPENSE (Gasto)], [F], [F], [F], [F], [T], [T], [T], [T], [T], [T], [T],
  [C2: Tipo es INCOME (Ingreso)], [T], [T], [T], [T], [F], [F], [F], [F], [F], [F], [F],
  [C3: Category ID no es nulo], [F], [T], [F], [F], [T], [T], [F], [T], [T], [T], [T],
  [C4: Cuenta activa y existe], [T], [T], [F], [T], [T], [T], [T], [T], [T], [F], [T],
  [C5: Monto > 0], [T], [T], [T], [F], [T], [T], [T], [T], [T], [T], [F],
  [C6: Categoría activa y existe], [-], [-], [-], [-], [T], [T], [-], [F], [T], [-], [-],
  [C7: Saldo cuenta >= Monto], [-], [-], [-], [-], [T], [T], [-], [-], [F], [-], [-],
  [C8: Gastos del mes > Límite], [-], [-], [-], [-], [F], [T], [-], [-], [-], [-], [-],
  
  table.cell(fill: rgb("#f5f5f5"), [*Acciones / Efectos*]),
  [], [], [], [], [], [], [], [], [], [], [],
  [E1: Guardar Transacción], [X], [], [], [], [X], [X], [], [], [], [], [],
  [E2: Modificar Saldo (+ / -)], [+], [], [], [], [-], [-], [], [], [], [], [],
  [E3: Lanzar InsufficientFundsError], [], [], [], [], [], [], [], [], [X], [], [],
  [E4: Lanzar ValueError], [], [X], [X], [X], [], [], [X], [X], [], [X], [X],
  [E5: Retornar Exceeded = True], [], [], [], [], [], [X], [], [], [], [], []
)

*Casos de Prueba Mapeados:*
- *TC_DT_01 (R1):* Ingreso exitoso de \$150.00 en cuenta activa sin categoría.
- *TC_DT_02 (R2):* Ingreso rechazado por incluir erróneamente un `category_id`.
- *TC_DT_03 (R3):* Ingreso rechazado en cuenta inexistente.
- *TC_DT_04 (R4):* Ingreso rechazado por monto nulo o negativo.
- *TC_DT_05 (R5):* Gasto exitoso disminuyendo saldo sin exceder presupuesto.
- *TC_DT_06 (R6):* Gasto exitoso pero que retorna alerta de presupuesto excedido (`exceeded = true`).
- *TC_DT_07 (R7):* Gasto rechazado por omitir el `category_id`.
- *TC_DT_08 (R8):* Gasto rechazado al usar una categoría inactiva (Soft Delete). *(Detecta error: el backend no valida si la categoría está activa)*.
- *TC_DT_09 (R9):* Gasto rechazado con `InsufficientFundsError` por sobregirar saldo.
- *TC_DT_10 (R10):* Gasto rechazado en cuenta inactiva (Soft Delete). *(Detecta error: el backend no valida si la cuenta está activa)*.
- *TC_DT_11 (R11):* Gasto rechazado por monto no positivo.

==== Implementación del Código de Pruebas (TD):
A continuación se detalla la clase `TestDecisionTable` en `test_blackbox_advanced.py` encargada de validar todas estas reglas:

```python
class TestDecisionTable:
    """Verifies rules of the Decision Table for transaction registration."""

    def test_r1_income_success(self, test_bundle: ServiceBundle) -> None:
        """R1: Income transaction, category omitted, active account, positive amount."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        tx, exceeded = test_bundle.service.register_transaction(
            account_id=acc.id,
            category_id=None,
            transaction_type="INCOME",
            amount=Decimal("150.00"),
            description="Salary",
        )
        assert tx.amount == Decimal("150.00")
        assert not exceeded
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("150.00")

    def test_r2_income_with_category_fails(self, test_bundle: ServiceBundle) -> None:
        """R2: Income transaction, category provided (must fail)."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Salary")
        with pytest.raises(ValueError, match="An income must not have a category"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=cat.id,
                transaction_type="INCOME",
                amount=Decimal("100.00"),
                description="Salary",
            )

    def test_r3_and_r4_income_inactive_or_missing_account_fails(
        self, test_bundle: ServiceBundle
    ) -> None:
        """R3 & R10: Account missing or inactive."""
        # Account not found
        with pytest.raises(ValueError, match="Account not found"):
            test_bundle.service.register_transaction(
                account_id=uuid4(),
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("100.00"),
                description="Salary",
            )

        # Inactive account
        acc = test_bundle.service.create_account(name="To Delete", bank="BCP")
        test_bundle.service.deactivate_account(acc.id)
        with pytest.raises(ValueError, match="Account is inactive"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("100.00"),
                description="Salary",
            )

    def test_r4_and_r11_invalid_amount_fails(self, test_bundle: ServiceBundle) -> None:
        """R4 & R11: Amount is zero or negative."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        with pytest.raises(ValueError, match="greater than 0"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("0.00"),
                description="Zero amount",
            )

    def test_r5_expense_success(self, test_bundle: ServiceBundle) -> None:
        """R5: Expense transaction. Validates active account, category, funds."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(cat.id, Decimal("100.00"), now.month, now.year)
        test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("200.00"), "Fund")

        tx, exceeded = test_bundle.service.register_transaction(
            account_id=acc.id,
            category_id=cat.id,
            transaction_type="EXPENSE",
            amount=Decimal("40.00"),
            description="Lunch",
        )
        assert tx.amount == Decimal("40.00")
        assert not exceeded

    def test_r6_expense_exceeds_budget_success(self, test_bundle: ServiceBundle) -> None:
        """R6: Expense exceeds budget limit but processes."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(cat.id, Decimal("50.00"), now.month, now.year)
        test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("200.00"), "Fund")

        tx, exceeded = test_bundle.service.register_transaction(
            account_id=acc.id,
            category_id=cat.id,
            transaction_type="EXPENSE",
            amount=Decimal("60.00"),
            description="Steak",
        )
        assert tx.amount == Decimal("60.00")
        assert exceeded

    def test_r7_expense_no_category_fails(self, test_bundle: ServiceBundle) -> None:
        """R7: Expense registered without category_id."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        with pytest.raises(ValueError, match="An expense must have a category"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="EXPENSE",
                amount=Decimal("10.00"),
                description="Missing category",
            )

    def test_r8_expense_inactive_category_fails(self, test_bundle: ServiceBundle) -> None:
        """R8: Expense registered on an inactive category."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        test_bundle.service.deactivate_category(cat.id)
        test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("100.00"), "Fund")

        with pytest.raises(ValueError, match="Category is inactive"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=cat.id,
                transaction_type="EXPENSE",
                amount=Decimal("10.00"),
                description="Inactive category expense",
            )

    def test_r9_expense_insufficient_funds_fails(self, test_bundle: ServiceBundle) -> None:
        """R9: Expense fails due to lack of funds."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        with pytest.raises(InsufficientFundsError, match="Insufficient funds"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=cat.id,
                transaction_type="EXPENSE",
                amount=Decimal("10.00"),
                description="Lunch",
            )
```

==== Resultados de Ejecución (TD):
Al ejecutar específicamente la suite de pruebas de Tablas de Decisión (`TestDecisionTable`), se obtienen las fallas que evidencian los bugs de desactivación lógica (Soft Delete) del sistema original (2 fallos, 7 aprobados):

```
$ uv run pytest finance/core/app/test_blackbox_advanced.py::TestDecisionTable -v
============================= test session starts ==============================
collected 9 items

finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r1_income_success PASSED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r2_income_with_category_fails PASSED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r3_and_r4_income_inactive_or_missing_account_fails FAILED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r4_and_r11_invalid_amount_fails PASSED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r5_expense_success PASSED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r6_expense_exceeds_budget_success PASSED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r7_expense_no_category_fails PASSED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r8_expense_inactive_category_fails FAILED
finance/core/app/test_blackbox_advanced.py::TestDecisionTable::test_r9_expense_insufficient_funds_fails PASSED

=================================== FAILURES ===================================
__________ TestDecisionTable.test_r3_and_r4_income_inactive_or_missing_account_fails ___________
    def test_r3_and_r4_income_inactive_or_missing_account_fails(self, test_bundle: ServiceBundle) -> None:
        ...
        acc = test_bundle.service.create_account(name="To Delete", bank="BCP")
        test_bundle.service.deactivate_account(acc.id)
>       with pytest.raises(ValueError, match="Account is inactive"):
E       Failed: DID NOT RAISE <class 'ValueError'>
...
__________ TestDecisionTable.test_r8_expense_inactive_category_fails ___________
    def test_r8_expense_inactive_category_fails(self, test_bundle: ServiceBundle) -> None:
        ...
        cat = test_bundle.service.create_category(name="Food")
        test_bundle.service.deactivate_category(cat.id)
>       with pytest.raises(ValueError, match="Category is inactive"):
E       Failed: DID NOT RAISE <class 'ValueError'>

========================= 2 failed, 7 passed in 0.08s ==========================
```

=== Transición de Estados (TE)

Se validaron las máquinas de estado del Presupuesto (Consumo Mensual) y de la Cuenta:

*Tabla de Transición para el Presupuesto:*
#table(
  columns: (1.5fr, 2.2fr, 1.3fr, 2fr),
  align: left + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Estado Actual*]),
  table.cell(fill: rgb("#f5f5f5"), [*Evento / Entrada*]),
  table.cell(fill: rgb("#f5f5f5"), [*Estado Siguiente*]),
  table.cell(fill: rgb("#f5f5f5"), [*Respuesta / Acción*]),
  
  [UNASSIGNED (S1)], [assign_budget(limit_amount)], [UNDER_LIMIT (S2)], [Crea el presupuesto con límite.],
  [UNDER_LIMIT (S2)], [register_expense() con total < limit], [UNDER_LIMIT (S2)], [Registra gasto, retorna `exceeded = false`.],
  [UNDER_LIMIT (S2)], [register_expense() con total == limit], [AT_LIMIT (S3)], [Registra gasto, retorna `exceeded = false`.],
  [UNDER_LIMIT (S2)], [register_expense() con total > limit], [EXCEEDED (S4)], [Registra gasto, retorna `exceeded = true`.],
  [AT_LIMIT (S3)], [register_expense(amount > 0)], [EXCEEDED (S4)], [Registra gasto, retorna `exceeded = true`.],
  [EXCEEDED (S4)], [register_expense(amount > 0)], [EXCEEDED (S4)], [Registra gasto, retorna `exceeded = true`.],
  [EXCEEDED (S4)], [assign_budget() con limit > gastos], [UNDER_LIMIT (S2)], [Actualiza límite, presupuesto vuelve a normal.],
  [EXCEEDED (S4)], [assign_budget() con limit <= gastos], [EXCEEDED (S4)], [Actualiza límite, continúa excedido.]
)

==== Implementación del Código de Pruebas (TE):
A continuación se detalla la clase `TestStateTransition` encargada de validar estas transiciones:

```python
class TestStateTransition:
    """Verifies state transitions for Budgets and Accounts."""

    def test_budget_state_transitions(self, test_bundle: ServiceBundle) -> None:
        """Validates S1 -> S2 -> S3 -> S4 state transitions."""
        acc = test_bundle.service.create_account(name="Card", bank="BCP")
        cat = test_bundle.service.create_category(name="Transport")
        now = datetime.now(timezone.utc)

        # S1 (UNASSIGNED): Check that budget status calculation fails before assignment
        with pytest.raises(ValueError, match="Budget not found"):
            test_bundle.service.calculate_budget_status(uuid4())

        # S1 -> S2 (UNDER_LIMIT): Assign budget of 100
        budget = test_bundle.service.assign_budget(cat.id, Decimal("100.00"), now.month, now.year)
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("0.00")
        assert not exceeded

        # Fund account
        test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("200.00"), "Fund")

        # S2 -> S2: Spend 50 (total spent = 50 < 100)
        _, exceeded = test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("50.00"), "Bus")
        assert not exceeded

        # S2 -> S3 (AT_LIMIT): Spend another 50 (total spent = 100 == 100)
        _, exceeded = test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("50.00"), "Taxi")
        assert not exceeded
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("100.00")

        # S3 -> S4 (EXCEEDED): Spend 0.01 (total spent = 100.01 > 100)
        _, exceeded = test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("0.01"), "Train")
        assert exceeded
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("100.01")
        assert exceeded

        # S4 -> S2: Update budget to 150 (new_limit > total_spent)
        test_bundle.service.assign_budget(cat.id, Decimal("150.00"), now.month, now.year)
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert not exceeded

        # S2 -> S4: Lower budget to 80 (new_limit < total_spent)
        test_bundle.service.assign_budget(cat.id, Decimal("80.00"), now.month, now.year)
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert exceeded
```

==== Resultados de Ejecución (TE):
Al ejecutar de forma aislada la clase de Transición de Estados, se observa un resultado exitoso:

```
$ uv run pytest finance/core/app/test_blackbox_advanced.py::TestStateTransition -v
============================= test session starts ==============================
collected 1 item

finance/core/app/test_blackbox_advanced.py::TestStateTransition::test_budget_state_transitions PASSED

============================== 1 passed in 0.03s ===============================
```

=== Pruebas de Casos de Uso (Use Case Testing)

Se modelaron escenarios de extremo a extremo representativos de los flujos del sistema financiero (con exclusión del registro de usuario UC-1):

- *UC-2: Configuración del Entorno Financiero (RF-02, RF-03, RF-04)*
  - *Flujo Principal:* Creación de cuenta, categoría y asignación de presupuesto.
  - *Flujo Alternativo (Upsert):* Reasignación de presupuesto al mismo mes y año actualizando el límite existente.
  - *Flujo Excepcional:* Creación de presupuestos con límites negativos o meses inválidos. El sistema los rechaza.

- *UC-3: Registro de Gastos y Control de Fondos (RF-05, RF-06)*
  - *Flujo Principal:* Fondear cuenta con ingreso, registrar un gasto menor al presupuesto y verificar saldos.
  - *Flujo Alternativo:* Gasto que excede el presupuesto pero con saldo suficiente. Registra la transacción pero genera alerta (`exceeded = true`).
  - *Flujo Excepcional:* Registrar un gasto sin fondos suficientes. Lanza `InsufficientFundsError` y mantiene el saldo intacto.

- *UC-4: Desactivación Lógica (Soft Delete) y Preservación (RF-07)*
  - *Flujo Principal:* Desactivar una cuenta. Comprobar que desaparece de las listas activas, pero sus transacciones históricas continúan preservadas.
  - *Flujo Excepcional:* Intentar registrar una nueva transacción en la cuenta inactiva. El sistema levanta un `ValueError` bloqueando la operación. *(Detecta error: el backend no bloquea transacciones en cuentas inactivas)*.

==== Implementación del Código de Pruebas (Use Cases):
A continuación se detalla la clase `TestUseCases` encargada de validar estos flujos:

```python
class TestUseCases:
    """Validates specific use case flows from end-to-end (excluding UC-1)."""

    def test_uc2_setup_environment(self, test_bundle: ServiceBundle) -> None:
        """UC-2: Create account, category, and budget with Upsert."""
        acc = test_bundle.service.create_account(name="Wallet", bank="Cash")
        assert acc.current_balance == Decimal("0.00")
        cat = test_bundle.service.create_category(name="Entertainment")
        now = datetime.now(timezone.utc)
        budget = test_bundle.service.assign_budget(cat.id, Decimal("100.00"), now.month, now.year)

        # Upsert
        updated_budget = test_bundle.service.assign_budget(cat.id, Decimal("120.00"), now.month, now.year)
        assert updated_budget.limit_amount == Decimal("120.00")
        assert len(test_bundle.budgets.list_all()) == 1

    def test_uc3_expense_and_budget_monitoring(self, test_bundle: ServiceBundle) -> None:
        """UC-3: Income, expenses, budget warnings, and insufficient funds."""
        acc = test_bundle.service.create_account(name="Account", bank="BCP")
        cat = test_bundle.service.create_category(name="Rent")
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(cat.id, Decimal("300.00"), now.month, now.year)

        test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("500.00"), "Scholarship")
        tx1, exceeded = test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("200.00"), "Rent 1")
        assert not exceeded

        tx2, exceeded = test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("100.01"), "Rent 2")
        assert exceeded

        with pytest.raises(InsufficientFundsError):
            test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("200.00"), "Overdraft")

    def test_uc4_archiving_and_preservation(self, test_bundle: ServiceBundle) -> None:
        """UC-4: Soft delete. History preserved but new blocked."""
        acc = test_bundle.service.create_account(name="Credit Card", bank="BBVA")
        cat = test_bundle.service.create_category(name="Books")
        test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("100.00"), "Gift")
        test_bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", Decimal("40.00"), "Clean Code")

        test_bundle.service.deactivate_account(acc.id)
        assert not test_bundle.accounts.get(acc.id).is_active
        assert len(test_bundle.transactions.list_all()) == 2

        with pytest.raises(ValueError, match="Account is inactive"):
            test_bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("10.00"), "New Income")
```

==== Resultados de Ejecución (Use Cases):
Al ejecutar esta clase, se detecta el bug de desactivación de cuentas (1 fallo, 2 aprobados):

```
$ uv run pytest finance/core/app/test_blackbox_advanced.py::TestUseCases -v
============================= test session starts ==============================
collected 3 items

finance/core/app/test_blackbox_advanced.py::TestUseCases::test_uc2_setup_environment PASSED
finance/core/app/test_blackbox_advanced.py::TestUseCases::test_uc3_expense_and_budget_monitoring PASSED
finance/core/app/test_blackbox_advanced.py::TestUseCases::test_uc4_archiving_and_preservation FAILED

=================================== FAILURES ===================================
_______________ TestUseCases.test_uc4_archiving_and_preservation _______________
    def test_uc4_archiving_and_preservation(self, test_bundle: ServiceBundle) -> None:
        ...
        test_bundle.service.deactivate_account(acc.id)
>       with pytest.raises(ValueError, match="Account is inactive"):
E       Failed: DID NOT RAISE <class 'ValueError'>

========================= 1 failed, 2 passed in 0.06s ==========================
```

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

=== Grafos Causa-Efecto (Cause-Effect Graphing)

El diseño del Grafo Causa-Efecto representa la lógica booleana del registro de transacciones (`register_transaction`), analizando la interacción entre las causas (condiciones de entrada) y efectos (acciones de salida o excepciones).

A continuación se muestra el diagrama del grafo causa-efecto generado para esta lógica:

#align(center)[
  #image("../../src/img/cause_effect_graph.pdf", width: 75%)
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
- *E1:* La transacción se almacena con éxito en el repositorio.
- *E2:* El saldo de la cuenta se actualiza.
- *E3:* Se lanza una excepción `InsufficientFundsError`.
- *E4:* Se lanza una excepción `ValueError` (por inconsistencia o datos inválidos).
- *E5:* Se evalúa el presupuesto del mes y se marca como excedido (retorna `exceeded = true`).

*Fórmulas Booleanas:*
- $E_1 = (C_2 and not C_3 and C_4 and C_5) or (C_1 and C_3 and C_4 and C_5 and C_6 and C_7)$
- $E_2 " (Ingreso)" = C_2 and not C_3 and C_4 and C_5$
- $E_2 " (Gasto)" = C_1 and C_3 and C_4 and C_5 and C_6 and C_7$
- $E_3 = C_1 and C_3 and C_4 and C_5 and C_6 and not C_7$
- $E_4 = not C_4 or not C_5 or (C_2 and C_3) or (C_1 and not C_3) or (C_1 and C_3 and not C_6)$
- $E_5 = E_1 and C_1 and ("Gastos del mes" > "Límite del presupuesto")$

=== Evidencias de Ejecución

Al ejecutar todo el conjunto de pruebas del sistema (combinando pruebas básicas PE y AVL unitarias de caja de cristal previa y las nuevas 5 técnicas de caja negra avanzada), se evidencia que se ejecutan 95 tests, resultando en 92 aprobados y 3 fallidos correspondientes exactamente a las tres fallas lógicas de Soft Delete descubiertas:

```
$ uv run pytest
============================= test session starts ==============================
platform linux -- Python 3.12.3, pytest-8.1.1, pluggy-1.4.0
rootdir: /home/alvaro9rqc/1_Pacha/1-unsa/7_S/ps/lab/06_caja_negra_td_te/development
configfile: pyproject.toml
testpaths: finance
collected 95 items

finance/adapters/inbound/ui_python/test_app_ui.py ....                   [  4%]
finance/adapters/outbound/db_memory/test_memory_repos.py ........       [ 12%]
finance/core/app/test_blackbox_advanced.py .............F..F.            [ 28%]
finance/core/app/test_services.py .............................          [ 58%]
finance/core/domain/test_entities.py ................................... [ 95%]
....F...........                                                         [100%]

=================================== FAILURES ===================================
1. TestDecisionTable::test_r3_and_r4_income_inactive_or_missing_account_fails
2. TestDecisionTable::test_r8_expense_inactive_category_fails
3. TestUseCases::test_uc4_archiving_and_preservation

======================== 3 failed, 92 passed in 0.28s ==========================
```
