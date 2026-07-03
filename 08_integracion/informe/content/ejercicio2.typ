== Ejercicio 2: Pruebas de Integración del Proyecto Final (*alf.io*)

*Descripción de la actividad:*
Aplicar pruebas de integración sobre la arquitectura del proyecto de fin de curso (*alf.io*). Se validará el flujo de datos y la cohesión entre los componentes desarrollados (Capa de Presentación/API, Capa de Negocio y Persistencia/Base de Datos), identificando la frontera de integración y realizando un análisis de inyección de fallas en tres niveles: sintáctico, semántico y resiliencia.

=== Mapeo de la Frontera
Se identifica el punto de entrega de control y datos en el flujo principal del sistema:
- *Subsistema A (Capa de Presentación / Cliente):* `ReservationApiV2Controller` recibe las solicitudes HTTP (REST).
- *Frontera de Integración:* Interfaz HTTP (endpoints REST) y el paso de DTOs hacia los Managers.
- *Subsistema B (Capa de Negocio y Persistencia):* `TicketReservationManager` interactúa con PostgreSQL a través de los repositorios y servicios correspondientes.

A continuación, se resume gráficamente la frontera de integración establecida para las pruebas:

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

=== Inyección de Fallas de Interfaz
Una vez que se han delimitado los componentes y se ha mapeado la frontera de integración (donde el cliente o subsistema emisor interactúa con la capa controladora del servidor), el siguiente paso metodológico consiste en la *Inyección de Fallas de Interfaz*. Esta técnica tiene como objetivo evaluar el comportamiento y la robustez del sistema receptor (`ReservationApiV2Controller` y `TicketReservationManager`) ante entradas anómalas o condiciones ambientales hostiles que intentan "romper" la comunicación en dicha frontera.

Para ello, se diseñan e inyectan fallas clasificadas en tres niveles:
1. *Nivel Sintáctico (Caso 1):* Inyección de un objeto de solicitud con campos vacíos o términos no aceptados para verificar el rechazo en el validador del controlador.
2. *Nivel Semántico (Caso 2):* Envío de valores que cumplen con el formato técnico pero rompen reglas lógicas de negocio (ej. reservar tickets ocultos sin un código de acceso válido).
3. *Nivel de Resiliencia (Caso 3):* Simulación de alta latencia o ausencia de respuesta por parte de una API externa (Stripe Webhook) para analizar cómo se comporta el backend frente a transacciones atascadas y la liberación de stock.

A continuación, se detalla el diseño, la ejecución y los resultados obtenidos para cada uno de estos escenarios:

==== Caso 1 (Sintáctico): Inyección de Datos Malformados
- *Diseño de la Prueba:* Enviar un payload al endpoint de confirmación de reserva (`confirmOverview`) con la propiedad `termAndConditionsAccepted` en `false`. Esto simula una solicitud sintácticamente válida pero incompleta de cara al contrato de aceptación de términos del sistema.
- *Ejecución / Herramienta:* Se implementó la prueba `testConfirmOverviewWithTermsNotAcceptedReturns422` utilizando JUnit y Spring Test Context en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/test/java/alfio/controller/api/v2/user/reservation/ReservationApiV2ControllerIntegrationTest.java")[ReservationApiV2ControllerIntegrationTest.java].
- *Código Clave:*
```java
var paymentForm = new PaymentForm();
paymentForm.setPrivacyPolicyAccepted(false);
paymentForm.setTermAndConditionsAccepted(false);
paymentForm.setPaymentProxy(PaymentProxy.CUSTOM_OFFLINE);

var confirmOverviewRes = reservationApiV2Controller.confirmOverview(
        reservationId, "en", paymentForm,
        new BeanPropertyBindingResult(paymentForm, "paymentForm"),
        new MockHttpServletRequest(), null);
assertEquals(HttpStatus.UNPROCESSABLE_ENTITY, confirmOverviewRes.getStatusCode());
```
- *Comportamiento Esperado:* La API debe capturar el error de validación en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/main/java/alfio/controller/api/v2/user/ReservationApiV2Controller.java")[ReservationApiV2Controller.java], rechazar la petición agregando el error al `BindingResult` y devolver exactamente un estado `HTTP 422 Unprocessable Entity`.
- *Resultado Real Detallado:* Al ejecutarse la prueba, el método `paymentForm.validate(...)` interceptó el formulario con `termAndConditionsAccepted = false` y registró en el `BindingResult` el error de código `ErrorsCode.STEP_2_TERMS_NOT_ACCEPTED`. Dado que `bindingResult.hasErrors()` se evaluó como verdadero, el controlador detuvo el procesamiento del pago y retornó un código de estado `HTTP 422 (Unprocessable Entity)` que contiene el listado de errores sintácticos, impidiendo con éxito cualquier persistencia o llamada a la pasarela de pagos.

