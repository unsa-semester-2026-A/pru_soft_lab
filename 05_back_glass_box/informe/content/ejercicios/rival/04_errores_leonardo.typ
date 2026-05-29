==== Errores detectados por Leonardo Arce (Persistencia y Modelo)

#table(
  columns: (1fr, 2.5fr, 1.2fr, 1fr),
  [ID], [Descripción del error], [Tipo], [Severidad],

  [BUG-LR-01],
  [La fecha que utiliza el sistema es la de la computadora. Si esta está errónea, el sistema también lo estará. No hay validación contra una fuente de tiempo confiable.],
  [Lógico/Dependencia],
  [Media],

  [BUG-LR-02],
  [Inconsistencia UI-Modelo: La interfaz no permite marcar fechas futuras, pero el método setCompletedOn() del modelo sí lo permite. Un atacante o llamada directa al modelo puede corromper datos.],
  [Lógico/Validación],
  [Alta],

  [BUG-LR-03],
  [Pérdida de historial al editar: Al crear un hábito en fecha pasada y luego actualizarlo a la fecha actual, el avance (historial de completaciones) se borra completamente.],
  [Lógico/Persistencia],
  [Alta],
)