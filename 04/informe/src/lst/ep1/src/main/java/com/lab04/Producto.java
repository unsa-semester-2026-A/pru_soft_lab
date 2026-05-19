package com.lab04;

import java.util.ArrayList;
import java.util.List;

public class Producto {
    private final String codigo;
    private final String nombre;
    private double precio;
    private int cantidad;
    private final List<Movimiento> movimientos;

    public Producto(String codigo, String nombre, double precio, int cantidad) {
        if (codigo == null || codigo.isBlank()) {
            throw new IllegalArgumentException("El código no puede ser vacío");
        }
        if (precio <= 0) {
            throw new IllegalArgumentException("El precio debe ser positivo");
        }
        if (cantidad < 0) {
            throw new IllegalArgumentException("La cantidad no puede ser negativa");
        }
        this.codigo = codigo;
        this.nombre = nombre;
        this.precio = precio;
        this.cantidad = cantidad;
        this.movimientos = new ArrayList<>();
    }

    public String getCodigo() {
        return codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        if (precio <= 0) {
            throw new IllegalArgumentException("El precio debe ser positivo");
        }
        this.precio = precio;
    }

    public int getCantidad() {
        return cantidad;
    }

    public List<Movimiento> getMovimientos() {
        return new ArrayList<>(movimientos);
    }

    public void agregarStock(int cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad a agregar debe ser positiva");
        }
        this.cantidad += cantidad;
        this.movimientos.add(new Movimiento(Movimiento.Tipo.ENTRADA, cantidad));
    }

    public void extraerStock(int cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad a extraer debe ser positiva");
        }
        if (cantidad > this.cantidad) {
            throw new IllegalStateException("Stock insuficiente");
        }
        this.cantidad -= cantidad;
        this.movimientos.add(new Movimiento(Movimiento.Tipo.SALIDA, cantidad));
    }

    public int consultarStock() {
        return cantidad;
    }

    public double obtenerValorTotal() {
        return precio * cantidad;
    }
}