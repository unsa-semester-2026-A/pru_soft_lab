def calcular_area(base, altura):
    return base * altura


if __name__ == "__main__":
    try:
        base = float(input("Ingrese la base: "))
        altura = float(input("Ingrese la altura: "))
        area = calcular_area(base, altura)
        print(f"Base: {base}, Altura: {altura}, Area: {area:.4f}")
    except ValueError:
        print("Error: ingrese valores numericos validos.")
