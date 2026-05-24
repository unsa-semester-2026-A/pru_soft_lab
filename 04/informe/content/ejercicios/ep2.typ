#import "/informe/util/util.typ": codeBlock

=== Ejercicio Propuesto 2: Carrito de Compras

*Procedimiento de Solución:*
Este ejercicio integró un sistema mediante las clases `CarritoCompra`, `ItemCarrito` y `Producto`. Para probar de forma aislada la lógica del carrito, se incorporó la librería *Mockito*. Se creó un Mock (simulacro) de la dependencia `ServicioPrecio` para controlar artificialmente los impuestos y descuentos en las aserciones de los totales.
La suite de pruebas (`CarritoCompraTest`) incluye más de 30 casos de prueba, verificando excepciones, cálculos y límites lógicos. Se aseguró una correcta integración aislando el componente a probar y validando interacciones con `verify()`. El cumplimiento integral se validó mediante un análisis de cobertura (> 85% total, 100% en lógica de negocio) con Maven y JaCoCo.

*Código Fuente (Clase CarritoCompra):*
#figure(
  codeBlock("/informe/src/lst/ep2/src/main/java/com/lab04/CarritoCompra.java", lang: "java"),
  caption: [Lógica principal del Carrito de Compras y gestión de items]
)

*Código Fuente (Clase ItemCarrito):*
#figure(
  codeBlock("/informe/src/lst/ep2/src/main/java/com/lab04/ItemCarrito.java", lang: "java"),
  caption: [Representación de un item dentro del carrito]
)

*Código Fuente (Interfaz ServicioPrecio):*
#figure(
  codeBlock("/informe/src/lst/ep2/src/main/java/com/lab04/ServicioPrecio.java", lang: "java"),
  caption: [Interfaz para el cálculo de descuentos e impuestos]
)

*Comandos de Ejecución (Pruebas):*
```bash
mvn clean test jacoco:report
```

*Evidencia de Ejecución (Pruebas):*
#figure(
  image("/informe/src/img/ep2.png", width: 80%),
  caption: [Ejecución de pruebas para Carrito de Compras]
)


*Reporte de Cobertura JaCoCo:*
#figure(
  image("/informe/src/img/report_ep2.png", width: 80%),
  caption: [Reporte de cobertura de la lógica de negocio (EP2)]
)

*Comandos de Ejecución:*
```bash
mvn exec:java
```

*Evidencia de Ejecución GUI:*
#figure(
  image("/informe/src/img/ep2_exe_gui.png", width: 80%),
  caption: [Ejecución del Carrito de Compras (GUI)]
)

*Código Fuente (Pruebas):*
#figure(
  codeBlock("/informe/src/lst/ep2/src/test/java/com/lab04/CarritoCompraTest.java", lang: "java"),
  caption: [Implementación de pruebas con Mocks para Carrito de Compras]
)
