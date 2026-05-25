"""Main entry point for the finance application."""

from finance.adapters.inbound.ui_python.app_ui import FinanceApp
from finance.config.bootstrap import build_container


def main() -> None:
    """Wire the real service and launch the UI."""
    container = build_container()
    app = FinanceApp(servicio=container.finance_service)
    app.mainloop()


if __name__ == "__main__":
    main()
