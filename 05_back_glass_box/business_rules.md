## 1. Estructura de Datos (Modelos de Dominio / DTOs)

Las propiedades están definidas en inglés para mantener un código limpio,
acompañadas de su propósito.

- **User** (El perfil local)
- `id`: UUID.
- `name`: String (Cadena de texto).
- `email`: String (Validar formato básico).

- **Account** (Origen o destino del dinero)
- `id`: UUID.
- `name`: String (Ej. "Ahorros").
- `bank`: String (Ej. "Interbank", "Cash").
- `current_balance`: Decimal (Inicia en 0.0, modificado solo internamente por
las transacciones).
- `is_active`: Boolean (Por defecto `True`).

- **Category** (Clasificación del gasto)
- `id`: UUID.
- `name`: String (Ej. "Servicios").
- `is_active`: Boolean (Por defecto `True`. Mecanismo de soft delete).

- **Budget** (La regla temporal de límite)
- `id`: UUID.
- `category_id`: UUID (Referencia a Category).
- `limit_amount`: Decimal (Debe ser > 0).
- `month`: Integer (1-12).
- `year`: Integer (Ej. 2026).

- **Transaction** (El movimiento financiero)
- `id`: UUID.
- `account_id`: UUID (Obligatorio).
- `category_id`: UUID (Obligatorio si es EXPENSE, nulo si es INCOME).
- `transaction_type`: Enum (`INCOME` o `EXPENSE`).
- `amount`: Decimal (Debe ser > 0).
- `description`: String (Concepto del movimiento).
- `created_at`: Datetime (Fecha y hora).

---

## 2. Flujos Principales (Casos de Uso)

Cada flujo representa la lógica de orquestación que la interfaz gráfica llamará.

- **Creación de Entidades Base:** Se registran los objetos iniciales (User,
Account, Category). Se valida que los nombres no estén vacíos ni compuestos solo
de espacios.
- **Asignación de Presupuesto:** El sistema asocia un límite de dinero a una
categoría para un periodo específico. Si el usuario envía un nuevo límite para
el mismo mes y año, se actualiza el registro existente en lugar de crear uno
nuevo.
- **Registro de Ingreso (`INCOME`):** Se recibe el dinero. Se suma el `amount`
al `current_balance` de la cuenta seleccionada y se persiste la transacción.
- **Registro de Gasto (`EXPENSE`):** Se valida el origen y el destino. Se
verifica que el `current_balance` sea suficiente. Si lo es, se resta el `amount`
de la cuenta, se guarda la transacción y se evalúa si la sumatoria de gastos del
mes supera el `limit_amount` del presupuesto activo.

---

## 3. Reglas de Negocio y Casos Especiales (Invariantes)

Estas reglas deben arrojar excepciones de Python (ej. `ValueError`) si se
incumplen, asegurando que las pruebas pasen sin fallos en la base de datos.

1. **Protección de Saldo:** Antes de un `EXPENSE`, se evalúa `current_balance -
amount`. Si es `< 0`, se cancela el flujo y se lanza un error de "Fondos
insuficientes".
2. **Soft Delete (`is_active`):** Al eliminar una `Account` o `Category`, el
sistema solo cambia `is_active = False`. La interfaz las oculta en los nuevos
registros, pero las mantiene en el historial para evitar transacciones huérfanas
y errores de integridad referencial.
3. **Presupuestos No Bloqueantes:** Si un `EXPENSE` supera el `limit_amount` del
`Budget` actual, la transacción se ejecuta de todos modos (si hay saldo en la
cuenta). El sistema retorna un indicador visual de "Presupuesto Excedido", pero
los números reales se mantienen íntegros.
4. **Montos Absolutos:** Todo `amount` ingresado debe ser `> 0`. Un ingreso de
monto negativo se rechaza. El campo `transaction_type` es el único responsable
de definir si es una suma o una resta.

---

## 4. Ejemplos de Acciones (Firmas y Ejecuciones)

Así es como se verían las interacciones desde la capa de interfaz hacia la capa
de casos de uso (Dominio).

> [!IMPORTANT]
> Esto no refleja el código final, solo es un ejemplo de como luciría el flujo

**1. Inicializar la app creando una Cuenta y una Categoría:**

```python # Creación de la cuenta donde guardaremos el dinero
crear_cuenta(name="Sueldo", bank="BCP") # Resultado: Account(id="uuid-1",
name="Sueldo", bank="BCP", current_balance=0.0, is_active=True)

# Creación de la categoría para ordenar gastos
crear_categoria(name="Transporte") # Resultado: Category(id="uuid-2",
name="Transporte", is_active=True)

```

**2. Asignar un presupuesto para el mes actual (Mayo 2026):**

```python asignar_presupuesto(category_id="uuid-2", limit_amount=150.00,
month=5, year=2026) # Resultado: Budget(id="uuid-3", category_id="uuid-2",
limit_amount=150.00, month=5, year=2026)

```

**3. Registrar un Ingreso (Cobro de salario):**

```python registrar_transaccion( account_id="uuid-1", category_id=None,
transaction_type="INCOME", amount=1000.00, description="Sueldo de mayo") # El
sistema suma 1000 a la cuenta "uuid-1". # Nuevo current_balance de
    Account("Sueldo") = 1000.00

```

**4. Registrar un Gasto (Pago de taxi):**

```python registrar_transaccion( account_id="uuid-1", category_id="uuid-2",
transaction_type="EXPENSE", amount=40.00, description="Taxi al trabajo") # El
sistema verifica: ¿1000.00 >= 40.00? Sí. # El sistema resta 40 a la cuenta
"uuid-1". Nuevo balance = 960.00 # El sistema evalúa presupuesto: Gastado (40)
<= Límite (150). Todo en orden.

```

**5. Intentar registrar un Gasto sin fondos suficientes (Fallo esperado):**

```python registrar_transaccion( account_id="uuid-1", category_id="uuid-2",
transaction_type="EXPENSE", amount=2000.00, description="Viaje") # El sistema
verifica: ¿960.00 >= 2000.00? Falso. # Resultado: Lanza Excepción "Saldo
insuficiente". La base de datos no se toca.

```
