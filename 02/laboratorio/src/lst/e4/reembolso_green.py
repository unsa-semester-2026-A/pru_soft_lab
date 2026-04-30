def calcular_reembolso(monto_reserva, horas_antes, es_vip):
    tasa_reembolso = 0.0
    if horas_antes > 72:
        tasa_reembolso = 1.0    
    return monto_reserva*tasa_reembolso 