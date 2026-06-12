"""Advanced black-box tests for the finance application core logic.

Covers:
1. Decision Table Testing (Tablas de Decisión)
2. State Transition Testing (Transición de Estados)
3. Use Case Testing (Casos de Uso: UC-2, UC-3, UC-4)
4. Random Testing (Pruebas Aleatorias / Invariantes)
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
# 1. Decision Table Testing (Tablas de Decisión)
# ─────────────────────────────────────────────────────────────


class TestDecisionTable:
    """Verifies rules of the Decision Table for transaction registration."""

    def test_r1_income_success(self, test_bundle: ServiceBundle) -> None:
        """R1: Income transaction, category omitted, active account, positive amount."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        tx, exceeded = test_bundle.service.register_transaction(
            account_id=acc.id,
            category_id=None,
            transaction_type="INCOME",
            amount=Decimal("150.00"),
            description="Salary",
        )
        assert tx.amount == Decimal("150.00")
        assert not exceeded
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("150.00")  # type: ignore

    def test_r2_income_with_category_fails(self, test_bundle: ServiceBundle) -> None:
        """R2: Income transaction, category provided (must fail)."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Salary")
        with pytest.raises(ValueError, match="An income must not have a category"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=cat.id,
                transaction_type="INCOME",
                amount=Decimal("100.00"),
                description="Salary",
            )

    def test_r3_and_r4_income_inactive_or_missing_account_fails(
        self, test_bundle: ServiceBundle
    ) -> None:
        """R3 & R10: Account missing or inactive."""
        # Account not found
        with pytest.raises(ValueError, match="Account not found"):
            test_bundle.service.register_transaction(
                account_id=uuid4(),
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("100.00"),
                description="Salary",
            )

        # Inactive account
        acc = test_bundle.service.create_account(name="To Delete", bank="BCP")
        test_bundle.service.deactivate_account(acc.id)
        with pytest.raises(ValueError, match="Account is inactive"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("100.00"),
                description="Salary",
            )

    def test_r4_and_r11_invalid_amount_fails(self, test_bundle: ServiceBundle) -> None:
        """R4 & R11: Amount is zero or negative."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        with pytest.raises(ValueError, match="greater than 0"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("0.00"),
                description="Zero amount",
            )

        with pytest.raises(ValueError, match="greater than 0"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="INCOME",
                amount=Decimal("-10.00"),
                description="Negative amount",
            )

    def test_r5_expense_success(self, test_bundle: ServiceBundle) -> None:
        """R5: Expense transaction.

        Validates active account, positive amount, active category,
        sufficient funds, and budget not exceeded.
        """
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        # Assign budget of 100
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(
            cat.id, Decimal("100.00"), now.month, now.year
        )
        # Fund account
        test_bundle.service.register_transaction(
            acc.id, None, "INCOME", Decimal("200.00"), "Funding"
        )

        # Register expense
        tx, exceeded = test_bundle.service.register_transaction(
            account_id=acc.id,
            category_id=cat.id,
            transaction_type="EXPENSE",
            amount=Decimal("40.00"),
            description="Lunch",
        )
        assert tx.amount == Decimal("40.00")
        assert not exceeded
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("160.00")  # type: ignore

    def test_r6_expense_exceeds_budget_success(
        self, test_bundle: ServiceBundle
    ) -> None:
        """R6: Expense registers successfully but returns exceeded = True."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        # Assign budget of 50
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(cat.id, Decimal("50.00"), now.month, now.year)
        # Fund account
        test_bundle.service.register_transaction(
            acc.id, None, "INCOME", Decimal("200.00"), "Funding"
        )

        # Expense of 60 exceeds budget limit of 50
        tx, exceeded = test_bundle.service.register_transaction(
            account_id=acc.id,
            category_id=cat.id,
            transaction_type="EXPENSE",
            amount=Decimal("60.00"),
            description="Steak dinner",
        )
        assert tx.amount == Decimal("60.00")
        assert exceeded
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("140.00")  # type: ignore

    def test_r7_expense_no_category_fails(self, test_bundle: ServiceBundle) -> None:
        """R7: Expense registered without category_id."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        with pytest.raises(ValueError, match="An expense must have a category"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=None,
                transaction_type="EXPENSE",
                amount=Decimal("10.00"),
                description="Missing category",
            )

    def test_r8_expense_inactive_category_fails(
        self, test_bundle: ServiceBundle
    ) -> None:
        """R8: Expense registered on an inactive/soft-deleted category."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        test_bundle.service.deactivate_category(cat.id)

        # Fund account
        test_bundle.service.register_transaction(
            acc.id, None, "INCOME", Decimal("100.00"), "Funding"
        )

        with pytest.raises(ValueError, match="Category is inactive"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=cat.id,
                transaction_type="EXPENSE",
                amount=Decimal("10.00"),
                description="Inactive category expense",
            )

    def test_r9_expense_insufficient_funds_fails(
        self, test_bundle: ServiceBundle
    ) -> None:
        """R9: Expense fails due to lack of funds."""
        acc = test_bundle.service.create_account(name="Active BCP", bank="BCP")
        cat = test_bundle.service.create_category(name="Food")
        # Try to spend without funding
        with pytest.raises(InsufficientFundsError, match="Insufficient funds"):
            test_bundle.service.register_transaction(
                account_id=acc.id,
                category_id=cat.id,
                transaction_type="EXPENSE",
                amount=Decimal("10.00"),
                description="Lunch",
            )


# ─────────────────────────────────────────────────────────────
# 2. State Transition Testing (Transición de Estados)
# ─────────────────────────────────────────────────────────────


class TestStateTransition:
    """Verifies state transitions for Budgets and Accounts."""

    def test_budget_state_transitions(self, test_bundle: ServiceBundle) -> None:
        """Validates S1 -> S2 -> S3 -> S4 state transitions."""
        acc = test_bundle.service.create_account(name="Card", bank="BCP")
        cat = test_bundle.service.create_category(name="Transport")
        now = datetime.now(timezone.utc)

        # S1 (UNASSIGNED): Check that budget status calculation fails before assignment
        with pytest.raises(ValueError, match="Budget not found"):
            test_bundle.service.calculate_budget_status(uuid4())

        # S1 -> S2 (UNDER_LIMIT): Assign budget of 100
        budget = test_bundle.service.assign_budget(
            cat.id, Decimal("100.00"), now.month, now.year
        )
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("0.00")
        assert not exceeded  # S2: Under limit

        # Fund account
        test_bundle.service.register_transaction(
            acc.id, None, "INCOME", Decimal("200.00"), "Fund"
        )

        # S2 -> S2: Spend 50 (total spent = 50 < 100)
        _, exceeded = test_bundle.service.register_transaction(
            acc.id, cat.id, "EXPENSE", Decimal("50.00"), "Bus"
        )
        assert not exceeded
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("50.00")
        assert not exceeded

        # S2 -> S3 (AT_LIMIT): Spend another 50 (total spent = 100 == 100)
        _, exceeded = test_bundle.service.register_transaction(
            acc.id, cat.id, "EXPENSE", Decimal("50.00"), "Taxi"
        )
        assert not exceeded
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("100.00")
        assert (
            not exceeded
        )  # Strictly speaking, 'exceeded' is total_spent > limit. 100 is not > 100.

        # S3 -> S4 (EXCEEDED): Spend 0.01 (total spent = 100.01 > 100)
        _, exceeded = test_bundle.service.register_transaction(
            acc.id, cat.id, "EXPENSE", Decimal("0.01"), "Train"
        )
        assert exceeded
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("100.01")
        assert exceeded

        # S4 -> S2: Update budget to 150 (new_limit > total_spent)
        test_bundle.service.assign_budget(
            cat.id, Decimal("150.00"), now.month, now.year
        )
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("100.01")
        assert not exceeded  # Back to UNDER_LIMIT (S2)

        # S2 -> S4: Lower budget to 80 (new_limit < total_spent)
        test_bundle.service.assign_budget(cat.id, Decimal("80.00"), now.month, now.year)
        spent, exceeded = test_bundle.service.calculate_budget_status(budget.id)
        assert spent == Decimal("100.01")
        assert exceeded  # Back to EXCEEDED (S4)


# ─────────────────────────────────────────────────────────────
# 3. Use Case Testing (Pruebas de Casos de Uso)
# ─────────────────────────────────────────────────────────────


class TestUseCases:
    """Validates specific use case flows from end-to-end (excluding UC-1)."""

    def test_uc2_setup_environment(self, test_bundle: ServiceBundle) -> None:
        """UC-2: Create account, category, and budget with Upsert."""
        # 1. Create account
        acc = test_bundle.service.create_account(name="Wallet", bank="Cash")
        assert acc.current_balance == Decimal("0.00")
        assert acc.is_active

        # 2. Create category
        cat = test_bundle.service.create_category(name="Entertainment")
        assert cat.is_active

        # 3. Assign budget for current month
        now = datetime.now(timezone.utc)
        budget = test_bundle.service.assign_budget(
            cat.id, Decimal("100.00"), now.month, now.year
        )
        assert budget.limit_amount == Decimal("100.00")

        # 3.1. Flow Alt: Assign budget again to same period (updates existing)
        updated_budget = test_bundle.service.assign_budget(
            cat.id, Decimal("120.00"), now.month, now.year
        )
        assert updated_budget.id == budget.id
        assert updated_budget.limit_amount == Decimal("120.00")
        assert len(test_bundle.budgets.list_all()) == 1

        # 3.2. Flow Ex: Invalid budget limits or month ranges
        with pytest.raises(ValueError, match="greater than 0"):
            test_bundle.service.assign_budget(
                cat.id, Decimal("-10.00"), now.month, now.year
            )
        with pytest.raises(ValueError, match="between 1 and 12"):
            test_bundle.service.assign_budget(cat.id, Decimal("50.00"), 13, 2026)

    def test_uc3_expense_and_budget_monitoring(
        self, test_bundle: ServiceBundle
    ) -> None:
        """UC-3: Income, expenses, budget warnings, and insufficient funds."""
        acc = test_bundle.service.create_account(name="Account", bank="BCP")
        cat = test_bundle.service.create_category(name="Rent")
        now = datetime.now(timezone.utc)
        test_bundle.service.assign_budget(
            cat.id, Decimal("300.00"), now.month, now.year
        )

        # 1. Register Income
        test_bundle.service.register_transaction(
            acc.id, None, "INCOME", Decimal("500.00"), "Scholarship"
        )
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("500.00")  # type: ignore

        # 2. Register Expense under limit
        tx1, exceeded = test_bundle.service.register_transaction(
            acc.id, cat.id, "EXPENSE", Decimal("200.00"), "Rent Part 1"
        )
        assert not exceeded
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("300.00")  # type: ignore

        # 3. Register Expense exceeding budget limit but within balance
        # (exceeded = True)
        tx2, exceeded = test_bundle.service.register_transaction(
            acc.id, cat.id, "EXPENSE", Decimal("100.01"), "Rent Part 2"
        )
        assert exceeded
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("199.99")  # type: ignore

        # 4. Register Expense exceeding funds (raises InsufficientFundsError)
        with pytest.raises(InsufficientFundsError):
            test_bundle.service.register_transaction(
                acc.id, cat.id, "EXPENSE", Decimal("200.00"), "Overdraft"
            )
        # Verify balance remained intact
        assert test_bundle.accounts.get(acc.id).current_balance == Decimal("199.99")  # type: ignore

    def test_uc4_archiving_and_preservation(self, test_bundle: ServiceBundle) -> None:
        """UC-4: Soft delete. History preserved but new blocked."""
        acc = test_bundle.service.create_account(name="Credit Card", bank="BBVA")
        cat = test_bundle.service.create_category(name="Books")

        # Register some history
        test_bundle.service.register_transaction(
            acc.id, None, "INCOME", Decimal("100.00"), "Gift"
        )
        test_bundle.service.register_transaction(
            acc.id, cat.id, "EXPENSE", Decimal("40.00"), "Clean Code"
        )

        # Soft Delete Account
        test_bundle.service.deactivate_account(acc.id)
        assert not test_bundle.accounts.get(acc.id).is_active  # type: ignore
        assert acc not in test_bundle.service.list_active_accounts()

        # Check history is preserved in repository
        assert len(test_bundle.transactions.list_all()) == 2

        # Block new transactions on inactive account
        with pytest.raises(ValueError, match="Account is inactive"):
            test_bundle.service.register_transaction(
                acc.id, None, "INCOME", Decimal("10.00"), "New Income"
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
