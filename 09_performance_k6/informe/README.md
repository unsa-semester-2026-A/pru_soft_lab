# Plantilla de Laboratorio en Typst

Esta plantilla está diseñada para la creación de informes de laboratorio utilizando Typst. Ofrece un diseño profesional y estandarizado.

## Estructura de archivos y configuración
- `laboratorio.typ`: Archivo principal donde se estructura el informe de laboratorio.
- `informe/config.typ`: Archivo de configuración que contiene las variables principales del laboratorio (título, autor, semestre, nombre de la fuente `textFont`, etc.). **Modificar este archivo para cada nuevo laboratorio.**
- `informe/content/`: Contiene el contenido del informe dividido en secciones (`1_ejercicios.typ`, `2_cuestionario.typ`, `3_conclusiones.typ`).
- `informe/util/`:
  - `util.typ`: Funciones utilitarias para generar componentes visuales de la plantilla.
  - `create_context.sh`: Script útil para recopilar contexto del repositorio.
- `agents/`: Directorio de personalizaciones y skills para asistentes de IA. Contiene:
  - `skills/register_command_output/scripts/cap.sh`: Script para la captura o ejecución de procesos en segundo plano. **Nota: No se pueden utilizar scripts interactivos con `cap.sh` ya que espera procesos no bloqueantes o que se ejecuten automáticamente.**


## Bloques de código (Codeblocks)
La configuración de la plantilla personaliza automáticamente los bloques de código usando `#show raw.where(block: true)`. Esto asegura un fondo gris claro, bordes redondeados y texto oscuro para un contraste óptimo, sin necesidad de usar funciones adicionales.

### Opciones para insertar código:
1. **Código en línea o bloques directos:**
   Puedes usar la sintaxis estándar de Typst. Automáticamente tomará el formato de la plantilla.
   ````typst
   ```java
   System.out.println("Hola Mundo");
   ```
   ````
2. **Leyendo desde un archivo externo:**
   Para incrustar código que está en otro archivo, utiliza la función `raw` con `read` incorporado de Typst:
   ```typst
   #raw(read("ruta/al/archivo.ext"), lang: "ext")
   ```

### Ubicación del código fuente:
Para que las inteligencias artificiales y scripts automáticos tengan un contexto claro, sigue esta convención:
- Si el código es **material exclusivo y de apoyo para el laboratorio** (como archivos proporcionados por el docente como ejemplos, esqueletos o plantillas iniciales), colócalos en el directorio `informe/src/lst/` y léelos en Typst usando `#raw(read(...))`.
- Si el código fuente es el **resultado o resolución final** de los ejercicios realizados por ti, dicho código debe estar situado en un subdirectorio propio creado específicamente para resolver esos ejercicios. En este caso, **no lo ubiques en `informe/src/lst/`**, sino que se debe citar o referenciar directamente desde su directorio de solución en los archivos correspondientes dentro de `informe/content/`.

## Integración con IA
Esta plantilla está optimizada para ser modificada fácilmente tanto de manera manual como a través de herramientas de inteligencia artificial (ej. Gemini CLI). La separación de configuraciones en `config.typ` y el uso de las funciones integradas de Typst facilitan el mantenimiento de la plantilla y minimizan los conflictos de dependencias.
