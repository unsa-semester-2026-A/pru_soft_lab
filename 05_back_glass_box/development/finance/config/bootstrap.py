"""Dependency injection bootstrap for the finance application."""

from __future__ import annotations
from dataclasses import dataclass
from uuid import UUID

from finance.core.app.services import FinanceService
from finance.core.domain.entities import Account, Budget, Category, Transaction, User
from finance.core.ports.outbound import (
    AccountRepository,
    BudgetRepository,
    CategoryRepository,
    TransactionRepository,
    UserRepository,
)

@dataclass
class InMemoryUserRepository(UserRepository):
    """In-memory user repository."""
    items: dict[UUID, User]
    def add(self, user: User) -> None:
        self.items[user.id] = user
    def get(self, user_id: UUID) -> User | None:
        return self.items.get(user_id)

@dataclass
class InMemoryAccountRepository(AccountRepository):
    """In-memory account repository."""
    items: dict[UUID, Account]
    def add(self, account: Account) -> None:
        self.items[account.id] = account
    def get(self, account_id: UUID) -> Account | None:
        return self.items.get(account_id)
    def update(self, account: Account) -> None:
        self.items[account.id] = account

@dataclass
class InMemoryCategoryRepository(CategoryRepository):
    """In-memory category repository."""
    items: dict[UUID, Category]
    def add(self, category: Category) -> None:
        self.items[category.id] = category
    def get(self, category_id: UUID) -> Category | None:
        return self.items.get(category_id)
    def update(self, category: Category) -> None:
        self.items[category.id] = category
@dataclass
class InMemoryBudgetRepository(BudgetRepository):
    """In-memory budget repository."""
    items: dict[UUID, Budget]
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
class InMemoryTransactionRepository(TransactionRepository):
    """In-memory transaction repository."""
    items: list[Transaction]
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

class AppContainer:
    """Container with wired application services."""
    
    finance_service: FinanceService
    
    def build_container() -> AppContainer:
        """Wire repositories and services."""
        users = InMemoryUserRepository(items={})
        accounts = InMemoryAccountRepository(items={})
        categories = InMemoryCategoryRepository(items={})
        budgets = InMemoryBudgetRepository(items={})
        transactions = InMemoryTransactionRepository(items=[])
        service = FinanceService(
            user_repository=users,
            account_repository=accounts,
            category_repository=categories,
            budget_repository=budgets,
            transaction_repository=transactions,
        )
        
        return AppContainer(finance_service=service)