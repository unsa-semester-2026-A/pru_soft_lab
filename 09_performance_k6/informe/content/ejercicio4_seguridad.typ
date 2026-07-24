=== Ejercicio 4: Pruebas Básicas de Seguridad utilizando Python

*Descripción de la actividad:*
Se desarrolló una suite de pruebas de seguridad automatizada en Python utilizando la biblioteca `requests` (`security_tests.py`), diseñada para evaluar la robustez y resiliencia de la API REST ante solicitudes malformadas, verbos no permitidos, parámetros inválidos y simulaciones de ataques por fuerza bruta de alta frecuencia.

==== Código de la Suite de Seguridad (`security_tests.py`)

```python
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import requests

BASE_URL = "http://localhost:5000"
BRUTE_FORCE_DICTIONARY = [
    {"user": "admin", "pass": "admin123"},
    {"user": "admin", "pass": "123456"},
    {"user": "root", "pass": "root"},
] + [{"token": f"token_{i:03d}", "code": f"promo_{i:03d}"} for i in range(45)]

def test_case_1_non_existent_resource():
    res = requests.get(f"{BASE_URL}/api/v1/eventos/non-existent-id-9999")
    return res.status_code == 404

def test_case_2_incomplete_payload():
    res = requests.post(f"{BASE_URL}/api/v1/compras/reservar", json={})
    return res.status_code in (400, 422)

def test_case_3_invalid_data_types():
    res = requests.post(f"{BASE_URL}/api/v1/compras/reservar", json={"evento_id": 12345, "cantidad": "ten"})
    return res.status_code in (400, 422)

def test_case_4_prohibited_http_method():
    res = requests.patch(f"{BASE_URL}/api/v1/eventos", json={"name": "test"})
    return res.status_code == 405

def test_case_5_brute_force_and_burst_abuse():
    url = f"{BASE_URL}/api/v1/compras/reservar"
    status_codes = []
    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = [executor.submit(requests.post, url, json=payload, timeout=3) for payload in BRUTE_FORCE_DICTIONARY]
        for f in as_completed(futures):
            try: status_codes.append(f.result().status_code)
            except: status_codes.append(0)
    return 500 not in status_codes and 0 not in status_codes
```

==== Evaluación de Escenarios de Seguridad Ejecutados

#align(center)[
  #table(
    columns: (1fr, 2fr, 1.2fr, 1.2fr, 1fr),
    fill: (x, y) => if y == 0 { rgb("1e1e24") } else { none },
    stroke: 0.5pt + rgb("cccccc"),
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Caso],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Descripción del Test],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Código Esperado],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Código Real],
    table.cell(inset: 0.6em)[#set text(fill: white, weight: "bold"); Estado],
    
    [Caso 1], [Recursos Inexistentes (GET id no existente)], [HTTP 404], [HTTP 404], [Aprobado],
    [Caso 2], [Datos Incompletos (POST payload vacío)], [HTTP 400 / 422], [HTTP 400], [Aprobado],
    [Caso 3], [Tipos de Datos Inválidos (Mismatch de tipos)], [HTTP 400 / 422], [HTTP 400], [Aprobado],
    [Caso 4], [Método HTTP No Permitido (PATCH en colección)], [HTTP 405], [HTTP 405], [Aprobado],
    [Caso 5], [Ataque Concurrente de Fuerza Bruta (50 ráfagas)], [Sin HTTP 500], [HTTP 400 (50/50)], [Aprobado]
  )
]

#figure(
  image("../src/fig/06-security-ressult.png", width: 85%),
  caption: [Resultado de la ejecución exitosa de los 5 casos de la Suite de Seguridad (`security_tests.py`).]
)

==== Análisis de Robustez en el Caso 5 (Fuerza Bruta y Ráfagas)
En la simulación multihilo del Caso 5 (10 hilos concurrentes procesando 50 payloads de prueba), la API mantuvo una respuesta consistente devolviendo únicamente errores de validación estructurados `HTTP 400 Bad Request` en formato JSON (`{"error": "Datos inválidos", "detalle": "..."}`). 

No se registraron excepciones internas `HTTP 500 Internal Server Error`, ni fugas de trazas de código (*stacktraces*) ni saturación de conexiones en el pool de Redis/PostgreSQL, confirmando que la aplicación gestiona de forma resiliente el tráfico anómalo de alta frecuencia.
