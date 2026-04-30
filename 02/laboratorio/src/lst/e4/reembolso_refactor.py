def calcular_reembolso(monto_reserva, horas_antes, es_vip=False):
    # 1. FASE DE ROBUSTEZ: Validación de tipos y valores
    try:
        # Intentamos convertir a los tipos necesarios
        monto = float(monto_reserva)
        
        if isinstance(horas_antes, float):
            raise ValueError("Horas no pueden ser decimales")
            
        horas = int(horas_antes)
    except (ValueError, TypeError):
        raise ValueError("Error: Entrada inválida (no numérica o nula)")
        
        
    # Validación de valores negativos
    if monto < 0 or horas < 0:
        raise ValueError("Error: No se permiten valores negativos")

    # 2. FASE DE LÓGICA DE NEGOCIO
    tasa_reembolso = 0.0

    if horas > 72:
        tasa_reembolso = 1.0
    elif 24 <= horas <= 72:
        tasa_reembolso = 0.5
    else:
        tasa_reembolso = 0.0

    # 3. REGLA VIP
    if es_vip and tasa_reembolso < 0.5:
        tasa_reembolso = 0.5
    
    # 4. Cálculo final
    return monto * tasa_reembolso