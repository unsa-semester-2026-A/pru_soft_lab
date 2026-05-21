package com.lab04;

import java.util.List;
import java.util.Scanner;

public class Main {
    private static CarritoCompra carrito;
    private static Scanner scanner;

    public static void main(String[] args) {
        scanner = new Scanner(System.in);
        
        // Implementacion del servicio de precios
        ServicioPrecio servicioPrecio = new ServicioPrecio() {
            @Override
            public double calcularDescuento(double monto) {
                if (monto >= 1000) {
                    return monto * 0.10; // 10% descuento para compras >= 1000
                } else if (monto >= 500) {
                    return monto * 0.05; // 5% descuento para compras >= 500
                }
                return 0;
            }
            
            @Override
            public double calcularImpuesto(double monto) {
                return monto * 0.18; // 18% IGV
            }
        };
        
        carrito = new CarritoCompra(servicioPrecio);
        
        // Catalogo de productos predefinidos
        Producto[] catalogo = {
            new Producto("P001", "Laptop Gamer", 3500.0, true),
            new Producto("P002", "Mouse RGB", 85.0, true),
            new Producto("P003", "Teclado Mecanico", 250.0, true),
            new Producto("P004", "Monitor 24\"", 850.0, true),
            new Producto("P005", "Audifonos Bluetooth", 180.0, true),
            new Producto("P006", "Disco SSD 1TB", 380.0, true),
            new Producto("P007", "Memoria USB 64GB", 45.0, true),
            new Producto("P008", "Camara Web HD", 120.0, true),
            new Producto("P009", "Silla Gamer", 1200.0, true),
            new Producto("P010", "Pad Mouse XXL", 65.0, true)
        };
        
        int opcion;
        do {
            mostrarMenuPrincipal();
            opcion = leerInt("Seleccione una opcion: ");
            
            switch (opcion) {
                case 1:
                    verCatalogo(catalogo);
                    break;
                case 2:
                    agregarProducto(catalogo);
                    break;
                case 3:
                    verCarrito();
                    break;
                case 4:
                    removerProducto();
                    break;
                case 5:
                    vaciarCarrito();
                    break;
                case 6:
                    verHistorial();
                    break;
                case 7:
                    finalizarCompra();
                    break;
                case 0:
                    System.out.println("\nGracias por usar el sistema de compras!");
                    break;
                default:
                    System.out.println("Opcion no valida. Intente nuevamente.");
            }
        } while (opcion != 0);
        
        scanner.close();
    }
    
    private static void mostrarMenuPrincipal() {
        System.out.println("\n" + "=".repeat(50));
        System.out.println("         CARRITO DE COMPRAS");
        System.out.println("=".repeat(50));
        System.out.println("1. Ver catalogo de productos");
        System.out.println("2. Agregar producto al carrito");
        System.out.println("3. Ver carrito actual");
        System.out.println("4. Remover producto del carrito");
        System.out.println("5. Vaciar carrito");
        System.out.println("6. Ver historial de operaciones");
        System.out.println("7. Finalizar compra (ver total)");
        System.out.println("0. Salir");
        System.out.println("-".repeat(50));
    }
    
    private static void verCatalogo(Producto[] catalogo) {
        System.out.println("\n" + "=".repeat(60));
        System.out.println("           CATALOGO DE PRODUCTOS");
        System.out.println("=".repeat(60));
        System.out.printf("%-8s %-25s %-10s %-12s%n", "ID", "Producto", "Precio", "Disponible");
        System.out.println("-".repeat(60));
        
        for (Producto p : catalogo) {
            System.out.printf("%-8s %-25s S/%-9.2f %-12s%n", 
                p.getId(), 
                p.getNombre(), 
                p.getPrecio(),
                p.isDisponible() ? "Si" : "No");
        }
        System.out.println("=".repeat(60));
        
        System.out.println("\n[Cantidad de productos en carrito: " + carrito.getCantidadItems() + "]");
        System.out.println("[Items totales en carrito: " + carrito.getItems().stream().mapToInt(ItemCarrito::getCantidad).sum() + "]");
    }
    
