= Conclusiones y Lecciones Aprendidas

A continuación, se presentan las conclusiones individuales del equipo de desarrollo, enfocadas en las técnicas de caja blanca aplicadas y el análisis de la complejidad ciclomática de las funciones evaluadas:

#v(1em)

La técnica de pruebas de cobertura de ramas (Branch Coverage) permitió verificar de forma sistemática los puntos de decisión en el módulo `bisect.py`, asegurando que tanto las bifurcaciones verdaderas como las falsas fueran transitadas al 100%. Por otro lado, el análisis de complejidad ciclomática para `Account.__post_init__` ($C C = 5$) evidenció una estructura de validaciones condicionales independientes de riesgo bajo, lo cual garantiza una alta mantenibilidad y simplifica el diseño de la suite de pruebas unitarias.

El diseño de pruebas de combinación de condiciones (Branch Condition Combination Testing) permitió validar de forma exhaustiva el comportamiento del módulo `bisect.py`, asegurando que las decisiones atómicas no presentaran dependencias ocultas o comportamientos imprevistos. Asimismo, el cálculo de complejidad para `Transaction.__post_init__` ($C C = 6$) evidenció cómo el uso de decisiones compuestas y operadores de cortocircuito (`and`) eleva la densidad de caminos lógicos, requiriendo un diseño riguroso de casos de prueba.

La elaboración de los casos de prueba permitió validar de manera sistemática el comportamiento de la función analizada, asegurando la ejecución de todas las sentencias relevantes tanto en escenarios normales como en casos de error. Se logró cubrir la validación de parámetros, la inicialización de valores por defecto, y las dos variantes del algoritmo de búsqueda (con y sin función key), lo que garantiza una cobertura del 100% de sentencias. Asimismo, el cálculo de complejidad para `FinanceService.register_transaction` ($C C = 3$) constató que su lógica posee un riesgo bajo y una excelente modularidad.

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 12pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    [Escribe aquí tu conclusión...]
  ]
)
