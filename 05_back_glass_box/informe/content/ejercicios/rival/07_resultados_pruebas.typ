= Resultados y Evidencia de Pruebas
== Persistencia - Habit.java

*Integrante:* Arce Mayhua Leonardo Ruben
*Componente:* Persistencia en memoria
*Commit:* e877aba

== Resumen de Pruebas Realizadas

Se ejecutaron pruebas sobre los métodos de la clase `Habit.java`:

- isActiveOnDate()
- getScheduledDaysCount()
- setCompletedOn()
- isCompletedOn()
- getTotalCompletionsCount()
- getTotalScheduledDaysCount()
- getCompletionRate()

== Errores Encontrados

Se identificaron 3 errores visuales en el sistema:

=== Error 1: Dependencia de la fecha del sistema

*Descripción:* La fecha que utiliza el sistema es la de la computadora. Si esta está errónea, el sistema también lo estará.
=== Fecha modificada en la computadora

#figure(
  image("../../../src/img/leonardo/modificacion_fecha.png", width: 100%),
  caption: [Estado antes de editar: Historial con completaciones marcadas]
)

*Impacto:* Un usuario con la fecha del sistema incorrecta puede registrar hábitos en fechas equivocadas.

=== Error 2: Inconsistencia entre UI y modelo

*Descripción:* La interfaz no permite marcar fechas futuras, pero el código (`setCompletedOn()`) sí lo permite.

*Impacto:* Si se accede directamente al modelo (sin UI), se pueden registrar completaciones en fechas que aún no han ocurrido.

=== Error 3: Pérdida de historial al editar fecha de inicio

*Descripción:* Al editar un hábito creado en fecha pasada y actualizarlo a la fecha actual, el avance (historial) se borra.

*Impacto:* El usuario pierde el registro de su progreso al modificar la fecha de inicio.


== Evidencia

=== Antes de editar

#figure(
  image("../../../src/img/leonardo/antes_editar_historial.png", width: 100%),
  caption: [Estado antes de editar: Historial con completaciones marcadas]
)

=== Después de editar (cambiando fecha de inicio)

#figure(
  image("../../../src/img/leonardo/despues_editar_historial.png", width: 100%),
  caption: [BUG: Al cambiar fecha de inicio, el historial se perdió]
)

== Conclusión

El sistema Habitflow presenta errores en la capa de persistencia y modelo que afectan la integridad de los datos y la experiencia del usuario. Se recomienda corregir la validación de fechas futuras y el manejo del historial al editar hábitos.