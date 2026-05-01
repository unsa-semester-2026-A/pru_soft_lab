class CajeroATM:
    def __init__(self, saldo_inicial: float):
        if saldo_inicial < 0:
            raise ValueError("El saldo inicial no puede ser negativo")
        self.saldo = saldo_inicial

    def retirar(self, monto: float) -> str:
        if monto <= 0:
            return "Monto inválido"
        if monto > self.saldo:
            return "Fondos Insuficientes"
        self.saldo -= monto
        return "Retiro exitoso"
