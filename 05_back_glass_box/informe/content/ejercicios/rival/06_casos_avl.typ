= Casos de Análisis de Valores Límite (AVL) - Persistencia
== Métodos de Habit.java

*Integrante:* Arce Mayhua Leonardo Ruben
*Componente:* Persistencia en memoria
*Commit:* e877aba

== Pruebas de Valores Límite

#table(
  columns: (1.5fr, 1fr, 1.5fr, 1.5fr),
  [Método], [Límite], [Valor de prueba], [Resultado esperado],

  [isActiveOnDate()], [startDate], [Fecha = startDate - 1 día], [false],
  [isActiveOnDate()], [startDate], [Fecha = startDate], [true],
  [isActiveOnDate()], [startDate], [Fecha = startDate + 1 día], [true],
  
  [setCompletedOn()], [startDate], [Fecha = startDate - 1 día], [Excepción],
  [setCompletedOn()], [startDate], [Fecha = startDate], [Registra],
  [setCompletedOn()], [hoy], [Fecha = hoy + 1 día], [Debe rechazar],
  
  [getScheduledDaysCount()], [start vs end], [start = 01/01/2024, end = 01/01/2024], [0],
  [getScheduledDaysCount()], [start vs end], [start = 01/01/2024, end = 02/01/2024], [1 si es día programado],
  
  [getCompletionRate()], [total_scheduled], [0 días programados], [0.0],
  [getCompletionRate()], [total_completed], [0 completaciones], [0.0],
)