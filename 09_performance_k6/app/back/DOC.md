A continuación, te presento el **Documento de Especificación de Requerimientos y Arquitectura** para tu laboratorio, estructurado exactamente con el nivel técnico que exigen los informes universitarios de software. Puedes copiar este formato directamente para tu entrega.

---
# Documento de Especificación Técnica: Sistema "TicketPass"
**Proyecto:** Plataforma de Alta Concurrencia para Venta de Entradas de Conciertos
**Arquitectura:** Desacoplada (Frontend en Astro / Backend en Flask + Redis)
---

## 1. Descripción del Sistema

El sistema simula la venta masiva de entradas para conciertos de alta demanda (picos de tráfico destructivos en segundos). Para soportar la carga sin corromper los datos ni ralentizar la experiencia de usuario, el backend delega la gestión del inventario (stock) en tiempo real y el encolamiento de los usuarios a **Redis**, mientras que **Flask** actúa como la capa lógica y de ruteo modular.

---

## 2. Requerimientos Funcionales (RF)

* **RF-01: Consulta de Cartelera y Disponibilidad:** El sistema debe permitir listar los conciertos activos, sus zonas (VIP, Preferencial, General), precios y el stock de entradas disponible en tiempo real.
* **RF-02: Encolamiento de Solicitudes (Cola de Espera):** Cuando la demanda supere el umbral del servidor, las solicitudes de compra deben ingresar a una cola FIFO (First In, First Out) gestionada en Redis para proteger la infraestructura.
* **RF-03: Reserva Atómica de Entradas:** El sistema debe permitir reservar entradas por un tiempo límite (ej. 5 minutos). La reducción del stock debe ser atómica para evitar la sobreventa.
* **RF-04: Confirmación y Transacción de Compra:** El sistema debe consolidar la compra si el usuario procesa el pago antes de que expire su tiempo de reserva, liberando el stock si el tiempo expira.

---

## 3. Requerimientos No Funcionales (RNF)

* **RNF-01: Alta Concurrencia y Rendimiento:** El backend debe ser capaz de procesar ráfagas simultáneas de hasta 100 usuarios concurrentes en las pruebas de estrés sin degradar críticamente el tiempo de respuesta global.

* **RNF-02: Consistencia de Datos (Prevención de Sobrevenda):** El sistema bajo ninguna circunstancia debe permitir un stock final negativo. Si quedan 5 entradas y entran 100 peticiones en el mismo milisegundo, solo 5 deben ser exitosas (`200 OK`) y 95 deben ser rechazadas (`409 Conflict`).

* **RNF-03: Seguridad y Validación de Datos:** La API debe validar estrictamente los payloads entrantes. Peticiones con cantidades negativas, IDs inválidos o tipos de datos corruptos deben ser rebotadas inmediatamente (`400 Bad Request`).

* **RNF-04: Arquitectura Desacoplada:** El frontend (Astro) y el backend (Flask) deben comunicarse exclusivamente mediante una API REST en formato JSON, manteniendo la capa lógica del backend aislada para las pruebas de carga puras.

---

## 4. Lógica de Concurrencia con Redis

En lugar de usar un `Lock` síncrono de Python que ralentiza el servidor al obligar a los hilos a esperar en fila, usaremos **Redis hashes y strings**.

1. **Stock Atómico:** El stock se almacena en Redis. Cuando llega una petición, usamos el comando `DECRBY` de Redis a través de la librería `redis-py`. Como Redis es monohilo internamente, procesa una reducción a la vez a la velocidad de la luz. Si el resultado es menor a 0, revertimos la operación inmediatamente (`INCRBY`) y respondemos que no hay stock.

2. **La Cola Virtual:** Las solicitudes de compra pesadas entran a una lista de Redis (`LPUSH` / `RPOPOP`). Flask mete la petición en la cola y un proceso en segundo plano (o la misma lógica de Redis) valida los turnos.

