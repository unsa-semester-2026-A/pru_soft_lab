A continuación se muestran los prompts utilizados para el desarrollo del proyecto, el equipo usó `Gemini CLI` por contar con el plan estudiantil:

#table(
columns: (0.8fr, 4fr, 1.8fr),
align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

[#strong("Herramienta/Asistente")], [#strong("Prompt")], [#strong("Uso")],

[Gemini], [Actualiza el archivo de configuración con el script de automatización y asegura compatibilidad multiplataforma...], [Actualización de README.md y compatibilidad multiplataforma],
[Gemini], [Mira los dos últimos commits de persistencia y dime si cumplen con el diseño del Reporte Técnico Final...], [Auditoría de código de persistencia frente al diseño técnico],
[Gemini], [Haz que la automatización sea la base del entorno... documenta el uso de comandos estándar en el archivo principal...], [Robustecimiento del `Makefile` y documentación de entorno],
[Gemini], [Entiende el alcance del proyecto e implementa la lógica financiera compleja en la capa de dominio...], [Implementación de invariantes en `entities.py` y pruebas AVL],
[Gemini], [Refactora el dominio para que todo esté en inglés, manteniendo exclusivamente la interfaz gráfica en español...], [Refactorización de nombres de variables y entidades a inglés],
[Gemini], [Stack y Herramientas: aplica análisis estático estricto con Ruff y Pyright bajo la convención de docstrings de Google...], [Configuración de Ruff, Pyright y tipado estático estricto],
[Gemini], [Procede con el paso de integración final conectando todas las capas desacopladas de la aplicación...], [Ensamblaje del sistema en `config/bootstrap.py`],
[Gemini], [Estructura los mensajes de confirmación de cambios siguiendo el estándar internacional de Conventional Commits...], [Estrategia de Git mediante commit estructurados],
[Gemini], [Evoluciona los flujos principales en la interfaz gráfica agregando operaciones de gestión para cuentas y presupuestos...], [Evolución de flujos lógicos en interfaz `customtkinter`],
[Gemini], [Optimiza la respuesta visual implementando notificaciones dinámicas temporales que den feedback al usuario...], [Notificaciones dinámicas temporales en la GUI],
[Gemini], [Separa la lógica agregando un cálculo en tiempo de ejecución (runtime) del consumo presupuestario en base al histórico...], [Cálculo en runtime del consumo presupuestario en el Core],
[Gemini], [Evalúa la suite de pruebas unitarias aplicando particiones de equivalencia y análisis de valores límite con Pytest...], [Optimización de suite de pruebas unitarias mediante `pytest`],
[Gemini], [Genera el esquema base del documento técnico final y el manual rápido de uso estructurado en Markdown...], [Redacción de documentación técnica y manual en Markdown],
[Gemini], [Expande los casos de prueba registrados e incrementa la cobertura técnica detallando los escenarios PE y AVL...], [Estandarización con Prettier y expansión de casos PE/AVL],
[Gemini], [Depura el manual técnico eliminando las especificaciones de entidades obsoletas para reflejar el diseño final...], [Depuración de especificaciones de diseño en documentación],
[Gemini], [Corrige las referencias relativas de los recursos visuales para garantizar un renderizado correcto al exportar...], [Ajuste de rutas de imágenes para compilación con Pandoc],
[Gemini], [Integra los nuevos escenarios avanzados en la suite y ejecuta la validación global de calidad de código...], [Verificación integral de calidad de código mediante `make check`],
[Gemini], [Sincroniza el estado actual del repositorio con la rama principal asegurando un historial limpio y ordenado...], [Cierre del ciclo de desarrollo y sincronización con origen]
)
