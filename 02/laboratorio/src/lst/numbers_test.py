import sys
import os
# Garantiza que se importa numbers.py local, no el modulo stdlib numbers
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from numbers import clasificar_numero  # noqa: E402

import unittest


class TestClasificarNumero(unittest.TestCase):

    def test_01_par_positivo(self):
        self.assertEqual(clasificar_numero(4), "par")

    def test_02_impar_positivo(self):
        self.assertEqual(clasificar_numero(7), "impar")

    def test_03_cero(self):
        self.assertEqual(clasificar_numero(0), "par")

    def test_04_negativo_par(self):
        self.assertEqual(clasificar_numero(-4), "par")

    def test_05_negativo_impar(self):
        self.assertEqual(clasificar_numero(-3), "impar")

    def test_06_dos(self):
        self.assertEqual(clasificar_numero(2), "par")

    def test_07_uno(self):
        self.assertEqual(clasificar_numero(1), "impar")


if __name__ == "__main__":
    unittest.main()
