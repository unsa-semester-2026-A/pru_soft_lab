= SOLUCIÓN DE EJERCICIOS/PROBLEMAS

#include "ejercicio1_leo.typ"
== Ejercicio 2: Pruebas de Integración del Proyecto Final

*Descripción de la actividad:*
Aplicar pruebas de integración sobre la arquitectura del proyecto final (*alf.io*). Se validará el flujo de datos entre la API (Capa de Presentación) y la lógica de negocio/base de datos. 
*Herramienta sugerida:* Postman o la suite nativa del proyecto (`MockMvc` / `TestRestTemplate`).

=== Resumen de Casos de Integración Evaluados
A continuación, se presenta un resumen consolidado de las pruebas de integración ejecutadas para analizar la robustez y los límites de control en la frontera del sistema:

#align(center)[
  #set par(justify: false)
  #table(
    columns: (1.2fr, 2fr, 2fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Nivel / Frontera],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); ¿Qué se hizo? (Acción)],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); ¿Qué se encontró / Validó? (Resultado)],
    
    [Sintáctica (Caso 1)], [Inyección de payload incompleto (términos no aceptados) en `confirmOverview`.], [El controlador interceptó los datos y retornó HTTP 422 (Unprocessable Entity), cancelando el flujo.],
    [Semántica (Caso 2)], [Intento de reserva de categoría restringida (`hidden`) sin código de acceso especial.], [El `TicketReservationManager` abortó la creación lanzando `MissingSpecialPriceTokenException` de forma segura.],
    [Resiliencia (Caso 3)], [Simulación de timeout y alta latencia en webhook de Stripe (pago externo).], [La reserva se mantuvo bloqueada de forma segura y liberó los tickets al expirar el timeout.]
  )
]

#include "ejercicio2_alisson.typ"
#include "ejercicio2_alvaro.typ"
