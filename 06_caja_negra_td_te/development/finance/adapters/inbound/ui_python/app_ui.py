"""Main application window for the personal finance system.

Entry point for the graphical interface. Receives a service instance
via dependency injection so both DummyFinanceService (tests) and the
real FinanceService (production) can be used interchangeably.
"""

from __future__ import annotations

from datetime import datetime
from typing import Any, Protocol, runtime_checkable
from uuid import UUID

import customtkinter as ctk
import darkdetect

from finance.adapters.inbound.ui_python.dummy_service import DummyFinanceService
from finance.adapters.inbound.ui_python.views import (
    validate_amount,
    validate_description,
    validate_month,
    validate_name,
    validate_year,
)


@runtime_checkable
class Refreshable(Protocol):
    """Protocol for UI frames that can refresh their data."""

    def refresh(self) -> None:
        """Update frame content with fresh data from the service."""
        ...


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
        self.geometry("840x680")
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
            ("Cuentas", _FrameGestionCuentas),
            ("Categorías", _FrameGestionCategorias),
            ("Presupuestos", _FrameGestionPresupuestos),
            ("Transacciones", _FrameGestionTransacciones),
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

        self._show("Cuentas")

    def _show(self, name: str) -> None:
        """Raise the selected frame to the front and refresh its data.

        Args:
            name: Key matching a registered frame.
        """
        for frame in self._frames.values():
            frame.grid_remove()

        frame = self._frames[name]
        if isinstance(frame, Refreshable):
            frame.refresh()
        frame.grid()


# ─────────────────────────────────────────────────────────────
# Shared helper
# ─────────────────────────────────────────────────────────────


def _set_status(label: ctk.CTkLabel, text: str, ok: bool) -> None:
    """Update a status label with colour-coded feedback that auto-clears.

    Args:
        label: The CTkLabel widget to update.
        text: Message to display.
        ok: True renders green (success), False renders red (error).
    """
    color = "#2ecc71" if ok else "#e74c3c"
    label.configure(text=text, text_color=color)

    # Cancel previous clear if exists to avoid premature hiding
    if hasattr(label, "_clear_id"):
        label.after_cancel(getattr(label, "_clear_id"))

    # Set new clear timer (3 seconds)
    clear_id = label.after(3000, lambda: label.configure(text=""))
    setattr(label, "_clear_id", clear_id)


# ─────────────────────────────────────────────────────────────
# Gestion: Cuentas
# ─────────────────────────────────────────────────────────────


class _FrameGestionCuentas(ctk.CTkFrame):
    """Wrapper for account list and creation."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._tabs = ctk.CTkTabview(self)
        self._tabs.pack(fill="both", expand=True)

        self._tabs.add("Mis Cuentas")
        self._tabs.add("Nueva Cuenta")

        self._frame_list = _FrameListaCuentas(self._tabs.tab("Mis Cuentas"), service)
        self._frame_list.pack(fill="both", expand=True)

        self._frame_new = _FrameCuenta(self._tabs.tab("Nueva Cuenta"), service)
        self._frame_new.pack(fill="both", expand=True)

        # Refresh list when switching to its tab
        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        """Refresh current active tab if it has a list."""
        if self._tabs.get() == "Mis Cuentas":
            self._frame_list.refresh()


class _FrameCuenta(ctk.CTkFrame):
    """Form for creating a new financial account."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
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
        try:
            name = validate_name(self._entry_name.get())
            bank = validate_name(self._entry_bank.get())
            account = self._service.create_account(name=name, bank=bank)
            _set_status(self._status, f"Cuenta '{account.name}' creada.", ok=True)
            self._entry_name.delete(0, "end")
            self._entry_bank.delete(0, "end")
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


