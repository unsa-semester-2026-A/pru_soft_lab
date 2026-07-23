"""Integración con Redis para cola de espera y gestión de stock.

Maneja la conexión a Redis y expone operaciones atómicas para
la cola FIFO y el stock de entradas.

Buenas prácticas aplicadas (redis-best-practices):
- Connection pooling para reutilizar conexiones
- Key naming consistente con colons
- TTL en reservas temporales
- Operaciones atómicas con DECRBY/INCRBY
"""

import json
import uuid

from redis import ConnectionPool, Redis

from src.config import config

# ── Connection Pool (redis-best-practices) ───────────────────────────────────
# Reutilizar conexiones en lugar de crear una nueva por request
_pool = ConnectionPool(
    host=config.REDIS_HOST,
    port=config.REDIS_PORT,
    db=config.REDIS_DB,
    decode_responses=True,
    max_connections=50,
    socket_timeout=5,
    socket_connect_timeout=5,
)


def get_redis() -> Redis:
    """Retorna un cliente Redis desde el pool de conexiones."""
    return Redis(connection_pool=_pool)


# ── Prefijos de claves (redis-core: colon-separated) ─────────────────────────
COLA_KEY = config.COLA_KEY
STOCK_PREFIX = "ticketpass:eventos"
RESERVA_PREFIX = "ticketpass:reservas"


# ── Cola de espera (List: LPUSH/BRPOP) ───────────────────────────────────────

def encolar_usuario(r: Redis, evento_id: str, zona_id: str, datos: dict) -> str:
    """Encola una solicitud de compra en la cola FIFO.

    Returns:
        ID único de la solicitud encolada.
    """
    solicitud_id = str(uuid.uuid4())
    entrada = json.dumps({
        "solicitud_id": solicitud_id,
        "evento_id": evento_id,
        "zona_id": zona_id,
        **datos,
    })
    r.rpush(COLA_KEY, entrada)
    return solicitud_id


def obtener_siguiente_en_cola(r: Redis, timeout: int = 0) -> dict | None:
    """Extrae el siguiente elemento de la cola (FIFO).

    Bloquea hasta `timeout` segundos si la cola está vacía.
    Retorna None si no hay elementos y timeout es 0.
    """
    resultado = r.blpop(COLA_KEY, timeout=timeout)
    if resultado is None:
        return None
    _, datos = resultado
    return json.loads(datos)


def longitud_cola(r: Redis) -> int:
    """Retorna la cantidad de solicitudes pendientes en la cola."""
    return r.llen(COLA_KEY)


# ── Stock atómico (String: DECRBY/INCRBY) ────────────────────────────────────

def reducir_stock_atomica(r: Redis, evento_id: str, zona_id: str, cantidad: int) -> bool:
    """Reduce el stock de forma atómica usando DECRBY.

    Si el resultado es negativo, revierte con INCRBY y retorna False.
    Retorna True si la reducción fue exitosa.

    Latencia objetivo: <10ms (RNF-01).
    """
    stock_key = f"{STOCK_PREFIX}:{evento_id}:stock:{zona_id}"
    resultado = r.decrby(stock_key, cantidad)

    if resultado < 0:
        r.incrby(stock_key, cantidad)
        return False
    return True


def revertir_stock(r: Redis, evento_id: str, zona_id: str, cantidad: int) -> None:
    """Restaura stock tras una reserva expirada o cancelada."""
    stock_key = f"{STOCK_PREFIX}:{evento_id}:stock:{zona_id}"
    r.incrby(stock_key, cantidad)


# ── Reservas temporales (Hash + TTL) ─────────────────────────────────────────

def crear_reserva(
    r: Redis, evento_id: str, zona_id: str, cantidad: int,
    precio_unitario: float, nombre_comprador: str,
    email_comprador: str = "", dni_comprador: str = "",
) -> dict:
    """Crea una reserva temporal con TTL en Redis (RF-02).

    Usa Hash para almacenar campos individuales (redis-core).
    TTL de 3 minutos para ventana de compra.
    """
    reserva_id = str(uuid.uuid4())
    datos_reserva = {
        "reserva_id": reserva_id,
        "evento_id": evento_id,
        "zona_id": zona_id,
        "cantidad": str(cantidad),
        "precio_unitario": str(precio_unitario),
        "precio_total": str(precio_unitario * cantidad),
        "nombre_comprador": nombre_comprador,
        "email_comprador": email_comprador,
        "dni_comprador": dni_comprador,
        "estado": "reservado",
    }

    key = f"{RESERVA_PREFIX}:{reserva_id}"

    # Pipeline para operaciones atómicas (redis-best-practices)
    pipe = r.pipeline()
    pipe.hset(key, mapping=datos_reserva)
    pipe.expire(key, config.RESERVA_TTL_SEGUNDOS)
    pipe.execute()

    return datos_reserva


def obtener_reserva(r: Redis, reserva_id: str) -> dict | None:
    """Obtiene una reserva por su ID. Retorna None si no existe o expiró."""
    key = f"{RESERVA_PREFIX}:{reserva_id}"
    datos = r.hgetall(key)
    return datos if datos else None


def eliminar_reserva(r: Redis, reserva_id: str) -> None:
    """Elimina una reserva de Redis."""
    key = f"{RESERVA_PREFIX}:{reserva_id}"
    r.delete(key)
