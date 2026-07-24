=== Ejercicio 2: Pruebas de Rendimiento con Apache JMeter

*Descripción de la actividad:*
Se diseñó y ejecutó un Plan de Pruebas de Carga en Apache JMeter (`jmeter_test_plan.jmx`) configurado con hilos virtuales (*Thread Group*), administradores de cabeceras HTTP y receptores de métricas (*Summary Report*, *Aggregate Report*, *View Results Tree*). El objetivo consistió en evaluar la respuesta del servidor bajo tres niveles progresivos de concurrencia.

==== Escenario 1: Carga Baja (20 Usuarios Concurrentes)
- *Configuración del Plan de Pruebas:* Se definieron 20 hilos virtuales (*threads*) con un tiempo de Ramp-Up de 10 segundos y un contador de bucles de 5 iteraciones. Se enviaron 100 peticiones para `HTTP Request - List Events (GET)` y 100 peticiones para `HTTP Request - Reserve Ticket (POST)`, sumando un total de 200 muestras.

#figure(
  image("../src/fig/11.png", width: 85%),
  caption: [Estructura y configuración del Thread Group para 20 usuarios en Apache JMeter.]
)

#figure(
  image("../src/fig/12.png", width: 85%),
  caption: [Summary Report de Apache JMeter para el Escenario 1 (20 usuarios).]
)

*Análisis Directo de Resultados del Escenario 1:*
- *Tiempos de Respuesta:* Ambas peticiones registraron tiempos de respuesta promedio sumamente bajos: `9 ms` para `List Events (GET)` y `4 ms` para `Reserve Ticket (POST)`, alcanzando un promedio global de `6 ms` con un tiempo máximo de `100 ms`. Esta velocidad responde al procesamiento en memoria atómico de Redis.
- *Tasa de Error y Comportamiento:* La petición `List Events (GET)` registró `0.00%` de error con un throughput de `10.6 req/s`. La petición `Reserve Ticket (POST)` presentó un `40.00%` de error, lo que elevó el error global del escenario al `20.00%`. Este comportamiento responde al consumo acelerado del stock inicial sembrado en Redis; al agotarse las entradas disponibles, la API rechaza legítimamente las compras adicionales mediante respuestas `HTTP 409 (Stock insuficiente)`.

==== Escenario 2: Carga Media (50 Usuarios Concurrentes)
- *Configuración del Plan de Pruebas:* Se incrementó la concurrencia a 50 hilos virtuales con un Ramp-Up de 20 segundos y 10 iteraciones, procesando un total de 1,200 muestras (600 peticiones GET y 600 peticiones POST) en un tiempo total de ejecución de 19 segundos.

#figure(
  image("../src/fig/13.png", width: 85%),
  caption: [Configuración del Thread Group para 50 usuarios concurrentes en JMeter.]
)

#figure(
  image("../src/fig/14.png", width: 85%),
  caption: [Summary Report de Apache JMeter para el Escenario 2 (50 usuarios).]
)

*Análisis Directo de Resultados del Escenario 2:*
- *Estabilidad de Tiempos:* `List Events (GET)` mantuvo un tiempo promedio de `7 ms` (mínimo `4 ms`, máximo `100 ms`, desviación estándar `5.22 ms`). `Reserve Ticket (POST)` promedió `3 ms` (mínimo `2 ms`, máximo `47 ms`, desviación estándar `3.03 ms`). El tiempo promedio general se redujo a `5 ms`.
- *Throughput y Tráfico de Red:* Se alcanzó un Throughput combinado de `5.0 req/s` con un consumo de red de `7.95 KB/s` recibidos y `1.30 KB/s` enviados. La consulta de eventos se mantuvo en `0.00%` de error, mientras que las reservas registraron un `40.00%` de rechazo debido a la saturación del inventario.

==== Escenario 3: Carga Alta / Estrés (100 Usuarios Concurrentes)
- *Configuración del Plan de Pruebas:* Se evaluó la capacidad de estrés del servidor con 100 hilos virtuales, un Ramp-Up de 30 segundos y 15 iteraciones (totalizando 1,200 muestras procesadas).

#figure(
  image("../src/fig/15.png", width: 85%),
  caption: [Configuración del Thread Group para 100 usuarios en Apache JMeter.]
)

#figure(
  image("../src/fig/16.png", width: 85%),
  caption: [Summary Report de Apache JMeter para el Escenario 3 (100 usuarios).]
)

*Análisis Directo de Resultados del Escenario 3:*
- *Respuesta del Servidor bajo Estrés:* A pesar de duplicar la cantidad de hilos concurrentes a 100, la API mantuvo su estabilidad de latencia en `5 ms` promedio (7 ms en GET y 3 ms en POST). No se observaron caídas del servidor de aplicaciones WSGI ni errores `HTTP 500`.

==== Consolidado de Resultados en Apache JMeter

#align(center)[
  #table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1.2fr, 1fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Escenario],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Muestras],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Prom (ms)],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Mín (ms)],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Máx (ms)],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Std. Dev.],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Throughput],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Error %],
    
    [20 Usuarios], [200], [6 ms], [2 ms], [100 ms], [8.79 ms], [21.2 / sec], [20.00%],
    [50 Usuarios], [1200], [5 ms], [2 ms], [100 ms], [4.68 ms], [5.0 / sec], [20.00%],
    [100 Usuarios], [1200], [5 ms], [2 ms], [100 ms], [4.68 ms], [5.0 / sec], [20.00%]
  )
]
