"""Tests for the finance UI validation layer and DummyFinanceService.

Uses Black Box Testing methodology:
- PE  = Partición de Equivalencia
- AVL = Análisis de Valores Límite

All tests use DummyFinanceService to remain independent of the real
FinanceService, memory repositories, and domain entities.
"""

from __future__ import annotations

from decimal import Decimal
from uuid import uuid4

import pytest

from finance.adapters.inbound.ui_python.dummy_service import (
    DummyFinanceService,
    InsufficientFundsError,
)
from finance.adapters.inbound.ui_python.views import (
    validate_amount,
    validate_month,
    validate_name,
    validate_year,
)

# ─────────────────────────────────────────────────────────────
# Fixtures
# ─────────────────────────────────────────────────────────────


@pytest.fixture
def service() -> DummyFinanceService:
    """Fresh DummyFinanceService instance for each test."""
    return DummyFinanceService()


# ─────────────────────────────────────────────────────────────
# validate_amount
# ─────────────────────────────────────────────────────────────


class TestValidateAmount:
    """PE and AVL tests for the amount input field."""

    def test_letras_lanza_error(self) -> None:
        """PE: alphabetic input must be rejected."""
        with pytest.raises(ValueError, match="número"):
            validate_amount("abc")

    def test_vacio_lanza_error(self) -> None:
        """PE: empty string must be rejected."""
        with pytest.raises(ValueError, match="vacío"):
            validate_amount("")

    def test_solo_espacios_lanza_error(self) -> None:
        """PE: whitespace-only string must be rejected."""
        with pytest.raises(ValueError, match="vacío"):
            validate_amount("   ")

    def test_negativo_lanza_error(self) -> None:
        """PE: negative amount must be rejected."""
        with pytest.raises(ValueError, match="mayor"):
            validate_amount("-10")

    def test_cero_lanza_error(self) -> None:
        """AVL: zero is the lower forbidden boundary."""
        with pytest.raises(ValueError, match="mayor"):
            validate_amount("0")

    def test_minimo_valido_pasa(self) -> None:
        """AVL: 0.01 is the minimum allowed value."""
        assert validate_amount("0.01") == Decimal("0.01")

    def test_decimal_valido_pasa(self) -> None:
        """PE: a normal positive decimal must be accepted."""
        assert validate_amount("150.50") == Decimal("150.50")

    def test_entero_como_string_pasa(self) -> None:
        """PE: integer string must be converted correctly."""
        assert validate_amount("200") == Decimal("200")


# ─────────────────────────────────────────────────────────────
# validate_name
# ─────────────────────────────────────────────────────────────


class TestValidateName:
    """PE tests for text name fields."""

    def test_vacio_lanza_error(self) -> None:
        """PE: empty name must be rejected."""
        with pytest.raises(ValueError, match="vacío"):
            validate_name("")

    def test_solo_espacios_lanza_error(self) -> None:
        """PE: whitespace-only name must be rejected."""
        with pytest.raises(ValueError, match="vacío"):
            validate_name("   ")

    def test_nombre_valido_pasa(self) -> None:
        """PE: a real name must be accepted and stripped."""
        assert validate_name("  Ahorros BCP  ") == "Ahorros BCP"

    def test_nombre_minimo_un_caracter(self) -> None:
        """AVL: a single non-space character is the minimum valid name."""
        assert validate_name("A") == "A"


# ─────────────────────────────────────────────────────────────
# validate_month
# ─────────────────────────────────────────────────────────────


class TestValidateMonth:
    """PE and AVL tests for the month field (1-12)."""

    def test_texto_lanza_error(self) -> None:
        """PE: alphabetic month must be rejected."""
        with pytest.raises(ValueError, match="número"):
            validate_month("marzo")

    def test_cero_lanza_error(self) -> None:
        """AVL: month 0 is below the lower boundary."""
        with pytest.raises(ValueError, match="entre 1 y 12"):
            validate_month("0")

    def test_enero_pasa(self) -> None:
        """AVL: month 1 is the lower boundary."""
        assert validate_month("1") == 1

    def test_diciembre_pasa(self) -> None:
        """AVL: month 12 is the upper boundary."""
        assert validate_month("12") == 12

    def test_mes_13_lanza_error(self) -> None:
        """AVL: month 13 exceeds the upper boundary."""
        with pytest.raises(ValueError, match="entre 1 y 12"):
            validate_month("13")

    def test_mes_valido_pasa(self) -> None:
        """PE: a mid-range month must be accepted."""
        assert validate_month("5") == 5


# ─────────────────────────────────────────────────────────────
# validate_year
# ─────────────────────────────────────────────────────────────


