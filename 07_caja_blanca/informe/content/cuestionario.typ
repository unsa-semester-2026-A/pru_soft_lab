= Solución del Cuestionario

*Responsable:* Anette (Anette Gallegos)

*Requisitos:*
- Responder de manera exhaustiva y bien argumentada las tres preguntas de discusión presentadas a continuación.
- Utilizar e incorporar en el texto entre *3 (mínimo)* y *5 (máximo)* citas a las referencias bibliográficas recomendadas (usando la sintaxis de Typst, por ejemplo: `@spillner2021software`, `@myers2012art`, `@iso29119` o `@mccabe1976complexity`).

#v(0.5em)
#block(
  fill: rgb("#ebf5fb"),
  stroke: 1pt + rgb("#aed6f1"),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  [
    #text(weight: "bold", fill: rgb("#21618c"))[Guía de Citas en Typst:] \
    Para citar un libro o artículo del archivo `references.bib` dentro del texto, utiliza la sintaxis `@id_referencia`. Por ejemplo:
    - Para citar a Spillner: `@spillner2021software`
    - Para citar a Myers: `@myers2012art`
    - Para citar la norma ISO 29119: `@iso29119`
    - Para citar a McCabe: `@mccabe1976complexity`
  ]
)
#v(0.5em)

== Pregunta de Discusión 01: La Ilusión del 100% de Cobertura de Ramas

*Enunciado:* El Gerente General emite la siguiente directiva: _"A partir de mañana, ningún sistema pasa a producción si no tiene 100% de cobertura de ramas (Branch Coverage). Si llegamos al 100%, garantizamos cero bugs y despedimos a la mitad del equipo de QA para ahorrar costos"_. 
Prepara una defensa técnica y financiera para demostrar que está en un error. Construye un ejemplo sencillo en Python que alcance el 100% de cobertura de ramas pero falle catastróficamente en producción.

*Pistas para la investigación:*
- Diferencia entre _"Functional testedness"_ y _"Structural testedness"_.
- Tipos de errores que la cobertura estructural no detecta (concurrencia, fugas de memoria, requisitos faltantes o incorrectos).

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Respuesta de Anette:* \
    [Escribe aquí tu análisis detallado...]
    
    *Ejemplo de Código en Python (100% Branch Coverage con fallo catastrófico):*
    ```py
    # Escribe el código aquí
    ```
  ]
)

== Pregunta de Discusión 02: Caja Negra vs. Caja Blanca y Desastres Históricos

*Enunciado:* Debatan la afirmación de que: _"Si probamos exhaustivamente todas las entradas y salidas del sistema como usuarios finales (caja negra) y todo funciona perfecto, examinar el código fuente (caja blanca) es una pérdida de tiempo comercial"_. 
Utilicen la analogía de un automóvil o cirugía, e investiguen un desastre histórico de software donde las pruebas de caja blanca habrían prevenido una tragedia que la caja negra no vio.

*Pistas para la investigación:*
- Conceptos de "código muerto" (dead code) y puertas traseras lógicas (logic backdoors).
- Cómo las pruebas de caja blanca detectan vulnerabilidades de seguridad e inyecciones de código que la caja negra no revela fácilmente.

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Respuesta de Anette:* \
    [Escribe aquí tu análisis detallado...]
  ]
)

== Pregunta de Discusión 03: Complejidad Ciclomática Alta y Conservación de la Complejidad

*Enunciado:* Descubren que la función `procesar_ticket_cliente()` tiene una Complejidad Ciclomática de 88. ¿Cómo utilizarían la "Refactorización" y los principios SOLID (como el SRP) para reducirla? Si la dividen en 10 funciones pequeñas, ¿la complejidad del sistema desaparece, se divide o se traslada a las pruebas de integración? Argumenten pros y contras.

*Pistas para la investigación:*
- El principio de Responsabilidad Única (SRP) y su impacto en las pruebas.
- El "Teorema de la Conservación de la Complejidad" en la arquitectura de software.
- Mantenibilidad y costos del código con alta complejidad ciclomática.

#block(
  stroke: 0.5pt + rgb("#bdc3c7"),
  inset: 15pt,
  fill: rgb("#fcfcfc"),
  width: 100%,
  [
    *Respuesta de Anette:* \
    [Escribe aquí tu análisis detallado...]
  ]
)