---

## 5. Arquitectura del Código y Módulos del Backend

Alineado a la estructura modular que solicitaste para la capa de servicios, esta es la distribución de responsabilidades en tu backend:

### `src/models.py`

Define los esquemas de validación de datos usando **Pydantic** y las estructuras base del concierto. Garantiza que la API sea segura ante datos malformados antes de tocar la base de datos.

* *Clases:* `ConciertoSchema`, `PedidoRequestSchema`.

### `src/seat_map.py`

Maneja la lógica de distribución geográfica o por zonas del evento. Define los sectores disponibles (VIP, General), el límite máximo por sector y los precios de cada entrada.

* *Funciones:* `obtener_precio_zona()`, `validar_zona_existente()`.

### `src/queue.py`

Contiene la integración directa con el cliente de Redis. Se encarga de gestionar la conexión al servidor de Redis y define los métodos para interactuar con la cola de usuarios y el flujo FIFO.

* *Funciones:* `conectar_redis()`, `encolar_usuario()`, `obtener_siguiente_en_cola()`.

### `src/service.py`

Contiene la **lógica transaccional dura** de la compra. Interactúa con `seat_map.py` para verificar precios y ejecuta los comandos atómicos en Redis a través de `queue.py` para restar el stock de forma segura.

* *Funciones:* `procesar_reserva_atomica()`, `confirmar_pago_ticket()`.

---

## 6. Diseño de la API REST (Rutas Modulares)

| Método | Endpoint | Descripción | Código HTTP Esperado |
| --- | --- | --- | --- |
| **GET** | `/api/v1/eventos` | Retorna la lista de conciertos con su stock actual directo desde Redis. | `200 OK` |
| **POST** | `/api/v1/compras/reservar` | Intenta encolar al usuario y restar el stock de forma atómica en Redis. | `200 OK` / `409 Conflict` (Agotado) / `400 Bad Request` (Datos inválidos)

 |
| **POST** | `/api/v1/compras/confirmar` | Consolida la compra definitiva y genera el ticket. | `200 OK` / `408 Timeout` (Expiró reserva) |

---

## 7. Plan de Pruebas de Carga y Estrés (Para el Informe de Laboratorio)

* **Línea Base (Carga Normal):** 20 usuarios virtuales recurrentes en **k6** consultando el catálogo (`GET /eventos`). El tiempo de respuesta debe mantenerse por debajo de los 20ms gracias al caché de Redis.


* **Prueba de Estrés (Concurrencia Crítica):** 100 usuarios virtuales en **JMeter** atacando en simultáneo el endpoint `POST /compras/reservar` cuando quedan solo 10 entradas.


* *Resultado Esperado:* Las gráficas deben mostrar exactamente 10 respuestas exitosas y 90 respuestas controladas con código 409. El *Error Rate* técnico del servidor debe ser 0% (el servidor no se cae), demostrando la robustez de Redis ante condiciones de carrera.

Un como se vera la app:
- Al inicio se muestra un titulo centrado en el medio con un texto enganchado o algo asi luego aprece un boton de empezar pasamos a la pantalla de eventos donde hay artos eventos en cards un search y tal vez cateogorias com que diga si es proximo evento o si es pasado evento y al darle click a un evento nos lleva a la pantalla de compra donde hay un mapa de asientos juntos cono una tabla donde se ve los precios categorias y luego un boton de comprar y al seleccionar un asiento nos lleva a la pantalla de pago que funciona de froma offline y donde se confirma la compra y se genera el ticket. se puede n tickets y poner nombre de los assitentes. guitate de https://teleticket.com.pe/paginas/condiciones, lo maximo que puede comprar es de 5 entradas a la vez.

