---
geometry:
- top=2cm
- bottom=2cm
- left=2cm
- right=2cm
---

# Documento Técnico: Sistema de Finanzas Personales (FinanceApp)

## 1. Información General

- **Nombre del Sistema:** FinanceApp
- **Integrantes:**
  - Arce Mayhua Leonardo Ruben
  - Gallegos Condori Anette Isabel
  - Jara Mamani Mariel Alisson
  - Quispe Condori, Alvaro Raul

## 2. Descripción

El sistema **FinanceApp** es una solución robusta para la gestión de finanzas personales, construida bajo el patrón de **Arquitectura Hexagonal**. Esta arquitectura garantiza un desacoplamiento total entre la lógica de negocio (Núcleo) y los detalles técnicos (Interfaces de Usuario, Bases de Datos). El sistema permite el control total de cuentas, categorías, presupuestos y transacciones, asegurando la integridad de los datos mediante una capa de validación exhaustiva y una estrategia de pruebas basada en la calidad del software.

## 3. Validaciones de Integridad

| Entidad         | Regla de Validación                                     | Excepción                |
| :-------------- | :------------------------------------------------------ | :----------------------- |
| **User**        | El email debe contener un carácter '@'.                 | `ValueError`             |
| **Account**     | El nombre y el banco no pueden estar vacíos.            | `ValueError`             |
| **Category**    | El nombre de la categoría es obligatorio.               | `ValueError`             |
| **Budget**      | El límite debe ser > 0; mes entre 1-12; año >= 1900.    | `ValueError`             |
| **Transaction** | Monto debe ser > 0; descripción obligatoria.            | `ValueError`             |
| **Transaction** | `EXPENSE` requiere categoría; `INCOME` no permite.      | `ValueError`             |
| **Business**    | Un gasto no puede exceder el saldo actual de la cuenta. | `InsufficientFundsError` |

## 4. Estrategia de Pruebas: Casos PE y AVL

Se ha implementado una suite de **74 pruebas unitarias** utilizando `pytest`, organizadas por capas y aplicando técnicas de Caja Negra.

### 4.1. Capa de Dominio (`core/domain`)

Pruebas sobre las entidades puras y sus invariantes.

| Entidad         | Tipo | Caso de Prueba / Escenario                         | Resultado Esperado                |
| :-------------- | :--- | :------------------------------------------------- | :-------------------------------- |
| **Account**     | PE   | Registro de ingresos y gastos dentro del saldo.    | Éxito (Balance actualizado)       |
| **Account**     | PE   | Registro de cuenta con nombre y banco válidos.     | Éxito                             |
| **Account**     | PE   | Nombre o banco vacíos / solo espacios.             | Falla (`ValueError`)              |
| **Account**     | AVL  | Gasto de exactamente el saldo disponible (Límite). | Balance = 0.00                    |
| **Account**     | AVL  | Gasto de 0.01 por encima del saldo.                | `InsufficientFundsError`          |
| **Account**     | AVL  | Ingreso de 0.00 o monto negativo.                  | Denegado (`ValueError`)           |
| **Budget**      | AVL  | Meses 0 y 13 (Inválidos); 1 y 12 (Válidos).        | Validación de rango (1-12)        |
| **Budget**      | AVL  | Año 1999 (Inválido); 2000 (Mínimo en UI).          | Validación de rango               |
| **Budget**      | AVL  | Límite 0.01 (Mínimo válido); 0.00 (Inválido).      | Validación de valor               |
| **Transaction** | PE   | Registro de `EXPENSE` sin categoría.               | Falla (`ValueError`)              |
| **Transaction** | PE   | Registro de `INCOME` con categoría.                | Falla (`ValueError`)              |
| **Transaction** | AVL  | Monto de 0.01 (Mínimo aceptado).                   | Éxito                             |
| **Transaction** | AVL  | Fecha en el límite del mes (Día 1 vs Día 31).      | Correcta asignación a presupuesto |

### 4.2. Capa de Aplicación (`core/app`)

Pruebas sobre el `FinanceService` que orquesta los flujos de trabajo.

| Escenario                       | Tipo | Descripción                                                                               |
| :------------------------------ | :--- | :---------------------------------------------------------------------------------------- |
| **Orquestación**                | EP   | Verificación de que los repositorios persisten los cambios tras crear usuarios o cuentas. |
| **Filtros**                     | EP   | `list_active_accounts` debe excluir aquellas marcadas con `is_active=False`.              |
| **Presupuesto (Límite - 0.01)** | AVL  | Gasto total = Límite - 0.01 (`exceeded = False`).                                         |
| **Presupuesto (Límite)**        | AVL  | Gasto total = Límite (`exceeded = False`).                                                |
| **Presupuesto (Límite + 0.01)** | AVL  | Gasto total = Límite + 0.01 (`exceeded = True`).                                          |

### 4.3. Capa de Adaptadores (`adapters/outbound`)

Pruebas sobre la persistencia en memoria.

| Escenario                | Tipo | Descripción                                                         |
| :----------------------- | :--- | :------------------------------------------------------------------ |
| **Periodo (Día 1)**      | AVL  | Incluir transacciones del primer día del mes objetivo.              |
| **Periodo (Último Día)** | AVL  | Incluir transacciones del último día del mes objetivo.              |
| **Periodo (Fronteras)**  | AVL  | Excluir transacciones del día anterior y posterior al mes objetivo. |
| **Persistencia**         | EP   | `update()` debe lanzar error si el ID de la entidad no existe.      |

### 4.4. Capa de Validación de UI (`adapters/inbound`)

Pruebas sobre los validadores de entrada de datos (Caja de Texto).

| Campo        | Tipo | Entrada / Acción                     | Resultado    |
| :----------- | :--- | :----------------------------------- | :----------- |
| **Tipado**   | PE   | Letras en campos de monto o fecha.   | `ValueError` |
| **Espacios** | PE   | Nombres con solo espacios en blanco. | Denegado     |
| **Rangos**   | AVL  | Año < 2000 para presupuestos.        | Denegado     |
