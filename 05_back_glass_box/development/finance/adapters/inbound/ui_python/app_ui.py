"""Main application window for the personal finance system.

Entry point for the graphical interface. Receives a service instance
via dependency injection so both DummyFinanceService (tests) and the
real FinanceService (production) can be used interchangeably.
"""

from __future__ import annotations

from typing import Any
from uuid import UUID

import customtkinter as ctk
import darkdetect

from finance.adapters.inbound.ui_python.dummy_service import DummyFinanceService
from finance.adapters.inbound.ui_python.views import (
    validate_amount,
    validate_month,
    validate_name,
    validate_year,
)


class FinanceApp(ctk.CTk):
    """Root window of the finance application.

    Manages navigation between views and holds a reference to the
    injected service. The UI never calls domain logic directly — all
    business operations go through the service.
    """

    def __init__(self, service: Any = None) -> None:
        """Initialize the root window and build the main UI.

        Args:
            service: The finance service to use for all operations.
                      If None, uses DummyFinanceService.
        """
        super().__init__()
        # If no service provided, use a dummy one for testing/non-blocking UI
        self._service: Any = service if service is not None else DummyFinanceService()
        self.title("Finanzas Personales")
        self.geometry("780x560")
        self.resizable(False, False)
        # Prefer explicit dark/light detection when available
        try:
            mode = "dark" if darkdetect.isDark() else "light"
            ctk.set_appearance_mode(mode)
        except Exception:
            ctk.set_appearance_mode("system")
        ctk.set_default_color_theme("blue")
        self._build_layout()

    def _build_layout(self) -> None:
        """Construct the sidebar and main content area."""
        self.grid_columnconfigure(1, weight=1)
        self.grid_rowconfigure(0, weight=1)

        # ── Sidebar ──────────────────────────────────────────
        sidebar = ctk.CTkFrame(self, width=180, corner_radius=0)
        sidebar.grid(row=0, column=0, sticky="nsew")
        sidebar.grid_rowconfigure(6, weight=1)

        ctk.CTkLabel(
            sidebar,
            text="Finanzas",
            font=ctk.CTkFont(size=18, weight="bold"),
        ).grid(row=0, column=0, padx=20, pady=(24, 16))

        nav_items: list[tuple[str, type[ctk.CTkFrame]]] = [
            ("Nueva cuenta", _FrameCuenta),
            ("Nueva categoría", _FrameCategoria),
            ("Presupuesto", _FramePresupuesto),
            ("Transacción", _FrameTransaccion),
        ]
        self._frames: dict[str, ctk.CTkFrame] = {}

        for row_idx, (label, frame_cls) in enumerate(nav_items, start=1):
            frame = frame_cls(self, self._service)
            frame.grid(row=0, column=1, sticky="nsew", padx=20, pady=20)
            self._frames[label] = frame

            btn = ctk.CTkButton(
                sidebar,
                text=label,
                command=lambda lbl=label: self._show(lbl),
                fg_color="transparent",
                text_color=("gray10", "gray90"),
                hover_color=("gray70", "gray30"),
                anchor="w",
            )
            btn.grid(row=row_idx, column=0, padx=10, pady=4, sticky="ew")

        self._show("Nueva cuenta")

    def _show(self, name: str) -> None:
        """Raise the selected frame to the front.

        Args:
            name: Key matching a registered frame.
        """
        for frame in self._frames.values():
            frame.grid_remove()
        self._frames[name].grid()


# ─────────────────────────────────────────────────────────────
# Shared helper
# ─────────────────────────────────────────────────────────────


def _set_status(label: ctk.CTkLabel, text: str, ok: bool) -> None:
    """Update a status label with colour-coded feedback.

    Args:
        label: The CTkLabel widget to update.
        text: Message to display.
        ok: True renders green (success), False renders red (error).
    """
    color = "#2ecc71" if ok else "#e74c3c"
    label.configure(text=text, text_color=color)


# ─────────────────────────────────────────────────────────────
# View: Nueva cuenta
# ─────────────────────────────────────────────────────────────


