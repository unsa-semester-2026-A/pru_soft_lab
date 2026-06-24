"""Dummy implementation of FinanceInboundPort for UI testing.

This module exists exclusively for testing the UI layer without
depending on the real FinanceService or any database adapter.
Do NOT use in production.
"""

from __future__ import annotations

import re
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
    """Minimal user DTO for UI tests.

    Attributes:
        name: Full name of the user.
        email: Email address of the user.
        id: Unique identifier for the user.
    """

    name: str
    email: str
    id: UUID = field(default_factory=uuid4)


@dataclass
class Account:
    """Minimal account DTO for UI tests.

    Attributes:
        name: Name of the account.
        bank: Name of the bank.
        current_balance: Current available funds.
        is_active: Status of the account.
        id: Unique identifier for the account.
    """

    name: str
    bank: str
    current_balance: Decimal = Decimal("0.00")
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)


@dataclass
class Category:
    """Minimal category DTO for UI tests.

    Attributes:
        name: Name of the category.
        is_active: Status of the category.
        id: Unique identifier for the category.
    """

    name: str
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)


@dataclass
class Budget:
    """Minimal budget DTO for UI tests.

    Attributes:
        category_id: ID of the linked category.
        month: Month of the budget.
        year: Year of the budget.
        limit_amount: Spending limit.
        id: Unique identifier for the budget.
    """

    category_id: UUID
    month: int
    year: int
    limit_amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)


