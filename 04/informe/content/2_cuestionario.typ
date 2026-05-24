#import "/informe/util/util.typ": *

#set enum(numbering: "1.")
#set par(justify: true)

+ *Principios FIRST y Pruebas Independientes* \
  Dentro de los principios FIRST, la independencia entre pruebas resulta quizás la más crítica en la práctica. Su propósito es que el resultado de cada test dependa únicamente del código que evalúa, sin verse condicionado por el orden de ejecución ni por estado residual dejado por pruebas anteriores.

  Cuando esta independencia se rompe, las consecuencias son concretas: una prueba puede fallar simplemente porque la anterior modificó una variable global o dejó registros en la base de datos, lo que genera falsos positivos o negativos difíciles de rastrear. Depurar este tipo de errores es particularmente frustrante porque el fallo no está en el código bajo prueba sino en el acoplamiento entre tests. Además, las pruebas dependientes no pueden ejecutarse en paralelo, lo que eleva considerablemente los tiempos de validación en pipelines de CI/CD @fowler2018refactoring.

  La combinación de inyección de dependencias con Mockito ataca directamente este problema. Al diseñar las clases en torno a interfaces en lugar de implementaciones concretas, es posible sustituir las dependencias reales —red, base de datos, servicios externos— por mocks controlados. Cada prueba arranca desde un estado predecible y aislado, sin interferencia de factores externos.

+ *Anotaciones de Ciclo de Vida en JUnit 5* \
  JUnit 5 provee cuatro anotaciones para gestionar el estado alrededor de la ejecución de tests:

  - `@BeforeAll`: Se ejecuta una única vez antes de que corra cualquier test de la clase; debe declararse como método estático. Es adecuada para operaciones costosas que no cambian entre pruebas, como levantar un contenedor Docker o abrir una conexión a una base de datos de pruebas.
  - `@AfterAll`: Contraparte de la anterior, se ejecuta al terminar todos los tests. Sirve para liberar esos recursos —cerrar conexiones, apagar contenedores.
  - `@BeforeEach`: Se ejecuta antes de cada método de prueba individualmente. Su uso más habitual es instanciar el objeto bajo prueba en un estado limpio, por ejemplo un `CarritoCompra` vacío, garantizando que ningún test herede estado del anterior.
  - `@AfterEach`: Se ejecuta tras cada test. Útil para limpiar archivos temporales o restaurar logs que haya modificado la prueba.

  Un anti-patrón frecuente es usar `@BeforeAll` para inicializar una estructura de datos compleja y luego mutarla dentro de los métodos `@Test` sin restablecerla entre ejecuciones. Esto introduce acoplamiento temporal: los tests pasan o fallan según el orden en que JUnit decide ejecutarlos, violando directamente el principio de independencia.

+ *Mejora de Calidad con Mockito e Inyección de Dependencias* \
  Las pruebas de integración verifican que el sistema funcione de extremo a extremo, pero son lentas, frágiles y requieren infraestructura real. Las pruebas con Mockito complementan ese enfoque al aislar la lógica de negocio de sus dependencias, logrando ejecuciones deterministas en milisegundos @osherove2013art.

  Conviene distinguir los tres tipos de dobles de prueba más usados en Mockito:

  - *Stubs:* Responden con valores predefinidos a llamadas concretas. Se usan para alimentar al objeto bajo prueba con datos controlados; por ejemplo, un stub de repositorio que devuelve siempre el mismo usuario al recibir un ID específico.
  - *Mocks:* Además de devolver respuestas configuradas, registran las interacciones: qué métodos se invocaron, cuántas veces y con qué argumentos. Esto permite verificar comportamiento, no solo estado. Un caso típico es confirmar que `procesarPago()` se llamó exactamente una vez con el monto correcto, sin tocar una pasarela de pago real.
  - *Spies:* A diferencia de un mock, un spy envuelve un objeto real y ejecuta su código verdadero, pero registra las llamadas para inspeccionarlas después. Resulta útil cuando se necesita preservar el comportamiento original —por ejemplo, un `Logger` real— pero también verificar que ciertos métodos como `log.error()` hayan sido invocados ante una excepción.

+ *Testing y Deuda Técnica* \
  Una suite de pruebas unitarias con buena cobertura actúa como red de seguridad para la refactorización: permite reorganizar, simplificar o reemplazar código sin el riesgo de introducir regresiones silenciosas. En ese sentido, las pruebas no son solo un mecanismo de verificación sino también una forma de documentación viva que describe cómo se espera que se comporte el sistema @beck1997test.

  Proyectos de gran escala como *Spring Framework*, *React* o el propio *JUnit 5* ilustran este enfoque en la práctica. Sus políticas de contribución exigen que todo Pull Request incluya pruebas automatizadas, y los pipelines de CI rechazan automáticamente aportes que reduzcan el porcentaje de cobertura global. Dado que en estos proyectos colaboran cientos de personas de forma simultánea, esa exigencia es lo que evita que la arquitectura se degrade progresivamente hacia una deuda técnica acumulada e inmanejable.
