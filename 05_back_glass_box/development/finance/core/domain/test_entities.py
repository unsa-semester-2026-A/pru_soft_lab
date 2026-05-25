"""Tests for domain entities using EP and BVA."""

from datetime import datetime
from decimal import Decimal
from uuid import UUID, uuid4

import pytest

from finance.core.domain.entities import (
    Account,
    Budget,
    InsufficientFundsError,
    Transaction,
    TransactionType,
    User,
)

# ─────────────────────────────────────────────────────────────
# User Tests
# ─────────────────────────────────────────────────────────────


class TestUser:
    """Test suite for User entity."""

    def test_valid_user(self) -> None:
        """PE: Valid user creation."""
        user = User(name="John Doe", email="john@example.com")
        assert user.name == "John Doe"
        assert user.email == "john@example.com"
        assert user.id is not None

    @pytest.mark.parametrize(
        "name, email, error_match",
        [
            ("", "john@example.com", "User name cannot be empty"),
            ("   ", "john@example.com", "User name cannot be empty"),
            ("John", "", "Email cannot be empty"),
            ("John", "invalid-email", "Email must have a valid format"),
        ],
    )
    def test_invalid_user_creation(
        self, name: str, email: str, error_match: str
    ) -> None:
        """PE/AVL: Invalid inputs for user creation."""
        with pytest.raises(ValueError, match=error_match):
            User(name=name, email=email)


# ─────────────────────────────────────────────────────────────
# Account Tests
# ─────────────────────────────────────────────────────────────


class TestAccount:
    """Test suite for Account entity."""

    def test_valid_account(self) -> None:
        """PE: Valid account creation."""
        account = Account(name="Savings", bank="BCP")
        assert account.name == "Savings"
        assert account.bank == "BCP"
        assert account.current_balance == Decimal("0.00")
        assert account.is_active is True

    def test_register_income_and_expense_valid(self) -> None:
        """PE: Registro de ingresos y gastos dentro del saldo."""
        account = Account(name="S", bank="B")
        account.register_income(Decimal("100.00"))
        account.register_expense(Decimal("40.00"))
        assert account.current_balance == Decimal("60.00")

    @pytest.mark.parametrize(
        "name, bank, error_match",
        [
            ("", "BCP", "Account name cannot be empty"),
            ("   ", "BCP", "Account name cannot be empty"),
            ("Savings", "", "Bank name cannot be empty"),
            ("Savings", "   ", "Bank name cannot be empty"),
        ],
    )
    def test_invalid_account_creation(
        self, name: str, bank: str, error_match: str
    ) -> None:
        """PE: Invalid strings for account creation."""
        with pytest.raises(ValueError, match=error_match):
            Account(name=name, bank=bank)

    @pytest.mark.parametrize(
        "amount, expected_balance",
        [
            (Decimal("0.01"), Decimal("0.01")),  # AVL: Minimum positive
            (Decimal("100"), Decimal("100")),  # PE: Normal positive
        ],
    )
    def test_register_income_valid(
        self, amount: Decimal, expected_balance: Decimal
    ) -> None:
        """AVL/PE: Valid income amounts."""
        account = Account(name="S", bank="B")
        account.register_income(amount)
        assert account.current_balance == expected_balance

    @pytest.mark.parametrize(
        "amount",
        [
            Decimal("0.00"),  # AVL: Zero (not positive)
            Decimal("-0.01"),  # AVL: Minimum negative
            Decimal("-100"),  # PE: Large negative
        ],
    )
    def test_register_income_invalid(self, amount: Decimal) -> None:
        """AVL/PE: Invalid income amounts."""
        account = Account(name="S", bank="B")
        with pytest.raises(ValueError, match="Income amount must be positive"):
            account.register_income(amount)

    def test_register_expense_valid_boundary(self) -> None:
        """AVL: Exact balance expense (leaves zero)."""
        account = Account(name="S", bank="B", current_balance=Decimal("100.00"))
        account.register_expense(Decimal("100.00"))
        assert account.current_balance == Decimal("0.00")

    @pytest.mark.parametrize(
        "initial_balance, expense_amount, error_match",
        [
            (
                Decimal("100.00"),
                Decimal("100.01"),
                "Insufficient funds",
            ),  # AVL: 1 cent over
            (
                Decimal("0.00"),
                Decimal("0.01"),
                "Insufficient funds",
            ),  # AVL: Any expense on zero balance
        ],
    )
    def test_register_expense_insufficient_funds(
        self, initial_balance: Decimal, expense_amount: Decimal, error_match: str
    ) -> None:
        """AVL: Insufficient funds boundaries."""
        account = Account(name="S", bank="B", current_balance=initial_balance)
        with pytest.raises(InsufficientFundsError, match=error_match):
            account.register_expense(expense_amount)


