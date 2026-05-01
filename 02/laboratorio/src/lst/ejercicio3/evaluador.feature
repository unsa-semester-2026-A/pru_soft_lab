# language: es

Característica: Validador de Calificaciones
  Como sistema de gestión académica
  Quiero clasificar el rendimiento de los estudiantes según su nota
  Para automatizar la entrega de resultados

  Escenario: Clasificación de nota insuficiente
    Dado que el usuario ingresa una nota entre 0 y 10
    Cuando el sistema evalúa la nota
    Entonces debe mostrar "Insuficiente"

  Escenario: Clasificación de nota regular
    Dado que el usuario ingresa una nota entre 11 y 15
    Cuando el sistema evalúa la nota
    Entonces debe mostrar "Regular"

  Escenario: Clasificación de nota excelente
    Dado que el usuario ingresa una nota entre 16 y 20
    Cuando el sistema evalúa la nota
    Entonces debe mostrar "Excelente"

  Escenario: Nota fuera de rango
    Dado que el usuario ingresa una nota menor que 0 o mayor que 20
    Cuando el sistema evalúa la nota
    Entonces debe lanzar una excepción ValueError

  Escenario: Tipo de dato inválido
    Dado que el usuario ingresa un valor no entero (decimal, texto o nulo)
    Cuando el sistema evalúa la nota
    Entonces debe lanzar una excepción TypeError
