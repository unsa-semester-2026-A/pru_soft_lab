"""Domain entities for the finance application."""

from __future__ import annotations

import re
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


def _validate_not_empty(value: str, field_name: str) -> None:
    """Validate that a string value is not empty or whitespace.

    Args:
        value: The string to validate.
        field_name: The name of the field for the error message.

    Raises:
        ValueError: If the value is empty or only contains whitespace.
    """
    if not value or not value.strip():
        raise ValueError(f"{field_name} cannot be empty.")


@dataclass(slots=True)
class User:
    """User profile.

    Attributes:
        name: Full name of the user.
        email: Email address of the user.
        id: Unique identifier for the user.
    """

    name: str
    email: str
    id: UUID = field(default_factory=uuid4)

    def __post_init__(self) -> None:
        """Validate entity fields.

        Raises:
            ValueError: If name or email is empty, or email format is invalid.
        """
        _validate_not_empty(self.name, "User name")
        _validate_not_empty(self.email, "Email")
        if "@" not in self.email:
            raise ValueError("Email must have a valid format.")


@dataclass(slots=True)
class Account:
    """Financial account linked to a user.

    Attributes:
        name: Name of the account.
        bank: Name of the bank.
        current_balance: Current available funds.
        is_active: Status of the account (soft delete).
        id: Unique identifier for the account.
    """

    name: str
    bank: str
    current_balance: Decimal = Decimal("0.00")
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)

    def __post_init__(self) -> None:
        """Validate entity fields."""
        _validate_not_empty(self.name, "Account name")
        _validate_not_empty(self.bank, "Bank name")
        if not re.match(r"^[A-Za-z\u00C0-\u024F\s]+$", self.name):
            raise ValueError("Account name must contain only letters.")
        if len(self.name) < 2:
            raise ValueError("Account name must be at least 2 characters.")
        if len(self.name) > 128:
            raise ValueError("Account name must be at most 128 characters.")
        if len(self.bank) > 100:
            raise ValueError("Bank name must be at most 100 characters.")

    def register_income(self, amount: Decimal) -> None:
        """Increase the account balance with a positive amount.

        Args:
            amount: The amount to add.

        Raises:
            ValueError: If the amount is not positive.
        """
        if amount <= 0:
            raise ValueError("Income amount must be positive.")
        self.current_balance += amount

    def register_expense(self, amount: Decimal) -> None:
        """Decrease the account balance if funds are sufficient.

        Args:
            amount: The amount to subtract.

        Raises:
            ValueError: If the amount is not positive.
            InsufficientFundsError: If the balance is less than the amount.
        """
        if amount <= 0:
            raise ValueError("Expense amount must be positive.")
        if self.current_balance - amount < 0:
            raise InsufficientFundsError("Insufficient funds for this expense.")
        self.current_balance -= amount


@dataclass(slots=True)
class Category:
    """Spending category for transactions.

    Attributes:
        name: Name of the category.
        is_active: Status of the category (soft delete).
        id: Unique identifier for the category.
    """

    name: str
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)

    def __post_init__(self) -> None:
        """Validate entity fields."""
        _validate_not_empty(self.name, "Category name")
        if len(self.name) > 100:
            raise ValueError("Category name must be at most 100 characters.")


@dataclass(slots=True)
class Budget:
    """Monthly budget for a specific category.

    Attributes:
        category_id: ID of the linked category.
        month: Month of the budget (1-12).
        year: Year of the budget.
        limit_amount: Maximum allowed spending for the month.
        id: Unique identifier for the budget.
    """

    category_id: UUID
    month: int
    year: int
    limit_amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)

    def __post_init__(self) -> None:
        """Validate entity fields.

        Raises:
            ValueError: If limit_amount <= 0, month is invalid, or year < 1900.
        """
        if self.limit_amount <= 0:
            raise ValueError("Budget limit must be greater than 0.")
        if not (1 <= self.month <= 12):
            raise ValueError("Month must be between 1 and 12.")
        if self.year < 1900:
            raise ValueError("Invalid year.")


@dataclass(slots=True)
class Transaction:
    """Financial movement.

    Attributes:
        account_id: ID of the linked account.
        category_id: ID of the linked category (None for income).
        transaction_type: Type of transaction (INCOME/EXPENSE).
        description: Short description of the movement.
        created_at: Date and time of the transaction.
        amount: Transaction amount.
        id: Unique identifier for the transaction.
    """

    account_id: UUID
    category_id: UUID | None
    transaction_type: TransactionType
    description: str
    created_at: datetime
    amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)

    def __post_init__(self) -> None:
        """Validate entity fields.

        Raises:
            ValueError: If amount <= 0, description is empty, or category rules
                are violated (expense needs category, income must not have one).
        """
        if self.amount <= 0:
            raise ValueError("Transaction amount must be greater than 0.")

        is_expense = self.transaction_type == TransactionType.EXPENSE
        if is_expense and self.category_id is None:
            raise ValueError("An expense must have a category.")

        is_income = self.transaction_type == TransactionType.INCOME
        if is_income and self.category_id is not None:
            raise ValueError("An income must not have a category.")

        _validate_not_empty(self.description, "Description")
