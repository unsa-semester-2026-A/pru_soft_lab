= SOLUCIÓN DEL CUESTIONARIO

== 1. Explique la diferencia entre una prueba funcional y una prueba no funcional. ¿Por qué las pruebas de rendimiento forman parte de las pruebas no funcionales?
Una *prueba funcional* verifica *qué hace* el sistema: valida que las funcionalidades se comporten conforme a los requisitos especificados (por ejemplo, que un formulario de login autentique correctamente a un usuario con credenciales válidas). Se enfoca en entradas, salidas y reglas de negocio.

Una *prueba no funcional*, en cambio, evalúa *cómo* el sistema realiza esas funciones: aspectos como velocidad, estabilidad, capacidad, seguridad, usabilidad o disponibilidad, sin importar si la lógica de negocio es correcta o no.

*¿Por qué las pruebas de rendimiento son no funcionales?*

Porque no verifican si una funcionalidad produce el resultado correcto, sino *bajo qué condiciones y con qué eficiencia* el sistema entrega ese resultado (tiempo de respuesta, capacidad de procesamiento, comportamiento bajo carga, uso de recursos). El sistema puede ser funcionalmente correcto y aun así fallar en rendimiento (por ejemplo, tardar 10 segundos en procesar una solicitud que debería tardar 200 ms). Por eso el rendimiento se clasifica dentro de los atributos de calidad no funcionales @browserstack2026funcional.

== 2. Describa las diferencias entre los siguientes tipos de pruebas de rendimiento: Load Testing, Stress Testing, Spike Testing, Endurance Testing. Mencione un escenario práctico para cada una.

Los cuatro tipos siguientes son subconjuntos de las pruebas de rendimiento y se diferencian principalmente por el patrón de carga que aplican y el objetivo que persiguen @browserstack2025rendimiento:

#table(
  columns: (1fr, 2.2fr, 2.3fr),
  inset: 8pt,
  align: left,
  stroke: 0.5pt,
  table.header([*Tipo*], [*Descripción*], [*Escenario práctico*]),
  [*Load Testing*],
  [Evalúa el comportamiento del sistema bajo una carga esperada (normal a alta), simulando el número de usuarios concurrentes previsto en producción.],
  [Simular 5,000 usuarios comprando simultáneamente en un e-commerce durante un día normal de operación.],

  [*Stress Testing*],
  [Somete al sistema a una carga que supera su capacidad máxima diseñada, con el fin de encontrar el punto de quiebre y observar cómo falla y se recupera.],
  [Aumentar progresivamente la carga hasta el doble de usuarios esperados para identificar en qué punto colapsa el servidor de una plataforma bancaria.],

  [*Spike Testing*],
  [Analiza la reacción del sistema ante incrementos súbitos y extremos de carga en periodos muy cortos de tiempo.],
  [Medir el comportamiento de un sitio de venta de entradas cuando se abren las ventas de un concierto y miles de usuarios ingresan en segundos.],

  [*Endurance Testing*],
  [(También llamado Soak Testing) Evalúa la estabilidad del sistema bajo carga sostenida durante un periodo prolongado, buscando fugas de memoria o degradación progresiva.],
  [Ejecutar una carga moderada constante durante 48 horas sobre un sistema de monitoreo para detectar fugas de memoria o caída gradual del rendimiento.],
)

== 3. Durante una prueba de rendimiento se obtuvieron los siguientes resultados:
== - Tiempo promedio de respuesta: 850 ms
== - Throughput: 180 solicitudes/segundo
== - Error Rate: 3%
== - Percentil 95: 1.8 segundos
== Interprete cada uno de estos indicadores y determine si el sistema presenta un desempeño aceptable. Justifique su respuesta.

*Datos obtenidos:*
- Tiempo promedio de respuesta: 850 ms
- Throughput: 180 solicitudes/segundo
- Error Rate: 3%
- Percentil 95 (P95): 1.8 segundos

*Interpretación:*

- *Tiempo promedio de respuesta (850 ms):* Es un valor moderadamente alto. Para aplicaciones web transaccionales se suele buscar un promedio menor a 500 ms; valores por encima de 1 segundo comienzan a afectar la experiencia del usuario. 850 ms está en una zona de alerta, aceptable solo si el tipo de operación es compleja (por ejemplo, reportes o procesos con lógica pesada).

- *Throughput (180 req/s):* Indica la capacidad de procesamiento del sistema. Por sí solo no es "bueno" ni "malo": debe compararse contra la carga esperada en producción. Si el objetivo del negocio requiere soportar, por ejemplo, 250 req/s en horas pico, este valor sería insuficiente.

- *Error Rate (3%):* Es un valor *elevado*. Los estándares habituales de la industria exigen una tasa de error inferior al 1% (idealmente cercana a 0% en operaciones críticas). Un 3% implica que 3 de cada 100 solicitudes están fallando, lo cual es una señal de inestabilidad, saturación de recursos o errores no controlados.

- *Percentil 95 (1.8 s):* Significa que el 95% de las solicitudes se respondieron en 1.8 segundos o menos, pero el 5% restante tardó más (posiblemente mucho más) @testrail2025metricas. La brecha entre el promedio (850 ms) y el P95 (1.8 s) es amplia, lo que sugiere *variabilidad* en el rendimiento y posibles cuellos de botella puntuales (picos de latencia).

