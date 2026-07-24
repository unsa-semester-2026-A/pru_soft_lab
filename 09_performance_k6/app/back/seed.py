"""Script para sembrar datos de ejemplo en Redis + PostgreSQL.

Ejecutar con: uv run python seed.py
"""

import json
import uuid

from redis import Redis

from src.config import config
from src.database import db
from main import create_app
from src.models.db_models import Asistente, Compra
from src.services.redis_queue import get_redis


EVENTOS_SEED = [
    {
        "id": "conc-001",
        "info": {
            "nombre": "Lana Del Rey: The Did You Know Tour",
            "artista": "Lana Del Rey",
            "venue": "Estadio Nacional, Lima",
            "fecha": "2026-08-15T21:00:00",
            "estado": "activo",
            "imagen_url": "https://www.wembleystadium.com/-/media/Project/WembleyStadium/events/2023/LDR/Updated-2nd-night/Lana-Del-Rey-LDN-1400x620---Main-headline-image.ashx",
            "categoria": "conciertos",
        },
        "zonas": [
            {"id": "vip", "nombre": "VIP", "precio": 350.0, "stock_total": 50},
            {"id": "pref", "nombre": "Preferencial", "precio": 200.0, "stock_total": 150},
            {"id": "gen", "nombre": "General", "precio": 100.0, "stock_total": 300},
        ],
    },
    {
        "id": "conc-002",
        "info": {
            "nombre": "The Strokes: Reality Awaits Tour",
            "artista": "The Strokes",
            "venue": "Arena Lima",
            "fecha": "2026-09-20T20:00:00",
            "estado": "activo",
            "imagen_url": "https://newsroom.livenation.com/wp-content/uploads/2026/04/Static_Newsroom_1720x720_TheStrokes_2026_National-1024x429.jpg",
            "categoria": "conciertos",
        },
        "zonas": [
            {"id": "vip", "nombre": "VIP", "precio": 280.0, "stock_total": 40},
            {"id": "pref", "nombre": "Preferencial", "precio": 160.0, "stock_total": 120},
            {"id": "gen", "nombre": "General", "precio": 80.0, "stock_total": 250},
        ],
    },
    {
        "id": "conc-003",
        "info": {
            "nombre": "Taylor Swift: The Eras Tour",
            "artista": "Taylor Swift",
            "venue": "Estadio San Marcos",
            "fecha": "2026-10-05T21:30:00",
            "estado": "activo",
            "imagen_url": "https://industriamusical.com/wp-content/uploads/2023/09/Taylor_Swift_The_Eras_Tour.jpg",
            "categoria": "conciertos",
        },
        "zonas": [
            {"id": "vip", "nombre": "VIP", "precio": 450.0, "stock_total": 60},
            {"id": "pref", "nombre": "Preferencial", "precio": 280.0, "stock_total": 100},
            {"id": "gen", "nombre": "General", "precio": 150.0, "stock_total": 200},
        ],
    },
    {
        "id": "conc-004",
        "info": {
            "nombre": "Hayley Williams: The Hayley Williams Show",
            "artista": "Hayley Williams",
            "venue": "Costa 21, Lima, Perú",
            "fecha": "2026-11-21T20:30:00",
            "estado": "activo",
            "imagen_url": "https://newsroom.livenation.com/wp-content/uploads/2026/05/Static_LiveNation-PR_1720x720_HayleyWilliams_2026_National-1024x429.jpg",
            "categoria": "conciertos",
        },
        "zonas": [
            {"id": "vip", "nombre": "VIP", "precio": 320.0, "stock_total": 30},
            {"id": "pref", "nombre": "Preferencial", "precio": 200.0, "stock_total": 80},
            {"id": "gen", "nombre": "General", "precio": 100.0, "stock_total": 180},
        ],
    },
    {
        "id": "conc-005",
        "info": {
            "nombre": "Caifanes en Lima",
            "artista": "Caifanes",
            "venue": "Estadio Nacional, Lima",
            "fecha": "2026-08-15T21:00:00",
            "estado": "activo",
            "imagen_url": "https://cdn.getcrowder.com/images/6716abbd-c0ba-455d-95cf-d362ad5372d5-caifanesfullbannerpagemanizales.gif",
            "categoria": "conciertos",
        },
        "zonas": [
            {"id": "vip", "nombre": "VIP", "precio": 350.0, "stock_total": 50},
            {"id": "pref", "nombre": "Preferencial", "precio": 200.0, "stock_total": 150},
            {"id": "gen", "nombre": "General", "precio": 80.0, "stock_total": 300},
        ],
    },
]


