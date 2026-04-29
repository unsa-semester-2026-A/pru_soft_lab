def calcular_area(base: float | int, altura: float | int) -> float | int:
    """
    Calcula el área de un rectángulo dadas su base y altura.

    Args:
        base (float | int): La medida de la base del rectángulo. Debe ser mayor o igual a cero.
        altura (float | int): La medida de la altura del rectángulo. Debe ser mayor o igual a cero.

    Returns:
        float | int: El área calculada del rectángulo. El tipo de retorno coincide 
        con los tipos de entrada provistos.

    Raises:
        TypeError: Si `base` o `altura` no son de tipo `int` o `float`.
        ValueError: Si `base` o `altura` son valores estrictamente negativos.
    """
    if type(base) not in (int, float) or type(altura) not in (int, float):
        raise TypeError("La base y la altura deben ser valores numéricos.")
    
    if base < 0 or altura < 0:
        raise ValueError("La base y la altura no pueden ser negativas.")
        
    return base * altura

if __name__ == "__main__":
    try:
        base = float(input("Ingrese la base: "))
        altura = float(input("Ingrese la altura: "))
        area = calcular_area(base, altura)
        print(f"Base: {base}, Altura: {altura}, Area: {area:.4f}")
    except (ValueError, TypeError) as e:
        print(f"Error: {e}")
