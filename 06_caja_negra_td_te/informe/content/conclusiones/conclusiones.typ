// ==========================================
// CONCLUSIONES
// Responsables: Todos los integrantes
// ==========================================

== Conclusiones del Trabajo

- *Conclusión 1:* Las Tablas de Decisión resultaron ser una herramienta muy práctica para organizar y visualizar todas las combinaciones posibles de condiciones de entrada en un sistema. Al aplicarlas sobre ParaBank y nuestro prodcuto, pudimos cubrir de forma sistemática casos que de otro modo podrían haber pasado desapercibidos, como registros con campos individuales faltantes o transferencias con cuentas no verificadas. Esta técnica obliga a pensar en cada condición por separado y en cómo se interactúan entre sí, permitiendo diseñar casos de pruebas completos y bien estructurados.

- *Conclusión 2:* Los Diagramas de Transición de Estados fueron especialmente útiles para modelar el comportamiento dinámico de procesos que cambian de estado, como la autenticación y la solicitud de préstamos de Parabank o el manejo de transacciones en FINANZA. Ambos nos permitieron identificar no solo los caminos exitosos, sino también las transiciones inválidas y los bucles (como un login fallido que mantiene al usuario en el estado Desconectado). Tener el diagrama de forma visual facilita enormemente la generación de casos de prueba que cubran todos los estados y transiciones posibles.

- *Conclusión 3:* La combinación de múltiples técnicas de caja negra (Partición de Equivalencia, Análisis de Valor Límite, Tablas de Decisión y Transición de Estados) aplicadas tanto sobre ParaBank como sobre la aplicación financiera propia, demostró que ninguna técnica por sí sola es suficiente para encontrar todos los defectos. Las Tablas de Decisión capturan la lógica combinatoria, los diagramas de estado capturan el comportamiento temporal, y las técnicas básicas (PE y AVL) validan los límites de entrada. Juntas, estas técnicas se complementan y ofrecen una cobertura mucho más robusta que si se usaran de forma aislada.
