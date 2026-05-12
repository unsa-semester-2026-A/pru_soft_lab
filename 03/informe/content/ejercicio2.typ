== Ejercicio 2: Validador de Contraseñas

=== Fase 1: Especificación (Docstrings)

El primer paso consistió en definir la interfaz de la función `validar_contrasena`, especificando claramente sus parámetros, su valor de retorno y el dominio de los mismos, sin incluir aún la lógica de validación.

El siguiente código muestra la especificación inicial:

#import "../util/util.typ": codeBlock
#figure(
  caption: "Especificación de la función validar_contrasena (fase 1)",
  codeBlock("../src/lst/exe2/fase1/validador_specification.py", lang: "python")
)

=== Fase 2: Casos de Prueba (Rojo)

Con la especificación definida, diseñamos los casos de prueba utilizando particiones de equivalencia. Se evaluó tanto el estado general de validez como la lista detallada de errores esperados para cada regla incumplida. La siguiente tabla resume los principales escenarios de prueba:

#table(
  columns: (auto, auto, auto, auto),
  align: horizon,
  table.header(
    [Id.], [Descripción], [Entrada], [Errores Esperados]
  ),
  [TC-01], [Contraseña completamente válida], ["Segura\#1"], [Ninguno (Lista vacía)],
  [TC-02], [Longitud menor a 8 caracteres], ["Ab1!"], [Falta longitud],
  [TC-03], [Sin letra mayúscula], ["segura\#1"], [Falta mayúscula],
  [TC-04], [Sin letra minúscula], ["SEGURA\#1"], [Falta minúscula],
  [TC-05], [Sin dígito numérico], ["Segura\#\#"], [Falta número],
  [TC-06], [Sin carácter especial], ["Segura12"], [Falta carácter especial],
  [TC-07], [Contraseña vacía], [""], [Falla en todas las 5 reglas],
  [TC-08], [Exactamente 8 caracteres válidos], ["aB1!cDe2"], [Ninguno (Lista vacía)],
  [TC-09], [Solo letras minúsculas], ["abcdefghi"], [Falta mayúscula, número y especial],
  [TC-10], [Falta número y especial], ["SuperSegura"], [Falta número y especial],
  [TC-11], [Contraseña válida con espacios], ["Seg ura\#1"], [Ninguno (Lista vacía)],
  [TC-12], [Símbolo especial no permitido (?)], ["Segura1?"], [Falta carácter especial],
)

A continuación, implementamos las pruebas unitarias siguiendo el patrón AAA. Al ejecutar las pruebas con la función aún vacía, todas fallaron, confirmando el estado "Rojo" inicial del desarrollo.

#figure(
  caption: "Pruebas unitarias de validador_contrasena (fase 2)",
  codeBlock("../src/lst/exe2/fase2/test_validador.py", lang: "python")
)

#figure(
  image("../src/img/exe2/fase2_rojo.png", width: 90%),
  caption: "Ejecución de pruebas unitarias - Fase Rojo",
)

=== Fase 3: Implementación (Verde)

Finalmente, procedimos a implementar la lógica interna de validación dentro de la función `validar_contrasena` para satisfacer cada una de las reglas estipuladas.

#figure(
  caption: "Implementación de validar_contrasena (fase 3)",
  codeBlock("../src/lst/exe2/fase3/validador.py", lang: "python")
)

Tras completar la implementación, volvimos a ejecutar la suite de pruebas comprobando que todos los casos pasan exitosamente (estado "Verde").

#figure(
  image("../src/img/exe2/fase3_verde.png", width: 90%),
  caption: "Ejecución de pruebas unitarias - Fase Verde",
)
