#table(
  columns: (1.5fr, 2.5fr),
  [*Elemento*], [*Detalle*],
  [Lenguaje], [Python == 3.12],
  [Framework UI], [CustomTkinter (apoyado por `darkdetect`)],
  [Testing], [pytest (v8.1.1)],
  [Automatización], [Makefile, Git hooks (pre-push) y `uv` como gestor de paquetes],
)

- *Herramientas adicionales:*
  - *Type Checker:* Pyright, configurado para requerir tipado estricto en parámetros y valores de retorno, previniendo errores en tiempo de ejecución.
  - *Linter y Formateador:* Ruff, encargado de mantener el formato del código (88 caracteres por línea) y validar la documentación bajo la convención de Google.
  - *Control de Versiones:* Git, apoyado por un hook `pre-push` en Shell que ejecuta `make check` para bloquear envíos de código que no superen las pruebas locales o el análisis estático.
