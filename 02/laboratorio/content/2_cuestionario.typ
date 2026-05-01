#set par(justify: true)
#set enum(numbering: "1.")

+ *¿Por qué en TDD se considera que "la prueba es el primer cliente del código"?*

  Porque antes de que exista ninguna implementación, la prueba ya consume la interfaz pública del módulo: invoca la función, le pasa argumentos y espera un valor de retorno. Eso obliga al desarrollador a diseñar una API clara y usable desde el principio, en lugar de diseñarla pensando solo en el código interno. En la programación orientada a pruebas (*test-first programming*), la especificación y las pruebas se escriben antes que cualquier implementación, de modo que el primer "usuario" real del módulo es el propio conjunto de pruebas. Si la prueba resulta difícil de escribir, es señal de que la interfaz está mal diseñada; así, la prueba actúa como auditor de calidad del diseño antes de que exista una sola línea de código productivo.

+ *¿Cómo ayuda BDD a evitar errores de comunicación entre el Product Owner y el equipo de desarrollo?*

  BDD traslada la especificación del software al lenguaje natural estructurado (Gherkin: *Dado / Cuando / Entonces*), comprensible tanto para perfiles técnicos como de negocio. Al escribir escenarios ejecutables, el Product Owner puede leerlos, validarlos y firmarlos antes de que comience el desarrollo. Si hay una ambigüedad en el requisito, el escenario la hace visible de inmediato; si el escenario pasa, hay evidencia objetiva de que el software cumple exactamente lo acordado. Esto elimina la brecha habitual entre "lo que el cliente pidió" y "lo que el equipo entendió", porque ambas partes trabajan sobre el mismo artefacto: la especificación ejecutable.

+ *¿Qué es el análisis de valor límite según Myers y por qué es más efectivo que probar valores aleatorios?*

  El análisis de valor límite (BVA, *Boundary Value Analysis*) se basa en la observación de Myers de que los defectos tienden a concentrarse justo en los extremos de las particiones de equivalencia: el valor mínimo, el máximo y los valores inmediatamente adyacentes a cada frontera. El software muestra un comportamiento discontinuo y discreto a lo largo del espacio de entradas posibles: puede funcionar correctamente en un amplio rango y fallar abruptamente en un único punto límite. Las pruebas aleatorias tienen baja probabilidad de caer exactamente en esos puntos críticos; el BVA, en cambio, los apunta directamente. Por eso, con un número pequeño de casos bien elegidos se detectan muchos más defectos que con un conjunto aleatorio de igual tamaño.

+ *¿Cuál es el propósito del paso Refactor en el ciclo TDD y qué riesgo se corre si se omite?*

  El paso *Refactor* busca mejorar la estructura interna del código (eliminar duplicación, clarificar nombres, simplificar lógica) sin alterar su comportamiento externo, aprovechando que las pruebas en verde actúan como red de seguridad. Si se omite, la base de código acumula deuda técnica: el código mínimo escrito para pasar la prueba (*Green*) suele ser sucio y frágil. Con el tiempo esa deuda hace que añadir nuevas funcionalidades sea cada vez más costoso y riesgoso, y aumenta la probabilidad de introducir regresiones, precisamente porque el código no fue diseñado para evolucionar sino solo para satisfacer el test inmediato.

+ *¿Por qué es importante definir el resultado esperado antes de ejecutar una prueba?*

  Definir el resultado esperado *a priori* garantiza que la prueba sea objetiva e independiente de la implementación. Una suite de pruebas correcta acepta todas las implementaciones legales de la especificación; si el resultado esperado se define después de ver la salida real, existe el riesgo de simplemente ratificar el comportamiento actual del código, incluso si ese comportamiento es incorrecto. Además, en el ciclo TDD, una prueba que no puede fallar antes de que exista la implementación no aporta valor: si el resultado esperado no está definido con antelación, no es posible verificar la fase *Red*, que es la que confirma que la prueba realmente detecta la ausencia de funcionalidad.
