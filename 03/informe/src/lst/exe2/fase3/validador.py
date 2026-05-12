def validar_contrasena(contrasena: str) -> dict:
    """
    Evalúa la fortaleza de una contraseña basándose en 5 reglas específicas.

    Reglas de validación:
    1. Longitud mínima de 8 caracteres.
    2. Contiene al menos una letra mayúscula.
    3. Contiene al menos una letra minúscula.
    4. Contiene al menos un dígito numérico.
    5. Contiene al menos un carácter especial de entre: ! @ # $ % ^ & *

    Args:
        contrasena (str): La cadena de texto de la contraseña a evaluar.
            Dominio: Cualquier cadena de texto (str).

    Returns:
        dict: Un diccionario con el resultado de la validación.
            Formato esperado:
            {
                "valida": bool, # True si cumple todas las reglas, False en caso contrario.
                "errores": list # Lista de strings detallando las reglas no cumplidas. Vacía si "valida" es True.
            }
            
            Mensajes de error esperados (si aplica):
            - "La contraseña debe tener al menos 8 caracteres."
            - "La contraseña debe contener al menos una letra mayúscula."
            - "La contraseña debe contener al menos una letra minúscula."
            - "La contraseña debe contener al menos un dígito numérico."
            - "La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *)."
    """
    errores = []
    
    if len(contrasena) < 8:
        errores.append("La contraseña debe tener al menos 8 caracteres.")
        
    if not any(c.isupper() for c in contrasena):
        errores.append("La contraseña debe contener al menos una letra mayúscula.")
        
    if not any(c.islower() for c in contrasena):
        errores.append("La contraseña debe contener al menos una letra minúscula.")
        
    if not any(c.isdigit() for c in contrasena):
        errores.append("La contraseña debe contener al menos un dígito numérico.")
        
    # Caracteres especiales permitidos: ! @ # $ % ^ & *
    especiales_permitidos = set("!@#$%^&*")
    if not any(c in especiales_permitidos for c in contrasena):
        errores.append("La contraseña debe contener al menos un carácter especial (! @ # $ % ^ & *).")
        
    return {
        "valida": len(errores) == 0,
        "errores": errores
    }
