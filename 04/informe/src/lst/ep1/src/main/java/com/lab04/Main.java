package com.lab04;

public class Main {
    public static void main(String[] args) {

        System.out.println("=== Sistema de Inventario ===\n");

        // Crear un producto
        Producto p = new Producto("P001", "Teclado Mecánico", 250.0, 10);
        System.out.println("Producto creado: " + p.getNombre());
        System.out.println("Precio: S/ " + p.getPrecio());
        System.out.println("Stock inicial: " + p.consultarStock());

        // Agregar stock
        p.agregarStock(5);
        System.out.println("\n[+] Se agregaron 5 unidades");
        System.out.println("Stock actual: " + p.consultarStock());

        // Extraer stock
        p.extraerStock(3);
        System.out.println("\n[-] Se extrajeron 3 unidades");
        System.out.println("Stock actual: " + p.consultarStock());

        // Ver valor total
        System.out.println("\nValor total en inventario: S/ " + p.obtenerValorTotal());

        // Ver historial de movimientos
        System.out.println("\n--- Historial de movimientos ---");
        for (Movimiento m : p.getMovimientos()) {
            System.out.println(m.getTipo() + " | Cantidad: " + m.getCantidad());
        }
    }
}
