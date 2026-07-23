# TicketPass - Sistema de Venta de Entradas

Plataforma de alta concurrencia para venta de entradas de conciertos.

**Stack:** Flask + Gunicorn + Redis + PostgreSQL + Astro

---

## Estructura del Proyecto

```
app/
├── back/               # Backend API (Flask + Redis + PostgreSQL)
│   ├── src/
│   │   ├── api/        # Endpoints REST (eventos, compras, admin)
│   │   ├── models/     # Schemas Pydantic + SQLAlchemy
│   │   └── services/   # Lógica de negocio (Redis, stock, transacciones)
│   ├── main.py         # Entry point Flask
│   ├── seed.py         # Poblar base de datos
│   └── Dockerfile
├── front/              # Frontend (Astro + React + Tailwind)
│   ├── src/
│   │   ├── components/ # Componentes React modulares
│   │   ├── lib/        # API client, validaciones, hooks
│   │   └── pages/      # Páginas Astro
│   └── Dockerfile
├── docker-compose.yml  # Todos los servicios
└── README.md           # Este archivo
```

---

## Ejecución Local (Desarrollo)

### Requisitos

- Python 3.12+
- Node.js 22+ / Bun
- Docker (para Redis y PostgreSQL)
- `uv` (package manager Python)

### 1. Iniciar servicios de Docker

```bash
docker compose up -d redis postgres
```

### 2. Backend API

```bash
cd back

# Instalar dependencias
uv sync

# Poblar base de datos con datos de ejemplo
uv run seed.py

# Iniciar servidor en desarrollo
uv run main.py
```

La API estará en: `http://localhost:5000`

### 3. Frontend

```bash
cd front

# Instalar dependencias
bun install

# Iniciar servidor de desarrollo
bun run dev
```

El frontend estará en: `http://localhost:4322`

### Endpoints disponibles

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/api/v1/eventos` | GET | Listar eventos |
| `/api/v1/eventos/:id` | GET | Obtener evento |
| `/api/v1/compras/reservar` | POST | Reservar entradas |
| `/api/v1/compras/confirmar` | POST | Confirmar compra |
| `/api/v1/admin/eventos` | POST | Crear evento |
| `/api/v1/admin/eventos/:id` | PUT | Actualizar evento |
| `/api/v1/admin/eventos/:id` | DELETE | Eliminar evento |
| `/api/v1/admin/stats` | GET | Estadísticas |
| `/api/v1/admin/compras` | GET | Listar compras |
| `/api/v1/admin/asistentes` | GET | Listar asistentes |

---

## Ejecución con Docker (Producción)

### Levantar todo

```bash
docker compose up --build -d
```

### Servicios

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| `front` | 4321 | Frontend Astro + Nginx |
| `api` | 5000 | Backend Flask + Gunicorn |
| `redis` | 6379 | Redis (stock, TTL, cola) |
| `postgres` | 5433 | PostgreSQL (compras, asistentes) |

### URLs

- **Frontend:** http://localhost:4322
- **API:** http://localhost:5000/health
- **Admin:** http://localhost:4322/admin

### Comandos útiles

```bash
# Ver logs
docker compose logs -f api
docker compose logs -f front

# Detener servicios
docker compose down

# Detener y eliminar volúmenes (borrar datos)
docker compose down -v

# Reconstruir solo el backend
docker compose up --build api -d

# Reconstruir solo el frontend
docker compose up --build front -d
```

---

## Semilla de Datos

Para poblar la base de datos con datos de ejemplo:

```bash
# Ejecutar seed (necesita Redis y PostgreSQL corriendo)
cd back && uv run python seed.py
```

**En Docker:**

```bash
docker compose exec api uv run python seed.py
```

### Datos que crea

**5 eventos en Redis:**
- Lana Del Rey: The Did You Know Tour
- Julian Casablancas + The Voids Tour
- Taylor Swift: The Eras Tour
- Hayley Williams: Petals for Armor Tour
- Daddy Yankee: La Última Vuelta

**3 compras + 6 asistentes en PostgreSQL**

---

## Arquitectura

### Flujo de Compra

```
1. Usuario selecciona evento y zona
2. POST /compras/reservar
   → DECRBY stock en Redis (atómico)
   → Crea reserva con TTL 180 segundos (3 min)
   → Retorna reserva_id

3. Usuario llena formulario (3 min máximo)

4. POST /compras/confirmar
   → Verifica TTL en Redis
   → Si expiró → 408 (stock liberado)
   → Si válido → persiste en PostgreSQL
   → Elimina reserva de Redis
```

### Requerimientos No Funcionales

| RNF | Descripción | Implementación |
|-----|-------------|----------------|
| RNF-01 | Latencia <10ms | Redis puro para stock |
| RNF-02 | Consistencia ante abandono | TTL 180s destruye reserva |
| RNF-03 | Integridad de datos | Verifica TTL antes de persistir |

---

## Variables de Entorno

### Backend (`back/.env`)

```env
FLASK_HOST=0.0.0.0
FLASK_PORT=5000
FLASK_DEBUG=true
REDIS_HOST=localhost
REDIS_PORT=6379
DATABASE_URL=postgresql://postgres:postgres@localhost:5433/ticketpass
RESERVA_TTL_SEGUNDOS=180
```

### Docker

Las variables de entorno en `docker-compose.yml` usan los nombres de los servicios Docker:
- `REDIS_HOST=redis` (nombre del servicio)
- `DATABASE_URL=postgresql://...@postgres:5432/ticketpass`

---

## Paleta de Colores

| Color | Hex | Uso |
|-------|-----|-----|
| Deep Purple | #29253D | Backgrounds oscuros |
| Teal | #82E2DB | Acento principal |
| Light Gray | #EDECEE | Backgrounds claros |
| Violet | #9577FF | CTAs / Botones primarios |
