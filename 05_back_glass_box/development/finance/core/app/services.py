"""Application services for the finance application."""

from __future__ import annotations

from datetime import datetime, timezone
from decimal import Decimal
from typing import Iterable
from uuid import UUID

from finance.core.domain.entities import (
    Account,
    Budget,
    Category,
    Transaction,
    TransactionType,
    User,
)
from finance.core.ports.inbound import FinanceInboundPort
from finance.core.ports.outbound import (
    AccountRepository,
    BudgetRepository,
    CategoryRepository,
    TransactionRepository,
    UserRepository,
)


class FinanceService(FinanceInboundPort):
    """Orchestrates finance flows using outbound ports."""

    def __init__(
        self,
        user_repository: UserRepository,
        account_repository: AccountRepository,
        category_repository: CategoryRepository,
        budget_repository: BudgetRepository,
        transaction_repository: TransactionRepository,
    ) -> None:
        """Initialize the service with required repositories.

        Args:
            user_repository: User persistence port.
            account_repository: Account persistence port.
            category_repository: Category persistence port.
            budget_repository: Budget persistence port.
            transaction_repository: Transaction persistence port.
        """
        self._user_repository = user_repository
        self._account_repository = account_repository
        self._category_repository = category_repository
        self._budget_repository = budget_repository
        self._transaction_repository = transaction_repository

    def create_user(self, name: str, email: str) -> User:
        """Create and persist a user profile.

        Args:
            name: Full name of the user.
            email: Email address of the user.

        Returns:
            The created User entity.
        """
        user = User(name=name, email=email)
        self._user_repository.add(user)
        return user

    def create_account(self, name: str, bank: str) -> Account:
        """Create and persist an account.

        Args:
            name: Name of the account.
            bank: Name of the bank.

        Returns:
            The created Account entity.
        """
        account = Account(name=name, bank=bank)
        self._account_repository.add(account)
        return account

    def create_category(self, name: str) -> Category:
        """Create and persist a category.

        Args:
            name: Name of the category.

        Returns:
            The created Category entity.
        """
        category = Category(name=name)
        self._category_repository.add(category)
        return category

    def assign_budget(
        self, category_id: UUID, limit_amount: Decimal, month: int, year: int
    ) -> Budget:
        """Assign a budget or update existing one for a period.

        Args:
            category_id: ID of the category.
            limit_amount: Spending limit.
            month: Month for the budget.
            year: Year for the budget.

        Returns:
            The created or updated Budget entity.
        """
        existing = self._budget_repository.get_by_category_and_period(
            category_id, month, year
        )
        if existing is None:
            budget = Budget(
                category_id=category_id,
                limit_amount=limit_amount,
                month=month,
                year=year,
            )
            self._budget_repository.add(budget)
            return budget
        updated = Budget(
            id=existing.id,
            category_id=existing.category_id,
            limit_amount=limit_amount,
            month=existing.month,
            year=existing.year,
        )
        self._budget_repository.update(updated)
        return updated

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

        Raises:
            ValueError: If the account is not found or transaction type is invalid.
        """
        account = self._account_repository.get(account_id)

        if account is None:
            raise ValueError("Account not found.")
        parsed_type = self._parse_transaction_type(transaction_type)
        transaction = Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=parsed_type,
            amount=amount,
            description=description,
            created_at=datetime.now(timezone.utc),
        )
        if parsed_type == TransactionType.INCOME:
            account.register_income(amount)
            self._account_repository.update(account)
            self._transaction_repository.add(transaction)
            return transaction, False

        account.register_expense(amount)
        self._account_repository.update(account)
        self._transaction_repository.add(transaction)
        exceeded = self._is_budget_exceeded(transaction)
        return transaction, exceeded

    def _parse_transaction_type(self, value: str) -> TransactionType:
        """Parse and validate transaction type input.

        Args:
            value: The transaction type string.

        Returns:
            The corresponding TransactionType enum member.

        Raises:
            ValueError: If the transaction type string is invalid.
        """
        try:
            return TransactionType(value.upper())
        except ValueError as exc:
            raise ValueError("Invalid transaction type.") from exc

    def _is_budget_exceeded(self, transaction: Transaction) -> bool:
        """Check whether the budget is exceeded after an expense.

        Args:
            transaction: The transaction that was just registered.

        Returns:
            True if the sum of expenses for the period exceeds the budget.
        """
        if transaction.category_id is None:
            return False
        month, year = transaction.created_at.month, transaction.created_at.year
        budget = self._budget_repository.get_by_category_and_period(
            transaction.category_id, month, year
        )
        if budget is None:
            return False
        transactions = self._transaction_repository.list_by_category_and_period(
            transaction.category_id, month, year
        )
        total_expenses = self._sum_expenses(transactions)
        return total_expenses > budget.limit_amount

    def list_active_accounts(self) -> list[Account]:
        """List all active accounts.

        Returns:
            A list of active Account entities.
        """
        all_accounts = self._account_repository.list_all()
        return [acc for acc in all_accounts if acc.is_active]

    def list_active_categories(self) -> list[Category]:
        """List all active categories.

        Returns:
            A list of active Category entities.
        """
        all_categories = self._category_repository.list_all()
        return [cat for cat in all_categories if cat.is_active]

    def deactivate_account(self, account_id: UUID) -> None:
        """Deactivate an account (soft delete).

        Args:
            account_id: The ID of the account to deactivate.

        Raises:
            ValueError: If the account is not found.
        """
        account = self._account_repository.get(account_id)
        if account is None:
            raise ValueError("Account not found.")
        account.is_active = False
        self._account_repository.update(account)

    def deactivate_category(self, category_id: UUID) -> None:
        """Deactivate a category (soft delete).

        Args:
            category_id: The ID of the category to deactivate.

        Raises:
            ValueError: If the category is not found.
        """
        category = self._category_repository.get(category_id)
        if category is None:
            raise ValueError("Category not found.")
        category.is_active = False
        self._category_repository.update(category)

    def list_all_budgets(self) -> list[Budget]:
        """List all defined budgets.

        Returns:
            A list of all Budget entities.
        """
        return self._budget_repository.list_all()

    def list_all_transactions(self) -> list[Transaction]:
        """List all registered transactions.

        Returns:
            A list of all Transaction entities.
        """
        return self._transaction_repository.list_all()

    def calculate_budget_status(self, budget_id: UUID) -> tuple[Decimal, bool]:
        """Calculate current spending status for a budget at runtime.

        Args:
            budget_id: The ID of the budget to check.

        Returns:
            A tuple containing (total_spent, is_exceeded).

        Raises:
            ValueError: If the budget is not found.
        """
        all_budgets = self._budget_repository.list_all()
        target = next((b for b in all_budgets if b.id == budget_id), None)

        if target is None:
            raise ValueError("Budget not found.")

        transactions = self._transaction_repository.list_by_category_and_period(
            target.category_id, target.month, target.year
        )
        total_spent = self._sum_expenses(transactions)
        return total_spent, total_spent > target.limit_amount

    def _sum_expenses(self, transactions: Iterable[Transaction]) -> Decimal:
        """Sum expenses from a list of transactions.

        Args:
            transactions: An iterable of transactions to process.

        Returns:
            The total decimal sum of all expense amounts.
        """
        total = Decimal("0")
        for transaction in transactions:
            if transaction.transaction_type == TransactionType.EXPENSE:
                total += transaction.amount
        return total
