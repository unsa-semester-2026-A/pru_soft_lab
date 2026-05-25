"""Input validation functions for the finance UI.

Each function validates a single field from a UI form, converting raw
string input into typed Python values or raising ValueError with a
message suitable for display in the interface.
"""

from __future__ import annotations

from decimal import Decimal, InvalidOperation


def validar_amount(valor: str) -> Decimal:
    """Validate and convert a user-entered amount string.

    Args:
        valor: Raw string from a UI entry widget.

    Returns:
        The amount as a Decimal if valid.

    Raises:
        ValueError: If empty, non-numeric, or not greater than zero.
    """
    if not valor.strip():
        raise ValueError("El campo monto no puede estar vacío.")
    try:
        monto = Decimal(valor.strip())
    except InvalidOperation:
        raise ValueError("Debe ingresar un número válido.")
    if monto <= Decimal("0"):
        raise ValueError("El monto debe ser mayor a 0.")
    return monto


def validar_nombre(valor: str) -> str:
    """Validate that a name field is not empty or whitespace-only.

    Args:
        valor: Raw string from a UI entry widget.

    Returns:
        The stripped name string if valid.

    Raises:
        ValueError: If the value is empty or whitespace-only.
    """
    if not valor.strip():
        raise ValueError("El nombre no puede estar vacío.")
    return valor.strip()


def validar_mes(valor: str) -> int:
    """Validate and convert a user-entered month string.

    Args:
        valor: Raw string from a UI entry widget.

    Returns:
        The month as an integer between 1 and 12.

    Raises:
        ValueError: If not an integer or outside the range 1-12.
    """
    if not valor.strip().isdigit():
        raise ValueError("El mes debe ser un número entero.")
    mes = int(valor.strip())
    if not 1 <= mes <= 12:
        raise ValueError("El mes debe estar entre 1 y 12.")
    return mes


def validar_anio(valor: str) -> int:
    """Validate and convert a user-entered year string.

    Args:
        valor: Raw string from a UI entry widget.

    Returns:
        The year as an integer >= 2000.

    Raises:
        ValueError: If not numeric or unreasonably small.
    """
    if not valor.strip().isdigit():
        raise ValueError("El año debe ser un número entero.")
    anio = int(valor.strip())
    if anio < 2000:
        raise ValueError("El año debe ser 2000 o posterior.")
    return anio