    private static void agregarProducto(Producto[] catalogo) {
        System.out.println("\n--- AGREGAR PRODUCTO AL CARRITO ---");
        System.out.print("Ingrese el ID del producto: ");
        String id = scanner.nextLine().trim();
        
        // Buscar producto en catalogo
        Producto productoSeleccionado = null;
        for (Producto p : catalogo) {
            if (p.getId().equalsIgnoreCase(id)) {
                productoSeleccionado = p;
                break;
            }
        }
        
        if (productoSeleccionado == null) {
            System.out.println("ERROR: Producto no encontrado en el catalogo.");
            return;
        }
        
        if (!productoSeleccionado.isDisponible()) {
            System.out.println("ERROR: El producto no esta disponible.");
            return;
        }
        
        System.out.print("Ingrese la cantidad: ");
        int cantidad = leerInt("");
        
        if (cantidad <= 0) {
            System.out.println("ERROR: La cantidad debe ser positiva.");
            return;
        }
        
        try {
            carrito.agregar(productoSeleccionado, cantidad);
            System.out.println(productoSeleccionado.getNombre() + " (x" + cantidad + ") agregado al carrito.");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
        }
    }
    
    private static void verCarrito() {
        System.out.println("\n" + carrito.obtenerResumenCompra());
        
        if (carrito.getCantidadItems() > 0) {
            System.out.println("-".repeat(40));
            System.out.printf("Descuento aplicado: S/%.2f%n", 
                carrito.calcularSubtotal() * 0.10);
            System.out.printf("IGV (18%%): S/%.2f%n", 
                carrito.calcularTotal() - carrito.calcularSubtotal());
        }
    }
    
    private static void removerProducto() {
        if (carrito.getCantidadItems() == 0) {
            System.out.println("ERROR: El carrito esta vacio. No hay productos para remover.");
            return;
        }
        
        System.out.println("\n--- REMOVER PRODUCTO DEL CARRITO ---");
        verCarrito();
        
        System.out.print("\nIngrese el ID del producto a remover: ");
        String id = scanner.nextLine().trim();
        
        try {
            carrito.remover(id);
            System.out.println("Producto removido del carrito.");
        } catch (IllegalArgumentException e) {
            System.out.println("ERROR: " + e.getMessage());
        } catch (IllegalStateException e) {
            System.out.println("ERROR: " + e.getMessage());
        }
    }
    
    private static void vaciarCarrito() {
        if (carrito.getCantidadItems() == 0) {
            System.out.println("El carrito ya esta vacio.");
            return;
        }
        
        System.out.print("\nEsta seguro de vaciar el carrito? (S/N): ");
        String confirmacion = scanner.nextLine().trim().toUpperCase();
        
        if (confirmacion.equals("S")) {
            carrito.vaciar();
            System.out.println("El carrito ha sido vaciado.");
        } else {
            System.out.println("Operacion cancelada.");
        }
    }
    
    private static void verHistorial() {
        System.out.println("\n" + "=".repeat(60));
        System.out.println("           HISTORIAL DE OPERACIONES");
        System.out.println("=".repeat(60));
        
        List<String> historial = carrito.getHistorial();
        if (historial.isEmpty()) {
            System.out.println("No hay operaciones registradas aun.");
        } else {
            int contador = 1;
            for (String operacion : historial) {
                System.out.printf("%2d. %s%n", contador++, operacion);
            }
        }
        System.out.println("=".repeat(60));
    }
    
    private static void finalizarCompra() {
        System.out.println("\n" + "=".repeat(60));
        System.out.println("              FINALIZAR COMPRA");
        System.out.println("=".repeat(60));
        
        if (carrito.getCantidadItems() == 0) {
            System.out.println("ATENCION: El carrito esta vacio. Agregue productos antes de finalizar la compra.");
            return;
        }
        
        System.out.println(carrito.obtenerResumenCompra());
        
        System.out.println("\n" + "-".repeat(40));
        System.out.printf("Subtotal: S/%.2f%n", carrito.calcularSubtotal());
        System.out.printf("Total a pagar: S/%.2f%n", carrito.calcularTotal());
        System.out.println("=".repeat(60));
        
        System.out.print("\nConfirmar compra? (S/N): ");
        String confirmacion = scanner.nextLine().trim().toUpperCase();
        
        if (confirmacion.equals("S")) {
            System.out.println("\nCOMPRA REALIZADA CON EXITO!");
            System.out.println("Gracias por su preferencia.");
            carrito.vaciar();
        } else {
            System.out.println("Compra cancelada. Puede seguir agregando productos.");
        }
    }
    
    private static int leerInt(String mensaje) {
        System.out.print(mensaje);
        while (!scanner.hasNextInt()) {
            System.out.print("Por favor, ingrese un numero valido: ");
            scanner.next();
        }
        int numero = scanner.nextInt();
        scanner.nextLine(); // Limpiar buffer
        return numero;
    }
}