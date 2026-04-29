import sys
import os
# Garantiza que se importa tu modulo local
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from numbers import clasificar_numero  # noqa: E402

import unittest

class TestClasificarNumero(unittest.TestCase):

    # --- Particiones válidas (Enteros) ---
    def test_par_positivo(self):
        self.assertEqual(clasificar_numero(4), "par")

    def test_impar_positivo(self):
        self.assertEqual(clasificar_numero(7), "impar")

    def test_cero(self):
        self.assertEqual(clasificar_numero(0), "par")

    def test_negativo_par(self):
        self.assertEqual(clasificar_numero(-4), "par")

    def test_negativo_impar(self):
        self.assertEqual(clasificar_numero(-3), "impar")

    def test_menor_par_positivo(self):
        self.assertEqual(clasificar_numero(2), "par")

    def test_menor_impar_positivo(self):
        self.assertEqual(clasificar_numero(1), "impar")

    def test_entero_extremo(self):
        # Límite superior típico en sistemas de 64 bits
        self.assertEqual(clasificar_numero(sys.maxsize), "impar")
        self.assertEqual(clasificar_numero(sys.maxsize - 1), "par")

    # --- Particiones inválidas (Tipos de datos no enteros) ---
    def test_tipo_flotante(self):
        with self.assertRaises(TypeError):
            clasificar_numero(2.5)

    def test_tipo_string(self):
        with self.assertRaises(TypeError):
            clasificar_numero("4")

    def test_tipo_booleano(self):
        # True no debe ser procesado como 1
        with self.assertRaises(TypeError):
            clasificar_numero(True)

    def test_tipo_none(self):
        with self.assertRaises(TypeError):
            clasificar_numero(None)

if __name__ == "__main__":
    unittest.main()
