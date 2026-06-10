En base a las reglas de negocio del sistema rival (Habitflow), se definieron las siguientes particiones de equivalencia para los diferentes atributos de un hábito. Los resultados se obtuvieron tanto de la suite de pruebas unitarias (`HabitServiceTest`) que pasaron exitosamente como de la validación integral de la UI.

#table(
  columns: (1.2fr, 1.2fr, 1.2fr, 1.2fr, 1.2fr),
  [Componente], [Clase de Equivalencia], [Valor de Prueba], [Resultado Esperado], [Resultado Obtenido],
  
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
