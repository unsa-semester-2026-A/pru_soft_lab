from dataclasses import dataclass


@dataclass
class Greeting:
    user_name: str
    system_message: str
