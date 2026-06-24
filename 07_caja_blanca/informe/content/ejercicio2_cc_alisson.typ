=== Función Asignada: `Transaction.__post_init__` (Mariel / Alisson)

*Ubicación:* `finance/core/domain/entities.py` (Líneas 200 a 219).

==== Código a Analizar:
```py
def __post_init__(self) -> None:
    """Validate entity fields.

    Raises:
        ValueError: If amount <= 0, description is empty, or category rules
            are violated (expense needs category, income must not have one).
    """
    if self.amount <= 0:
        raise ValueError("Transaction amount must be greater than 0.")

    is_expense = self.transaction_type == TransactionType.EXPENSE
    if is_expense and self.category_id is None:
        raise ValueError("An expense must have a category.")

    is_income = self.transaction_type == TransactionType.INCOME
    if is_income and self.category_id is not None:
        raise ValueError("An income must not have a category.")

    _validate_not_empty(self.description, "Description")
```

==== 1. Grafo de Flujo de Control (CFG) - Mariel (Alisson)
#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Instrucciones:* Dibuja y enumera los nodos y aristas de la función. Puedes adjuntar una imagen utilizando:
    
    `#figure(image("../src/img/fixed/cfg_transaction_alisson.png", width: 70%), caption: [Grafo de Flujo de Control - Transaction.__post_init__])`
  ]
)

==== 2. Cálculo Manual de la Complejidad Ciclomática (CC) - Mariel (Alisson)
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
radon cc development/finance/core/domain/entities.py -s -a
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
