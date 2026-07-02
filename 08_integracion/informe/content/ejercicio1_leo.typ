== Ejercicio 1: Automatización con Supertest (Leo)

*Descripción de la actividad:*
Implementar una API REST básica en Node.js + Express (ej. catálogo de videojuegos, biblioteca musical, etc.) y diseñar una suite de pruebas de integración utilizando Supertest y Jest/Mocha. La suite debe validar persistencia cruzada, modificación de estado y robustez (edge cases).

=== Código de la API (`app.js`)
#v(1em)
// LEO: Reemplaza este bloque de código con la implementación real de tu API.
```javascript

const express = require('express');
const app = express();
 
app.use(express.json());
 
// --- "Base de datos" en memoria ---
let videojuegos = [];
let nextId = 1;
 
// --- Helpers de validación ---
function esVideojuegoValido(body) {
  const { titulo, genero, precio, stock } = body;
 
  if (typeof titulo !== 'string' || titulo.trim() === '') return false;
  if (typeof genero !== 'string' || genero.trim() === '') return false;
  if (typeof precio !== 'number' || isNaN(precio) || precio < 0) return false;
  if (typeof stock !== 'number' || isNaN(stock) || stock < 0 || !Number.isInteger(stock)) return false;
 
  return true;
}
 
// --- POST /api/videojuegos ---
// Crea un videojuego nuevo con id dinámico
app.post('/api/videojuegos', (req, res) => {
  if (!esVideojuegoValido(req.body)) {
    return res.status(400).json({
      error: 'Datos inválidos. Se requiere titulo (string), genero (string), precio (number >= 0) y stock (integer >= 0).'
    });
  }
 
  const { titulo, genero, precio, stock } = req.body;
 
  const nuevoVideojuego = {
    id: nextId++,
    titulo,
    genero,
    precio,
    stock
  };
 
  videojuegos.push(nuevoVideojuego);
 
  return res.status(201).json(nuevoVideojuego);
});
 
// --- GET /api/videojuegos ---
// Devuelve la lista completa
app.get('/api/videojuegos', (req, res) => {
  return res.status(200).json(videojuegos);
});
 
// --- GET /api/videojuegos/:id ---
// Devuelve un videojuego por ID o 404
app.get('/api/videojuegos/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const videojuego = videojuegos.find(v => v.id === id);
 
  if (!videojuego) {
    return res.status(404).json({ error: `Videojuego con id ${req.params.id} no encontrado.` });
  }
 
  return res.status(200).json(videojuego);
});
 
// --- PUT /api/videojuegos/:id/stock ---
// Modifica cuantitativamente el stock restando una cantidad
app.put('/api/videojuegos/:id/stock', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const videojuego = videojuegos.find(v => v.id === id);
 
  if (!videojuego) {
    return res.status(404).json({ error: `Videojuego con id ${req.params.id} no encontrado.` });
  }
 
  const { cantidad } = req.body;
 
  if (typeof cantidad !== 'number' || isNaN(cantidad) || !Number.isInteger(cantidad) || cantidad <= 0) {
    return res.status(400).json({ error: 'La cantidad a restar debe ser un número entero positivo.' });
  }
 
  if (videojuego.stock < cantidad) {
    return res.status(400).json({
      error: `Stock insuficiente. Stock actual: ${videojuego.stock}, cantidad solicitada: ${cantidad}.`
    });
  }
 
  videojuego.stock -= cantidad;
 
  return res.status(200).json(videojuego);
});
 
module.exports = app;
```

