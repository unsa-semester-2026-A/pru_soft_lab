==== Evidencias y pasos de reproducción

// Definición de URL base para acortar enlaces de GitHub
#let github_base = "https://github.com/rikich3/lab_pru_soft/tree/main/lab5/"
#let controller_url = github_base + "src/main/java/com/tracker/controllers/MainController.java"

#table(
  columns: (1fr, 4fr),
  stroke: 0.5pt + luma(100),
  fill: (x, y) => if y == 0 { luma(240) },
  align: (center, left),
  
  [*Bug ID*], [*Evidencia / Pasos*],

  [BUG-01],
  [
    *Pasos para replicar:*

    1. Abrir el formulario para editar un hábito existente.
    2. Observar cómo el límite del spinner requiere un parche asíncrono para no fallar debido a un orden de carga incorrecto.

    *Esperado:* Los datos se cargan en el formulario sin detonar cálculos reactivos hasta que todos los campos estén listos.

    *Obtenido (Fallo):* Establecer la fecha detona el listener de inmediato antes de cargar los días de la semana necesarios para el cálculo de límites.

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
    ```
  ],

  [BUG-02],
  [
    *Pasos para replicar:*
    1. Crear 3 hábitos cuya duración sume <= 24 horas.
    2. Editar uno de ellos incrementando el tiempo para superar el límite de 24h/día.
    3. El sistema muestra correctamente la alerta de rechazo. Cerrar la alerta.
    4. Actualizar la vista o intentar otra acción (ej. crear otro hábito).

    *Esperado:* Al fallar la validación, el objeto en memoria debe revertir su estado original (integridad transaccional).

    *Obtenido (Fallo):* El código ya mutó la instancia viva usando *setters* antes de validar. El dashboard pasa a mostrar un tiempo acumulado irreal (ej. 26 horas).

    *Evidencia (Capturas):*
    
    #figure(
      image("/informe/src/img/alvaro/escenario previo al bug 2.png", width: 90%),
      caption: [Escenario previo al bug: 3 hábitos suman un tiempo válido.],
    )
    
    #figure(
      image("/informe/src/img/alvaro/manifestacion bug 2, se ve que el tiempo diario estimado es de 26 horas.png", width: 90%),
      caption: [Manifestación del bug 2: La memoria quedó corrupta y el dashboard muestra 26 horas diarias.],
    )
  ],

  [BUG-03],
  [
    *Pasos para replicar:*
    1. Iniciar la edición de un hábito existente.
    2. Seleccionar en el `DatePicker` una fecha en el pasado.

    *Esperado:* El sistema debe mantener bloqueado el contenedor de días pasados (`pastCompletionContainer`) en modo edición.

    *Obtenido (Fallo):* El *listener* reactivo de la fecha habilita el campo incondicionalmente (`disable(false)`), rompiendo la restricción.
  ],

  [BUG-04],
  [
    *Pasos para replicar:*
    1. En el formulario de la derecha, escribe `"Gimnasio Diario"` y duración `1 hrs 0 mins`.
    2. Selecciona *todos los días* y fecha de inicio de *hace exactamente 4 días*.
    3. En el selector de "Días cumplidos", pon `2` y guarda.
    4. En la grilla del historial de la tarjeta (últimos 5 días), *marca las 4 casillas del pasado*.

    *Esperado:* El progreso debe limitarse lógicamente al 100%.

    *Obtenido (Fallo):* La tarjeta muestra inconsistencias como `Progreso: 6/5 días (100.0%)`. En el panel superior, la Completitud General muestra *`120.0%`*. La matemática colapsa al disminuir los días programados pero conservar los días marcados.

    *Evidencia (Capturas):*
    #figure(
      image("/informe/src/img/alvaro/estado antes de realizar el bug.png", width: 90%),
      caption: [Estado normal antes de realizar el bug.],
    )
    
    #figure(
      image("/informe/src/img/alvaro/bug de completitud manifestado.png", width: 90%),
      caption: [Bug manifestado: El Dashboard muestra una métrica imposible mayor al 100%.],
    )
  ],

  [BUG-05],
  [
    *Pasos para replicar:*
    1. Inicia la aplicación y déjala abierta en la computadora.
    2. Cambia la fecha del sistema operativo un día hacia el futuro (para simular el paso de medianoche).
    3. Intenta crear un hábito seleccionando el día de *"Hoy"* en el calendario.

    *Esperado:* El sistema debe detectar el nuevo día y permitir el guardado.

    *Obtenido (Fallo - Bloqueo Permanente):* El botón de *Guardar Hábito* se deshabilita permanentemente para el día actual. La app guarda la fecha de inicio del programa (`today`) de manera estática y considera todo nuevo día como "fecha en el futuro".
  ],

  [BUG-06],
  [
    *Pasos para replicar:*
    1. Haz clic dentro de la fecha de inicio (`DatePicker`) y borra la fecha actual.
    2. Escribe texto basura, ej: `"BASURA-TEXTO-99"`.
    3. Rellena los demás campos y pulsa rápido *Enter* o el botón de Guardar.

    *Esperado:* El sistema valida el campo e impide el guardado, mostrando un mensaje amigable.

    *Obtenido (Fallo):* La aplicación colapsa intentando procesar basura no estructurada (`DateTimeParseException`), llenando la consola del sistema con trazas de error de Java y rompiendo el flujo del hilo de la interfaz.
  ],
)