#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 {
      align(right)[
        #text(size: 8pt, fill: rgb("#7f8c8d"))[Búsqueda de Errores: Habitflow (Equipo 19)]
      ]
    }
  },
  footer: context {
    let page_num = counter(page).get().first()
    align(center)[
      #text(size: 9pt, fill: rgb("#7f8c8d"))[#page_num]
    ]
  }
)

#set text(
  font: "Liberation Sans",
  size: 11pt,
  lang: "es",
)

#set par(justify: true)
#set heading(numbering: "1.")
#let breakable(name) = {
  name.split("_").join([\_\u{200b}])
}

// Styling for headings
#show heading: it => block(below: 0.8em, above: 1.2em)[
  #set text(weight: "bold", fill: rgb("#2c3e50"))
  #it
]

// Main Title
#align(center)[
  #block(
    fill: rgb("#d35400"), // Dark orange header to represent bug tracking
    inset: 18pt,
    radius: 4pt,
    width: 100%,
    [
      #text(fill: white, size: 20pt, weight: "bold")[BÚSQUEDA DE ERRORES EN APLICACIÓN RIVAL] \
      #v(0.3em)
      #text(fill: rgb("#f5f5f5"), size: 14pt, weight: "medium")[Guerra de Testers - Habitflow]
    ]
  )
]

#v(1.5em)

// Project Metadata
#grid(
  columns: (1.2fr, 1fr),
  gutter: 20pt,
  [
    #block(
      stroke: 0.5pt + rgb("#bdc3c7"),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      fill: rgb("#f8f9fa"),
      [
        #text(weight: "bold", fill: rgb("#2c3e50"))[Información General:] \
        #v(0.5em)
        - *Sistema Evaluado:* Habitflow (Equipo 19)
        - *Versión:* Commit 8f41d4c
        - *Curso:* Pruebas de Software
      ]
    )
  ],
  [
    #block(
      stroke: 0.5pt + rgb("#bdc3c7"),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      fill: rgb("#f8f9fa"),
      [
        #text(weight: "bold", fill: rgb("#2c3e50"))[Evaluadores:] \
        #v(0.3em)
        - Arce Mayhua Leonardo Ruben
        - Gallegos Condori Anette Isabel
        - Jara Mamani Mariel Alisson
        - Quispe Condori, Alvaro Raul
      ]
    )
  ]
)

#v(1em)

#outline(indent: 1.5em)

#v(1.5em)

#let table_theme(columns, header_cells, ..rows) = {
  table(
    columns: columns,
    stroke: 0.5pt + rgb("#bdc3c7"),
    fill: (col, row) => if row == 0 { rgb("#d35400") } else if calc.even(row) { rgb("#f8f9fa") } else { none },
    inset: (x: 8pt, y: 7pt),
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    
    // Header cells
    ..header_cells.map(c => [
      #set text(fill: white, weight: "bold", size: 9pt)
      #c
    ]),
    
    // Row cells
    ..rows.pos().map(c => [
      #set text(size: 8.5pt)
      #c
    ])
  )
}

= Contexto y Alcance de la Evaluación

A continuación se detalla la información del sistema evaluado, la disponibilidad del manual de uso y el alcance definido para el proceso de pruebas de caja blanca y caja negra:

#align(center)[
  #table_theme(
    (1.2fr, 3fr),
    ([Elemento], [Detalle]),
    [*Equipo evaluado*], [Tema 19],
    [*Sistema evaluado*], [Habitflow],
    [*Versión / Commit*], [`8f41d4c` (después se subieron más cambios pero no se tomó en cuenta)],
    [*Manual recibido*], [Sí (#link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/docs/MANUAL_DE_USO.pdf")[Enlace al manual])],
    [*Alcance de pruebas*], [
      Evaluación de Caja Blanca orientada a rutas críticas, límites y validaciones clave:
      - *Controlador y UI:* Validaciones en tiempo real, manejo del límite de días pasados, operaciones CRUD básicas y actualización del dashboard (`MainController.java`, `main.fxml`).
      - *Servicios y Negocio:* Verificación de reglas de invariantes, límite de 1440 mins/día, control de fechas futuras/pasadas y persistencia (`HabitService.java`, `habits.json`).
      - *Modelos y Cálculos:* Programación de fechas activas, registro histórico y cálculo de tasas de completitud/estadísticas (`Habit.java`).
      - *Arranque y Recursos:* Carga limpia de FXML, inyección de dependencias UI y mapeo de eventos.
      
      _Nota: Todos los integrantes aplican exploración cruzada para detectar errores fuera de su módulo asignado._
    ]
  )
]

