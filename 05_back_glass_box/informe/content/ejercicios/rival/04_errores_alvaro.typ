==== Errores detectados por Alvaro Quispe

#table(
  columns: (1fr, 2.5fr, 1.2fr, 1fr),
  [ID], [Descripción del error], [Tipo], [Severidad],
  [BUG-AQ-01],
  [Condición de carrera al inicializar el formulario. La carga prematura de la fecha detona listeners con datos desactualizados de la UI.],
  [Lógico / UI],
  [Media],

  [BUG-AQ-02],
  [Mutación prematura en memoria sin transaccionalidad. El controlador altera la instancia viva del hábito antes de que el servicio valide la regla de 24 horas.],
  [Lógico / Validación],
  [Alta],

  [BUG-AQ-03],
  [Descoordinación de estados reactivos. El spinner de "Días cumplidos" reacciona a cambios de fecha y se habilita, ignorando si el sistema está en modo edición.],
  [UI],
  [Baja],

  [BUG-AQ-04],
  [Fallo lógico en el cálculo de completitud. Retirar un día de la programación de un hábito previamente completado no descuenta el logro, generando tasas > 100%.],
  [Lógico],
  [Alta],
)

