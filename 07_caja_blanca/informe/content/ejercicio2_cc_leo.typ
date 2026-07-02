= Flujo del proceso: FinanceService.register_transaction

El flujo de `FinanceService.register_transaction` describe el proceso que se sigue para registrar una transacción financiera en una cuenta, asegurando validaciones, clasificación del tipo de operación y actualización del saldo.

#figure(
  image("../src/img/leonardo/Diagrama_Flujo.jpeg", width: 80%),
  caption: [Diagrama de Flujo]
) <fig:gaa>
== 1. Obtención de la cuenta

En primer lugar, el sistema obtiene la cuenta a partir del identificador proporcionado mediante una consulta al repositorio. Este paso es fundamental porque todas las operaciones posteriores dependen de la existencia de una cuenta válida.

== 2. Validación de existencia de cuenta

Luego se realiza una validación para comprobar si la cuenta existe.  
Si la cuenta no se encuentra, el sistema interrumpe la ejecución y lanza una excepción del tipo `ValueError` con el mensaje "Account not found".  
Esto evita que se realicen operaciones sobre datos inexistentes o inválidos.

== 3. Interpretación del tipo de transacción

Si la cuenta existe, el proceso continúa con la interpretación del tipo de transacción.  
En esta etapa se utiliza una función interna para convertir el tipo de transacción recibido en un formato estándar, clasificándolo normalmente como ingreso (`INCOME`) o gasto (`EXPENSE`).

== 4. Creación del objeto Transaction

Después de esto, se crea un objeto `Transaction` que representa la operación financiera.  
Este objeto almacena la información relevante de la transacción, como la cuenta asociada, el monto y el tipo de operación.

== 5. Flujo según tipo de transacción

=== 5.1 Transacción de ingreso (INCOME)

Si la transacción es de tipo ingreso:
- Se registra el ingreso
- Se actualiza el saldo de la cuenta sumando el monto correspondiente
- Se guarda la transacción en la base de datos
- Se retorna la transacción junto con el valor `false`, indicando que no existe exceso de presupuesto

=== 5.2 Transacción de gasto (EXPENSE)

Si la transacción es de tipo gasto:
- Se registra el gasto
- Se actualiza el saldo de la cuenta restando el monto
- Se guarda la transacción en la base de datos
- Se evalúa si el gasto supera el presupuesto establecido
- Se retorna la transacción junto con un valor booleano que indica si se excedió el presupuesto