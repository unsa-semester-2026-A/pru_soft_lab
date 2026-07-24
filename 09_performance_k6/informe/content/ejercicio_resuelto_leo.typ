== I. Ejercicio/Problema resuelto por el docente

== Ejercicio 1: Desarrollo y pruebas de rendimiento de una API REST en Python utilizando Flask
#v(1em)

=== 1. Implementación de la API REST

En este laboratorio se desarrolló una API REST utilizando el framework Flask de Python, cuyo objetivo fue implementar un servicio web para la administración de un catálogo básico de productos.

Para el desarrollo se configuró un entorno virtual en Python, donde se instalaron las dependencias necesarias:

- *Flask*: utilizado para la creación del servidor REST.
- *Requests*: utilizado para realizar pruebas de consumo de la API mediante Python.

La API fue implementada en el archivo `app.py`, donde se definieron los endpoints necesarios para realizar operaciones CRUD sobre los productos:

- `GET /productos`: permite obtener la lista completa de productos.
- `POST /productos`: permite registrar nuevos productos.
- `GET /productos/{id}`: permite consultar un producto específico.
- `PUT /productos/{id}`: permite actualizar información de un producto.
- `DELETE /productos/{id}`: permite eliminar un producto.

La información inicial utilizada para las pruebas fue:

```json
[
 {
  "id":1,
  "nombre":"Laptop",
  "precio":3500
 },
 {
  "id":2,
  "nombre":"Mouse",
  "precio":90
 },
 {
  "id":3,
  "nombre":"Teclado",
  "precio":180
 }
]
```

=== 2. Ejecución y validación del servicio REST

Luego de implementar la API, se inició el servidor Flask mediante:

```bash
python app.py
```

El servicio quedó disponible mediante la dirección:

`http://localhost:5000`

La correcta ejecución del servidor fue validada mediante una consulta al endpoint:

`GET http://localhost:5000/productos`

