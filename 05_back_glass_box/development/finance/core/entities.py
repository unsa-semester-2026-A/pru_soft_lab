"""Domain entities for the finance application."""

from dataclasses import dataclass


@dataclass
class Greeting:
    """Greeting entity representing a user welcome message."""

    user_name: str
    system_message: str
