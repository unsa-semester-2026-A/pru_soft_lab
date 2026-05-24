"""Core services for the finance application."""

from finance.core.entities import Greeting


class GreetingService:
    """Service for generating greetings."""

    def generate_greeting(self, name: str):
        """Generate a greeting for a given name.

        Args:
            name: The name of the person to greet.

        Returns:
            A Greeting entity.
        """
        return Greeting(user_name=name, system_message="Core initialized successfully.")
