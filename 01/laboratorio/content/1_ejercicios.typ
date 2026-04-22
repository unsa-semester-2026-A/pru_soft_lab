#import "../util.typ" as util
#set par(justify: true)

*Ejercicio 1.1 — Depuración: algoritmo Shell Sort* \

El programa `shell_sort.py` implementa el algoritmo Shell Sort con la secuencia de incrementos de Knuth [1].
*[Leo]* creó el proyecto `/LAB_01/` en VS Code y ejecutó el programa con los argumentos indicados en la guía, obteniendo los siguientes resultados:

#table(
  columns: (2fr, 1.5fr, 0.8fr),
  stroke: 0.5pt,
  inset: 0.5em,
  [*Comando ejecutado*], [*Salida obtenida*], [*Estado*],
  [`python shell_sort.py 9 7 3 11`], [`Output:  3 7 9 11`], [Correcto],
  [`python shell_sort.py 14 2 7 1`], [`Output:  2 7 14 1`], [Incorrecto],
  [`python shell_sort.py 14 $ 7 A`], [`Output:  0 7 14 0`], [Incorrecto],
)

*Identificación del defecto.* El error se ubica en la función `main()` en la asignación del tamaño del arreglo:

- Código erróneo: `size = len(a) - 1`
- Código correcto: `size = len(a)`

El valor `size` delimita el bucle `for i in range(h, size)` dentro de `shell_sort`. Con `size = len(a) - 1`, el elemento en el último índice nunca es considerado en el ordenamiento. Por ejemplo, para la entrada `14 2 7 1`, el arreglo queda `[2, 7, 14, 1]` porque el elemento `1` en el índice 3 no es procesado.

*Proceso de depuración en VS Code* — *[Mariel y Leo]*: Se configuró `launch.json` con `args: ["14","2","7","1"]`, se colocaron breakpoints en las líneas 30, 37 y 38, y se presionó F5. El panel de variables mostró `size = 3` cuando el valor correcto es `4`.

#align(center)[
  #image("../src/img/exercises/solved/exe1-debug-bug.png", width: 65%)

  _Figura 1 — Panel de variables del depurador mostrando `size = 3` (valor incorrecto)._
]

*Corrección aplicada.* Se reemplazó `size = len(a) - 1` por `size = len(a)`. Con la corrección, `python shell_sort.py 14 2 7 1` produce correctamente `Output:  1 2 7 14`.

#util.codeBlock("src/lst/shell_sort.py", lang: "python")

#align(center)[
  #image("../src/img/exercises/solved/exe1-debug-fixed.png", width: 65%)

  _Figura 2 — Panel de variables con el valor corregido `size = 4`._
]

\

*Ejercicio 1.2 — Pruebas: Clasificación de Triángulos [2]* \

*[Leo]* creó el archivo `triangle.py` en VS Code con el código del docente.

*Paso 2 — Ingreso de valores inválidos.* Al ejecutar el código original (sin validación de lados positivos) con entradas como `(3, 0, 5)` o `(3, 4, -5)`, el programa clasifica el triángulo incorrectamente en vez de declararlo inválido. Esto evidencia un defecto: la versión original omite verificar que los lados sean positivos.

*Paso 3 — Respuesta a los 13 criterios de Myers [2].*

