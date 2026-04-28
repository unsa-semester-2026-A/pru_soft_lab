import unittest
from triangle import clasificar_triangulo


class TestClasificarTriangulo(unittest.TestCase):

    def test_01_escaleno_valido(self):
        self.assertEqual(clasificar_triangulo(3, 4, 5), "El triangulo es escaleno.")

    def test_02_equilatero_valido(self):
        self.assertEqual(clasificar_triangulo(7, 7, 7), "El triangulo es equilatero.")

    def test_03_isosceles_valido(self):
        self.assertEqual(clasificar_triangulo(5, 5, 8), "El triangulo es isosceles.")

    def test_04a_isosceles_ab(self):
        self.assertEqual(clasificar_triangulo(3, 3, 4), "El triangulo es isosceles.")

    def test_04b_isosceles_ac(self):
        self.assertEqual(clasificar_triangulo(3, 4, 3), "El triangulo es isosceles.")

    def test_04c_isosceles_bc(self):
        self.assertEqual(clasificar_triangulo(4, 3, 3), "El triangulo es isosceles.")

    def test_05_lado_cero(self):
        self.assertIn("invalido", clasificar_triangulo(3, 0, 5))

    def test_06_lado_negativo(self):
        self.assertIn("invalido", clasificar_triangulo(3, 4, -5))

    def test_07_suma_igual_tercero(self):
        self.assertIn("invalido", clasificar_triangulo(1, 2, 3))

    def test_08a_suma_igual_perm1(self):
        self.assertIn("invalido", clasificar_triangulo(1, 2, 3))

    def test_08b_suma_igual_perm2(self):
        self.assertIn("invalido", clasificar_triangulo(1, 3, 2))

    def test_08c_suma_igual_perm3(self):
        self.assertIn("invalido", clasificar_triangulo(3, 1, 2))

    def test_09_suma_menor_tercero(self):
        self.assertIn("invalido", clasificar_triangulo(1, 2, 4))

    def test_10a_suma_menor_perm1(self):
        self.assertIn("invalido", clasificar_triangulo(1, 2, 4))

    def test_10b_suma_menor_perm2(self):
        self.assertIn("invalido", clasificar_triangulo(1, 4, 2))

    def test_10c_suma_menor_perm3(self):
        self.assertIn("invalido", clasificar_triangulo(4, 1, 2))

    def test_11_todos_cero(self):
        self.assertIn("invalido", clasificar_triangulo(0, 0, 0))


if __name__ == "__main__":
    unittest.main()