class _FrameListaCuentas(ctk.CTkFrame):
    """View to list and delete accounts."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        ctk.CTkLabel(
            self, text="Lista de cuentas activas", font=ctk.CTkFont(size=16)
        ).pack(anchor="w", pady=(0, 12))

        self._scroll = ctk.CTkScrollableFrame(self, width=540, height=350)
        self._scroll.pack(fill="both", expand=True)

    def refresh(self) -> None:
        for widget in self._scroll.winfo_children():
            widget.destroy()

        try:
            accounts = self._service.list_active_accounts()
            if not accounts:
                ctk.CTkLabel(self._scroll, text="No hay cuentas activas.").pack(pady=20)
                return

            for acc in accounts:
                card = ctk.CTkFrame(self._scroll)
                card.pack(fill="x", pady=6, padx=10)

                info_frame = ctk.CTkFrame(card, fg_color="transparent")
                info_frame.pack(side="left", fill="both", expand=True, padx=12, pady=8)

                ctk.CTkLabel(
                    info_frame, text=acc.name, font=ctk.CTkFont(weight="bold")
                ).pack(anchor="w")
                ctk.CTkLabel(info_frame, text=acc.bank, font=ctk.CTkFont(size=12)).pack(
                    anchor="w"
                )

                ctk.CTkLabel(
                    card,
                    text=f"${acc.current_balance:,.2f}",
                    font=ctk.CTkFont(size=16, weight="bold"),
                    text_color="#3498db",
                ).pack(side="left", padx=20)

                ctk.CTkButton(
                    card,
                    text="Eliminar",
                    width=70,
                    fg_color="#e74c3c",
                    hover_color="#c0392b",
                    command=lambda a_id=acc.id: self._delete(a_id),
                ).pack(side="right", padx=12)
        except Exception as exc:
            ctk.CTkLabel(
                self._scroll, text=f"Error: {exc}", text_color="#e74c3c"
            ).pack()

    def _delete(self, account_id: UUID) -> None:
        try:
            self._service.deactivate_account(account_id)
            self.refresh()
        except Exception as exc:
            print(f"Delete error: {exc}")


# ─────────────────────────────────────────────────────────────
# Gestion: Categorías
# ─────────────────────────────────────────────────────────────


class _FrameGestionCategorias(ctk.CTkFrame):
    """Wrapper for category list and creation."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._tabs = ctk.CTkTabview(self)
        self._tabs.pack(fill="both", expand=True)

        self._tabs.add("Mis Categorías")
        self._tabs.add("Nueva Categoría")

        self._frame_list = _FrameListaCategorias(
            self._tabs.tab("Mis Categorías"), service
        )
        self._frame_list.pack(fill="both", expand=True)

        self._frame_new = _FrameCategoria(self._tabs.tab("Nueva Categoría"), service)
        self._frame_new.pack(fill="both", expand=True)

        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        """Refresh list tab."""
        if self._tabs.get() == "Mis Categorías":
            self._frame_list.refresh()


class _FrameCategoria(ctk.CTkFrame):
    """Form for creating a spending category."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
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
        try:
            name = validate_name(self._entry_name.get())
            cat = self._service.create_category(name=name)
            _set_status(self._status, f"Categoría '{cat.name}' creada.", ok=True)
            self._entry_name.delete(0, "end")
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


class _FrameListaCategorias(ctk.CTkFrame):
    """View to list and delete categories."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        ctk.CTkLabel(
            self, text="Lista de categorías activas", font=ctk.CTkFont(size=16)
        ).pack(anchor="w", pady=(0, 12))

        self._scroll = ctk.CTkScrollableFrame(self, width=540, height=350)
        self._scroll.pack(fill="both", expand=True)

    def refresh(self) -> None:
        for widget in self._scroll.winfo_children():
            widget.destroy()

        try:
            categories = self._service.list_active_categories()
            if not categories:
                ctk.CTkLabel(self._scroll, text="No hay categorías activas.").pack(
                    pady=20
                )
                return

            for cat in categories:
                card = ctk.CTkFrame(self._scroll)
                card.pack(fill="x", pady=4, padx=10)

                ctk.CTkLabel(card, text=cat.name, font=ctk.CTkFont(weight="bold")).pack(
                    side="left", padx=12, pady=10
                )

                ctk.CTkButton(
                    card,
                    text="Eliminar",
                    width=70,
                    fg_color="#e74c3c",
                    hover_color="#c0392b",
                    command=lambda c_id=cat.id: self._delete(c_id),
                ).pack(side="right", padx=12)
        except Exception as exc:
            ctk.CTkLabel(
                self._scroll, text=f"Error: {exc}", text_color="#e74c3c"
            ).pack()

    def _delete(self, category_id: UUID) -> None:
        try:
            self._service.deactivate_category(category_id)
            self.refresh()
        except Exception as exc:
            print(f"Delete error: {exc}")


