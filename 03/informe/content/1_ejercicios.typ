#import "../util/util.typ" as util

*Ejercicio 2: Validador de Contraseñas* \

*Fase 1: Especificación (Docstrings)* \
Antes de implementar la lógica, se definió la especificación de la función `validar_contrasena()` utilizando *docstrings*. La especificación describe las reglas de validación, los parámetros de entrada y la estructura del resultado esperado.

*Especificación (Spec):*
#util.codeBlock("../src/lst/ejercicio2/validador_spec.py", lang: "python")

*Fase 2: Diseño (Particiones de Equivalencia y Valores Límite)* \
Se analizaron las reglas de validación para construir clases de equivalencia válidas e inválidas. Se consideraron límites de longitud, ausencia de tipos de caracteres y combinaciones múltiples de errores.

#table(
  columns: (0.45fr, 2.5fr, 1.8fr, 1.3fr),
  stroke: 0.5pt,
  inset: 0.35em,

  [*Id.*], [*Condición / Regla*], [*Valores de Prueba*], [*Resultado Esperado*],

  [TC-01], [Contraseña completamente válida], [`"Segura\#1"`], [Válido (`True`)],

  [TC-02], [Longitud menor a 8 caracteres], [`"Ab1!"`], [Inválido (`False`)],

  [TC-03], [Sin letra mayúscula], [`"segura\#1"`], [Inválido (`False`)],

  [TC-04], [Sin letra minúscula], [`"SEGURA\#1"`], [Inválido (`False`)],

  [TC-05], [Sin dígito numérico], [`"Segura\#\#"`], [Inválido (`False`)],

  [TC-06], [Sin carácter especial], [`"Segura12"`], [Inválido (`False`)],

  [TC-07], [Contraseña vacía], [`""`], [Inválido (`False`)],

  [TC-08], [Exactamente 8 caracteres válidos], [`"aB1!cDe2"`], [Válido (`True`)],

  [TC-09], [Solo letras minúsculas], [`"abcdefghi"`], [Inválido (`False`)],

  [TC-10], [Solo letras mayúsculas], [`"ABCDEFGHI"`], [Inválido (`False`)],

  [TC-11], [Solo números], [`"12345678"`], [Inválido (`False`)],

  [TC-12], [Solo caracteres especiales], [`"!@\#$%\^&*"`], [Inválido (`False`)],

  [TC-13], [Mayúsculas y minúsculas únicamente], [`"AbCdEfGh"`], [Inválido (`False`)],

  [TC-14], [Letras y números sin especial], [`"Segura123"`], [Inválido (`False`)],

  [TC-15], [Números y especial sin letras], [`"1234!@\#$"`], [Inválido (`False`)],

  [TC-16], [Contraseña con espacios], [`"Seg ura\#1"`], [Válido (`True`)],

  [TC-17], [Contraseña con caracteres especiales repetidos], [`"Segura!!!1"`], [Válido (`True`)],

  [TC-18], [Contraseña extremadamente larga válida], [`"MiContrasenaSuperSegura\#123"`], [Válido (`True`)],

  [TC-19], [Uso de caracteres unicode], [`"Contraseña\#1"`], [Válido (`True`)],

  [TC-20], [Símbolo especial no permitido], [`"Segura1?"`], [Inválido (`False`)],

  [TC-21], [Solo espacios], [`"        "`], [Inválido (`False`)],

  [TC-22], [Contraseña con emojis], [`"Clave😀\#1A"`], [Válido (`True`)],

  [TC-23], [Longitud exacta sin mayúscula], [`"abc\#1234"`], [Inválido (`False`)],

  [TC-24], [Longitud exacta sin minúscula], [`"ABC\#1234"`], [Inválido (`False`)],

  [TC-25], [Longitud exacta sin número], [`"Abcdef\#@"`], [Inválido (`False`)],

  [TC-26], [Longitud exacta sin especial], [`"Abcd1234"`], [Inválido (`False`)],

  [TC-27], [Contraseña válida con símbolo ^], [`"Clave\^123A"`], [Válido (`True`)],

  [TC-28], [Contraseña válida con símbolo &], [`"Clave&123A"`], [Válido (`True`)],

  [TC-29], [Contraseña válida con símbolo \*], [`"Clave*123A"`], [Válido (`True`)],

  [TC-30], [Contraseña mínima compleja válida], [`"Aa1!aaaa"`], [Válido (`True`)],
)

*Fase 3: TDD - ROJO (Red)* \
Siguiendo el enfoque *Test-Driven Development*, primero se creó la especificación y posteriormente las pruebas unitarias basadas en las particiones de equivalencia definidas.

Al ejecutar las pruebas inicialmente, estas fallaron debido a que la lógica aún no había sido implementada, obteniendo así el estado esperado de la fase ROJA.

*Especificación inicial:*
#util.codeBlock("../src/lst/ejercicio2/validador_spec.py", lang: "python")

#align(center)[
  #image("../src/img/ejercicio2/red_image.jpg", width: 80%)
  _Figura 9 — Pruebas fallando (Estado ROJO)._
]

*Fase 4: TDD - VERDE (Green)* \
Se implementó la lógica mínima necesaria en `validador.py` para satisfacer todas las reglas de validación y permitir que todas las pruebas unitarias sean superadas correctamente.

*Implementación final:*
#util.codeBlock("../src/lst/ejercicio2/validador.py", lang: "python")

#align(center)[
  #image("../src/img/ejercicio2/gree_image.jpg", width: 80%)
  _Figura 10 — Pruebas exitosas (Estado VERDE)._
]

*Fase 5: Refactor y Validación* \
Finalmente, el código fue revisado y refactorizado para mejorar su legibilidad, organización y mantenibilidad. Se verificó que todos los casos de prueba definidos en la tabla de diseño pasaran correctamente, garantizando así la robustez del validador de contraseñas.

*Pruebas unitarias completas:*
#util.codeBlock("../src/lst/ejercicio2/test_validador.py", lang: "python")