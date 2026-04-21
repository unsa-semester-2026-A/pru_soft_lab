import unittest
from rectangle import calcular_area


class TestCalcularArea(unittest.TestCase):

    def test_01_enteros_positivos(self):
        self.assertEqual(calcular_area(3, 4), 12)

    def test_02_decimales_positivos(self):
        self.assertAlmostEqual(calcular_area(2.5, 3.5), 8.75)

    def test_03_base_uno(self):
        self.assertEqual(calcular_area(1, 7), 7)

    def test_04_altura_uno(self):
        self.assertEqual(calcular_area(5, 1), 5)

    def test_05_base_cero(self):
        self.assertEqual(calcular_area(0, 5), 0)

    def test_06_altura_cero(self):
        self.assertEqual(calcular_area(5, 0), 0)

    def test_07_ambos_cero(self):
        self.assertEqual(calcular_area(0, 0), 0)

    def test_08_decimal_precision(self):
        self.assertAlmostEqual(calcular_area(1.5, 2.0), 3.0)

    def test_09_enteros_grandes(self):
        self.assertEqual(calcular_area(100, 200), 20000)


if __name__ == "__main__":
    unittest.main()
