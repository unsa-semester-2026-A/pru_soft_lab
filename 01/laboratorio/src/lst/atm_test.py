import unittest
from atm import consultar_saldo, depositar, retirar

class TestATM(unittest.TestCase):

    # --- Pruebas para consultar_saldo ---
    def test_consultar_saldo_valido(self):
        self.assertEqual(consultar_saldo(1000.0), 1000.0)

    def test_consultar_saldo_tipo_invalido(self):
        with self.assertRaises(TypeError):
            consultar_saldo("1000")

    # --- Pruebas para depositar ---
    def test_depositar_valido(self):
        self.assertAlmostEqual(depositar(1000.0, 200.0), 1200.0)

    def test_depositar_monto_cero(self):
        with self.assertRaises(ValueError):
            depositar(1000.0, 0)

    def test_depositar_monto_negativo(self):
        with self.assertRaises(ValueError):
            depositar(1000.0, -100.0)

    def test_depositar_tipo_invalido(self):
        with self.assertRaises(TypeError):
            depositar(1000.0, "200")
            
        with self.assertRaises(TypeError):
            depositar(1000.0, None)

    # --- Pruebas para retirar ---
    def test_retirar_valido(self):
        self.assertAlmostEqual(retirar(1000.0, 300.0), 700.0)

    def test_retirar_saldo_exacto(self):
        self.assertAlmostEqual(retirar(1000.0, 1000.0), 0.0)

    def test_retirar_excede_saldo(self):
        with self.assertRaises(ValueError):
            retirar(1000.0, 1500.0)

    def test_retirar_monto_cero(self):
        with self.assertRaises(ValueError):
            retirar(1000.0, 0)

    def test_retirar_monto_negativo(self):
        with self.assertRaises(ValueError):
            retirar(1000.0, -50.0)

    def test_retirar_tipo_invalido(self):
        with self.assertRaises(TypeError):
            retirar(1000.0, "50")

if __name__ == "__main__":
    unittest.main()
