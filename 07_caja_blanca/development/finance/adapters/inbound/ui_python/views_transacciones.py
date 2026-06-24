"""Transaction management views."""

from __future__ import annotations

from typing import Any
from uuid import UUID

import customtkinter as ctk

from finance.adapters.inbound.ui_python.theme import (
    BG_CARD,
    BG_INPUT,
    BG_INPUT_HOVER,
    GREEN,
    GREEN_DARK,
    PRIMARY,
    PRIMARY_HOVER,
    RED,
    TEXT_MUTED,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    badge_color,
    card,
    field_label,
    input_entry,
    option_menu,
    primary_button,
    section_title,
    set_status,
)
from finance.adapters.inbound.ui_python.views import (
    validate_amount,
    validate_description,
)


class FrameGestionTransacciones(ctk.CTkFrame):
    """Tab container for transaction management."""

    def __init__(self, parent: ctk.CTk, service: Any, on_change: Any = None) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._on_change = on_change
        self._tabs = ctk.CTkTabview(
            self,
            fg_color=BG_CARD,
            segmented_button_fg_color=BG_INPUT,
            segmented_button_selected_color=PRIMARY,
            segmented_button_selected_hover_color=PRIMARY_HOVER,
            segmented_button_unselected_color=BG_INPUT,
            segmented_button_unselected_hover_color=BG_INPUT_HOVER,
            corner_radius=12,
        )
        self._tabs.pack(fill="both", expand=True)
        self._tabs.add("Historial")
        self._tabs.add("Nueva Transaccion")
        self._frame_list = FrameListaTransacciones(self._tabs.tab("Historial"), service)
        self._frame_list.pack(fill="both", expand=True)
        self._frame_new = FrameNuevaTransaccion(
            self._tabs.tab("Nueva Transaccion"), service, on_change=on_change
        )
        self._frame_new.pack(fill="both", expand=True)
        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        self._frame_list.refresh()
        self._frame_new.refresh()


class FrameNuevaTransaccion(ctk.CTkFrame):
    """Form to register a new income or expense transaction."""

    def __init__(self, parent: Any, service: Any, on_change: Any = None) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._on_change = on_change
        self._acc_map: dict[str, UUID] = {}
        self._cat_map: dict[str, UUID] = {}
        self._type_var = ctk.StringVar(value="INCOME")
        self._btn_income: ctk.CTkButton | None = None
        self._btn_expense: ctk.CTkButton | None = None
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Registrar Transaccion").grid(
            row=0, column=0, sticky="w", pady=(8, 8)
        )
        scroll = ctk.CTkScrollableFrame(
            self, fg_color="transparent", scrollbar_fg_color=BG_INPUT
        )
        scroll.grid(row=1, column=0, sticky="nsew")
        scroll.columnconfigure(0, weight=1)

        crd = card(scroll)
        crd.grid(row=0, column=0, sticky="ew", padx=2)
        crd.columnconfigure(0, weight=1)
        form = ctk.CTkFrame(crd, fg_color="transparent")
        form.grid(row=0, column=0, padx=24, pady=24, sticky="ew")
        form.columnconfigure(0, weight=1)

        field_label(form, text="Tipo de Movimiento *").grid(
            row=0, column=0, sticky="w", pady=(0, 8)
        )
        toggle = ctk.CTkFrame(form, fg_color="transparent")
        toggle.grid(row=1, column=0, sticky="w", pady=(0, 16))
        self._btn_income = ctk.CTkButton(
            toggle,
            text="  INGRESO  ",
            width=140,
            height=40,
            corner_radius=10,
            fg_color=GREEN,
            hover_color=GREEN_DARK,
            text_color="#FFFFFF",
            font=ctk.CTkFont(size=13, weight="bold"),
            command=lambda: self._set_type("INCOME"),
        )
        self._btn_income.pack(side="left", padx=(0, 10))
        self._btn_expense = ctk.CTkButton(
            toggle,
            text="  GASTO  ",
            width=140,
            height=40,
            corner_radius=10,
            fg_color=BG_INPUT,
            hover_color=BG_INPUT_HOVER,
            text_color=TEXT_SECONDARY,
            font=ctk.CTkFont(size=13, weight="bold"),
            command=lambda: self._set_type("EXPENSE"),
        )
        self._btn_expense.pack(side="left")
        self._update_toggle_style()

        field_label(form, text="Cuenta *").grid(
            row=2, column=0, sticky="w", pady=(0, 6)
        )
        self._opt_acc = option_menu(form, values=["Cargando..."])
        self._opt_acc.grid(row=3, column=0, sticky="ew", pady=(0, 14))

        field_label(form, text="Categoria (solo gastos) *").grid(
            row=4, column=0, sticky="w", pady=(0, 6)
        )
        self._opt_cat = option_menu(form, values=["Ninguna"])
        self._opt_cat.grid(row=5, column=0, sticky="ew", pady=(0, 14))

        field_label(form, text="Monto *").grid(row=6, column=0, sticky="w", pady=(0, 6))
        self._entry_amount = input_entry(form, placeholder="Ej: 150.00")
        self._entry_amount.grid(row=7, column=0, sticky="ew", pady=(0, 14))

        field_label(form, text="Descripcion *").grid(
            row=8, column=0, sticky="w", pady=(0, 6)
        )
        self._entry_desc = input_entry(form, placeholder="Ej: Almuerzo, Sueldo mensual")
        self._entry_desc.grid(row=9, column=0, sticky="ew", pady=(0, 20))

        primary_button(form, text="Registrar Transaccion", command=self._submit).grid(
            row=10, column=0, sticky="w"
        )
        self._status = ctk.CTkLabel(form, text="", anchor="w")
        self._status.grid(row=11, column=0, sticky="w", pady=(10, 0))

    def _set_type(self, tipo: str) -> None:
        self._type_var.set(tipo)
        self._update_toggle_style()

    def _update_toggle_style(self) -> None:
        current = self._type_var.get()
        if self._btn_income and self._btn_expense:
            if current == "INCOME":
                self._btn_income.configure(fg_color=GREEN, text_color="#FFFFFF")
                self._btn_expense.configure(
                    fg_color=BG_INPUT, text_color=TEXT_SECONDARY
                )
            else:
                self._btn_income.configure(fg_color=BG_INPUT, text_color=TEXT_SECONDARY)
                self._btn_expense.configure(fg_color=RED, text_color="#FFFFFF")

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
                raise ValueError("Seleccione una cuenta valida.")
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
            msg = "Transaccion registrada."
            if exceeded:
                msg = "Transaccion registrada. Presupuesto excedido!"
            set_status(self._status, msg, ok=True)
            self._entry_amount.delete(0, "end")
            self._entry_desc.delete(0, "end")
            if self._on_change is not None:
                print("[DEBUG] calling on_change from transaction submit")
                self._on_change()
            else:
                print("[DEBUG] on_change is None!")
        except Exception as exc:
            set_status(self._status, str(exc), ok=False)