# ─────────────────────────────────────────────────────────────
# Gestion: Presupuestos
# ─────────────────────────────────────────────────────────────


class _FrameGestionPresupuestos(ctk.CTkFrame):
    """Wrapper for budget list and assignment."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._tabs = ctk.CTkTabview(self)
        self._tabs.pack(fill="both", expand=True)

        self._tabs.add("Mis Presupuestos")
        self._tabs.add("Asignar Presupuesto")

        self._frame_list = _FrameListaPresupuestos(
            self._tabs.tab("Mis Presupuestos"), service
        )
        self._frame_list.pack(fill="both", expand=True)

        self._frame_new = _FrameAsignarPresupuesto(
            self._tabs.tab("Asignar Presupuesto"), service
        )
        self._frame_new.pack(fill="both", expand=True)

        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        """Refresh current tab data."""
        active_tab = self._tabs.get()
        if active_tab == "Mis Presupuestos":
            self._frame_list.refresh()
        elif active_tab == "Asignar Presupuesto":
            self._frame_new.refresh()


class _FrameAsignarPresupuesto(ctk.CTkFrame):
    """Form for assigning a monthly budget to a category."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._cat_map: dict[str, UUID] = {}
        self._build()

    def _build(self) -> None:
        ctk.CTkLabel(
            self, text="Asignar presupuesto", font=ctk.CTkFont(size=16, weight="bold")
        ).pack(anchor="w", pady=(0, 12))

        ctk.CTkLabel(self, text="Categoría").pack(anchor="w")
        self._opt_cat = ctk.CTkOptionMenu(self, width=320, values=["Cargando..."])
        self._opt_cat.pack(pady=6, anchor="w")

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

    def refresh(self) -> None:
        try:
            categories = self._service.list_active_categories()
            self._cat_map = {cat.name: cat.id for cat in categories}
            names = list(self._cat_map.keys())
            if not names:
                self._opt_cat.configure(values=["No hay categorías"])
                self._opt_cat.set("No hay categorías")
            else:
                self._opt_cat.configure(values=names)
                self._opt_cat.set(names[0])
        except Exception as exc:
            print(f"Refresh error: {exc}")

    def _submit(self) -> None:
        try:
            cat_name = self._opt_cat.get()
            if cat_name not in self._cat_map:
                raise ValueError("Seleccione una categoría válida.")

            cat_id = self._cat_map[cat_name]
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
            self._entry_limit.delete(0, "end")
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


