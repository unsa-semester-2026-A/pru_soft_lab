= Casos de Prueba de Caja Negra (PE) - Sistema Rival
== Persistencia en Memoria

*Integrante:* Arce Mayhua Leonardo Ruben
*Sistema Rival:* Habitflow

== Pruebas de Caja Negra Aplicadas al Sistema Rival

#table(
  columns: (1.5fr, 1fr, 1.5fr, 1.5fr),
  [Componente], [Clase], [Valor], [Resultado esperado],

  [Fecha del sistema], [Válida], [Fecha correcta], [Sistema funciona normalmente],
  [Fecha del sistema], [Inválida], [Fecha errónea], [Sistema debería alertar o rechazar],
  
  [setCompletedOn() - UI], [Válida], [Fecha <= hoy], [Permite marcar],
  [setCompletedOn() - UI], [Inválida], [Fecha > hoy], [No permite marcar (correcto)],
  
  [setCompletedOn() - Modelo], [Inválida], [Fecha > hoy], [Debería rechazar pero NO lo hace],
  
  [Editar hábito], [Válida], [Cambiar nombre o duración], [Mantiene historial],
  [Editar hábito], [Inválida], [Cambiar fecha de inicio], [PÉRDIDA DE HISTORIAL - BUG],
)