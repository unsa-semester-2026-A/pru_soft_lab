=== Instrucciones para Leo (Prueba de Sentencias)

*Objetivo:* Diseñar una suite de pruebas con `pytest` que logre el *100% de cobertura de sentencias (Statement Coverage)* para el módulo `bisect.py`. Esto requiere transitar por todas las líneas ejecutables del programa.

==== Módulo Analizado

*Archivo:* `bisect.py`
*Función seleccionada:* `bisect_left(a, x, lo=0, hi=None, *, key=None)`

==== Objetivo

Diseñar casos de prueba que permitan alcanzar una cobertura del 100% de sentencias en la función `bisect_left()` del módulo estándar `bisect.py`. La prueba debe ejecutar todas las instrucciones principales:

- Validación del parámetro `lo`.
- Asignación de `hi` cuando es `None`.
- Búsqueda sin función `key`.
- Búsqueda utilizando función `key`.
- Retorno final del índice.

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
