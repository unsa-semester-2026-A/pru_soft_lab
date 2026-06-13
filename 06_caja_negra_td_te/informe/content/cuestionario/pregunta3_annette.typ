// ==========================================
// CUESTIONARIO - PREGUNTA 3
// Responsable: Annette
// Tema: El impacto de la IA en el Diseño de Pruebas de Caja Negra
// ==========================================

#set par(justify: true, leading: 0.65em, first-line-indent: 1.5em)

== El impacto de la IA en el Diseño de Pruebas de Caja Negra

=== Limitaciones Técnicas, Sesgos y "Alucinaciones" de los LLMs en QA

Al solicitar a un LLM que genere una Tabla de Decisión para reglas de negocio anidadas (por ejemplo, un sistema de préstamos con condiciones condicionales encadenadas), se observan limitaciones claras:

*Alucinaciones lógicas:* Los LLMs son propensos a alucinaciones, creando salidas sintácticamente correctas pero lógicamente defectuosas basadas en suposiciones incorrectas. Además, la capacidad del modelo para generar casos de prueba está limitada por las ventanas de contexto, que pueden no incluir restricciones específicas del sistema u otros parámetros vitales @testomat2026llm.

*No determinismo:* Los LLMs introducen variables aleatorias: alucinaciones que generan escenarios de prueba plausibles pero completamente ficticios, resultados no deterministas donde el mismo prompt produce casos de prueba completamente diferentes, y lógica inconsistente que sigue reglas distintas en cada generación @lambdatest2025llm.

*Problemas específicos con reglas anidadas:* Al enfrentar reglas de negocio complejas con múltiples condiciones encadenadas, se observan discrepancias como: tipos de prueba faltantes (el LLM genera solo un subconjunto de los tipos especificados), pruebas adicionales redundantes (genera variaciones innecesarias del mismo escenario), y alteraciones semánticas que llevan a outputs incorrectos @gruber2024llmsdifferential.

*Sesgo sistemático:* Los datasets de entrenamiento codifican patrones históricos de toma de decisiones; los modelos de IA pueden perpetuar inadvertidamente los puntos ciegos organizacionales existentes, y los escenarios de prueba podrían inconscientemente reflejar prejuicios incorporados @lambdatest2025llm.

=== Discusión: ¿La IA Reemplazará al QA Senior o Será un Asistente?

La evidencia apunta a que la IA será un asistente potente, no un reemplazo:

Hoy y muy probablemente en el futuro, los LLMs seguirán siendo asistentes y facilitadores valiosos, no reemplazos del personal humano. Las responsabilidades de los ingenieros de QA se desplazan hacia la supervisión y el rol de guardianes de calidad, mientras la IA hace la mayor parte del trabajo práctico. Los humanos seguirán a cargo de la toma de decisiones estratégicas, mientras las máquinas manejarán la planificación táctica y la ejecución de pruebas @testomat2026llm.

El argumento central es cognitivo: un QA Senior aplica razonamiento matemático estructurado (selección de particiones de equivalencia, identificación de condiciones de frontera, modelado de estados en sistemas distribuidos), y comprensión del dominio de negocio que el LLM no posee. Los LLMs son esencialmente modelos de caja negra ---casi nunca explican por qué eligieron un input o suposición determinada. Esto crea desafíos para campos altamente regulados como salud y finanzas, que requieren trazas de auditoría @tothenew2025bias.

La IA es excelente para generar la estructura inicial de casos de prueba, expandir escenarios ya definidos por el QA, y acelerar la redacción. Pero falla en detectar condiciones de borde no documentadas, razonar sobre reglas de negocio anidadas sin inconsistencias lógicas, y adaptarse a contextos de sistema crítico donde el error tiene consecuencias graves.
