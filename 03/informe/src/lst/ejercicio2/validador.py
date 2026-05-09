# validador.py

import re


def validar_contrasena(contrasena: str) -> dict:
    """
    Evalúa la fortaleza de una contraseña basándose en 5 reglas:

    1. Longitud mínima de 8 caracteres.
    2. Al menos una letra mayúscula.
    3. Al menos una letra minúscula.
    4. Al menos un dígito numérico.
    5. Al menos un carácter especial permitido:
       ! @ # $ % ^ & *

    Parámetros:
    contrasena (str):
        Contraseña que será evaluada.

    Retorna:
    dict:
        {
            "valida": bool,
            "errores": list
        }

    - "valida" será True si cumple todas las reglas.
    - "errores" contendrá los criterios incumplidos.
    """

    errores = []

    # Regla 1: Longitud mínima
    if len(contrasena) < 8:
        errores.append(
            "La contraseña debe tener al menos 8 caracteres"
        )

    # Regla 2: Al menos una letra mayúscula
    if not re.search(r"[A-Z]", contrasena):
        errores.append(
            "La contraseña debe contener al menos una letra mayúscula"
        )

    # Regla 3: Al menos una letra minúscula
    if not re.search(r"[a-z]", contrasena):
        errores.append(
            "La contraseña debe contener al menos una letra minúscula"
        )

    # Regla 4: Al menos un dígito numérico
    if not re.search(r"\d", contrasena):
        errores.append(
            "La contraseña debe contener al menos un dígito"
        )

    # Regla 5: Al menos un carácter especial permitido
    if not re.search(r"[!@#$%^&*]", contrasena):
        errores.append(
            "La contraseña debe contener al menos un carácter especial"
        )

    # Resultado final
    return {
        "valida": len(errores) == 0,
        "errores": errores
    }