La respuesta obtenida confirmó que la API funcionaba correctamente y estaba preparada para las pruebas de rendimiento.
#figure(
  image("../src/fig/ejercicior/Postman.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>


_(Captura de respuesta del endpoint /productos - navegador o Postman mostrando la lista de productos)_

=== 3. Prueba inicial mediante Python Requests

Antes de realizar las pruebas de carga, se realizó una prueba básica utilizando la librería Requests de Python.

El objetivo fue comprobar que el servicio REST respondiera correctamente antes de someterlo a múltiples solicitudes simultáneas.

*Resultado obtenido:*

- Código: `200`
- Respuesta:

```json
[
 {'id':1,'nombre':'Laptop','precio':3500},
 {'id':2,'nombre':'Mouse','precio':90},
 {'id':3,'nombre':'Teclado','precio':180}
]
```

Esto permitió verificar que los resultados posteriores correspondieran al comportamiento del sistema bajo carga y no a errores en la implementación de la API.
#figure(
  image("../src/fig/ejercicior/cliente.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
_(Captura de la ejecución del cliente cliente.py mostrando código 200)_

=== 4. Pruebas de rendimiento utilizando Apache JMeter

Después de validar el funcionamiento de la API, se realizaron pruebas de carga utilizando Apache JMeter.

El objetivo fue simular múltiples usuarios concurrentes realizando solicitudes HTTP hacia el endpoint:

`GET http://localhost:5000/productos`

La prueba fue configurada utilizando:

- *Thread Group* para simular usuarios virtuales.
- *HTTP Request* para realizar las peticiones GET.
- *Listeners* para analizar los resultados obtenidos.

Los escenarios evaluados fueron:

#v(0.5em)
#table(
  columns: (auto, auto, auto),
  align: center,
  table.header([*Escenario*], [*Usuarios*], [*Ramp-Up*]),
  [1], [20], [10 segundos],
  [2], [50], [20 segundos],
  [3], [100], [30 segundos],
)
#v(0.5em)

Durante las pruebas se analizaron los siguientes indicadores:

- Tiempo promedio de respuesta.
- Tiempo mínimo y máximo.
- Throughput.
- Desviación estándar.
- Porcentaje de errores.


*Resultados obtenidos mediante JMeter*

Los resultados fueron registrados mediante los reportes:

- Summary Report.
- Aggregate Report.
- View Results Tree.
- Graph Results.

#figure(
  image("../src/fig/ejercicior/jmeter1.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
#figure(
  image("../src/fig/ejercicior/jmeter2.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
_(Capturas de los reportes obtenidos)_

=== 5. Pruebas de rendimiento utilizando K6

Posteriormente se realizaron pruebas automatizadas utilizando K6, herramienta orientada a pruebas de rendimiento mediante scripts JavaScript.

El script ejecutado realizó solicitudes hacia:

`http://localhost:5000/productos`

Se evaluaron tres escenarios:

#v(0.5em)
#table(
  columns: (auto, auto, auto),
  align: center,
  table.header([*Escenario*], [*Usuarios virtuales*], [*Duración*]),
  [A], [20], [30 segundos],
  [B], [50], [45 segundos],
  [C], [100], [60 segundos],
)
#v(0.5em)

==== Resultados obtenidos con K6

*Escenario A: 20 usuarios virtuales*

Resultados:

- Tiempo promedio de respuesta: 2.34 ms
- Solicitudes realizadas: 600
- Throughput: 19.91 solicitudes/segundo
- Errores: 0%
#figure(
  image("../src/fig/ejercicior/k61.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
_(Captura resultado K6 - 20 usuarios)_

*Escenario B: 50 usuarios virtuales*

Resultados:

- Tiempo promedio: 2.85 ms
- Solicitudes realizadas: 2250
- Throughput: 49.74 solicitudes/segundo
- Errores: 0%

#figure(
  image("../src/fig/ejercicior/k62.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
_(Captura resultado K6 - 50 usuarios)_

*Escenario C: 100 usuarios virtuales*

Resultados:

- Tiempo promedio: 4.26 ms
- Solicitudes realizadas: 6000
- Throughput: 99.11 solicitudes/segundo
- Errores: 0%

#figure(
  image("../src/fig/ejercicior/k63.jpg", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
_(Captura resultado K6 - 100 usuarios)_

=== 6. Tabla de resultados obtenidos

#v(0.5em)
#table(
  columns: (auto, auto, auto, auto),
  align: center,
  table.header([*Usuarios*], [*Tiempo promedio (ms)*], [*Throughput*], [*Error %*]),
  [20], [2.34 ms], [19.91 req/s], [0%],
  [50], [2.85 ms], [49.74 req/s], [0%],
  [100], [4.26 ms], [99.11 req/s], [0%],
)
#v(0.5em)

=== 7. Análisis de resultados

*¿Cómo varía el tiempo de respuesta conforme aumenta el número de usuarios?*

El tiempo de respuesta aumenta progresivamente debido a que el servidor debe atender una mayor cantidad de solicitudes simultáneas. Sin embargo, el incremento fue reducido, pasando de 2.34 ms con 20 usuarios a 4.26 ms con 100 usuarios.

*¿Existe degradación del rendimiento?*

Existe una ligera degradación debido al aumento de usuarios concurrentes, pero la API mantiene estabilidad, ya que todas las solicitudes fueron procesadas correctamente y no se registraron errores.

*¿Qué recurso podría limitar el desempeño?*

El principal recurso que podría limitar el rendimiento es la CPU, debido al procesamiento de múltiples solicitudes simultáneas. También podrían influir la memoria disponible y la configuración del servidor Flask.

=== 8. Comparación Apache JMeter vs K6

#v(0.5em)
#table(
  columns: (auto, auto, auto),
  align: (left, left, left),
  table.header([*Característica*], [*Apache JMeter*], [*K6*]),
  [Facilidad de uso], [Mayor facilidad por su interfaz gráfica.], [Requiere conocimientos básicos de programación.],
  [Curva de aprendizaje], [Media debido a la cantidad de componentes.], [Menor para usuarios con conocimientos de código.],
  [Automatización], [Permite automatización, pero requiere configuración adicional.], [Alta automatización mediante scripts.],
  [Integración CI/CD], [Compatible, pero requiere configuración.], [Excelente integración con pipelines DevOps.],
  [Consumo de memoria], [Mayor consumo por utilizar interfaz gráfica Java.], [Menor consumo de recursos.],
  [Generación de reportes], [Reportes gráficos y estadísticos completos.], [Métricas detalladas mediante consola y herramientas externas.],
  [Escalabilidad], [Buena, pero requiere más recursos.], [Alta escalabilidad para grandes cantidades de usuarios.],
)
#v(0.5em)

=== 9. Análisis final

*¿Qué herramienta presentó menor tiempo promedio de respuesta?*

K6 presentó los menores tiempos de respuesta, alcanzando un promedio mínimo de:

2.34 ms

*¿Cuál fue el Throughput máximo alcanzado?*

El throughput máximo fue de:

99.11 solicitudes/segundo

con 100 usuarios virtuales.

*¿Qué porcentaje de errores presentó cada herramienta?*

K6 presentó:

0% de errores

en todos los escenarios evaluados.

*¿Cuál herramienta es más adecuada para DevOps?*

K6 resulta más adecuado para DevOps debido a su enfoque basado en código, facilidad de automatización e integración con pipelines CI/CD.

*¿Qué mejoras implementar para soportar más usuarios?*

Se recomienda:

- Utilizar servidores de producción como Gunicorn.
- Implementar una base de datos optimizada.
- Aplicar mecanismos de caché.
- Usar balanceadores de carga.
- Mejorar la arquitectura para soportar escalamiento horizontal.
