import unittest

class TestReembolsoHotel(unittest.TestCase):

    def test_01_mas_de_72_horas(self):
        self.assertAlmostEqual(calcular_reembolso(1000.0, 73, False), 1000.0)

if __name__ == "__main__":
    unittest.main()