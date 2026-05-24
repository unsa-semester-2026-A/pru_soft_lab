package com.lab04;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.InOrder;
import org.mockito.Mockito;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@DisplayName("Tests para CarritoCompra")
class CarritoCompraTest {

    private ServicioPrecio servicioPrecioMock;
    private CarritoCompra carrito;

    @BeforeEach
    void setUp() {
        servicioPrecioMock = Mockito.mock(ServicioPrecio.class);
        carrito = new CarritoCompra(servicioPrecioMock);
    }

    @Nested
    @DisplayName("Pruebas de agregar producto")
    class PruebasAgregar {

        @Test
        @DisplayName("agregar producto válido al carrito vacío")
        void testAgregarProductoVacio() {
            Producto p = new Producto("P1", "Laptop", 1500.0, true);
            carrito.agregar(p, 1);

            assertEquals(1, carrito.getCantidadItems());
            assertEquals("Laptop", carrito.getItems().get(0).getProducto().getNombre());
        }

        @Test
        @DisplayName("agregar producto indisponible lanza excepción")
        void testAgregarProductoNoDisponible() {
            Producto p = new Producto("P1", "Laptop", 1500.0, false);

            IllegalStateException ex = assertThrows(
                    IllegalStateException.class,
                    () -> carrito.agregar(p, 1));
            assertEquals("El producto no está disponible", ex.getMessage());
        }

        @Test
        @DisplayName("agregar cantidad negativa lanza excepción")
        void testAgregarCantidadNegativa() {
            Producto p = new Producto("P1", "Laptop", 1500.0, true);

            IllegalArgumentException ex = assertThrows(
                    IllegalArgumentException.class,
                    () -> carrito.agregar(p, -1));
            assertEquals("La cantidad debe ser positiva", ex.getMessage());
        }

        @Test
        @DisplayName("agregar cantidad cero lanza excepción")
        void testAgregarCantidadCero() {
            Producto p = new Producto("P1", "Laptop", 1500.0, true);

            IllegalArgumentException ex = assertThrows(
                    IllegalArgumentException.class,
                    () -> carrito.agregar(p, 0));
            assertEquals("La cantidad debe ser positiva", ex.getMessage());
        }

        @Test
        @DisplayName("agregar producto null lanza excepción")
        void testAgregarProductoNull() {
            IllegalArgumentException ex = assertThrows(
                    IllegalArgumentException.class,
                    () -> carrito.agregar(null, 1));
            assertEquals("El producto no puede ser null", ex.getMessage());
        }

        @Test
        @DisplayName("agregar producto duplicado actualiza cantidad")
        void testAgregarProductoDuplicado() {
            Producto p = new Producto("P1", "Laptop", 1500.0, true);
            carrito.agregar(p, 2);
            carrito.agregar(p, 3);

            assertEquals(1, carrito.getCantidadItems());
            assertEquals(5, carrito.getItems().get(0).getCantidad());
        }

        @Test
        @DisplayName("agregar múltiples productos diferentes")
        void testAgregarMultiplesProductos() {
            Producto p1 = new Producto("P1", "Laptop", 1500.0, true);
            Producto p2 = new Producto("P2", "Mouse", 50.0, true);
            carrito.agregar(p1, 1);
            carrito.agregar(p2, 2);

            assertEquals(2, carrito.getCantidadItems());
        }
    }

    @Nested
    @DisplayName("Pruebas de remover producto")
    class PruebasRemover {

        @Test
        @DisplayName("remover producto existente")
        void testRemoverProductoExistente() {
            Producto p = new Producto("P1", "Laptop", 1500.0, true);
            carrito.agregar(p, 1);
            carrito.remover("P1");

            assertEquals(0, carrito.getCantidadItems());
        }

        @Test
        @DisplayName("remover producto que no existe lanza excepción")
        void testRemoverProductoNoExistente() {
            IllegalStateException ex = assertThrows(
                    IllegalStateException.class,
                    () -> carrito.remover("P999"));
            assertEquals("Producto no encontrado en el carrito", ex.getMessage());
        }

