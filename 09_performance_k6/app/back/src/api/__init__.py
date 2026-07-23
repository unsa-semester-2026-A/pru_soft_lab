"""Registro de blueprints del API."""

from flask import Flask

from .eventos import eventos_bp
from .compras import compras_bp
from .admin import admin_bp


def register_routes(app: Flask) -> None:
    """Registra todos los blueprints en la app Flask."""
    app.register_blueprint(eventos_bp)
    app.register_blueprint(compras_bp)
    app.register_blueprint(admin_bp)
