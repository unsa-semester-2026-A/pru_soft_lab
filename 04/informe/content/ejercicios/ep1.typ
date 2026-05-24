#import "/informe/util/util.typ": codeBlock

=== Ejercicio Propuesto 1: Gestor de Inventario

*Procedimiento de Solución:*
Se implementó un sistema robusto para la gestión de stock. La clase `Producto` integra validaciones en sus operaciones (precios positivos, stock no negativo, códigos válidos) y registra la fecha de cada cambio en el inventario mediante la clase `Movimiento`. 
Para verificar el comportamiento, se desarrolló `ProductoTest` utilizando JUnit 5. Se agruparon casos de prueba lógicamente con `@Nested` y se utilizaron pruebas parametrizadas para validar las restricciones de entrada de manera escalable. Al realizar el análisis dinámico, se logró una *cobertura de código del 100%* evaluada a través de *JaCoCo*.

*Código Fuente (Clase Producto):*
#figure(
  codeBlock("/informe/src/lst/ep1/src/main/java/com/lab04/Producto.java", lang: "java"),
  caption: [Implementación de la clase Producto con validaciones y gestión de stock]
)

*Código Fuente (Clase Movimiento):*
#figure(
  codeBlock("/informe/src/lst/ep1/src/main/java/com/lab04/Movimiento.java", lang: "java"),
  caption: [Clase para el registro histórico de movimientos de inventario]
)

*Comandos de Ejecución:*
```bash
cd informe/src/lst/ep1
mvn clean test jacoco:report
```

*Evidencia de Ejecución (Tests):*
#figure(
  image("/informe/src/img/ep1.png", width: 80%),
  caption: [Ejecución de pruebas del Gestor de Inventario]
)

*Evidencia de Ejecución (Ejecución):*

Para ejecutar el comando se tiene que realizar el siguiente comando: `mvn exec:java`.

#figure(
  image("/informe/src/img/ep1_exe.png", width: 80%),
  caption: [Ejecución del Gestor de Inventario]
)

*Reporte de Cobertura JaCoCo:*
#figure(
  image("/informe/src/img/report_ep1.png", width: 80%),
  caption: [Reporte de cobertura del 100% en la lógica de negocio (EP1)]
)

*Código Fuente (Pruebas):*
#figure(
  codeBlock("/informe/src/lst/ep1/src/test/java/com/lab04/ProductoTest.java", lang: "java"),
  caption: [Suite de pruebas para Producto e Inventario]
)
