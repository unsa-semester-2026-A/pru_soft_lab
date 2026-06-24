"""Main application window for the personal finance system.

Entry point for the graphical interface. Receives a service instance
via dependency injection so both DummyFinanceService (tests) and the
real FinanceService (production) can be used interchangeably.
"""

from __future__ import annotations

from typing import Any, Protocol, runtime_checkable

import customtkinter as ctk

from finance.adapters.inbound.ui_python.dummy_service import DummyFinanceService
from finance.adapters.inbound.ui_python.theme import (
    BG_DARK,
    BG_INPUT_HOVER,
    BG_SIDEBAR,
    BORDER,
    PRIMARY,
    TEXT_MUTED,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
)
from finance.adapters.inbound.ui_python.views_cuentas import FrameGestionCuentas
from finance.adapters.inbound.ui_python.views_categorias import FrameGestionCategorias
from finance.adapters.inbound.ui_python.views_presupuestos import (
    FrameGestionPresupuestos,
)
from finance.adapters.inbound.ui_python.views_transacciones import (
    FrameGestionTransacciones,
)


@runtime_checkable
class Refreshable(Protocol):
    """Protocol for UI frames that can refresh their data."""

    def refresh(self) -> None: ...


class FinanceApp(ctk.CTk):
    """Root window of the finance application."""

    def __init__(self, service: Any = None) -> None:
        super().__init__()
        self._service: Any = service if service is not None else DummyFinanceService()
        self._load_seed_data()
        self.title("Finanzas Personales")
        self.geometry("960x720")
        self.minsize(800, 600)
        self.configure(fg_color=BG_DARK)
        try:
            import darkdetect

            mode = "dark" if darkdetect.isDark() else "light"
            ctk.set_appearance_mode("dark" if mode == "dark" else "dark")
        except Exception:
            ctk.set_appearance_mode("dark")
        ctk.set_default_color_theme("blue")
        self._build_layout()

    def _build_layout(self) -> None:
        self.grid_columnconfigure(1, weight=1)
        self.grid_rowconfigure(0, weight=1)

        sidebar = ctk.CTkFrame(self, width=220, corner_radius=0, fg_color=BG_SIDEBAR)
        sidebar.grid(row=0, column=0, sticky="nsew")
        sidebar.grid_columnconfigure(0, weight=1)
        sidebar.grid_rowconfigure(7, weight=1)

        brand = ctk.CTkFrame(sidebar, fg_color="transparent")
        brand.grid(row=0, column=0, padx=20, pady=(24, 4), sticky="ew")
        ctk.CTkLabel(
            brand,
            text="$",
            font=ctk.CTkFont(size=28, weight="bold"),
            text_color=PRIMARY,
        ).pack(anchor="w")
        ctk.CTkLabel(
            brand,
            text="FINANZAS",
            font=ctk.CTkFont(size=15, weight="bold"),
            text_color=TEXT_PRIMARY,
        ).pack(anchor="w")

        ctk.CTkFrame(sidebar, height=1, fg_color=BORDER).grid(
            row=1, column=0, padx=20, pady=(16, 12), sticky="ew"
        )

        ctk.CTkLabel(
            sidebar,
            text="NAVEGACION",
            font=ctk.CTkFont(size=10, weight="bold"),
            text_color=TEXT_MUTED,
        ).grid(row=2, column=0, padx=24, pady=(4, 8), sticky="w")

        nav_items: list[tuple[str, str, type[ctk.CTkFrame]]] = [
            ("Cuentas", "Cuentas", FrameGestionCuentas),
            ("Categorias", "Categorias", FrameGestionCategorias),
            ("Presupuestos", "Presupuestos", FrameGestionPresupuestos),
            ("Transacciones", "Transacciones", FrameGestionTransacciones),
        ]
        self._frames: dict[str, ctk.CTkFrame] = {}
        self._nav_btns: dict[str, ctk.CTkButton] = {}

        for idx, (key, label, frame_cls) in enumerate(nav_items, start=3):
            frame = frame_cls(self, self._service, on_change=self.refresh_all)
            frame.grid(row=0, column=1, sticky="nsew", padx=28, pady=28)
            self._frames[key] = frame

            btn = ctk.CTkButton(
                sidebar,
                text=f"    {label}",
                command=lambda k=key: self._show(k),
                fg_color="transparent",
                text_color=TEXT_SECONDARY,
                hover_color=BG_INPUT_HOVER,
                anchor="w",
                height=40,
                corner_radius=10,
                font=ctk.CTkFont(size=13),
            )
            btn.grid(row=idx, column=0, padx=12, pady=3, sticky="ew")
            self._nav_btns[key] = btn

        self._show("Cuentas")
        self.refresh_all()

    def _load_seed_data(self) -> None:
        """Load seed data from JSON if available."""
        import os
        seed_path = os.path.join(os.path.dirname(__file__), "seed_data.json")
        if os.path.exists(seed_path) and hasattr(self._service, "load_seed_data"):
            try:
                self._service.load_seed_data(seed_path)
                print(f"[SEED] Datos cargados desde {seed_path}")
            except Exception as exc:
                print(f"[SEED] Error cargando datos: {exc}")

    def refresh_all(self) -> None:
        """Refresh every visible frame (called after data changes)."""
        print("[DEBUG] refresh_all called")
        for key, frame in self._frames.items():
            if isinstance(frame, Refreshable):
                print(f"[DEBUG] refreshing {key}")
                frame.refresh()

    def _show(self, name: str) -> None:
        for frame in self._frames.values():
            frame.grid_remove()
        for key, btn in self._nav_btns.items():
            if key == name:
                btn.configure(fg_color=PRIMARY, text_color="#FFFFFF")
            else:
                btn.configure(fg_color="transparent", text_color=TEXT_SECONDARY)
        frame = self._frames[name]
        if isinstance(frame, Refreshable):
            frame.refresh()
        frame.grid()
