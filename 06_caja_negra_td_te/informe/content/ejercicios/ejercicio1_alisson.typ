// ==========================================
// EJERCICIO 1: PRUEBAS AVANZADAS DE PARABANK
// Responsable: Alisson
// Técnicas: Tablas de Decisión (TD) y Transición de Estados (TE)
// ==========================================


= Pruebas Avanzadas de ParaBank (TD y TE)

Para verificar el correcto comportamiento del sistema ParaBank se aplicaron técnicas de pruebas de caja negra avanzadas: *Tablas de Decisión (TD)* y *Transición de Estados (TE)*, enfocándose en los flujos más críticos del dominio bancario.

== Tablas de Decisión (TD)

Las Tablas de Decisión permiten modelar la combinatoria lógica del sistema ante múltiples condiciones de entrada, identificando qué combinaciones producen cada resultado esperado. Se diseñaron tres tablas aplicadas a las funcionalidades clave de ParaBank.

=== Funcionalidad 1: Registro de Usuario

Se modeló la lógica de registro de nuevos clientes, considerando 12 condiciones de entrada: campos obligatorios, disponibilidad de usuario y coincidencia de contraseñas. Se consolidó la siguiente Tabla de Decisión de 13 reglas.

#table(
  columns: (2.2fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr, 0.5fr),
  align: left + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Condiciones / Causas*]),
  [#strong("R1")],
  [#strong("R2")],
  [#strong("R3")],
  [#strong("R4")],
  [#strong("R5")],
  [#strong("R6")],
  [#strong("R7")],
  [#strong("R8")],
  [#strong("R9")],
  [#strong("R10")],
  [#strong("R11")],
  [#strong("R12")],
  [#strong("R13")],

  [C1: First Name proporcionado], [T], [F], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-],
  [C2: Last Name proporcionado], [T], [-], [F], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-],
  [C3: Address proporcionado], [T], [-], [-], [F], [-], [-], [-], [-], [-], [-], [-], [-], [-],
  [C4: City proporcionada], [T], [-], [-], [-], [F], [-], [-], [-], [-], [-], [-], [-], [-],
  [C5: State proporcionado], [T], [-], [-], [-], [-], [F], [-], [-], [-], [-], [-], [-], [-],
  [C6: Zip Code proporcionado], [T], [-], [-], [-], [-], [-], [F], [-], [-], [-], [-], [-], [-],
  [C7: Phone proporcionado], [T], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-],
  [C8: SSN proporcionado], [T], [-], [-], [-], [-], [-], [-], [F], [-], [-], [-], [-], [-],
  [C9: Username proporcionado], [T], [-], [-], [-], [-], [-], [-], [-], [F], [-], [-], [-], [-],
  [C10: Password proporcionado], [T], [-], [-], [-], [-], [-], [-], [-], [-], [F], [-], [-], [-],
  [C11: Confirm proporcionado], [T], [-], [-], [-], [-], [-], [-], [-], [-], [-], [F], [-], [-],
  [C12: Username disponible], [T], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [F], [-],
  [C13: Passwords coinciden], [T], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [-], [F],

  table.cell(fill: rgb("#f5f5f5"), [*Acciones / Efectos*]),
  [], [], [], [], [], [], [], [], [], [], [], [], [],
  [E1: Registro Exitoso], [X], [], [], [], [], [], [], [], [], [], [], [], [],
  [E2: Error de validación / Registro fallido], [], [X], [X], [X], [X], [X], [X], [X], [X], [X], [X], [X], [X],
)

*Casos de Prueba Mapeados:*
- *TC_TD_R01 (R1):* Todos los campos proporcionados, username disponible, contraseñas coinciden.\ *Resultado:* Registro exitoso.
- *TC_TD_R02 (R2):* First Name no proporcionado (vacío). \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R03 (R3):* Last Name no proporcionado.\ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R04 (R4):* Address no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R05 (R5):* City no proporcionada. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R06 (R6):* State no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R07 (R7):* Zip Code no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R08 (R8):* SSN no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R09 (R9):* Username no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R10 (R10):* Password no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R11 (R11):* Confirm Password no proporcionado. \ *Resultado:* Error de validación, registro fallido.
- *TC_TD_R12 (R12):* Todos los campos completos pero username ya existe. \ *Resultado:* Error "This username already exists".
- *TC_TD_R13 (R13):* Todos los campos completos pero Password y Confirm no coinciden. \ *Resultado:* Error "Password confirmation mismatch".

=== Funcionalidad 2: Inicio de Sesión

Se modeló la lógica de autenticación del usuario considerando si el username está registrado y si la contraseña es correcta. Se consolidó la siguiente Tabla de Decisión de 3 reglas.

#table(
  columns: (3fr, 1fr, 1fr, 1fr),
  align: left + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Condiciones / Causas*]),
  [#strong("R1")], [#strong("R2")], [#strong("R3")],

  [C1: Username registrado], [T], [F], [T],
  [C2: Password correcto], [T], [-], [F],

  table.cell(fill: rgb("#f5f5f5"), [*Acciones / Efectos*]),
  [], [], [],
  [E1: Acceso Permitido], [X], [], [],
  [E2: Acceso Denegado], [], [X], [X],
)

*Casos de Prueba Mapeados:*
- *TC_TD_L01 (R1):* Username registrado y password correcto. \ *Resultado:* Acceso permitido, redirección al panel de cuentas.
- *TC_TD_L02 (R2):* Username no registrado en el sistema. \ *Resultado:* Acceso denegado, mensaje de error.
- *TC_TD_L03 (R3):* Username registrado pero password incorrecto. \ *Resultado:* Acceso denegado, mensaje de error.

=== Funcionalidad 3: Transferencia de Fondos Interna

Se modeló la lógica de transferencia entre cuentas, verificando que la cuenta de destino sea válida y que el saldo sea suficiente. Se consolidó la siguiente Tabla de Decisión de 3 reglas.

#table(
  columns: (3fr, 1fr, 1fr, 1fr),
  align: left + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Condiciones / Causas*]),
  [#strong("R1")], [#strong("R2")], [#strong("R3")],

  [C1: Account == Verify Account], [T], [F], [T],
  [C2: Monto \<= Saldo], [T], [-], [F],

  table.cell(fill: rgb("#f5f5f5"), [*Acciones / Efectos*]),
  [], [], [],
  [E1: Pago Realizado], [X], [], [],
  [E2: Transferencia Rechazada], [], [X], [X],
)

*Casos de Prueba Mapeados:*
- *TC_TD_T01 (R1):* Cuenta de destino verificada y saldo suficiente. \ *Resultado:* Pago realizado, fondos transferidos exitosamente.
- *TC_TD_T02 (R2):* Cuenta de destino no verificada (no pertenece al cliente o no existe). \ *Resultado:* Transferencia rechazada, error de cuenta.
- *TC_TD_T03 (R3):* Cuenta verificada pero saldo insuficiente (monto > saldo). \ *Resultado:* Transferencia rechazada, fondos insuficientes.

== Transición de Estados (TE)

La técnica de Transición de Estados modela el comportamiento dinámico del sistema, identificando los estados por los que pasa una entidad y los eventos que provocan el cambio de un estado a otro.

=== Diagrama 1: Autenticación

El sistema de autenticación de ParaBank se modela como una máquina de estados con dos estados principales: *Desconectado* y *Autenticado*. Las transiciones entre estos estados se producen por eventos de login exitoso, login fallido, logout y navegación protegida.

#figure(
  image("../../src/img/fixed/als/auth.png", width: 70%),
  caption: [Diagrama de estados del sistema de autenticación: Desconectado ↔ Autenticado],
)

===== Casos de Prueba Mapeados (TE - Autenticación)

- *TC_TE_A01 (Happy Path):* S0 → S1. Login con credenciales válidas → acceso al sistema.
- *TC_TE_A02 (Login fallido):* S0 → S0. Login con credenciales incorrectas → permanece en Desconectado.
- *TC_TE_A03 (Logout):* S1 → S0. El usuario cierra sesión → vuelve a Desconectado.
- *TC_TE_A04 (Bucle protegido):* S1 → S1. El usuario navega por secciones protegidas sin perder sesión.

=== Diagrama 2: Solicitud de Préstamo

El proceso de solicitud de préstamo sigue un ciclo de vida con estados secuenciales y ramificación condicional.

#figure(
  image("../../src/img/fixed/als/loan.png", width: 70%),
  caption: [Diagrama de estados del flujo de solicitud de préstamo: Solicitud → Evaluación → Aprobado/Denegado → Cuenta Fondeada],
)

==== Casos de Prueba Mapeados (TE - Préstamo)

- *TC_TE_P01 (Happy Path):* S0 → S1 → S2 → S4. Solicitud con enganche correcto y riesgo bajo → aprobada → cuenta fondeada.
- *TC_TE_P02 (Fondos insuficientes):* S0 → S1 → S3. Solicitud con fondos de enganche insuficientes → denegada.
- *TC_TE_P03 (Riesgo alto):* S0 → S1 → S3. Solicitud con enganche correcto pero riesgo alto → denegada.

== Resumen de Resultados

#table(
  columns: (3fr, 1.5fr, 1.5fr, 1.5fr),
  align: left + horizon,
  table.cell(fill: rgb("#f5f5f5"), [*Técnica / Flujo*]),
  table.cell(fill: rgb("#f5f5f5"), [*Casos Diseñados*]),
  table.cell(fill: rgb("#f5f5f5"), [*Casos Ejecutados*]),
  table.cell(fill: rgb("#f5f5f5"), [*Cobertura*]),

  [TD - Registro de Usuario], [13], [13], [100%],
  [TD - Inicio de Sesión], [3], [3], [100%],
  [TD - Transferencia de Fondos], [3], [3], [100%],
  [TE - Autenticación], [4], [4], [100%],
  [TE - Solicitud de Préstamo], [3], [3], [100%],
  [Total], [26], [26], [100%],
)

Las Tablas de Decisión permitieron identificar de forma sistemática todas las combinaciones relevantes de entradas válidas e inválidas, asegurando cobertura completa de las reglas de negocio críticas. Los Diagramas de Transición de Estados modelaron el comportamiento temporal del sistema, validando tanto los caminos exitosos (Happy Path) como las excepciones en cada fase del ciclo de vida de las operaciones bancarias. Las pruebas fueron ejecutadas sobre la aplicación web en línea de ParaBank, verificando que el sistema responde correctamente según lo especificado.
