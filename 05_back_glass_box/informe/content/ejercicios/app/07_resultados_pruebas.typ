Resultados de pruebas internas del producto (core/domain y core/app).

==== Entities

Las pruebas del dominio estan en `finance/core/domain/test_entities.py` y cubren
las entidades User, Account, Budget y Transaction, incluyendo validaciones de
formatos, limites y reglas de negocio.

Evidencia: Fig 1. Pruebas de dominio (entities) en ejecucion.

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

Evidencia: Fig 2. Pruebas de servicios (core/app) en ejecucion.
