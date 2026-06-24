"""Dark theme palette and shared UI helper functions."""

from __future__ import annotations

from typing import Any

import customtkinter as ctk

# -- Dark Palette --------------------------------------------------------
BG_DARK = "#1A1625"
BG_CARD = "#252037"
BG_SIDEBAR = "#151220"
BG_INPUT = "#2D2640"
BG_INPUT_HOVER = "#362E4A"

PRIMARY = "#8B5CF6"
PRIMARY_HOVER = "#7C3AED"
PRIMARY_LIGHT = "#A78BFA"

GREEN = "#22C55E"
GREEN_DARK = "#16A34A"
RED = "#EF4444"

RED_DARK = "#DC2626"
YELLOW = "#EAB308"
BLUE = "#3B82F6"
CYAN = "#06B6D4"
PINK = "#EC4899"

TEXT_PRIMARY = "#F9FAFB"
TEXT_SECONDARY = "#9CA3AF"
TEXT_MUTED = "#6B7280"
BORDER = "#374151"

MONTH_ABBR = [
    "Ene",
    "Feb",
    "Mar",
    "Abr",
    "May",
    "Jun",
    "Jul",
    "Ago",
    "Sep",
    "Oct",
    "Nov",
    "Dic",
]
BADGE_COLORS = [GREEN, PINK, YELLOW, BLUE, PRIMARY, CYAN, RED]


def set_status(label: ctk.CTkLabel, text: str, ok: bool) -> None:
    """Display a temporary status message on a label."""
    color = GREEN if ok else RED
    label.configure(text=text, text_color=color)
    if hasattr(label, "_clear_id"):
        label.after_cancel(getattr(label, "_clear_id"))
    clear_id = label.after(3500, lambda: label.configure(text=""))
    setattr(label, "_clear_id", clear_id)


def badge_color(name: str) -> str:
    """Return a deterministic badge color based on the category name."""
    return BADGE_COLORS[hash(name) % len(BADGE_COLORS)]


def section_title(parent: Any, text: str) -> ctk.CTkLabel:
    """Create a styled section title label."""
    return ctk.CTkLabel(
        parent,
        text=text,
        font=ctk.CTkFont(size=18, weight="bold"),
        text_color=TEXT_PRIMARY,
    )


def card(parent: Any, **kw: Any) -> ctk.CTkFrame:
    """Create a dark card frame."""
    return ctk.CTkFrame(parent, fg_color=BG_CARD, corner_radius=14, **kw)


def field_label(parent: Any, text: str) -> ctk.CTkLabel:
    """Create a field label for form elements."""
    return ctk.CTkLabel(
        parent,
        text=text,
        font=ctk.CTkFont(size=12),
        text_color=TEXT_SECONDARY,
        anchor="w",
    )


def input_entry(parent: Any, placeholder: str = "", **kw: Any) -> ctk.CTkEntry:
    """Create a styled input entry field."""
    return ctk.CTkEntry(
        parent,
        placeholder_text=placeholder,
        fg_color=BG_INPUT,
        border_color=BORDER,
        text_color=TEXT_PRIMARY,
        placeholder_text_color=TEXT_MUTED,
        corner_radius=10,
        height=40,
        font=ctk.CTkFont(size=13),
        **kw,
    )


def primary_button(
    parent: Any, text: str, command: Any = None, **kw: Any
) -> ctk.CTkButton:
    """Create a primary action button."""
    return ctk.CTkButton(
        parent,
        text=text,
        command=command,
        fg_color=PRIMARY,
        hover_color=PRIMARY_HOVER,
        text_color="#FFFFFF",
        corner_radius=10,
        height=42,
        font=ctk.CTkFont(size=13, weight="bold"),
        **kw,
    )


def option_menu(parent: Any, values: list[str], **kw: Any) -> ctk.CTkOptionMenu:
    """Create a styled option menu dropdown."""
    return ctk.CTkOptionMenu(
        parent,
        values=values,
        fg_color=BG_INPUT,
        button_color=PRIMARY,
        button_hover_color=PRIMARY_HOVER,
        dropdown_fg_color=BG_CARD,
        dropdown_hover_color=BG_INPUT_HOVER,
        text_color=TEXT_PRIMARY,
        corner_radius=10,
        height=40,
        font=ctk.CTkFont(size=13),
        **kw,
    )
