Resultados de pruebas internas del producto (core/domain y core/app).

==== Entities

Las pruebas del dominio estan en `finance/core/domain/test_entities.py` y cubren
las entidades User, Account, Budget y Transaction, incluyendo validaciones de
formatos, limites y reglas de negocio.

==== Services

Las pruebas de servicios estan en `finance/core/app/test_services.py` y cubren
el servicio `FinanceService` y el metodo `_sum_expenses`.

- Crear usuario y cuenta persiste en repositorios en memoria.
- Asignar presupuesto crea uno nuevo o actualiza el existente.
- Registrar ingreso actualiza el saldo y guarda la transaccion.
- Registrar gasto valida fondos y marca presupuesto excedido.
- Rechazo de tipo de transaccion invalido.
- Rechazo de cuenta inexistente.
- Calculo correcto del total de gastos.

#figure(
  image("/informe/src/img/alvaro/pruebas_app.png", width: 100%),
  caption: [Pruebas de dominio y servicios en ejecución (Core).]
)

==== UI y Validaciones (Adapters Inbound)

Las pruebas de UI y validaciones se encuentran en `finance/adapters/inbound/ui_python/test_app_ui.py`.
Cubren las funciones de validación de entradas numéricas, cadenas de texto, y las reglas del DummyService simulando la capa de presentación.
- `validate_amount`, `validate_name`, `validate_month`, `validate_year` operan con sus correctos rechazos de PE y AVL.
- `DummyFinanceService` respeta los límites de saldo (InsufficientFundsError) y no lista cuentas inactivas.

#figure(
  image("/informe/src/img/alvaro/pruebas_ui.png", width: 100%),
  caption: [Pruebas de adaptadores de UI (PE y AVL).]
)

==== Persistencia en Memoria (Adapters Outbound)

Las pruebas de repositorios de memoria están en `finance/adapters/outbound/db_memory/test_memory_repos.py`.
Estas verifican el almacenamiento, filtros temporales y soft-deletes de entidades.
- `InMemoryAccountRepository` respeta el flag `is_active` en sus métodos `get`.
- `InMemoryTransactionRepository` aplica AVL estrictos para recuperar transacciones en el periodo correcto.
- `InMemoryBudgetRepository` filtra correctamente por categoría, mes y año.

#figure(
  image("/informe/src/img/alvaro/pruebas_db.png", width: 100%),
  caption: [Pruebas de repositorios en memoria (PE y AVL).]
)