=== Código de las Pruebas (`tema_libre.test.js`)
#v(1em)
// LEO: Reemplaza este bloque de código con tus pruebas en Supertest.
```javascript
 
const request = require('supertest');
const app = require('./app');
 
describe('API Catálogo de Videojuegos', () => {
 
  // -----------------------------------------------------------
  // 1. Flujo de Persistencia Cruzada (POST + GET)
  // -----------------------------------------------------------
  describe('Flujo de Persistencia Cruzada (POST + GET)', () => {
    it('debe crear un videojuego con POST y luego recuperarlo con GET /:id', async () => {
      const nuevoVideojuego = {
        titulo: 'The Legend of Zelda: Tears of the Kingdom',
        genero: 'Aventura',
        precio: 59.99,
        stock: 10
      };
 
      // 1. Creamos el recurso
      const resPost = await request(app)
        .post('/api/videojuegos')
        .send(nuevoVideojuego);
 
      expect(resPost.statusCode).toBe(201);
      expect(resPost.body).toHaveProperty('id');
      expect(resPost.body.titulo).toBe(nuevoVideojuego.titulo);
 
      const idCreado = resPost.body.id;
 
      // 2. Verificamos que persiste consultándolo por su ID
      const resGet = await request(app).get(`/api/videojuegos/${idCreado}`);
 
      expect(resGet.statusCode).toBe(200);
      expect(resGet.body).toEqual({ id: idCreado, ...nuevoVideojuego });
    });
 
    it('debe devolver 404 al buscar un videojuego con un ID inexistente', async () => {
      const res = await request(app).get('/api/videojuegos/99999');
 
      expect(res.statusCode).toBe(404);
      expect(res.body).toHaveProperty('error');
    });
  });
 
  // -----------------------------------------------------------
  // 2. Simulación de Modificación de Estado (PUT + GET)
  // -----------------------------------------------------------
  describe('Simulación de Modificación de Estado (PUT + GET)', () => {
    it('debe restar stock correctamente y reflejar el cambio en una consulta posterior', async () => {
      // Creamos un videojuego con stock inicial conocido
      const resPost = await request(app)
        .post('/api/videojuegos')
        .send({
          titulo: 'Elden Ring',
          genero: 'RPG',
          precio: 69.99,
          stock: 20
        });
 
      const idCreado = resPost.body.id;
 
      // Restamos stock
      const resPut = await request(app)
        .put(`/api/videojuegos/${idCreado}/stock`)
        .send({ cantidad: 5 });
 
      expect(resPut.statusCode).toBe(200);
      expect(resPut.body.stock).toBe(15);
 
      // Confirmamos el nuevo estado con un GET independiente
      const resGet = await request(app).get(`/api/videojuegos/${idCreado}`);
 
      expect(resGet.statusCode).toBe(200);
      expect(resGet.body.stock).toBe(15);
    });
 
    it('debe devolver 400 si se intenta restar más stock del disponible', async () => {
      const resPost = await request(app)
        .post('/api/videojuegos')
        .send({
          titulo: 'Hollow Knight',
          genero: 'Metroidvania',
          precio: 14.99,
          stock: 3
        });
 
      const idCreado = resPost.body.id;
 
      const resPut = await request(app)
        .put(`/api/videojuegos/${idCreado}/stock`)
        .send({ cantidad: 10 });
 
      expect(resPut.statusCode).toBe(400);
      expect(resPut.body).toHaveProperty('error');
 
      // El stock original no debe haberse modificado
      const resGet = await request(app).get(`/api/videojuegos/${idCreado}`);
      expect(resGet.body.stock).toBe(3);
    });
  });
 
  // -----------------------------------------------------------
  // 3. Validación de Robustez (Edge Cases)
  // -----------------------------------------------------------
  describe('Validación de Robustez (Edge Cases)', () => {
    it('debe devolver 400 al enviar un POST con datos malformados (faltan campos)', async () => {
      const datosMalformados = {
        titulo: 'Juego incompleto'
        // faltan genero, precio y stock
      };
 
      const res = await request(app)
        .post('/api/videojuegos')
        .send(datosMalformados);
 
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('error');
    });
 
    it('debe devolver 400 al enviar un POST con tipos de datos incorrectos', async () => {
      const datosMalformados = {
        titulo: 'Juego con precio inválido',
        genero: 'Acción',
        precio: 'gratis', // debería ser number
        stock: 5
      };
 
      const res = await request(app)
        .post('/api/videojuegos')
        .send(datosMalformados);
 
      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('error');
    });
  });
 
  // -----------------------------------------------------------
  // Extra: GET /api/videojuegos devuelve la lista completa
  // -----------------------------------------------------------
  it('GET /api/videojuegos debe devolver un array con los videojuegos creados', async () => {
    await request(app)
      .post('/api/videojuegos')
      .send({ titulo: 'Stardew Valley', genero: 'Simulación', precio: 9.99, stock: 50 });
 
    const res = await request(app).get('/api/videojuegos');
 
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThan(0);
  });
});
```

