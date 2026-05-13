= 1. ¿Cuál es la diferencia fundamental entre una prueba unitaria y una prueba de integración?

La principal diferencia entre una prueba unitaria y una prueba de integración está en el alcance y el aislamiento de los componentes que se prueban.

La prueba unitaria verifica el funcionamiento de una pequeña unidad de código (método, función o clase) de manera aislada, utilizando simulaciones como mocks o stubs para reemplazar dependencias externas. Su objetivo es asegurar que la lógica interna funcione correctamente.

Por otro lado, la prueba de integración comprueba cómo interactúan entre sí dos o más módulos, componentes o sistemas, como bases de datos o APIs externas. El objetivo es verificar que la comunicación y las interfaces funcionen correctamente.

*Ejemplo en un sistema bancario:*

- Una prueba unitaria podría validar el método que calcula los intereses de una cuenta de ahorro.
- Una prueba de integración podría verificar que una transferencia bancaria actualice correctamente tanto la base de datos como el servicio de notificaciones.

#v(1em)

= 2. Explique el principio F.I.R.S.T. de las pruebas unitarias

F.I.R.S.T. es un acrónimo que representa las características que deben cumplir las pruebas unitarias para ser confiables y mantenibles.

- *Fast:* Las pruebas deben ejecutarse rápidamente para facilitar su uso frecuente.
- *Independent:* Las pruebas no deben depender unas de otras y deben poder ejecutarse en cualquier orden.
- *Repeatable:* Deben producir el mismo resultado sin importar el entorno de ejecución.
- *Self-validating:* Deben indicar automáticamente si pasaron o fallaron mediante aserciones.
- *Timely:* Las pruebas deben escribirse oportunamente, idealmente antes del código de producción siguiendo TDD.

El atributo *Independent* es especialmente importante al utilizar fixtures en Pytest porque evita que el estado compartido entre pruebas produzca resultados inconsistentes o errores difíciles de detectar.

#v(1em)

= 3. Patrón AAA (Arrange–Act–Assert)

En el patrón AAA, incluir múltiples aserciones dentro de una misma prueba puede ocasionar problemas de mantenibilidad y dificultar la identificación exacta de los errores cuando una prueba falla.

Además, demasiadas aserciones pueden indicar que la prueba está validando varios comportamientos diferentes en lugar de uno solo.

Sin embargo, es aceptable utilizar múltiples assertions cuando todas verifican distintos aspectos de un mismo resultado o estado final producido por una única acción.

Por ejemplo:

- Validar múltiples atributos de un objeto complejo.
- Verificar el código de estado, encabezados y cuerpo de una respuesta HTTP.
- Comprobar diferentes propiedades relacionadas del mismo resultado.

= 4. Test-Driven Development (TDD)

Test-Driven Development (TDD) es una metodología de desarrollo basada en escribir primero las pruebas antes de implementar el código funcional. El proceso sigue tres etapas principales conocidas como Red–Green–Refactor:

- *Red:* Se escribe una prueba que inicialmente falla porque la funcionalidad aún no existe.
- *Green:* Se implementa el código mínimo necesario para que la prueba pase correctamente.
- *Refactor:* Se mejora y reorganiza el código sin modificar su comportamiento, manteniendo las pruebas exitosas.

Las pruebas unitarias con Pytest facilitan la adopción de TDD debido a su sintaxis sencilla, legibilidad y facilidad para ejecutar pruebas automáticamente. Además, Pytest permite detectar errores rápidamente mediante aserciones claras y reportes detallados, lo cual acelera el ciclo de desarrollo.

Un ejemplo sencillo en Python sería el desarrollo de una función para sumar dos números.

*Paso 1: Crear primero la prueba (Red)*

```python
def test_suma():
    assert suma(2, 3) == 5

```
Inicialmente la prueba fallará porque la función `suma` todavía no existe.

*Paso 2: Implementar el código mínimo (Green)*

```python
def suma(a, b):
    return a + b
```
Después de implementar la función, la prueba se ejecutará correctamente.

*Paso 3: Refactorizar (Refactor)*

Finalmente, el código puede reorganizarse o documentarse mejor sin alterar su comportamiento, verificando siempre que las pruebas continúen pasando.

= 5. Cobertura de código (Code Coverage)

La cobertura de código es una métrica utilizada para medir qué porcentaje del código fuente ha sido ejecutado durante las pruebas. Su objetivo es identificar partes del programa que no están siendo evaluadas por los tests y que podrían contener errores no detectados.

En Python, la cobertura puede medirse utilizando el plugin `pytest-cov`, el cual se integra con Pytest para generar reportes automáticos sobre el código ejecutado durante las pruebas.

Un ejemplo de ejecución sería:

#raw(
  "pytest --cov=app",
  lang: "bash",
)

Este comando muestra el porcentaje de cobertura del módulo `app`.

Existen diferentes métricas de cobertura, entre las más importantes están:

- *Statement Coverage:*  
  Mide el porcentaje de instrucciones o líneas de código ejecutadas al menos una vez durante las pruebas.

- *Branch Coverage:*  
  Evalúa si todas las ramas posibles de decisión fueron recorridas, por ejemplo, las rutas `if/else`, `match`, ciclos y condiciones lógicas.

El *branch coverage* suele ser más completo porque verifica no solo que una línea fue ejecutada, sino también que todas las decisiones posibles fueron probadas.

Sin embargo, una cobertura del 100% no garantiza que el software esté libre de errores. Esto ocurre porque las pruebas podrían ejecutar todas las líneas del programa sin verificar correctamente los resultados esperados o sin contemplar casos límite y escenarios inesperados.

Por ejemplo, una prueba puede recorrer una función completa pero contener aserciones insuficientes o incorrectas. Además, pueden existir errores relacionados con lógica de negocio, concurrencia, rendimiento o integración que no son detectados únicamente mediante cobertura.

Por ello, la cobertura de código debe considerarse como un indicador de apoyo y no como una garantía absoluta de calidad del software.
