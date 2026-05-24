"""Main entry point for the finance application."""

from finance.adapters.ui import ConsoleUI
from finance.core.services import GreetingService


def main():
    """Run the main application logic."""
    service = GreetingService()
    app = ConsoleUI(service=service)
    app.run(user_name="Equipo")


if __name__ == "__main__":
    main()