#table(
  columns: (0.35fr, 2.5fr, 0.7fr),
  stroke: 0.5pt,
  inset: 0.45em,
  [*\#*], [*¿Se tiene un caso de prueba que...?*], [*¿Cumple?*],
  [1], [Represente un triángulo escaleno válido.], [Sí — (3, 4, 5)],
  [2], [Represente un triángulo equilátero válido.], [Sí — (7, 7, 7)],
  [3], [Represente un triángulo isósceles válido.], [Sí — (5, 5, 8)],
  [4], [Pruebe las tres permutaciones de isósceles (a=b, a=c, b=c).], [Sí — (3,3,4); (3,4,3); (4,3,3)],
  [5], [Un lado con valor cero.], [Sí — (3, 0, 5)],
  [6], [Un lado con valor negativo.], [Sí — (3, 4, -5)],
  [7], [Tres enteros positivos donde la suma de dos lados iguala al tercero.], [Sí — (1, 2, 3)],
  [8], [Las tres permutaciones del caso 7 (a+b=c, a+c=b, b+c=a).], [Sí — (1,2,3); (1,3,2); (3,1,2)],
  [9], [Tres enteros positivos donde la suma de dos lados es menor que el tercero.], [Sí — (1, 2, 4)],
  [10], [Las tres permutaciones del caso 9 (a+b menor que c, a+c menor que b, b+c menor que a).], [Sí — (1,2,4); (1,4,2); (4,1,2)],
  [11], [Todos los lados son cero.], [Sí — (0, 0, 0)],
  [12], [Al menos un valor no entero (decimal).], [Sí — (2.5, 3.5, 5.5)],
  [13], [Número incorrecto de valores de entrada (ej. solo 2 entradas).], [Sí — (5, 5)],
)

*Paso 4 — Diseño de Casos de Prueba [2].*

