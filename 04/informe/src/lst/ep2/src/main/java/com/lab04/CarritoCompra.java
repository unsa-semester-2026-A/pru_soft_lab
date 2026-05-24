package com.lab04;

import java.util.ArrayList;
import java.util.List;

public class CarritoCompra {
    private final List<ItemCarrito> items;
    private final List<String> historial;
    private final ServicioPrecio servicioPrecio;

    public CarritoCompra(ServicioPrecio servicioPrecio) {
        this.items = new ArrayList<>();
        this.historial = new ArrayList<>();
        this.servicioPrecio = servicioPrecio;
    }

    public void agregar(Producto producto, int cantidad) {
        if (producto == null) {
            throw new IllegalArgumentException("El producto no puede ser null");
        }
        if (!producto.isDisponible()) {
            throw new IllegalStateException("El producto no está disponible");
        }
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad debe ser positiva");
        }

        for (ItemCarrito item : items) {
            if (item.getProducto().getId().equals(producto.getId())) {
                item.setCantidad(item.getCantidad() + cantidad);
                historial.add("Actualizar cantidad: " + producto.getNombre() + " +" + cantidad);
                return;
            }
        }

        items.add(new ItemCarrito(producto, cantidad));
        historial.add("Agregar: " + producto.getNombre() + " (x" + cantidad + ")");
    }

    public void remover(String productoId) {
        if (productoId == null || productoId.isBlank()) {
            throw new IllegalArgumentException("El ID del producto no puede ser vacío");
        }

        ItemCarrito itemRemover = null;
        for (ItemCarrito item : items) {
            if (item.getProducto().getId().equals(productoId)) {
                itemRemover = item;
                break;
            }
        }

        if (itemRemover == null) {
            throw new IllegalStateException("Producto no encontrado en el carrito");
        }

        items.remove(itemRemover);
        historial.add("Remover: " + itemRemover.getProducto().getNombre());
    }

    public void vaciar() {
        items.clear();
        historial.add("Vaciar carrito");
    }

    public double calcularSubtotal() {
        double subtotal = 0;
        for (ItemCarrito item : items) {
            subtotal += item.getSubtotal();
        }
        return subtotal;
    }

    public double calcularTotal() {
        double subtotal = calcularSubtotal();
        if (subtotal == 0) {
            return 0;
        }

        double descuento = servicioPrecio.calcularDescuento(subtotal);
        double conDescuento = subtotal - descuento;
        double impuesto = servicioPrecio.calcularImpuesto(conDescuento);

        historial.add("CalcularTotal: subtotal=" + subtotal + ", descuento=" + descuento + ", impuesto=" + impuesto);
        return conDescuento + impuesto;
    }

    public String obtenerResumenCompra() {
        if (items.isEmpty()) {
            return "Carrito vacío";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("=== Resumen de Compra ===\n");
        for (ItemCarrito item : items) {
            sb.append("- ")
                    .append(item.getProducto().getNombre())
                    .append(": ")
                    .append(item.getCantidad())
                    .append(" x S/")
                    .append(item.getProducto().getPrecio())
                    .append(" = S/")
                    .append(item.getSubtotal())
                    .append("\n");
        }
        sb.append("Subtotal: S/").append(calcularSubtotal()).append("\n");
        sb.append("Total: S/").append(calcularTotal()).append("\n");
        return sb.toString();
    }

    public List<ItemCarrito> getItems() {
        return java.util.Collections.unmodifiableList(items);
    }

    public List<String> getHistorial() {
        return new ArrayList<>(historial);
    }

    public int getCantidadItems() {
        return items.size();
    }
}