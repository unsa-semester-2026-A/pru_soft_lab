=== Pruebas de Sentencias (Statement Testing)

Para el análisis de cobertura de sentencias, se diseñó una suite de pruebas unitarias enfocada en transitar por cada una de las instrucciones ejecutables del módulo `bisect.py`, asegurando que ninguna línea de código quede sin verificar.

==== Módulo Analizado

*Archivo:* `bisect.py`
*Función seleccionada:* `bisect_left(a, x, lo=0, hi=None, *, key=None)`

==== Objetivo del Análisis de Cobertura

El propósito del diseño de la suite de pruebas es alcanzar una cobertura de sentencias del $100\%$ en la función `bisect_left` del módulo estándar `bisect.py`. La suite de pruebas está estructurada para asegurar la ejecución de cada una de las instrucciones principales:

- Validación de la precondición para el parámetro `lo` (debe ser no negativo).
- Inicialización y asignación del límite superior por defecto `hi` en caso de ser omitido (`None`).
- Flujo de búsqueda binaria en ausencia de una función de transformación `key`.
- Flujo de búsqueda binaria con el uso de una función de transformación `key`.
- Retorno final del índice calculado.

==== Análisis de Sentencias

===== 1. Validación del límite inferior
Código:
```python
if lo < 0:
    raise ValueError('lo must be non-negative')
```
Se cubre enviando un valor negativo en `lo`.

===== 2. Inicialización del límite superior
Código:
```python
if hi is None:
    hi = len(a)
```
Se ejecuta cuando no se proporciona `hi`.

===== 3. Búsqueda sin función key
Código:
```python
if key is None:
    while lo < hi:
        mid = (lo + hi) // 2
        if a[mid] < x:
            lo = mid + 1
        else:
            hi = mid
```

===== 4. Búsqueda utilizando key
Código:
```python
else:
    while lo < hi:
        mid = (lo + hi) // 2
        if key(a[mid]) < x:
            lo = mid + 1
        else:
            hi = mid
```

==== Casos de Prueba Diseñados

===== Caso 1: Error por límite negativo
*Entrada:*
```python
a = [1, 3, 5, 7]
x = 4
lo = -1
```
*Resultado esperado:* Lanza `ValueError`
*Sentencias cubiertas:* Validación `lo < 0` y lanzamiento de excepción.

===== Caso 2: Búsqueda normal sin key
*Entrada:*
```python
a = [1, 3, 5, 7]
x = 4
```
*Resultado esperado:* Retorna `2`
*Sentencias cubiertas:* `hi = len(a)`, ciclo `while`, cálculo de `mid`, comparación `a[mid] < x`, y actualización de límites.

===== Caso 3: Uso de función key
*Entrada:*
```python
a = [{"valor": 1}, {"valor": 3}, {"valor": 5}]
x = 4
key = lambda elemento: elemento["valor"]
```
*Resultado esperado:* Retorna `2`
*Sentencias cubiertas:* Rama alternativa `key`, comparación mediante `key(a[mid])`, y actualización de límites.

==== Resultado de Cobertura

Los casos de prueba ejecutan todas las sentencias relevantes de la función `bisect_left()`.
*Cobertura obtenida:* $100\%$

==== Conclusión

Los casos diseñados permiten recorrer todas las instrucciones ejecutables del algoritmo, incluyendo validaciones, búsqueda estándar y búsqueda personalizada mediante la función `key`.
