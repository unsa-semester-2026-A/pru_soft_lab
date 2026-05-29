Casos de Analisis de Valores Limite (AVL) para entradas criticas del producto.
El AVL exige probar el limite, el valor inferior inmediato y el superior.

==== Entities

===== User

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [User], [name vacio], [name=""], [Rechazado: nombre vacio],
  [User], [email vacio], [email=""], [Rechazado: email vacio],
  [User], [email sin @], [email="invalid-email"], [Rechazado: formato email],
)

===== Account

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [Account.register_income], [amount=0], [amount=0], [Rechazado: monto no positivo],
  [Account.register_income], [amount>0], [amount=0.01], [Aceptado],
  [Account.register_income], [amount\<0], [amount=-0.01], [Rechazado],
  [Account.register_expense], [balance=amount], [balance=amount], [Aceptado (saldo en cero)],
  [Account.register_expense], [balance\<amount], [balance=amount-0.01], [Rechazado: saldo insuficiente],
)

===== Budget

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [Budget], [limit minimo], [limit=0.01], [Aceptado],
  [Budget], [limit=0], [limit=0], [Rechazado: limite > 0],
  [Budget], [month minimo], [month=1], [Aceptado],
  [Budget], [month maximo], [month=12], [Aceptado],
  [Budget], [month\<1], [month=0], [Rechazado: mes 1..12],
  [Budget], [month>12], [month=13], [Rechazado: mes 1..12],
  [Budget], [year minimo], [year=1900], [Aceptado],
  [Budget], [year\<1900], [year=1899], [Rechazado: anio invalido],
)

===== Transaction

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [Transaction], [amount minimo], [amount=0.01], [Aceptado],
  [Transaction], [amount=0], [amount=0], [Rechazado: monto > 0],
  [Transaction], [amount\<0], [amount=-0.01], [Rechazado: monto > 0],
  [Transaction], [gasto sin categoria], [type=EXPENSE \, category_id=None], [Rechazado],
  [Transaction], [ingreso con categoria], [type=INCOME \, category_id=uuid], [Rechazado],
)

==== Services

===== \_is_budget_exceeded

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [\_is_budget_exceeded], [gasto=limite], [total=limite], [Presupuesto no superado],
  [\_is_budget_exceeded], [gasto>limite], [total=limite+0.01], [Presupuesto superado],
)

===== \_sum_expenses

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [\_sum_expenses], [mezcla INCOME/EXPENSE], [lista con INCOME y EXPENSE], [Suma solo gastos],
)
