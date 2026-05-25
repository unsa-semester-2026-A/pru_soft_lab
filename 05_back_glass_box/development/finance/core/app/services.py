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
        """Initialize the service with required repositories."""
        self._user_repository = user_repository
        self._account_repository = account_repository
        self._category_repository = category_repository
        self._budget_repository = budget_repository
        self._transaction_repository = transaction_repository

    def create_user(self, name: str, email: str) -> User:
        """Create and persist a user profile."""
        user = User(name=name, email=email)
        self._user_repository.add(user)
        return user

    def create_account(self, name: str, bank: str) -> Account:
        """Create and persist an account."""
        account = Account(name=name, bank=bank)
        self._account_repository.add(account)
        return account

    def create_category(self, name: str) -> Category:
        """Create and persist a category."""
        category = Category(name=name)
        self._category_repository.add(category)
        return category

    def assign_budget(
        self, category_id: UUID, limit_amount: Decimal, month: int, year: int
    ) -> Budget:
        """Assign a budget or update existing one for a period."""
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
        """Register a transaction and return budget status."""
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
        """Parse and validate transaction type input."""
        try:
            return TransactionType(value.upper())
        except ValueError as exc:
            raise ValueError("Invalid transaction type.") from exc

    def _is_budget_exceeded(self, transaction: Transaction) -> bool:
        """Check whether the budget is exceeded after an expense."""
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

    def _sum_expenses(self, transactions: Iterable[Transaction]) -> Decimal:
        """Sum expenses from a list of transactions."""
        total = Decimal("0")
        for transaction in transactions:
            if transaction.transaction_type == TransactionType.EXPENSE:
                total += transaction.amount
        return total
