=== Mapeo de la Frontera
Se identifica el punto de entrega de control y datos en el flujo principal del sistema:
- *Subsistema A (Capa de Presentación / Cliente):* `ReservationApiV2Controller` recibe las solicitudes HTTP (REST).
- *Frontera de Integración:* Interfaz HTTP (endpoints REST) y el paso de DTOs hacia los Managers.
- *Subsistema B (Capa de Negocio y Persistencia):* `TicketReservationManager` interactúa con PostgreSQL.

#align(center)[
  #table(
    columns: (1.5fr, 1.5fr, 2fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Componente Emisor (A)],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Componente Receptor (B)],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Datos / Control Transferido],
    
    [Cliente API / Frontend], [ReservationApiV2Controller], [Solicitud de reserva de tickets vía POST `/api/v2/events/.../reservations`],
    [Stripe Webhook (Mock)], [StripePaymentWebhookController], [Notificación asíncrona de confirmación de pago]
  )
]

=== Inyección de Fallas de Interfaz: Caso 3 (Resiliencia)

==== Caso 3 (Resiliencia): Timeout en Pasarela de Pagos / Webhook
- *Diseño de la Prueba:* Simular una alta latencia o falta de respuesta al confirmar un pago externo (ej. Stripe no responde a tiempo o el webhook llega muy tarde).
- *Ejecución / Herramienta:* Enviar peticiones simuladas con alta latencia usando Postman (o herramientas como Toxiproxy), o diseñar una prueba con `MockMvc` simulando un retardo o desconexión en el controlador del webhook.
- *Comportamiento Esperado:* El sistema debe mantener la reserva en estado `EXTERNAL_PROCESSING_PAYMENT` y, al expirar el tiempo de sesión, liberar los tickets bloqueados sin afectar otras transacciones.

=== Documentación de Discrepancias (Caso 3)
#align(center)[
  #table(
    columns: (1fr, 2fr, 2fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); ID Caso],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Resultado Esperado],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Resultado Real],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Estado],
    
    [INC-03 (Resiliencia)], [La reserva no se confirma y los tickets se liberan tras expirar el timeout.], [TODO (Alisson): Anotar el resultado real observado tras la prueba], [En pruebas]
  )
]
