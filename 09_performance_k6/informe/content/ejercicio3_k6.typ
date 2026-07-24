=== Ejercicio 3: Pruebas de Rendimiento utilizando K6

*Descripción de la actividad:*
Se implementó y ejecutó un script de pruebas de carga en K6 (`k6_test.js`) escrito en JavaScript asíncrono. K6 evalúa la API emulando usuarios virtuales (VUs) en tiempo real, midiendo iteraciones, latencias en percentiles ($P_90$, $P_95$), throughput en peticiones por segundo (RPS) y tasa de fallos HTTP.

==== Código del Script K6 (`k6_test.js`)

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,
  duration: '30s',
  thresholds: {
    http_req_failed: ['rate<0.05'],
    http_req_duration: ['p(95)<1500'],
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:5000';
const EVENT_IDS = ['conc-001', 'conc-002', 'conc-003', 'conc-004', 'conc-005'];
const ZONE_IDS = ['vip', 'pref', 'gen'];

function getRandomElement(array) {
  return array[Math.floor(Math.random() * array.length)];
}

export default function () {
  const eventsResponse = http.get(`${BASE_URL}/api/v1/eventos`);
  check(eventsResponse, {
    'GET /eventos status is 200': (r) => r.status === 200,
    'GET /eventos duration < 500ms': (r) => r.timings.duration < 500,
  });

  sleep(0.5);

  const selectedEvent = getRandomElement(EVENT_IDS);
  const selectedZone = getRandomElement(ZONE_IDS);
  const randomDni = Math.floor(10000000 + Math.random() * 90000000).toString();

  const reservationPayload = JSON.stringify({
    evento_id: selectedEvent,
    zona_id: selectedZone,
    cantidad: 1,
    nombre_comprador: 'Load Tester User',
    email_comprador: 'k6tester@example.com',
    dni_comprador: randomDni,
  });

  const reservationResponse = http.post(
    `${BASE_URL}/api/v1/compras/reservar`,
    reservationPayload,
    { headers: { 'Content-Type': 'application/json' } }
  );

  check(reservationResponse, {
    'POST /compras/reservar status is 200/201': (r) => r.status === 200 || r.status === 201,
  });

  sleep(1);
}
```

==== Escenarios de Carga Ejecutados en K6

===== Escenario A: 20 VUs por 30 segundos
- *Resultados de Ejecución:* Se completaron 400 iteraciones en 30.5 segundos (800 peticiones HTTP). Se registraron 300 reservas POST procesadas exitosamente antes de agotar el stock inicial de la zona sembrada, alcanzando un 75% de éxito en el endpoint POST.

#figure(
  image("../src/fig/08-k6 results.png", width: 85%),
  caption: [Reporte de consola K6 para el Escenario A (20 usuarios virtuales).]
)

===== Escenario B: 50 VUs por 45 segundos
- *Resultados de Ejecución:* Se ejecutaron 1,500 iteraciones completas en 45.8 segundos (3,000 peticiones HTTP en total). Se evaluaron 4,500 verificaciones (*checks*), alcanzando un 94.13% de éxito global (4,236 aprobadas).

#figure(
  image("../src/fig/09-50vusers.png", width: 85%),
  caption: [Reporte de consola K6 para el Escenario B (50 usuarios virtuales).]
)

*Análisis Detallado del Escenario B:*
- *Tasa de Reservas Exitosas:* `GET /eventos` se mantuvo en 100% de éxito. `POST /compras/reservar` alcanzó un *82% de éxito (1,236 reservas confirmadas)* y 264 rechazadas por vaciado total de stock.
- *Latencias en Percentiles:* La duración promedio HTTP fue de `19.27 ms` (mínimo `1.27 ms`, mediana `10.37 ms`, máximo `255.85 ms`). El percentil $P_90$ se ubicó en `45.68 ms` y el percentil $P_95$ en `66.32 ms`.
- *Throughput y Rendimiento de Red:* Se alcanzó un Throughput continuo de *64.71 peticiones HTTP por segundo* (32.35 transacciones por segundo), transmitiendo 5.0 MB de datos recibidos (107 kB/s) y 586 kB enviados (13 kB/s).

===== Escenario C: 100 VUs por 60 segundos
- *Resultados de Ejecución:* Se ejecutaron 3,955 iteraciones completas en 61.5 segundos (7,910 peticiones HTTP totales). Se evaluaron 11,865 verificaciones, con 9,837 verificaciones exitosas (82.90%).

#figure(
  image("../src/fig/10.png", width: 85%),
  caption: [Reporte de consola K6 para el Escenario C (100 usuarios virtuales).]
)

*Análisis Detallado del Escenario C:*
- *Comportamiento a Máxima Carga:* Se procesaron exitosamente *1,927 reservas POST* (48% de tasa de éxito sobre el total de intentos), agotando las 1,927 entradas disponibles en Redis. Las 2,028 solicitudes restantes fueron rechazadas legítimamente con `HTTP 409`.
- *Velocidad y Latencias:* El percentil $P_95$ se registró en *58.26 ms*, cumpliendo exitosamente el umbral configurado (`p(95)<1500ms`). La latencia promedio se mantuvo en `17.94 ms`.
- *Throughput Máximo:* Se alcanzó el pico de rendimiento del sistema con *128.55 peticiones por segundo (RPS)* (64.27 iteraciones completas/sec), procesando 13 MB de datos recibidos (210 kB/s) y 1.5 MB enviados (25 kB/s).

==== Consolidado de Métricas en K6

#align(center)[
  #table(
    columns: (1.2fr, 1fr, 1fr, 1.2fr, 1fr, 1fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Escenario],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Iteraciones],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Prom (ms)],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Percentil 95],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Throughput],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Exitosas],
    table.cell(inset: 0.4em)[#set text(fill: white, weight: "bold"); Fallidas],
    
    [20 VUs (30s)], [400], [10.08 ms], [41.08 ms], [26.24 req/s], [300 POST], [100 (Stock)],
    [50 VUs (45s)], [1500], [19.27 ms], [66.32 ms], [64.71 req/s], [1236 POST], [264 (Stock)],
    [100 VUs (60s)], [3955], [17.94 ms], [58.26 ms], [128.55 req/s], [1927 POST], [2028 (Stock)]
  )
]

==== Cuadro Comparativo: Apache JMeter vs K6

#align(center)[
  #table(
    columns: (1.5fr, 2fr, 2fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Característica],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Apache JMeter],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); K6 (Grafana Labs)],
    
    [Facilidad de uso], [Alta mediante GUI gráfica (Swing).], [Alta para desarrolladores (Código JS).],
    [Curva de aprendizaje], [Baja a media (Arrastrar y configurar).], [Muy baja (Scripting estándar en JavaScript).],
    [Automatización], [Requiere archivos XML .jmx e invocación CLI.], [Nativa mediante CLI y scripts reutilizables.],
    [Integración CI/CD], [Compleja (Requiere plugins en Jenkins/Actions).], [Excelente (Integración nativa en GitHub Actions/GitLab).],
    [Consumo de memoria], [Alto (Un hilo Java dedicado por usuario virtual).], [Muy bajo (Motor asíncrono Go/JavaScript).],
    [Generación de reportes], [Árbol de resultados, Summary y HTML dashboards.], [Métricas en consola, JSON, Grafana e InfluxDB.],
    [Escalabilidad], [Media (Limitado por hilos JVM del sistema).], [Muy alta (Soporta miles de VUs con pocos recursos).]
  )
]
