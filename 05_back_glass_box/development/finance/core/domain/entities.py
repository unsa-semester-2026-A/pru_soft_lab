"""Domain entities for the finance application."""
from __future__ import annotations
from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal
from enum import Enum
from uuid import UUID, uuid4

class TransactionType(Enum):
    """Allowed transaction types."""    
    INCOME = "INCOME"
    EXPENSE = "EXPENSE"

class InsufficientFundsError(ValueError):
    """Raised when an account lacks sufficient balance for an expense."""
    

@dataclass(slots=True)
class User:
    """User profile."""
    name: str
    email: str
    id: UUID = field(default_factory=uuid4)
    
    
@dataclass(slots=True)
class Account:
    """Financial account linked to a user."""
    name: str
    bank: str
    current_balance: Decimal = Decimal("0.00")
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)
    
    
@dataclass(slots=True)
class Category:
    """Spending category for transactions."""
    name: str
    is_active: bool = True
    id: UUID = field(default_factory=uuid4)


@dataclass(slots=True)
class Budget:
    """Monthly budget for a specific category."""
    category_id: UUID
    month: int
    year: int
    limit_amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)


@dataclass(slots=True)
class Transaction:
    """Financial movement."""
    account_id: UUID
    category_id: UUID
    transaction_type: TransactionType
    description: str
    created_at: datetime
    amount: Decimal = Decimal("0.00")
    id: UUID = field(default_factory=uuid4)