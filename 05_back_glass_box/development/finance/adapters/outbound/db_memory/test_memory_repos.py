"""Tests for in-memory repositories using equivalence partitioning."""

from datetime import datetime
from decimal import Decimal
from uuid import uuid4

import pytest

from finance.adapters.outbound.db_memory.memory_repos import (
    InMemoryAccountRepository,
    InMemoryBudgetRepository,
    InMemoryCategoryRepository,
    InMemoryTransactionRepository,
    InMemoryUserRepository,
)
from finance.core.domain.entities import (
    Account,
    Budget,
    Category,
    Transaction,
    TransactionType,
    User,
)


class TestInMemoryUserRepository:
    """Test suite for UserRepository."""

    def test_add_and_get_user(self):
        """PE: Usuario agregado debe ser recuperable."""
        repo = InMemoryUserRepository()
        user = User(name="Juan Perez", email="juan@test.com")

        repo.add(user)
        retrieved = repo.get(user.id)

        assert retrieved is not None
        assert retrieved.id == user.id
        assert retrieved.name == "Juan Perez"

    def test_get_nonexistent_user_returns_none(self):
        """PE: ID inexistente debe retornar None."""
        repo = InMemoryUserRepository()
        result = repo.get(uuid4())
        assert result is None


class TestInMemoryAccountRepository:
    """Test suite for AccountRepository with soft delete."""

    def test_get_active_account(self):
        """PE: Cuenta activa debe ser recuperable."""
        repo = InMemoryAccountRepository()
        account = Account(name="Ahorros", bank="BBVA")
        repo.add(account)

        result = repo.get(account.id)

        assert result is not None
        assert result.name == "Ahorros"

    def test_get_inactive_account_returns_none(self):
        """PE: Soft delete - cuenta inactiva NO debe ser recuperable."""
        repo = InMemoryAccountRepository()
        account = Account(name="Inactiva", bank="BCP")
        account.is_active = False
        repo.add(account)

        result = repo.get(account.id)

        assert result is None

    def test_get_nonexistent_account_returns_none(self):
        """PE: ID inexistente debe retornar None."""
        repo = InMemoryAccountRepository()
        result = repo.get(uuid4())
        assert result is None

    def test_update_existing_account(self):
        """PE: Actualizar cuenta existente modifica los datos."""
        repo = InMemoryAccountRepository()
        account = Account(name="Original", bank="Original")
        repo.add(account)

        account.name = "Modificado"
        repo.update(account)

        retrieved = repo.get(account.id)

        assert retrieved is not None  # ← Línea clave añadida
        assert retrieved.name == "Modificado"

    def test_update_nonexistent_account_raises_error(self):
        """PE: Actualizar cuenta inexistente debe lanzar ValueError."""
        repo = InMemoryAccountRepository()
        fake_account = Account(name="Fake", bank="Fake")
        fake_account.id = uuid4()

        with pytest.raises(ValueError, match="not found"):
            repo.update(fake_account)


class TestInMemoryCategoryRepository:
    """Test suite for CategoryRepository with soft delete."""

    def test_get_active_category(self):
        """PE: Categoría activa debe ser recuperable."""
        repo = InMemoryCategoryRepository()
        category = Category(name="Comida")
        repo.add(category)

        result = repo.get(category.id)

        assert result is not None
        assert result.name == "Comida"

    def test_get_inactive_category_returns_none(self):
        """PE: Soft delete - categoría inactiva NO debe ser recuperable."""
        repo = InMemoryCategoryRepository()
        category = Category(name="Inactiva")
        category.is_active = False
        repo.add(category)

        result = repo.get(category.id)

        assert result is None


class TestInMemoryBudgetRepository:
    """Test suite for BudgetRepository with special query."""

    def test_get_by_category_and_period_exact_match(self):
        """AVL: Búsqueda exacta por categoría y período debe funcionar."""
        repo = InMemoryBudgetRepository()
        category_id = uuid4()
        budget = Budget(
            category_id=category_id, month=5, year=2026, limit_amount=Decimal("1000")
        )
        repo.add(budget)

        result = repo.get_by_category_and_period(category_id, 5, 2026)

        assert result is not None
        assert result.limit_amount == Decimal("1000")

    def test_get_by_category_and_period_wrong_month_returns_none(self):
        """AVL: Cambiar el mes debe retornar None."""
        repo = InMemoryBudgetRepository()
        category_id = uuid4()
        budget = Budget(
            category_id=category_id,
            month=5,
            year=2026,
            limit_amount=Decimal("100.00"),
        )
        repo.add(budget)

        result = repo.get_by_category_and_period(category_id, 6, 2026)

        assert result is None

    def test_get_by_category_and_period_wrong_year_returns_none(self):
        """AVL: Cambiar el año debe retornar None."""
        repo = InMemoryBudgetRepository()
        category_id = uuid4()
        budget = Budget(
            category_id=category_id,
            month=5,
            year=2026,
            limit_amount=Decimal("100.00"),
        )
        repo.add(budget)

        result = repo.get_by_category_and_period(category_id, 5, 2025)

        assert result is None


class TestInMemoryTransactionRepository:
    """Test suite for TransactionRepository."""

    def test_add_and_list_transactions_by_period(self):
        """PE: Transacciones deben filtrarse correctamente por período."""
        repo = InMemoryTransactionRepository()
        category_id = uuid4()
        account_id = uuid4()

        trans1 = Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=TransactionType.EXPENSE,
            amount=Decimal("100"),
            description="Test",
            created_at=datetime(2026, 5, 15),
        )
        trans2 = Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=TransactionType.EXPENSE,
            amount=Decimal("200"),
            description="Test",
            created_at=datetime(2026, 5, 20),
        )
        trans3 = Transaction(
            account_id=account_id,
            category_id=category_id,
            transaction_type=TransactionType.EXPENSE,
            amount=Decimal("300"),
            description="Test",
            created_at=datetime(2026, 6, 1),  # Mes diferente
        )

        repo.add(trans1)
        repo.add(trans2)
        repo.add(trans3)

        result = repo.list_by_category_and_period(category_id, 5, 2026)

        assert len(result) == 2
        assert result[0].amount == Decimal("100")
        assert result[1].amount == Decimal("200")
