=== Ejercicio 1: Desarrollo de una API REST para Pruebas de Rendimiento

*Descripción de la actividad:*
Se implementó una API REST de alto rendimiento denominada *TicketPass*, orientada a la gestión y venta de entradas para conciertos y eventos masivos. La arquitectura combina el desarrollo backend en Python utilizando *Flask*, *Gunicorn* como servidor WSGI de producción, *Redis* para el procesamiento atómico de reservas y control de inventario con vencimiento temporal (TTL), y *PostgreSQL* como motor de persistencia relacional para la confirmación de compras y registro de asistentes.

==== Arquitectura y Estructura del Sistema
La solución se encuentra modularizada bajo el patrón de arquitectura limpia y fábrica de aplicaciones (*Application Factory*), permitiendo separar las capas de transporte REST, lógica de negocio y persistencia de datos:

#align(center)[
  #table(
    columns: (1.5fr, 1.5fr, 2fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Componente],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Tecnología / Servicio],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Responsabilidad en las Pruebas],
    
    [API REST Backend], [Flask 3.0 + Gunicorn], [Exposición de endpoints HTTP en el puerto 5000.],
    [Cache & Stock], [Redis 7 (Alpine)], [Operaciones atómicas DECRBY, colas FIFO y reservas con TTL 180s.],
    [Persistencia Relacional], [PostgreSQL 16], [Almacenamiento persistente de compras y asistentes.],
    [Frontend UI], [Astro 4.0 + Nginx], [Interfaz web de usuario atendida en el puerto 4322.]
  )
]

==== Definición de Endpoints Evaluados
A continuación se especifican los servicios REST expuestos por la API que fueron sometidos a las pruebas de carga, rendimiento y seguridad:

- `GET /health`: Estado y disponibilidad del servicio.
- `GET /api/v1/eventos`: Consulta del catálogo de eventos activos y disponibilidad de stock en Redis.
- `POST /api/v1/compras/reservar`: Reserva temporal de entradas con reducción atómica de stock mediante `DECRBY`.
- `POST /api/v1/compras/confirmar`: Confirmación y persistencia de la compra en PostgreSQL verificando la validez del TTL.

==== Verificación de Despliegue e Inicialización
Se levantó la infraestructura completa en contenedores mediante Docker Compose y se ejecutó la siembra inicial de datos (*seed*), creando 5 eventos masivos en Redis y registros en PostgreSQL:

#figure(
  image("../src/fig/dockerps.png", width: 85%),
  caption: [Estado de los contenedores Docker en ejecución para la API TicketPass.]
)

#figure(
  image("../src/fig/docker_compose1.png", width: 85%),
  caption: [Despliegue y construcción de servicios mediante Docker Compose.]
)

#figure(
  image("../src/fig/seed_succes.png", width: 85%),
  caption: [Ejecución exitosa del script de siembra de datos (`seed.py`) en Redis y PostgreSQL.]
)

#figure(
  image("../src/fig/seed_succes_in_web_view.png", width: 85%),
  caption: [Visualización de los eventos sembrados en la interfaz web de TicketPass.]
)

#figure(
  image("../src/fig/05-client.png", width: 85%),
  caption: [Ejecución exitosa del Smoke Test preliminar en Python (`cliente.py`).]
)

#figure(
  image("../src/fig/07-k6init.png", width: 85%),
  caption: [Inicialización de la suite de pruebas de carga en K6.]
)
