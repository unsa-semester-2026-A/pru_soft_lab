#import "/informe/util/util.typ": codeBlock

=== Ejercicio Resuelto 1: Calculadora Simple

*Procedimiento de Solución:*
Se implementó la clase `Calculadora` para realizar operaciones aritméticas básicas. Posteriormente, se desarrolló la clase de pruebas `CalculadoraTest` utilizando JUnit 5. Se definieron casos de prueba para cada operación, comprobando los retornos con `assertEquals` y manejando adecuadamente la división por cero con `assertThrows`. La clase utiliza las anotaciones `@Test` y `@DisplayName` para etiquetar las pruebas.

*Código Fuente (Clase Calculadora):*
#figure(
  codeBlock("/informe/src/lst/er1/src/main/java/com/lab04/Calculadora.java", lang: "java"),
  caption: [Implementación de la lógica de Calculadora]
)

*Comandos de Ejecución:*
```bash
cd informe/src/lst/er1
mvn clean test -Dtest=CalculadoraTest jacoco:report
```

*Evidencia de Ejecución:*
#figure(
  image("/informe/src/img/er1.png", width: 80%),
  caption: [Ejecución de pruebas para Calculadora]
)

#figure(
  image("/informe/src/img/report_r.png", width: 80%),
  caption: [Reporte de cobertura JaCoCo - Ejercicios Resueltos]
)

*Código Fuente (Pruebas):*
#figure(
  codeBlock("/informe/src/lst/er1/src/test/java/com/lab04/CalculadoraTest.java", lang: "java"),
  caption: [Implementación de pruebas unitarias para Calculadora]
)