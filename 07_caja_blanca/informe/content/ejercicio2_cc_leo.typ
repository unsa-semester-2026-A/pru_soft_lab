=== Función Asignada: `FinanceService.register_transaction` (Leo)

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

==== 1. Grafo de Flujo de Control (CFG) - Leo
#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Instrucciones:* Dibuja y enumera los nodos y aristas de la función. Puedes adjuntar una imagen utilizando:
    
    `#figure(image("../src/img/fixed/cfg_register_transaction_leo.png", width: 70%), caption: [Grafo de Flujo de Control - FinanceService.register_transaction])`
  ]
)

==== 2. Cálculo Manual de la Complejidad Ciclomática (CC) - Leo
Aplica las siguientes fórmulas para el cálculo:
1. $C C = A - N + 2$
2. $C C = P + 1$

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Desarrollo del Cálculo:*
    - Número de Aristas ($A$): [Completar]
    - Número de Nodos ($N$): [Completar]
    - Número de Nodos Predicado ($P$): [Completar]
    
    *Resultado:* $C C =$ [Completar]
  ]
)

==== 3. Verificación con la Herramienta Radon - Mariel (Alisson)
*Instrucciones para Mariel:* Ejecuta el siguiente comando en la terminal para obtener el score de Radon:
```bash
radon cc development/finance/core/app/services.py -s -a
```

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Resultados de Radon:*
    - Score numérico de Radon: [Completar]
    - Categoría de riesgo (Rango A-F): [Completar]
    - ¿El resultado manual coincide con el de la herramienta?: [Completar]
  ]
)
