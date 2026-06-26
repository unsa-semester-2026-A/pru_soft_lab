= Solución del Cuestionario

== Pregunta de Discusión 01: La Ilusión del 100% de Cobertura de Ramas

*Enunciado:* El Gerente General emite la siguiente directiva: _"A partir de mañana, ningún sistema pasa a producción si no tiene 100% de cobertura de ramas (Branch Coverage). Si llegamos al 100%, garantizamos cero bugs y despedimos a la mitad del equipo de QA para ahorrar costos"_. 
Prepara una defensa técnica y financiera para demostrar que está en un error. Construye un ejemplo sencillo en Python que alcance el 100% de cobertura de ramas pero falle catastróficamente en producción.

*Pistas para la investigación:*
- Diferencia entre _"Functional testedness"_ y _"Structural testedness"_.
- Tipos de errores que la cobertura estructural no detecta (concurrencia, fugas de memoria, requisitos faltantes o incorrectos).

*Respuesta:* \
    En primer lugar, existe una diferencia crítica entre *structural testedness* (cobertura estructural) y *functional testedness* (cobertura funcional). La cobertura de ramas es una métrica puramente estructural; solo indica qué porcentaje de las bifurcaciones del código fuente se ejecutaron durante las pruebas, pero no evalúa si el software cumple correctamente con las especificaciones del negocio o si faltan requisitos por implementar. Como bien señalan Kaner, Bach y Pettichord en su clásico sobre pruebas de software (@kaner2002lessons), medir la cobertura nos dice qué código hemos recorrido, pero no nos dice absolutamente nada sobre la calidad de las pruebas ni sobre los escenarios lógicos que el desarrollador olvidó programar.

    Lograr un 100% de cobertura de ramas no detectará problemas dinámicos ni de entorno, tales como:
    - *Condiciones de carrera y concurrencia,* que son errores que solo ocurren bajo cargas específicas o tiempos de respuesta asíncronos.
    - *Fugas de memoria (Memory Leaks),* código que puede ejecutar todas sus líneas perfectamente en una prueba corta, pero colapsar en producción tras horas acumulando memoria consumida.
    - *Datos no contemplados o errores de tipo,* el flujo pasa por la rama, pero un valor extremo o un tipo de dato inesperado rompe el sistema dinámicamente.

    Financieramente, despedir a la mitad del equipo de QA basándose en esta métrica provocaría un incremento masivo en el costo técnico a mediano plazo. De acuerdo con los extensos estudios empíricos de Barry Boehm sobre la economía de la ingeniería de software (@boehm1981software), el costo de corregir un error de software aumenta de forma exponencial a medida que avanza el ciclo de vida del desarrollo. Un defecto detectado y corregido en producción puede llegar a ser hasta 100 veces más costoso que si se hubiese detectado en las fases tempranas de diseño o pruebas funcionales por un equipo de QA calificado.
    
    *Ejemplo de Código en Python (100% Branch Coverage con fallo catastrófico):*
    ```py
    def calcular_descuento(precio, codigo_cliente):
        """
        Calcula el precio final con descuento según el tipo de cliente.
        Códigos válidos: 'VIP' = 20% descuento, otros = 5% descuento
        """
        if codigo_cliente == "VIP":
            descuento = precio * 0.20
        else:
            descuento = precio * 0.05

        # El código asume que 'precio' siempre será un número. Si debido a un error de 
        # integración en producción (ej. un JSON mal parseado) 'precio' llega como un string,
        # la multiplicación ('precio * 0.05') fallará con un TypeError, deteniendo la app.
        # Además, si 'precio' es negativo, el sistema procesará un descuento absurdo.
        return precio - descuento
    ```

    Creamos un test unitario que cubre todas las ramas:
    ```py
    import pytest
    from descuento import calcular_descuento

    # ============================================================
    # TESTS CON 100% BRANCH COVERAGE
    # (los únicos que el Gerente exige)
    # ============================================================

    def test_cliente_vip():
        """Cubre la rama IF (codigo_cliente == 'VIP')"""
        resultado = calcular_descuento(100, "VIP")
        assert resultado == 80.0

    def test_cliente_normal():
        """Cubre la rama ELSE (cualquier otro codigo)"""
        resultado = calcular_descuento(100, "REGULAR")
        assert resultado == 95.0
    ```
    Siguiendo la lógica del Gerente, este código alcanza el 100% de cobertura de ramas. Sin embargo, en producción el sistema fallará catastróficamente si se invoca como `calcular_descuento("100", "VIP")` lanzando un `TypeError` no controlado que colapsará la pasarela de pagos. Esto demuestra que la cobertura estructural no es sinónimo de ausencia de bugs.

