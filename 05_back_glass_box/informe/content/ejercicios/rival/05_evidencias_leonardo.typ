==== Evidencias y pasos (Leonardo Arce)

#table(
  columns: (1fr, 2fr),
  [Bug ID], [Evidencia / Pasos],

  [BUG-LR-01],
  [
    *Pasos:* 1) Cambiar la fecha del sistema a una fecha incorrecta (ej. 01/01/2025) 2) Abrir la aplicación Habitflow 3) Crear un nuevo hábito \
    *Esperado:* El sistema debería detectar la fecha incorrecta o alertar al usuario \
    *Obtenido:* El sistema opera con la fecha errónea como si fuera correcta \
    *Evidencia:* La aplicación permite crear hábitos con fechas que no corresponden a la realidad
  ],

  [BUG-LR-02],
  [
    *Pasos:* 1) Abrir la aplicación Habitflow 2) Revisar el código setCompletedOn() líneas 159-165 3) Llamar al método con una fecha futura \
    *Esperado:* El método debería lanzar una excepción o rechazar la fecha futura \
    *Obtenido:* El método permite cualquier fecha >= startDate, incluso futuras \
    *Evidencia:* 
    ```java
    public void setCompletedOn(LocalDate date, boolean completed) {
        if (date.isBefore(startDate)) {
            throw new IllegalArgumentException(...);
        }
        getHistory().put(date, completed);
    }
    ```
  ],

  [BUG-LR-03],
  [
    *Pasos:* 1) Crear hábito con fecha inicio 01/01/2024 2) Marcar varios checkboxes 3) Editar hábito cambiando fecha a 29/05/2026 4) Guardar cambios \
    *Esperado:* El historial de fechas >= nueva fecha debe conservarse \
    *Obtenido:* Todo el historial anterior a la nueva fecha se pierde completamente \
    *Evidencia:* === Antes de editar

#figure(
  image("../../../src/img/leonardo/antes_editar_historial.png", width: 100%),
  caption: [Estado antes de editar: Historial con completaciones marcadas]
)

=== Después de editar (cambiando fecha de inicio)

#figure(
  image("../../../src/img/leonardo/despues_editar_historial.png", width: 100%),
  caption: [BUG: Al cambiar fecha de inicio, el historial se perdió]
)

  ],
)


