==== Evidencias y pasos (Alvaro Quispe)

// Definición de URL base para acortar enlaces de GitHub
#let github_base = "https://github.com/rikich3/lab_pru_soft/tree/main/lab5/"
#let controller_url = github_base + "src/main/java/com/tracker/controllers/MainController.java"

#table(
  columns: (1fr, 4fr),
  stroke: 0.5pt + luma(100),
  fill: (x, y) => if y == 0 { luma(240) },
  align: (center, left),
  
  [*Bug ID*], [*Evidencia / Pasos*],

  [BUG-AQ-01],
  [
    *Pasos para replicar:*

    1. Abrir el formulario para editar un hábito existente.
    2. Observar cómo el límite del spinner requiere un parche asíncrono para no fallar debido a un orden de carga incorrecto.

    *Esperado:* Los datos se cargan en el formulario sin detonar cálculos reactivos hasta que todos los campos (incluyendo días de la semana) estén listos.

    *Obtenido (Fallo):* Establecer la fecha detona el listener de inmediato antes de que se carguen los días de la semana necesarios para el cálculo de límites. El desarrollador usó `Platform.runLater()` como parche temporal para evadir la excepción de JavaFX.

    *Archivo:* #link(controller_url)[`src/main/java/.../MainController.java`]

    *Evidencia (Código - Líneas 357-367):*
    ```java
    // La fecha se setea PRIMERO, detonando el listener
    startDatePicker.setValue(habit.getStartDate()); 

    // Parche temporal para mitigar la condición de carrera
    Platform.runLater(() -> {
      if (habit.getStartDate().isBefore(today)) {
        pastCompletionSpinner.getValueFactory().setValue(habit.getCompletedDaysInPast());
      }
    });

    // Los días se setean DESPUÉS.
    setSelectedDaysOfWeek(habit.getDaysOfWeek()); 
    ```
  ],

  [BUG-AQ-02],
  [
    *Pasos para replicar:* 1. Crear 3 hábitos cuya duración sume <= 24 horas.
    2. Editar uno de ellos incrementando el tiempo para superar el límite de 24h/día.
    3. El sistema muestra correctamente la alerta de rechazo. Cerrar la alerta.
    4. Actualizar la vista o intentar otra acción (ej. crear otro hábito).

    *Esperado:* Al fallar la validación en el Service, el objeto en memoria debe revertir o mantener su estado original (integridad transaccional).

    *Obtenido (Fallo):* La alerta se muestra, pero el código en el controlador ya mutó la instancia viva usando *setters* antes de validar. El dashboard pasa a mostrar un tiempo acumulado irreal (ej. 26 horas).

    *Archivo:* #link(controller_url + "#L386-L397")[`src/main/java/.../MainController.java`]

    *Evidencia (Código - Líneas 386-397):*
    ```java
    // Se obtiene referencia en memoria
    habit = habitService.getHabitById(editingHabitId); 
    if (habit == null) return;

    // Se MUTA directamente el objeto ANTES de enviarlo a validar/guardar
    habit.setName(name); 
    habit.setStartDate(startDate);
    habit.setDailyDurationMinutes(totalMinutes);
    ```

    *Evidencia (Capturas):*
    
    #figure(
      image("/informe/src/img/alvaro/escenario previo al bug 2.png", width: 90%),
      caption: [Escenario previo al bug: 3 hábitos suman un tiempo válido.],
    )
    
    #figure(
      image("/informe/src/img/alvaro/manifestacion bug 2, se ve que el tiempo diario estimado es de 26 horas.png", width: 90%),
      caption: [Manifestación del bug 2: Tras un intento fallido de edición, la memoria quedó corrupta y el dashboard muestra 26 horas diarias.],
    )
  ],

  [BUG-AQ-03],
  [
    *Pasos para replicar:*

    1. Iniciar la edición de un hábito existente.
    2. Seleccionar en el `DatePicker` una fecha en el pasado.

    *Esperado:* Al estar en modo edición, el sistema debe validar la variable `editingHabitId` y mantener bloqueado el contenedor de días pasados (`pastCompletionContainer`).

    *Obtenido (Fallo):* El *listener* reactivo de la fecha habilita el campo incondicionalmente (`disable(false)`), rompiendo la restricción del flujo de negocios en modo edición.

    *Archivo:* #link(controller_url + "#L100-L101")[`src/main/java/.../MainController.java`]

    *Evidencia (Código - Líneas 100-101):*
    ```java
    if (selectedDate.isBefore(today)) {
      // Activa el contenedor sin comprobar si se está en modo edición
      pastCompletionContainer.setDisable(false); 
    }
    ```
  ],

  [BUG-AQ-04],
  [
    *Pasos para replicar:*

    1. Marcar como completado un hábito programado para el día actual.
    2. Editar dicho hábito y quitar "el día de hoy" de su programación semanal.
    3. Verificar la métrica general de completitud en el Dashboard.

    *Esperado:* El logro del día se descarta o el porcentaje se recalcula manteniendo un techo lógico del 100%.

    *Obtenido (Fallo):* Error de lógica matemática. El sistema disminuye correctamente los "días programados" (divisor), pero conserva intactos los "días completados" (dividendo) del registro previo, resultando en tasas que rompen la matemática básica.

    *Archivo:* #link(controller_url + "#L203-L214")[`src/main/java/.../MainController.java`]

    *Evidencia (Código - Líneas 203-214):*
    ```java
    for (Habit habit : habits) {
      // Disminuye al quitar el día de hoy
      totalScheduledDays += habit.getTotalScheduledDaysCount(today); 
      
      // Mantiene el día previo a pesar de que hoy ya no es "programado"
      totalCompletions += habit.getTotalCompletionsCount(today);     
    }
    // Genera > 1.0 (ej. 1.25 -> 125%)
    double rate = (double) totalCompletions / totalScheduledDays; 
    ```

    *Evidencia (Capturas):*

    #figure(
      image("/informe/src/img/alvaro/estado antes de realizar el bug.png", width: 90%),
      caption: [Estado normal antes de realizar el bug (Completitud <= 100%).],
    )
    
    #figure(
      image("/informe/src/img/alvaro/bug de completitud manifestado.png", width: 90%),
      caption: [Bug manifestado: El Dashboard muestra una métrica imposible de 125%.],
    )
  ],
)
