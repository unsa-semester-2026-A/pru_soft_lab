"""Category management views."""

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
    RED,
    TEXT_MUTED,
    badge_color,
    card,
    field_label,
    input_entry,
    primary_button,
    section_title,
    set_status,
)
from finance.adapters.inbound.ui_python.views import validate_category_name


class FrameGestionCategorias(ctk.CTkFrame):
    """Tab container for category management."""

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
        self._tabs.add("Mis Categorias")
        self._tabs.add("Nueva Categoria")
        self._frame_list = FrameListaCategorias(
            self._tabs.tab("Mis Categorias"), service
        )
        self._frame_list.pack(fill="both", expand=True)
        self._frame_new = FrameCategoria(self._tabs.tab("Nueva Categoria"), service)
        self._frame_new.pack(fill="both", expand=True)
        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        self._frame_list.refresh()


class FrameCategoria(ctk.CTkFrame):
    """Form to create a new category."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Crear Nueva Categoria").grid(
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

        field_label(form, text="Nombre de la Categoria *").grid(
            row=0, column=0, sticky="w", pady=(0, 6)
        )
        self._entry_name = input_entry(
            form, placeholder="Ej: Transporte, Alimentos, Servicios"
        )
        self._entry_name.grid(row=1, column=0, sticky="ew", pady=(0, 20))

        primary_button(form, text="Crear Categoria", command=self._submit).grid(
            row=2, column=0, sticky="w"
        )
        self._status = ctk.CTkLabel(form, text="", anchor="w")
        self._status.grid(row=3, column=0, sticky="w", pady=(10, 0))

    def _submit(self) -> None:
        try:
            name = validate_category_name(self._entry_name.get())
            cat = self._service.create_category(name=name)
            set_status(self._status, f"Categoria '{cat.name}' creada.", ok=True)
            self._entry_name.delete(0, "end")
        except Exception as exc:
            set_status(self._status, str(exc), ok=False)


class FrameListaCategorias(ctk.CTkFrame):
    """Grid display of active categories as colored badges."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Categorias Activas").grid(
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
            categories = self._service.list_active_categories()
            if not categories:
                ctk.CTkLabel(
                    self._scroll,
                    text="No hay categorias.\nCrea una para empezar.",
                    text_color=TEXT_MUTED,
                    font=ctk.CTkFont(size=13),
                ).pack(pady=48)
                return
            for cat in categories:
                color = badge_color(cat.name)
                row = ctk.CTkFrame(
                    self._scroll, fg_color=color, corner_radius=10, height=42
                )
                row.pack(fill="x", padx=4, pady=3)
                row.pack_propagate(False)
                row.columnconfigure(0, weight=1)
                ctk.CTkLabel(
                    row,
                    text=cat.name,
                    font=ctk.CTkFont(size=13, weight="bold"),
                    text_color="#FFFFFF",
                    anchor="w",
                ).grid(row=0, column=0, sticky="ew", padx=(12, 8))
                ctk.CTkButton(
                    row,
                    text="x",
                    width=28,
                    height=28,
                    font=ctk.CTkFont(size=12, weight="bold"),
                    text_color="#FFFFFF",
                    fg_color="transparent",
                    hover_color=("gray70", "gray30"),
                    command=lambda c_id=cat.id: self._delete(c_id),
                ).grid(row=0, column=1, padx=(0, 10))
        except Exception as exc:
            ctk.CTkLabel(self._scroll, text=f"Error: {exc}", text_color=RED).pack()

    def _delete(self, category_id: UUID) -> None:
        try:
            self._service.deactivate_category(category_id)
            self.refresh()
        except Exception as exc:
            print(f"Delete error: {exc}")
