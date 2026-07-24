=== Análisis de Resultados

Con base en las métricas empíricas recolectadas durante la ejecución de las pruebas de rendimiento con Apache JMeter, K6 y la suite de seguridad en Python, se responde detalladamente a las preguntas de evaluación del laboratorio:

1. *Pregunta 1: Tiempo promedio de respuesta en cada escenario*
   - *Apache JMeter:*
     - Escenario 1 (20 usuarios): `6 ms` promedio general (9 ms en GET, 4 ms en POST).
     - Escenario 2 (50 usuarios): `5 ms` promedio general (7 ms en GET, 3 ms en POST).
     - Escenario 3 (100 usuarios): `5 ms` promedio general (7 ms en GET, 3 ms en POST).
   - *K6 (Grafana Labs):*
     - Escenario A (20 VUs / 30s): `10.08 ms` promedio general ($P_95 = 41.08 "ms"$).
     - Escenario B (50 VUs / 45s): `19.27 ms` promedio general ($P_95 = 66.32 "ms"$).
     - Escenario C (100 VUs / 60s): `17.94 ms` promedio general ($P_95 = 58.26 "ms"$).
   - *Conclusión:* En todos los escenarios, la API respondió significativamente por debajo del umbral de tolerancia de $500 "ms"$, catalogándose como de rendimiento *Excelente*.

2. *Pregunta 2: Comparativa de Throughput (JMeter vs K6)*
   - *K6 presentó un Throughput sustancialmente mayor* que Apache JMeter. En el Escenario C de 100 usuarios virtuales, K6 alcanzó un rendimiento máximo de *128.55 peticiones por segundo (RPS)* (procesando 7,910 solicitudes HTTP en 60 segundos), mientras que JMeter registró 21.2 RPS en su pico debido a la sobrecarga de sincronización de hilos Java por usuario en el entorno de pruebas.

3. *Pregunta 3: Punto de aparición de errores de respuesta*
   - Los errores de respuesta *no surgieron por fallas de servidor (500) o degradación de infraestructura*, sino por la *saturación lógica del stock de entradas* en Redis:
     - En K6 Escenario A (20 VUs), los errores en reservas aparecieron a partir de la solicitud 301 (al agotarse las 300 entradas de la zona).
     - En K6 Escenario B (50 VUs), se procesaron 1,236 compras exitosas antes de agotar el inventario total disponible y rechazar las 264 peticiones restantes con `HTTP 409`.
     - En JMeter, las solicitudes POST registraron un 40.00% de rechazo por consumo acelerado del stock sembrado en Redis.

4. *Pregunta 4: Identificación del cuello de botella en la infraestructura*
   - *El servidor de aplicación Flask (Gunicorn WSGI) e hilos sintéticos:* Aunque la capa de almacenamiento en memoria Redis respondió con latencias extremadamente reducidas ($< 5 "ms"$), el modelo sincrónico de Workers en Flask/Gunicorn constituye el cuello de botella cuando la concurrencia supera las 100 VUs simultáneas sin balanceador de carga.

5. *Pregunta 5: Recomendaciones para optimizar Rendimiento y Seguridad*
   - *Rendimiento:*
     - *Horizontal Pod Autoscaling (HPA):* Desplegar múltiples réplicas de la API Flask detrás de un balanceador de carga (Nginx / HAProxy).
     - *Redis Cluster:* Distribuir las claves de stock entre múltiples nodos Redis Sharded para evitar la contención sobre una sola instancia.
     - *Conexiones Asíncronas:* Implementar frameworks asíncronos como FastAPI o Quart para manejar E/S sin bloquear hilos.
   - *Seguridad:*
     - *Rate Limiting Estricto (Flask-Limiter / Redis Rate Limiter):* Limitar el número de reservas por dirección IP (ej. máximo 5 peticiones por minuto) devolviendo `HTTP 429 Too Many Requests`.
     - *Autenticación JWT:* Requerir tokens Bearer autenticados en los endpoints de reserva y administración para mitigar ataques de *Credential Stuffing*.
