# Reporte Técnico Final: Sistema de Finanzas Personales

## 1. Desmitificando la Arquitectura Hexagonal (Puertos y Adaptadores)

La confusión sobre la Arquitectura Hexagonal (creada por Alistair Cockburn)
surge porque muchos frameworks le añaden capas innecesarias. El concepto
original es directo y tiene un solo objetivo: **aislar la lógica de negocio para
que la aplicación pueda ser probada sin depender de bases de datos, interfaces
gráficas o servicios externos.**

El sistema se divide en tres partes fundamentales:

### El Hexágono (Núcleo / Core)

Es el centro de la aplicación. Aquí viven las reglas de negocio (Entidades) y
los casos de uso (Servicios). **Regla de oro:** El Hexágono no sabe nada del
mundo exterior. No sabe si están usando una base de datos en memoria, SQLite o
PostgreSQL. No sabe si el usuario interactúa por consola (CLI) o interfaz
gráfica (Tkinter). Tampoco importa librerías externas que no sean parte estándar
de Python.

### Los Puertos (Los Contratos)

Son las fronteras del Hexágono. En Python, no usamos la palabra reservada
`interface`, usamos `typing.Protocol` o clases abstractas (`abc`).

- **Puertos de Entrada (Inbound/Driving):** Definen lo que la aplicación _puede
hacer_. Es la botonera que el núcleo expone hacia el exterior (ej.
`gestionar_transacciones`).
- **Puertos de Salida (Outbound/Driven):** Definen lo que la aplicación
_necesita_ del exterior para funcionar (ej. "necesito un lugar para guardar esta
cuenta", definido en un `AccountRepository`).

### Los Adaptadores (Los Traductores)

Viven fuera del Hexágono. Traducen el lenguaje del mundo real al lenguaje que
entienden los puertos.

- **Adaptadores de Entrada (Driving Adapters):** Los actores que inician la
acción. Aquí vive la Interfaz de Usuario (UI) en Python o los tests de
integración. Toman los clics o comandos del usuario y llaman a los Puertos de
Entrada.
- **Adaptadores de Salida (Driven Adapters):** La infraestructura. Aquí viven la
base de datos en memoria (`MemoryRepository`) o en SQLite. Implementan los
métodos definidos en los Puertos de Salida.

---

## 2. Estructura de Directorios y Pruebas Co-localizadas

La aplicación se estructura como un módulo instalable de Python. Las pruebas
(`tests`) se ubican exactamente al lado del archivo que están evaluando. Esto
mejora la navegación y asegura que quien modifique un componente, actualice su
prueba inmediatamente.

```text
finanzas_app/
├── pyproject.toml             # Configuración del módulo de Python
└── finanzas/
    ├── __init__.py
    ├── __main__.py            # Punto de entrada (python -m finanzas)
    ├── config/                # Inyección de dependencias
    │   ├── bootstrap.py       # Une los adaptadores con el core
    │
    ├── core/                  # EL HEXÁGONO (Sin dependencias externas)
    │   ├── domain/
    │   │   ├── entities.py    # Dataclasses: User, Account, Category, Budget, Transaction
    │   │   └── test_entities.py
    │   ├── ports/
    │   │   ├── inbound.py     # Protocolos de casos de uso
    │   │   └── outbound.py    # Protocolos de repositorios
    │   └── app/
    │       ├── services.py    # Orquestación (implementa inbound, usa outbound)
    │       └── test_services.py
    │
    └── adapters/              # EL MUNDO EXTERIOR
        ├── inbound/
        │   └── ui_python/     # Interfaz de usuario (Tkinter o CLI)
        │       ├── app_ui.py
        │       ├── views.py   # Pantallas (sin lógica de negocio)
        │       └── controllers.py # Llama a finanzas.core.ports.inbound
        └── outbound/
            ├── db_memory/     # Base de datos temporal (diccionarios/listas)
            │   ├── memory_repos.py
            │   └── test_memory_repos.py
            └── db_sqlite/     # Base de datos real (opcional)
                ├── sqlite_repos.py
                └── test_sqlite_repos.py

```

---

## 3. Despliegue de Componentes y Responsabilidades

Para trabajar en paralelo sin generar conflictos, cada componente tiene un rol
estrictamente definido.

### A. Entidades de Dominio (`core/domain/entities.py`)

Son `dataclasses` de Python. Aquí residen **todas las reglas de negocio e
invariantes**.

- **Responsabilidad:** Proteger la integridad de los datos.
- **Regla:** Si se intenta crear una entidad con datos inválidos o ejecutar una
acción prohibida, la entidad debe lanzar una excepción de Python inmediatamente
(`ValueError`, `InsufficientFundsError`).
- **Ejemplo de lógica:** `Account.register_expense(amount)` valida que el
`amount` sea mayor a 0 y que `current_balance - amount >= 0`. Si falla, arroja
error.

### B. Puertos (`core/ports/outbound.py` y `inbound.py`)

Son archivos que solo contienen definiciones de clases vacías con tipado (usando
`typing.Protocol`).

- **Responsabilidad:** Establecer las firmas de los métodos (qué reciben y qué
devuelven).
- **Regla:** El equipo debe acordar estas firmas primero. Una vez definidas, un
miembro puede programar la UI y otro la Base de Datos simultáneamente, porque
saben exactamente cómo se comunicarán con el core.

### C. Servicios de la Aplicación (`core/app/services.py`)

Es la capa de orquestación.

- **Responsabilidad:** Ejecutar los pasos lógicos de los flujos de uso (ej.
Crear Cuenta, Registrar Transacción).
- **Regla - Sin Estado (Stateless):** Estos servicios no guardan información en
memoria (no hay variables globales de estado aquí). Reciben datos primitivos,
buscan las entidades usando los puertos de salida, mandan a ejecutar la acción
en la entidad y guardan el resultado.

### D. Adaptadores de Salida (ej. `adapters/outbound/db_memory/memory_repos.py`)

Son clases concretas que implementan los contratos definidos en los Puertos de
Salida.

- **Responsabilidad:** Persistir y recuperar los datos.
- **Regla:** Para llegar a la entrega del lunes y asegurar que las pruebas no
fallen, el repositorio principal será en memoria (usando listas o diccionarios
nativos de Python). La conexión a una base de datos real (SQLite) es secundaria.

### E. Adaptadores de Entrada (ej. `adapters/inbound/ui_python/`)

La interfaz gráfica o de consola.

- **Responsabilidad:** Capturar la interacción del usuario y mostrar datos. El
estado de la vista (qué pantalla está abierta) se maneja aquí, no en el núcleo.
- **Regla:** La UI es tonta. No calcula presupuestos ni valida si hay fondos
suficientes. La UI manda los datos al Servicio y captura las excepciones (ej.
`InsufficientFundsError`) para mostrar un mensaje rojo en la pantalla.

---

## 4. Reglas Estrictas de Implementación para el Equipo

Para evitar refactorizaciones de última hora antes del lunes, todos los miembros
del equipo deben cumplir estas cuatro reglas:

1. **Regla de la Dependencia (Hacia Adentro):** El código dentro de la carpeta
`core` jamás debe importar nada de la carpeta `adapters`. Si un archivo en
`core` hace un `import adapters...`, la arquitectura está rota.
2. **Validaciones Tempranas en Dominio:** No llenen los `services.py` de
declaraciones `if/else`. Las validaciones de negocio van en los métodos de las
clases dentro de `entities.py`.
3. **Desarrollo Orientado a Pruebas Locales:** Desarrollen y prueben usando
`db_memory`. Esto garantiza pruebas que corren en milisegundos.
4. **Inyección de Dependencias Limpia:** La instanciación de las clases ocurre
en `config/bootstrap.py`. Este es el único archivo que conoce todo el sistema,
donde se le inyecta el `MemoryRepository` al `FinanceService`, y el
`FinanceService` a la Interfaz de Usuario.
