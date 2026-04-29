def evaluar_rendimiento(nota):

    if not isinstance(nota, int):
        raise TypeError("La nota debe ser un numero entero")

    if nota < 0 or nota > 20:
        raise ValueError("La nota debe estar entre 0 y 20")

    if 0 <= nota <= 10:
        return "Insuficiente"

    if 11 <= nota <= 15:
        return "Regular"

    return "Excelente"