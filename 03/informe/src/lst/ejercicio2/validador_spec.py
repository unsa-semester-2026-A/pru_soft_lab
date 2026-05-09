def validar_contrasena(contrasena: str) -> dict:
    """
    Evalúa la fortaleza de una contraseña basándose en 5 reglas:

    1. Debe tener al menos 8 caracteres.
    2. Debe contener al menos una letra mayúscula.
    3. Debe contener al menos una letra minúscula.
    4. Debe contener al menos un dígito numérico.
    5. Debe contener al menos un carácter especial:
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
    - "errores" contendrá una lista con los criterios incumplidos.
    - Si la contraseña es válida, la lista de errores será vacía.
    """

    pass