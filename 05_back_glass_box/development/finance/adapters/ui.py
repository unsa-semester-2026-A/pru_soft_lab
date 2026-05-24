"""Minimal module for demonstration."""

from finance.core.services import GreetingService


class ConsoleUI:
    """Console user interface for the finance application."""

    def __init__(self, service: GreetingService) -> None:
        """Initialize the ConsoleUI with a greeting service.

        Args:
            service: The service used to generate greetings.
        """
        self.service = service

    def run(self, user_name: str):
        """Run the console UI logic.

        Args:
            user_name: The name of the user to greet.
        """
        greeting = self.service.generate_greeting(name=user_name)
        print(f"Bienvenido al sistema {greeting.user_name}!")
        print("El núcleo del sistema se ha inicializado correctamente.")
