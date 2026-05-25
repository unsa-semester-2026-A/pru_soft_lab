from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from decimal import Decimal
from typing import Iterable
from uuid import UUID, uuid4

import pytest

from finance.core.app.services import FinanceService
from finance.core.domain.entities import (
    Account,
    Budget,
    Category,
    InsufficientFundsError,
    Transaction,
    TransactionType,
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


@dataclass
class ServiceBundle:
    service: FinanceService
    users: InMemoryUserRepository
    accounts: InMemoryAccountRepository
    categories: InMemoryCategoryRepository
    budgets: InMemoryBudgetRepository
    transactions: InMemoryTransactionRepository


def build_service() -> ServiceBundle:
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


def test_create_user_persists_data() -> None:
    bundle = build_service()
    user = bundle.service.create_user(name="Ana", email="ana@example.com")

    assert bundle.users.get(user.id) == user


def test_create_account_persists_data() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Ahorros", bank="Cash")

    assert bundle.accounts.get(account.id) == account


def test_assign_budget_creates_new_budget() -> None:
    bundle = build_service()
    category = bundle.service.create_category(name="Comida")

    budget = bundle.service.assign_budget(
        category_id=category.id,
        limit_amount=Decimal("150"),
        month=5,
        year=2026,
    )

    assert bundle.budgets.get_by_category_and_period(category.id, 5, 2026) == budget


def test_assign_budget_updates_existing_budget() -> None:
    bundle = build_service()
    category = bundle.service.create_category(name="Servicios")
    existing = Budget(
        category_id=category.id,
        limit_amount=Decimal("100"),
        month=4,
        year=2026,
    )
    bundle.budgets.add(existing)

    updated = bundle.service.assign_budget(
        category_id=category.id,
        limit_amount=Decimal("220"),
        month=4,
        year=2026,
    )

    assert updated.id == existing.id
    assert updated.limit_amount == Decimal("220")


def test_register_income_updates_balance_and_persists_transaction() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Sueldo", bank="BCP")

    transaction, exceeded = bundle.service.register_transaction(
        account_id=account.id,
        category_id=None,
        transaction_type="INCOME",
        amount=Decimal("1000"),
        description="Pago",
    )

    stored = bundle.accounts.get(account.id)
    assert stored is not None
    assert stored.current_balance == Decimal("1000")
    assert transaction in bundle.transactions.items
    assert exceeded is False


def test_register_expense_rejects_when_insufficient_balance() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Diario", bank="Cash")

    with pytest.raises(InsufficientFundsError):
        bundle.service.register_transaction(
            account_id=account.id,
            category_id=uuid4(),
            transaction_type="EXPENSE",
            amount=Decimal("50"),
            description="Taxi",
        )


def test_register_expense_flags_budget_exceeded() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Caja", bank="Cash")
    category = bundle.service.create_category(name="Transporte")
    bundle.service.assign_budget(
        category_id=category.id,
        limit_amount=Decimal("100"),
        month=5,
        year=2026,
    )
    bundle.service.register_transaction(
        account_id=account.id,
        category_id=None,
        transaction_type="INCOME",
        amount=Decimal("200"),
        description="Recarga",
    )

    transaction, exceeded = bundle.service.register_transaction(
        account_id=account.id,
        category_id=category.id,
        transaction_type="EXPENSE",
        amount=Decimal("120"),
        description="Bus",
    )

    assert transaction in bundle.transactions.items
    assert exceeded is True


def test_register_expense_budget_not_exceeded_when_under_limit() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Caja", bank="Cash")
    category = bundle.service.create_category(name="Salud")
    bundle.service.assign_budget(
        category_id=category.id,
        limit_amount=Decimal("200"),
        month=5,
        year=2026,
    )
    bundle.service.register_transaction(
        account_id=account.id,
        category_id=None,
        transaction_type="INCOME",
        amount=Decimal("300"),
        description="Deposito",
    )

    _, exceeded = bundle.service.register_transaction(
        account_id=account.id,
        category_id=category.id,
        transaction_type="EXPENSE",
        amount=Decimal("120"),
        description="Farmacia",
    )

    assert exceeded is False


def test_register_transaction_rejects_invalid_type() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Caja", bank="Cash")

    with pytest.raises(ValueError):
        bundle.service.register_transaction(
            account_id=account.id,
            category_id=None,
            transaction_type="OTHER",
            amount=Decimal("10"),
            description="Test",
        )


def test_register_transaction_rejects_missing_account() -> None:
    bundle = build_service()

    with pytest.raises(ValueError):
        bundle.service.register_transaction(
            account_id=uuid4(),
            category_id=None,
            transaction_type="INCOME",
            amount=Decimal("10"),
            description="Test",
        )


def test_register_expense_uses_current_period_for_budget() -> None:
    bundle = build_service()
    account = bundle.service.create_account(name="Caja", bank="Cash")
    category = bundle.service.create_category(name="Hogar")
    current_month = datetime.now(timezone.utc).month
    current_year = datetime.now(timezone.utc).year
    bundle.service.assign_budget(
        category_id=category.id,
        limit_amount=Decimal("50"),
        month=current_month,
        year=current_year,
    )
    bundle.service.register_transaction(
        account_id=account.id,
        category_id=None,
        transaction_type="INCOME",
        amount=Decimal("80"),
        description="Ingreso",
    )

    _, exceeded = bundle.service.register_transaction(
        account_id=account.id,
        category_id=category.id,
        transaction_type="EXPENSE",
        amount=Decimal("60"),
        description="Compra",
    )

    assert exceeded is True


def test_sum_expenses_only_counts_expense_transactions() -> None:
    bundle = build_service()
    account_id = uuid4()
    category_id = uuid4()
    transactions: Iterable[Transaction] = [
        Transaction(
            account_id=account_id,
            category_id=None,
            transaction_type=TransactionType.INCOME,
            amount=Decimal("100"),
            description="Ingreso",
            created_at=datetime.now(timezone.utc),
        ),
        Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=TransactionType.EXPENSE,
            amount=Decimal("40"),
            description="Gasto",
            created_at=datetime.now(timezone.utc),
        ),
    ]

    total = bundle.service._sum_expenses(transactions)

    assert total == Decimal("40")
