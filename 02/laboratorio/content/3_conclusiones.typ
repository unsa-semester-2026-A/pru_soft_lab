#set par(justify: true)
#set enum(numbering: "1.")

+ **TDD como disciplina de diseño, no solo de verificación.** El ciclo Red-Green-Refactor no es únicamente una técnica de detección de errores; es ante todo una disciplina de diseño que fuerza a comprender los requisitos antes de escribir código. El ejemplo del validador de contraseñas y el módulo de descuentos ilustra cómo el código mínimo del paso *Green* puede ser deliberadamente incorrecto (orden erróneo de condicionales), y cómo es la propia prueba la que lo descubre, no la revisión manual.

+ **BDD como puente entre negocio y tecnología.** Los escenarios Gherkin (*Dado / Cuando / Entonces*) convierten los requisitos en artefactos ejecutables que cualquier miembro del equipo puede leer y validar. Esto reduce la ambigüedad en la interpretación de los requisitos y produce documentación viva que se mantiene sincronizada con el código.

+ **La selección sistemática de casos de prueba es superior al azar.** Aplicar particiones de equivalencia y análisis de valor límite permite construir suites pequeñas pero exhaustivas en los puntos donde estadísticamente se concentran los defectos. Como demuestran los ejercicios, probar los límites exactos (2, 3, 4, 5 extras) detecta errores que una prueba aleatoria difícilmente encontraría.

+ **unittest y pytest son complementarios.** unittest impone una estructura orientada a objetos que favorece la organización formal de los casos de prueba (útil en equipos grandes o entornos con estándares estrictos), mientras que pytest ofrece una sintaxis más ágil y reportes detallados que aceleran el ciclo de retroalimentación, especialmente valioso en proyectos que aplican integración continua.

+ **La combinación TDD + BDD maximiza la calidad.** TDD garantiza la corrección técnica interna; BDD garantiza que el software entregue el valor de negocio esperado. Usados juntos conforman una estrategia de pruebas completa que cubre tanto la micro-validación del código como la validación de los requisitos del usuario final.

#v(2em)
#bibliography("refs.bib", style: "ieee")
