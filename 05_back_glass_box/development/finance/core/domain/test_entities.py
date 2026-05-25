"""Tests for domain entities."""

from datetime import datetime
from decimal import Decimal
from uuid import uuid4

import pytest

from finance.core.domain.entities import (
    Account,
    Budget,
    Category,
    InsufficientFundsError,
    Transaction,
    TransactionType,
    User,
)


def test_user_creation_valid():
    """Test valid user creation."""
    user = User(name="John Doe", email="john@example.com")
    assert user.name == "John Doe"
    assert user.email == "john@example.com"
    assert user.id is not None


def test_user_creation_invalid_name():
    """Test user creation with empty name."""
    with pytest.raises(ValueError, match="User name cannot be empty"):
        User(name="", email="john@example.com")
    with pytest.raises(ValueError, match="User name cannot be empty"):
        User(name="   ", email="john@example.com")


def test_user_creation_invalid_email():
    """Test user creation with invalid email."""
    with pytest.raises(ValueError, match="Email cannot be empty"):
        User(name="John", email="")
    with pytest.raises(ValueError, match="Email must have a valid format"):
        User(name="John", email="invalidemail.com")


def test_account_creation_valid():
    """Test valid account creation."""
    account = Account(name="Savings", bank="Bank of America")
    assert account.name == "Savings"
    assert account.bank == "Bank of America"
    assert account.current_balance == Decimal("0.00")
    assert account.is_active is True


def test_account_creation_invalid():
    """Test account creation with empty strings."""
    with pytest.raises(ValueError, match="Account name cannot be empty"):
        Account(name="", bank="Bank")
    with pytest.raises(ValueError, match="Bank name cannot be empty"):
        Account(name="Savings", bank="  ")


def test_account_register_income_valid():
    """Test valid income registration."""
    account = Account(name="Savings", bank="Bank")
    account.register_income(Decimal("100.50"))
    assert account.current_balance == Decimal("100.50")
    account.register_income(Decimal("50.25"))
    assert account.current_balance == Decimal("150.75")


def test_account_register_income_invalid():
    """Test income registration with negative or zero amounts."""
    account = Account(name="Savings", bank="Bank")
    with pytest.raises(ValueError, match="Income amount must be positive"):
        account.register_income(Decimal("0.00"))
    with pytest.raises(ValueError, match="Income amount must be positive"):
        account.register_income(Decimal("-10.00"))


def test_account_register_expense_valid():
    """Test valid expense registration."""
    account = Account(name="S", bank="B", current_balance=Decimal("200.00"))
    account.register_expense(Decimal("50.00"))
    assert account.current_balance == Decimal("150.00")
    
    # Boundary Value: Exact balance
    account.register_expense(Decimal("150.00"))
    assert account.current_balance == Decimal("0.00")


def test_account_register_expense_invalid_amount():
    """Test expense registration with invalid amounts."""
    account = Account(name="S", bank="B", current_balance=Decimal("200.00"))
    with pytest.raises(ValueError, match="Expense amount must be positive"):
        account.register_expense(Decimal("0.00"))
    with pytest.raises(ValueError, match="Expense amount must be positive"):
        account.register_expense(Decimal("-50.00"))


def test_account_register_expense_insufficient_funds():
    """Test expense registration when funds are insufficient."""
    account = Account(name="S", bank="B", current_balance=Decimal("100.00"))
    # Boundary Value: Just 1 cent over
    with pytest.raises(
        InsufficientFundsError, match="Insufficient funds for this expense."
    ):
        account.register_expense(Decimal("100.01"))
    
    # Balance should remain unchanged
    assert account.current_balance == Decimal("100.00")


def test_category_creation():
    """Test valid and invalid category creation."""
    category = Category(name="Food")
    assert category.name == "Food"
    assert category.is_active is True

    with pytest.raises(ValueError, match="Category name cannot be empty"):
        Category(name="")


def test_budget_creation_valid():
    """Test valid budget creation."""
    cat_id = uuid4()
    budget = Budget(
        category_id=cat_id, month=5, year=2026, limit_amount=Decimal("500.00")
    )
    assert budget.limit_amount == Decimal("500.00")
    assert budget.month == 5
    assert budget.year == 2026


def test_budget_creation_invalid():
    """Test invalid budget creation boundaries."""
    cat_id = uuid4()
    with pytest.raises(ValueError, match="Budget limit must be greater than 0"):
        Budget(category_id=cat_id, month=5, year=2026, limit_amount=Decimal("0.00"))
    
    with pytest.raises(ValueError, match="Month must be between 1 and 12"):
        Budget(category_id=cat_id, month=0, year=2026, limit_amount=Decimal("100.00"))
        
    with pytest.raises(ValueError, match="Month must be between 1 and 12"):
        Budget(category_id=cat_id, month=13, year=2026, limit_amount=Decimal("100.00"))
        
    with pytest.raises(ValueError, match="Invalid year"):
        Budget(category_id=cat_id, month=5, year=1899, limit_amount=Decimal("100.00"))


def test_transaction_creation_income_valid():
    """Test valid income transaction."""
    acc_id = uuid4()
    tx = Transaction(
        account_id=acc_id,
        category_id=None,
        transaction_type=TransactionType.INCOME,
        description="Salary",
        created_at=datetime.now(),
        amount=Decimal("1000.00"),
    )
    assert tx.amount == Decimal("1000.00")


def test_transaction_creation_expense_valid():
    """Test valid expense transaction."""
    acc_id = uuid4()
    cat_id = uuid4()
    tx = Transaction(
        account_id=acc_id,
        category_id=cat_id,
        transaction_type=TransactionType.EXPENSE,
        description="Groceries",
        created_at=datetime.now(),
        amount=Decimal("50.00"),
    )
    assert tx.amount == Decimal("50.00")


def test_transaction_creation_invalid_amount():
    """Test transactions with invalid amounts."""
    acc_id = uuid4()
    with pytest.raises(ValueError, match="Transaction amount must be greater than 0"):
        Transaction(
            account_id=acc_id,
            category_id=None,
            transaction_type=TransactionType.INCOME,
            description="Salary",
            created_at=datetime.now(),
            amount=Decimal("0.00"),
        )
    with pytest.raises(ValueError, match="Transaction amount must be greater than 0"):
        Transaction(
            account_id=acc_id,
            category_id=None,
            transaction_type=TransactionType.INCOME,
            description="Salary",
            created_at=datetime.now(),
            amount=Decimal("-10.00"),
        )


def test_transaction_creation_invalid_category_logic():
    """Test transactions with mismatched category logic."""
    acc_id = uuid4()
    cat_id = uuid4()
    
    # Expense without category
    with pytest.raises(ValueError, match="An expense must have a category"):
        Transaction(
            account_id=acc_id,
            category_id=None,
            transaction_type=TransactionType.EXPENSE,
            description="Groceries",
            created_at=datetime.now(),
            amount=Decimal("50.00"),
        )
        
    # Income with category
    with pytest.raises(ValueError, match="An income must not have a category"):
        Transaction(
            account_id=acc_id,
            category_id=cat_id,
            transaction_type=TransactionType.INCOME,
            description="Salary",
            created_at=datetime.now(),
            amount=Decimal("1000.00"),
        )


def test_transaction_creation_invalid_description():
    """Test transactions with invalid description."""
    acc_id = uuid4()
    with pytest.raises(ValueError, match="Description cannot be empty"):
        Transaction(
            account_id=acc_id,
            category_id=None,
            transaction_type=TransactionType.INCOME,
            description="",
            created_at=datetime.now(),
            amount=Decimal("1000.00"),
        )
