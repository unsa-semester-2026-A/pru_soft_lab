"""Outbound ports (repositories) for the finance application."""

from __future__ import annotations

from typing import Protocol
from uuid import UUID

from finance.core.domain.entities import Account, Budget, Category, Transaction, User


class UserRepository(Protocol):
    """Persistence operations for users."""

    def add(self, user: User) -> None:
        """Persist a user.

        Args:
            user: The User entity to save.
        """
        ...

    def get(self, user_id: UUID) -> User | None:
        """Retrieve a user by id.

        Args:
            user_id: The unique identifier of the user.

        Returns:
            The User entity if found, None otherwise.
        """
        ...

    def update(self, user: User) -> None:
        """Update an existing user.

        Args:
            user: The User entity with updated information.
        """
        ...


class AccountRepository(Protocol):
    """Persistence operations for accounts."""

    def add(self, account: Account) -> None:
        """Persist an account.

        Args:
            account: The Account entity to save.
        """
        ...

    def get(self, account_id: UUID) -> Account | None:
        """Retrieve an account by id.

        Args:
            account_id: The unique identifier of the account.

        Returns:
            The Account entity if found, None otherwise.
        """
        ...

    def update(self, account: Account) -> None:
        """Update an existing account.

        Args:
            account: The Account entity with updated information.
        """
        ...

    def list_all(self) -> list[Account]:
        """List all accounts (active and inactive).

        Returns:
            A list of all Account entities.
        """
        ...


class CategoryRepository(Protocol):
    """Persistence operations for categories."""

    def add(self, category: Category) -> None:
        """Persist a category.

        Args:
            category: The Category entity to save.
        """
        ...

    def get(self, category_id: UUID) -> Category | None:
        """Retrieve a category by id.

        Args:
            category_id: The unique identifier of the category.

        Returns:
            The Category entity if found, None otherwise.
        """
        ...

    def update(self, category: Category) -> None:
        """Update an existing category.

        Args:
            category: The Category entity with updated information.
        """
        ...

    def list_all(self) -> list[Category]:
        """List all categories (active and inactive).

        Returns:
            A list of all Category entities.
        """
        ...


class BudgetRepository(Protocol):
    """Persistence operations for budgets."""

    def add(self, budget: Budget) -> None:
        """Persist a budget.

        Args:
            budget: The Budget entity to save.
        """
        ...

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
        ...

    def update(self, budget: Budget) -> None:
        """Update an existing budget.

        Args:
            budget: The Budget entity with updated information.
        """
        ...

    def list_all(self) -> list[Budget]:
        """List all budgets.

        Returns:
            A list of all Budget entities.
        """
        ...


class TransactionRepository(Protocol):
    """Persistence operations for transactions."""

    def add(self, transaction: Transaction) -> None:
        """Persist a transaction.

        Args:
            transaction: The Transaction entity to save.
        """
        ...

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
        ...

    def list_all(self) -> list[Transaction]:
        """List all transactions.

        Returns:
            A list of all Transaction entities.
        """
        ...
