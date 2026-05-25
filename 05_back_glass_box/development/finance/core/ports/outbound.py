"""Outbound ports (repositories) for the finance application."""

from __future__ import annotations
from typing import Protocol
from uuid import UUID
from finance.core.domain.entities import Account, Budget, Category, Transaction, User

class UserRepository(Protocol):
    """Persistence operations for users."""
    
    def add(self, user: User) -> None:
        """Persist a user."""
        
    def get(self, user_id: UUID) -> User | None:
        """Retrieve a user by id."""
    
    def update(self, user: User) -> None:
        """Update an existing user."""
        
        
class AccountRepository(Protocol):
    """Persistence operations for accounts."""
    def add(self, account: Account) -> None:
        """Persist an account."""
        
    def get(self, account_id: UUID) -> Account | None:
        """Retrieve an account by id."""
        
    def update(self, account: Account) -> None:
        """Update an existing account."""
        
        
class CategoryRepository(Protocol):
    """Persistence operations for categories."""
    def add(self, category: Category) -> None:
        """Persist a category."""
        
    def get(self, category_id: UUID) -> Category | None:
        """Retrieve a category by id."""
        
    def update(self, category: Category) -> None:
        """Update an existing category."""
        
        
class BudgetRepository(Protocol):
    """Persistence operations for budgets."""
    def add(self, budget: Budget) -> None:
        """Persist a budget."""
        
    def get_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> Budget | None:
        """Retrieve a budget by category and period."""
        
    def update(self, budget: Budget) -> None:
        """Update an existing budget."""
        
        
class TransactionRepository(Protocol):
    """Persistence operations for transactions."""
    def add(self, transaction: Transaction) -> None:
        """Persist a transaction."""
        
    def list_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> list[Transaction]:
        """List transactions for a category and period."""