== Pregunta de Discusión 02: Caja Negra vs. Caja Blanca y Desastres Históricos

*Enunciado:* Debatan la afirmación de que: _"Si probamos exhaustivamente todas las entradas y salidas del sistema como usuarios finales (caja negra) y todo funciona perfecto, examinar el código fuente (caja blanca) es una pérdida de tiempo comercial"_. 
Utilicen la analogía de un automóvil o cirugía, e investiguen un desastre histórico de software donde las pruebas de caja blanca habrían prevenido una tragedia que la caja negra no vio.

*Pistas para la investigación:*
- Conceptos de "código muerto" (dead code) y puertas traseras lógicas (logic backdoors).
- Cómo las pruebas de caja blanca detectan vulnerabilidades de seguridad e inyecciones de código que la caja negra no revela fácilmente.

  *Respuesta:* \
    La suposición de que las pruebas de caja negra exhaustivas eliminan la necesidad de las pruebas de caja blanca es un error de visión y seguridad comercial crítico. La analogía automotriz es útil: un vehículo puede responder perfectamente en una pista de pruebas (caja negra: acelera, frena, gira correctamente); pero una inspección de caja blanca (revisión de planos estructurales y soldaduras internas) puede revelar que una línea de líquido de frenos está rozando directamente contra un componente que alcanza altas temperaturas. Por fuera todo se ve “perfecto”, pero el sistema está diseñado para colapsar catastróficamente bajo condiciones de estrés prolongado en el tiempo.

    Como explica Gary McGraw en su obra fundamental sobre seguridad en el desarrollo de software (@mcgraw2006software), las pruebas de caja negra están severamente limitadas porque solo interactúan con la interfaz expuesta. Esto las hace incapaces de detectar riesgos internos críticos como:
    - *Código Muerto (Dead Code):* Fragmentos de código que no se utilizan en la lógica actual pero permanecen en el binario. Este código incrementa la superficie de ataque, ya que puede ser aprovechado por atacantes para ejecutar cargas maliciosas ocultas.
    - *Puertas Traseras Lógicas (Logic Backdoors) e Inyecciones:* Si un desarrollador malicioso introduce una condición oculta (por ejemplo, `if tarjeta == "9999-9999": evadir_pasarela_pago()`), un test de caja negra jamás adivinará esa entrada específica de forma aleatoria. Las pruebas de caja blanca (como el análisis estático y dinámico del código fuente) mapean la estructura lógica interna, identificando flujos ocultos y sanitizaciones deficientes que previenen inyecciones de código antes de llegar a producción.

    Un desastre histórico de gran magnitud que demuestra el peligro de ignorar la caja blanca ocurrió durante la Guerra del Golfo en *1991 con el Sistema de Misiles Patriot en Dhahran*. El sistema de software encargado de rastrear misiles enemigos funcionaba bajo un reloj interno que medía el tiempo en décimas de segundo. Al convertir este valor a un número de punto flotante de 24 bits, se producía un error de redondeo matemático infinitesimal.
    En lenguaje simple, es como si quisieras partir un pastel para tres personas, si divides 1 entre 3, obtienes 0.3333..., y si redondeas a 0.33, al final te faltará un pedazo de pastel. En el caso del Patriot, este error de redondeo acumulado durante horas provocó que el sistema de rastreo perdiera precisión en la ubicación del misil Scud iraquí, resultando en la incapacidad de interceptarlo y causando la muerte de 28 soldados estadounidenses.
    En pruebas de caja negra de corta duración, el sistema funcionaba a la perfección. Sin embargo, tras operar de forma continua durante 100 horas, el error de redondeo acumulado causó un desajuste temporal de 0.34 segundos. Como consecuencia, el sistema falló en interceptar un misil Scud iraquí. El reporte oficial de la oficina de contabilidad del gobierno (@gao1992patriot) demostró que una inspección de caja blanca orientada al análisis estático de registros, precisión de tipos de datos numéricos y acumulación de registros internos habría expuesto inmediatamente el fallo de desbordamiento/redondeo que las pruebas dinámicas externas no pudieron ver.

