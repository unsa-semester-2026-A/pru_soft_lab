"""Domain entities for the finance application."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal
from enum import Enum
from uuid import UUID, uuid4


class TransactionType(Enum):
    """Allowed transaction types."""

    INCOME = "INCOME"
    EXPENSE = "EXPENSE"


class InsufficientFundsError(ValueError):
    """Raised when an account lacks sufficient balance for an expense."""


@dataclass(slots=True)
class User:
    """User profile."""

    name: str
    email: str
    id: UUID = field(default_factory=uuid4)


@dataclass(slots=True)
class Account:
    """Financial account linked to a user."""

    name: str
    bank: str
    current_balance: Decimal = Decimal("0.00")
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)

    def register_income(self, amount: Decimal) -> None:
        """Increase the account balance with a positive amount."""
        if amount <= 0:
            raise ValueError("Income amount must be positive.")
        self.current_balance += amount

    def register_expense(self, amount: Decimal) -> None:
        """Decrease the account balance if funds are sufficient."""
        if amount <= 0:
            raise ValueError("Expense amount must be positive.")
        if self.current_balance - amount < 0:
            raise InsufficientFundsError("Saldo insuficiente para este gasto.")
        self.current_balance -= amount


@dataclass(slots=True)
class Category:
    """Spending category for transactions."""

    name: str
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)


@dataclass(slots=True)
class Budget:
    """Monthly budget for a specific category."""

    category_id: UUID
    month: int
    year: int
    limit_amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)


@dataclass(slots=True)
class Transaction:
    """Financial movement."""

    account_id: UUID
    category_id: UUID | None
    transaction_type: TransactionType
    description: str
    created_at: datetime
    amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)