        @Test
        @DisplayName("remover con ID vacío lanza excepción")
        void testRemoverIdVacio() {
            IllegalArgumentException ex = assertThrows(
                    IllegalArgumentException.class,
                    () -> carrito.remover(""));
            assertEquals("El ID del producto no puede ser vacío", ex.getMessage());
        }

        @Test
        @DisplayName("remover con ID null lanza excepción")
        void testRemoverIdNull() {
            IllegalArgumentException ex = assertThrows(
                    IllegalArgumentException.class,
                    () -> carrito.remover(null));
            assertEquals("El ID del producto no puede ser vacío", ex.getMessage());
        }
    }

    @Nested
    @DisplayName("Pruebas de vaciar carrito")
    class PruebasVaciar {

        @Test
        @DisplayName("vaciar carrito con productos")
        void testVaciarConProductos() {
            Producto p = new Producto("P1", "Laptop", 1500.0, true);
            Producto p2 = new Producto("P2", "Mouse", 50.0, true);
            carrito.agregar(p, 1);
            carrito.agregar(p2, 1);
            carrito.vaciar();

            assertEquals(0, carrito.getCantidadItems());
        }

        @Test
        @DisplayName("vaciar carrito vacío no causa error")
        void testVaciarCarritoVacio() {
            assertDoesNotThrow(() -> carrito.vaciar());
            assertEquals(0, carrito.getCantidadItems());
        }
    }

    @Nested
    @DisplayName("Pruebas de calcularTotal")
    class PruebasCalcularTotal {

        @Test
        @DisplayName("calcularTotal en carrito vacío retorna 0")
        void testCalcularTotalCarritoVacio() {
            assertEquals(0.0, carrito.calcularTotal(), 0.01);
            verifyNoInteractions(servicioPrecioMock);
        }

        @Test
        @DisplayName("calcularTotal con un producto (validar impuestos y descuentos)")
        void testCalcularTotalUnProducto() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 1);

            // Subtotal: 1000. Descuento (10%): 100. Monto con desc: 900. Impuesto (18% de 900): 162. Total = 1062
            when(servicioPrecioMock.calcularDescuento(1000.0)).thenReturn(100.0);
            when(servicioPrecioMock.calcularImpuesto(900.0)).thenReturn(162.0);

            double total = carrito.calcularTotal();
            assertEquals(1062.0, total, 0.01);
            
