"""Tests for UI validation and dummy service using EP and BVA."""

from __future__ import annotations

from decimal import Decimal
from uuid import uuid4

import pytest

from finance.adapters.inbound.ui_python.dummy_service import (
    DummyFinanceService,
    InsufficientFundsError,
)
from finance.adapters.inbound.ui_python.views import (
    validate_account_name,
    validate_amount,
    validate_bank_name,
    validate_category_name,
    validate_month,
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
# Validation Tests (Parametrized EP & BVA)
# ─────────────────────────────────────────────────────────────


class TestValidators:
    """Consolidated validator tests using parametrization."""

    @pytest.mark.parametrize(
        "value, expected",
        [
            ("150.50", Decimal("150.50")),  # PE: Valid decimal
            ("200", Decimal("200")),  # PE: Valid integer
            ("0.01", Decimal("0.01")),  # AVL: Minimum valid
        ],
    )
    def test_validate_amount_valid(self, value: str, expected: Decimal) -> None:
        assert validate_amount(value) == expected

    @pytest.mark.parametrize(
        "value, match",
        [
            ("abc", "número"),  # PE: Non-numeric
            ("", "vacío"),  # PE: Empty
            ("   ", "vacío"),  # PE: Whitespace
            ("-10", "mayor a 0"),  # PE: Negative
            ("0", "mayor a 0"),  # AVL: Zero
        ],
    )
    def test_validate_amount_invalid(self, value: str, match: str) -> None:
        with pytest.raises(ValueError, match=match):
            validate_amount(value)

    @pytest.mark.parametrize(
        "value, expected",
        [
            ("  Ahorros  ", "Ahorros"),  # PE: Stripping
            ("AB", "AB"),  # AVL: Min length
            ("Ahorros Personales", "Ahorros Personales"),  # PE: With space
        ],
    )
    def test_validate_account_name_valid(self, value: str, expected: str) -> None:
        assert validate_account_name(value) == expected

    @pytest.mark.parametrize(
        "value, match",
        [
            ("", "vacio"),  # PE: Empty
            ("   ", "vacio"),  # PE: Whitespace
            ("A", "al menos 2"),  # AVL: Too short
            ("123", "solo debe contener letras"),  # PE: Numbers
            ("Cuenta@BCP", "solo debe contener letras"),  # PE: Special chars
        ],
    )
    def test_validate_account_name_invalid(self, value: str, match: str) -> None:
        with pytest.raises(ValueError, match=match):
            validate_account_name(value)

    @pytest.mark.parametrize(
        "value, expected",
        [
            ("  BCP  ", "BCP"),  # PE: Stripping
            ("Interbank S.A.", "Interbank S.A."),  # PE: With dots
            ("Banco 123", "Banco 123"),  # PE: With numbers
        ],
    )
    def test_validate_bank_name_valid(self, value: str, expected: str) -> None:
        assert validate_bank_name(value) == expected

    @pytest.mark.parametrize(
        "value, match",
        [
            ("", "vacio"),  # PE: Empty
            ("   ", "vacio"),  # PE: Whitespace
        ],
    )
    def test_validate_bank_name_invalid(self, value: str, match: str) -> None:
        with pytest.raises(ValueError, match=match):
            validate_bank_name(value)

    @pytest.mark.parametrize(
        "value, expected",
        [
            ("  Transporte  ", "Transporte"),  # PE: Stripping
            ("Servicios Basicos", "Servicios Basicos"),  # PE: With space
        ],
    )
    def test_validate_category_name_valid(self, value: str, expected: str) -> None:
        assert validate_category_name(value) == expected

    @pytest.mark.parametrize(
        "value, match",
        [
            ("", "vacio"),  # PE: Empty
            ("   ", "vacio"),  # PE: Whitespace
        ],
    )
    def test_validate_category_name_invalid(self, value: str, match: str) -> None:
        with pytest.raises(ValueError, match=match):
            validate_category_name(value)

    @pytest.mark.parametrize(
        "value, expected",
        [
            ("1", 1),  # AVL: Lower bound
            ("12", 12),  # AVL: Upper bound
            ("6", 6),  # PE: Middle
        ],
    )
    def test_validate_month_valid(self, value: str, expected: int) -> None:
        assert validate_month(value) == expected

    @pytest.mark.parametrize(
        "value, match",
        [
            ("0", "entre 1 y 12"),  # AVL: Below bound
            ("13", "entre 1 y 12"),  # AVL: Above bound
            ("marzo", "entero"),  # PE: Text
        ],
    )
    def test_validate_month_invalid(self, value: str, match: str) -> None:
        with pytest.raises(ValueError, match=match):
            validate_month(value)

    @pytest.mark.parametrize(
        "value, expected",
        [
            ("2000", 2000),  # AVL: Lower bound
            ("2026", 2026),  # PE: Current
        ],
    )
    def test_validate_year_valid(self, value: str, expected: int) -> None:
        assert validate_year(value) == expected

    @pytest.mark.parametrize(
        "value, match",
        [
            ("1999", "2000 o posterior"),  # AVL: Below bound
            ("veinte", "entero"),  # PE: Text
        ],
    )
    def test_validate_year_invalid(self, value: str, match: str) -> None:
        with pytest.raises(ValueError, match=match):
            validate_year(value)


# ─────────────────────────────────────────────────────────────
# DummyService Tests
# ─────────────────────────────────────────────────────────────


class TestDummyService:
    """Behavioral tests for DummyFinanceService."""

    def test_register_income_updates_simulated_balance(
        self, service: DummyFinanceService
    ) -> None:
        """PE: Income increases balance."""
        service.register_transaction(uuid4(), None, "INCOME", Decimal("100"), "T")
        assert service._balance == Decimal("1100.00")

    def test_register_expense_fails_insufficient_funds(
        self, service: DummyFinanceService
    ) -> None:
        """PE: Overspending raises error."""
        with pytest.raises(InsufficientFundsError):
            service.register_transaction(
                uuid4(), uuid4(), "EXPENSE", Decimal("1000.01"), "T"
            )

    def test_list_active_filters_deactivated(
        self, service: DummyFinanceService
    ) -> None:
        """PE: List methods respect is_active."""
        acc = service.create_account("Ahorros", "BCP")
        service.deactivate_account(acc.id)
        assert len(service.list_active_accounts()) == 0
