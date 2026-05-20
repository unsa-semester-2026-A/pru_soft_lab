# GUÍA DE LABORATORIO
**(Formato docente)**

## INFORMACIÓN BÁSICA

* **Asignatura:** Pruebas de Software
* **Título de la Práctica:** Pruebas Unitarias con JUnit
* **Número de Práctica:** 04
* **Año Lectivo:** 2026
* **Semestre:** VII
* **Tipo de Práctica:** Grupal (X)
* **Fecha de Inicio:** 11/05/2026
* **Fecha de Fin:** 15/05/2026
* **Duración:** 100 min
* **Máximo de Estudiantes:** 4
* **Docentes:** Prof. Robert Arisaca / Prof. Diego Iquira / Prof. Lino Pinto

### Recursos a Utilizar
* Una computadora personal
* Lenguaje de programación Java
* Visual Studio Code + extensión Java
* Framework de pruebas unitarias JUnit 5.0
* Maven 3.9 / JaCoCo 0.8 para análisis de cobertura de código

---

## OBJETIVOS, TEMAS Y COMPETENCIAS

### Objetivos
* El estudiante comprenderá la importancia de diseñar pruebas unitarias de componentes de software basados en Java.
* El estudiante ejecutará pruebas unitarias basadas en el framework JUnit 5.0 y realizará un análisis de cobertura con JaCoCo.

### Temas
* Pruebas Unitarias: definición y propósito
* Historia y evolución de JUnit
* Apache Maven y gestión de dependencias
* Anotaciones y ciclos de vida en JUnit 5
* Pruebas parametrizadas / Métricas de cobertura (JaCoCo)

### Competencias
* **C.m:** Construye responsablemente soluciones siguiendo un proceso adecuado llevando a cabo las pruebas ajustadas a los recursos disponibles del cliente.

---

## CONTENIDO DE LA GUÍA

## I. MARCO CONCEPTUAL

### 1.1 Historia y Evolución de JUnit
JUnit fue creado en 1997 por Kent Beck y Erich Gamma, motivado por la necesidad de automatizar pruebas en Java. Beck fue influenciado por el trabajo de Smalltalk en SUnit, adaptando el concepto al lenguaje Java. Esta herramienta revolucionó la industria del software al facilitar la implementación de *Test-Driven Development* (TDD).

#### Evolución de JUnit:
* **JUnit 1.x (1997-2000):** Primera versión, basada en herencia y el patrón xUnit.
* **JUnit 3.x (2000-2006):** Popularización, uso de herencia de `TestCase` y métodos `setUp`/`tearDown`.
* **JUnit 4.x (2006-2017):** Introducción de anotaciones (`@Test`, `@Before`, `@After`) y mayor flexibilidad.
* **JUnit 5.0 (2017-2022):** Arquitectura modular, soporte para lambdas, extensiones y JUnit Platform.
* **JUnit 5.10+ (2023-presente):** Mejoras en parametrización y mejor integración con herramientas modernas.

### 1.2 Arquitectura de JUnit 5
JUnit 5 fue rediseñado con una arquitectura modular que separa las responsabilidades de diferentes actores en el ecosistema de testing:
* **JUnit Platform:** Fundación para ejecutar tests en la JVM. Proporciona el `TestEngine` y APIs de extensión.
* **JUnit Jupiter:** Nuevo modelo de programación. Incluye anotaciones, aserciones (*assertions*) y extensiones.
* **JUnit Vintage:** Proporciona compatibilidad retroactiva con JUnit 3.x y 4.x a través de un `TestEngine` dedicado.

### 1.3 Apache Maven y Gestión de Dependencias
Apache Maven es una herramienta de construcción y gestión de proyectos Java que utiliza un modelo declarativo basado en un archivo de configuración llamado `pom.xml`. Maven soluciona problemas comunes en proyectos Java como:
* Gestión centralizada de dependencias con transitividad automática.
* Ciclo de vida estándar de construcción (`clean`, `compile`, `test`, `package`, `install`, `deploy`).
* Integración con repositorios remotos (Maven Central).
* Ejecución automática de pruebas unitarias.
* Generación de reportes y documentación.

