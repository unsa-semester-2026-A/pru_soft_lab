"""Rutas para el panel de administración."""

from flask import Blueprint, jsonify
from src.database import db
from src.models.db_models import Compra, Asistente
from src.models.schemas import CompraResponse, StatsResponse
from src.services.redis_queue import get_redis
from src.services.seat_map import obtener_eventos

admin_bp = Blueprint("admin", __name__, url_prefix="/api/v1/admin")


def _obtener_nombre_evento(r, evento_id: str) -> str:
    """Obtiene el nombre del evento desde Redis."""
    key = f"ticketpass:eventos:{evento_id}:info"
    nombre = r.hget(key, "nombre")
    return nombre if nombre else evento_id


# ── GET /api/v1/admin/stats ─────────────────────────────────────────────────
@admin_bp.route("/stats", methods=["GET"])
def obtener_stats():
    r = get_redis()
    try:
        eventos = obtener_eventos(r)

        compras = db.session.query(Compra).all()
        asistentes = db.session.query(Asistente).all()

        total_compras = len(compras)
        total_asistentes = len(asistentes)
        ingresos = sum(c.precio_total for c in compras) if compras else 0

        return jsonify(StatsResponse(
            total_eventos=len(eventos),
            total_compras=total_compras,
            total_asistentes=total_asistentes,
            ingresos_totales=ingresos,
        ).model_dump()), 200
    finally:
        r.close()


# ── GET /api/v1/admin/compras ───────────────────────────────────────────────
@admin_bp.route("/compras", methods=["GET"])
def listar_compras():
    r = get_redis()
    try:
        compras = db.session.query(Compra).order_by(Compra.fecha_compra.desc()).all()

        resultado = []
        for c in compras:
            asistentes = db.session.query(Asistente).filter(Asistente.compra_id == c.id).all()
            evento_nombre = _obtener_nombre_evento(r, c.evento_id)
            resultado.append(CompraResponse(
                id=str(c.id),
                evento_id=c.evento_id,
                evento_nombre=evento_nombre,
                comprador_nombre=c.nombre_comprador,
                comprador_email=getattr(c, "email_comprador", ""),
                comprador_dni=getattr(c, "dni_comprador", ""),
                zona=c.zona_id,
                cantidad=c.cantidad,
                total=c.precio_total,
                estado=c.estado,
                fecha=c.fecha_compra.isoformat() if c.fecha_compra else "",
                asistentes=[{"nombre": a.nombre_asistente, "documento": a.documento_asistente} for a in asistentes],
            ).model_dump())

        return jsonify(resultado), 200
    finally:
        r.close()


# ── GET /api/v1/admin/asistentes ────────────────────────────────────────────
@admin_bp.route("/asistentes", methods=["GET"])
def listar_asistentes():
    r = get_redis()
    try:
        asistentes = db.session.query(Asistente).all()

        resultado = []
        for a in asistentes:
            evento_nombre = _obtener_nombre_evento(r, a.evento_id)
            resultado.append({
                "id": str(a.id),
                "nombre": a.nombre_asistente,
                "documento": a.documento_asistente,
                "evento_id": a.evento_id,
                "evento_nombre": evento_nombre,
                "zona": a.zona_id,
                "ticket_id": a.ticket_id,
                "precio": a.precio,
            })

        return jsonify(resultado), 200
    finally:
        r.close()