#table(
  columns: (0.35fr, 2fr, 0.7fr, 2fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Descripción*], [*Datos de Entrada*], [*Resultado Esperado*],
  [1],  [Triángulo escaleno válido],                       [(3, 4, 5)],     [El triangulo es escaleno.],
  [2],  [Triángulo equilátero válido],                     [(7, 7, 7)],     [El triangulo es equilatero.],
  [3],  [Triángulo isósceles válido],                      [(5, 5, 8)],     [El triangulo es isosceles.],
  [4a], [Isósceles — permutación a=b],                     [(3, 3, 4)],     [El triangulo es isosceles.],
  [4b], [Isósceles — permutación a=c],                     [(3, 4, 3)],     [El triangulo es isosceles.],
  [4c], [Isósceles — permutación b=c],                     [(4, 3, 3)],     [El triangulo es isosceles.],
  [5],  [Un lado con valor cero],                          [(3, 0, 5)],     [Triangulo invalido: lados deben ser positivos.],
  [6],  [Un lado con valor negativo],                      [(3, 4, -5)],    [Triangulo invalido: lados deben ser positivos.],
  [7],  [Suma de dos lados igual al tercero],              [(1, 2, 3)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [8a], [Suma igual — permutación a+b=c],                  [(1, 2, 3)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [8b], [Suma igual — permutación a+c=b],                  [(1, 3, 2)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [8c], [Suma igual — permutación b+c=a],                  [(3, 1, 2)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [9],  [Suma de dos lados menor que el tercero],          [(1, 2, 4)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [10a],[Suma menor — permutación a+b menor que c],        [(1, 2, 4)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [10b],[Suma menor — permutación a+c menor que b],        [(1, 4, 2)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [10c],[Suma menor — permutación b+c menor que a],        [(4, 1, 2)],     [Triangulo invalido: no cumple desigualdad triangular.],
  [11], [Todos los lados son cero],                        [(0, 0, 0)],     [Triangulo invalido: lados deben ser positivos.],
  [12], [Valores no enteros],                              [(2.5, 3.5, 5.5)],[Error: ingrese solo numeros enteros.],
  [13], [Número incorrecto de entradas (solo 2)],          [(5, 5)],        [El programa espera la tercera entrada (bloquea).],
)

*Paso 5 — Defecto identificado en el código original.* La versión inicial de `triangle.py` (guía, p. 8) no valida que los lados sean positivos. La versión corregida agrega la condición `if lado1 <= 0 or lado2 <= 0 or lado3 <= 0` antes de la desigualdad triangular. El código final utilizado es:

#util.codeBlock("src/lst/triangle.py", lang: "python")

*Paso 6 — Implementación de `triangle_test.py`.* *[Leo]* creó el archivo en VS Code:

#util.codeBlock("src/lst/triangle_test.py", lang: "python")

*Paso 7 — Validación de casos de prueba.*

#align(center)[
  #image("../src/img/image_dummy.webp", width: 80%)

  _Figura 3 — Resultado de `python -m unittest triangle_test.py` (17 tests OK). (Captura: Leo)._
]

#table(
  columns: (0.35fr, 1.6fr, 0.65fr, 1.8fr, 0.55fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Descripción*], [*Entrada*], [*Resultado real*], [*Estado*],
  [1],     [Escaleno válido],       [(3,4,5)],       [El triangulo es escaleno.],       [Pasa],
  [2],     [Equilátero válido],     [(7,7,7)],       [El triangulo es equilatero.],     [Pasa],
  [3],     [Isósceles válido],      [(5,5,8)],       [El triangulo es isosceles.],      [Pasa],
  [4a],    [Isósceles a=b],         [(3,3,4)],       [El triangulo es isosceles.],      [Pasa],
  [4b],    [Isósceles a=c],         [(3,4,3)],       [El triangulo es isosceles.],      [Pasa],
  [4c],    [Isósceles b=c],         [(4,3,3)],       [El triangulo es isosceles.],      [Pasa],
  [5],     [Lado cero],             [(3,0,5)],       [Invalido: lados positivos.],      [Pasa],
  [6],     [Lado negativo],         [(3,4,-5)],      [Invalido: lados positivos.],      [Pasa],
  [7/8a],  [Suma=tercero (perm. 1)],[(1,2,3)],       [Invalido: desigualdad.],          [Pasa],
  [8b],    [Suma=tercero (perm. 2)],[(1,3,2)],       [Invalido: desigualdad.],          [Pasa],
  [8c],    [Suma=tercero (perm. 3)],[(3,1,2)],       [Invalido: desigualdad.],          [Pasa],
  [9/10a], [Suma menor que tercero (perm. 1)],[(1,2,4)],       [Invalido: desigualdad.],          [Pasa],
  [10b],   [Suma menor que tercero (perm. 2)],[(1,4,2)],       [Invalido: desigualdad.],          [Pasa],
  [10c],   [Suma menor que tercero (perm. 3)],[(4,1,2)],       [Invalido: desigualdad.],          [Pasa],
  [11],    [Todos cero],            [(0,0,0)],       [Invalido: lados positivos.],      [Pasa],
  [12],    [No enteros],            [(2.5,3.5,5.5)], [ValueError → mensaje de error.],  [Pasa],
  [13],    [Solo 2 entradas],       [(5,5)],         [Bloquea esperando Lado 3.],       [N/A],
)

*El programa no presenta errores* en los 16 casos automatizables (casos 1–12). El caso 13 no es verificable con `unittest` estándar porque requiere interacción interactiva de E/S.

\

*Ejercicios Propuestos* \ \

*1. Área de un Rectángulo* \

Se implementaron `rectangle.py` y `rectangle_test.py`. La función `calcular_area` acepta entradas enteras y decimales positivas, calculando el área como `base × altura`.

*Código fuente — `rectangle.py`:*
#util.codeBlock("src/lst/rectangle.py", lang: "python")

*Código fuente — `rectangle_test.py`:*
#util.codeBlock("src/lst/rectangle_test.py", lang: "python")

*Casos de prueba diseñados:*

#table(
  columns: (0.35fr, 1.7fr, 0.9fr, 1.3fr, 0.55fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Descripción*], [*Entrada (base, altura)*], [*Resultado Esperado*], [*Estado*],
  [1], [Enteros positivos],        [(3, 4)],     [12],      [Pasa],
  [2], [Decimales positivos],      [(2.5, 3.5)], [8.75],    [Pasa],
  [3], [Base igual a 1],           [(1, 7)],     [7],       [Pasa],
  [4], [Altura igual a 1],         [(5, 1)],     [5],       [Pasa],
  [5], [Base igual a cero],        [(0, 5)],     [0],       [Pasa],
  [6], [Altura igual a cero],      [(5, 0)],     [0],       [Pasa],
  [7], [Ambos iguales a cero],     [(0, 0)],     [0],       [Pasa],
  [8], [Decimal con precisión],    [(1.5, 2.0)], [3.0],     [Pasa],
  [9], [Enteros grandes],          [(100, 200)], [20 000],  [Pasa],
)

#align(center)[
  #image("../src/img/exercises/proposed/exe2-test-passed.png", width: 80%)

  _Figura 4 — Ejecución de `python -m unittest rectangle_test.py` (9 tests OK)._
]

\

*2. Identificador de Números Pares e Impares* \

Se implementaron `numbers.py` y `numbers_test.py`. La función `clasificar_numero` aplica el operador módulo (`n % 2`) para determinar la paridad de cualquier entero, incluyendo cero y negativos.

*Código fuente — `numbers.py`:*
#util.codeBlock("src/lst/numbers.py", lang: "python")

*Código fuente — `numbers_test.py`:*
#util.codeBlock("src/lst/numbers_test.py", lang: "python")

*Casos de prueba diseñados:*

#table(
  columns: (0.35fr, 1.8fr, 0.7fr, 1fr, 0.55fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Descripción*], [*Entrada*], [*Resultado Esperado*], [*Estado*],
  [1], [Par positivo típico],     [4],  [par],   [Pasa],
  [2], [Impar positivo típico],   [7],  [impar], [Pasa],
  [3], [Cero (frontera)],         [0],  [par],   [Pasa],
  [4], [Negativo par],            [-4], [par],   [Pasa],
  [5], [Negativo impar],          [-3], [impar], [Pasa],
  [6], [Menor par positivo (2)],  [2],  [par],   [Pasa],
  [7], [Menor impar positivo (1)],[1],  [impar], [Pasa],
)

#align(center)[
  #image("../src/img/image_dummy.webp", width: 80%)

  _Figura 5 — Ejecución de `python -m unittest numbers_test.py` (7 tests OK). (Captura: Leo)._
]

