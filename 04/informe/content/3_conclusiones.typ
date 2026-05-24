#import "/informe/util/util.typ": *

#set enum(numbering: "1.")
#set par(justify: true)

#let conclusiones = (
  "La implementación de pruebas unitarias mediante JUnit 5 demuestra ser fundamental para la construcción de software robusto. Al utilizar anotaciones modernas y pruebas parametrizadas, se logra no solo validar la corrección lógica, sino escalar los flujos de validación de forma eficiente sin duplicar código.",
  "El aislamiento de componentes mediante frameworks como Mockito es la clave para cumplir los principios FIRST. Sustituir dependencias pesadas (como servicios de pago o bases de datos) por simulacros garantiza que las pruebas sean deterministas, extremadamente veloces y estén exentas de falsos positivos provocados por el entorno.",
  "La adopción del patrón Arrange-Act-Assert (AAA) proporciona una estructura estándar y legible que facilita el mantenimiento de la suite de pruebas, sirviendo colateralmente como documentación viva del comportamiento del código.",
  "PLUS: El monitoreo de la métrica de cobertura de código a través de herramientas de análisis dinámico como Maven y JaCoCo promueve una cultura de calidad. Validar que la cobertura abarca caminos excepcionales y flujos críticos (>85% y 100% en lógica de negocio pura) mitiga el riesgo de regresiones y reduce considerablemente la Deuda Técnica, permitiendo refactorizaciones seguras en ciclos de Integración Continua.",
)

#for conclusion in conclusiones [
  - #conclusion
]