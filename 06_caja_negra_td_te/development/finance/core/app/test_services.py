"""Tests for application services using EP and BVA."""

from __future__ import annotations

from dataclasses import dataclass, field
from decimal import Decimal
from uuid import UUID, uuid4

import pytest

from finance.core.app.services import FinanceService
from finance.core.domain.entities import (
    Account,
    Budget,
    Category,
    InsufficientFundsError,
    Transaction,
    User,
)


@dataclass
class InMemoryUserRepository:
    items: dict[UUID, User] = field(default_factory=dict)

    def add(self, user: User) -> None:
        self.items[user.id] = user

    def get(self, user_id: UUID) -> User | None:
        return self.items.get(user_id)

    def update(self, user: User) -> None:
        self.items[user.id] = user


@dataclass
class InMemoryAccountRepository:
    items: dict[UUID, Account] = field(default_factory=dict)

    def add(self, account: Account) -> None:
        self.items[account.id] = account

    def get(self, account_id: UUID) -> Account | None:
        return self.items.get(account_id)

    def list_all(self) -> list[Account]:
        return list(self.items.values())

    def update(self, account: Account) -> None:
        self.items[account.id] = account


@dataclass
class InMemoryCategoryRepository:
    items: dict[UUID, Category] = field(default_factory=dict)

    def add(self, category: Category) -> None:
        self.items[category.id] = category

    def get(self, category_id: UUID) -> Category | None:
        return self.items.get(category_id)

    def update(self, category: Category) -> None:
        self.items[category.id] = category

    def list_all(self) -> list[Category]:
        return list(self.items.values())


@dataclass
class InMemoryBudgetRepository:
    items: dict[UUID, Budget] = field(default_factory=dict)

    def add(self, budget: Budget) -> None:
        self.items[budget.id] = budget

    def get_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> Budget | None:
        for budget in self.items.values():
            if (
                budget.category_id == category_id
                and budget.month == month
                and budget.year == year
            ):
                return budget
        return None

    def update(self, budget: Budget) -> None:
        self.items[budget.id] = budget

    def list_all(self) -> list[Budget]:
        return list(self.items.values())


@dataclass
class InMemoryTransactionRepository:
    items: list[Transaction] = field(default_factory=list)

    def add(self, transaction: Transaction) -> None:
        self.items.append(transaction)

    def list_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> list[Transaction]:
        return [
            transaction
            for transaction in self.items
            if transaction.category_id == category_id
            and transaction.created_at.month == month
            and transaction.created_at.year == year
        ]

    def list_all(self) -> list[Transaction]:
        return self.items


@dataclass
class ServiceBundle:
    service: FinanceService
    users: InMemoryUserRepository
    accounts: InMemoryAccountRepository
    categories: InMemoryCategoryRepository
    budgets: InMemoryBudgetRepository
    transactions: InMemoryTransactionRepository


@pytest.fixture
def bundle() -> ServiceBundle:
    """Fixture to provide a clean service and repositories for each test."""
    users = InMemoryUserRepository()
    accounts = InMemoryAccountRepository()
    categories = InMemoryCategoryRepository()
    budgets = InMemoryBudgetRepository()
    transactions = InMemoryTransactionRepository()
    service = FinanceService(
        user_repository=users,
        account_repository=accounts,
        category_repository=categories,
        budget_repository=budgets,
        transaction_repository=transactions,
    )
    return ServiceBundle(
        service=service,
        users=users,
        accounts=accounts,
        categories=categories,
        budgets=budgets,
        transactions=transactions,
    )


# ─────────────────────────────────────────────────────────────
# Creation Tests
# ─────────────────────────────────────────────────────────────


def test_create_user_persists_data(bundle: ServiceBundle) -> None:
    user = bundle.service.create_user(name="Ana", email="ana@example.com")
    assert bundle.users.get(user.id) == user


def test_create_account_persists_data(bundle: ServiceBundle) -> None:
    account = bundle.service.create_account(name="Ahorros", bank="Cash")
    assert bundle.accounts.get(account.id) == account


# ─────────────────────────────────────────────────────────────
# Budget Status Tests (BVA)
# ─────────────────────────────────────────────────────────────


@pytest.mark.parametrize(
    "expense_amount, expected_exceeded",
    [
        (Decimal("99.99"), False),  # AVL: Slightly under limit
        (Decimal("100.00"), False),  # AVL: Exactly at limit
        (Decimal("100.01"), True),  # AVL: Slightly over limit
    ],
)
def test_calculate_budget_status_boundaries(
    bundle: ServiceBundle, expense_amount: Decimal, expected_exceeded: bool
) -> None:
    """AVL: Testing budget status exactly at the boundaries."""
    acc = bundle.service.create_account(name="CA", bank="B")
    cat = bundle.service.create_category(name="T")

    # Set limit to 100
    from datetime import datetime, timezone

    now = datetime.now(timezone.utc)
    budget = bundle.service.assign_budget(cat.id, Decimal("100"), now.month, now.year)

    # Fund account
    bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("1000"), "Fund")

    # Register expense
    bundle.service.register_transaction(acc.id, cat.id, "EXPENSE", expense_amount, "E")

    spent, exceeded = bundle.service.calculate_budget_status(budget.id)

    assert spent == expense_amount
    assert exceeded == expected_exceeded


# ─────────────────────────────────────────────────────────────
# Registration Logic Tests (EP)
# ─────────────────────────────────────────────────────────────


def test_register_income_updates_balance(bundle: ServiceBundle) -> None:
    account = bundle.service.create_account(name="Sueldo", bank="BCP")
    bundle.service.register_transaction(account.id, None, "INCOME", Decimal("500"), "P")

    stored = bundle.accounts.get(account.id)
    assert stored is not None
    assert stored.current_balance == Decimal("500")


def test_register_expense_fails_insufficient_funds(bundle: ServiceBundle) -> None:
    account = bundle.service.create_account(name="Cash", bank="Cash")
    with pytest.raises(InsufficientFundsError):
        bundle.service.register_transaction(
            account.id, uuid4(), "EXPENSE", Decimal("10"), "E"
        )


@pytest.mark.parametrize("invalid_type", ["TRANSFER", "LOAN", ""])
def test_register_transaction_rejects_invalid_types(
    bundle: ServiceBundle, invalid_type: str
) -> None:
    acc = bundle.service.create_account(name="CA", bank="B")
    with pytest.raises(ValueError, match="Invalid transaction type"):
        bundle.service.register_transaction(
            acc.id, None, invalid_type, Decimal("10"), "T"
        )


# ─────────────────────────────────────────────────────────────
# Listing & Filtering Tests (EP)
# ─────────────────────────────────────────────────────────────


def test_list_active_accounts_filters_soft_deleted(bundle: ServiceBundle) -> None:
    bundle.service.create_account(name="Active", bank="B1")
    inactive = bundle.service.create_account(name="Inactive", bank="B2")
    bundle.service.deactivate_account(inactive.id)

    active_accounts = bundle.service.list_active_accounts()
    assert len(active_accounts) == 1
    assert active_accounts[0].name == "Active"


def test_list_all_transactions_returns_full_history(bundle: ServiceBundle) -> None:
    acc = bundle.service.create_account(name="CA", bank="B")
    bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("100"), "T1")
    bundle.service.register_transaction(acc.id, None, "INCOME", Decimal("100"), "T2")

    txns = bundle.service.list_all_transactions()
    assert len(txns) == 2
