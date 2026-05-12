import pytest
from atm import Atm, SaldoInsuficienteError, MontoInvalidoError

# --- Fixtures ---

@pytest.fixture
def cajero():
    """Fixture: retorna una instancia de Atm con saldo inicial de S/. 1000.0"""
    return Atm(saldo_inicial=1000.0)

# --- Pruebas de inicialización y consulta de saldo ---

def test_saldo_inicial_correcto(cajero):
    """TC-01: Verifica que el saldo inicial se asigne correctamente."""
    # Arrange: fixture 'cajero'
    # Act
    saldo_actual = cajero.consultar_saldo()
    # Assert
    assert saldo_actual == 1000.0

def test_inicializacion_saldo_negativo_lanza_excepcion():
    """TC-10: Verifica que inicializar con saldo negativo lance MontoInvalidoError."""
    # Arrange
    saldo_invalido = -500.0
    # Act & Assert
    with pytest.raises(MontoInvalidoError):
        Atm(saldo_inicial=saldo_invalido)

# --- Pruebas parametrizadas para operaciones exitosas ---

@pytest.mark.parametrize("monto_deposito, saldo_esperado", [
    (500.0, 1500.0),   # TC-02: Depósito válido estándar
    (0.01, 1000.01),   # Depósito mínimo
    (10000.0, 11000.0) # Depósito grande
])
def test_depositos_validos(cajero, monto_deposito, saldo_esperado):
    """Prueba múltiples depósitos válidos usando particiones de equivalencia."""
    # Arrange: fixture 'cajero' y parámetros
    # Act
    cajero.depositar(monto_deposito)
    # Assert
    assert abs(cajero.consultar_saldo() - saldo_esperado) < 0.001

@pytest.mark.parametrize("monto_retiro, saldo_esperado", [
    (300.0, 700.0),    # TC-03: Retiro válido estándar
    (1000.0, 0.0),     # TC-04: Retiro exacto al saldo disponible
    (0.01, 999.99),    # Retiro mínimo
])
def test_retiros_validos(cajero, monto_retiro, saldo_esperado):
    """Prueba múltiples retiros válidos usando valores límite."""
    # Arrange: fixture 'cajero' y parámetros
    # Act
    cajero.retirar(monto_retiro)
    # Assert
    assert abs(cajero.consultar_saldo() - saldo_esperado) < 0.001

def test_multiples_operaciones_consecutivas(cajero):
    """TC-11: Verifica que el saldo se mantenga consistente tras varias operaciones."""
    # Arrange: fixture 'cajero' (saldo inicial 1000.0)
    # Act
    cajero.depositar(500.0)
    cajero.retirar(200.0)
    cajero.depositar(100.0)
    # Assert (1000 + 500 - 200 + 100 = 1400)
    assert cajero.consultar_saldo() == 1400.0

def test_limites_deposito_y_retiro_minimo(cajero):
    """TC-12: Verifica los límites de depósito mínimo y retiro mínimo (0.01)."""
    # Act & Assert 1: Depósito mínimo
    cajero.depositar(0.01)
    assert abs(cajero.consultar_saldo() - 1000.01) < 0.001

    # Arrange 2: Retiramos el depósito para volver a 1000.0
    cajero.retirar(0.01)

    # Act & Assert 2: Retiro mínimo desde 1000.0
    cajero.retirar(0.01)
    assert abs(cajero.consultar_saldo() - 999.99) < 0.001

# --- Pruebas parametrizadas para excepciones de validación ---

@pytest.mark.parametrize("monto_invalido", [
    -200.0, # TC-06: Depósito de monto negativo
    0.0,    # TC-07: Depósito de monto cero
])
def test_deposito_monto_invalido_lanza_excepcion(cajero, monto_invalido):
    """Verifica que montos negativos o cero lancen MontoInvalidoError en depósitos."""
    # Arrange: fixture 'cajero' y parámetro
    # Act & Assert
    with pytest.raises(MontoInvalidoError):
        cajero.depositar(monto_invalido)

@pytest.mark.parametrize("monto_invalido", [
    -50.0,  # Retiro de monto negativo (equivalente a TC-08 asumido)
    0.0,    # TC-09: Retiro de monto cero
])
def test_retiro_monto_invalido_lanza_excepcion(cajero, monto_invalido):
    """Verifica que montos negativos o cero lancen MontoInvalidoError en retiros."""
    # Arrange: fixture 'cajero' y parámetro
    # Act & Assert
    with pytest.raises(MontoInvalidoError):
        cajero.retirar(monto_invalido)

def test_retiro_mayor_al_saldo_lanza_excepcion(cajero):
    """TC-05: Verifica que retirar más del saldo disponible lance SaldoInsuficienteError."""
    # Arrange: fixture 'cajero' (saldo 1000)
    monto_excesivo = 1001.0
    # Act & Assert
    with pytest.raises(SaldoInsuficienteError):
        cajero.retirar(monto_excesivo)
