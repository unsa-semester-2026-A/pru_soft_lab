def clasificar_numero(n: int) -> str:
    """
    Determina si un número entero es par o impar.

    Args:
        n (int): El número a clasificar. Debe ser estrictamente un entero.

    Returns:
        str: "par" si el número es múltiplo de 2, "impar" en caso contrario.

    Raises:
        TypeError: Si `n` no es de tipo entero (ej. flotantes, cadenas, booleanos).
    """
    if type(n) is not int:
        raise TypeError("El valor debe ser estrictamente un numero entero.")
        
    return "par" if n % 2 == 0 else "impar"

if __name__ == "__main__":
    try:
        cantidad = int(input("Cuantos numeros desea ingresar? "))
        numeros = []
        for i in range(cantidad):
            n = int(input(f"Numero {i + 1}: "))
            numeros.append(n)
        for n in numeros:
            print(f"{n} es {clasificar_numero(n)}")
    except ValueError:
        print("Error: ingrese solo numeros enteros.")
