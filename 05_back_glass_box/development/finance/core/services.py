from finance.core.entities import Greeting


class GreetingService:
    def generate_greeting(self, name: str):
        return Greeting(user_name=name, system_message="Core initialized successfully.")
