=== Casos de Análisis de Valores Límite (AVL)
El Analisis de Valores Limite complementa la PE y exige probar los valores en la frontera, justo por debajo y justo por encima del rango permitido.

==== Entities
Las validaciones de valores frontera de las entidades se ejecutan directamente en el inicializador `__post_init__` y en los métodos mutadores de:
#link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/finance/core/domain/entities.py")[`finance/core/domain/entities.py`].

===== User
#table(
  columns: (1.4fr, 1.1fr, 1.1fr, 1.2fr),
  [Componente], [Límite / Condición], [Valor], [Resultado esperado],
  [User], [name vacío (Frontera)], [name=""], [Rechazado: ValueError],
  [User], [name con espacios (Frontera)], [name="   "], [Rechazado: ValueError],
  [User], [email vacío (Frontera)], [email=""], [Rechazado: ValueError],
  [User], [email sin @ (Frontera)], [email="invalid.email"], [Rechazado: ValueError],
  [User], [email con @ mínimo (Superior)], [email="a\@b"], [Aceptado],
)

===== Account
#table(
  columns: (1.5fr, 1.2fr, 1.4fr, 1.2fr),
  [Componente], [Límite], [Valor], [Resultado esperado],
  [Account.register_income], [amount=0 \ (Límite)], [amount="0.00"], [Rechazado: ValueError],
  [Account.register_income], [amount\<0 \ (Inferior)], [amount="0.00"], [Rechazado: ValueError],
  [Account.register_income], [amount>0 (Superior)], [amount="0.01"], [Aceptado],
  [Account.register_expense], [amount=0 (Límite)], [amount="0.00"], [Rechazado: ValueError],
  [Account.register_expense], [amount\<0 (Inferior)], [amount="0.00"], [Rechazado: ValueError],
  [Account.register_expense], [balance = amount (Límite)], [balance="50.00" \ amount="50.00"], [Aceptado (Saldo final 0.00)],
  [Account.register_expense], [balance > amount (Superior)], [balance="50.00"\ amount="49.99"], [Aceptado (Saldo final 0.01)],
  [Account.register_expense], [balance < amount (Inferior)], [balance="50.00"\ amount="50.01"], [Rechazado: \ InsufficientFundsErr],
)

===== Budget
#table(
  columns: (1.2fr, 1.1fr, 1.1fr, 1.2fr),
  [Componente], [Límite], [Valor], [Resultado esperado],
  [Budget], [limit_amount = 0 (Límite)], [limit_amount="0.00"], [Rechazado: ValueError],
  [Budget], [limit_amount < 0 (Inferior)], [limit_amount="0.00"], [Rechazado: ValueError],
  [Budget], [limit_amount > 0 (Superior)], [limit_amount="0.01"], [Aceptado],
  
  [Budget], [month = 1 (Límite Inf)], [month=1], [Aceptado],
  [Budget], [month < 1 (Inferior)], [month=0], [Rechazado: ValueError],
  [Budget], [month > 1 (Superior)], [month=2], [Aceptado],
  
  [Budget], [month = 12 (Límite Sup)], [month=12], [Aceptado],
  [Budget], [month < 12 (Inferior)], [month=11], [Aceptado],
  [Budget], [month > 12 (Superior)], [month=13], [Rechazado: ValueError],
  
  [Budget], [year = 1900 (Límite Inf)], [year=1900], [Aceptado],
  [Budget], [year < 1900 (Inferior)], [year=1899], [Rechazado: ValueError],
  [Budget], [year > 1900 (Superior)], [year=1901], [Aceptado],
)

===== Transaction
#table(
  columns: (1.2fr, 1.1fr, 1.1fr, 1.2fr),
  [Componente], [Límite / Condición], [Valor], [Resultado esperado],
  [Transaction], [amount = 0 (Límite)], [amount="0.00"], [Rechazado: ValueError],
  [Transaction], [amount < 0 (Inferior)], [amount="0.00"], [Rechazado: ValueError],
  [Transaction], [amount > 0 (Superior)], [amount="0.01"], [Aceptado],
  [Transaction], [description vacía (Límite)], [description=""], [Rechazado: ValueError],
  [Transaction], [description con espacios (Límite)], [description="   "], [Rechazado: ValueError],
)

==== Services
Los límites lógicos dentro de las operaciones de negocio de los servicios se procesan en el archivo unificado de la aplicación: #link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/finance/core/app/services.py")[`finance/core/app/services.py`].

===== \_sum_expenses

#table(
  columns: (1.2fr, 1fr, 1fr, 1.4fr),
  [Componente], [Limite], [Valor], [Resultado esperado],
  [\_sum_expenses], [mezcla INCOME/EXPENSE], [lista con INCOME y EXPENSE], [Suma solo gastos],
)

===== \_is_budget_exceeded
#table(
  columns: (1.2fr, 1.1fr, 1.2fr, 1.2fr),
  [Componente], [Límite], [Valor], [Resultado esperado],
  [\_is_budget_exceeded], [total_expenses = limit_amount\ (Frontera)], [total_expenses="200.00"\ limit_amount="200.00"], [Retorna False (No superado)],
  [\_is_budget_exceeded], [total_expenses < limit_amount\ (Inferior)], [total_expenses="199.99"\ limit_amount="200.00"], [Retorna False (No superado)],
  [\_is_budget_exceeded], [total_expenses > limit_amount\ (Superior)], [total_expenses="200.01"\  limit_amount="200.00"], [Retorna True (Superado)],
)