=== Inyección de Fallas de Interfaz: Caso 1 y Caso 2

==== Caso 1 (Sintáctico): Inyección de Datos Malformados
- *Diseño de la Prueba:* Enviar un JSON con campos faltantes o tipos de datos erróneos al endpoint de reservas (ej. intentar confirmar un pago sin mandar el `paymentProxy` en el body).
- *Ejecución / Herramienta:* Configurar una petición POST en Postman o en el código (`StripeReservationFlowIntegrationTest`) hacia `/api/v2/events/.../reservations/.../confirm`.
- *Comportamiento Esperado:* La API debe interceptar el esquema inválido y devolver HTTP `400 Bad Request` o `422 Unprocessable Entity` inmediatamente, bloqueando la capa de persistencia.

==== Caso 2 (Semántico): Valores Legales Fuera de Lógica
- *Diseño de la Prueba:* Enviar un payload que sea sintácticamente válido (JSON correcto) pero semánticamente incorrecto (ej. intentar reservar boletos de una categoría "oculta" sin enviar el código especial, o enviar fechas de nacimiento en el futuro para los asistentes).
- *Ejecución / Herramienta:* Enviar un POST a `/api/v2/events/.../reservations` con IDs de categorías restringidas.
- *Comportamiento Esperado:* Aunque la sintaxis es correcta, el `TicketReservationManager` evalúa las reglas de negocio, detecta la infracción y la API devuelve un mensaje de error sin efectuar la reserva.

=== Documentación de Discrepancias (Casos 1 y 2)
#align(center)[
  #table(
    columns: (1fr, 2fr, 2fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); ID Caso],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Resultado Esperado],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Resultado Real],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Estado],
    
    [INC-01 (Sintáctico)], [HTTP 422 ante payload incompleto.], [TODO (Alvaro): Anotar el resultado real tras la ejecución], [En pruebas],
    [INC-02 (Semántico)], [Error de validación de negocio al violar restricciones de categoría.], [TODO (Alvaro): Anotar el resultado real tras la ejecución], [En pruebas]
  )
]
