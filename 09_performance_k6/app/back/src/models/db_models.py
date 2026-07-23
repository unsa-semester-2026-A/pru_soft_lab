"""Modelos SQLAlchemy para persistencia en PostgreSQL.

Buenas prácticas aplicadas (sqlalchemy-postgres, sqlalchemy-alembic):
- Índices en columnas de búsqueda frecuente
- Constraints para integridad de datos
- Timestamps con server_default
- Separación de modelos y schemas
"""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, Float, Integer, String, func
from sqlalchemy.dialects.postgresql import UUID

from src.database import db


class Compra(db.Model):
    """Registro de una compra confirmada.

    Índices:
    - reserva_id: búsqueda rápida por reserva
    - evento_id: filtrado por evento
    """

    __tablename__ = "compras"

    id = db.Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    reserva_id = db.Column(
        String(36),
        unique=True,
        nullable=False,
        index=True,
    )
    evento_id = db.Column(
        String(50),
        nullable=False,
        index=True,
    )
    zona_id = db.Column(
        String(50),
        nullable=False,
    )
    cantidad = db.Column(
        Integer,
        nullable=False,
    )
    precio_unitario = db.Column(
        Float,
        nullable=False,
    )
    precio_total = db.Column(
        Float,
        nullable=False,
    )
    nombre_comprador = db.Column(
        String(200),
        nullable=False,
    )
    email_comprador = db.Column(
        String(200),
        nullable=False,
        default="",
    )
    dni_comprador = db.Column(
        String(15),
        nullable=False,
        default="",
    )
    estado = db.Column(
        String(20),
        nullable=False,
        default="confirmado",
        index=True,
    )
    fecha_compra = db.Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )


class Asistente(db.Model):
    """Registro individual de un asistente (ticket).

    Índices:
    - compra_id: relación con compra
    - reserva_id: búsqueda por reserva
    - evento_id: filtrado por evento
    - ticket_id: búsqueda única de ticket
    """

    __tablename__ = "asistentes"

    id = db.Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )
    compra_id = db.Column(
        UUID(as_uuid=True),
        nullable=False,
        index=True,
    )
    reserva_id = db.Column(
        String(36),
        nullable=False,
        index=True,
    )
    evento_id = db.Column(
        String(50),
        nullable=False,
        index=True,
    )
    zona_id = db.Column(
        String(50),
        nullable=False,
    )
    nombre_asistente = db.Column(
        String(200),
        nullable=False,
    )
    documento_asistente = db.Column(
        String(50),
        nullable=False,
    )
    precio = db.Column(
        Float,
        nullable=False,
    )
    ticket_id = db.Column(
        String(36),
        unique=True,
        nullable=False,
        index=True,
    )
    fecha_registro = db.Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
