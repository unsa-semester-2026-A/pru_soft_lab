import unittest
from identificador import validar_identificador

class TestValidadorIdentificador(unittest.TestCase):
    
    def test_longitud_valida(self):
        # Límite: 1 caracter
        self.assertTrue(validar_identificador("A"))
        # Límite: 6 caracteres
        self.assertTrue(validar_identificador("A1B2C3"))
        
    def test_longitud_invalida(self):
        # Límite: 0 caracteres (frontera inferior exterior)
        self.assertFalse(validar_identificador(""))
        # Límite: 7 caracteres (frontera superior exterior)
        self.assertFalse(validar_identificador("A123456"))

    def test_primer_caracter(self):
        # Empieza con letra
        self.assertTrue(validar_identificador("X"))
        # Empieza con número (inválido)
        self.assertFalse(validar_identificador("1ABC"))
        # Empieza con caracter especial
        self.assertFalse(validar_identificador("_ABC"))

    def test_caracteres_restantes_validos(self):
        # Solo letras y dígitos
        self.assertTrue(validar_identificador("Var1"))

    def test_caracteres_restantes_invalidos(self):
        # Contiene caracter especial (no letra ni dígito)
        self.assertFalse(validar_identificador("Var_1"))
        self.assertFalse(validar_identificador("A#B"))
        self.assertFalse(validar_identificador("A B"))

if __name__ == '__main__':
    unittest.main()