class TestValidateYear:
    """PE and AVL tests for the year field."""

    def test_texto_lanza_error(self) -> None:
        """PE: alphabetic year must be rejected."""
        with pytest.raises(ValueError, match="número"):
            validate_year("veinte")

    def test_anio_limite_inferior_pasa(self) -> None:
        """AVL: year 2000 is the minimum allowed."""
        assert validate_year("2000") == 2000

    def test_anio_inferior_prohibido(self) -> None:
        """AVL: year 1999 is below the allowed boundary."""
        with pytest.raises(ValueError, match="2000"):
            validate_year("1999")

    def test_anio_valido_pasa(self) -> None:
        """PE: a current year must be accepted."""
        assert validate_year("2026") == 2026


# ─────────────────────────────────────────────────────────────
# DummyFinanceService — create_account
# ─────────────────────────────────────────────────────────────


class TestCreateAccount:
    """PE tests for DummyFinanceService.create_account."""

    def test_datos_validos_retorna_account(self, service: DummyFinanceService) -> None:
        """PE: valid inputs must return an Account with correct fields."""
        account = service.create_account(name="Sueldo", bank="BCP")
        assert account.name == "Sueldo"
        assert account.bank == "BCP"
        assert account.current_balance == Decimal("0.00")
        assert account.is_active is True

    def test_nombre_vacio_lanza_error(self, service: DummyFinanceService) -> None:
        """PE: empty account name must be rejected by the service."""
        with pytest.raises(ValueError):
            service.create_account(name="", bank="BCP")

    def test_banco_vacio_lanza_error(self, service: DummyFinanceService) -> None:
        """PE: empty bank name must be rejected by the service."""
        with pytest.raises(ValueError):
            service.create_account(name="Sueldo", bank="")


# ─────────────────────────────────────────────────────────────
# DummyFinanceService — create_category
# ─────────────────────────────────────────────────────────────


class TestCreateCategory:
    """PE tests for DummyFinanceService.create_category."""

    def test_nombre_valido_retorna_category(
        self, service: DummyFinanceService
    ) -> None:
        """PE: valid name must return a Category."""
        category = service.create_category(name="Transporte")
        assert category.name == "Transporte"
        assert category.is_active is True

    def test_nombre_vacio_lanza_error(self, service: DummyFinanceService) -> None:
        """PE: empty category name must be rejected."""
        with pytest.raises(ValueError):
            service.create_category(name="")


# ─────────────────────────────────────────────────────────────
# DummyFinanceService — register_transaction
# ─────────────────────────────────────────────────────────────


class TestRegisterTransaction:
    """PE and AVL tests for DummyFinanceService.register_transaction."""

    def test_income_valido_retorna_tupla(self, service: DummyFinanceService) -> None:
        """PE: valid INCOME must return (Transaction, False)."""
        txn, exceeded = service.register_transaction(
            account_id=uuid4(),
            category_id=None,
            transaction_type="INCOME",
            amount=Decimal("500.00"),
            description="Sueldo mayo",
        )
        assert txn.transaction_type.value == "INCOME"
        assert exceeded is False

    def test_expense_valido_retorna_tupla(self, service: DummyFinanceService) -> None:
        """PE: valid EXPENSE within balance must return (Transaction, bool)."""
        txn, _ = service.register_transaction(
            account_id=uuid4(),
            category_id=uuid4(),
            transaction_type="EXPENSE",
            amount=Decimal("40.00"),
            description="Taxi",
        )
        assert txn.transaction_type.value == "EXPENSE"

    def test_monto_cero_lanza_error(self, service: DummyFinanceService) -> None:
        """AVL: amount of 0 is the lower forbidden boundary."""
        with pytest.raises(ValueError, match="mayor"):
            service.register_transaction(
                account_id=uuid4(),
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("0"),
                description="Test",
            )

    def test_tipo_invalido_lanza_error(self, service: DummyFinanceService) -> None:
        """PE: an unknown transaction type must be rejected."""
        with pytest.raises(ValueError, match="inválido"):
            service.register_transaction(
                account_id=uuid4(),
                category_id=None,
                transaction_type="TRANSFERENCIA",
                amount=Decimal("100"),
                description="Test",
            )

    def test_fondos_insuficientes_lanza_error(
        self, service: DummyFinanceService
    ) -> None:
        """PE: expense exceeding balance must raise InsufficientFundsError."""
        with pytest.raises(InsufficientFundsError):
            service.register_transaction(
                account_id=uuid4(),
                category_id=uuid4(),
                transaction_type="EXPENSE",
                amount=Decimal("9999.00"),
                description="Gasto enorme",
            )
