Se aplicó la técnica de Análisis de Valores Límite sobre las restricciones numéricas y de fechas del sistema rival (Habitflow). Al igual que los casos PE, los resultados provienen de la suite de `HabitServiceTest` y la validación en caja blanca del flujo de usuario.

#table(
  columns: (1.2fr, 1.2fr, 1.2fr, 1.2fr, 1.2fr),
  [Componente], [Límite Evaluado], [Valor de Prueba], [Resultado Esperado], [Resultado Obtenido],
  
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
