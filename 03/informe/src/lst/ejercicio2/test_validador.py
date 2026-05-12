# test_validador.py

import pytest
from validador import validar_contrasena


@pytest.mark.parametrize(
    "contrasena,esperado",
    [

        # TC-01
        ("Segura#1", True),

        # TC-02
        ("Ab1!", False),

        # TC-03
        ("segura#1", False),

        # TC-04
        ("SEGURA#1", False),

        # TC-05
        ("Segura##", False),

        # TC-06
        ("Segura12", False),

        # TC-07
        ("", False),

        # TC-08
        ("aB1!cDe2", True),

        # TC-09
        ("abcdefghi", False),

        # TC-10
        ("ABCDEFGHI", False),

        # TC-11
        ("12345678", False),

        # TC-12
        ("!@#$%^&*", False),

        # TC-13
        ("AbCdEfGh", False),

        # TC-14
        ("Segura123", False),

        # TC-15
        ("1234!@#$", False),

        # TC-16
        ("Seg ura#1", True),

        # TC-17
        ("Segura!!!1", True),

        # TC-18
        ("MiContrasenaSuperSegura#123", True),

        # TC-19
        ("Contraseña#1", True),

        # TC-20
        ("Segura1?", False),

        # TC-21
        ("        ", False),

        # TC-22
        ("Clave😀#1A", True),

        # TC-23
        ("abc#1234", False),

        # TC-24
        ("ABC#1234", False),

        # TC-25
        ("Abcdef#@", False),

        # TC-26
        ("Abcd1234", False),

        # TC-27
        ("Clave^123A", True),

        # TC-28
        ("Clave&123A", True),

        # TC-29
        ("Clave*123A", True),

        # TC-30
        ("Aa1!aaaa", True),
    ]
)
def test_validar_contrasena(contrasena, esperado):

    # Arrange
    entrada = contrasena

    # Act
    resultado = validar_contrasena(entrada)

    # Assert
    assert resultado["valida"] == esperado