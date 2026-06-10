Casos de Particion de Equivalencia (PE) para dominio y servicios del producto.
La PE agrupa entradas en clases validas e invalidas; un valor representativo por
clase es suficiente para cubrir el comportamiento esperado.

==== Entities

===== User

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [User], [Valida], [name="John" \, email="john\@example.com"], [Usuario creado],
  [User], [Invalida], [name="" \, email="john\@example.com"], [Rechazado: nombre vacio],
  [User], [Invalida], [name="John" \, email=""], [Rechazado: email vacio],
  [User], [Invalida], [name="John" \, email="invalid-email"], [Rechazado: formato email],
)

===== Account

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [Account], [Valida], [name="Savings" \, bank="BCP"], [Cuenta creada],
  [Account], [Invalida], [name="" \, bank="BCP"], [Rechazado: nombre vacio],
  [Account], [Invalida], [name="Savings" \, bank=""], [Rechazado: banco vacio],
  [Account.register_income], [Valida], [amount=100.00], [Saldo incrementado],
  [Account.register_income], [Invalida], [amount=0], [Rechazado: monto no positivo],
  [Account.register_income], [Invalida], [amount=-1], [Rechazado: monto no positivo],
  [Account.register_expense], [Valida], [amount=40 \, balance=100], [Saldo decrementado],
  [Account.register_expense], [Invalida], [amount=150 \, balance=100], [Rechazado: saldo insuficiente],
  [Account.register_expense], [Invalida], [amount=0], [Rechazado: monto no positivo],
)

===== Budget

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [Budget], [Valida], [limit=100 \, month=5 \, year=2026], [Presupuesto creado],
  [Budget], [Invalida], [limit=0 \, month=5 \, year=2026], [Rechazado: limite > 0],
  [Budget], [Invalida], [limit=-1 \, month=5 \, year=2026], [Rechazado: limite > 0],
  [Budget], [Invalida], [limit=100 \, month=0 \, year=2026], [Rechazado: mes 1..12],
  [Budget], [Invalida], [limit=100 \, month=13 \, year=2026], [Rechazado: mes 1..12],
  [Budget], [Invalida], [limit=100 \, month=5 \, year=1899], [Rechazado: anio invalido],
)

===== Transaction

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [Transaction], [Valida], [type=INCOME \, category_id=None], [Transaccion valida],
  [Transaction], [Invalida], [type=EXPENSE \, category_id=None], [Rechazado: gasto sin categoria],
  [Transaction], [Invalida], [type=INCOME \, category_id=uuid], [Rechazado: ingreso con categoria],
  [Transaction], [Invalida], [amount=0], [Rechazado: monto > 0],
  [Transaction], [Invalida], [amount=-0.01], [Rechazado: monto > 0],
)

==== Services

===== register_transaction

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [register_transaction], [Valida], [account_id existe], [Transaccion registrada],
  [register_transaction], [Invalida], [account_id inexistente], [Rechazado: cuenta no encontrada],
  [register_transaction], [Valida], [category_id=None], [Transaccion sin categoria],
  [register_transaction], [Valida], [category_id valido], [Transaccion con categoria],
  [register_transaction], [Invalida], [transaction_type="OTHER"], [Rechazado: tipo invalido],
)

===== assign_budget

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [assign_budget], [Valida], [sin presupuesto previo], [Crea presupuesto],
  [assign_budget], [Valida], [presupuesto existente], [Actualiza limite],
)

===== \_is_budget_exceeded

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [\_is_budget_exceeded], [Valida], [gasto>limite], [Presupuesto superado],
  [\_is_budget_exceeded], [Valida], [gasto<=limite], [Presupuesto no superado],
  [\_is_budget_exceeded], [Valida], [category_id=None], [Sin verificacion],
  [\_is_budget_exceeded], [Valida], [sin presupuesto], [Retorna False],
)

===== \_sum_expenses

#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [\_sum_expenses], [Valida], [lista con INCOME y EXPENSE], [Suma solo gastos],
)

==== UI y Validaciones

===== validate_amount
#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [validate_amount], [Valida], ["150.50"], [Decimal(150.50)],
  [validate_amount], [Valida], ["200"], [Decimal(200)],
  [validate_amount], [Invalida], ["abc"], [Rechazado: no es numero],
  [validate_amount], [Invalida], ["   "], [Rechazado: vacio],
  [validate_amount], [Invalida], ["-10"], [Rechazado: mayor a 0],
)

===== validate_month / validate_year
#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [validate_month], [Valida], ["6"], [Entero 6],
  [validate_month], [Invalida], ["marzo"], [Rechazado: debe ser entero],
  [validate_year], [Valida], ["2026"], [Entero 2026],
  [validate_year], [Invalida], ["veinte"], [Rechazado: debe ser entero],
)

==== Persistencia en Memoria

===== Repositorios (Account y Budget)
#table(
  columns: (1.2fr, 0.5fr, 1fr, 1.4fr),
  [Componente], [Clase], [Valor], [Resultado esperado],
  [AccountRepository.get], [Valida], [Cuenta activa], [Retorna cuenta],
  [AccountRepository.get], [Invalida], [Cuenta inactiva], [Retorna None (soft delete)],
  [AccountRepository.list], [Valida], [Mixtas activas/inactivas], [Retorna todas],
  [BudgetRepository.get], [Valida], [Parametros correctos], [Retorna presupuesto],
  [BudgetRepository.get], [Invalida], [Mes incorrecto], [Retorna None],
)