== Pregunta de Discusión 03: Complejidad Ciclomática Alta y Conservación de la Complejidad

*Enunciado:* Descubren que la función `procesar_ticket_cliente()` tiene una Complejidad Ciclomática de 88. ¿Cómo utilizarían la "Refactorización" y los principios SOLID (como el SRP) para reducirla? Si la dividen en 10 funciones pequeñas, ¿la complejidad del sistema desaparece, se divide o se traslada a las pruebas de integración? Argumenten pros y contras.

*Pistas para la investigación:*
- El principio de Responsabilidad Única (SRP) y su impacto en las pruebas.
- El "Teorema de la Conservación de la Complejidad" en la arquitectura de software.
- Mantenibilidad y costos del código con alta complejidad ciclomática.

  *Respuesta:*
  Una función con una Complejidad Ciclomática (CC) de 88 se encuentra en una zona de riesgo crítico. Según el modelo original de Thomas McCabe (@mccabe1976complexity), un valor superior a 50 indica que el módulo es técnicamente intratable, extremadamente difícil de mantener y matemáticamente propenso a albergar defectos debido a la cantidad de caminos independientes (88 caminos en este caso) que requerirían pruebas unitarias.

    Para resolver el problema de `procesar_ticket_cliente()`, aplicaríamos el *Principio de Responsabilidad Única (SRP)* de SOLID mediante técnicas de refactorización estructural. Siguiendo el catálogo de Martin Fowler (@fowler2018refactoring), la estrategia principal consiste en aplicar *Extract Method* (Extraer Método). En lugar de que una sola función gigante maneje la validación del ticket, la asignación de prioridades, la persistencia en la base de datos, el cálculo de SLAs y el envío de notificaciones por correo, el método original se transforma en una función orquestadora de alto nivel de pocas líneas, delegando cada sub-responsabilidad a 10 funciones o clases satélites independientes con una CC baja (idealmente < 10).

    Al dividir la función en 10 partes más pequeñas, *la complejidad del sistema no desaparece; se traslada y se transforma*. Este fenómeno se alinea con la *Ley de Tesler* o el principio de conservación de la complejidad en la arquitectura de software: existe una cantidad de complejidad intrínseca en cualquier dominio de negocio que no se puede eliminar, solo mover de lugar. Al fragmentar el código, la *complejidad algorítmica interna* (ciclomática) decrece drásticamente, pero se transforma en *complejidad de acoplamiento e integración*, trasladando el esfuerzo principal hacia las pruebas de integración.

    *Pros de la Refactorización:*
    - Las 10 funciones individuales se vuelven radicalmente más legibles y fáciles de modificar sin efectos secundarios inesperados.
    - Diseñar pruebas para funciones pequeñas con baja CC es una tarea directa, permitiendo alcanzar una cobertura aproximada del 100% de forma estable (@fowler2018refactoring).

    *Contras y Traslado del Esfuerzo:*
    - Aunque las 10 funciones pasen individualmente sus pruebas unitarias, el riesgo se desplaza a la interacción entre ellas. Se requiere diseñar pruebas de integración más robustas y mocks complejos para asegurar que el flujo de datos no se rompa en los puntos de unión.
    - Un exceso de subdivisión puede dificultar que un nuevo desarrollador comprenda el flujo de negocio global de un solo vistazo, obligándolo a navegar a través de múltiples abstracciones.

