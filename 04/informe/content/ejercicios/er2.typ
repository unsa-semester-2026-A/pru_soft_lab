#import "/informe/util/util.typ": codeBlock

=== Ejercicio Resuelto 2: Gestor de Cuenta Bancaria

*Procedimiento de Solución:*
Se elaboró un gestor para operaciones bancarias mediante la clase `CuentaBancaria`, con validaciones que previenen depósitos negativos y retiros superiores al saldo. Las pruebas se redactaron en `CuentaBancariaTest`, introduciendo anotaciones de ciclo de vida como `@BeforeEach` para instanciar la cuenta antes de cada prueba. Además, se emplearon *Pruebas Parametrizadas* (`@ParameterizedTest` y `@CsvSource`) para someter la lógica a diferentes flujos de datos en una misma prueba, validando múltiples montos de depósito y retiro eficientemente.

*Código Fuente (Clase CuentaBancaria):*
#figure(
  codeBlock("/informe/src/lst/er1/src/main/java/com/lab04/CuentaBancaria.java", lang: "java"),
  caption: [Implementación de la clase CuentaBancaria y Transacción]
)

*Comandos de Ejecución:*
```bash
cd informe/src/lst/er1
mvn clean test -Dtest=CuentaBancariaTest jacoco:report
```

*Evidencia de Ejecución:*
#figure(
  image("/informe/src/img/er2.png", width: 80%),
  caption: [Ejecución de pruebas para CuentaBancaria]
)

*Código Fuente (Pruebas):*
#figure(
  codeBlock("/informe/src/lst/er1/src/test/java/com/lab04/CuentaBancariaTest.java", lang: "java"),
  caption: [Implementación de pruebas para Cuenta Bancaria]
)