== Aplicación propia (FinanceApp)
#include "ejercicios/app/00_resumen.typ"

=== Requerimientos y reglas de negocio y validaciones <sec:eje:app:reglas_negocio>
#include "ejercicios/app/01_reglas_negocio.typ"

=== Diseño y arquitectura <sec:eje:app:design>
#include "ejercicios/app/02_diseno.typ"

=== Stack y herramientas <set:eje:app:stack>
#include "ejercicios/app/03_stack_herramientas.typ"

=== Manual rápido de uso
#include "ejercicios/app/04_manual_uso.typ"

=== Estrategia de Pruebas (Partición de Equivalencia y Valores Límite)

La versión digital y actualizada de este documento se puede consultar directamente en su repositorio de GitHub a través del siguiente enlace: #link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/docs/DOCUMENTO_TECNICO.pdf")[Documento Técnico en GitHub].

Se ha diseñado e implementado un total de 74 pruebas unitarias (excluyendo el módulo de usuario) utilizando las técnicas de Partición de Equivalencia (PE) y Análisis de Valores Límite (AVL). Todos los detalles de esta suite de pruebas se encuentran documentados en el Documento Técnico.

#align(center)[#image("/informe/src/img/alvaro/doc_tec/captura informe técnico.png", width: 90%)]

=== Resultados y evidencia de pruebas internas
#include "ejercicios/app/07_resultados_pruebas.typ"

=== Prompts y apoyo de IA
#include "ejercicios/app/08_prompts_ia.typ"

== Guerra de Testers (aplicación rival)

Como parte de la dinámica de "Guerra de Testers", se realizó una evaluación integral de caja negra y caja blanca sobre el sistema Habitflow desarrollado por el Equipo 19. A través del análisis de su código fuente, validación gráfica y pruebas unitarias de su lógica de negocio, se diseñaron casos de prueba basados en Partición de Equivalencia (PE) y Análisis de Valores Límite (AVL). Esta búsqueda exhaustiva de defectos permitió consolidar un catálogo de errores donde se detallan inconsistencias matemáticas, condiciones de carrera críticas en la carga del sistema, mutaciones prematuras del estado de los hábitos en memoria y bloqueos lógicos.

La versión digital de este reporte se encuentra disponible en GitHub a través del siguiente enlace: #link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/docs/BUSQUEDA_ERRORES.pdf")[Documento de Búsqueda de Errores en GitHub].

#align(center)[#image("/informe/src/img/alvaro/doc_tec/captura_busqueda_errores.png", width: 90%)]