class _FrameListaPresupuestos(ctk.CTkFrame):
    """View to list existing budgets categorized by period."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        ctk.CTkLabel(
            self, text="Estado de presupuestos", font=ctk.CTkFont(size=16)
        ).pack(anchor="w", pady=(0, 12))

        self._scroll = ctk.CTkScrollableFrame(self, width=540, height=400)
        self._scroll.pack(fill="both", expand=True)

    def refresh(self) -> None:
        for widget in self._scroll.winfo_children():
            widget.destroy()

        try:
            budgets = self._service.list_all_budgets()
            categories = self._service.list_active_categories()
            cat_map = {c.id: c.name for c in categories}

            if not budgets:
                ctk.CTkLabel(self._scroll, text="No hay presupuestos.").pack(pady=20)
                return

            now = datetime.now()
            current_p = now.year * 100 + now.month

            # Map to runtime status and sort
            results = []
            for b in budgets:
                spent, exceeded = self._service.calculate_budget_status(b.id)
                results.append(
                    {
                        "budget": b,
                        "spent": spent,
                        "exceeded": exceeded,
                        "period": b.year * 100 + b.month,
                    }
                )

            results.sort(key=lambda x: x["period"], reverse=True)

            # Categorize
            past, active, future = [], [], []
            for r in results:
                if r["period"] < current_p:
                    past.append(r)
                elif r["period"] == current_p:
                    active.append(r)
                else:
                    future.append(r)

            self._render_section("Activos", active, cat_map)
            self._render_section("Futuros", future, cat_map)
            self._render_section("Pasados", past, cat_map)

        except Exception as exc:
            ctk.CTkLabel(
                self._scroll, text=f"Error: {exc}", text_color="#e74c3c"
            ).pack()

    def _render_section(
        self, title: str, items: list[dict[str, Any]], cat_map: dict[UUID, str]
    ) -> None:
        if not items:
            return

        ctk.CTkLabel(self._scroll, text=title, font=ctk.CTkFont(weight="bold")).pack(
            anchor="w", pady=(12, 4), padx=10
        )

        for r in items:
            card = ctk.CTkFrame(self._scroll)
            card.pack(fill="x", pady=4, padx=10)

            b = r["budget"]
            c_name = cat_map.get(b.category_id, "Categoría eliminada")
            period = f"{b.month}/{b.year}"

            top_f = ctk.CTkFrame(card, fg_color="transparent")
            top_f.pack(fill="x", padx=12, pady=(8, 2))

            ctk.CTkLabel(top_f, text=c_name, font=ctk.CTkFont(weight="bold")).pack(
                side="left"
            )
            ctk.CTkLabel(top_f, text=period, font=ctk.CTkFont(size=12)).pack(
                side="right"
            )

            mid_f = ctk.CTkFrame(card, fg_color="transparent")
            mid_f.pack(fill="x", padx=12, pady=(2, 8))

            status_text = "EXCEDIDO" if r["exceeded"] else "CUMPLIDO"
            status_color = "#e74c3c" if r["exceeded"] else "#2ecc71"

            info = f"Límite: ${b.limit_amount:,.2f} | Gastado: ${r['spent']:,.2f}"
            ctk.CTkLabel(mid_f, text=info, font=ctk.CTkFont(size=13)).pack(side="left")
            ctk.CTkLabel(
                mid_f,
                text=status_text,
                text_color=status_color,
                font=ctk.CTkFont(weight="bold"),
            ).pack(side="right")


# ─────────────────────────────────────────────────────────────
# Gestion: Transacciones
# ─────────────────────────────────────────────────────────────


class _FrameGestionTransacciones(ctk.CTkFrame):
    """Wrapper for transaction list and creation."""

    def __init__(self, parent: ctk.CTk, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._tabs = ctk.CTkTabview(self)
        self._tabs.pack(fill="both", expand=True)

        self._tabs.add("Historial")
        self._tabs.add("Nueva Transacción")

        self._frame_list = _FrameListaTransacciones(
            self._tabs.tab("Historial"), service
        )
        self._frame_list.pack(fill="both", expand=True)

        self._frame_new = _FrameNuevaTransaccion(
            self._tabs.tab("Nueva Transacción"), service
        )
        self._frame_new.pack(fill="both", expand=True)

        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        """Refresh current tab data."""
        active_tab = self._tabs.get()
        if active_tab == "Historial":
            self._frame_list.refresh()
        elif active_tab == "Nueva Transacción":
            self._frame_new.refresh()


class _FrameNuevaTransaccion(ctk.CTkFrame):
    """Form for registering an income or expense transaction."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._acc_map: dict[str, UUID] = {}
        self._cat_map: dict[str, UUID] = {}
        self._build()

    def _build(self) -> None:
        ctk.CTkLabel(
            self,
            text="Registrar transacción",
            font=ctk.CTkFont(size=16, weight="bold"),
        ).pack(anchor="w", pady=(0, 12))

        ctk.CTkLabel(self, text="Cuenta").pack(anchor="w")
        self._opt_acc = ctk.CTkOptionMenu(self, width=320, values=["Cargando..."])
        self._opt_acc.pack(pady=6, anchor="w")

        ctk.CTkLabel(self, text="Categoría (Solo para Gastos)").pack(anchor="w")
        self._opt_cat = ctk.CTkOptionMenu(self, width=320, values=["Ninguna"])
        self._opt_cat.pack(pady=6, anchor="w")

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

    def refresh(self) -> None:
        try:
            accounts = self._service.list_active_accounts()
            self._acc_map = {f"{a.name} ({a.bank})": a.id for a in accounts}
            acc_names = list(self._acc_map.keys())
            if not acc_names:
                self._opt_acc.configure(values=["No hay cuentas"])
                self._opt_acc.set("No hay cuentas")
            else:
                self._opt_acc.configure(values=acc_names)
                self._opt_acc.set(acc_names[0])

            categories = self._service.list_active_categories()
            self._cat_map = {cat.name: cat.id for cat in categories}
            cat_names = ["Ninguna"] + list(self._cat_map.keys())
            self._opt_cat.configure(values=cat_names)
            self._opt_cat.set("Ninguna")
        except Exception as exc:
            print(f"Refresh error: {exc}")

    def _submit(self) -> None:
        try:
            acc_name = self._opt_acc.get()
            if acc_name not in self._acc_map:
                raise ValueError("Seleccione una cuenta válida.")
            account_id = self._acc_map[acc_name]

            cat_name = self._opt_cat.get()
            cat_id: UUID | None = (
                self._cat_map.get(cat_name) if cat_name != "Ninguna" else None
            )

            tipo = self._type_var.get()
            amount = validate_amount(self._entry_amount.get())
            desc = validate_description(self._entry_desc.get())

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
            self._entry_amount.delete(0, "end")
            self._entry_desc.delete(0, "end")
        except Exception as exc:
            _set_status(self._status, str(exc), ok=False)