= Estrategia de Pruebas: Partición de Equivalencia (PE)

En base a las reglas de negocio del sistema rival (Habitflow), se definieron las siguientes particiones de equivalencia para los diferentes atributos de un hábito. Los resultados se obtuvieron tanto de la suite de pruebas unitarias (`HabitServiceTest`) que pasaron exitosamente como de la validación integral de la UI.

#align(center)[
  #table_theme(
    (1fr, 1.2fr, 1.2fr, 1.2fr, 1.4fr),
    ([Componente], [Clase de Equivalencia], [Valor de Prueba], [Resultado Esperado], [Resultado Obtenido]),
    
    [Nombre del Hábito], [Válida (Texto único)], ["Hacer Ejercicio"], [Aceptado], [Pasa (Aceptado)],
    [Nombre del Hábito], [Inválida (Vacío)], ["" o "   "], [Rechazado], [Pasa (Rechazado)],
    [Nombre del Hábito], [Inválida (Duplicado)], ["Meditar" (ya existe)], [Rechazado], [Pasa (Rechazado)],
    
    [Días de la semana], [Válida (1 a 7 días)], [Lunes, Miércoles], [Aceptado], [Pasa (Aceptado)],
    [Días de la semana], [Inválida (0 días)], [Ninguno], [Rechazado], [Pasa (Rechazado)],

    [Duración diaria], [Válida (1 - 1440 min)], [60 minutos], [Aceptado], [Pasa (Aceptado)],
    [Duración diaria], [Inválida (<= 0 min)], [-10 minutos], [Rechazado], [Pasa (Rechazado)],
    [Duración diaria], [Inválida (> 1440 min)], [1500 minutos], [Rechazado], [Pasa (Rechazado)],

    [Duración acumulada], [Válida (Suma <= 1440)], [Suma = 1440 min], [Aceptado], [Pasa (Aceptado)],
    [Duración acumulada], [Inválida (Suma > 1440)], [Suma = 1450 min], [Rechazado], [Falla (Rechaza en UI pero muta la memoria - Bug 2)],

    [Fecha de inicio], [Válida (Pasado o Hoy)], [Fecha de hoy], [Aceptado], [Pasa (Aceptado)],
    [Fecha de inicio], [Inválida (Futuro)], [Mañana], [Rechazado], [Pasa (Rechazado)],

    [Días en el pasado], [Válida (0 a N programados)], [2 (de 5 programados)], [Aceptado], [Pasa (Aceptado)],
    [Días en el pasado], [Inválida (Negativo)], [-1], [Rechazado], [Pasa (Rechazado)],
    [Días en el pasado], [Inválida (> N programados)], [6 (de 5 programados)], [Rechazado], [Pasa (Rechazado)],
    [Días en el pasado], [Inválida (> 0 si inicia hoy)], [1 (iniciando hoy)], [Rechazado], [Pasa (Rechazado)]
  )
]

= Estrategia de Pruebas: Análisis de Valores Límite (AVL)

Se aplicó la técnica de Análisis de Valores Límite sobre las restricciones numéricas y de fechas del sistema rival (Habitflow). Al igual que los casos PE, los resultados provienen de la suite de `HabitServiceTest` y la validación en caja blanca del flujo de usuario.

