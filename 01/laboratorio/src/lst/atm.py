SALDO_INICIAL = 1000.0

def consultar_saldo(saldo: float | int) -> float | int:
    """
    Devuelve el saldo actual.

    Args:
        saldo (float | int): El saldo disponible en la cuenta.

    Returns:
        float | int: El valor del saldo actual.
        
    Raises:
        TypeError: Si el saldo no es numérico.
    """
    if type(saldo) not in (int, float):
        raise TypeError("El saldo debe ser un valor numerico.")
    return saldo

def depositar(saldo: float | int, monto: float | int) -> float | int:
    """
    Agrega un monto al saldo actual.

    Args:
        saldo (float | int): El saldo actual.
        monto (float | int): El monto a depositar. Debe ser estrictamente positivo.

    Returns:
        float | int: El nuevo saldo tras el depósito.

    Raises:
        TypeError: Si `saldo` o `monto` no son numéricos.
        ValueError: Si `monto` es menor o igual a cero.
    """
    if type(saldo) not in (int, float) or type(monto) not in (int, float):
        raise TypeError("El saldo y el monto deben ser valores numericos.")
    
    if monto <= 0:
        raise ValueError("El monto a depositar debe ser positivo.")
        
    return saldo + monto

def retirar(saldo: float | int, monto: float | int) -> float | int:
    """
    Resta un monto del saldo actual si hay fondos suficientes.

    Args:
        saldo (float | int): El saldo actual.
        monto (float | int): El monto a retirar. Debe ser estrictamente positivo.

    Returns:
        float | int: El nuevo saldo tras el retiro.

    Raises:
        TypeError: Si `saldo` o `monto` no son numéricos.
        ValueError: Si `monto` es menor o igual a cero, o si excede el `saldo` actual.
    """
    if type(saldo) not in (int, float) or type(monto) not in (int, float):
        raise TypeError("El saldo y el monto deben ser valores numericos.")
        
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
            except (ValueError, TypeError) as e:
                print(f"Error: {e}")
        elif opcion == "3":
            try:
                monto = float(input("Monto a retirar: S/."))
                saldo = retirar(saldo, monto)
                print(f"Retiro exitoso. Nuevo saldo: S/.{saldo:.2f}")
            except (ValueError, TypeError) as e:
                print(f"Error: {e}")
        elif opcion == "4":
            print("Hasta luego.")
            break
        else:
            print("Opcion invalida. Seleccione 1-4.")
