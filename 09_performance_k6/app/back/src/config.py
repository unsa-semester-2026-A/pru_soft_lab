import os

from dotenv import load_dotenv

load_dotenv()


class Config:
    """Configuración central del backend Flask + Gunicorn + Redis + PostgreSQL."""

    # Flask
    FLASK_HOST: str = os.getenv("FLASK_HOST", "0.0.0.0")
    FLASK_PORT: int = int(os.getenv("FLASK_PORT", "5000"))
    FLASK_DEBUG: bool = os.getenv("FLASK_DEBUG", "false").lower() == "true"

    # Gunicorn
    GUNICORN_WORKERS: int = int(os.getenv("GUNICORN_WORKERS", "4"))
    GUNICORN_BIND: str = os.getenv("GUNICORN_BIND", "0.0.0.0:5000")

    # Redis
    REDIS_HOST: str = os.getenv("REDIS_HOST", "localhost")
    REDIS_PORT: int = int(os.getenv("REDIS_PORT", "6379"))
    REDIS_DB: int = int(os.getenv("REDIS_DB", "0"))
    REDIS_URL: str = os.getenv(
        "REDIS_URL", f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}"
    )

    # PostgreSQL
    SQLALCHEMY_DATABASE_URI: str = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5432/ticketpass",
    )

    # Negocio
    RESERVA_TTL_SEGUNDOS: int = int(os.getenv("RESERVA_TTL_SEGUNDOS", "180"))
    MAX_ENTRADAS_POR_PEDIDO: int = int(os.getenv("MAX_ENTRADAS_POR_PEDIDO", "5"))

    # Cola
    COLA_KEY: str = "ticketpass:cola"
    COLA_TIMEOUT_SEGUNDOS: int = int(os.getenv("COLA_TIMEOUT_SEGUNDOS", "10"))


config = Config()