class FrameListaTransacciones(ctk.CTkFrame):
    """Scrollable list of all transactions with pagination."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Historial de Movimientos").grid(
            row=0, column=0, sticky="w", pady=(8, 12)
        )
        self._scroll = ctk.CTkScrollableFrame(
            self, fg_color="transparent", scrollbar_fg_color=BG_INPUT
        )
        self._scroll.grid(row=1, column=0, sticky="nsew")

    def refresh(self) -> None:
        for w in self._scroll.winfo_children():
            w.destroy()
        try:
            txns = self._service.list_all_transactions()
            accounts = self._service.list_active_accounts()
            categories = self._service.list_active_categories()
            acc_map = {a.id: a.name for a in accounts}
            cat_map = {c.id: c.name for c in categories}
            if not txns:
                ctk.CTkLabel(
                    self._scroll,
                    text="No hay movimientos registrados.",
                    text_color=TEXT_MUTED,
                    font=ctk.CTkFont(size=13),
                ).pack(pady=48)
                return

            for idx, t in enumerate(reversed(txns)):
                is_income = t.transaction_type.value == "INCOME"
                accent = GREEN if is_income else RED
                crd = card(self._scroll)
                crd.pack(fill="x", pady=5, padx=4)

                ctk.CTkFrame(
                    crd, width=3, height=5, fg_color=accent, corner_radius=2
                ).pack(side="left", fill="y")

                inner = ctk.CTkFrame(crd, fg_color="transparent")
                inner.pack(side="left", fill="both", expand=True, padx=14, pady=12)

                date_str = t.created_at.strftime("%d/%m %H:%M")

                ctk.CTkLabel(
                    inner,
                    text=f"{date_str}  --  {t.description}",
                    font=ctk.CTkFont(size=13, weight="bold"),
                    text_color=TEXT_PRIMARY,
                ).pack(anchor="w")

                acc_name = acc_map.get(t.account_id, "Cuenta eliminada")
                ctk.CTkLabel(
                    inner,
                    text=acc_name,
                    font=ctk.CTkFont(size=11),
                    text_color=TEXT_SECONDARY,
                ).pack(anchor="w")

                if t.category_id and t.category_id in cat_map:
                    cat_name = cat_map[t.category_id]
                    cat_color = badge_color(cat_name)
                    cat_badge = ctk.CTkFrame(
                        inner, fg_color=cat_color, corner_radius=6, height=20
                    )
                    cat_badge.pack(anchor="w", pady=(6, 0))
                    cat_badge.pack_propagate(False)
                    ctk.CTkLabel(
                        cat_badge,
                        text=cat_name.upper(),
                        font=ctk.CTkFont(size=9, weight="bold"),
                        text_color="#FFFFFF",
                    ).pack(padx=8, pady=1)

                prefix = "+" if is_income else "-"
                ctk.CTkLabel(
                    crd,
                    text=f"{prefix}${t.amount:,.2f}",
                    text_color=accent,
                    font=ctk.CTkFont(size=16, weight="bold"),
                ).pack(side="right", padx=16)

        except Exception as exc:
            ctk.CTkLabel(self._scroll, text=f"Error: {exc}", text_color=RED).pack()