class _FrameCuenta(ctk.CTkFrame):
    """Form for creating a new financial account."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        """Initialize the account creation form.

        Args:
            parent: Root window.
            service: Finance service for account operations.
        """
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        """Build form widgets."""
        ctk.CTkLabel(
            self, text="Nueva cuenta", font=ctk.CTkFont(size=16, weight="bold")
        ).pack(anchor="w", pady=(0, 12))

        self._entry_name = ctk.CTkEntry(
            self, placeholder_text="Nombre (ej. Sueldo)", width=320
        )
        self._entry_name.pack(pady=6, anchor="w")

        self._entry_bank = ctk.CTkEntry(
            self, placeholder_text="Banco (ej. BCP)", width=320
        )
        self._entry_bank.pack(pady=6, anchor="w")

        ctk.CTkButton(self, text="Crear cuenta", command=self._submit).pack(
            pady=12, anchor="w"
        )

        self._status = ctk.CTkLabel(self, text="")
        self._status.pack(anchor="w")

    def _submit(self) -> None:
        """Validate inputs and call the service."""
        try:
            name = validate_name(self._entry_name.get())
            bank = validate_name(self._entry_bank.get())
            account = self._service.create_account(name=name, bank=bank)
            _set_status(self._status, f"Cuenta '{account.name}' creada.", ok=True)
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


# ─────────────────────────────────────────────────────────────
# View: Nueva categoría
# ─────────────────────────────────────────────────────────────


class _FrameCategoria(ctk.CTkFrame):
    """Form for creating a spending category."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        """Initialize the category form.

        Args:
            parent: Root window.
            service: Finance service for category operations.
        """
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        """Build form widgets."""
        ctk.CTkLabel(
            self, text="Nueva categoría", font=ctk.CTkFont(size=16, weight="bold")
        ).pack(anchor="w", pady=(0, 12))

        self._entry_name = ctk.CTkEntry(
            self, placeholder_text="Nombre (ej. Transporte)", width=320
        )
        self._entry_name.pack(pady=6, anchor="w")

        ctk.CTkButton(self, text="Crear categoría", command=self._submit).pack(
            pady=12, anchor="w"
        )

        self._status = ctk.CTkLabel(self, text="")
        self._status.pack(anchor="w")

    def _submit(self) -> None:
        """Validate input and call the service."""
        try:
            name = validate_name(self._entry_name.get())
            cat = self._service.create_category(name=name)
            _set_status(self._status, f"Categoría '{cat.name}' creada.", ok=True)
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


# ─────────────────────────────────────────────────────────────
# View: Presupuesto
# ─────────────────────────────────────────────────────────────


class _FramePresupuesto(ctk.CTkFrame):
    """Form for assigning a monthly budget to a category."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        """Initialize the budget form.

        Args:
            parent: Root window.
            service: Finance service for budget operations.
        """
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        """Build form widgets."""
        ctk.CTkLabel(
            self, text="Asignar presupuesto", font=ctk.CTkFont(size=16, weight="bold")
        ).pack(anchor="w", pady=(0, 12))

        self._entry_cat_id = ctk.CTkEntry(
            self, placeholder_text="UUID de categoría", width=320
        )
        self._entry_cat_id.pack(pady=6, anchor="w")

        self._entry_limit = ctk.CTkEntry(
            self, placeholder_text="Límite (ej. 150.00)", width=320
        )
        self._entry_limit.pack(pady=6, anchor="w")

        self._entry_month = ctk.CTkEntry(self, placeholder_text="Mes (1-12)", width=150)
        self._entry_month.pack(pady=6, anchor="w")

        self._entry_year = ctk.CTkEntry(
            self, placeholder_text="Año (ej. 2026)", width=150
        )
        self._entry_year.pack(pady=6, anchor="w")

        ctk.CTkButton(self, text="Asignar presupuesto", command=self._submit).pack(
            pady=12, anchor="w"
        )

        self._status = ctk.CTkLabel(self, text="")
        self._status.pack(anchor="w")

    def _submit(self) -> None:
        """Validate inputs and call the service."""
        try:
            cat_id = UUID(self._entry_cat_id.get().strip())
            limit = validate_amount(self._entry_limit.get())
            month = validate_month(self._entry_month.get())
            year = validate_year(self._entry_year.get())
            self._service.assign_budget(
                category_id=cat_id,
                limit_amount=limit,
                month=month,
                year=year,
            )
            _set_status(self._status, "Presupuesto asignado correctamente.", ok=True)
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


# ─────────────────────────────────────────────────────────────
# View: Transacción
# ─────────────────────────────────────────────────────────────


class _FrameTransaccion(ctk.CTkFrame):
    """Form for registering an income or expense transaction."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        """Initialize the transaction form.

        Args:
            parent: Root window.
            service: Finance service for transaction operations.
        """
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        """Build form widgets."""
        ctk.CTkLabel(
            self,
            text="Registrar transacción",
            font=ctk.CTkFont(size=16, weight="bold"),
        ).pack(anchor="w", pady=(0, 12))

        self._entry_account_id = ctk.CTkEntry(
            self, placeholder_text="UUID de cuenta", width=320
        )
        self._entry_account_id.pack(pady=6, anchor="w")

        self._entry_cat_id = ctk.CTkEntry(
            self,
            placeholder_text="UUID de categoría (vacío si es INCOME)",
            width=320,
        )
        self._entry_cat_id.pack(pady=6, anchor="w")

        self._type_var = ctk.StringVar(value="INCOME")
        frame_type = ctk.CTkFrame(self, fg_color="transparent")
        frame_type.pack(anchor="w", pady=6)
        ctk.CTkRadioButton(
            frame_type, text="INCOME", variable=self._type_var, value="INCOME"
        ).pack(side="left", padx=(0, 16))
        ctk.CTkRadioButton(
            frame_type, text="EXPENSE", variable=self._type_var, value="EXPENSE"
        ).pack(side="left")

        self._entry_amount = ctk.CTkEntry(
            self, placeholder_text="Monto (ej. 40.00)", width=320
        )
        self._entry_amount.pack(pady=6, anchor="w")

        self._entry_desc = ctk.CTkEntry(self, placeholder_text="Descripción", width=320)
        self._entry_desc.pack(pady=6, anchor="w")

        ctk.CTkButton(self, text="Registrar", command=self._submit).pack(
            pady=12, anchor="w"
        )

        self._status = ctk.CTkLabel(self, text="")
        self._status.pack(anchor="w")

    def _submit(self) -> None:
        """Validate inputs and call the service."""
        try:
            account_id = UUID(self._entry_account_id.get().strip())
            cat_raw = self._entry_cat_id.get().strip()
            cat_id: UUID | None = UUID(cat_raw) if cat_raw else None
            tipo = self._type_var.get()
            amount = validate_amount(self._entry_amount.get())
            desc = validate_name(self._entry_desc.get())

            _, exceeded = self._service.register_transaction(
                account_id=account_id,
                category_id=cat_id,
                transaction_type=tipo,
                amount=amount,
                description=desc,
            )
            msg = "Transacción registrada."
            if exceeded:
                msg += " ¡Presupuesto excedido!"
            _set_status(self._status, msg, ok=True)
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)