# Flujo 1: Retencion de Stock
```bash
[Usuario / Script de Carga] 
          │
          ▼
1. Envía POST /iniciar_compra (Zona, Cantidad)
          │
          ▼
2. Flask ejecuta DECRBY stock:[zona] en REDIS
          │
          ├──► [¿Stock < 0?] ──► SÍ ──► Ejecuta INCRBY (Revertir) ──► Retorna 400 "Agotado"
          │
          └──► NO (Hay Stock)
                │
                ▼
3. Genera un `compra_id` único
                │
                ▼
4. Guarda en REDIS la clave `compra:[compra_id]` con la cantidad retenida.
   Se le aplica un TTL de 5 minutos (EX 300).
                │
                ▼
5. Retorna 201 "Token de compra generado. Tienes 5 minutos para enviar los datos".
```

# Flujo 2: Confirmación y Envío de Datos (Paso 2 del Usuario)Este es el flujo clave para tu prueba de rendimiento: procesar nombres de asistentes e impactar la BD relacional.

```bash
[Usuario / Script de Carga] 
          │
          ▼
1. Envía POST /confirmar_compra (compra_id, datos_tarjeta, lista_asistentes)
   Ej: [{"nombre": "Carlos", "dni": "123"}, {"nombre": "Ana", "dni": "456"}]
          │
          ▼
2. Flask verifica la existencia de `compra:[compra_id]` en REDIS
          │
          ├──► [¿La clave YA NO EXISTE / Expiró?] ──► SÍ ──► Retorna 408 "Tiempo límite de 5 min agotado"
          │                                                    (El stock ya se liberó automáticamente en Redis)
          └──► SÍ EXISTE (Entró dentro de los 5 minutos)
                │
                ▼
3. Se ejecuta la lógica de pago simulada (milisegundos)
                │
                ▼
4. Se realiza la inserción masiva (Bulk Insert) en POSTGRESQL:
   - Se crea la Orden de compra final.
   - Se registran los nombres individuales de los asistentes vinculados a esa orden.
                │
                ▼
5. Se elimina `compra:[compra_id]` de REDIS para cerrar el ciclo de forma limpia.
                │
                ▼
6. Retorna 200 "Compra exitosa. Entradas emitidas".
```
es un prototipo de API REST de alto rendimiento diseñado para la venta inmediata de entradas de conciertos en zonas generales. El sistema simula una compra en caliente donde el usuario tiene un límite estricto de 5 minutos para enviar los datos de los asistentes de cada entrada desde que el stock es retenido.Para soportar el estrés de carga masiva, la retención de stock, el control del temporizador de 5 minutos y la asignación temporal de datos se procesan en Redis, impactando a la base de datos PostgreSQL únicamente cuando la transacción y el pago simulado son exitosos.2. Requerimientos del SistemaRequerimientos Funcionales (RF)RF-01: Selección y Bloqueo de Stock Instantáneo: El sistema debe validar y restar el stock de la zona en Redis de forma atómica.RF-02: Ventana de Compra de 5 Minutos: El sistema debe otorgar un identificador de sesión de compra que expira estrictamente a los 5 minutos (300 segundos).RF-03: Personalización de Entradas Múltiples: Si el usuario compra más de una entrada, el formulario final debe permitir enviar un arreglo con el nombre y documento de cada asistente individual.RF-04: Procesamiento Inmediato: El sistema debe simular la aprobación de una pasarela de pago al instante y, si es exitosa, persistir los datos de los asistentes en PostgreSQL.Requerimientos No Funcionales (RNF)RNF-01: Latencia Crítica Corta: El proceso de validación de stock y creación del temporizador de 5 minutos debe resolverse en menos de 10 milisegundos en el servidor.RNF-02: Consistencia ante Abandono: Si el usuario tarda más de 5 minutos en llenar el formulario, Redis debe destruir la sesión y el stock debe quedar disponible para el público inmediatamente.RNF-03: Integridad de Datos Masiva: El sistema debe garantizar que no se registren asistentes en PostgreSQL si la sesión de Redis ya había expirado por tiempo límite.