#align(center)[
  #table_theme(
    (1fr, 1.2fr, 1.2fr, 1.2fr, 1.4fr),
    ([Componente], [Límite Evaluado], [Valor de Prueba], [Resultado Esperado], [Resultado Obtenido]),
    
    [Duración diaria], [Mínimo válido], [1 minuto], [Aceptado], [Pasa (Aceptado)],
    [Duración diaria], [Justo debajo del mínimo], [0 minutos], [Rechazado], [Pasa (Rechazado)],
    [Duración diaria], [Máximo válido], [1440 minutos (24h)], [Aceptado], [Pasa (Aceptado)],
    [Duración diaria], [Justo sobre el máximo], [1441 minutos], [Rechazado], [Pasa (Rechazado)],

    [Duración acumulada], [Máximo válido (Suma)], [1440 minutos totales], [Aceptado], [Pasa (Aceptado)],
    [Duración acumulada], [Justo sobre el máximo], [1441 minutos totales], [Rechazado], [Falla (Muta memoria y calcula tiempos sobre el límite - Bug 2)],

    [Fecha de inicio], [Límite máximo (Hoy)], [Hoy], [Aceptado], [Pasa (Aceptado)],
    [Fecha de inicio], [Justo sobre el máximo (Futuro)], [Hoy + 1 día], [Rechazado], [Pasa (Rechazado)],

    [Días en el pasado], [Mínimo válido], [0], [Aceptado], [Pasa (Aceptado)],
    [Días en el pasado], [Justo debajo del mínimo], [-1], [Rechazado], [Pasa (Rechazado)],
    [Días en el pasado], [Máximo válido], [N (Total programados)], [Aceptado], [Pasa (Aceptado)],
    [Días en el pasado], [Justo sobre el máximo], [N + 1], [Rechazado], [Pasa (Rechazado)],

    [Completitud], [Máximo matemático], [100% (1.0)], [Mantenerse en <= 100%], [Falla (Alcanza un valor de 125% al editar - Bug 4)]
  )
]

= Catálogo Unificado de Errores

A continuación se presenta el catálogo detallado de los errores identificados en el sistema Habitflow, clasificados por su tipo y nivel de severidad.

#align(center)[
  #table_theme(
    (1fr, 2.5fr, 1.2fr, 1fr),
    ([ID], [Descripción del error], [Tipo], [Severidad]),
    
    [BUG-01],
    [Condición de carrera al inicializar el formulario. La carga prematura de la fecha detona listeners con datos desactualizados de la UI, requiriendo parches de concurrencia inestables.],
    [Lógico / UI],
    [Media],

    [BUG-02],
    [Mutación prematura en memoria sin transaccionalidad. El controlador altera la instancia viva del hábito antes de validar la regla de 24 horas. Corrompe los tiempos diarios estimados mostrando valores fuera de límite (e.g. 26 horas).],
    [Lógico / Validación],
    [Alta],

    [BUG-03],
    [Descoordinación de estados reactivos. El spinner de "Días cumplidos" reacciona a cambios de fecha y se habilita automáticamente, ignorando la restricción de que debería estar inhabilitado si el sistema está en modo edición.],
    [UI],
    [Baja],

    [BUG-04],
    [Incoherencia Matemática y Fallo lógico en el cálculo de completitud. Retirar un día de la programación de un hábito completado no descuenta el logro, generando tasas imposibles (e.g. 120.0%, 125%).],
    [Lógico / Aritmético],
    [Alta],

    [BUG-05],
    [Bloqueo Permanente del Guardado tras Medianoche. El sistema guarda la "fecha actual" al inicio y no la actualiza. Si pasa la medianoche e intentas crear un hábito para "Hoy", el sistema cree que es en el futuro y deshabilita permanentemente el botón de guardado.],
    [Lógico / UI],
    [Crítica],

    [BUG-06],
    [Inyección de Basura y Excepciones Gráficas (`DateTimeParseException`). Permitir editar directamente la fecha de inicio con texto sin sanitizar ocasiona que la UI intente procesar datos no estructurados y arroje stack traces, rompiendo el hilo gráfico.],
    [Validación / UI],
    [Alta]
  )
]

= Evidencias y Pasos de Reproducción

// Definición de URL base para acortar enlaces de GitHub
#let github_base = "https://github.com/rikich3/lab_pru_soft/tree/main/lab5/"
#let controller_url = github_base + "src/main/java/com/tracker/controllers/MainController.java"

#align(center)[
  #table_theme(
    (1fr, 4fr),
    ([Bug ID], [Evidencia / Pasos]),
    
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
]
