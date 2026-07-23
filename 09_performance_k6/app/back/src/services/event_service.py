"""Lógica transaccional de reservas y compras.

Orquesta las operaciones entre Redis (stock + TTL) y PostgreSQL (persistencia).
Garantiza integridad: no persiste si la sesión de Redis expiró (RNF-03).
"""

import uuid
from datetime import datetime, timezone

from redis import Redis

from src.models.db_models import Asistente, Compra
from src.services.redis_queue import (
    crear_reserva,
    eliminar_reserva,
    obtener_reserva,
    reducir_stock_atomica,
    revertir_stock,
)
from .seat_map import obtener_precio_zona, validar_evento_activo, validar_zona_existente


def procesar_reserva_atomica(
    r: Redis, evento_id: str, zona_id: str,
    cantidad: int, nombre_comprador: str,
    email_comprador: str, dni_comprador: str,
) -> dict:
    """Procesa una reserva de entradas de forma atómica (RF-01 + RF-02).

    Flujo:
    1. Valida que el evento exista y esté activo.
    2. Valida que la zona exista.
    3. Obtiene el precio de la zona.
    4. Reduce el stock atómicamente en Redis (DECRBY).
    5. Crea la reserva temporal con TTL de 3 minutos (RF-02).

    Returns:
        Diccionario con el resultado de la operación.
    """
    if not validar_evento_activo(r, evento_id):
        return {"exito": False, "codigo": 404, "error": "Evento no encontrado o inactivo"}

    if not validar_zona_existente(r, evento_id, zona_id):
        return {"exito": False, "codigo": 404, "error": "Zona no encontrada en el evento"}

    precio = obtener_precio_zona(r, evento_id, zona_id)
    if precio is None:
        return {"exito": False, "codigo": 404, "error": "Precio no disponible para la zona"}

    if not reducir_stock_atomica(r, evento_id, zona_id, cantidad):
        return {"exito": False, "codigo": 409, "error": "Stock insuficiente"}

    reserva = crear_reserva(
        r, evento_id, zona_id, cantidad, precio,
        nombre_comprador, email_comprador, dni_comprador,
    )

    return {"exito": True, "codigo": 200, "reserva": reserva}


def confirmar_pago_ticket(
    r: Redis,
    db,
    reserva_id: str,
    asistentes: list[dict],
) -> dict:
    """Confirma una reserva, persiste en PostgreSQL y genera tickets (RF-04).

    Flujo crítico:
    1. Verifica que la reserva exista en Redis (no haya expirado) - RNF-03
    2. Valida cantidad de asistentes
    3. Simula aprobación de pasarela de pago
    4. Persiste Compra + Asistentes en PostgreSQL
    5. Elimina la reserva temporal de Redis

    Si la reserva expiró (TTL agotado), NO persiste nada y retorna 408.
    Esto garantiza RNF-02 y RNF-03.
    """
    # 1. Verificar reserva en Redis - RNF-03: Si expiró, no persistir
    reserva = obtener_reserva(r, reserva_id)
    if reserva is None:
        return {
            "exito": False,
            "codigo": 408,
            "error": "La sesión de compra ha expirado. El stock fue liberado. Vuelve a intentar.",
        }

    cantidad = int(reserva["cantidad"])

    # 2. Validar cantidad de asistentes coincide con la reserva
    if len(asistentes) != cantidad:
        return {
            "exito": False,
            "codigo": 400,
            "error": f"Se esperaban {cantidad} asistentes, recibidos {len(asistentes)}",
        }

    # 3. Simular aprobación de pasarela de pago (siempre exitosa en prototipo)
    pago_aprobado = True
    if not pago_aprobado:
        revertir_stock(r, reserva["evento_id"], reserva["zona_id"], cantidad)
        eliminar_reserva(r, reserva_id)
        return {"exito": False, "codigo": 402, "error": "Pago rechazado"}

    # 4. Persistir en PostgreSQL (solo si el TTL no expiró)
    compra = Compra(
        reserva_id=reserva_id,
        evento_id=reserva["evento_id"],
        zona_id=reserva["zona_id"],
        cantidad=cantidad,
        precio_unitario=float(reserva["precio_unitario"]),
        precio_total=float(reserva["precio_total"]),
        nombre_comprador=reserva["nombre_comprador"],
        email_comprador=reserva.get("email_comprador", ""),
        dni_comprador=reserva.get("dni_comprador", ""),
        estado="confirmado",
    )
    db.session.add(compra)
    db.session.flush()

    tickets = []
    for asistente in asistentes:
        ticket_id = str(uuid.uuid4())
        registro = Asistente(
            compra_id=compra.id,
            reserva_id=reserva_id,
            evento_id=reserva["evento_id"],
            zona_id=reserva["zona_id"],
            nombre_asistente=asistente["nombre"],
            documento_asistente=asistente["documento"],
            precio=float(reserva["precio_unitario"]),
            ticket_id=ticket_id,
        )
        db.session.add(registro)
        tickets.append({
            "ticket_id": ticket_id,
            "reserva_id": reserva_id,
            "evento_id": reserva["evento_id"],
            "zona_id": reserva["zona_id"],
            "nombre_asistente": asistente["nombre"],
            "documento_asistente": asistente["documento"],
            "precio": float(reserva["precio_unitario"]),
            "fecha_compra": datetime.now(timezone.utc).isoformat(),
        })

    db.session.commit()

    # 5. Eliminar reserva temporal de Redis
    eliminar_reserva(r, reserva_id)

    return {
        "exito": True,
        "codigo": 200,
        "compra_id": str(compra.id),
        "tickets": tickets,
    }
