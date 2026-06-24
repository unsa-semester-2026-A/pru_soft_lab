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
#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Instrucciones:* Dibuja y enumera los nodos y aristas de la función. Puedes adjuntar una imagen utilizando:
    
    `#figure(image("../src/img/fixed/cfg_account_alvaro.png", width: 70%), caption: [Grafo de Flujo de Control - Account.__post_init__])`
  ]
)

==== 2. Cálculo Manual de la Complejidad Ciclomática (CC) - Álvaro
Aplica las siguientes fórmulas para el cálculo:
1. $C C = A - N + 2$
2. $C C = P + 1$

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Desarrollo del Cálculo:*
    - Número de Aristas ($A$): [Completar]
    - Número de Nodos ($N$): [Completar]
    - Número de Nodos Predicado ($P$): [Completar]
    
    *Resultado:* $C C =$ [Completar]
  ]
)

==== 3. Verificación con la Herramienta Radon - Mariel (Alisson)
*Instrucciones para Mariel:* Ejecuta el siguiente comando en la terminal para obtener el score de Radon:
```bash
radon cc development/finance/core/domain/entities.py -s -a
```

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Resultados de Radon:*
    - Score numérico de Radon: [Completar]
    - Categoría de riesgo (Rango A-F): [Completar]
    - ¿El resultado manual coincide con el de la herramienta?: [Completar]
  ]
)