            verify(servicioPrecioMock).calcularDescuento(1000.0);
            verify(servicioPrecioMock).calcularImpuesto(900.0);
        }

        @ParameterizedTest
        @CsvSource({
                "100.0, 0.0, 18.0, 118.0",
                "200.0, 0.0, 36.0, 236.0",
                "600.0, 60.0, 97.2, 637.2"
        })
        @DisplayName("calcularTotal con diferentes montos (parametrizada)")
        void testCalcularTotalParametrizado(double precio, double descSimulado, double impSimulado,
                double totalEsperado) {
            Producto p = new Producto("P1", "Producto", precio, true);
            carrito.agregar(p, 1);

            when(servicioPrecioMock.calcularDescuento(precio)).thenReturn(descSimulado);
            when(servicioPrecioMock.calcularImpuesto(precio - descSimulado)).thenReturn(impSimulado);

            double total = carrito.calcularTotal();
            assertEquals(totalEsperado, total, 0.01);
        }
    }

    @Nested
    @DisplayName("Pruebas de obtenerResumenCompra")
    class PruebasResumen {

        @Test
        @DisplayName("obtenerResumenCompra de carrito vacío")
        void testResumenCarritoVacio() {
            String resumen = carrito.obtenerResumenCompra();
            assertEquals("Carrito vacío", resumen);
        }

        @Test
        @DisplayName("obtenerResumenCompra con productos")
        void testResumenConProductos() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 2);

            when(servicioPrecioMock.calcularDescuento(2000.0)).thenReturn(0.0);
            when(servicioPrecioMock.calcularImpuesto(2000.0)).thenReturn(360.0);

            String resumen = carrito.obtenerResumenCompra();
            assertTrue(resumen.contains("Laptop"));
            assertTrue(resumen.contains("2000.0"));
            assertTrue(resumen.contains("Total: S/2360.0"));
        }
    }

    @Nested
    @DisplayName("Pruebas de casos límite")
    class PruebasLimites {

        @Test
        @DisplayName("carrito con 1 producto (caso límite)")
        void testCarritoConUnProducto() {
            Producto p = new Producto("P1", "Producto1", 10.0, true);
            carrito.agregar(p, 1);
            assertEquals(1, carrito.getCantidadItems());
        }

        @Test
        @DisplayName("carrito con 100 productos (caso límite)")
        void testCarritoCon100Productos() {
            for (int i = 1; i <= 100; i++) {
                Producto p = new Producto("P" + i, "Producto" + i, 10.0, true);
                carrito.agregar(p, 1);
            }

            assertEquals(100, carrito.getCantidadItems());
        }

        @Test
        @DisplayName("historial registra operaciones")
        void testHistorialRegistraOperaciones() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 1);
            carrito.remover("P1");

            List<String> historial = carrito.getHistorial();
            assertTrue(historial.contains("Agregar: Laptop (x1)"));
            assertTrue(historial.contains("Remover: Laptop"));
        }
    }

    @Nested
    @DisplayName("Pruebas de interacción con ServicioPrecio (Mockito)")
    class PruebasServicioPrecio {

        @Test
        @DisplayName("verificar que se llama calcularDescuento y calcularImpuesto")
        void testVerificarLlamadasServicio() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 1);

            carrito.calcularTotal();

            verify(servicioPrecioMock, times(1)).calcularDescuento(1000.0);
            verify(servicioPrecioMock, atLeastOnce()).calcularImpuesto(anyDouble());
        }

        @Test
        @DisplayName("verificar orden de llamadas (InOrder)")
        void testOrdenLlamadas() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 1);

            when(servicioPrecioMock.calcularDescuento(1000.0)).thenReturn(0.0);

            carrito.calcularTotal();

            InOrder inOrder = inOrder(servicioPrecioMock);
            inOrder.verify(servicioPrecioMock).calcularDescuento(1000.0);
            inOrder.verify(servicioPrecioMock).calcularImpuesto(1000.0);
        }
    }

    @Nested
    @DisplayName("Pruebas adicionales de lógica y cobertura")
    class PruebasAdicionales {

        @Test
        @DisplayName("actualizar cantidad de producto existente (cobertura)")
        void testActualizarCantidad() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 1);
            carrito.agregar(p, 2);

            assertEquals(1, carrito.getCantidadItems());
            assertEquals(3, carrito.getItems().get(0).getCantidad());
            assertTrue(carrito.getHistorial().contains("Actualizar cantidad: Laptop +2"));
        }

        @Test
        @DisplayName("obtenerItems devuelve copia de la lista (encapsulamiento)")
        void testGetItemsEsCopia() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            carrito.agregar(p, 1);
            
            List<ItemCarrito> items = carrito.getItems();
            assertThrows(UnsupportedOperationException.class, () -> items.add(null)); // Si la lista es inmutable o si intentamos modificarla no debería afectar al carrito
            
            // Si no es inmutable pero es copia, borrar de la lista externa no afecta al carrito
            try {
                items.clear();
            } catch (Exception ignored) {}
            
            assertEquals(1, carrito.getCantidadItems());
        }

        @Test
        @DisplayName("set cantidad en ItemCarrito lanza excepción si es <= 0")
        void testItemCarritoSetCantidadInvalida() {
            Producto p = new Producto("P1", "Laptop", 1000.0, true);
            ItemCarrito item = new ItemCarrito(p, 1);
            assertThrows(IllegalArgumentException.class, () -> item.setCantidad(0));
            assertThrows(IllegalArgumentException.class, () -> item.setCantidad(-5));
        }
    }
}