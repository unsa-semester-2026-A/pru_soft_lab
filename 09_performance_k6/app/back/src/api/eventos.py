"""Rutas para gestión de eventos (público + admin)."""

from flask import Blueprint, jsonify, request
from pydantic import ValidationError

from src.models.schemas import (
    ErrorResponse,
    EventoCreateRequest,
)
from src.services.redis_queue import get_redis
from src.services.seat_map import obtener_eventos

eventos_bp = Blueprint("eventos", __name__, url_prefix="/api/v1")


def _format_error(e: ValidationError) -> dict:
    errores = [f"{' -> '.join(str(l) for l in err['loc'])}: {err['msg']}" for err in e.errors()]
    return ErrorResponse(error="Datos inválidos", detalle="; ".join(errores)).model_dump()


# ── GET /api/v1/eventos ─────────────────────────────────────────────────────
@eventos_bp.route("/eventos", methods=["GET"])
def listar_eventos():
    r = get_redis()
    try:
        eventos = obtener_eventos(r)
        return jsonify(eventos), 200
    finally:
        r.close()


# ── GET /api/v1/eventos/<id> ────────────────────────────────────────────────
@eventos_bp.route("/eventos/<evento_id>", methods=["GET"])
def obtener_evento(evento_id: str):
    r = get_redis()
    try:
        eventos = obtener_eventos(r)
        evento = next((e for e in eventos if e["id"] == evento_id), None)
        if not evento:
            return jsonify(ErrorResponse(error="Evento no encontrado", detalle=evento_id).model_dump()), 404
        return jsonify(evento), 200
    finally:
        r.close()


# ── POST /api/v1/admin/eventos ──────────────────────────────────────────────
@eventos_bp.route("/admin/eventos", methods=["POST"])
def crear_evento():
    try:
        datos = EventoCreateRequest.model_validate(request.get_json())
    except ValidationError as e:
        return jsonify(_format_error(e)), 400

    r = get_redis()
    try:
        import uuid
        evento_id = f"evt-{str(uuid.uuid4())[:8]}"

        # Guardar info del evento
        r.hset(f"ticketpass:eventos:{evento_id}:info", mapping={
            "nombre": datos.nombre,
            "artista": datos.artista,
            "venue": datos.venue,
            "fecha": datos.fecha,
            "estado": "activo",
            "imagen_url": datos.imagen_url,
            "categoria": datos.categoria,
        })

        # Guardar zonas y stock
        for zona in datos.zonas:
            r.hset(f"ticketpass:eventos:{evento_id}:zonas:{zona.id}", mapping={
                "nombre": zona.nombre,
                "precio": str(zona.precio),
                "stock_total": str(zona.stock_total),
            })
            r.set(f"ticketpass:eventos:{evento_id}:stock:{zona.id}", str(zona.stock_total))

        return jsonify({"id": evento_id, "mensaje": "Evento creado exitosamente"}), 201
    finally:
        r.close()


# ── PUT /api/v1/admin/eventos/<id> ──────────────────────────────────────────
@eventos_bp.route("/admin/eventos/<evento_id>", methods=["PUT"])
def actualizar_evento(evento_id: str):
    r = get_redis()
    try:
        key = f"ticketpass:eventos:{evento_id}:info"
        if not r.exists(key):
            return jsonify(ErrorResponse(error="Evento no encontrado", detalle=evento_id).model_dump()), 404

        datos = request.get_json()
        campos_validos = {"nombre", "artista", "venue", "fecha", "estado", "imagen_url", "categoria"}
        update = {k: v for k, v in datos.items() if k in campos_validos and v is not None}

        if update:
            r.hset(key, mapping=update)

        return jsonify({"mensaje": "Evento actualizado"}), 200
    finally:
        r.close()


# ── DELETE /api/v1/admin/eventos/<id> ───────────────────────────────────────
@eventos_bp.route("/admin/eventos/<evento_id>", methods=["DELETE"])
def eliminar_evento(evento_id: str):
    r = get_redis()
    try:
        key = f"ticketpass:eventos:{evento_id}:info"
        if not r.exists(key):
            return jsonify(ErrorResponse(error="Evento no encontrado", detalle=evento_id).model_dump()), 404

        # Eliminar todas las claves del evento
        for k in r.keys(f"ticketpass:eventos:{evento_id}:*"):
            r.delete(k)

        return jsonify({"mensaje": "Evento eliminado"}), 200
    finally:
        r.close()
