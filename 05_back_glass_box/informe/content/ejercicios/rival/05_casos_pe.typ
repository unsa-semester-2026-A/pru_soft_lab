= Casos de Prueba de Caja Negra (PE) - Persistencia
== Métodos de Habit.java

*Integrante:* Arce Mayhua Leonardo Ruben
*Componente:* Persistencia en memoria
*Commit:* e877aba

== Pruebas de Caja Negra

#table(
  columns: (1.8fr, 1fr, 1.5fr, 1.5fr),
  [Método], [Clase de equivalencia], [Valor de prueba], [Resultado esperado],

  [isActiveOnDate()], [Válida], [Fecha >= startDate y día programado], [true],
  [isActiveOnDate()], [Inválida], [Fecha < startDate], [false],
  
  [getScheduledDaysCount()], [Válida], [start=01/01/2024, end=08/01/2024, días Lun-Mié-Vie], [3],
  [getScheduledDaysCount()], [Límite], [start == end], [0],
  
  [setCompletedOn()], [Válida], [Fecha >= startDate y fecha <= hoy], [Registra],
  [setCompletedOn()], [Inválida], [Fecha < startDate], [Lanza excepción],
  [setCompletedOn()], [Inválida], [Fecha > hoy], [Debe rechazar],
  
  [isCompletedOn()], [Válida], [Fecha con registro completado], [true],
  [isCompletedOn()], [Válida], [Fecha sin registro], [false],
  
  [getTotalCompletionsCount()], [Válida], [Solo fechas <= hoy], [Conteo correcto],
  [getTotalCompletionsCount()], [Inválida], [Incluye fechas futuras], [No debe contar],
  
  [getCompletionRate()], [Válida], [Días programados > 0], [Tasa entre 0 y 1],
  [getCompletionRate()], [Límite], [Días programados = 0], [0.0],
)