= Casos de Análisis de Valores Límite (AVL) - Sistema Rival
== Persistencia en Memoria

*Integrante:* Arce Mayhua Leonardo Ruben
*Sistema Rival:* Habitflow

== Pruebas de Valores Límite Aplicadas al Sistema Rival

#table(
  columns: (1.5fr, 1fr, 1.5fr, 1.5fr),
  [Componente], [Límite], [Valor], [Resultado esperado],

  [isActiveOnDate()], [startDate], [startDate - 1 día], [false],
  [isActiveOnDate()], [startDate], [startDate], [true],
  
  [setCompletedOn()], [startDate - 1], [Fecha anterior a inicio], [Excepción - OK],
  [setCompletedOn()], [hoy + 1], [Fecha futura], [Excepción - BUG: No la lanza],
  
  [getTotalCompletionsCount()], [hoy + 1], [Fecha futura en historial], [No debe contar - BUG],
  
  [Editar hábito], [startDate original], [Cambiar a fecha posterior], [Mantener historial de fechas >= nueva fecha],
  [Editar hábito], [startDate original], [Cambiar a fecha posterior], [PÉRDIDA TOTAL DE HISTORIAL - BUG],
)