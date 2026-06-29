=== Inyección de Fallas de Interfaz

==== Caso 1 (Sintáctico): Inyección de Datos Malformados (Alvaro)
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

==== Caso 2 (Semántico): Valores Legales Fuera de Lógica (Alvaro)
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

==== Caso 3 (Resiliencia): Timeout en Pasarela de Pagos / Webhook (Alisson)
- *Diseño de la Prueba:* Simular una alta latencia o falta de respuesta al confirmar un pago externo (ej. Stripe no responde a tiempo o el webhook llega muy tarde).
- *Ejecución / Herramienta:* Simular una latencia alta en las pasarelas externas o diseñar una prueba asíncrona con `MockMvc` simulando un retardo en el controlador del webhook.
- *Comportamiento Esperado:* El sistema debe mantener la reserva en estado `EXTERNAL_PROCESSING_PAYMENT` y, al expirar el tiempo de sesión, liberar los tickets bloqueados sin afectar otras transacciones.
- *Resultado Real:* TODO (Alisson): Anotar el resultado real observado tras la prueba.

=== Documentación de Discrepancias (Casos 1, 2 y 3)
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
    [INC-03 (Resiliencia)], [La reserva no se confirma y los tickets se liberan tras expirar el timeout.], [TODO (Alisson): Anotar el resultado real observado tras la prueba], [En pruebas]
  )
]

=== Reporte de Ejecución de Pruebas (Alvaro)
A continuación se adjunta la captura del resultado de ejecución en la terminal obtenida para los dos casos de prueba de integración de Alvaro:

#align(center)[
  #figure(
    image("/informe/src/fig/ejercicio2/test_output.png", width: 95%),
    caption: [Salida de terminal de la ejecución exitosa de las pruebas de integración de Alvaro en alf.io.],
  ) <fig-test-output-alvaro>
]
