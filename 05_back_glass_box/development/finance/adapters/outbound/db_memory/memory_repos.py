"""In-memory repositories for testing and development."""

from __future__ import annotations

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

    def __init__(self) -> None:
        """Initialize empty storage."""
        self._storage: dict[UUID, User] = {}

    def add(self, user: User) -> None:
        """Add a user to memory.

        Args:
            user: The User entity to save.
        """
        self._storage[user.id] = user

    def get(self, user_id: UUID) -> User | None:
        """Retrieve a user by ID.

        Args:
            user_id: The unique identifier of the user.

        Returns:
            The User entity if found, None otherwise.
        """
        user = self._storage.get(user_id)
        return user if user else None

    def update(self, user: User) -> None:
        """Update an existing user.

        Args:
            user: The User entity with updated information.

        Raises:
            ValueError: If the user is not found in storage.
        """
        if user.id not in self._storage:
            raise ValueError(f"User with id {user.id} not found")
        self._storage[user.id] = user


class InMemoryAccountRepository(AccountRepository):
    """Account repository that stores data in a dictionary."""

    def __init__(self) -> None:
        """Initialize empty storage."""
        self._storage: dict[UUID, Account] = {}

    def add(self, account: Account) -> None:
        """Add an account to memory.

        Args:
            account: The Account entity to save.
        """
        self._storage[account.id] = account

    def get(self, account_id: UUID) -> Account | None:
        """Retrieve an account by ID (only active accounts - soft delete).

        Args:
            account_id: The unique identifier of the account.

        Returns:
            The Account entity if found and active, None otherwise.
        """
        account = self._storage.get(account_id)
        if account and account.is_active:
            return account
        return None

    def update(self, account: Account) -> None:
        """Update an existing account.

        Args:
            account: The Account entity with updated information.

        Raises:
            ValueError: If the account is not found in storage.
        """
        if account.id not in self._storage:
            raise ValueError(f"Account with id {account.id} not found")
        self._storage[account.id] = account

    def list_all(self) -> list[Account]:
        """List all accounts (active and inactive).

        Returns:
            A list of all Account entities.
        """
        return list(self._storage.values())


class InMemoryCategoryRepository(CategoryRepository):
    """Category repository that stores data in a dictionary."""

    def __init__(self) -> None:
        """Initialize empty storage."""
        self._storage: dict[UUID, Category] = {}

    def add(self, category: Category) -> None:
        """Add a category to memory.

        Args:
            category: The Category entity to save.
        """
        self._storage[category.id] = category

    def get(self, category_id: UUID) -> Category | None:
        """Retrieve a category by ID (only active categories - soft delete).

        Args:
            category_id: The unique identifier of the category.

        Returns:
            The Category entity if found and active, None otherwise.
        """
        category = self._storage.get(category_id)
        if category and category.is_active:
            return category
        return None

    def update(self, category: Category) -> None:
        """Update an existing category.

        Args:
            category: The Category entity with updated information.

        Raises:
            ValueError: If the category is not found in storage.
        """
        if category.id not in self._storage:
            raise ValueError(f"Category with id {category.id} not found")
        self._storage[category.id] = category

    def list_all(self) -> list[Category]:
        """List all categories (active and inactive).

        Returns:
            A list of all Category entities.
        """
        return list(self._storage.values())


class InMemoryBudgetRepository(BudgetRepository):
    """Budget repository that stores data in a dictionary."""

    def __init__(self) -> None:
        """Initialize empty storage."""
        self._storage: dict[UUID, Budget] = {}

    def add(self, budget: Budget) -> None:
        """Add a budget to memory.

        Args:
            budget: The Budget entity to save.
        """
        self._storage[budget.id] = budget

    def get_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> Budget | None:
        """Retrieve a budget by category and period.

        Args:
            category_id: The ID of the linked category.
            month: The budget month.
            year: The budget year.

        Returns:
            The Budget entity if found, None otherwise.
        """
        for budget in self._storage.values():
            if (
                budget.category_id == category_id
                and budget.month == month
                and budget.year == year
            ):
                return budget
        return None

    def update(self, budget: Budget) -> None:
        """Update an existing budget.

        Args:
            budget: The Budget entity with updated information.

        Raises:
            ValueError: If the budget is not found in storage.
        """
        if budget.id not in self._storage:
            raise ValueError(f"Budget with id {budget.id} not found")
        self._storage[budget.id] = budget

    def list_all(self) -> list[Budget]:
        """List all budgets.

        Returns:
            A list of all Budget entities.
        """
        return list(self._storage.values())


class InMemoryTransactionRepository(TransactionRepository):
    """Transaction repository that stores data in a list."""

    def __init__(self) -> None:
        """Initialize empty storage."""
        self._storage: list[Transaction] = []

    def add(self, transaction: Transaction) -> None:
        """Add a transaction to memory.

        Args:
            transaction: The Transaction entity to save.
        """
        self._storage.append(transaction)

    def list_by_category_and_period(
        self, category_id: UUID, month: int, year: int
    ) -> list[Transaction]:
        """List transactions for a category and period.

        Args:
            category_id: The ID of the linked category.
            month: The month to filter by.
            year: The year to filter by.

        Returns:
            A list of Transaction entities matching the criteria.
        """
        result = []
        for transaction in self._storage:
            if (
                transaction.category_id == category_id
                and transaction.created_at.month == month
                and transaction.created_at.year == year
            ):
                result.append(transaction)
        return result

    def list_all(self) -> list[Transaction]:
        """List all transactions.

        Returns:
            A list of all Transaction entities.
        """
        return self._storage
