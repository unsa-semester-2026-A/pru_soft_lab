SALDO_INICIAL = 1000.0


def consultar_saldo(saldo):
    return saldo


def depositar(saldo, monto):
    if monto <= 0:
        raise ValueError("El monto a depositar debe ser positivo.")
    return saldo + monto


def retirar(saldo, monto):
    if monto <= 0:
        raise ValueError("El monto a retirar debe ser positivo.")
    if monto > saldo:
        raise ValueError("Saldo insuficiente.")
    return saldo - monto


if __name__ == "__main__":
    saldo = SALDO_INICIAL
    while True:
        print("\n--- Cajero Automatico ---")
        print("1. Consultar Saldo")
        print("2. Depositar Dinero")
        print("3. Retirar Dinero")
        print("4. Salir")
        opcion = input("Seleccione una opcion: ").strip()
        if opcion == "1":
            print(f"Saldo actual: S/.{consultar_saldo(saldo):.2f}")
        elif opcion == "2":
            try:
                monto = float(input("Monto a depositar: S/."))
                saldo = depositar(saldo, monto)
                print(f"Deposito exitoso. Nuevo saldo: S/.{saldo:.2f}")
            except ValueError as e:
                print(f"Error: {e}")
        elif opcion == "3":
            try:
                monto = float(input("Monto a retirar: S/."))
                saldo = retirar(saldo, monto)
                print(f"Retiro exitoso. Nuevo saldo: S/.{saldo:.2f}")
            except ValueError as e:
                print(f"Error: {e}")
        elif opcion == "4":
            print("Hasta luego.")
            break
        else:
            print("Opcion invalida. Seleccione 1-4.")
