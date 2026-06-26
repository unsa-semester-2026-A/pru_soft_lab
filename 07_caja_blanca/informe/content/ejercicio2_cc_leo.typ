=== Complejidad Ciclomática en FinanceService.register_transaction (Responsable: Leonardo Arce)

*Ubicación:* `finance/core/app/services.py` (Líneas 131 a 179).

==== Código a Analizar:
```py
def register_transaction(
    self,
    account_id: UUID,
    category_id: UUID | None,
    transaction_type: str,
    amount: Decimal,
    description: str,
) -> tuple[Transaction, bool]:
    """Register a transaction and return budget status."""
    account = self._account_repository.get(account_id)

    if account is None:
        raise ValueError("Account not found.")
    parsed_type = self._parse_transaction_type(transaction_type)
    transaction = Transaction(
        account_id=account_id,
        category_id=category_id,
        transaction_type=parsed_type,
        amount=amount,
        description=description,
        created_at=datetime.now(timezone.utc),
    )
    if parsed_type == TransactionType.INCOME:
        account.register_income(amount)
        self._account_repository.update(account)
        self._transaction_repository.add(transaction)
        return transaction, False

    account.register_expense(amount)
    self._account_repository.update(account)
    self._transaction_repository.add(transaction)
    exceeded = self._is_budget_exceeded(transaction)
    return transaction, exceeded
```

==== Grafo de Flujo de Control (CFG)
*Metodología de conteo de nodos:*

Para el cálculo de la Complejidad Ciclomática, se contabilizan únicamente los *nodos predicado* (puntos de decisión) y los puntos de inicio/secuencia y fin de la función. Las sentencias de error (`raise`) y de retorno (`return`) no representan nodos predicado independientes, sino que son transiciones directas al nodo de salida (Fin). Las sentencias secuenciales se agrupan en el bloque de inicio o de transición correspondiente.

Análisis de nodos predicado en `FinanceService.register_transaction`:

#table(
  columns: (0.5fr, 2fr, 1fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#dfdfdf") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#f8f9fa"))[*Nodo*],
  table.cell(fill: rgb("#f8f9fa"))[*Descripción*],
  table.cell(fill: rgb("#f8f9fa"))[*Tipo*],

  [1], [`def register_transaction(...)` (hasta la obtención de la cuenta)], [Inicio],
  [2], [`if account is None:` (valida existencia de cuenta)], [Predicado],
  [3], [`raise ValueError("Account not found.")` (rama de error)], [Fin (Error)],
  [4], [`if parsed_type == TransactionType.INCOME:` (valida tipo de operación)], [Predicado],
  [5], [Registro de ingreso y retorno `return transaction, False`], [Fin (Retorno)],
  [6], [Registro de gasto, evaluación de presupuesto y retorno], [Fin (Retorno)],
  [7], [Terminación de la función (convergencia final de salidas)], [Fin],
)

*Aristas del CFG:*

#table(
  columns: (1fr, 1.5fr, 2.5fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#dfdfdf") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#f8f9fa"))[*Arista*],
  table.cell(fill: rgb("#f8f9fa"))[*Origen → Destino*],
  table.cell(fill: rgb("#f8f9fa"))[*Condición*],

  [e1], [1 → 2], [Entrada a la función (Siempre)],
  [e2], [2 → 3], [`account is None` es True],
  [e3], [2 → 4], [`account is None` es False],
  [e4], [3 → 7], [ValueError Exception termina la ejecución],
  [e5], [4 → 5], [`parsed_type == TransactionType.INCOME` es True],
  [e6], [4 → 6], [`parsed_type == TransactionType.INCOME` es False],
  [e7], [5 → 7], [Retorno de transacción de ingresos],
  [e8], [6 → 7], [Retorno de transacción de gastos],
)

#figure(
  image("../src/img/leonardo/Diagrama_flujo.jpeg", width: 75%),
  caption: [Grafo de Flujo de Control (CFG) para `FinanceService.register_transaction`],
)

==== Cálculo Manual de la Complejidad Ciclomática (CC)

Para la determinación de la complejidad ciclomática de la función, se aplican las siguientes fórmulas matemáticas:

*Fórmula 1:* $C C = A - N + 2$

- Número de Aristas ($A$): $8$
- Número de Nodos ($N$): $7$
- $C C = 8 - 7 + 2 = 3$

*Fórmula 2:* $C C = P + 1$

Análisis de nodos predicado (decisiones):
- P1: `if account is None` → 1 condición
- P2: `if parsed_type == TransactionType.INCOME` → 1 condición

- Número de Nodos Predicado ($P$): $2$
- $C C = 2 + 1 = 3$

*Resultado:* $C C = 3$

==== Verificación con la Herramienta Radon

*Comando ejecutado:*
```bash
radon cc development/finance/core/app/services.py -s -a
```

#figure(
  image("../src/img/leonardo/radon_transaction_leo.png", width: 80%),
  caption: [Resultado de Radon para `FinanceService.register_transaction`],
)

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Resultados de Radon:*
    - Score numérico de Radon: *3*
    - Categoría de riesgo (Rango A-F): *A* (Riesgo bajo, CC <= 5)
    - *Comparación de Resultados:* El cálculo manual coincide plenamente con la herramienta Radon. Al aplicar ambas fórmulas ($A - N + 2$ y $P + 1$), se obtiene como resultado exacto $C C = 3$, lo cual es congruente con la salida de Radon que califica con complejidad 3 y nivel de riesgo A.
  ]
)

==== Análisis de Resultados

La función `FinanceService.register_transaction` tiene una complejidad ciclomática de 3, lo cual es considerado un riesgo muy bajo (Categoría A). La estructura de la función se compone de dos decisiones simples e independientes: la verificación de la existencia de la cuenta y la bifurcación lógica según el tipo de transacción (ingreso o gasto).

*Recomendaciones:*
- La modularidad y la legibilidad son excelentes.
- Se recomienda tener al menos 3 casos de prueba unitarios específicos (uno para cuenta no encontrada, uno para ingresos y otro para gastos) para lograr cobertura total de ramas en la fase de pruebas de caja blanca.