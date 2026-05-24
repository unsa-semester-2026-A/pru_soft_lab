from finance.core.services import GreetingService


class ConsoleUI:
    def __init__(  self, service: GreetingService) -> None:
        self.service = service

    def run(self, user_name: str):
        greeting = self.service.generate_greeting(name=user_name)
        print(f"Bienvenido al sistema {greeting.user_name}!")
        print("El núcleo del sistema se ha inicializado correctamente.")
