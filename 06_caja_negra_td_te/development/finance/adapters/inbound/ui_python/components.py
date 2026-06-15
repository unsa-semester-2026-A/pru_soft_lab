"""Reusable UI components."""

from __future__ import annotations

from datetime import datetime
from typing import Any

import customtkinter as ctk

from finance.adapters.inbound.ui_python.theme import (
    BG_CARD,
    BG_INPUT,
    BG_INPUT_HOVER,
    PRIMARY,
    PRIMARY_HOVER,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    MONTH_ABBR,
)


class CalendarPicker(ctk.CTkFrame):
    """Month/Year date picker with dropdown selectors."""

    def __init__(self, parent: Any, **kw: Any) -> None:
        super().__init__(parent, fg_color="transparent", **kw)
        now = datetime.now()
        self._month_var = ctk.StringVar(value=MONTH_ABBR[now.month - 1])
        self._year_var = ctk.StringVar(value=str(now.year))

        ctk.CTkLabel(
            self,
            text="Periodo",
            font=ctk.CTkFont(size=12),
            text_color=TEXT_SECONDARY,
        ).pack(anchor="w", pady=(0, 6))

        row = ctk.CTkFrame(self, fg_color="transparent")
        row.pack(fill="x")

        self._opt_month = ctk.CTkOptionMenu(
            row,
            variable=self._month_var,
            values=MONTH_ABBR,
            fg_color=BG_INPUT,
            button_color=PRIMARY,
            button_hover_color=PRIMARY_HOVER,
            dropdown_fg_color=BG_CARD,
            dropdown_hover_color=BG_INPUT_HOVER,
            text_color=TEXT_PRIMARY,
            corner_radius=10,
            width=140,
            height=40,
            font=ctk.CTkFont(size=13),
        )
        self._opt_month.pack(side="left", padx=(0, 10))

        years = [str(y) for y in range(now.year, now.year + 6)]
        self._opt_year = ctk.CTkOptionMenu(
            row,
            variable=self._year_var,
            values=years,
            fg_color=BG_INPUT,
            button_color=PRIMARY,
            button_hover_color=PRIMARY_HOVER,
            dropdown_fg_color=BG_CARD,
            dropdown_hover_color=BG_INPUT_HOVER,
            text_color=TEXT_PRIMARY,
            corner_radius=10,
            width=100,
            height=40,
            font=ctk.CTkFont(size=13),
        )
        self._opt_year.pack(side="left")

    def get_month(self) -> int:
        return MONTH_ABBR.index(self._month_var.get()) + 1

    def get_year(self) -> int:
        return int(self._year_var.get())
