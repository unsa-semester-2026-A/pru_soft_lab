"""Inbound ports (use cases) for the finance application."""

from __future__ import annotations

from decimal import Decimal
from typing import Protocol
from uuid import UUID

from finance.core.domain.entities import Account, Budget, Category, Transaction, User


class FinanceInboundPort(Protocol):
    """Use cases exposed to the outside world."""

    def create_user(self, name: str, email: str) -> User:
        """Create a user profile.

        Args:
            name: Full name of the user.
            email: Email address of the user.

        Returns:
            The created User entity.
        """
        ...

    def create_account(self, name: str, bank: str) -> Account:
        """Create a financial account.

        Args:
            name: Name of the account.
            bank: Name of the bank.

        Returns:
            The created Account entity.
        """
        ...

    def create_category(self, name: str) -> Category:
        """Create a transaction category.

        Args:
            name: Name of the category.

        Returns:
            The created Category entity.
        """
        ...

    def assign_budget(
        self, category_id: UUID, limit_amount: Decimal, month: int, year: int
    ) -> Budget:
        """Assign or update a budget for a category.

        Args:
            category_id: ID of the category.
            limit_amount: Spending limit.
            month: Month for the budget.
            year: Year for the budget.

        Returns:
            The created or updated Budget entity.
        """
        ...

    def register_transaction(
        self,
        account_id: UUID,
        category_id: UUID | None,
        transaction_type: str,
        amount: Decimal,
        description: str,
    ) -> tuple[Transaction, bool]:
        """Register a transaction and return budget status.

        Args:
            account_id: ID of the source account.
            category_id: ID of the category (None for income).
            transaction_type: 'INCOME' or 'EXPENSE'.
            amount: Transaction amount.
            description: Short description.

        Returns:
            A tuple containing the Transaction entity and a boolean indicating
            if the budget for that category has been exceeded.
        """
        ...

    def list_active_accounts(self) -> list[Account]:
        """List all active accounts.

        Returns:
            A list of active Account entities.
        """
        ...

    def list_active_categories(self) -> list[Category]:
        """List all active categories.

        Returns:
            A list of active Category entities.
        """
        ...

    def deactivate_account(self, account_id: UUID) -> None:
        """Deactivate an account (soft delete).

        Args:
            account_id: The ID of the account to deactivate.
        """
        ...

    def deactivate_category(self, category_id: UUID) -> None:
        """Deactivate a category (soft delete).

        Args:
            category_id: The ID of the category to deactivate.
        """
        ...

    def list_all_budgets(self) -> list[Budget]:
        """List all defined budgets.

        Returns:
            A list of all Budget entities.
        """
        ...

    def list_all_transactions(self) -> list[Transaction]:
        """List all registered transactions.

        Returns:
            A list of all Transaction entities.
        """
        ...

    def calculate_budget_status(self, budget_id: UUID) -> tuple[Decimal, bool]:
        """Calculate current spending status for a budget at runtime.

        Args:
            budget_id: The ID of the budget to check.

        Returns:
            A tuple containing (total_spent, is_exceeded).
        """
        ...
