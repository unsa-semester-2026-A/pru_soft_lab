==== Catálogo Unificado de Errores

#table(
  columns: (1fr, 2.5fr, 1.2fr, 1fr),
  [ID], [Descripción del error], [Tipo], [Severidad],
  
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