### 1.4 Configuración de pom.xml para JUnit 5
El archivo `pom.xml` (*Project Object Model*) es el corazón de un proyecto Maven. Define metadatos del proyecto, dependencias, plugins y configuraciones de construcción. A continuación, se presenta una configuración parcial para JUnit 5:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="[http://maven.apache.org/POM/4.0.0](http://maven.apache.org/POM/4.0.0)"
         xmlns:xsi="[http://www.w3.org/2001/XMLSchema-instance](http://www.w3.org/2001/XMLSchema-instance)"
         xsi:schemaLocation="[http://maven.apache.org/POM/4.0.0](http://maven.apache.org/POM/4.0.0) [http://maven.apache.org/xsd/maven-4.0.0.xsd](http://maven.apache.org/xsd/maven-4.0.0.xsd)">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.lab04</groupId>
    <artifactId>pruebas-unitarias-junit</artifactId>
    <version>1.0.0</version>
    <name>Pruebas Unitarias con JUnit 5</name>
    <description>
        Guía de laboratorio para pruebas unitarias en Java 25 con JUnit 5
    </description>
</project>
```

Para usar este pom.xml: 
1) Crear directorio de proyecto, 
2) Colocar pom.xml en la raíz, 
3) Ejecutar mvn clean test en la terminal.

``bash
proyecto/
├── pom.xml
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/lab04/
    │   │       ├── Calculadora.java
    │   │       └── CuentaBancaria.java
    │   └── resources/
    └── test/
        ├── java/
        │   └── com/lab04/
        │       ├── CalculadoraTest.java
        │       └── CuentaBancariaTest.java
        └── resources/
└── target/
    ├── classes/
    └── test-classes/
```
1.6 Anotaciones Principales en JUnit 5
@Test: Marca un método como prueba unitaria ejecutable.

@DisplayName: Proporciona un nombre personalizado para la prueba (admite espacios y caracteres especiales).

@BeforeEach: Se ejecuta antes de cada prueba.

@AfterEach: Se ejecuta después de cada prueba.

@BeforeAll: Se ejecuta una sola vez antes de todas las pruebas (debe ser un método estático).

@AfterAll: Se ejecuta una sola vez después de todas las pruebas (debe ser un método estático).

@ParameterizedTest: Marca una prueba para ejecutarse múltiples veces con diferentes parámetros.

@ValueSource: Proporciona una fuente de valores simples para pruebas parametrizadas.

@CsvSource: Proporciona datos estructurados en formato CSV para pruebas parametrizadas.

@Disabled: Deshabilita temporalmente una prueba.

@Nested: Permite anidar una clase de prueba dentro de otra para agrupar pruebas relacionadas.

@Tag: Etiqueta pruebas para realizar filtrados y categorizaciones.

1.7 Assertions (Aserciones) en JUnit 5
assertEquals(expected, actual): Verifica que dos valores sean iguales.

assertTrue(condition): Verifica que una condición sea verdadera.

assertFalse(condition): Verifica que una condición sea falsa.

assertNull(object): Verifica que un objeto sea nulo.

assertNotNull(object): Verifica que un objeto NO sea nulo.

assertThrows(ExceptionType, executable): Verifica que se lance una excepción específica.

assertDoesNotThrow(executable): Verifica que NO se lance ninguna excepción.

assertAll(...): Ejecuta múltiples assertions agrupadas, reportando todas las fallas en conjunto.

assertArrayEquals(expected, actual): Verifica que dos arrays sean iguales.

assertIterableEquals(expected, actual): Verifica que dos colecciones iterables sean iguales.

II. EJERCICIO/PROBLEMA RESUELTO POR EL DOCENTE
EJERCICIO 1: CALCULADORA SIMPLE
1.1 Descripción del Problema
Se requiere crear una clase Calculadora que realice operaciones matemáticas básicas (suma, resta, multiplicación, división). Cada operación debe ser probada a nivel de pruebas unitarias para lograr una cobertura del 100%.

