Se escribió dos archivos, uno para el #link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/docs/MANUAL_DE_USO.pdf")[manual de usuario] y otro para el #link("https://github.com/unsa-semester-2026-A/pru_soft_lab/blob/main/05_back_glass_box/development/docs/DOCUMENTO_TECNICO.pdf")[Documento técnico], a continuación se presenta un resumen de su contenido:

- *Cómo ejecutar:*

Desde la raíz del proyecto, inicializa la aplicación utilizando el entorno gestionado por `uv`, o alternativamente con `make run`

```bash
  uv run python -m finance
  # alternativamente
  make run
```

- *Flujo básico de uso:*
  1. *Configuración inicial:* Registrar al menos una cuenta (origen/destino de fondos) y las categorías necesarias.
  2. *Planificación:* Asignar límites de presupuesto a las categorías. El sistema las agrupa temporalmente (Pasados, Activos, Futuros) y marca su estado (verde para cumplido, rojo para excedido).
  3. *Operación continua:* Registrar transacciones en el historial. Los ingresos (`INCOME`) suman saldo y no requieren categoría; los gastos (`EXPENSE`) exigen una categoría y restan saldo.


#figure(
  image("/development/docs/img/pantalla_al_iniciar_programa.png", width: 80%),
  caption: [Pantalla principal de inicio del sistema.],
)

#figure(
  image("/development/docs/img/formualrio de transaccion vacio.png", width: 80%),
  caption: [Formulario de registro de nuevas transacciones.],
)


- *Datos válidos y restricciones:*
  Las restricciones aseguran la integridad del sistema a nivel de dominio y aplicación, validadas exhaustivamente mediante Particiones de Equivalencia y Análisis de Valores Límite.

  #table(
    columns: (1.2fr, 2.5fr, 1.3fr),
    [Entidad / Ámbito], [Regla de Validación], [Excepción],
    [*User*], [El correo electrónico debe contener un carácter '@'.], [`ValueError`],
    [*Account / Category*],
    [Los nombres, bancos y categorías no pueden estar vacíos ni compuestos solo por espacios.],
    [`ValueError`],

    [*Budget*],
    [El límite de monto debe ser mayor a cero. El mes debe estar entre 1 y 12, y el año ser mayor o igual a 2000 (UI).],
    [`ValueError`],

    [*Transaction (Base)*], [El monto ingresado debe ser mayor a cero y la descripción es obligatoria.], [`ValueError`],
    [*Transaction (Tipo)*],
    [La operación `EXPENSE` requiere una categoría asignada; `INCOME` no permite categoría.],
    [`ValueError`],

    [*Negocio (Saldo)*],
    [El monto de un gasto no puede exceder el saldo actual disponible en la cuenta seleccionada.],
    [`InsufficientFundsError`],
  )

  - *Eliminación Segura:* La eliminación de cuentas o categorías aplica un "soft delete" lógico (`is_active=False`), ocultándolas en la UI pero manteniéndolas en el historial para evitar inconsistencias.


