import pytest
from calculadora_docstrings import Calculadora


@pytest.fixture
def calc():
    """Arrange: Instancia global para las pruebas."""
    return Calculadora()


class TestSuma:
    def test_suma_enteros(self, calc):
        # Arrange
        a, b = 5, 3
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert resultado == 8

    def test_suma_negativos(self, calc):
        # Arrange
        a, b = -5, -3
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert resultado == -8


class TestResta:
    def test_resta_enteros(self, calc):
        # Arrange
        a, b = 10, 4
        # Act
        resultado = calc.restar(a, b)
        # Assert
        assert resultado == 6

    def test_resta_negativos(self, calc):
        # Arrange
        a, b = -5, -3
        # Act
        resultado = calc.restar(a, b)
        # Assert
        assert resultado == -2


class TestMultiplicacion:
    def test_mul_enteros(self, calc):
        # Arrange
        a, b = 4, 7
        # Act
        resultado = calc.multiplicar(a, b)
        # Assert
        assert resultado == 28

    def test_mul_decimales(self, calc):
        # Arrange
        a, b = 2.5, 4.0
        # Act
        resultado = calc.multiplicar(a, b)
        # Assert
        assert resultado == 10.0

    def test_mul_negativos(self, calc):
        # Arrange
        a, b = -5, -4
        # Act
        resultado = calc.multiplicar(a, b)
        # Assert
        assert resultado == 20


class TestDivision:
    def test_division_enteros(self, calc):
        # Arrange
        a, b = 20, 4
        # Act
        resultado = calc.dividir(a, b)
        # Assert
        assert resultado == 5

    def test_division_decimal(self, calc):
        # Arrange
        a, b = 7.5, 2.5
        # Act
        resultado = calc.dividir(a, b)
        # Assert
        assert resultado == 3.0

    def test_division_entre_cero(self, calc):
        # Arrange
        a, b = 10, 0
        # Act & Assert
        with pytest.raises(ValueError, match="No se puede dividir entre cero"):
            calc.dividir(a, b)

    def test_dividir_cero_entre_numero(self, calc):
        # Arrange
        a, b = 0, 10
        # Act
        resultado = calc.dividir(a, b)
        # Assert
        assert resultado == 0.0


class TestPrecisionAvanzada:
    def test_precision_flotante(self, calc):
        # Arrange
        a, b = 0.1, 0.2
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert abs(resultado - 0.3) < 1e-9

    def test_numeros_grandes(self, calc):
        # Arrange
        a, b = 1e10, 1e10
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert resultado == 2e10

    def test_mul_desbordamiento(self, calc):
        # Arrange
        a, b = 1e300, 1e20
        # Act
        resultado = calc.multiplicar(a, b)
        # Assert
        assert resultado == float("inf")

    def test_divisor_infinito(self, calc):
        # Arrange
        a, b = 1e300, 1e-20
        # Act
        resultado = calc.dividir(a, b)
        # Assert
        assert resultado == float("inf")

    def test_infinito_negativo(self, calc):
        # Arrange
        a, b = -1e300, 1e20
        # Act
        resultado = calc.multiplicar(a, b)
        # Assert
        assert resultado == float("-inf")


class TestLimitesFlotantes:
    def test_limite_max_float(self, calc):
        # Arrange
        a, b = 1.79e308, 1.0
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert resultado == 1.79e308

    def test_desbordamiento_externo(self, calc):
        # Arrange
        a, b = 1.8e308, 1.1
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert resultado == float("inf")

    def test_division_limite_inf(self, calc):
        # Arrange
        a, b = 1e308, 0.1
        # Act
        resultado = calc.dividir(a, b)
        # Assert
        assert resultado == float("inf")

    def test_division_entre_cero_explicito(self, calc):
        # Arrange
        a, b = 10, 0
        # Act & Assert
        with pytest.raises(ValueError, match="No se puede dividir entre cero"):
            calc.dividir(a, b)


class TestParametrizadas:
    @pytest.mark.parametrize(
        "a, b, esperado",
        [
            (3, 5, 8),
            (-2, 7, 5),
            (1.5, 2.5, 4.0),
        ],
    )
    def test_suma_parametrizada(self, calc, a, b, esperado):
        # Arrange
        # Act
        resultado = calc.sumar(a, b)
        # Assert
        assert resultado == esperado
