---
name: distribute work using comments
description: Guidelines to distribute tasks and leave notes using comments instead of rendering them in the document text
---

When distributing tasks, assigning work, or leaving notes/reminders, you MUST write them as comments in the source files (e.g., Typst, Python, Bash, etc.) instead of adding them as visible document content. This prevents cluttering the final output and saves manual cleanup work.

### Comment Conventions:
For Typst, use double slashes `//` for single-line comments or `/* ... */` for block comments:
- **Task Assignment / TODO**: Use `// TODO(username): description of the task`
- **General Notes**: Use `// NOTE: important context or explanation`
- **Warnings**: Use `// WARNING: critical caution or constraint`
- is not allowed do something like this: `Ejercicio 1: Automatización con Supertest (Asignado a: Leonardo Ruben Arce Mayhua)`

### Create modular files

- Since the document may become large, is important to split it into several files that can included from a parent file. This help to avoid merge conflicts  and
  to keeps the project organized.


### Example:
Instead of writing visible text in the document:
> *Tarea 1: Alvaro - Implementar sección de pruebas.*
> *Tarea 2: Christian - Diseñar diagramas UML.*

You MUST write:
```typst
// TODO(Alvaro): Implementar sección de pruebas
// TODO(Christian): Diseñar diagramas UML
```

Do not put lists of tasks, pending assignments, or draft outlines in the compiled document output unless the user explicitly requests a visible section or table for task distribution.
