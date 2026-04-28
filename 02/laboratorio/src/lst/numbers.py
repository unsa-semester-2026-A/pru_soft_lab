def clasificar_numero(n):
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
