"""Dependency injection bootstrap for the finance application."""

from __future__ import annotations

import json
import os
from dataclasses import dataclass
from decimal import Decimal

from finance.adapters.outbound.db_memory.memory_repos import (
    InMemoryAccountRepository,
    InMemoryBudgetRepository,
    InMemoryCategoryRepository,
    InMemoryTransactionRepository,
    InMemoryUserRepository,
)
from finance.core.app.services import FinanceService


@dataclass(slots=True)
class AppContainer:
    """Container with wired application services.

    Attributes:
        finance_service: The orchestrated finance service.
    """

    finance_service: FinanceService


def _load_seed_data(service: FinanceService) -> None:
    """Load sample data from seed_data.json into any service."""
    seed_path = os.path.join(
        os.path.dirname(__file__),
        "..",
        "adapters",
        "inbound",
        "ui_python",
        "seed_data.json",
    )
    if not os.path.exists(seed_path):
        return
    with open(seed_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    cat_map: dict[str, object] = {}
    for cat_name in data.get("categories", []):
        cat = service.create_category(cat_name)
        cat_map[cat_name] = cat.id

    acc_map: dict[str, object] = {}
    for acc_data in data.get("accounts", []):
        acc = service.create_account(acc_data["name"], acc_data["bank"])
        acc_map[acc_data["name"]] = acc.id

    for b_data in data.get("budgets", []):
        cat_id = cat_map.get(b_data["category"])
        if cat_id is not None:
            service.assign_budget(
                category_id=cat_id,
                limit_amount=Decimal(str(b_data["limit"])),
                month=b_data["month"],
                year=b_data["year"],
            )

    for t_data in data.get("transactions", []):
        acc_id = acc_map.get(t_data["account"])
        cat_id = cat_map.get(t_data["category"]) if t_data.get("category") else None
        if acc_id is not None:
            service.register_transaction(
                account_id=acc_id,
                category_id=cat_id,
                transaction_type=t_data["type"],
                amount=Decimal(str(t_data["amount"])),
                description=t_data["description"],
            )
    print("[SEED] Datos de prueba cargados correctamente")


def build_container() -> AppContainer:
    """Wire repositories and services.

    Returns:
        A configured AppContainer instance.
    """
    users = InMemoryUserRepository()
    accounts = InMemoryAccountRepository()
    categories = InMemoryCategoryRepository()
    budgets = InMemoryBudgetRepository()
    transactions = InMemoryTransactionRepository()

    service = FinanceService(
        user_repository=users,
        account_repository=accounts,
        category_repository=categories,
        budget_repository=budgets,
        transaction_repository=transactions,
    )

    _load_seed_data(service)

    return AppContainer(finance_service=service)
