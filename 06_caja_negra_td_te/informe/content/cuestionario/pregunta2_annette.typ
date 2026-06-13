// ==========================================
// CUESTIONARIO - PREGUNTA 2
// Responsable: Annette
// Tema: Transición de Estados en Microservicios
// ==========================================
#set par(justify: true, leading: 0.65em, first-line-indent: 1.5em)

== Transición de Estados en Microservicios

=== Modelado y Prueba de Estados en Arquitecturas Asíncronas (Eventual Consistency)

En una arquitectura de microservicios, la transición `[Pendiente] → [Pagado]` no ocurre de forma atómica. El estado puede pasar por fases intermedias manejadas por distintos servicios (servicio de pagos, servicio de notificaciones, servicio de inventario) que se comunican a través de colas de mensajes o eventos.

El *Event Sourcing* captura cada cambio en el estado de una aplicación como una secuencia de eventos inmutables. En lugar de actualizar filas en una base de datos, cada acción ---como `OrderPlaced` o `PaymentReceived`--- se registra en un _event store_. El estado actual de un servicio puede reconstruirse reproduciendo todos los eventos relevantes en el orden correcto @architectureway2025eventual.

Para modelar correctamente esto, los equipos deben crear representaciones visuales de todos los estados posibles para cada microservicio y las transiciones válidas entre ellos. Las tablas de transición pueden automatizarse para mejorar la eficiencia y consistencia de las pruebas @faun2026statetransition.

El reto clave es que en sistemas orientados a eventos, las pruebas deben validar resultados observables dentro de límites de tiempo esperados, en lugar de asumir consistencia inmediata. Los IDs de correlación deben conectar el disparador original con los efectos secundarios aguas abajo, para que los fallos relacionados con el tiempo sean comprensibles @thinksys2026microservices.

=== Estrategias para Evitar Falsos Positivos en Pruebas Asíncronas

Los falsos positivos ocurren cuando una prueba falla simplemente porque el sistema aún está procesando el cambio de estado en segundo plano. Las estrategias clave son:

*1. Polling con timeout inteligente:* Los scripts de prueba deben ser resilientes a pequeños retrasos. Si una acción del usuario dispara un servicio de email, la prueba no debería fallar inmediatamente si el email no llegó al instante ---en cambio, debe hacer _polling_ a una API o base de datos hasta un timeout razonable. Sin embargo, hay que evitar simplemente aumentar los tiempos de espera para enmascarar condiciones de carrera @bunnyshell2026e2e.

*2. Observabilidad y logging detallado:* Se debe solicitar a los desarrolladores que implementen logging detallado alrededor del servicio y las actualizaciones de datos para rastrear la secuencia de eventos. Esto ayuda a identificar el punto exacto de fallo cuando surgen problemas @dev2025microservices.

*3. Datos deterministas sobre datos reales:* Los datos de producción pueden hacer que un sistema se vea realista, pero los datos deterministas lo hacen testeable. Si las pruebas pasan localmente pero fallan en CI, fallan una vez y pasan al rerun, o dependen del orden de ejecución, el problema generalmente no es el caso de prueba en sí, sino una estrategia débil de configuración o aislamiento de datos @thinksys2026microservices.

*4. Contract Testing:* Validar que cada microservicio cumple con el contrato de mensajes que los demás esperan, independientemente del timing. Herramientas como _Pact_ permiten definir estos contratos y verificarlos en pipelines de CI/CD.