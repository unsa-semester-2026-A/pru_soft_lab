"""Inbound ports (use cases) for the finance application."""

from __future__ import annotations

from decimal import Decimal
from typing import Protocol
from uuid import UUID

from finance.core.domain.entities import Account, Budget, Category, Transaction, User


class FinanceInboundPort(Protocol):
    """Use cases exposed to the outside world."""

    def create_user(self, name: str, email: str) -> User:
        """Create a user profile."""
        ...

    def create_account(self, name: str, bank: str) -> Account:
        """Create a financial account."""
        ...

    def create_category(self, name: str) -> Category:
        """Create a transaction category."""
        ...

    def assign_budget(
        self, category_id: UUID, limit_amount: Decimal, month: int, year: int
    ) -> Budget:
        """Assign or update a budget for a category."""
        ...

    def register_transaction(
        self,
        account_id: UUID,
        category_id: UUID | None,
        transaction_type: str,
        amount: Decimal,
        description: str,
    ) -> tuple[Transaction, bool]:
        """Register a transaction and return budget status."""
        ...
