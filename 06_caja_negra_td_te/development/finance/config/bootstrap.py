"""Dependency injection bootstrap for the finance application."""

from __future__ import annotations

from dataclasses import dataclass

from finance.adapters.outbound.db_memory.memory_repos import (
    InMemoryAccountRepository,
    InMemoryBudgetRepository,
    InMemoryCategoryRepository,
    InMemoryTransactionRepository,
    InMemoryUserRepository,
)
from finance.core.app.services import FinanceService


@dataclass(slots=True)
class AppContainer:
    """Container with wired application services.

    Attributes:
        finance_service: The orchestrated finance service.
    """

    finance_service: FinanceService


def build_container() -> AppContainer:
    """Wire repositories and services.

    Returns:
        A configured AppContainer instance.
    """
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

    return AppContainer(finance_service=service)
