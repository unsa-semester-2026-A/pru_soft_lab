import unittest
from reembolso_refactor import calcular_reembolso

class TestReembolsos(unittest.TestCase):

    # --- TESTS DE CASOS VÁLIDOS ---
    def test_id1_horas_mayor_72(self):
        self.assertEqual(calcular_reembolso(1000, 73, False), 1000.0)

    def test_id2_horas_limite_24(self):
        self.assertEqual(calcular_reembolso(1000, 24, False), 500.0)
    
    def test_id3_horas_menor_24(self):
        self.assertEqual(calcular_reembolso(1000, 2, False), 0.0)

    def test_id4_vip_ultima_hora(self):
        self.assertEqual(calcular_reembolso(1000, 2, True), 500.0)
        
    def test_id5_monto_cero(self):
        self.assertEqual(calcular_reembolso(0, 48, False), 0.0)

    def test_id6_monto_decimales(self):
        self.assertEqual(calcular_reembolso(999.99, 48, False), 499.995)

    def test_id8_horas_cero_segun_tabla(self):
        self.assertEqual(calcular_reembolso(1000, 0, False), 0.0)

    # --- TESTS DE ERROR ---
    def test_id7_monto_negativo(self):
        with self.assertRaises(ValueError):
            calcular_reembolso(-100, 48)
            
    def test_id9_horas_decimales_invalido(self):
        with self.assertRaises(ValueError):
            calcular_reembolso(1000, 24.5)
            
    def test_id10_horas_negativas(self):
        with self.assertRaises(ValueError):
            calcular_reembolso(1000, -5)

    def test_id11_texto(self):
        with self.assertRaises(ValueError):
            calcular_reembolso("mil", "veinticuatro")
    
    def test_id12_vacio(self):
        with self.assertRaises(ValueError):
            calcular_reembolso("", "")

    def test_id13_nulos(self):
        with self.assertRaises(ValueError):
            calcular_reembolso(None, None)

if __name__ == "__main__":
    unittest.main()