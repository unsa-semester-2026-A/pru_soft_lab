=== Inyección de Fallas de Interfaz: Caso 1 y Caso 2 (Alvaro)

==== Caso 1 (Sintáctico): Inyección de Datos Malformados (Términos no Aceptados)
- *Diseño de la Prueba:* Enviar un payload al endpoint de confirmación de reserva (`confirmOverview`) con la propiedad `termAndConditionsAccepted` en `false`. Esto simula una solicitud sintácticamente válida pero incompleta de cara al contrato de aceptación de términos del sistema.
- *Ejecución / Código:* Se implementó la prueba `testConfirmOverviewWithTermsNotAcceptedReturns422` en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/test/java/alfio/controller/api/v2/user/reservation/ReservationApiV2ControllerIntegrationTest.java")[ReservationApiV2ControllerIntegrationTest.java].
- *Código Clave (Prueba):*
```java
var paymentForm = new PaymentForm();
paymentForm.setPrivacyPolicyAccepted(false);
paymentForm.setTermAndConditionsAccepted(false); // Violación de validación
paymentForm.setPaymentProxy(PaymentProxy.CUSTOM_OFFLINE);

var confirmOverviewRes = reservationApiV2Controller.confirmOverview(
        reservationId, "en", paymentForm,
        new BeanPropertyBindingResult(paymentForm, "paymentForm"),
        new MockHttpServletRequest(), null);
assertEquals(HttpStatus.UNPROCESSABLE_ENTITY, confirmOverviewRes.getStatusCode());
```
- *Comportamiento Esperado:* La API debe capturar el error de validación en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/main/java/alfio/controller/api/v2/user/ReservationApiV2Controller.java")[ReservationApiV2Controller.java], rechazar la petición agregando el error al `BindingResult` y devolver exactamente un estado `HTTP 422 Unprocessable Entity`.
- *Resultado Real:* El backend interceptó correctamente el incumplimiento de la validación sintáctica del formulario a través de `paymentForm.validate(...)` y retornó `HTTP 422` de forma exitosa.

==== Caso 2 (Semántico): Valores Legales Fuera de Lógica (Reserva de Categoría Restringida)
- *Diseño de la Prueba:* Enviar una solicitud de reserva de tickets sobre una categoría de acceso restringido (`isAccessRestricted == true`) sin proporcionar un código de descuento/acceso correspondiente (`Optional.empty()`).
- *Ejecución / Código:* Se implementó la prueba `testCreateReservationForHiddenCategoryWithoutCodeThrowsMissingSpecialPriceTokenException` en #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/test/java/alfio/controller/api/v2/user/reservation/ReservationApiV2ControllerIntegrationTest.java")[ReservationApiV2ControllerIntegrationTest.java].
- *Código Clave (Prueba):*
```java
var hiddenCategory = ticketCategoryRepository.findAllTicketCategories(event.getId()).stream()
        .filter(TicketCategory::isAccessRestricted).findFirst().orElseThrow();

var tr = new TicketReservationModification();
tr.setQuantity(1);
tr.setTicketCategoryId(hiddenCategory.getId());
var mod = new TicketReservationWithOptionalCodeModification(tr, Optional.empty()); // Sin código de acceso

assertThrows(MissingSpecialPriceTokenException.class, () ->
        ticketReservationManager.createTicketReservation(
                event, Collections.singletonList(mod), Collections.emptyList(),
                DateUtils.addDays(new Date(), 1), Optional.empty(), Locale.ENGLISH, false, null)
);
```
- *Comportamiento Esperado:* Aunque el payload es correcto, #link("https://github.com/catarinas-ps-2026/alf.io/blob/test/integration/src/main/java/alfio/manager/TicketReservationManager.java")[TicketReservationManager.java] debe evaluar el estado semántico de la categoría mediante el método `fixToken()`. Al no encontrar un token válido de precio especial, debe lanzar `MissingSpecialPriceTokenException`.
- *Resultado Real:* El manager evaluó correctamente las reglas de negocio en `fixToken(...)`, denegando la transacción y lanzando la excepción esperada, lo cual bloquea la reserva.

=== Documentación de Discrepancias (Casos 1 y 2)
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
    [INC-02 (Semántico)], [Excepción MissingSpecialPriceTokenException al reservar categoría restringida sin código.], [Lanzó MissingSpecialPriceTokenException bloqueando la transacción.], [Exitoso]
  )
]

#block(
  fill: rgb("#f9f9fb"),
  inset: 12pt,
  radius: 6pt,
  stroke: 0.5pt + rgb("#e1e4e6"),
  width: 100%,
)[
  #set text(size: 8.5pt)
  *Resumen de la Sección (Alvaro):*
  Se integraron y validaron exitosamente los límites de control de la API pública de reservas en *alf.io* a nivel sintáctico y semántico:
  - *Frontera Sintáctica:* Controlada a través del controlador `ReservationApiV2Controller` que asegura que los campos de aceptación y del método de pago cumplan con el contrato, retornando un código de error de validación `HTTP 422`.
  - *Frontera Semántica:* Salvaguardada por el core de negocio en `TicketReservationManager` mediante `fixToken()`, el cual rechaza transacciones lógicas prohibidas (como acceder a categorías restringidas sin token) lanzando `MissingSpecialPriceTokenException`.
  Ambos flujos evitan escrituras inconsistentes en la base de datos PostgreSQL de pruebas controlada por *Testcontainers*.
]
