# Planificación y Repartición de Tareas - Laboratorio 08

Este documento detalla la planificación y la asignación de responsabilidades para el **Laboratorio 08: Pruebas de Integración (API Testing con Postman y Supertest)** para el grupo **Catarinas**.

---

## 👥 Resumen del Equipo y Roles

| Integrante                     | Username Git      |  Tarea Asignada                                                                                       |
| :----------------------------- | :---------------- |  :--------------------------------------------------------------------------------------------------- |
| **Leonardo Ruben Arce Mayhua** | `Larcem`          |  **Ejercicio 1: Automatización con Supertest** (`ejercicio1_leo.typ`)                                 |
| **Mariel Alisson Jara Mamani** | `Alsnj20`         |  **Ejercicio 2: Pruebas de Integración - alf.io (Frontera y Resiliencia)** (`ejercicio2_alisson.typ`) |
| **Álvaro Raúl Quispe Condori** | `alvaro9rqc`      |  **Ejercicio 2: Pruebas de Integración - alf.io (Inyección de Fallas)** (`ejercicio2_alvaro.typ`)     |
| **Anette Gallegos**            | `Anette-Gallegos` |  **Cuestionario, Conclusiones y Compilación Final** (`cuestionario.typ`, `conclusiones.typ`)          |

> [!NOTE]
> Para evitar conflictos al momento de unir el trabajo (merge conflicts en Git), el documento se ha **modularizado**. Cada integrante debe trabajar **únicamente** en su archivo asignado dentro de `informe/content/`. El archivo principal `ejercicios.typ` se encargará de unir todo automáticamente.

---

## 📝 Plan de Acción Detallado

### 💻 Ejercicio 1: Automatización con Supertest

- **Asignado a:** Leonardo Arce (`Larcem`)
- **Archivo de trabajo:** `informe/content/ejercicio1_leo.typ`

> [!WARNING]
> **Instrucciones para Leonardo:** Dado que debes entregar un código con altos estándares (arquitectura limpia, aserciones estrictas), **debes copiar y pegar el siguiente prompt exacto en tu Inteligencia Artificial** para generar la base de tu código:

#### 🤖 PROMPT PARA LA IA DE LEONARDO:

```text
Actúa como un Ingeniero de Software Senior especialista en Testing de API. Necesito que generes el código para el Ejercicio 1 de mi laboratorio de Pruebas de Software. El stack es Node.js, Express, Jest y Supertest.

Requisitos de la API (app.js):
1. Elige una temática: "Catálogo de Videojuegos". Usa persistencia en memoria (array local).
2. Endpoints:
   - POST /api/videojuegos: Crea videojuego (id dinámico, titulo, genero, precio, stock).
   - GET /api/videojuegos/:id: Devuelve videojuego por ID o 404.
   - PUT /api/videojuegos/:id/stock: Modifica cuantitativamente el stock restando una cantidad. Si el stock es insuficiente, devuelve 400.
   - GET /api/videojuegos: Devuelve la lista completa.

Requisitos de las Pruebas (tema_libre.test.js):
1. Flujo de Persistencia Cruzada (POST + GET).
2. Simulación de Modificación de Estado (PUT + GET confirmando el nuevo stock).
3. Validación de Robustez (Edge Cases): Enviar un POST con datos malformados y asertar que devuelve HTTP 400.

Genera el código en dos bloques:
- Bloque 1: app.js (exportando app, sin el listen).
- Bloque 2: tema_libre.test.js
```

Una vez que obtengas el código y lo pruebes exitosamente en tu PC, documenta los resultados en tu archivo `ejercicio1_leo.typ`.

---

### 🔍 Ejercicio 2: Pruebas de Integración del Proyecto Final (`alf.io`)

El laboratorio pide realizar pruebas de integración (Mapeo de Frontera, Inyección de Fallas de Interfaz) a la arquitectura del proyecto de fin de curso. Se ha determinado diseñar y documentar **casos de prueba enfocados en la API REST (Postman o MockMvc/TestRestTemplate)** simulando las peticiones a los endpoints del proyecto real.

- **Parte 1 (Asignada a Alisson `Alsnj20`):**
  - **Archivo de trabajo:** `informe/content/ejercicio2_alisson.typ`
  - **Tareas:**
    1. **Mapeo de la Frontera**: Documentar cómo la capa REST (ej. `ReservationApiV2Controller`) actúa como puente hacia los Managers y PostgreSQL.
    2. **Caso 3 (Resiliencia):** Diseñar y ejecutar (o documentar en base a los tests del repositorio, como `StripeReservationFlowIntegrationTest`) un test que evalúe qué ocurre cuando hay un _Timeout_ o fallo de conexión/firma con la pasarela de pagos simulada (Webhook). Completar la tabla de discrepancias con el resultado real.

- **Parte 2 (Asignada a Álvaro `alvaro9rqc`):**
  - **Archivo de trabajo:** `informe/content/ejercicio2_alvaro.typ`
  - **Tareas:**
    1. **Caso 1 (Sintáctico):** Diseñar/ejecutar una petición (ej. usando Postman hacia la API local de `alf.io`) enviando datos de reserva incompletos o malformados y registrar cómo la API rechaza el payload con error `400 Bad Request` o `422 Unprocessable Entity`.
    2. **Caso 2 (Semántico):** Mandar una petición sintácticamente válida pero que rompa una regla de negocio (ej. reservar tickets de una categoría "oculta" sin token válido). Registrar el resultado real en la tabla de discrepancias.

---

### 📝 Cuestionario, Conclusiones y Compilación

- **Asignada:** Anette Gallegos (`Anette-Gallegos`)
- **Archivos de trabajo:** `informe/content/cuestionario.typ`, `informe/content/conclusiones.typ`

**Acciones a tomar:**

1. **Cuestionario:** Responder detalladamente las 5 preguntas teóricas ubicadas en `cuestionario.typ` basándote en la teoría de la guía y los libros (Myers/Spillner).
2. **Conclusiones:** Redactar 3 conclusiones sobre lo aprendido en la práctica de integración en `conclusiones.typ`.
3. **Referencias:** Añadir las citas en `informe/references.bib` en formato BibTeX y citarlas apropiadamente usando la sintaxis de Typst `@referencia`.
4. **Compilación Final:** Cuando todos terminen, compilar el reporte en PDF:
   ```bash
   typst compile laboratorio.typ laboratorio.pdf
   ```
5. Revisar que no hayan errores de renderizado.
