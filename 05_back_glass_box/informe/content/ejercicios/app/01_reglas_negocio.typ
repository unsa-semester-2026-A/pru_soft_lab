#table(
  columns: (1.2fr, 2.5fr, 1.3fr),
  [ID / Requerimiento], [Descripción], [Ámbito / Entidades],
  [RF-01: Registro de Usuario], [Crear el perfil local validando que el nombre no esté vacío y el correo tenga un formato básico.], [User],
  [RF-02: Control de Cuentas], [Registrar cuentas con saldo inicial en cero, restringiendo su modificación directa desde el exterior.], [Account],
  [RF-03: Clasificación], [Crear categorías operativas para la organización y posterior análisis de los movimientos financieros.], [Category],
  [RF-04: Planificación], [Asignar un límite mensual por categoría. Si se vuelve a enviar el periodo, se actualiza el valor existente.], [Budget, Category],
  [RF-05: Gestión de Ingresos], [Procesar entradas de dinero incrementando el saldo de la cuenta e indexando la transacción.], [Transaction, Account],
  [RF-06: Control de Gastos], [Validar la disponibilidad de fondos, debitar el monto y comprobar el estado del presupuesto asignado.], [Transaction, Account],
  [RF-07: Preservación], [Desactivar cuentas o categorías de forma lógica para proteger la integridad del historial de transacciones.], [Account, Category]
)

#table(
  columns: (1.3fr, 2fr, 1.5fr),
  [Regla / Invariante], [Descripción], [Excepción o manejo],
  [Protección de saldo],
  [Un gasto (`EXPENSE`) no puede dejar el `current_balance` de la cuenta en un valor negativo.],
  [`InsufficientFundsError`],
  
  [Montos positivos],
  [Todo valor de `amount` en transacciones y `limit_amount` en presupuestos debe ser estrictamente mayor a cero.],
  [`ValueError`],
  
  [Validación de texto],
  [Los nombres de las entidades base (`User`, `Account`, `Category`) no pueden estar vacíos ni compuestos solo por espacios.],
  [`ValueError`],
  
  [Rango de periodo],
  [El campo `month` dentro de un presupuesto (`Budget`) debe ser un entero restringido entre 1 y 12.],
  [`ValueError`],
  
  [Unicidad de presupuesto],
  [Solo se permite un presupuesto por categoría para un mismo mes y año. Si ya existe, el sistema actualiza el registro.],
  [Actualización (Upsert)],
  
  [Integridad de transacción],
  [Las transacciones de tipo `EXPENSE` requieren obligatoriamente un `category_id`. Los ingresos (`INCOME`) lo omiten.],
  [Validación estructural],
)

- *Notas:*
  - *Soft Delete (`is_active`):* La eliminación de una cuenta o categoría es lógica (`is_active = False`). La interfaz oculta el registro para nuevas operaciones, pero los datos permanecen intactos en la base de datos para evitar registros huérfanos y mantener la integridad del historial.
  - *Presupuestos No Bloqueantes:* Superar el `limit_amount` de un presupuesto no detiene la ejecución de un gasto si la cuenta dispone de fondos. El sistema procesa la transacción y genera una alerta visual de "Presupuesto Excedido", sin alterar los saldos reales.
  - *Inmutabilidad Externa del Saldo:* El campo `current_balance` de una cuenta no puede modificarse directamente por agentes externos; su estado se calcula y actualiza exclusivamente a través del procesamiento interno de transacciones.
