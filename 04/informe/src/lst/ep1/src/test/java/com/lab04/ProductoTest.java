package com.lab04;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Tests para Producto y Gestión de Movimientos")
class ProductoTest {

    @Nested
    @DisplayName("Pruebas de Constructor y Validaciones Iniciales")
    class PruebasConstructor {

        @Test
        @DisplayName("Crear producto con datos válidos")
        void testCrearProductoExitosamente() {
            Producto producto = new Producto("P001", "Teclado Mecánico", 250.0, 10);

            assertEquals("P001", producto.getCodigo());
            assertEquals("Teclado Mecánico", producto.getNombre());
            assertEquals(250.0, producto.getPrecio());
            assertEquals(10, producto.getCantidad());
            assertTrue(producto.getMovimientos().isEmpty(), "Al crearse, no debería tener movimientos de stock");
        }

        @ParameterizedTest
        @ValueSource(strings = { "", "   " })
        @DisplayName("Código vacío o con espacios lanza IllegalArgumentException")
        void testCodigoInvalido(String codigoInvalido) {
            assertThrows(IllegalArgumentException.class,
                    () -> new Producto(codigoInvalido, "Mouse", 45.0, 5));
        }

        @Test
        @DisplayName("Código null lanza IllegalArgumentException")
        void testCodigoNull() {
            assertThrows(IllegalArgumentException.class,
                    () -> new Producto(null, "Mouse", 45.0, 5));
        }

        @ParameterizedTest
        @ValueSource(doubles = { 0.0, -1.0, -100.5 })
        @DisplayName("Precio menor o igual a cero lanza IllegalArgumentException")
        void testPrecioInvalidoInicial(double precioInvalido) {
            assertThrows(IllegalArgumentException.class,
                    () -> new Producto("P002", "Mouse", precioInvalido, 5));
        }

        @Test
        @DisplayName("Cantidad inicial negativa lanza IllegalArgumentException")
        void testCantidadInicialNegativa() {
            assertThrows(IllegalArgumentException.class,
                    () -> new Producto("P002", "Mouse", 50.0, -1));
        }
    }

    @Nested
    @DisplayName("Pruebas de Modificación de Atributos (Setters)")
    class PruebasSetters {

        @Test
        @DisplayName("Modificar precio con valor válido")
        void testSetPrecioValido() {
            Producto producto = new Producto("P001", "Laptop", 1500.0, 5);
            producto.setPrecio(1350.0);
            assertEquals(1350.0, producto.getPrecio());
        }

        @ParameterizedTest
        @ValueSource(doubles = { 0.0, -50.0 })
        @DisplayName("Modificar precio a valores no positivos lanza IllegalArgumentException")
        void testSetPrecioInvalido(double precioInvalido) {
            Producto producto = new Producto("P001", "Laptop", 1500.0, 5);
            assertThrows(IllegalArgumentException.class, () -> producto.setPrecio(precioInvalido));
        }
    }

    @Nested
    @DisplayName("Pruebas de Operaciones de Stock (Entradas y Salidas)")
    class PruebasOperacionesStock {

        @Test
        @DisplayName("Agregar stock incrementa la cantidad y registra movimiento ENTRADA")
        void testAgregarStockExitoso() {
            Producto producto = new Producto("P001", "Monitor", 600.0, 5);
            producto.agregarStock(10);

            assertEquals(15, producto.consultarStock());

            List<Movimiento> movimientos = producto.getMovimientos();
            assertEquals(1, movimientos.size());
            assertEquals(Movimiento.Tipo.ENTRADA, movimientos.get(0).getTipo());
            assertEquals(10, movimientos.get(0).getCantidad());
            assertNotNull(movimientos.get(0).getFecha());
        }

        @ParameterizedTest
        @ValueSource(ints = { 0, -5 })
        @DisplayName("Agregar cantidad inválida de stock lanza IllegalArgumentException")
        void testAgregarStockInvalido(int cantidadInvalida) {
            Producto producto = new Producto("P001", "Monitor", 600.0, 5);
            assertThrows(IllegalArgumentException.class, () -> producto.agregarStock(cantidadInvalida));
        }

        @Test
        @DisplayName("Extraer stock reduce la cantidad y registra movimiento SALIDA")
        void testExtraerStockExitoso() {
            Producto producto = new Producto("P001", "Monitor", 600.0, 15);
            producto.extraerStock(5);

            assertEquals(10, producto.consultarStock());

            List<Movimiento> movimientos = producto.getMovimientos();
            assertEquals(1, movimientos.size());
            assertEquals(Movimiento.Tipo.SALIDA, movimientos.get(0).getTipo());
            assertEquals(5, movimientos.get(0).getCantidad());
        }