\

*3. Mini Simulador de Cajero Automático (ATM)* \

Se implementaron `atm.py` y `atm_test.py`. Las funciones `depositar` y `retirar` validan montos positivos y disponibilidad de saldo lanzando `ValueError` ante entradas inválidas, lo que permite probarlas unitariamente sin interacción con el menú.

*Código fuente — `atm.py`:*
#util.codeBlock("src/lst/atm.py", lang: "python")

*Código fuente — `atm_test.py`:*
#util.codeBlock("src/lst/atm_test.py", lang: "python")

*Casos de prueba diseñados:*

#table(
  columns: (0.35fr, 2fr, 1fr, 1.5fr, 0.55fr),
  stroke: 0.5pt,
  inset: 0.4em,
  [*Id.*], [*Descripción*], [*Parámetros*], [*Resultado Esperado*], [*Estado*],
  [1], [Consultar saldo inicial],        [saldo=1000],             [1000.0],       [Pasa],
  [2], [Depósito válido],                [saldo=1000, dep=200],    [1200.0],       [Pasa],
  [3], [Depósito monto cero],            [dep=0],                  [ValueError],   [Pasa],
  [4], [Depósito monto negativo],        [dep=-100],               [ValueError],   [Pasa],
  [5], [Retiro válido],                  [saldo=1000, ret=300],    [700.0],        [Pasa],
  [6], [Retiro saldo exacto],            [saldo=1000, ret=1000],   [0.0],          [Pasa],
  [7], [Retiro que excede saldo],        [saldo=1000, ret=1500],   [ValueError],   [Pasa],
  [8], [Retiro monto cero],              [ret=0],                  [ValueError],   [Pasa],
  [9], [Retiro monto negativo],          [ret=-50],                [ValueError],   [Pasa],
)

#align(center)[
  #image("../src/img/exercises/proposed/exe3-test-passed.png", width: 80%)

  _Figura 6 — Ejecución de `python -m unittest atm_test.py` (9 tests OK)._
]