def seed_redis(r: Redis) -> None:
    """Siembra los datos de ejemplo en Redis."""
    for key in r.keys("ticketpass:*"):
        r.delete(key)

    for evento in EVENTOS_SEED:
        eid = evento["id"]
        r.hset(f"ticketpass:eventos:{eid}:info", mapping=evento["info"])

        for zona in evento["zonas"]:
            r.hset(
                f"ticketpass:eventos:{eid}:zonas:{zona['id']}",
                mapping={
                    "nombre": zona["nombre"],
                    "precio": str(zona["precio"]),
                    "stock_total": str(zona["stock_total"]),
                },
            )
            r.set(
                f"ticketpass:eventos:{eid}:stock:{zona['id']}",
                str(zona["stock_total"]),
            )

    print(f"✓ {len(EVENTOS_SEED)} eventos sembrados en Redis")


def seed_postgres(app) -> None:
    """Siembra datos de ejemplo en PostgreSQL."""
    with app.app_context():
        db.session.query(Asistente).delete()
        db.session.query(Compra).delete()
        db.session.commit()

        compras_ejemplo = [
            {
                "reserva_id": str(uuid.uuid4()),
                "evento_id": "conc-001",
                "zona_id": "vip",
                "cantidad": 2,
                "precio_unitario": 350.0,
                "precio_total": 700.0,
                "nombre_comprador": "Juan Pérez",
                "email_comprador": "juan.perez@email.com",
                "dni_comprador": "12345678",
                "estado": "confirmado",
            },
            {
                "reserva_id": str(uuid.uuid4()),
                "evento_id": "conc-003",
                "zona_id": "gen",
                "cantidad": 3,
                "precio_unitario": 150.0,
                "precio_total": 450.0,
                "nombre_comprador": "Ana García",
                "email_comprador": "ana.garcia@email.com",
                "dni_comprador": "87654321",
                "estado": "confirmado",
            },
            {
                "reserva_id": str(uuid.uuid4()),
                "evento_id": "conc-002",
                "zona_id": "pref",
                "cantidad": 1,
                "precio_unitario": 160.0,
                "precio_total": 160.0,
                "nombre_comprador": "Carlos Ruiz",
                "email_comprador": "carlos.ruiz@email.com",
                "dni_comprador": "11223344",
                "estado": "confirmado",
            },
        ]

        asistentes_ejemplo = [
            {"compra_idx": 0, "nombre": "Juan Pérez", "documento": "12345678"},
            {"compra_idx": 0, "nombre": "María López", "documento": "87654321"},
            {"compra_idx": 1, "nombre": "Ana García", "documento": "11223344"},
            {"compra_idx": 1, "nombre": "Carlos Ruiz", "documento": "55667788"},
            {"compra_idx": 1, "nombre": "Laura Martín", "documento": "99001122"},
            {"compra_idx": 2, "nombre": "Pedro Sánchez", "documento": "33445566"},
        ]

        compras_creadas = []
        for c in compras_ejemplo:
            compra = Compra(**c)
            db.session.add(compra)
            compras_creadas.append(compra)

        db.session.flush()

        for a in asistentes_ejemplo:
            compra = compras_creadas[a["compra_idx"]]
            asistente = Asistente(
                compra_id=compra.id,
                reserva_id=compra.reserva_id,
                evento_id=compra.evento_id,
                zona_id=compra.zona_id,
                nombre_asistente=a["nombre"],
                documento_asistente=a["documento"],
                precio=compra.precio_unitario,
                ticket_id=str(uuid.uuid4()),
            )
            db.session.add(asistente)

        db.session.commit()
        print(f"✓ {len(compras_ejemplo)} compras y {len(asistentes_ejemplo)} asistentes en PostgreSQL")


if __name__ == "__main__":
    r = get_redis()
    try:
        seed_redis(r)
    finally:
        r.close()

    app = create_app()
    seed_postgres(app)
    print("✓ Seed completado")
