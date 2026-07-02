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
