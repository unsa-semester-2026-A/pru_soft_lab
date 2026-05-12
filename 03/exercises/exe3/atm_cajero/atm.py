"""
Módulo que define la estructura del Cajero Automático (ATM).
"""

class SaldoInsuficienteError(Exception):
    """Excepción lanzada cuando se intenta retirar un monto mayor al saldo disponible."""
    pass

class MontoInvalidoError(Exception):
    """Excepción lanzada cuando se proporciona un monto no válido (negativo o cero)."""
    pass

class Atm:
    """
    Simulador de un Cajero Automático.
    
    Permite realizar operaciones básicas de consulta de saldo, depósito y retiro.
    """

    def __init__(self, saldo_inicial: float = 0.0):
        """
        Inicializa una nueva instancia del cajero con un saldo inicial.

        Args:
            saldo_inicial (float): El monto con el que inicia el cajero.
                Dominio: saldo_inicial >= 0 (Números reales no negativos).
        """
        if saldo_inicial < 0:
            raise MontoInvalidoError("El saldo inicial no puede ser negativo.")
        self._saldo = float(saldo_inicial)

    def consultar_saldo(self) -> float:
        """
        Retorna el saldo actual disponible en el cajero.

        Returns:
            float: El saldo actual.
                Dominio: [0, +inf) (Números reales no negativos).
        """
        return self._saldo

    def depositar(self, monto: float) -> None:
        """
        Incrementa el saldo del cajero con el monto proporcionado.

        Args:
            monto (float): El monto a depositar.
                Dominio: monto > 0 (Números reales positivos).
        """
        if monto <= 0:
            raise MontoInvalidoError(f"Monto inválido: {monto}. Debe ser positivo.")
        self._saldo += float(monto)

    def retirar(self, monto: float) -> None:
        """
        Decrementa el saldo del cajero con el monto proporcionado.

        Args:
            monto (float): El monto a retirar.
                Dominio: monto > 0 (Números reales positivos).
        """
        if monto <= 0:
            raise MontoInvalidoError(f"Monto inválido: {monto}. Debe ser positivo.")
        if monto > self._saldo:
            raise SaldoInsuficienteError(
                f"Saldo insuficiente: tiene {self._saldo}, intenta retirar {monto}"
            )
        self._saldo -= float(monto)
