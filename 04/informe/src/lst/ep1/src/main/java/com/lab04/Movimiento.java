package com.lab04;

import java.time.LocalDateTime;

public class Movimiento {
    public enum Tipo { ENTRADA, SALIDA }

    private final Tipo tipo;
    private final int cantidad;
    private final LocalDateTime fecha;

    public Movimiento(Tipo tipo, int cantidad) {
        this.tipo = tipo;
        this.cantidad = cantidad;
        this.fecha = LocalDateTime.now();
    }

    public Tipo getTipo() {
        return tipo;
    }

    public int getCantidad() {
        return cantidad;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }
}