// ==========================================
// EJERCICIO 1: PRUEBAS BÁSICAS DE PARABANK
// Responsable: Leo
// Técnicas: Partición de Equivalencia (PE) y Análisis de Valor Límite (AVL)
// ==========================================


= Pruebas Básicas de ParaBank (PE y AVL)

La aplicación ParaBank es un simulador de banca en línea que permite realizar operaciones como registro de usuarios, inicio de sesión, transferencia de fondos y solicitud de préstamos. Para verificar su correcto funcionamiento se aplicaron técnicas de pruebas de caja negra basadas en especificación, específicamente Partición de Equivalencia y Análisis de Valor Límite.

== Partición de Equivalencia (PE)

La técnica de Partición de Equivalencia consiste en dividir los datos de entrada en grupos o clases que se espera tengan un comportamiento similar. De cada clase se selecciona uno o más valores representativos para reducir la cantidad de pruebas necesarias sin disminuir la cobertura.

=== Funcionalidad 1: Inicio de Sesión

==== Clases de Equivalencia Identificadas

#table(
	columns: 4,
	[Campo], [Clase], [Tipo], [Descripción],

	[Usuario], [PE-LOGIN-01], [Válida], [Usuario registrado en el sistema],
	[Usuario], [PE-LOGIN-02], [Inválida], [Usuario inexistente],
	[Usuario], [PE-LOGIN-03], [Inválida], [Campo vacío],

	[Contraseña], [PE-LOGIN-04], [Válida], [Contraseña correcta],
	[Contraseña], [PE-LOGIN-05], [Inválida], [Contraseña incorrecta],
	[Contraseña], [PE-LOGIN-06], [Inválida], [Campo vacío]
)

==== Casos de Prueba Derivados

#table(
	columns: 5,
	[Caso], [Entrada], [Clase], [Resultado Esperado], [Estado],

	[PE-01], [Usuario válido + contraseña válida], [Válida], [Acceso exitoso], [Aprobado],
	[PE-02], [Usuario inválido], [Inválida], [Mensaje de error], [Aprobado],
	[PE-03], [Contraseña incorrecta], [Inválida], [Mensaje de error], [Aprobado],
	[PE-04], [Usuario vacío], [Inválida], [Mensaje de validación], [Aprobado],
	[PE-05], [Contraseña vacía], [Inválida], [Mensaje de validación], [Aprobado]
)

=== Funcionalidad 2: Registro de Usuario

==== Clases de Equivalencia Identificadas

#table(
	columns: 4,
	[Campo], [Clase], [Tipo], [Descripción],

	[Username], [PE-REG-01], [Válida], [Usuario nuevo],
	[Username], [PE-REG-02], [Inválida], [Usuario existente],
	[Username], [PE-REG-03], [Inválida], [Campo vacío],

	[Password], [PE-REG-04], [Válida], [Contraseñas coinciden y usuario distinto],
	[Password], [PE-REG-05], [Inválida], [Contraseñas diferentes],
	[Password], [PE-REG-06], [Inválida], [Campo vacío]
)

==== Casos de Prueba Derivados

#table(
	columns: 5,
	[Caso], [Entrada], [Clase], [Resultado Esperado], [Estado],

	[PE-06], [Usuario nuevo + contraseñas coinciden], [Válida], [Registro exitoso], [Aprobado],
	[PE-07], [Usuario ya registrado], [Inválida], [Error de registro], [Aprobado],
	[PE-08], [Username vacío], [Inválida], [Error de validación], [Aprobado],
	[PE-09], [Contraseñas coinciden con usuario distinto], [Válida], [Registro exitoso], [Aprobado],
	[PE-10], [Contraseñas diferentes], [Inválida], [Error de validación], [Aprobado],
	[PE-11], [Contraseña vacía], [Inválida], [Error de validación], [Aprobado]
)

== Análisis de Valor Límite (AVL)

La técnica de Análisis de Valor Límite se enfoca en probar los valores cercanos a los límites de entrada, ya que es donde suelen encontrarse defectos de software.

=== Funcionalidad: Transferencia de Fondos

==== Límites Identificados

Se utilizó el saldo disponible de la cuenta como referencia para definir los valores límite, considerando el mínimo de la cuenta como 500 y el caso de transferencia total cuando el monto equivale al saldo actual.

#table(
	columns: 3,
	[Tipo de Límite], [Valor], [Descripción],

	[Inferior inválido], [499], [Valor justo debajo del mínimo permitido],
	[Mínimo válido], [500], [Valor mínimo aceptado],
	[Máximo válido], [Saldo disponible], [Transferencia de todos los fondos]
)

==== Casos de Prueba Derivados

#table(
	columns: 5,
	[Caso], [Valor Probado], [Tipo], [Resultado Esperado], [Estado],

	[AVL-01], [499], [Inferior inválido], [Error de validación], [Aprobado],
	[AVL-02], [500], [Mínimo válido], [Transferencia exitosa], [Aprobado],
	[AVL-03], [Saldo disponible], [Máximo válido], [Transferencia de todos los fondos], [Aprobado]
)

== Evidencias de Ejecución (PE y AVL)

=== Evidencias de Partición de Equivalencia

#figure(
	image("../../src/img/fixed/leonardo/figure1.jpg", width: 80%),
	caption: [PE-01: Inicio de sesión con credenciales válidas]
)

#figure(
	image("../../src/img/fixed/leonardo/figure2.jpg", width: 80%),
	caption: [PE-02: Intento de acceso con usuario inválido]
)

#figure(
	image("../../src/img/fixed/leonardo/figure3.jpg", width: 80%),
	caption: [PE-03: Intento de acceso con contraseña incorrecta]
)

#figure(
	image("../../src/img/fixed/leonardo/figure4.jpg", width: 80%),
	caption: [PE-04: Validación de usuario vacío]
)

#figure(
	image("../../src/img/fixed/leonardo/figure5.jpg", width: 80%),
	caption: [PE-05: Validación de contraseña vacía]
)

=== Evidencias de Análisis de Valor Límite

#figure(
	image("../../src/img/fixed/leonardo/figure6.jpg", width: 80%),
	caption: [AVL-01: Transferencia con 499 (justo debajo del mínimo)]
)

#figure(
	image("../../src/img/fixed/leonardo/figure7.jpg", width: 80%),
	caption: [AVL-02: Transferencia con 500 (mínimo permitido)]
)

#figure(
	image("../../src/img/fixed/leonardo/figure8.jpg", width: 80%),
	caption: [AVL-03: Transferencia del saldo total disponible]
)

== Resumen de Resultados

#table(
	columns: 4,
	[Técnica], [Casos Ejecutados], [Casos Exitosos], [Cobertura],

	[Partición de Equivalencia], [11], [11], [100%],
	[Análisis de Valor Límite], [3], [3], [100%],
	[Total], [14], [14], [100%]
)


- La técnica de Partición de Equivalencia permitió reducir la cantidad de pruebas necesarias agrupando entradas con comportamientos similares.
- El Análisis de Valor Límite permitió validar el comportamiento del sistema en los extremos de los rangos de entrada.
- Todas las pruebas ejecutadas produjeron los resultados esperados según las especificaciones funcionales de ParaBank.
- Las funcionalidades evaluadas mostraron un comportamiento consistente frente a entradas válidas e inválidas.
- La cobertura obtenida fue satisfactoria para las técnicas aplicadas en este laboratorio.