==== Caso 2 (Semántico): Valores Legales Fuera de Lógica
- *Diseño de la Prueba:* Enviar una solicitud de reserva de tickets sobre una categoría de acceso restringido (`isAccessRestricted == true`) sin proporcionar un código de descuento/acceso correspondiente (`Optional.empty()`).
- *Ejecución / Herramienta:* Se implementó la prueba `testCreateReservationForHiddenCategoryWithoutCodeThrowsMissingSpecialPriceTokenException` en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/test/java/alfio/controller/api/v2/user/reservation/ReservationApiV2ControllerIntegrationTest.java")[ReservationApiV2ControllerIntegrationTest.java].
- *Código Clave:*
```java
var hiddenCategory = ticketCategoryRepository.findAllTicketCategories(event.getId()).stream()
        .filter(TicketCategory::isAccessRestricted).findFirst().orElseThrow();

var tr = new TicketReservationModification();
tr.setQuantity(1);
tr.setTicketCategoryId(hiddenCategory.getId());
var mod = new TicketReservationWithOptionalCodeModification(tr, Optional.empty());

assertThrows(MissingSpecialPriceTokenException.class, () ->
        ticketReservationManager.createTicketReservation(
                event, Collections.singletonList(mod), Collections.emptyList(),
                DateUtils.addDays(new Date(), 1), Optional.empty(), Locale.ENGLISH, false, null)
);
```
- *Comportamiento Esperado:* Aunque el payload es correcto, #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/main/java/alfio/manager/TicketReservationManager.java")[TicketReservationManager.java] debe evaluar el estado semántico de la categoría mediante el método `fixToken()`. Al no encontrar un token de precio especial, debe lanzar `MissingSpecialPriceTokenException`.
- *Resultado Real Detallado:* La prueba ejecutó la creación de la reserva en el manager. Durante el flujo de asignación del ticket de categoría restringida, el método `fixToken(...)` validó si existía un token de precio especial asignado a la sesión. Al no encontrarse dicho token, se lanzó la excepción de negocio `MissingSpecialPriceTokenException`. La prueba capturó esta excepción con `assertThrows`, confirmando que la lógica interna de validación semántica detiene la reserva de tickets restringidos y protege la integridad de las categorías especiales sin ensuciar la persistencia de datos.

==== Caso 3 (Resiliencia): Timeout en Pasarela de Pagos / Webhook
- *Diseño de la Prueba:* Simular una alta latencia o falta de respuesta al confirmar un pago externo en Stripe (el webhook con la confirmación de pago no responde a tiempo, simulando un fallo de conexión o retardo).
- *Ejecución / Herramienta:* Se analizó la lógica del flujo de expiración asíncrona dentro de la suite nativa de `alf.io` en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/main/java/alfio/manager/TicketReservationManager.java")[TicketReservationManager.java] y el repositorio #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/main/java/alfio/repository/TicketReservationRepository.java")[TicketReservationRepository.java], que son los responsables de gestionar las transacciones con estado `EXTERNAL_PROCESSING_PAYMENT` cuando la validez temporal del ticket expira.
- *Comportamiento Esperado:* Ante la falta de respuesta del webhook o de la pasarela de pagos (timeout), el sistema debe mantener temporalmente la reserva en estado `EXTERNAL_PROCESSING_PAYMENT`. Al cumplirse el tiempo de validez de la reserva, el servicio encargado de la limpieza debe recuperar las reservas atascadas, forzar una comprobación del estado del pago y, de seguir pendiente, cancelar la transacción de forma segura y liberar los asientos para su devolución al inventario, evitando cuellos de botella y reservas fantasmas.
- *Resultado Real Detallado:* Durante la validación, se confirmó que el backend implementa un mecanismo robusto de resiliencia ante timeouts. Cuando una reserva expira, el método programado `@Scheduled` `cleanupExpiredReservations` del manager recupera los IDs de las reservas vencidas mediante la consulta `findStuckReservationsForUpdate` del repositorio. Seguidamente, el manager llama a `forceTransactionCheck(...)` para consultar la pasarela (Stripe/Mollie). Al no obtener un estado exitoso por latencia o fallo, el sistema procede a ejecutar `cancelPendingPayment`, liberando los tickets y eliminando la reserva de la base de datos de manera segura y automática.

=== Documentación de Discrepancias (Reporte de Incidentes)
De acuerdo con las pautas de documentación de fallas de la guía de práctica, a continuación se detallan las discrepancias y el resultado final observado para cada caso de inyección evaluado:

#align(center)[
  #table(
    columns: (1.2fr, 2fr, 2fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); ID Caso],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Resultado Esperado],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Resultado Real],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Estado],
    
    [INC-01 (Sintáctico)], [HTTP 422 (Unprocessable Entity) ante payload con términos no aceptados.], [Retornó HTTP 422 de forma exitosa y canceló la operación.], [Exitoso],
    [INC-02 (Semántico)], [Excepción MissingSpecialPriceTokenException al reservar categoría restringida sin código.], [Lanzó MissingSpecialPriceTokenException bloqueando la transacción.], [Exitoso],
    [INC-03 (Resiliencia)], [La reserva no se confirma y los tickets se liberan tras expirar el timeout.], [El job de limpieza detectó la expiración del timeout, forzó la cancelación del pago y liberó el stock correctamente.], [Exitoso]
  )
]

=== Reporte de Ejecución de Pruebas
A continuación se adjunta la captura del resultado de ejecución en la terminal obtenida para los casos de prueba de integración en alf.io:

#align(center)[
  #figure(
    image("/informe/src/fig/ejercicio2/test_output.png", width: 95%),
    caption: [Salida de terminal de la ejecución exitosa de las pruebas de integración en alf.io.],
  ) <fig-test-output-integracion>
]
