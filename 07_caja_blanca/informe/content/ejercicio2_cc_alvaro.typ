=== Función Asignada: `Account.__post_init__` (Alvaro)

*Ubicación:* `finance/core/domain/entities.py` (Líneas 82 a 94).

==== Código a Analizar:
```py
def __post_init__(self) -> None:
    """Validate entity fields."""
    _validate_not_empty(self.name, "Account name")
    _validate_not_empty(self.bank, "Bank name")
    if not re.match(r"^[A-Za-z\u00C0-\u024F\s]+$", self.name):
        raise ValueError("Account name must contain only letters.")
    if len(self.name) < 2:
        raise ValueError("Account name must be at least 2 characters.")
    if len(self.name) > 128:
        raise ValueError("Account name must be at most 128 characters.")
    if len(self.bank) > 100:
        raise ValueError("Bank name must be at most 100 characters.")
```

==== 1. Grafo de Flujo de Control (CFG) - Álvaro
*Metodología de conteo de nodos:*

Para el cálculo de la Complejidad Ciclomática, se contabilizan únicamente los *nodos predicado* (puntos de decisión) y los puntos de inicio/secuencia y fin de la función. Las sentencias de error (`raise`) no se modelan como nodos predicado independientes, sino que representan la terminación de una rama específica que va hacia el nodo de salida (Fin). Las llamadas a funciones secuenciales sin bifurcación (como `_validate_not_empty`) se asocian al nodo de inicio.

Análisis de nodos predicado en `Account.__post_init__`:

#table(
  columns: (0.5fr, 2fr, 1fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#dfdfdf") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#f8f9fa"))[*Nodo*],
  table.cell(fill: rgb("#f8f9fa"))[*Descripción*],
  table.cell(fill: rgb("#f8f9fa"))[*Tipo*],

  [1], [`def __post_init__(self) -> None:` (incluye llamadas `_validate_not_empty`)], [Inicio],
  [2], [`if not re.match(...)` (valida caracteres del nombre)], [Predicado],
  [3], [`if len(self.name) < 2` (valida longitud mínima)], [Predicado],
  [4], [`if len(self.name) > 128` (valida longitud máxima)], [Predicado],
  [5], [`if len(self.bank) > 100` (valida longitud máxima de banco)], [Predicado],
  [6], [Terminación de la función (retorno o exception)], [Fin],
)

*Aristas del CFG:*

#table(
  columns: (1fr, 1.5fr, 2.5fr),
  stroke: 0.5pt + rgb("#bdc3c7"),
  fill: (col, row) => if row == 0 { rgb("#dfdfdf") } else { none },
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if row == 0 { center + horizon } else { left + horizon },

  table.cell(fill: rgb("#f8f9fa"))[*Arista*],
  table.cell(fill: rgb("#f8f9fa"))[*Origen → Destino*],
  table.cell(fill: rgb("#f8f9fa"))[*Condición*],

  [e1], [1 → 2], [Entrada a la función (Siempre)],
  [e2], [2 → 6], [`not re.match(...)` es True (Lanza ValueError)],
  [e3], [2 → 3], [`not re.match(...)` es False],
  [e4], [3 → 6], [`len(name) < 2` es True (Lanza ValueError)],
  [e5], [3 → 4], [`len(name) < 2` es False],
  [e6], [4 → 6], [`len(name) > 128` es True (Lanza ValueError)],
  [e7], [4 → 5], [`len(name) > 128` es False],
  [e8], [5 → 6], [`len(bank) > 100` es True (Lanza ValueError)],
  [e9], [5 → 6], [`len(bank) > 100` es False (Fin exitoso)],
)

#figure(
  image("../src/img/fixed/cfg_account_alvaro.png", width: 70%),
  caption: [Grafo de Flujo de Control (CFG) para `Account.__post_init__`],
)

==== 2. Cálculo Manual de la Complejidad Ciclomática (CC) - Álvaro
Aplica las siguientes fórmulas para el cálculo:

*Fórmula 1:* $C C = A - N + 2$

- Número de Aristas ($A$): $9$
- Número de Nodos ($N$): $6$
- $C C = 9 - 6 + 2 = 5$

*Fórmula 2:* $C C = P + 1$

Análisis de nodos predicado (decisiones):
- P1: `if not re.match(...)` → 1 condición
- P2: `if len(self.name) < 2` → 1 condición
- P3: `if len(self.name) > 128` → 1 condición
- P4: `if len(self.bank) > 100` → 1 condición

- Número de Nodos Predicado ($P$): $4$
- $C C = 4 + 1 = 5$

*Resultado:* $C C = 5$

==== 3. Verificación con la Herramienta Radon - Álvaro

*Comando ejecutado:*
```bash
radon cc development/finance/core/domain/entities.py -s -a
```

#figure(
  image("../src/img/finance/radon_account.png", width: 80%),
  caption: [Resultado de Radon para `Account.__post_init__`],
)

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Resultados de Radon:*
    - Score numérico de Radon: *5*
    - Categoría de riesgo (Rango A-F): *A* (Riesgo bajo, CC <= 5)
    - ¿El resultado manual coincide con el de la herramienta?: *Sí*. El cálculo manual aplicando ambas fórmulas ($A - N + 2$ y $P + 1$) da como resultado exacto $C C = 5$, lo cual coincide con la salida de Radon que califica con complejidad 5 y nivel de riesgo A.
  ]
)

==== Análisis de Resultados

La función `Account.__post_init__` tiene una complejidad ciclomática de 5, lo cual es considerado un riesgo muy bajo (Categoría A). La lógica interna consta de una secuencia lineal de validaciones condicionales independientes que comprueban la integridad del nombre de la cuenta y del banco. No contiene bucles o ramificaciones complejas interdependientes.

*Recomendaciones:*
- La modularidad y la legibilidad son excelentes.
- Se recomienda tener al menos 5 casos de prueba unitarios específicos (uno para el caso de éxito y cuatro para cubrir cada una de las excepciones `ValueError`) para lograr cobertura total de ramas en la fase de pruebas de caja blanca.
