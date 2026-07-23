"""Gestión de zonas y precios de eventos.

Lee la configuración de zonas desde Redis y expone helpers
para validar zonas y obtener precios.
"""

from redis import Redis

# Prefijo de clave Redis para eventos
EVENTOS_PREFIX = "ticketpass:eventos"


def obtener_eventos(r: Redis) -> list[dict]:
    """Retorna todos los eventos activos desde Redis."""
    eventos = []
    evento_keys = r.keys(f"{EVENTOS_PREFIX}:*:info")

    for key in evento_keys:
        evento_id = key.split(":")[2]
        info = r.hgetall(key)
        if not info:
            continue

        zonas = obtener_zonas_evento(r, evento_id)
        eventos.append({
            "id": evento_id,
            "nombre": info.get("nombre", ""),
            "artista": info.get("artista", ""),
            "venue": info.get("venue", ""),
            "fecha": info.get("fecha", ""),
            "estado": info.get("estado", "activo"),
            "imagen_url": info.get("imagen_url", ""),
            "zonas": zonas,
        })

    return eventos


def obtener_zonas_evento(r: Redis, evento_id: str) -> list[dict]:
    """Retorna las zonas de un evento con su stock actual."""
    zonas = []
    zona_keys = r.keys(f"{EVENTOS_PREFIX}:{evento_id}:zonas:*")

    for key in zona_keys:
        zona_id = key.split(":")[-1]
        info = r.hgetall(key)
        if not info:
            continue

        stock_key = f"{EVENTOS_PREFIX}:{evento_id}:stock:{zona_id}"
        stock_disponible = int(r.get(stock_key) or info.get("stock_total", 0))

        zonas.append({
            "id": zona_id,
            "nombre": info.get("nombre", ""),
            "precio": float(info.get("precio", 0)),
            "stock_total": int(info.get("stock_total", 0)),
            "stock_disponible": stock_disponible,
        })

    return zonas


def obtener_precio_zona(r: Redis, evento_id: str, zona_id: str) -> float | None:
    """Retorna el precio de una zona específica. None si no existe."""
    key = f"{EVENTOS_PREFIX}:{evento_id}:zonas:{zona_id}"
    precio = r.hget(key, "precio")
    return float(precio) if precio else None


def validar_zona_existente(r: Redis, evento_id: str, zona_id: str) -> bool:
    """Valida que una zona exista en un evento."""
    key = f"{EVENTOS_PREFIX}:{evento_id}:zonas:{zona_id}"
    return r.exists(key) == 1


def validar_evento_activo(r: Redis, evento_id: str) -> bool:
    """Valida que un evento esté en estado activo."""
    key = f"{EVENTOS_PREFIX}:{evento_id}:info"
    estado = r.hget(key, "estado")
    return estado == "activo" if estado else False
