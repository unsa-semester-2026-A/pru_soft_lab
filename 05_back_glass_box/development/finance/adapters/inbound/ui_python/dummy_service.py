"""Dummy implementation of FinanceInboundPort for UI testing.

This module exists exclusively for testing the UI layer without
depending on the real FinanceService or any database adapter.
Do NOT use in production.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from decimal import Decimal
from enum import Enum
from uuid import UUID, uuid4


class TransactionType(Enum):
    """Allowed transaction types (mirrors core entity)."""

    INCOME = "INCOME"
    EXPENSE = "EXPENSE"


class InsufficientFundsError(ValueError):
    """Raised when a simulated account has insufficient balance."""


@dataclass
class User:
    """Minimal user DTO for UI tests."""

    name: str
    email: str
    id: UUID = field(default_factory=uuid4)


@dataclass
class Account:
    """Minimal account DTO for UI tests."""

    name: str
    bank: str
    current_balance: Decimal = Decimal("0.00")
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)


@dataclass
class Category:
    """Minimal category DTO for UI tests."""

    name: str
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)


@dataclass
class Budget:
    """Minimal budget DTO for UI tests."""

    category_id: UUID
    month: int
    year: int
    limit_amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)


@dataclass
class Transaction:
    """Minimal transaction DTO for UI tests."""

    account_id: UUID
    category_id: UUID | None
    transaction_type: TransactionType
    amount: Decimal
    description: str
    created_at: datetime
    id: UUID = field(default_factory=uuid4)


class DummyFinanceService:
    """Fake implementation of FinanceInboundPort for UI tests.

    Mirrors the exact method signatures defined in inbound.py so that
    when the real FinanceService is injected later, no UI code changes.

    Attributes:
        _accounts: In-memory list of created accounts.
        _categories: In-memory list of created categories.
        _balance: Simulated balance used for expense validation.
    """

    def __init__(self) -> None:
        """Initialize the dummy with empty in-memory collections."""
        self._accounts: list[Account] = []
        self._categories: list[Category] = []
        self._balance: Decimal = Decimal("1000.00")

    def create_user(self, name: str, email: str) -> User:
        """Simulate user creation.

        Args:
            name: Full name of the user.
            email: Email address of the user.

        Returns:
            A User dataclass with a generated UUID.

        Raises:
            ValueError: If name or email are empty.
        """
        if not name.strip():
            raise ValueError("Name cannot be empty.")
        if not email.strip():
            raise ValueError("Email cannot be empty.")
        return User(name=name, email=email)

    def create_account(self, name: str, bank: str) -> Account:
        """Simulate account creation.

        Args:
            name: Display name for the account.
            bank: Bank or institution name.

        Returns:
            An Account dataclass with zero balance.

        Raises:
            ValueError: If name or bank are empty.
        """
        if not name.strip():
            raise ValueError("Account name cannot be empty.")
        if not bank.strip():
            raise ValueError("Bank name cannot be empty.")
        account = Account(name=name, bank=bank)
        self._accounts.append(account)
        return account

    def create_category(self, name: str) -> Category:
        """Simulate category creation.

        Args:
            name: Display name for the category.

        Returns:
            A Category dataclass.

        Raises:
            ValueError: If name is empty.
        """
        if not name.strip():
            raise ValueError("Category name cannot be empty.")
        category = Category(name=name)
        self._categories.append(category)
        return category

    def assign_budget(
        self,
        category_id: UUID,
        limit_amount: Decimal,
        month: int,
        year: int,
    ) -> Budget:
        """Simulate budget assignment.

        Args:
            category_id: UUID of the target category.
            limit_amount: Monthly spending limit.
            month: Target month (1-12).
            year: Target year.

        Returns:
            A Budget dataclass.

        Raises:
            ValueError: If limit_amount is not positive.
        """
        if limit_amount <= Decimal("0"):
            raise ValueError("Limit amount must be greater than 0.")
        return Budget(
            category_id=category_id,
            limit_amount=limit_amount,
            month=month,
            year=year,
        )

    def register_transaction(
        self,
        account_id: UUID,
        category_id: UUID | None,
        transaction_type: str,
        amount: Decimal,
        description: str,
    ) -> tuple[Transaction, bool]:
        """Simulate transaction registration.

        Returns a tuple of (Transaction, budget_exceeded).
        budget_exceeded is True when simulated expenses surpass 800.

        Args:
            account_id: UUID of the account.
            category_id: UUID of the category (None for INCOME).
            transaction_type: 'INCOME' or 'EXPENSE'.
            amount: Transaction amount, must be > 0.
            description: Human-readable description.

        Returns:
            Tuple of Transaction and a bool indicating budget exceeded.

        Raises:
            ValueError: If amount <= 0 or transaction_type is invalid.
            InsufficientFundsError: If balance would go negative.
        """
        if amount <= Decimal("0"):
            raise ValueError("El monto debe ser mayor a 0.")
        if transaction_type.upper() not in ("INCOME", "EXPENSE"):
            raise ValueError("Tipo de transacción inválido.")

        parsed_type = TransactionType(transaction_type.upper())

        if parsed_type == TransactionType.EXPENSE:
            if amount > self._balance:
                raise InsufficientFundsError("Fondos insuficientes.")
            self._balance -= amount
            budget_exceeded = self._balance < Decimal("200.00")
        else:
            self._balance += amount
            budget_exceeded = False

        transaction = Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=parsed_type,
            amount=amount,
            description=description,
            created_at=datetime.now(timezone.utc),
        )
        return transaction, budget_exceeded

    def list_accounts(self) -> list[Account]:
        """Return active accounts (not in real inbound.py, mocked here).

        Returns:
            List of active Account objects.
        """
        return [a for a in self._accounts if a.is_active]

    def list_categories(self) -> list[Category]:
        """Return active categories (not in real inbound.py, mocked here).

        Returns:
            List of active Category objects.
        """
        return [c for c in self._categories if c.is_active]