# ─────────────────────────────────────────────────────────────
# Budget Tests
# ─────────────────────────────────────────────────────────────


class TestBudget:
    """Test suite for Budget entity."""

    @pytest.mark.parametrize(
        "limit, month, year",
        [
            (Decimal("0.01"), 1, 1900),  # AVL: Minimums
            (Decimal("100.00"), 12, 2026),  # AVL: Max month
        ],
    )
    def test_valid_budget_boundaries(
        self, limit: Decimal, month: int, year: int
    ) -> None:
        """AVL: Valid boundaries for Budget creation."""
        budget = Budget(category_id=uuid4(), month=month, year=year, limit_amount=limit)
        assert budget.limit_amount == limit
        assert budget.month == month
        assert budget.year == year

    @pytest.mark.parametrize(
        "limit, month, year, error_match",
        [
            (Decimal("0.00"), 5, 2026, "greater than 0"),  # AVL: Zero limit
            (Decimal("-1.00"), 5, 2026, "greater than 0"),  # PE: Negative limit
            (Decimal("100"), 0, 2026, "between 1 and 12"),  # AVL: Month < 1
            (Decimal("100"), 13, 2026, "between 1 and 12"),  # AVL: Month > 12
            (Decimal("100"), 5, 1899, "Invalid year"),  # AVL: Year < 1900
        ],
    )
    def test_invalid_budget_boundaries(
        self, limit: Decimal, month: int, year: int, error_match: str
    ) -> None:
        """AVL: Boundary tests for Budget creation."""
        with pytest.raises(ValueError, match=error_match):
            Budget(category_id=uuid4(), month=month, year=year, limit_amount=limit)


# ─────────────────────────────────────────────────────────────
# Transaction Tests
# ─────────────────────────────────────────────────────────────


class TestTransaction:
    """Test suite for Transaction entity."""

    def test_valid_transaction_amount(self) -> None:
        """AVL: Monto de 0.01 (Mínimo aceptado)."""
        tx = Transaction(
            account_id=uuid4(),
            category_id=None,
            transaction_type=TransactionType.INCOME,
            description="Minimum income",
            created_at=datetime.now(),
            amount=Decimal("0.01"),
        )
        assert tx.amount == Decimal("0.01")

    @pytest.mark.parametrize(
        "t_type, cat_id, error_match",
        [
            (TransactionType.EXPENSE, None, "expense must have a category"),  # logic
            (
                TransactionType.INCOME,
                uuid4(),
                "income must not have a category",
            ),  # logic
        ],
    )
    def test_invalid_transaction_logic(
        self, t_type: TransactionType, cat_id: UUID | None, error_match: str
    ) -> None:
        """PE: Invalid logic between type and category."""
        with pytest.raises(ValueError, match=error_match):
            Transaction(
                account_id=uuid4(),
                category_id=cat_id,
                transaction_type=t_type,
                description="Test",
                created_at=datetime.now(),
                amount=Decimal("100"),
            )

    @pytest.mark.parametrize("amount", [Decimal("0.00"), Decimal("-0.01")])
    def test_invalid_transaction_amount(self, amount: Decimal) -> None:
        """AVL: Transaction amount must be positive."""
        with pytest.raises(ValueError, match="greater than 0"):
            Transaction(
                account_id=uuid4(),
                category_id=None,
                transaction_type=TransactionType.INCOME,
                description="Test",
                created_at=datetime.now(),
                amount=amount,
            )
