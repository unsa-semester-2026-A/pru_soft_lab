== EJERCICIO RESUELTO POR EL DOCENTE

=== Desarrollo y Pruebas de Rendimiento de una API REST en Python utilizando Flask

==== Implementación de la API REST

En esta sección se analiza la API REST desarrollada durante la sesión guiada utilizando el framework Flask de Python para la administración de un catálogo básico de productos.

Para el desarrollo se configuró un entorno virtual en Python, donde se instalaron las dependencias necesarias:

- *Flask*: utilizado para la creación del servidor REST.
- *Requests*: utilizado para realizar pruebas de consumo de la API mediante Python.

La API fue implementada en el archivo `app.py`, donde se definieron los endpoints necesarios para realizar operaciones CRUD sobre los productos:

- `GET /productos`: permite obtener la lista completa de productos.
- `POST /productos`: permite registrar nuevos productos.
- `GET /productos/{id}`: permite consultar un producto específico.
- `PUT /productos/{id}`: permite actualizar información de un producto.
- `DELETE /productos/{id}`: permite eliminar un producto.

La información inicial utilizada para las pruebas fue:

```json
[
 {
  "id": 1,
  "nombre": "Laptop",
  "precio": 3500
 },
 {
  "id": 2,
  "nombre": "Mouse",
  "precio": 90
 },
 {
  "id": 3,
  "nombre": "Teclado",
  "precio": 180
 }
]
```

==== Ejecución y Validación del Servicio REST

Luego de implementar la API, se inició el servidor Flask mediante `python app.py` en `http://localhost:5000`. La respuesta obtenida confirmó que la API funcionaba correctamente:

#figure(
  image("../src/fig/ejercicior/Postman.jpg", width: 80%),
  caption: [Consulta al endpoint /productos desde Postman.]
)

==== Prueba Inicial mediante Python Requests

Antes de realizar las pruebas de carga, se realizó una prueba básica utilizando la librería Requests de Python (`cliente.py`).

#figure(
  image("../src/fig/ejercicior/cliente.jpg", width: 80%),
  caption: [Ejecución del cliente cliente.py en Python.]
)

==== Pruebas de Rendimiento utilizando Apache JMeter

Se realizaron pruebas de carga en Apache JMeter sobre `GET /productos` configurando hilos virtuales en tres escenarios:

#align(center)[
  #table(
    columns: (1fr, 1fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Escenario],
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Usuarios],
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Ramp-Up],
    
    [Escenario 1], [20], [10 segundos],
    [Escenario 2], [50], [20 segundos],
    [Escenario 3], [100], [30 segundos]
  )
]

#figure(
  image("../src/fig/ejercicior/jmeter1.jpg", width: 80%),
  caption: [Summary Report de JMeter en el ejercicio docente.]
)

#figure(
  image("../src/fig/ejercicior/jmeter2.jpg", width: 80%),
  caption: [Graph Results de JMeter en el ejercicio docente.]
)

==== Pruebas de Rendimiento utilizando K6

Se ejecutaron pruebas automatizadas en K6 sobre `http://localhost:5000/productos` evaluando tres escenarios:

===== Resultados Obtenidos con K6

*Escenario A (20 VUs / 30s):* Tiempo promedio de 2.34 ms, 600 solicitudes, 19.91 req/s, 0% errores.

#figure(
  image("../src/fig/ejercicior/k61.jpg", width: 80%),
  caption: [Resultado de K6 para el Escenario A (20 VUs).]
)

*Escenario B (50 VUs / 45s):* Tiempo promedio de 2.85 ms, 2,250 solicitudes, 49.74 req/s, 0% errores.

#figure(
  image("../src/fig/ejercicior/k62.jpg", width: 80%),
  caption: [Resultado de K6 para el Escenario B (50 VUs).]
)

*Escenario C (100 VUs / 60s):* Tiempo promedio de 4.26 ms, 6,000 solicitudes, 99.11 req/s, 0% errores.

#figure(
  image("../src/fig/ejercicior/k63.jpg", width: 80%),
  caption: [Resultado de K6 para el Escenario C (100 VUs).]
)

==== Tabla de Resultados Consolidados del Ejercicio Docente

#align(center)[
  #table(
    columns: (1fr, 1.2fr, 1.2fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Usuarios],
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Tiempo Promedio (ms)],
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Throughput],
    table.cell(inset: 0.5em)[#set text(fill: white, weight: "bold"); Error %],
    
    [20 VUs], [2.34 ms], [19.91 req/s], [0%],
    [50 VUs], [2.85 ms], [49.74 req/s], [0%],
    [100 VUs], [4.26 ms], [99.11 req/s], [0%]
  )
]
