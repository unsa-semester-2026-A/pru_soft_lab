import unittest
from atm import consultar_saldo, depositar, retirar


class TestATM(unittest.TestCase):

    def test_01_consultar_saldo(self):
        self.assertEqual(consultar_saldo(1000.0), 1000.0)

    def test_02_depositar_valido(self):
        self.assertAlmostEqual(depositar(1000.0, 200.0), 1200.0)

    def test_03_depositar_monto_cero(self):
        with self.assertRaises(ValueError):
            depositar(1000.0, 0)

    def test_04_depositar_monto_negativo(self):
        with self.assertRaises(ValueError):
            depositar(1000.0, -100.0)

    def test_05_retirar_valido(self):
        self.assertAlmostEqual(retirar(1000.0, 300.0), 700.0)

    def test_06_retirar_saldo_exacto(self):
        self.assertAlmostEqual(retirar(1000.0, 1000.0), 0.0)

    def test_07_retirar_excede_saldo(self):
        with self.assertRaises(ValueError):
            retirar(1000.0, 1500.0)

    def test_08_retirar_monto_cero(self):
        with self.assertRaises(ValueError):
            retirar(1000.0, 0)

    def test_09_retirar_monto_negativo(self):
        with self.assertRaises(ValueError):
            retirar(1000.0, -50.0)


if __name__ == "__main__":
    unittest.main()
