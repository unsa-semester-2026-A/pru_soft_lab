= CONCLUSIONES

1. Se logró diseñar e implementar una arquitectura de prueba de alto rendimiento para la API REST *TicketPass*, validando experimentalmente que el almacenamiento y decremento atómico de stock en Redis (`DECRBY`) permite procesar más de 128 peticiones por segundo con latencias inferiores a $60 "ms"$ ($P_95$), garantizando la consistencia de inventario sin sobreventa (*no overbooking*).

2. La evaluación comparativa entre Apache JMeter y K6 demostró la superioridad de K6 en entornos DevOps y pipelines CI/CD debido a su motor asíncrono liviano en Go/JavaScript, alcanzando un throughput significativamente mayor y reduciendo el consumo de memoria en comparación con el modelo multitarea basado en hilos JVM de JMeter.

3. Las pruebas de seguridad mediante Python confirmaron la robustez de la API REST desarrollada, la cual respondió con códigos HTTP estandarizados (`404`, `400`, `405`) y mantuvo la resiliencia ante ataques de fuerza bruta y ráfagas de solicitudes concurrentes, protegiendo las trazas de error internas y asegurando la disponibilidad del servicio.
