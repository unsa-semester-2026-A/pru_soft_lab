// ==========================================
// CUESTIONARIO - PREGUNTA 1
// Responsable: Annette
// Tema: El límite de las Tablas de Decisión vs. Pairwise Testing
// ==========================================

#set par(justify: true, leading: 0.65em, first-line-indent: 1.5em)

== El límite de las Tablas de Decisión vs. Pairwise Testing

=== Fundamento Matemático de Pairwise Testing (All-Pairs)

El *Pairwise Testing* (o All-Pairs Testing) se fundamenta en la *matemática combinatoria*, concretamente en la teoría de los *Covering Arrays* (arreglos de cobertura). Un Covering Array CA(N; t, k, v) es una matriz de N filas y k columnas sobre un alfabeto de v símbolos, tal que para cualquier subconjunto de t columnas, todas las v^t combinaciones posibles aparecen al menos una vez entre las N filas @kuhn2010combinatorial. En Pairwise Testing, t = 2, lo que garantiza que cada par posible de valores de entrada aparezca en al menos un caso de prueba.

La justificación empírica de esta reducción es sólida: la evidencia indica que la gran mayoría de los defectos de software son activados por la interacción de a lo mucho dos parámetros, siendo los defectos de tres o más factores simultáneos progresivamente más raros y costosos de detectar @kuhn2010combinatorial. Bajo este principio, cubrir todos los pares de valores es suficiente para detectar la mayor parte de los errores reales.

En términos de reducción de esfuerzo, la técnica puede disminuir el tamaño del conjunto de pruebas hasta en un 95% en comparación con las pruebas exhaustivas @mastertesting2026pairwise. Por ejemplo, un módulo con 10 parámetros booleanos requeriría 2^10 = 1.024 casos de forma exhaustiva, pero Pairwise Testing lo reduce a aproximadamente 14-18 casos @leadwithskills2025pairwise.

Los algoritmos más utilizados para generar estos arreglos son:

- *IPOG (In-Parameter-Order-General):* construye los casos de prueba añadiendo un parámetro a la vez; maneja eficientemente restricciones y pruebas de fuerza mixta @mastertesting2026pairwise.
- *Algoritmos meta-heurísticos* (Simulated Annealing, algoritmos genéticos): exploran el espacio de soluciones de forma más exhaustiva, útiles cuando las restricciones entre parámetros son complejas @mastertesting2026pairwise.
- *Herramientas prácticas* como PICT (Microsoft) y Pairwise Online Generator implementan estos algoritmos sin requerir conocimiento matemático profundo por parte del tester @inflectra2025pairwise.

Una limitación importante es que Pairwise Testing puede no detectar defectos que requieran la interacción simultánea de tres o más parámetros. Para esos escenarios se recurre al *n-way combinatorial testing* (t = 3, 4, ...), donde estudios del NIST indican que pruebas de 4 a 6 interacciones pueden alcanzar el 100% de detección en muchos sistemas @kuhn2010combinatorial.

=== Discusión y Casos de Estudio

==== Sistema crítico: pruebas exhaustivas al 100%

*Caso: Sistema de gestión de vuelo (aviónica)*

En un sistema de control de vuelo, las variables condicionales incluyen altitud, velocidad, posición de flaps, estado del tren de aterrizaje, nivel de combustible, condiciones meteorológicas, entre otras. Una combinación específica de tres o más condiciones simultáneas (ej. baja altitud + flaps incorrectos + velocidad reducida) puede desencadenar un accidente con pérdida de vidas humanas.

En este contexto, asumir que los defectos de 3+ factores son "estadísticamente improbables" es inaceptable. Los estándares de certificación aeronáutica como DO-178C exigen niveles de cobertura que justifican el uso de Tablas de Decisión exhaustivas. El costo del testing completo es mínimo comparado con el costo humano y legal de un fallo en producción. Como señalan Kuhn et al., para sistemas de alta seguridad se recomienda escalar hasta pruebas de 4 a 6 interacciones para obtener una alta garantía @kuhn2010combinatorial. Complementariamente, TestRail indica que en sistemas críticos para la seguridad y motores de reglas complejos, se debe usar pruebas de orden superior cuando el análisis de riesgos sugiere que los problemas surgen de interacciones entre 3 o más parámetros @testrail2026pairwise.

==== Sistema comercial: Pairwise Testing asumiendo el riesgo

*Caso: Configurador de productos en plataforma de e-commerce*

Una tienda online con 15 variables de configuración (país, idioma, moneda, método de pago, tipo de envío, cupón de descuento, categoría de producto, dispositivo, navegador, resolución de pantalla, sistema operativo, versión de app, membresía, historial de compras, zona horaria) generaría un número de combinaciones completamente inmanejable de forma exhaustiva.

Aquí se justifica aplicar Pairwise Testing por varias razones:

+ *Perfil de riesgo tolerable:* un defecto en esta plataforma tiene impacto económico, no de vidas humanas.
+ *Ciclo de despliegue rápido:* el modelo ágil permite lanzar hotfixes para defectos que escapen al testing inicial.
+ *Alta eficiencia demostrada:* Pairwise Testing es muy eficiente para encontrar bugs gracias a su foco en las combinaciones de variables que causan la mayor cantidad de defectos @inflectra2025pairwise.
+ *Costo-beneficio favorable:* reducir el conjunto de pruebas hasta en un 95% libera recursos para otras actividades de calidad como pruebas de rendimiento y seguridad @mastertesting2026pairwise.

El riesgo asumido es que defectos originados en interacciones de 3+ parámetros (ej. usuario con cupón + moneda exótica + método de pago específico) podrían no ser detectados antes del lanzamiento. Este riesgo se mitiga con monitoreo post-despliegue, análisis de errores en producción y la incorporación de escenarios de 3-way testing para las combinaciones de mayor impacto comercial identificadas por el equipo de negocio.
