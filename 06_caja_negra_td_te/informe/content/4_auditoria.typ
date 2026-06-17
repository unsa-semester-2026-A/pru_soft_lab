// ==========================================
// AUDITORÍA DE RÚBRICA Y CHECK-LIST
// Responsable: Leo
// ==========================================

#block(
  fill: rgb("#fffbe6"),
  stroke: rgb("#ffe58f"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Indicaciones para Leo (Auditoría):*
  - Valida el informe completo contra la rúbrica antes de la entrega final.
  - Verifica y marca en el siguiente check-list que se cumplan las condiciones críticas para asegurar el puntaje.
]

== Auditoría de Rúbrica y Check-list

#table(
  columns: (2fr, 1fr, 3fr),
  inset: 7pt,
  stroke: 0.5pt + rgb("#d9d9d9"),
  fill: (x, y) => if y == 0 { rgb("#ffe58f") } else { none },
  align: (left, center, left),
  [*Criterio de Rúbrica / Entregable*], [*Estado (Cumple / No)*], [*Detalle / Observaciones*],
  [Cuestionario: Citas bibliográficas en todas las respuestas (Annette)], [ \[ \] Sí / \[ \] No ], [Verificar que Annette haya incluido referencias bibliográficas en formato de cita (ej. \@debruyn2011global) en las tres preguntas.],
  [Ejercicio 1: Pruebas Básicas de ParaBank (Leo)], [ \[ \] Sí / \[ \] No ], [Verificar que se hayan aplicado y documentado PE y AVL con su respectiva evidencia de ejecución (capturas o código).],
  [Ejercicio 1: Pruebas Avanzadas de ParaBank (Alisson)], [ \[ \] Sí / \[ \] No ], [Verificar que se hayan diseñado y ejecutado las Tablas de Decisión y diagramas de Transición de Estados con evidencia.],
  [Ejercicio 2: Guerra de Testers Parte II (Yo)], [ \[ \] Sí / \[ \] No ], [Verificar la inclusión de TD, TE, y las 3 técnicas nuevas (Use Case, Random, Cause-effect) con su respectiva evidencia.],
  [Formato: Excelente redacción, estructurado y sin errores ortográficos], [ \[ \] Sí / \[ \] No ], [Revisión general de formato y gramática de todo el documento.]
)

#v(1em)

*Firma del Auditor:*
#v(2em)
-------------------------------------- \
Leo (Responsable de Auditoría de Rúbrica)
