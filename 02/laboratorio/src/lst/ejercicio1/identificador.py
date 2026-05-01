def validar_identificador(identificador: str) -> bool:
    """
    Valida si el nombre de una variable (identificador) es válido según las reglas clásicas de Fortran:
    1. Debe tener entre 1 y 6 caracteres.
    2. El primer carácter debe ser obligatoriamente una letra.
    3. Los caracteres restantes pueden ser letras o dígitos.
    
    Args:
        identificador (str): El nombre de la variable a validar.
        
    Returns:
        bool: True si el identificador es válido, False de lo contrario.
    """
    # 1. Regla: Longitud entre 1 y 6 caracteres
    if not (1 <= len(identificador) <= 6):
        return False
    
    # 2. Regla: El primer carácter debe ser una letra
    if not identificador[0].isalpha():
        return False
        
    # 3. Regla: Los caracteres restantes deben ser letras o dígitos
    if len(identificador) > 1:
        if not identificador[1:].isalnum():
            return False
            
    return True