1.2 Requisitos Funcionales
Suma de dos enteros.
Resta de dos enteros.
Multiplicación de dos enteros.
División de dos enteros (resultado double).
Manejo de división entre cero lanzando una excepción.

1.3 Archivos de Código
Clase a probar: src/main/java/pe/com/lab04/Calculadora.java

Clase de pruebas: src/main/java/pe/com/lab04/CalculadoraTest.java

1.4 Ejecución y Resultados
Para ejecutar las pruebas desde consola:
```bash
mvn clean test
mvn test -Dtest=CalculadoraTest
```
Resultados del análisis (VSCode - Run Test with Coverage):

Calculadora.java: 100% de cobertura.

1.5 Puntos Clave del Ejercicio
@Test marca los métodos como pruebas ejecutables.

@DisplayName proporciona descripciones legibles.

@BeforeEach inicializa el objeto antes de cada prueba.

assertEquals y assertThrows verifican resultados válidos y excepciones respectivamente.

Empleo del Patrón AAA: Arrange-Act-Assert.

EJERCICIO 2: GESTOR DE CUENTA BANCARIA
2.1 Descripción del Problema
Se requiere crear una clase CuentaBancaria que gestione transacciones bancarias (depósitos, retiros) con validaciones y manejo de estado. Este ejercicio introduce pruebas parametrizadas y un ciclo de vida más complejo.

2.2 Requisitos Funcionales
Mantener número de cuenta, saldo inicial y titular.

Permitir depósitos con validación de monto positivo.

Permitir retiros con validación de saldo suficiente.

Registrar el historial de transacciones.

Lanzar excepciones para operaciones inválidas.

Consultar el saldo actual.

2.3 Archivos de Código
Clase a probar: src/main/java/pe/com/lab04/CuentaBancaria.java

Clase de pruebas: src/main/java/pe/com/lab04/CuentaBancariaTest.java

2.4 Ejecución y Resultados
Ejecución en consola:

```bash
mvn clean test
mvn test -Dtest=CuentaBancariaTest
```
Métricas obtenidas en el IDE (VSCode):

CuentaBancaria.java: 81% de cobertura.

2.5 Puntos Clave del Ejercicio
Uso de @BeforeEach y @AfterEach para la configuración y limpieza (setup/teardown) de entornos de prueba.

@ParameterizedTest junto con @ValueSource y @CsvSource para inyectar múltiples flujos de datos a una misma prueba.

Empleo de validaciones directamente en constructores.

Uso de LocalDateTime para el registro de marcas de tiempo (timestamps) en transacciones.
III. EJERCICIOS/PROBLEMAS PROPUESTOS
EJERCICIO PROPUESTO 1: GESTOR DE INVENTARIO
1.1 Descripción General
Desarrolle un programa para la gestión de inventario que permita controlar el stock de productos. El programa debe mantener información de productos y registrar movimientos (entradas y salidas). Este ejercicio enfatiza validaciones y casos límite.

1.2 Requisitos Funcionales
Clase Producto con atributos: código, nombre, precio, cantidad.

Validar que el código no sea vacío.

Validar que la cantidad nunca sea negativa.

Validar que el precio sea positivo.

Método agregarStock(cantidad): incrementa el stock.

Método extraerStock(cantidad): decrementa el stock.

Método consultarStock(): retorna la cantidad disponible.

Método obtenerValorTotal(): retorna el cálculo de precio * cantidad.

Lanzar excepciones para operaciones inválidas y registrar la fecha y hora (LocalDateTime) de cada movimiento.

1.3 Requisitos de Pruebas
Mínimo 12 casos de prueba.

Cobertura de código al 100%.

Cobertura de casos excepcionales (valores negativos, nulos).

Al menos una prueba parametrizada.

Usar @BeforeEach para inicialización y @DisplayName para descripciones legibles.

Validar los mensajes de error en las excepciones.

1.4 Estructura de Clases Sugerida
Clase Producto: Atributos codigo (String), nombre (String), precio (double), cantidad (int). Métodos getters, agregarStock(), extraerStock(), consultarStock().

Clase Movimiento: Atributos tipo (ENTRADA/SALIDA), cantidad, fecha (LocalDateTime).