=== Captura de Pantalla / Reporte de Ejecución
#v(1em)
#figure(
  image("../src/fig/ejercicio1/Reporte_eje1.png", width: 80%),
  caption: [Ejecución de Jest/Mocha]
) <fig:gaa>
*(Colocar reporte de ejecución de Jest/Mocha)*
== Interpretación del Reporte de Ejecución (Jest)

El comando `npx jest --verbose` ejecuta la suite de pruebas y muestra el detalle de cada caso individual. A continuación se explica cada sección del resultado obtenido:

=== 1. Estado del archivo de pruebas

```
PASS  ./tema_libre.test.js
```

Indica que el archivo `tema_libre.test.js` se ejecutó y *todos* sus tests pasaron exitosamente. Si algún test hubiera fallado, esta línea mostraría `FAIL` en lugar de `PASS`.

=== 2. Estructura jerárquica (describe / it)

```
API Catálogo de Videojuegos
    √ GET /api/videojuegos debe devolver un array...
    Flujo de Persistencia Cruzada (POST + GET)
      √ debe crear un videojuego con POST...
```

Cada bloque `describe(...)` del código de pruebas se representa como un grupo (título sin símbolo), y cada `it(...)` o `test(...)` aparece como una línea individual con:

- *√* : el caso de prueba pasó correctamente (en caso de fallo se mostraría una *×* con el detalle del error).
- *Texto descriptivo*: corresponde al string pasado como primer argumento de `it(...)`, y debe describir el comportamiento esperado.
- *(N ms)*: tiempo que tardó en ejecutarse ese caso puntual.

En este reporte, los tests están agrupados según los 3 requisitos funcionales evaluados:

+ *Flujo de Persistencia Cruzada (POST + GET)*: valida que un recurso creado pueda recuperarse correctamente, y que un ID inexistente devuelva `404`.
+ *Simulación de Modificación de Estado (PUT + GET)*: valida que el stock se actualice correctamente y que se rechace una resta mayor al stock disponible (`400`).
+ *Validación de Robustez (Edge Cases)*: valida que el sistema rechace payloads malformados o con tipos de datos incorrectos (`400`).

=== 3. Resumen general

```
Test Suites: 1 passed, 1 total
Tests:       7 passed, 7 total
Snapshots:   0 total
Time:        0.715 s, estimated 2 s
```

- *Test Suites*: número de archivos de prueba ejecutados. Aquí solo hay uno (`tema_libre.test.js`), y pasó completo.
- *Tests*: número total de casos individuales (`it`) ejecutados. Los 7 casos definidos pasaron sin errores.
- *Snapshots*: pruebas basadas en comparación de "capturas" de datos previamente guardadas; no se usó esta técnica en este ejercicio, por eso el valor es 0.
- *Time*: tiempo real de ejecución de toda la suite (0.715 s), junto con una estimación previa hecha por Jest antes de correr los tests.

=== Conclusión

El resultado confirma que la API `/api/videojuegos` cumple con los tres requisitos de prueba solicitados: persistencia de datos entre operaciones, modificación correcta del estado interno (stock), y manejo adecuado de errores ante entradas inválidas. Los *7 de 7* tests pasando sin fallos evidencian que la implementación es funcionalmente correcta para los casos evaluados.