Para validar la integridad y robustez del sistema FinanceApp, la suite de pruebas unitarias se estructuró siguiendo los principios de la Arquitectura Hexagonal. Esto garantiza que las reglas de negocio en el núcleo de la aplicación permanezcan completamente aisladas y desacopladas de los detalles de infraestructura, como la interfaz de usuario y los mecanismos de persistencia. En total, se han diseñado y ejecutado exitosamente *74 pruebas unitarias*, confirmando la validez y la corrección del diseño propuesto mediante la aplicación sistemática de las técnicas de Partición de Equivalencia (PE) y Análisis de Valores Límite (AVL).

A continuación, se detalla la distribución de estas pruebas según las capas de la arquitectura:

==== Capa Core (Domain & Services)

El núcleo de la aplicación concentra la lógica de negocio pura y la coordinación de los casos de uso principales. Sus pruebas se dividen en dos niveles:

- *Entidades del Dominio (Domain):* Ubicadas en `finance/core/domain/test_entities.py`, verifican el estado interno y las restricciones fundamentales de las entidades `User`, `Account`, `Budget` y `Transaction`, validando formatos, límites y reglas de consistencia de negocio.
- *Servicios de Aplicación (Services):* Ubicadas en `finance/core/app/test_services.py`, evalúan el servicio `FinanceService` y sus métodos auxiliares como `_sum_expenses`. Estas pruebas cubren la creación persistente en memoria, la asignación y actualización de presupuestos, el registro de transacciones con actualización de saldos, y la validación de fondos insuficientes.

#figure(
  image("/informe/src/img/alvaro/pruebas_app.png", width: 90%),
  caption: [Pruebas unitarias de dominio y servicios (Core) en ejecución exitosa.]
)

==== Capa de Adaptadores de Entrada (Adapters Inbound - UI & Validators)

Esta capa gestiona las interacciones externas e inicia las acciones del sistema. Las pruebas asociadas se encuentran en `finance/adapters/inbound/ui_python/test_app_ui.py` y se enfocan en:

- *Validación de Entradas:* Verificación rigurosa de funciones de validación como `validate_amount`, `validate_name`, `validate_month` y `validate_year` para filtrar datos erróneos antes de procesarlos.
- *Simulación del Presentador:* Comprobación del comportamiento de `DummyFinanceService`, asegurando que maneje correctamente los límites de saldo (lanzando `InsufficientFundsError` cuando corresponda) y evite listar cuentas inactivas.

#figure(
  image("/informe/src/img/alvaro/pruebas_ui.png", width: 90%),
  caption: [Pruebas de adaptadores de entrada (UI y validadores) confirmando la integridad de datos.]
)

==== Capa de Adaptadores de Salida (Adapters Outbound - Persistence)

Los adaptadores de salida implementan la comunicación con la infraestructura externa de persistencia. Las pruebas de persistencia en memoria están ubicadas en `finance/adapters/outbound/db_memory/test_memory_repos.py` y verifican:

- *InMemoryAccountRepository:* Controla que el flag `is_active` sea respetado en todas las operaciones de obtención de cuentas.
- *InMemoryTransactionRepository:* Aplica rangos de valores límite estrictos para la recuperación de transacciones dentro de periodos temporales específicos.
- *InMemoryBudgetRepository:* Garantiza el correcto filtrado de presupuestos por categoría, mes y año.

#figure(
  image("/informe/src/img/alvaro/pruebas_db.png", width: 90%),
  caption: [Pruebas de adaptadores de salida (repositorios en memoria) garantizando la correcta persistencia.]
)
