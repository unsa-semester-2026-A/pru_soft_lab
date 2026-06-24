"""Advanced black-box tests for the finance application core logic.

Covers:
1. Random Testing (Pruebas Aleatorias / Invariantes)
"""

import random
from dataclasses import dataclass, field
from datetime import datetime, timezone
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

# ─────────────────────────────────────────────────────────────
# In-Memory Repositories for Test Setup
# ─────────────────────────────────────────────────────────────


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
def test_bundle() -> ServiceBundle:
    """Provides a fresh service bundle for each test."""
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
# 4. Random Testing / Property-Based Testing
# ─────────────────────────────────────────────────────────────


class TestRandomTesting:
    """Performs Property-Based testing to check invariants."""

    def test_random_transactions_and_invariants(
        self, test_bundle: ServiceBundle
    ) -> None:
        """Generates random transaction paths to assert invariants."""
        # Setup entities
        acc = test_bundle.service.create_account(name="Master Account", bank="Bank")
        cat = test_bundle.service.create_category(name="General")
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(
            cat.id, Decimal("500.00"), now.month, now.year
        )

        # Tracking state locally to compare with domain calculations
        local_balance = Decimal("0.00")
        local_incomes = Decimal("0.00")
        local_expenses = Decimal("0.00")

        # Run 100 randomized transaction attempts
        rng = random.Random(42)  # Seeded for deterministic runs

        for _ in range(100):
            is_income = rng.choice([True, False])
            # Random amount in [0.01, 100.00]
            amount = Decimal(f"{rng.randint(1, 10000) / 100:.2f}")

            if is_income:
                # 1. Income Invariant: Income succeeds on active account
                # and amount > 0
                test_bundle.service.register_transaction(
                    acc.id, None, "INCOME", amount, "Random income"
                )
                local_balance += amount
                local_incomes += amount
            else:
                # 2. Expense / Fund protection Invariant
                if local_balance >= amount:
                    # Should succeed
                    test_bundle.service.register_transaction(
                        acc.id, cat.id, "EXPENSE", amount, "Random expense"
                    )
                    local_balance -= amount
                    local_expenses -= amount
                else:
                    # Should fail due to insufficient funds
                    with pytest.raises(InsufficientFundsError):
                        test_bundle.service.register_transaction(
                            acc.id, cat.id, "EXPENSE", amount, "Random expense"
                        )

            # Invariant check: current balance matches formula
            stored_acc = test_bundle.accounts.get(acc.id)
            assert stored_acc is not None
            assert stored_acc.current_balance == local_balance
            assert stored_acc.current_balance >= Decimal("0.00")

        # Invariant check: Final balances match sum(incomes) + sum(expenses)
        stored_acc = test_bundle.accounts.get(acc.id)
        assert stored_acc is not None
        assert stored_acc.current_balance == local_incomes + local_expenses

    def test_random_budget_limit_invariants(self, test_bundle: ServiceBundle) -> None:
        """Validates that random budget assignments maintain uniqueness of budgets."""
        cat = test_bundle.service.create_category(name="Random Cat")
        rng = random.Random(1337)
        now = datetime.now(timezone.utc)

        # Run 50 random budget assignments for the same period
        last_limit = Decimal("0.00")
        for _ in range(50):
            limit = Decimal(f"{rng.randint(1, 1000):.2f}")
            test_bundle.service.assign_budget(cat.id, limit, now.month, now.year)
            last_limit = limit

        # Invariant check: only one budget exists for this month and year
        all_budgets = test_bundle.budgets.list_all()
        assert len(all_budgets) == 1
        assert all_budgets[0].limit_amount == last_limit
