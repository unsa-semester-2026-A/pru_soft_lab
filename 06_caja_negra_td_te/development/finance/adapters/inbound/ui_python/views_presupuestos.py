"""Budget management views."""

from __future__ import annotations

from datetime import datetime
from typing import Any
from uuid import UUID

import customtkinter as ctk

from finance.adapters.inbound.ui_python.components import CalendarPicker
from finance.adapters.inbound.ui_python.theme import (
    BG_CARD,
    BG_INPUT,
    BG_INPUT_HOVER,
    BORDER,
    GREEN,
    MONTH_ABBR,
    PRIMARY,
    PRIMARY_HOVER,
    RED,
    TEXT_MUTED,
    TEXT_PRIMARY,
    TEXT_SECONDARY,
    YELLOW,
    badge_color,
    card,
    field_label,
    input_entry,
    option_menu,
    primary_button,
    section_title,
    set_status,
)
from finance.adapters.inbound.ui_python.views import validate_amount


class FrameGestionPresupuestos(ctk.CTkFrame):
    """Tab container for budget management."""

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
        self._tabs.add("Mis Presupuestos")
        self._tabs.add("Asignar Presupuesto")
        self._frame_list = FrameListaPresupuestos(
            self._tabs.tab("Mis Presupuestos"), service
        )
        self._frame_list.pack(fill="both", expand=True)
        self._frame_new = FrameAsignarPresupuesto(
            self._tabs.tab("Asignar Presupuesto"), service
        )
        self._frame_new.pack(fill="both", expand=True)
        self._tabs.configure(command=self.refresh)

    def refresh(self) -> None:
        self._frame_list.refresh()
        self._frame_new.refresh()