EJERCICIO PROPUESTO 2: CARRITO DE COMPRAS
2.1 Descripción General
Implemente un programa de carrito de compras para una tienda en línea. Este ejercicio integra múltiples clases, operaciones complejas y requiere el uso de Mockito para simular servicios externos como el cálculo de impuestos y descuentos.

2.2 Requisitos Funcionales
Clase Producto: id, nombre, precio, disponibilidad.

Clase CarritoCompra: agregar producto, remover producto, vaciar.

Interfaz ServicioPrecio: calcularDescuento(), calcularImpuesto().

Operaciones del Carrito: calcularTotal() (aplicando descuentos e impuestos) y obtenerResumenCompra().

Validaciones: impedir añadir productos indisponibles, no permitir cantidades negativas, permitir actualizar cantidades de productos existentes y detectar productos duplicados.

Mantener un historial de operaciones del carrito.

2.3 Requisitos de Pruebas
Mínimo 18 casos de prueba.

Pruebas sin mocks para operaciones básicas y pruebas con Mockito para simular ServicioPrecio.

Pruebas parametrizadas para diferentes montos.

Validar casos límite: carrito vacío (total = 0), productos duplicados, carrito con 1 producto y carrito con 100 productos.

Verificar las llamadas de interacción hacia ServicioPrecio.

Usar @Nested para agrupar las pruebas relacionadas.

Cobertura mínima del 85%.

2.4 Estructura Sugerida
Producto: id, nombre, precio (double), disponible (boolean).

CarritoCompra: Atributos items (List<ItemCarrito>), servicioPrecio. Métodos agregar, remover, calcularTotal, obtenerResumen.

ServicioPrecio (Interfaz): Métodos calcularDescuento(double), calcularImpuesto(double).

I. CUESTIONARIO
Pregunta 1: Principios FIRST y Pruebas Independientes ¿Por qué es crítico el principio "Independent" (Independencia) en las pruebas unitarias? Explique las consecuencias de tener pruebas dependientes entre si. ¿Cómo ayuda Mockito y la inyección de dependencias a lograr independencia total?

Pregunta 2: Anotaciones de Ciclo de Vida en JUnit 5 ¿Cuál es el propósito de las anotaciones de ciclo de vida (@BeforeEach, @AfterEach, @BeforeAll, @AfterAll)? Proporcione casos de uso específicos para cada una, explique cuándo usar cada una y por qué son necesarias. Incluya al menos un anti-patrón (mal uso).

Pregunta 3: Mejora de Calidad con Mockito e Inyección de Dependencias ¿Cómo mejora Mockito la calidad de las pruebas unitarias en comparación con pruebas de integración? Discuta las diferencias entre mocks, stubs y spies. ¿Cuándo es apropiado usar cada uno? Proporcione ejemplos del mundo real (e.g., APIs externas, bases de datos, servicios de pago).

Pregunta 4: Testing y Deuda Técnico ¿Cuál es la relación entre las pruebas unitarias exhaustivas y la reducción de deuda técnica? Analice cómo las pruebas facilitan la refactorización segura y la prevención de regresiones. Investigue proyectos Open Source exitosos y cómo manejan testing.

II. REFERENCIAS Y BIBLIOGRAFÍA RECOMENDADAS
[1] Beck, K., & Gamma, E. (1997). "Test Infected: Programmers Love Writing Tests". Java Report, 7(9), 37-50. Artículo seminal que introduce JUnit y revoluciona el testing en Java.

[2] Fowler, M. (2018). "Refactoring: Improving the Design of Existing Code" (2nd ed.). Addison-Wesley Professional. Capítulos 3-4 sobre testing y cambios seguros.

[3] Roman, S., Liguori, S., & Stanchev, P. (2022). "JUnit in Action" (3rd ed.). Manning Publications. Guía comprehensiva de JUnit 5 con ejercicios prácticos.

[4] Osherove, R. (2013). "The Art of Unit Testing: with Examples in Java" (2nd ed.). Manning Publications. Mejores prácticas para pruebas valiosas y mantenibles.
