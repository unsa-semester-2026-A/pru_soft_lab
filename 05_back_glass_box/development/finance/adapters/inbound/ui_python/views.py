"""Input validation functions for the finance UI.

Each function validates a single field from a UI form, converting raw
string input into typed Python values or raising ValueError with a
message suitable for display in the interface.
"""

from __future__ import annotations

from decimal import Decimal, InvalidOperation


def validate_amount(value: str) -> Decimal:
    """Validate and convert a user-entered amount string.

    Args:
        value: Raw string from a UI entry widget.

    Returns:
        The amount as a Decimal if valid.

    Raises:
        ValueError: If empty, non-numeric, or not greater than zero.
    """
    if not value.strip():
        raise ValueError("El campo monto no puede estar vacío.")
    try:
        amount = Decimal(value.strip())
    except InvalidOperation:
        raise ValueError("Debe ingresar un número válido.")
    if amount <= Decimal("0"):
        raise ValueError("El monto debe ser mayor a 0.")
    return amount


def validate_name(value: str) -> str:
    """Validate that a name field is not empty or whitespace-only.

    Args:
        value: Raw string from a UI entry widget.

    Returns:
        The stripped name string if valid.

    Raises:
        ValueError: If the value is empty or whitespace-only.
    """
    if not value.strip():
        raise ValueError("El nombre no puede estar vacío.")
    return value.strip()


def validate_month(value: str) -> int:
    """Validate and convert a user-entered month string.

    Args:
        value: Raw string from a UI entry widget.

    Returns:
        The month as an integer between 1 and 12.

    Raises:
        ValueError: If not an integer or outside the range 1-12.
    """
    if not value.strip().isdigit():
        raise ValueError("El mes debe ser un número entero.")
    month = int(value.strip())
    if not 1 <= month <= 12:
        raise ValueError("El mes debe estar entre 1 y 12.")
    return month


def validate_year(value: str) -> int:
    """Validate and convert a user-entered year string.

    Args:
        value: Raw string from a UI entry widget.

    Returns:
        The year as an integer >= 2000.

    Raises:
        ValueError: If not numeric or unreasonably small.
    """
    if not value.strip().isdigit():
        raise ValueError("El año debe ser un número entero.")
    year = int(value.strip())
    if year < 2000:
        raise ValueError("El año debe ser 2000 o posterior.")
    return year
