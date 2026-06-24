"""Account management views."""

from __future__ import annotations

from typing import Any
from uuid import UUID

import customtkinter as ctk

from finance.adapters.inbound.ui_python.theme import (
    BG_CARD,
    BG_INPUT,
    BG_INPUT_HOVER,
    PRIMARY,
    PRIMARY_HOVER,
    PRIMARY_LIGHT,
    RED,
    RED_DARK,
    TEXT_MUTED,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    badge_color,
    card,
    field_label,
    input_entry,
    primary_button,
    section_title,
    set_status,
)
from finance.adapters.inbound.ui_python.views import validate_account_name, validate_bank_name


class FrameGestionCuentas(ctk.CTkFrame):
    """Tab container for account management."""

    def __init__(
        self, parent: ctk.CTk, service: Any, on_change: Any = None
    ) -> None:
        super().__init__(parent, fg_color="transparent")
        
        self._service = service
        
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
        self._tabs.add("Mis Cuentas")
        self._tabs.add("Nueva Cuenta")
        self._frame_list = FrameListaCuentas(self._tabs.tab("Mis Cuentas"), service)
        self._frame_list.pack(fill="both", expand=True)
        self._frame_new = FrameCuenta(self._tabs.tab("Nueva Cuenta"), service)
        self._frame_new.pack(fill="both", expand=True)
        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        self._frame_list.refresh()


class FrameCuenta(ctk.CTkFrame):
    """Form to create a new account."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Crear Nueva Cuenta").grid(
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

        field_label(form, text="Nombre de la Cuenta *").grid(
            row=0, column=0, sticky="w", pady=(0, 6)
        )
        self._entry_name = input_entry(
            form, placeholder="Ej: Sueldo, Ahorros, Efectivo"
        )
        self._entry_name.grid(row=1, column=0, sticky="ew", pady=(0, 16))

        field_label(form, text="Banco / Institucion *").grid(
            row=2, column=0, sticky="w", pady=(0, 6)
        )
        self._entry_bank = input_entry(form, placeholder="Ej: BCP, Interbank, Efectivo")
        self._entry_bank.grid(row=3, column=0, sticky="ew", pady=(0, 20))

        primary_button(form, text="Crear Cuenta", command=self._submit).grid(
            row=4, column=0, sticky="w"
        )
        self._status = ctk.CTkLabel(form, text="", anchor="w")
        self._status.grid(row=5, column=0, sticky="w", pady=(10, 0))

    def _submit(self) -> None:
        try:
            name = validate_account_name(self._entry_name.get())
            bank = validate_bank_name(self._entry_bank.get())
            account = self._service.create_account(name=name, bank=bank)
            set_status(self._status, f"Cuenta '{account.name}' creada.", ok=True)
            self._entry_name.delete(0, "end")
            self._entry_bank.delete(0, "end")
        except Exception as exc:
            set_status(self._status, str(exc), ok=False)


class FrameListaCuentas(ctk.CTkFrame):
    """Scrollable list of active accounts."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Cuentas Activas").grid(
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
            accounts = self._service.list_active_accounts()
            if not accounts:
                ctk.CTkLabel(
                    self._scroll,
                    text="No hay cuentas activas.\nCrea una cuenta para comenzar.",
                    text_color=TEXT_MUTED,
                    font=ctk.CTkFont(size=13),
                ).pack(pady=48)
                return
            for acc in accounts:
                crd = card(self._scroll)
                crd.pack(fill="x", pady=6, padx=4)
                crd.columnconfigure(0, weight=1)
                inner = ctk.CTkFrame(crd, fg_color="transparent")
                inner.grid(row=0, column=0, padx=18, pady=16, sticky="ew")
                inner.columnconfigure(0, weight=1)

                left = ctk.CTkFrame(inner, fg_color="transparent")
                left.grid(row=0, column=0, sticky="w")
                ctk.CTkLabel(
                    left,
                    text=acc.name,
                    font=ctk.CTkFont(size=14, weight="bold"),
                    text_color=TEXT_PRIMARY,
                ).pack(anchor="w")
                ctk.CTkLabel(
                    left,
                    text=acc.bank,
                    font=ctk.CTkFont(size=12),
                    text_color=TEXT_SECONDARY,
                ).pack(anchor="w")

                right = ctk.CTkFrame(inner, fg_color="transparent")
                right.grid(row=0, column=1, sticky="e")
                ctk.CTkLabel(
                    right,
                    text=f"${acc.current_balance:,.2f}",
                    font=ctk.CTkFont(size=17, weight="bold"),
                    text_color=PRIMARY_LIGHT,
                ).pack(side="left", padx=(0, 14))
                ctk.CTkButton(
                    right,
                    text="Eliminar",
                    width=70,
                    height=32,
                    fg_color=RED,
                    hover_color=RED_DARK,
                    corner_radius=8,
                    font=ctk.CTkFont(size=12, weight="bold"),
                    command=lambda a_id=acc.id: self._delete(a_id),
                ).pack(side="right")
        except Exception as exc:
            ctk.CTkLabel(self._scroll, text=f"Error: {exc}", text_color=RED).pack()

    def _delete(self, account_id: UUID) -> None:
        try:
            self._service.deactivate_account(account_id)
            self.refresh()
        except Exception as exc:
            print(f"Delete error: {exc}")
