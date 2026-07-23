"""Rutas para gestión de compras y reservas."""

from flask import Blueprint, jsonify, request
from pydantic import ValidationError

from src.config import config
from src.database import db
from src.models.schemas import (
    ConfirmarRequest,
    ConfirmarResponse,
    ErrorResponse,
    ReservaRequest,
    ReservaResponse,
    TicketResponse,
)
from src.services.redis_queue import get_redis, longitud_cola
from src.services.event_service import confirmar_pago_ticket, procesar_reserva_atomica

compras_bp = Blueprint("compras", __name__, url_prefix="/api/v1/compras")


def _format_error(e: ValidationError) -> dict:
    errores = [f"{' -> '.join(str(l) for l in err['loc'])}: {err['msg']}" for err in e.errors()]
    return ErrorResponse(error="Datos inválidos", detalle="; ".join(errores)).model_dump()


# ── POST /api/v1/compras/reservar ───────────────────────────────────────────
@compras_bp.route("/reservar", methods=["POST"])
def reservar():
    try:
        datos = ReservaRequest.model_validate(request.get_json())
    except ValidationError as e:
        return jsonify(_format_error(e)), 400
    except Exception as e:
        return jsonify(ErrorResponse(error="Error en el payload", detalle=str(e)).model_dump()), 400

    r = get_redis()
    try:
        resultado = procesar_reserva_atomica(
            r,
            evento_id=datos.evento_id,
            zona_id=datos.zona_id,
            cantidad=datos.cantidad,
            nombre_comprador=datos.nombre_comprador,
            email_comprador=datos.email_comprador,
            dni_comprador=datos.dni_comprador,
        )

        if not resultado["exito"]:
            return jsonify(ErrorResponse(
                error=resultado["error"],
                detalle=f"Código: {resultado['codigo']}",
            ).model_dump()), resultado["codigo"]

        reserva = resultado["reserva"]

        return jsonify(ReservaResponse(
            reserva_id=reserva["reserva_id"],
            evento_id=reserva["evento_id"],
            zona_id=reserva["zona_id"],
            cantidad=int(reserva["cantidad"]),
            precio_unitario=float(reserva["precio_unitario"]),
            precio_total=float(reserva["precio_total"]),
            expira_en_segundos=config.RESERVA_TTL_SEGUNDOS,
            estado=reserva["estado"],
        ).model_dump()), 200

    finally:
        r.close()


# ── POST /api/v1/compras/confirmar ──────────────────────────────────────────
@compras_bp.route("/confirmar", methods=["POST"])
def confirmar():
    try:
        datos = ConfirmarRequest.model_validate(request.get_json())
    except ValidationError as e:
        return jsonify(_format_error(e)), 400
    except Exception as e:
        return jsonify(ErrorResponse(error="Error en el payload", detalle=str(e)).model_dump()), 400

    r = get_redis()
    try:
        asistentes_data = [{"nombre": a.nombre, "documento": a.documento} for a in datos.asistentes]

        resultado = confirmar_pago_ticket(
            r=r,
            db=db,
            reserva_id=datos.reserva_id,
            asistentes=asistentes_data,
        )

        if not resultado["exito"]:
            return jsonify(ErrorResponse(
                error=resultado["error"],
                detalle=f"Código: {resultado['codigo']}",
            ).model_dump()), resultado["codigo"]

        tickets = [TicketResponse(**t).model_dump() for t in resultado["tickets"]]

        return jsonify(ConfirmarResponse(
            estado="confirmado",
            compra_id=resultado["compra_id"],
            tickets=tickets,
            mensaje="Compra confirmada exitosamente",
        ).model_dump()), 200

    finally:
        r.close()


# ── GET /api/v1/compras/cola/estado ─────────────────────────────────────────
@compras_bp.route("/cola/estado", methods=["GET"])
def estado_cola():
    r = get_redis()
    try:
        return jsonify({"longitud": longitud_cola(r)}), 200
    finally:
        r.close()
