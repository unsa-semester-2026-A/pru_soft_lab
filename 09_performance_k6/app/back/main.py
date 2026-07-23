"""Entrypoint del backend Flask - TicketPass.

Sistema de venta de entradas de alto rendimiento.
Flask + Gunicorn + Redis + PostgreSQL.

Buenas prácticas aplicadas (flask-python):
- Application factory pattern
- Error handlers customizados
- Logging estructurado
- Blueprints para modularidad
"""

import logging

from flask import Flask, jsonify

from src.config import config
from src.database import db


def create_app() -> Flask:
    """Factory de la aplicación Flask."""
    app = Flask(__name__)

    # ── Configuración ────────────────────────────────────────────────────────
    app.config["SQLALCHEMY_DATABASE_URI"] = config.SQLALCHEMY_DATABASE_URI
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # ── Logging (flask-python) ───────────────────────────────────────────────
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )
    app.logger.setLevel(logging.INFO)

    # ── Inicializar extensiones ──────────────────────────────────────────────
    db.init_app(app)

    # ── Crear tablas ─────────────────────────────────────────────────────────
    with app.app_context():
        from src.models.db_models import Asistente, Compra  # noqa: F401
        db.create_all()
        app.logger.info("Tablas PostgreSQL inicializadas")

    # ── Registrar blueprints (flask-python) ──────────────────────────────────
    from src.api import register_routes
    register_routes(app)

    # ── Health check ─────────────────────────────────────────────────────────
    @app.route("/health")
    def health():
        return jsonify({
            "status": "ok",
            "service": "ticketpass-api",
            "version": "0.1.0",
        }), 200

    # ── Error handlers (flask-python) ────────────────────────────────────────
    @app.errorhandler(400)
    def bad_request(e):
        return jsonify({"error": "Bad Request", "detalle": str(e)}), 400

    @app.errorhandler(404)
    def not_found(e):
        return jsonify({"error": "Not Found", "detalle": str(e)}), 404

    @app.errorhandler(408)
    def request_timeout(e):
        return jsonify({"error": "Request Timeout", "detalle": str(e)}), 408

    @app.errorhandler(409)
    def conflict(e):
        return jsonify({"error": "Conflict", "detalle": str(e)}), 409

    @app.errorhandler(500)
    def internal_error(e):
        app.logger.error(f"Error interno: {e}")
        return jsonify({"error": "Internal Server Error", "detalle": "Error interno del servidor"}), 500

    return app


if __name__ == "__main__":
    app = create_app()
    app.run(
        host=config.FLASK_HOST,
        port=config.FLASK_PORT,
        debug=config.FLASK_DEBUG,
    )
