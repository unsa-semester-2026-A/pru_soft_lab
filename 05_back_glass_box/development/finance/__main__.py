"""Main entry point for the finance application."""

from finance.adapters.inbound.ui_python.app_ui import FinanceApp
from finance.config.bootstrap import AppContainer


def main() -> None:
    """Wire the real service and launch the UI."""
    container = AppContainer.build_container()
    app = FinanceApp(servicio=container.finance_service)
    app.mainloop()


if __name__ == "__main__":
    main()
