"""Tests for in-memory repositories using EP and BVA."""

from datetime import datetime
from decimal import Decimal
from uuid import UUID, uuid4

import pytest

from finance.adapters.outbound.db_memory.memory_repos import (
    InMemoryAccountRepository,
    InMemoryBudgetRepository,
    InMemoryCategoryRepository,
    InMemoryTransactionRepository,
    InMemoryUserRepository,
)
from finance.core.domain.entities import (
    Account,
    Budget,
    Transaction,
    TransactionType,
)

# ─────────────────────────────────────────────────────────────
# Fixtures
# ─────────────────────────────────────────────────────────────


@pytest.fixture
def user_repo():
    return InMemoryUserRepository()


@pytest.fixture
def account_repo():
    return InMemoryAccountRepository()


@pytest.fixture
def category_repo():
    return InMemoryCategoryRepository()


@pytest.fixture
def budget_repo():
    return InMemoryBudgetRepository()


@pytest.fixture
def transaction_repo():
    return InMemoryTransactionRepository()


# ─────────────────────────────────────────────────────────────
# Repository Tests
# ─────────────────────────────────────────────────────────────


class TestInMemoryAccountRepository:
    """Test suite for AccountRepository."""

    def test_add_and_get_active(self, account_repo: InMemoryAccountRepository) -> None:
        """PE: Active account retrieval."""
        account = Account(name="SA", bank="B")
        account_repo.add(account)
        assert account_repo.get(account.id) == account

    def test_get_inactive_returns_none(
        self, account_repo: InMemoryAccountRepository
    ) -> None:
        """PE: Inactive account (soft delete) should not be returned by get()."""
        account = Account(name="IA", bank="B", is_active=False)
        account_repo.add(account)
        assert account_repo.get(account.id) is None

    def test_list_all_includes_inactive(
        self, account_repo: InMemoryAccountRepository
    ) -> None:
        """PE: list_all should return everything regardless of is_active."""
        acc1 = Account(name="AC", bank="B")
        acc2 = Account(name="IA", bank="B", is_active=False)
        account_repo.add(acc1)
        account_repo.add(acc2)
        assert len(account_repo.list_all()) == 2


class TestInMemoryTransactionRepository:
    """Test suite for TransactionRepository."""

    @pytest.mark.parametrize(
        "txn_date, should_be_found",
        [
            (datetime(2026, 5, 1), True),  # AVL: First day of target month
            (datetime(2026, 5, 31), True),  # AVL: Last day of target month
            (datetime(2026, 4, 30), False),  # AVL: Last day of previous month
            (datetime(2026, 6, 1), False),  # AVL: First day of next month
            (datetime(2025, 5, 1), False),  # AVL: Same month, wrong year
        ],
    )
    def test_list_by_category_and_period_boundaries(
        self,
        transaction_repo: InMemoryTransactionRepository,
        txn_date: datetime,
        should_be_found: bool,
    ) -> None:
        """AVL: Testing date boundaries for period-based listing."""
        cat_id = uuid4()
        acc_id = uuid4()
        txn = Transaction(
            account_id=acc_id,
            category_id=cat_id,
            transaction_type=TransactionType.EXPENSE,
            amount=Decimal("10"),
            description="T",
            created_at=txn_date,
        )
        transaction_repo.add(txn)

        results = transaction_repo.list_by_category_and_period(cat_id, 5, 2026)

        if should_be_found:
            assert txn in results
        else:
            assert txn not in results


class TestInMemoryBudgetRepository:
    """Test suite for BudgetRepository."""

    def test_get_by_period_valid(self, budget_repo: InMemoryBudgetRepository) -> None:
        cat_id = uuid4()
        budget = Budget(
            category_id=cat_id, month=5, year=2026, limit_amount=Decimal("100")
        )
        budget_repo.add(budget)
        assert budget_repo.get_by_category_and_period(cat_id, 5, 2026) == budget

    @pytest.mark.parametrize(
        "search_cat, search_month, search_year",
        [
            (uuid4(), 5, 2026),  # PE: Wrong category
            (uuid4(), 4, 2026),  # PE: Wrong month
            (uuid4(), 5, 2025),  # PE: Wrong year
        ],
    )
    def test_get_by_period_missing(
        self,
        budget_repo: InMemoryBudgetRepository,
        search_cat: UUID,
        search_month: int,
        search_year: int,
    ) -> None:
        """PE: Búsqueda con parámetros incorrectos retorna None."""
        cat_id = uuid4()
        budget = Budget(
            category_id=cat_id, month=5, year=2026, limit_amount=Decimal("100")
        )
        budget_repo.add(budget)
        assert (
            budget_repo.get_by_category_and_period(
                search_cat, search_month, search_year
            )
            is None
        )
