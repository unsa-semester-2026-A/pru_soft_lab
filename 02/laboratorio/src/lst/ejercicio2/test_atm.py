import unittest
from atm import CajeroATM

class TestCajeroATM(unittest.TestCase):
    # Escenario: Retiro de monto cero (valor inválido)
    def test_retiro_de_cero_es_invalido(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(0)
        self.assertEqual(resultado, "Monto inválido")
        self.assertEqual(cajero.saldo, 100)

    def test_retiro_negativo_es_invalido(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(-10)
        self.assertEqual(resultado, "Monto inválido")
        self.assertEqual(cajero.saldo, 100)

    # Escenario: Retiro con monto exacto al saldo (valor límite)
    def test_retiro_exactamente_igual_al_saldo(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(100)
        self.assertEqual(resultado, "Retiro exitoso")
        self.assertEqual(cajero.saldo, 0)

    # Escenario: Retiro fallido por fondos insuficientes <- PRINCIPAL
    def test_retiro_mayor_al_saldo_muestra_fondos_insuficientes(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(150)
        self.assertEqual(resultado, "Fondos Insuficientes")
        self.assertEqual(cajero.saldo, 100)

    # Escenario: Retiro exitoso con saldo suficiente
    def test_retiro_normal_exitoso(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(50)
        self.assertEqual(resultado, "Retiro exitoso")
        self.assertEqual(cajero.saldo, 50)

    # Límite superior fallido
    def test_retiro_un_peso_mas_del_saldo_falla(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(101)
        self.assertEqual(resultado, "Fondos Insuficientes")
        self.assertEqual(cajero.saldo, 100)

    # Límite interior exitoso
    def test_retiro_un_peso_menos_del_saldo_exitoso(self):
        cajero = CajeroATM(100)
        resultado = cajero.retirar(99)
        self.assertEqual(resultado, "Retiro exitoso")
        self.assertEqual(cajero.saldo, 1)

    def test_saldo_no_cambia_cuando_hay_fondos_insuficientes(self):
        cajero = CajeroATM(100)
        cajero.retirar(150)
        self.assertEqual(cajero.saldo, 100)

if __name__ == '__main__':
    unittest.main()
