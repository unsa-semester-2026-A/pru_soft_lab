import re
from datetime import datetime

from pydantic import BaseModel, EmailStr, Field, field_validator

# ── Regex patterns ───────────────────────────────────────────────────────────
UUID_REGEX = re.compile(
    r"^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    re.IGNORECASE,
)
DNI_REGEX = re.compile(r"^[0-9]{7,15}$")
NOMBRE_REGEX = re.compile(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+$")


# ── Zona ─────────────────────────────────────────────────────────────────────
class ZonaSchema(BaseModel):
    id: str = Field(..., pattern=r"^[a-zA-Z0-9_-]{1,50}$")
    nombre: str = Field(..., min_length=1, max_length=100)
    precio: float = Field(gt=0, le=10000)
    stock_total: int = Field(ge=0, le=100000)
    stock_disponible: int = Field(default=0, ge=0, le=100000)


# ── Evento ───────────────────────────────────────────────────────────────────
class EventoSchema(BaseModel):
    id: str = Field(..., pattern=r"^[a-zA-Z0-9_-]{1,50}$")
    nombre: str = Field(..., min_length=1, max_length=200)
    artista: str = Field(..., min_length=1, max_length=200)
    venue: str = Field(..., min_length=1, max_length=300)
    fecha: str
    estado: str = Field(..., pattern=r"^(activo|agotado|finalizado)$")
    imagen_url: str = Field(default="", max_length=500)
    zonas: list[ZonaSchema]

    @field_validator("fecha")
    @classmethod
    def validar_fecha_iso(cls, v: str) -> str:
        try:
            datetime.fromisoformat(v)
        except ValueError:
            raise ValueError("La fecha debe estar en formato ISO 8601")
        return v

class EventoCreateRequest(BaseModel):
    nombre: str = Field(..., min_length=3, max_length=200)
    artista: str = Field(..., min_length=2, max_length=200)
    venue: str = Field(..., min_length=3, max_length=300)
    fecha: str
    categoria: str = Field(..., pattern=r"^(conciertos|teatro|deportes|entretenimiento)$")
    imagen_url: str = Field(default="", max_length=500)
    descripcion: str = Field(default="", max_length=1000)
    zonas: list[ZonaSchema]

    @field_validator("fecha")
    @classmethod
    def validar_fecha(cls, v: str) -> str:
        try:
            datetime.fromisoformat(v)
        except ValueError:
            raise ValueError("La fecha debe estar en formato ISO 8601")
        return v


# ── Asistente ────────────────────────────────────────────────────────────────
class AsistenteInput(BaseModel):
    nombre: str = Field(..., min_length=2, max_length=200)
    documento: str = Field(..., min_length=7, max_length=15)

    @field_validator("nombre")
    @classmethod
    def limpiar_nombre(cls, v: str) -> str:
        v = " ".join(v.split()).strip()
        if len(v) < 2:
            raise ValueError("El nombre debe tener al menos 2 caracteres")
        if not NOMBRE_REGEX.match(v):
            raise ValueError("El nombre solo puede contener letras y espacios")
        return v

    @field_validator("documento")
    @classmethod
    def validar_documento(cls, v: str) -> str:
        v = v.strip()
        if not DNI_REGEX.match(v):
            raise ValueError("El documento debe ser numérico (7-15 dígitos)")
        return v


# ── Reserva ──────────────────────────────────────────────────────────────────
class ReservaRequest(BaseModel):
    evento_id: str = Field(..., min_length=1, max_length=50, pattern=r"^[a-zA-Z0-9_-]+$")
    zona_id: str = Field(..., min_length=1, max_length=50, pattern=r"^[a-zA-Z0-9_-]+$")
    cantidad: int = Field(ge=1, le=5)
    nombre_comprador: str = Field(..., min_length=2, max_length=200)
    email_comprador: EmailStr
    dni_comprador: str = Field(..., min_length=7, max_length=15)

    @field_validator("nombre_comprador")
    @classmethod
    def limpiar_nombre(cls, v: str) -> str:
        v = " ".join(v.split()).strip()
        if not NOMBRE_REGEX.match(v):
            raise ValueError("El nombre solo puede contener letras y espacios")
        return v

    @field_validator("dni_comprador")
    @classmethod
    def validar_dni(cls, v: str) -> str:
        v = v.strip()
        if not DNI_REGEX.match(v):
            raise ValueError("El DNI debe ser numérico (7-15 dígitos)")
        return v


# ── Confirmar compra ─────────────────────────────────────────────────────────
class ConfirmarRequest(BaseModel):
    reserva_id: str = Field(..., min_length=36, max_length=36)
    asistentes: list[AsistenteInput] = Field(..., min_length=1, max_length=5)

    @field_validator("reserva_id")
    @classmethod
    def validar_uuid(cls, v: str) -> str:
        if not UUID_REGEX.match(v):
            raise ValueError("El reserva_id debe ser un UUID v4 válido")
        return v


# ── Responses ────────────────────────────────────────────────────────────────
class ReservaResponse(BaseModel):
    reserva_id: str
    evento_id: str
    zona_id: str
    cantidad: int
    precio_unitario: float
    precio_total: float
    expira_en_segundos: int
    estado: str


class TicketResponse(BaseModel):
    ticket_id: str
    reserva_id: str
    evento_id: str
    zona_id: str
    nombre_asistente: str
    documento_asistente: str
    precio: float
    fecha_compra: str


class ConfirmarResponse(BaseModel):
    estado: str
    compra_id: str
    tickets: list[TicketResponse]
    mensaje: str


class ErrorResponse(BaseModel):
    error: str = Field(..., min_length=1, max_length=500)
    detalle: str = Field(..., max_length=1000)


# ── Admin Response ───────────────────────────────────────────────────────────
class CompraResponse(BaseModel):
    id: str
    evento_id: str
    evento_nombre: str
    comprador_nombre: str
    comprador_email: str
    comprador_dni: str
    zona: str
    cantidad: int
    total: float
    estado: str
    fecha: str
    asistentes: list[dict]

class StatsResponse(BaseModel):
    total_eventos: int
    total_compras: int
    total_asistentes: int
    ingresos_totales: float
