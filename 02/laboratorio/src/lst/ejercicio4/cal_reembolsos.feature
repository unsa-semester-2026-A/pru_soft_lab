Feature: Calculadora de Reembolsos de Hotel

  Scenario: Cliente VIP cancela con poca antelación
    Given un cliente "VIP"
    And una reserva con un monto de 1000
    When el cliente cancela la reserva con 2 horas de antelación
    Then el sistema debe calcular un reembolso del 50%, es decir, 500

  Scenario: Cliente convencional cancela con poca antelación
    Given un cliente convencional
    And una reserva con un monto de 1000
    When el cliente cancela la reserva con 2 horas de antelación
    Then el sistema debe calcular un reembolso del 0%, es decir, 0
  