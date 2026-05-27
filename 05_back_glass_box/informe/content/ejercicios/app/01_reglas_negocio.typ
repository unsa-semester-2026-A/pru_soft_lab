Basar esta sección en `business_rules.md` y en las validaciones implementadas en las entidades.

#table(
  columns: (1.2fr, 2fr, 1.3fr),
  [Regla / Invariante], [Descripción], [Excepción o manejo],
  [Ej. Saldo no negativo], [Un gasto no puede dejar el saldo en negativo.], [`InsufficientFundsError`],
)

- *Notas:* (mencionar reglas especiales como soft delete, límites de presupuesto, etc.)