@dataclass
class Transaction:
    """Minimal transaction DTO for UI tests.

    Attributes:
        account_id: ID of the linked account.
        category_id: ID of the linked category.
        transaction_type: INCOME or EXPENSE.
        amount: Transaction amount.
        description: Short description.
        created_at: Date and time of the transaction.
        id: Unique identifier for the transaction.
    """

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
        self._budgets: list[Budget] = []
        self._transactions: list[Transaction] = []
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
            raise ValueError("El nombre del usuario no puede estar vacio.")
        if not email.strip():
            raise ValueError("El correo no puede estar vacio.")
        return User(name=name, email=email)

    def create_account(self, name: str, bank: str) -> Account:
        """Simulate account creation.

        Args:
            name: Display name for the account (letters only, 2-128 chars).
            bank: Bank or institution name (max 100 chars).

        Returns:
            An Account dataclass with zero balance.

        Raises:
            ValueError: If validation rules are violated.
        """
        if not name.strip():
            raise ValueError("El nombre de la cuenta no puede estar vacio.")
        if not bank.strip():
            raise ValueError("El nombre del banco no puede estar vacio.")
        if not re.match(r"^[A-Za-z\u00C0-\u024F\s]+$", name.strip()):
            raise ValueError("El nombre de la cuenta solo debe contener letras.")
        if len(name.strip()) < 2:
            raise ValueError("El nombre de la cuenta debe tener al menos 2 letras.")
        if len(name.strip()) > 128:
            raise ValueError("El nombre de la cuenta debe tener maximo 128 caracteres.")
        if len(bank.strip()) > 100:
            raise ValueError("El nombre del banco debe tener maximo 100 caracteres.")
        account = Account(name=name.strip(), bank=bank.strip())
        self._accounts.append(account)
        return account

    def create_category(self, name: str) -> Category:
        """Simulate category creation.

        Args:
            name: Display name for the category (max 100 chars).

        Returns:
            A Category dataclass.

        Raises:
            ValueError: If validation rules are violated.
        """
        if not name.strip():
            raise ValueError("El nombre de la categoria no puede estar vacio.")
        if len(name.strip()) > 100:
            raise ValueError("El nombre de la categoria debe tener maximo 100 caracteres.")
        category = Category(name=name.strip())
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
            raise ValueError("El monto del limite debe ser mayor a 0.")
        budget = Budget(
            category_id=category_id,
            limit_amount=limit_amount,
            month=month,
            year=year,
        )
        self._budgets.append(budget)
        return budget

    def register_transaction(
        self,
        account_id: UUID,
        category_id: UUID | None,
        transaction_type: str,
        amount: Decimal,
        description: str,
    ) -> tuple[Transaction, bool]:
        """Register a transaction and check budget status.

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
            raise ValueError("Tipo de transaccion invalido.")

        parsed_type = TransactionType(transaction_type.upper())

        if parsed_type == TransactionType.EXPENSE:
            if amount > self._balance:
                raise InsufficientFundsError("Fondos insuficientes para esta operacion.")
            self._balance -= amount
        else:
            self._balance += amount

        transaction = Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=parsed_type,
            amount=amount,
            description=description,
            created_at=datetime.now(timezone.utc),
        )
        self._transactions.append(transaction)

        budget_exceeded = False
        if parsed_type == TransactionType.EXPENSE and category_id is not None:
            now = transaction.created_at
            for b in self._budgets:
                if (
                    b.category_id == category_id
                    and b.month == now.month
                    and b.year == now.year
                ):
                    spent, exceeded = self.calculate_budget_status(b.id)
                    if exceeded:
                        budget_exceeded = True
                        break

        return transaction, budget_exceeded

    def list_active_accounts(self) -> list[Account]:
        """Return active accounts.

        Returns:
            List of active Account objects.
        """
        return [a for a in self._accounts if a.is_active]

    def list_active_categories(self) -> list[Category]:
        """Return active categories.

        Returns:
            List of active Category objects.
        """
        return [c for c in self._categories if c.is_active]

    def deactivate_account(self, account_id: UUID) -> None:
        """Simulate account deactivation.

        Args:
            account_id: The ID of the account to deactivate.
        """
        for account in self._accounts:
            if account.id == account_id:
                account.is_active = False
                return

    def deactivate_category(self, category_id: UUID) -> None:
        """Simulate category deactivation.

        Args:
            category_id: The ID of the category to deactivate.
        """
        for category in self._categories:
            if category.id == category_id:
                category.is_active = False
                return

    def list_all_budgets(self) -> list[Budget]:
        """Return all simulated budgets.

        Returns:
            List of Budget objects.
        """
        return self._budgets

    def list_all_transactions(self) -> list[Transaction]:
        """Return all simulated transactions.

        Returns:
            List of Transaction objects.
        """
        return self._transactions

    def calculate_budget_status(self, budget_id: UUID) -> tuple[Decimal, bool]:
        """Calculate real spent amount against a budget.

        Args:
            budget_id: The ID of the budget to check.

        Returns:
            A tuple of (total_spent, exceeded).
        """
        budget = next((b for b in self._budgets if b.id == budget_id), None)
        if budget is None:
            return Decimal("0.00"), False
        spent = Decimal("0.00")
        for t in self._transactions:
            if (
                t.transaction_type == TransactionType.EXPENSE
                and t.category_id == budget.category_id
                and t.created_at.month == budget.month
                and t.created_at.year == budget.year
            ):
                spent += t.amount
        exceeded = spent > budget.limit_amount
        return spent, exceeded

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

    def load_seed_data(self, path: str) -> None:
        """Load sample data from a JSON file.

        Args:
            path: Path to the JSON seed file.
        """
        import json

        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)

        cat_map: dict[str, UUID] = {}
        for cat_name in data.get("categories", []):
            cat = self.create_category(cat_name)
            cat_map[cat_name] = cat.id

        acc_map: dict[str, UUID] = {}
        for acc_data in data.get("accounts", []):
            acc = self.create_account(acc_data["name"], acc_data["bank"])
            acc_map[acc_data["name"]] = acc.id

        for b_data in data.get("budgets", []):
            cat_id = cat_map.get(b_data["category"])
            if cat_id is not None:
                self.assign_budget(
                    category_id=cat_id,
                    limit_amount=Decimal(str(b_data["limit"])),
                    month=b_data["month"],
                    year=b_data["year"],
                )

        for t_data in data.get("transactions", []):
            acc_id = acc_map.get(t_data["account"])
            cat_id = cat_map.get(t_data["category"]) if t_data.get("category") else None
            if acc_id is not None:
                self.register_transaction(
                    account_id=acc_id,
                    category_id=cat_id,
                    transaction_type=t_data["type"],
                    amount=Decimal(str(t_data["amount"])),
                    description=t_data["description"],
                )
