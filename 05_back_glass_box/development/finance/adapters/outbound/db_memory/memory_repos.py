"""In-memory repositories for testing and development."""

from typing import Dict, List
from uuid import UUID

from finance.core.domain.entities import (
    Account,
    Budget,
    Category,
    Transaction,
    User,
)
from finance.core.ports.outbound import (
    AccountRepository,
    BudgetRepository,
    CategoryRepository,
    TransactionRepository,
    UserRepository,
)


class InMemoryUserRepository(UserRepository):
    """User repository that stores data in a dictionary."""

    def __init__(self):
        """Initialize empty storage."""
        self._storage: Dict[UUID, User] = {}

    def add(self, user: User) -> None:
        """Add a user to memory."""
        self._storage[user.id] = user

    def get(self, user_id: UUID) -> User | None:
        """Retrieve a user by ID (only active users)."""
        user = self._storage.get(user_id)
        return user if user else None

    def update(self, user: User) -> None:
        """Update an existing user."""
        if user.id not in self._storage:
            raise ValueError(f"User with id {user.id} not found")
        self._storage[user.id] = user


class InMemoryAccountRepository(AccountRepository):
    """Account repository that stores data in a dictionary."""

    def __init__(self):
        """Initialize empty storage."""
        self._storage: Dict[UUID, Account] = {}

    def add(self, account: Account) -> None:
        """Add an account to memory."""
        self._storage[account.id] = account

    def get(self, account_id: UUID) -> Account | None:
        """Retrieve an account by ID (only active accounts - soft delete)."""
        account = self._storage.get(account_id)
        if account and account.is_active:
            return account
        return None

    def update(self, account: Account) -> None:
        """Update an existing account."""
        if account.id not in self._storage:
            raise ValueError(f"Account with id {account.id} not found")
        self._storage[account.id] = account


class InMemoryCategoryRepository(CategoryRepository):
    """Category repository that stores data in a dictionary."""

    def __init__(self):
        """Initialize empty storage."""
        self._storage: Dict[UUID, Category] = {}

    def add(self, category: Category) -> None:
        """Add a category to memory."""
        self._storage[category.id] = category

    def get(self, category_id: UUID) -> Category | None:
        """Retrieve a category by ID (only active categories - soft delete)."""
        category = self._storage.get(category_id)
        if category and category.is_active:
            return category
        return None

    def update(self, category: Category) -> None:
        """Update an existing category."""
        if category.id not in self._storage:
            raise ValueError(f"Category with id {category.id} not found")
        self._storage[category.id] = category


class InMemoryBudgetRepository(BudgetRepository):
    """Budget repository that stores data in a dictionary."""

    def __init__(self):
        """Initialize empty storage."""
        self._storage: Dict[UUID, Budget] = {}

    def add(self, budget: Budget) -> None:
        """Add a budget to memory."""
        self._storage[budget.id] = budget

    def get_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> Budget | None:
        """Retrieve a budget by category and period."""
        for budget in self._storage.values():
            if (
                budget.category_id == category_id
                and budget.month == month
                and budget.year == year
            ):
                return budget
        return None

    def update(self, budget: Budget) -> None:
        """Update an existing budget."""
        if budget.id not in self._storage:
            raise ValueError(f"Budget with id {budget.id} not found")
        self._storage[budget.id] = budget


class InMemoryTransactionRepository(TransactionRepository):
    """Transaction repository that stores data in a list."""

    def __init__(self):
        """Initialize empty storage."""
        self._storage: List[Transaction] = []

    def add(self, transaction: Transaction) -> None:
        """Add a transaction to memory."""
        self._storage.append(transaction)

    def list_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> list[Transaction]:
        """List transactions for a category and period."""
        result = []
        for transaction in self._storage:
            if (
                transaction.category_id == category_id
                and transaction.created_at.month == month
                and transaction.created_at.year == year
            ):
                result.append(transaction)
        return result
