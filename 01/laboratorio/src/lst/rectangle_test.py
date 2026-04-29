import unittest
import sys
from rectangle import calcular_area

class TestCalcularArea(unittest.TestCase):

    # --- Partición: Valores válidos (a > 0, b > 0) y Tipos (int, float) ---
    def test_enteros_positivos(self):
        self.assertEqual(calcular_area(3, 4), 12)

    def test_decimales_positivos(self):
        self.assertAlmostEqual(calcular_area(2.5, 3.5), 8.75)

    def test_decimal_precision(self):
        self.assertAlmostEqual(calcular_area(1.5, 2.0), 3.0)

    def test_flotantes_muy_grandes(self):
        # Límite de sistema para probar comportamiento con números extremos
        max_float = sys.float_info.max
        self.assertEqual(calcular_area(max_float, 1), max_float)

    # --- Partición: Límites matemáticos (a = 0 o b = 0 o ambos) e identidad (1) ---
    def test_base_uno(self):
        self.assertEqual(calcular_area(1, 7.5), 7.5)

    def test_altura_uno(self):
        self.assertEqual(calcular_area(5.2, 1), 5.2)

    def test_base_cero(self):
        self.assertEqual(calcular_area(0, 5.5), 0)

    def test_altura_cero(self):
        self.assertEqual(calcular_area(5.5, 0), 0)

    def test_ambos_cero(self):
        self.assertEqual(calcular_area(0, 0), 0)

    # --- Partición: Subdominio Inválido por Valor (a < 0 o b < 0) ---
    def test_base_negativa(self):
        with self.assertRaises(ValueError):
            calcular_area(-3, 4)

    def test_altura_negativa(self):
        with self.assertRaises(ValueError):
            calcular_area(3, -4)

    def test_ambos_negativos(self):
        with self.assertRaises(ValueError):
            calcular_area(-3, -4)

    # --- Partición: Subdominio Inválido por Tipo de Dato ---
    def test_tipo_string(self):
        with self.assertRaises(TypeError):
            calcular_area("3", 4)

    def test_tipo_none(self):
        with self.assertRaises(TypeError):
            calcular_area(None, 5)

    def test_tipo_booleano(self):
        # En Python True = 1 y False = 0, pero semánticamente es incorrecto para un área
        with self.assertRaises(TypeError):
            calcular_area(True, 4)

if __name__ == "__main__":
    unittest.main()
