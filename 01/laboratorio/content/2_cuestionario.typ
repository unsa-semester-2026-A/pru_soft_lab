#set par(justify: true)
#set enum(numbering: "1.")

+ *¿Cuál es el objetivo de la depuración de software?*

  La depuración (_debugging_) tiene como objetivo identificar la causa raíz de un defecto conocido y corregirlo. A diferencia de las pruebas, que detectan la _presencia_ de fallas, la depuración las _localiza_ con precisión para eliminarlas [1]. Las actividades clave comprenden: reproducir el error en un entorno controlado, inspeccionar variables mediante breakpoints, analizar el flujo de ejecución paso a paso, y validar que la corrección no introduce nuevos defectos.

+ *¿Cuál es el objetivo de las pruebas de software?*

  Las pruebas (_testing_) buscan verificar que el software cumple los requisitos especificados y validar que el producto satisface las necesidades reales del usuario [2]. Mediante la ejecución sistemática de casos de prueba se detectan defectos antes de la entrega al cliente, reduciendo el costo de corrección —cuyo incremento es exponencial cuanto más tarde se detecta el defecto— y aumentando la confianza en el sistema.

+ *Perfil de un analista de pruebas y un ingeniero de pruebas de software.*

  Según el estándar ISTQB _Foundation Level_ [1], el *analista de pruebas* diseña, ejecuta y documenta casos de prueba; analiza resultados y reporta defectos. Requiere pensamiento analítico, atención al detalle y conocimiento del dominio de negocio. El *ingeniero de pruebas* (perfil técnico) se ocupa de la automatización, la infraestructura de pruebas y las métricas de cobertura; requiere habilidades en programación y herramientas como `pytest`, Selenium o Jenkins. Ambos roles demandan comunicación efectiva y comprensión del ciclo de vida del software.

+ *Criterios y técnicas para garantizar alta confiabilidad ante la imposibilidad de pruebas exhaustivas.*

  Las pruebas exhaustivas son impracticables porque el espacio de entradas es potencialmente infinito: un programa con tres enteros de 32 bits tendría más de $10^{28}$ combinaciones posibles [2]. Para maximizar la detección de defectos con un conjunto manejable de casos se aplican técnicas como: (a) *partición de equivalencias*, que agrupa entradas con comportamiento idéntico; (b) *análisis de valores límite*, que prueba los extremos y fronteras de cada partición; (c) *pruebas basadas en riesgos*, que prioriza funcionalidades críticas o históricamente falladas; y (d) *criterios de cobertura estructural* (sentencias, decisiones, MC/DC), que miden qué proporción del código fue ejercitada. La combinación de estas técnicas permite alcanzar alta confiabilidad de manera sistemática.

+ *¿Cuál es la diferencia entre verificación y validación de software?*

  La *verificación* comprueba que el software fue construido correctamente respecto a la especificación ("¿estamos construyendo el producto bien?"). Se realiza mediante inspecciones, revisiones de código y pruebas estáticas, sin necesidad de ejecutar el sistema. La *validación* comprueba que se construyó el producto correcto respecto a las necesidades reales del usuario ("¿estamos construyendo el producto correcto?"), y se realiza mediante pruebas dinámicas con el sistema en ejecución [1]. En síntesis: la verificación controla la coherencia interna del proceso de construcción, mientras que la validación controla que el resultado final satisface al usuario final.