        @ParameterizedTest
        @ValueSource(ints = { 0, -10 })
        @DisplayName("Extraer cantidad inválida de stock lanza IllegalArgumentException")
        void testExtraerStockInvalido(int cantidadInvalida) {
            Producto producto = new Producto("P001", "Monitor", 600.0, 15);
            assertThrows(IllegalArgumentException.class, () -> producto.extraerStock(cantidadInvalida));
        }

        @Test
        @DisplayName("Extraer más stock del disponible lanza IllegalStateException")
        void testExtraerStockInsuficiente() {
            Producto producto = new Producto("P001", "Monitor", 600.0, 5);

            IllegalStateException ex = assertThrows(IllegalStateException.class,
                    () -> producto.extraerStock(6));
            assertEquals("Stock insuficiente", ex.getMessage());
        }
    }

    @Nested
    @DisplayName("Pruebas Financieras y de Totales")
    class PruebasFinancieras {

        @Test
        @DisplayName("Obtener valor total en inventario cuando hay stock")
        void testObtenerValorTotalConStock() {
            Producto producto = new Producto("P001", "Audífonos", 120.0, 4); // 120 * 4 = 480
            assertEquals(480.0, producto.obtenerValorTotal(), 0.001);
        }

        @Test
        @DisplayName("Obtener valor total en inventario con stock en cero es 0")
        void testObtenerValorTotalSinStock() {
            Producto producto = new Producto("P001", "Audífonos", 120.0, 0);
            assertEquals(0.0, producto.obtenerValorTotal(), 0.001);
        }

        @ParameterizedTest
        @CsvSource({
                "10.0,  5,  50.0",
                "100.5, 2,  201.0",
                "0.5,   10, 5.0"
        })
        @DisplayName("Cálculo parametrizado del valor total del inventario")
        void testObtenerValorTotalParametrizado(double precio, int cantidad, double valorEsperado) {
            Producto producto = new Producto("PX", "Generico", precio, cantidad);
            assertEquals(valorEsperado, producto.obtenerValorTotal(), 0.001);
        }
    }

    @Nested
    @DisplayName("Pruebas de Historial y Casos Límite")
    class PruebasHistorialYLimites {

        @Test
        @DisplayName("El historial conserva el orden cronológico y tipo de múltiples transacciones")
        void testHistorialMultiplesMovimientos() {
            Producto producto = new Producto("P001", "Impresora", 400.0, 10);

            producto.agregarStock(5);
            producto.extraerStock(3);
            producto.agregarStock(2);

            List<Movimiento> historial = producto.getMovimientos();

            assertEquals(3, historial.size());
            assertEquals(14, producto.consultarStock());

            // Verificar orden exacto
            assertEquals(Movimiento.Tipo.ENTRADA, historial.get(0).getTipo());
            assertEquals(5, historial.get(0).getCantidad());

            assertEquals(Movimiento.Tipo.SALIDA, historial.get(1).getTipo());
            assertEquals(3, historial.get(1).getCantidad());

            assertEquals(Movimiento.Tipo.ENTRADA, historial.get(2).getTipo());
            assertEquals(2, historial.get(2).getCantidad());
        }

        @Test
        @DisplayName("Garantizar inmutabilidad de la lista devuelta por getMovimientos")
        void testInmutabilidadHistorial() {
            Producto producto = new Producto("P001", "Impresora", 400.0, 10);
            producto.agregarStock(5);

            List<Movimiento> listaModificable = producto.getMovimientos();

            // Intentar alterar la lista externamente no debería afectar al encapsulamiento
            // del producto
            assertDoesNotThrow(() -> listaModificable.clear(),
                    "Modificar la lista externa no debería romper el programa");

            // Pero lo importante es comprobar que la lista nativa interna sigue teniendo su
            // elemento original
            assertEquals(1, producto.getMovimientos().size(),
                    "La lista interna del producto debe permanecer intacta ante manipulaciones externas");
        }

        @Test
        @DisplayName("Caso límite: Extraer exactamente la totalidad del stock disponible")
        void testCasoLimiteExtraerTodoElStock() {
            Producto producto = new Producto("P001", "Silla Gamer", 350.0, 8);

            assertDoesNotThrow(() -> producto.extraerStock(8));
            assertEquals(0, producto.consultarStock());
        }
    }
}