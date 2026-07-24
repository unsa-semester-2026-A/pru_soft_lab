= CUESTIONARIO

== Pregunta 1: Pruebas Funcionales vs. Pruebas No Funcionales
- Pruebas Funcionales: Evalúan qué hace el sistema (cumplimiento de requisitos lógicos y resultados esperados).
- Pruebas No Funcionales: Evalúan cómo opera el sistema (atributos de calidad como velocidad, estabilidad, escalabilidad y consumo de recursos).

Justificación: Las pruebas de rendimiento son no funcionales porque miden tiempos de respuesta, throughput y comportamiento del servidor bajo carga, en lugar de verificar la lógica de negocio individual.

== Pregunta 2: Tipos de Pruebas de Rendimiento
- Load Testing (Carga): Mide el desempeño bajo carga normal esperada (ej. 500 usuarios simultáneos en e-commerce).
- Stress Testing (Estrés): Evalúa el comportamiento al sobrepasar la capacidad máxima hasta hallar el punto de fallo (ej. subir de 1,000 a 10,000 usuarios hasta saturar la base de datos).
- Spike Testing (Picos): Analiza la reacción ante ráfagas súbitas e instantáneas de tráfico (ej. 5,000 accesos repentinos al abrir un proceso de matrícula).
- Endurance Testing (Resistencia/Soak): Mantiene carga constante durante periodos prolongados para detectar fugas de memoria o degradación (ej. 200 VUs durante 24 horas continuas).

== Pregunta 3: Interpretación de Indicadores de Rendimiento
- Tiempo Promedio (850 ms): Aceptable pero cercano al límite razonable (1s).
- Throughput (180 req/s): Elevada capacidad de procesamiento.
- Error Rate (3%): Inaceptable para producción (> 0.1%).
- Percentil 95 (P_95 = 1.8 "s"): Deficiente; el 5% de las peticiones sufren alta latencia.

Dictamen: El desempeño NO es aceptable. La tasa de error del 3% y el P_95 de 1.8 segundos indican inestabilidad en la experiencia de usuario.

== Pregunta 4: Comparación entre Apache JMeter y K6
- JMeter: Basado en Java con GUI intuitiva. Alto consumo de recursos (un hilo JVM por VU). Ideal para sistemas legacy y protocolos heterogéneos (SOAP, JDBC).
- K6: Basado en Go/JavaScript mediante código CLI. Muy bajo consumo de recursos y alta escalabilidad. Ideal para APIs REST modernas, microservicios y pipelines CI/CD (DevOps).

== Pregunta 5: Respuestas y Códigos HTTP ante Situaciones de Seguridad
1. Recursos Inexistentes: Devolver HTTP 404 Not Found con JSON descriptivo sin stacktraces.
2. Parámetros Inválidos: Devolver HTTP 400 Bad Request o 422 Unprocessable Entity indicando la falla de validación.
3. Métodos No Permitidos: Devolver HTTP 405 Method Not Allowed con cabecera Allow.
4. Ataques de Fuerza Bruta: Devolver HTTP 429 Too Many Requests (o 401 Unauthorized) aplicando rate limiting y bloqueo temporal por IP.
