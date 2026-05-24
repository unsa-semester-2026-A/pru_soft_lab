from finance.core.services import GreetingService


def test_generate_greeting_returns_correct_data():
    service = GreetingService()
    result = service.generate_greeting(name="TestUser")
    assert result.user_name == "TestUser"
    assert result.system_message == "Core initialized successfully."
