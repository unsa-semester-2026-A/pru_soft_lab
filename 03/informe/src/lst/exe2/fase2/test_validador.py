import pytest
from validador import validar_contrasena

@pytest.mark.parametrize("contrasena, expected_errores", [
    # TC-01: Contraseña completamente válida
    ("Segura#1", []),
    
    # TC-02: Falla la longitud (< 8)
    ("Ab1!", [
        "La contraseña debe tener al menos 8 caracteres."
    ]),
    
    # TC-03: Falla por falta de mayúscula
    ("segura#1", [
        "La contraseña debe contener al menos una letra mayúscula."
    ]),
    
    # TC-04: Falla por falta de minúscula
    ("SEGURA#1", [
        "La contraseña debe contener al menos una letra minúscula."
    ]),
    
    # TC-05: Falla por falta de número
    ("Segura##", [
        "La contraseña debe contener al menos un dígito numérico."
    ]),
    
    # TC-06: Falla por falta de carácter especial
    ("Segura12", [
        "La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *)."
    ]),
    
    # TC-07: Falla en todo (vacía)
    ("", [
        "La contraseña debe tener al menos 8 caracteres.",
        "La contraseña debe contener al menos una letra mayúscula.",
        "La contraseña debe contener al menos una letra minúscula.",
        "La contraseña debe contener al menos un dígito numérico.",
        "La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *)."
    ]),
    
    # TC-08: Exactamente 8 caracteres válidos (borde)
    ("aB1!cDe2", []),
    
    # TC-09: Solo letras (minúsculas)
    ("abcdefghi", [
        "La contraseña debe contener al menos una letra mayúscula.",
        "La contraseña debe contener al menos un dígito numérico.",
        "La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *)."
    ]),
    
    # TC-10: Combinación de faltas (sin número y sin especial)
    ("SuperSegura", [
        "La contraseña debe contener al menos un dígito numérico.",
        "La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *)."
    ]),
    
    # TC-11: Contraseña válida con espacios internos (debe ser válida)
    ("Seg ura#1", []),
    
    # TC-12: Contraseña con carácter especial no permitido (?), cuenta como falta de especial
    ("Segura1?", [
        "La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *)."
    ]),
])
def test_validar_contrasena(contrasena, expected_errores):
    """Verifica que la función retorne los errores correctos y el estado 'valida' correspondiente."""
    # Arrange
    # (Los valores ya están listos gracias a parametrize)
    
    # Act
    resultado = validar_contrasena(contrasena)
    
    # Assert
    assert isinstance(resultado, dict), "El resultado debe ser un diccionario"
    
    if len(expected_errores) == 0:
        assert resultado["valida"] is True, "La contraseña debe ser válida."
        assert resultado["errores"] == [], "La lista de errores debe estar vacía."
    else:
        assert resultado["valida"] is False, "La contraseña debe ser inválida."
        # Validar que los errores devueltos coincidan con los esperados (sin importar el orden)
        assert set(resultado["errores"]) == set(expected_errores), f"Errores esperados: {expected_errores}, pero se obtuvo: {resultado['errores']}"
