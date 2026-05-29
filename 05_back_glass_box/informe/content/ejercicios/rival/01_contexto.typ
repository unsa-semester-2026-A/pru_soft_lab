#table(
  columns: (1fr, 3fr),
  [*Elemento*], [*Detalle*],
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
