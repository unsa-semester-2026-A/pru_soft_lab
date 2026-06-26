=== Complejidad Ciclomática en `Transaction.__post_init__` (Responsable: Alisson Jara)

*Ubicación:* `finance/core/domain/entities.py` (Líneas 200 a 218).

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

==== Grafo de Flujo de Control (CFG)
*Metodología de conteo de nodos:*

Para el cálculo de la Complejidad Ciclomática, solo se contabilizan los *nodos predicado* (puntos de decisión). Las sentencias de error (`raise`) y las sentencias de secuencia (asignaciones, llamadas a funciones) *no se cuentan* como nodos separados porque:

- *Sentencias de error (`raise`):* Son el resultado directo de una condición True. No crean un nuevo camino, sino que terminan la ejecución en ese punto. Se consideran parte del mismo nodo predicado.
- *Sentencias de secuencia:* Las asignaciones como `is_expense = ...` se ejecutan en orden lineal sin bifurcación. Son transiciones directas entre nodos predicado.

Análisis de nodos predicado en `Transaction.__post_init__`:

#table(
  columns: (0.5fr, 2fr, 1fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#dfdfdf") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#f8f9fa"))[*Nodo*],
  table.cell(fill: rgb("#f8f9fa"))[*Descripción*],
  table.cell(fill: rgb("#f8f9fa"))[*Tipo*],

  [1], [`def __post_init__(self) -> None:`], [Inicio],
  [2], [`if self.amount <= 0`], [Predicado],
  [3a], [`if is_expense`], [Predicado (cortocircuito)],
  [3b], [`if self.category_id is None`], [Predicado],
  [4a], [`if is_income`], [Predicado (cortocircuito)],
  [4b], [`if self.category_id is not None`], [Predicado],
  [5], [`_validate_not_empty(self.description, "Description")`], [Fin],
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
  [e2], [2 → 5], [amount <= 0 = True (Termina en raise)],
  [e3], [2 → 3a], [amount <= 0 = False],
  [e4], [3a → 3b], [is_expense = True],
  [e5], [3a → 4a], [is_expense = False],
  [e6], [3b → 5], [category_id is None = True],
  [e7], [3b → 4a], [category_id is None = False],
  [e8], [4a → 4b], [is_income = True],
  [e9], [4a → 5], [is_income = False],
  [e10], [4b → 5], [category_id is not None = True],
  [e11], [4b → 5], [category_id is not None = False],
)

#figure(
  image("../src/img/finance/graph_transaction.png", width: 62%),
  caption: [Grafo de Flujo de Control (CFG) para `Transaction.__post_init__`],
)

// #mermaid("---
// config:
//   look: classic
// ---
// graph TD
//     classDef inicioFin fill:#B8B8B8,stroke:#000000,stroke-width:2px,color:#1B5E20,font-weight:bold;
//     classDef predicado fill:#FFF9C4,stroke:#000000,stroke-width:2px,color:#000000,font-weight:bold;
//     1((1))
//     2((2))
//     3a((3a))
//     3b((3b))
//     4a((4a))
//     4b((4b))
//     5((5))
//     class 1,5 inicioFin;
//     class 2,3a,3b,4a,4b predicado;
//     1 -->|e1: Entrada| 2
//     2 -->|e2: True | 5
//     2 -->|e3: False| 3a
//     3a -->|e4: True| 3b
//     3a -->|e5: False| 4a
//     3b -->|e6: True -> | 5
//     3b -->|e7: False| 4a
//     4a -->|e8: True| 4b
//     4a -->|e9: False| 5
//     4b -->|e10: True ->| 5
//     4b -->|e11: False| 5
//     linkStyle default stroke:#000000,stroke-width:2px,font-family:Arial;")

==== Cálculo Manual de la Complejidad Ciclomática (CC)

Para el cálculo manual de la complejidad ciclomática de la función, se aplican las siguientes fórmulas convencionales:

*Fórmula 1:* $C C = A - N + 2$

- Número de Aristas ($A$): $11$
- Número de Nodos ($N$): $7$
- $C C = 11 - 7 + 2 = 6$

*Fórmula 2:* $C C = P + 1$

Análisis de nodos predicado (decisiones):
- P1: `if self.amount <= 0` → 1 condición atómica
- P2: `if is_expense and self.category_id is None` → 2 condiciones atómicas (cortocircuito `and`)
- P3: `if is_income and self.category_id is not None` → 2 condiciones atómicas (cortocircuito `and`)

- Número de Nodos Predicado ($P$): $1 + 2 + 2 = 5$
- $C C = 5 + 1 = 6$

*Resultado:* $C C = 6$



==== Verificación con la Herramienta Radon

*Comando ejecutado:*
```bash
radon cc development/finance/core/domain/entities.py -s -a
```

*Salida de Radon:*

#figure(
  image("../src/img/finance/radon_transaction.png", width: 80%),
  caption: [Resultado de Radon para `Transaction.__post_init__`],
)

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Resultados de Radon:*
    - Score numérico de Radon: *6*
    - Categoría de riesgo (Rango A-F): *B* (Riesgo moderado, CC entre 6-10)
    - *Coincidencia de resultados:* El cálculo manual con la fórmula $C C = P + 1 = 5 + 1 = 6$ coincide exactamente con el score de 6 reportado por Radon, validando la precisión del análisis.
  ],
)

==== Análisis de Resultados

La función `Transaction.__post_init__` presenta una complejidad ciclomática de 6, lo que indica un riesgo moderado. Esto se debe principalmente a las validaciones condicionales con el operador `and` que genera cortocircuito, creando múltiples caminos de ejecución.

*Recomendaciones:*
- La complejidad es aceptable para una función de validación.
- Se podrían extraer las validaciones en funciones auxiliares para mejorar la legibilidad.
- Cada camino de ejecución requiere un caso de prueba mínimo para alcanzar cobertura completa de ramas.