El sistema *no presenta un desempeño aceptable* para un entorno de producción exigente. Aunque el throughput y el promedio podrían tolerarse dependiendo del contexto, la tasa de error del 3% supera los umbrales aceptables y la dispersión entre el promedio y el P95 evidencia inconsistencia en los tiempos de respuesta. Se recomienda investigar la causa raíz (saturación de conexiones, cuellos de botella en base de datos, falta de escalamiento horizontal, etc.) antes de considerar el sistema listo para producción.

== 4. Compare Apache JMeter y K6 considerando los siguientes aspectos:
== - facilidad de uso
== - automatización
== - escalabilidad
== - integración con CI/CD
== - generación de reportes
== - consumo de recursos.
== Indique en qué tipo de proyecto utilizaría cada herramienta.

La siguiente comparación se basa en las diferencias arquitectónicas y de uso reportadas entre ambas herramientas @pflb2026k6jmeter:

#table(
  columns: (1.3fr, 2fr, 2fr),
  inset: 8pt,
  align: left,
  stroke: 0.5pt,
  table.header([*Aspecto*], [*Apache JMeter*], [*K6*]),
  [Facilidad de uso],
  [Interfaz gráfica (GUI) que facilita la creación visual de pruebas, aunque puede volverse compleja en escenarios grandes.],
  [Basado en scripts JavaScript; requiere conocimientos de programación, pero resulta más limpio y mantenible para equipos técnicos.],

  [Automatización],
  [Se puede automatizar vía línea de comandos (modo no-GUI), aunque no fue diseñado nativamente para ese fin.],
  [Diseñado desde el inicio para automatización y ejecución por consola (CLI-first), ideal para pipelines automatizados.],

  [Escalabilidad],
  [Alta, pero requiere configuraciones adicionales (modo distribuido) para pruebas de gran volumen; consume más recursos por hilo.],
  [Muy escalable gracias a su arquitectura basada en Go, con menor consumo de memoria por usuario virtual simulado.],

  [Integración con CI/CD],
  [Posible mediante plugins (Jenkins, Maven, Taurus), pero con configuración adicional.],
  [Integración nativa y sencilla con herramientas como Jenkins, GitLab CI, GitHub Actions.],

  [Generación de reportes],
  [Reportes HTML robustos y detallados mediante plugins y dashboards integrados.],
  [Reportes más simples por defecto, pero se integra fácilmente con Grafana e InfluxDB para dashboards avanzados.],

  [Consumo de recursos],
  [Mayor consumo de CPU/memoria, especialmente con muchos hilos (modelo basado en threads de Java).],
  [Más eficiente en el uso de recursos (modelo basado en goroutines), permite simular más usuarios virtuales con menos hardware.],
)

*¿Cuándo usar cada herramienta?*

- *Apache JMeter:* recomendable en proyectos donde el equipo de QA no tiene fuerte perfil de programación, se requieren protocolos diversos (HTTP, FTP, JDBC, SOAP, etc.) o ya existe una infraestructura basada en Java/plugins.
- *K6:* recomendable en proyectos con cultura DevOps/CI-CD, equipos con conocimientos de JavaScript, y donde se requiera eficiencia de recursos y pruebas de rendimiento como parte del pipeline de integración continua.

== 5. Durante las pruebas básicas de seguridad se detectaron las siguientes situaciones:
== - acceso a recursos inexistentes
== - envío de parámetros inválidos
== - métodos HTTP no permitidos
== - intentos repetitivos de autenticación.
== Explique cómo deberían responder las aplicaciones modernas ante cada uno de estos escenarios y qué códigos HTTP deberían devolverse.

Los códigos de estado HTTP recomendados para cada escenario se basan en las convenciones estándar de diseño de APIs REST @postman2025httpstatus:

#table(
  columns: (1.6fr, 2.6fr, 1fr),
  inset: 8pt,
  align: left,
  stroke: 0.5pt,
  table.header([*Escenario*], [*Comportamiento esperado*], [*Código HTTP*]),
  [Acceso a recursos inexistentes],
  [La aplicación debe indicar de forma clara que el recurso solicitado no existe, sin revelar información sensible sobre la estructura interna del sistema.],
  [`404 Not Found`],

  [Envío de parámetros inválidos],
  [Debe validarse la entrada en el backend (no solo en el cliente) y rechazar la solicitud con un mensaje de error controlado, evitando excepciones no manejadas o fugas de stack trace.],
  [`400 Bad Request`],

  [Métodos HTTP no permitidos],
  [Si un endpoint solo acepta ciertos verbos (por ejemplo, GET) y se recibe otro (por ejemplo, DELETE), debe rechazarse explícitamente sin ejecutar ninguna acción.],
  [`405 Method Not Allowed`],

  [Intentos repetitivos de autenticación],
  [Debe implementarse control de fuerza bruta: bloqueo temporal de la cuenta o IP, CAPTCHA progresivo, y limitación de tasa (rate limiting). Tras varios intentos fallidos, las credenciales inválidas deben rechazarse sin dar pistas sobre cuál campo fue incorrecto.],
  [`401 Unauthorized` (intentos fallidos) / `429 Too Many Requests` (tras exceder el límite)],
)

*Principio general:* en todos los casos, las aplicaciones modernas deben seguir el principio de *fallar de forma segura* (fail securely): responder con códigos HTTP estándar y mensajes genéricos que no expongan detalles internos (rutas del servidor, versiones de framework, trazas de error), delegando el registro detallado del incidente a logs internos accesibles solo para el equipo técnico.