class FrameAsignarPresupuesto(ctk.CTkFrame):
    """Form to assign a budget to a category for a given period."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._cat_map: dict[str, UUID] = {}
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Asignar Presupuesto").grid(
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

        field_label(form, text="Categoria *").grid(
            row=0, column=0, sticky="w", pady=(0, 6)
        )
        self._opt_cat = option_menu(form, values=["Cargando..."])
        self._opt_cat.grid(row=1, column=0, sticky="ew", pady=(0, 16))

        field_label(form, text="Monto Fijo Mensual *").grid(
            row=2, column=0, sticky="w", pady=(0, 6)
        )
        self._entry_limit = input_entry(form, placeholder="Ej: 500.00")
        self._entry_limit.grid(row=3, column=0, sticky="ew", pady=(0, 16))

        self._calendar = CalendarPicker(form)
        self._calendar.grid(row=4, column=0, sticky="w", pady=(0, 20))

        primary_button(form, text="Asignar Presupuesto", command=self._submit).grid(
            row=5, column=0, sticky="w"
        )
        self._status = ctk.CTkLabel(form, text="", anchor="w")
        self._status.grid(row=6, column=0, sticky="w", pady=(10, 0))

    def refresh(self) -> None:
        try:
            categories = self._service.list_active_categories()
            self._cat_map = {cat.name: cat.id for cat in categories}
            names = list(self._cat_map.keys())
            if not names:
                self._opt_cat.configure(values=["No hay categorias"])
                self._opt_cat.set("No hay categorias")
            else:
                self._opt_cat.configure(values=names)
                self._opt_cat.set(names[0])
        except Exception as exc:
            print(f"Refresh error: {exc}")

    def _submit(self) -> None:
        try:
            cat_name = self._opt_cat.get()
            if cat_name not in self._cat_map:
                raise ValueError("Seleccione una categoria valida.")
            cat_id = self._cat_map[cat_name]
            limit = validate_amount(self._entry_limit.get())
            month = self._calendar.get_month()
            year = self._calendar.get_year()
            self._service.assign_budget(
                category_id=cat_id, limit_amount=limit, month=month, year=year
            )
            set_status(self._status, "Presupuesto asignado.", ok=True)
            self._entry_limit.delete(0, "end")
        except Exception as exc:
            set_status(self._status, str(exc), ok=False)


class FrameListaPresupuestos(ctk.CTkFrame):
    """Scrollable list of budgets with progress bars."""

    def __init__(self, parent: Any, service: Any) -> None:
        super().__init__(parent, fg_color="transparent")
        self._service = service
        self._build()

    def _build(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)
        section_title(self, text="Estado de Presupuestos").grid(
            row=0, column=0, sticky="w", pady=(8, 12)
        )
        self._scroll = ctk.CTkScrollableFrame(
            self, fg_color="transparent", scrollbar_fg_color=BG_INPUT
        )
        self._scroll.grid(row=1, column=0, sticky="nsew")

    def refresh(self) -> None:
        print("[DEBUG] FrameListaPresupuestos.refresh called")
        for w in self._scroll.winfo_children():
            w.destroy()
        try:
            budgets = self._service.list_all_budgets()
            print(f"[DEBUG] budgets count: {len(budgets)}")
            categories = self._service.list_active_categories()
            cat_map = {c.id: c.name for c in categories}
            if not budgets:
                ctk.CTkLabel(
                    self._scroll,
                    text="No hay presupuestos definidos.",
                    text_color=TEXT_MUTED,
                    font=ctk.CTkFont(size=13),
                ).pack(pady=48)
                return
            now = datetime.now()
            current_p = now.year * 100 + now.month
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
            past, active, future = [], [], []
            for r in results:
                if r["period"] < current_p:
                    past.append(r)
                elif r["period"] == current_p:
                    active.append(r)
                else:
                    future.append(r)
            self._render_section("Activos", active, cat_map, YELLOW)
            self._render_section("Futuros", future, cat_map, TEXT_SECONDARY)
            self._render_section("Pasados", past, cat_map, TEXT_MUTED)
        except Exception as exc:
            ctk.CTkLabel(self._scroll, text=f"Error: {exc}", text_color=RED).pack()

    def _render_section(
        self,
        title: str,
        items: list[dict[str, Any]],
        cat_map: dict[UUID, str],
        accent: str,
    ) -> None:
        if not items:
            return
        header = ctk.CTkFrame(self._scroll, fg_color="transparent")
        header.pack(fill="x", padx=4, pady=(14, 6))
        ctk.CTkFrame(header, height=3, width=4, fg_color=accent, corner_radius=2).pack(
            side="left", padx=(0, 8)
        )
        ctk.CTkLabel(
            header,
            text=title.upper(),
            font=ctk.CTkFont(size=11, weight="bold"),
            text_color=accent,
        ).pack(side="left")
        for r in items:
            crd = card(self._scroll)
            crd.pack(fill="x", pady=5, padx=4)
            inner = ctk.CTkFrame(crd, fg_color="transparent")
            inner.pack(fill="x", padx=18, pady=10)

            b = r["budget"]
            c_name = cat_map.get(b.category_id, "Categoria eliminada")
            period = f"{MONTH_ABBR[b.month - 1]} {b.year}"

            top = ctk.CTkFrame(inner, fg_color="transparent")
            top.pack(fill="x")

            cat_badge = ctk.CTkFrame(
                top, fg_color=badge_color(c_name), corner_radius=6, height=26
            )
            cat_badge.pack(side="left")
            cat_badge.pack_propagate(False)
            ctk.CTkLabel(
                cat_badge,
                text=c_name.upper(),
                font=ctk.CTkFont(size=12, weight="bold"),
                text_color="#FFFFFF",
            ).pack(padx=8, pady=2)

            ctk.CTkLabel(
                top, text=period, font=ctk.CTkFont(size=12), text_color=TEXT_SECONDARY
            ).pack(side="right")

            remaining = b.limit_amount - r["spent"]
            pct = (
                (float(r["spent"]) / float(b.limit_amount) * 100)
                if b.limit_amount > 0
                else 0
            )
            pct = min(pct, 100)

            bar_bg = ctk.CTkFrame(inner, height=10, fg_color=BORDER, corner_radius=5)
            bar_bg.pack(fill="x", pady=(8, 4))
            bar_bg.pack_propagate(False)
            bar_color = RED if r["exceeded"] else (YELLOW if pct > 70 else GREEN)
            if pct > 0:
                bar_fill = ctk.CTkFrame(
                    bar_bg, height=10, fg_color=bar_color, corner_radius=5
                )
                bar_fill.place(relx=0, rely=0, relwidth=pct / 100, relheight=1)

            amounts = ctk.CTkFrame(inner, fg_color="transparent")
            amounts.pack(fill="x")

            ctk.CTkLabel(
                amounts,
                text=f"Gastado: ${r['spent']:,.2f}",
                font=ctk.CTkFont(size=12, weight="bold"),
                text_color=TEXT_PRIMARY,
            ).pack(side="left")

            rem_color = GREEN if remaining >= 0 else RED
            rem_text = (
                f"Restante: ${remaining:,.2f}"
                if remaining >= 0
                else f"Excedido: ${abs(remaining):,.2f}"
            )
            ctk.CTkLabel(
                amounts, text=rem_text, font=ctk.CTkFont(size=12), text_color=rem_color
            ).pack(side="right")

            footer = ctk.CTkFrame(inner, fg_color="transparent")
            footer.pack(fill="x", pady=(4, 0))
            ctk.CTkLabel(
                footer,
                text=f"Limite: ${b.limit_amount:,.2f}  |  {int(pct)}% usado",
                font=ctk.CTkFont(size=11),
                text_color=TEXT_MUTED,
            ).pack(side="left")
            status_text = "EXCEDIDO" if r["exceeded"] else "DENTRO DEL LIMITE"
            status_color = RED if r["exceeded"] else GREEN
            ctk.CTkLabel(
                footer,
                text=status_text,
                text_color=status_color,
                font=ctk.CTkFont(size=11, weight="bold"),
            ).pack(side="right")
