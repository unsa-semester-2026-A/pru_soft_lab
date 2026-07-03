= SOLUCIÓN DEL CUESTIONARIO

== 1. ¿Por qué las pruebas unitarias exitosas no garantizan que la integración será exitosa?

Las pruebas unitarias se enfocan en verificar el comportamiento aislado de cada módulo o clase, utilizando a menudo stubs o mocks para simular las dependencias. Sin embargo, no validan la comunicación entre los componentes reales. Problemas como inconsistencias en los tipos de datos de las interfaces de comunicación, errores de configuración, efectos secundarios no deseados en la base de datos, problemas de concurrencia y fallas en la sincronización de protocolos (como diferencias en latencias o manejo de timeouts) solo se manifiestan cuando los módulos interactúan entre sí. Por lo tanto, el éxito unitario no asegura la compatibilidad operativa de la integración.

== 2. Explique la diferencia entre un Stub y un Driver y proporcione un ejemplo de cuándo usó uno de ellos en su proyecto.

- *Stub (Cabo/Taco):* Es un componente de simulación pasivo utilizado en pruebas de integración descendente (top-down). Reemplaza a un módulo de bajo nivel que aún no ha sido desarrollado o integrado, respondiendo a las llamadas del módulo superior con datos predefinidos.
- *Driver (Controlador):* Es un componente activo utilizado en pruebas de integración ascendente (bottom-up). Simula el comportamiento del módulo superior (llamador), invocando los métodos o endpoints del módulo inferior bajo prueba para enviarle datos de entrada y verificar su comportamiento.

*Ejemplo:* En el proyecto final (*alf.io*), se usó un *Stub* (a través de mocks de simulación) para emular las respuestas de la pasarela de pago externa (Stripe) al procesar la confirmación de pago. Esto permitió verificar que el controlador de la aplicación reacciona de forma adecuada a los códigos de respuesta del webhook de Stripe sin realizar llamadas de red reales a la infraestructura externa.

== 3. Según Myers, ¿por qué es arriesgado que el mismo desarrollador que escribió el código de los módulos diseñe también las pruebas de integración?

Según Myers, los desarrolladores sufren de "ceguera ante los propios errores" (self-blindness). El desarrollador diseña e implementa el código basándose en su propia interpretación de los requisitos y especificaciones. Si comete un error de interpretación o asunción al programar, es sumamente probable que repita el mismo error conceptual al diseñar los casos de prueba de integración. Además, existe un sesgo cognitivo subconsciente que evita que el programador intente "romper" activamente su propio software, inclinando las pruebas hacia la verificación de caminos exitosos (happy paths) en lugar de escenarios límite, de error y de robustez extrema.

== 4. Defina "Integración Incremental" y explique por qué el enfoque "Big Bang" debe evitarse en proyectos complejos.

- *Integración Incremental:* Es una estrategia donde el sistema se ensambla y prueba paso a paso, añadiendo un módulo (o un pequeño conjunto de módulos) a la vez a la estructura ya probada (ya sea de arriba hacia abajo, de abajo hacia arriba o sándwich).
- *Enfoque Big Bang:* Consiste en desarrollar todos los módulos de manera independiente e intentar integrarlos todos de golpe en una sola fase de pruebas final.

*Por qué debe evitarse:* En proyectos complejos, el enfoque Big Bang dificulta drásticamente la localización y depuración de fallas (debugging). Si ocurre un fallo, es extremadamente complejo determinar cuál de las múltiples interfaces recién conectadas o cuál de los componentes causó el problema debido al efecto enmascarador y la propagación de errores. La integración incremental, en cambio, aísla el origen de los fallos al módulo recién incorporado y reduce el retrabajo.

== 5. ¿Cómo ayuda la herramienta seleccionada por su grupo a detectar "defectos enmascarados" entre sus subsistemas?

La herramienta utilizada (Supertest combinada con Jest y el contexto de pruebas de Spring de alf.io con Testcontainers) ayuda a detectar "defectos enmascarados" (defectos donde una falla en un componente oculta o compensa otra falla en otro componente) mediante la automatización de aserciones precisas en múltiples capas del flujo de datos de integración. Por ejemplo, al enviar payloads malformados o inválidos en las pruebas de API REST, Supertest captura con precisión la respuesta exacta HTTP a nivel de controlador, permitiendo verificar si la excepción fue capturada por la validación sintáctica de la interfaz o si se propagó y fue enmascarada como un error genérico del sistema. De igual forma, el aislamiento de la base de datos mediante Testcontainers asegura que no existan datos previos residuales que enmascaren comportamientos incorrectos en la lógica de negocio durante pruebas consecutivas.
