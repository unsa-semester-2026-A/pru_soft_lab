def clasificar_triangulo(lado1, lado2, lado3):
    if lado1 <= 0 or lado2 <= 0 or lado3 <= 0:
        return "Triangulo invalido: Las longitudes de los lados deben ser positivas."
    if (lado1 + lado2 <= lado3) or \
       (lado1 + lado3 <= lado2) or \
       (lado2 + lado3 <= lado1):
        return "Triangulo invalido: Las longitudes no cumplen la desigualdad triangular."
    if lado1 == lado2 == lado3:
        return "El triangulo es equilatero."
    elif lado1 == lado2 or lado1 == lado3 or lado2 == lado3:
        return "El triangulo es isosceles."
    else:
        return "El triangulo es escaleno."


if __name__ == "__main__":
    print("Ingrese las longitudes de los tres lados del triangulo:")
    try:
        s1 = int(input("Lado 1: "))
        s2 = int(input("Lado 2: "))
        s3 = int(input("Lado 3: "))
        print(clasificar_triangulo(s1, s2, s3))
    except ValueError:
        print("Error: Por favor, ingrese solo numeros enteros para las longitudes de los lados.")
