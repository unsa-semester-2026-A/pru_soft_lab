- *Arquitectura:* El sistema implementa una Arquitectura Hexagonal (Puertos y Adaptadores) basada en el libro de @Cockburn2024-jx para aislar estrictamente la lógica de negocio de las dependencias externas. El flujo obedece la regla de dependencia hacia el centro, garantizando que el núcleo sea agnóstico respecto a bases de datos, frameworks o interfaces, lo que maximiza su testabilidad.

- *Componentes clave:*
  - *Core (Núcleo):* Contiene las entidades de dominio (invariantes y reglas de negocio) y los servicios de aplicación (orquestación lógica sin estado). No posee dependencias externas.
  - *Puertos:* Contratos definidos mediante protocolos (`typing.Protocol`) que establecen las fronteras de entrada (casos de uso expuestos) y salida (necesidades de infraestructura).
  - *Adaptadores:* Implementaciones concretas de los puertos. Los adaptadores de salida manejan la infraestructura externa (ej. repositorios en memoria), mientras que los de entrada inician la ejecución del núcleo.
  - *UI (Interfaz de Usuario):* Un adaptador de entrada pasivo. Captura interacciones y renderiza respuestas, delegando cualquier validación lógica o cálculo directamente a la capa de servicios.

- *Esquema estructural:* Árbol de directorios principal, omitiendo archivos de caché y configuración del entorno para mayor claridad.

```text
.
├── docs/                  # Documentación técnica y manuales de usuario
└── finance/               # Módulo principal del sistema
    ├── adapters/          # EL MUNDO EXTERIOR (Traductores)
    │   ├── inbound/       # Adaptadores de entrada (Iniciadores)
    │   │   └── ui_python/ # Interfaz gráfica y vistas (app_ui.py, views.py)
    │   └── outbound/      # Adaptadores de salida (Infraestructura)
    │       └── db_memory/ # Repositorios de datos y persistencia en memoria
    ├── config/            # Inyección de dependencias y ensamblaje (bootstrap.py)
    └── core/              # EL HEXÁGONO (Totalmente aislado)
        ├── app/           # Orquestación de casos de uso (services.py)
        ├── domain/        # Modelos, invariantes y reglas de negocio (entities.py)
        └── ports/         # Interfaces y contratos de comunicación (inbound.py, outbound.py)

```

