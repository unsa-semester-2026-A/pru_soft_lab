# TicketPass API

Backend de alto rendimiento para venta de entradas de conciertos.

**Stack:** Flask + Gunicorn + Redis + PostgreSQL

## Arquitectura Modular

```
back/
├── main.py              # Flask factory + Gunicorn
├── seed.py              # Datos de ejemplo en Redis
├── Dockerfile           # Imagen de la app
├── docker-compose.yml   # Redis + PostgreSQL + API
├── src/
│   ├── config.py        # Variables de entorno
│   ├── database.py      # Flask-SQLAlchemy
│   ├── models/
│   │   ├── schemas.py   # Esquemas Pydantic (validación estricta)
│   │   └── db_models.py # Modelos SQLAlchemy (Compra, Asistente)
│   ├── api/
│   │   └── routes.py    # Flask Blueprints
│   └── services/
│       ├── event_service.py  # Lógica transaccional (Redis → PostgreSQL)
│       ├── redis_queue.py    # Stock atómico DECRBY + cola FIFO + TTL
│       └── seat_map.py       # Eventos y zonas desde Redis
└── .env.example
```

---

## Ejecución con Docker (Recomendado)

```bash
docker compose up --build
```

La API estará disponible en `http://localhost:5000`

Sembrar datos de ejemplo:

```bash
docker compose exec api uv run python seed.py
```

Detener servicios:

```bash
docker compose down
```

---

## Ejecución sin Docker

### Requisitos

- Python 3.12+
- Redis server
- PostgreSQL 14+
- `uv` package manager

### Instalación

```bash
uv sync
```

### Ejecución

```bash
redis-server
createdb ticketpass
uv run python seed.py
uv run python main.py
```

### Con Gunicorn

```bash
uv run gunicorn --bind 0.0.0.0:5000 --workers 4 --timeout 120 "main:create_app()"
```

---

## Endpoints

| Método | Endpoint | Descripción | RNF |
|--------|----------|-------------|-----|
| `GET` | `/health` | Health check | - |
| `GET` | `/api/v1/eventos` | Lista eventos con stock real-time | - |
| `POST` | `/api/v1/compras/reservar` | Reserva atómica + TTL 5 min | RF-01, RF-02, RNF-01 |
| `POST` | `/api/v1/compras/confirmar` | Confirma + persiste en PostgreSQL | RF-04, RNF-02, RNF-03 |
| `GET` | `/api/v1/cola/estado` | Estado de la cola | - |

## Eventos de Ejemplo (Seed)

| ID | Artista | Venue | Zonas |
|----|---------|-------|-------|
| conc-001 | Lana Del Rey | Estadio Nacional | VIP, Preferencial, General |
| conc-002 | Julian Casablancas | Arena Lima | VIP, Preferencial, General |
| conc-003 | Taylor Swift | Estadio San Marcos | VIP, Preferencial, General |
| conc-004 | Hayley Williams | Jockey Club | VIP, Preferencial, General |

## Modelo de Evento

```json
{
  "id": "conc-001",
  "nombre": "Lana Del Rey: The Did You Know...",
  "artista": "Lana Del Rey",
  "venue": "Estadio Nacional, Lima",
  "fecha": "2026-08-15T21:00:00",
  "estado": "activo",
  "imagen_url": "https://...",
  "zonas": [...]
}
```

## Flujo de Compra

```
1. POST /compras/reservar
   - DECRBY en Redis (<10ms)
   - Crea reserva con TTL 300s
   - Retorna reserva_id

2. [Usuario llena formulario - 5 min máximo]

3. POST /compras/confirmar
   - Verifica TTL en Redis (RNF-03)
   - Si expiró → 408 (stock liberado)
   - Si válido → persiste en PostgreSQL
   - Elimina reserva de Redis
```