class _FrameListaTransacciones(ctk.CTkFrame):
    """View to list all transactions."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        ctk.CTkLabel(
            self, text="Historial de movimientos", font=ctk.CTkFont(size=16)
        ).pack(anchor="w", pady=(0, 12))

        self._scroll = ctk.CTkScrollableFrame(self, width=540, height=400)
        self._scroll.pack(fill="both", expand=True)

    def refresh(self) -> None:
        for widget in self._scroll.winfo_children():
            widget.destroy()

        try:
            txns = self._service.list_all_transactions()
            accounts = self._service.list_active_accounts()
            acc_map = {a.id: f"{a.name}" for a in accounts}

            if not txns:
                ctk.CTkLabel(self._scroll, text="No hay movimientos.").pack(pady=20)
                return

            for t in reversed(txns):
                card = ctk.CTkFrame(self._scroll)
                card.pack(fill="x", pady=4, padx=10)

                left_f = ctk.CTkFrame(card, fg_color="transparent")
                left_f.pack(side="left", padx=12, pady=8, fill="both", expand=True)

                date_str = t.created_at.strftime("%d/%m %H:%M")
                ctk.CTkLabel(
                    left_f,
                    text=f"{date_str} - {t.description}",
                    font=ctk.CTkFont(weight="bold"),
                ).pack(anchor="w")

                acc_name = acc_map.get(t.account_id, "Cuenta eliminada")
                ctk.CTkLabel(
                    left_f, text=f"Cuenta: {acc_name}", font=ctk.CTkFont(size=12)
                ).pack(anchor="w")

                prefix = "+" if t.transaction_type.value == "INCOME" else "-"
                color = "#2ecc71" if prefix == "+" else "#e74c3c"

                ctk.CTkLabel(
                    card,
                    text=f"{prefix}${t.amount:,.2f}",
                    text_color=color,
                    font=ctk.CTkFont(size=15, weight="bold"),
                ).pack(side="right", padx=15)
        except Exception as exc:
            ctk.CTkLabel(
                self._scroll, text=f"Error: {exc}", text_color="#e74c3c"
            ).pack()
